#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Auto-source emsdk environment if available and not already set
if [ -z "${EMSDK:-}" ] && [ -f "${HOME}/emsdk/emsdk_env.sh" ]; then
    source "${HOME}/emsdk/emsdk_env.sh" 2>/dev/null
fi

# --- CONFIGURATION ---
OUTPUT_DIR="./build"
NATIVE_OUT_NAME="faust_bridge"
WASM_OUT_NAME="game"

# Color formatting for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# --- BUILD FUNCTIONS ---

build_native() {
    log_info "Detecting host OS..."
    OS="$(uname -s)"
    
    case "$OS" in
        Linux)
            if grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
                log_info "Targeting Raspberry Pi (Linux)..."
            else
                log_info "Targeting Desktop Linux..."
            fi
            
            log_info "Compiling native shared library (.so)..."
            g++ -O3 -shared -fPIC \
                dsp-faust/bridge.cpp \
                dsp-faust/DspFaust.cpp \
                -Idsp-faust \
                -o "${OUTPUT_DIR}/${NATIVE_OUT_NAME}.so" \
                -lpthread -lasound
            ;;
            
        Darwin)
            log_info "Targeting macOS..."
            
            # Detect Homebrew prefix for Apple Silicon vs Intel
            if [ -d "/opt/homebrew" ]; then
                BREW_PREFIX="/opt/homebrew"
            elif [ -d "/usr/local/Homebrew" ] || [ -d "/usr/local/include" ]; then
                BREW_PREFIX="/usr/local"
            else
                log_warn "Homebrew not found at /opt/homebrew or /usr/local."
                log_warn "Falling back to default include/lib paths."
                BREW_PREFIX=""
            fi
            
            if [ -n "$BREW_PREFIX" ]; then
                log_info "Homebrew prefix: ${BREW_PREFIX}"
                BREW_INCLUDE="-I${BREW_PREFIX}/include"
                BREW_LIBS="-L${BREW_PREFIX}/lib"
            else
                BREW_INCLUDE=""
                BREW_LIBS=""
            fi
            
            log_info "Compiling native dynamic library (.dylib)..."
            c++ -std=c++11 -fPIC -shared \
                dsp-faust/bridge.cpp \
                dsp-faust/DspFaust.cpp \
                -Idsp-faust \
                ${BREW_INCLUDE} \
                ${BREW_LIBS} \
                -o "${OUTPUT_DIR}/${NATIVE_OUT_NAME}.dylib" \
                -framework CoreAudio \
                -framework CoreFoundation \
                -framework AudioToolbox \
                -framework CoreMIDI \
                -lportaudio
            ;;
            
        *)
            log_error "Unsupported native OS: $OS"
            log_warn "If you are on Windows, run this script inside Git Bash / MSYS2 using MinGW."
            exit 1
            ;;
    esac
    
    log_success "Native library built successfully at: ${OUTPUT_DIR}/${NATIVE_OUT_NAME}.${OS_LIB_EXT}"
}

build_wasm() {
    log_info "Checking for Emscripten compiler (emcc)..."
    if ! command -v emcc &> /dev/null; then
        log_error "Emscripten ('emcc') could not be found. Please source your emsdk environment."
        log_error "Run: source /path/to/emsdk/emsdk_env.sh"
        exit 1
    fi

    log_info "Compiling WebAssembly module for Nekoweb..."

    # Create a temporary copy of DspFaust.cpp with audio driver disabled
    # (PORTAUDIO_DRIVER triggers native-only PortAudio code)
    DSPFAUST_WEB="${OUTPUT_DIR}/DspFaust_web.cpp"
    sed '1s/#define PORTAUDIO_DRIVER 1/\/\/ #define PORTAUDIO_DRIVER 1 (disabled for wasm)/' \
        dsp-faust/DspFaust.cpp > "${DSPFAUST_WEB}"

    # Define functions to preserve so LuaJIT's FFI can link to them at runtime
    EXPORTED_FUNCS="['_dsp_new','_dsp_start','_dsp_stop','_dsp_set_param','_dsp_get_param','_dsp_get_json_ui','_dsp_delete','_malloc','_free']"

    emcc -O3 \
        dsp-faust/bridge.cpp \
        "${DSPFAUST_WEB}" \
        -Idsp-faust \
        -s EXPORTED_FUNCTIONS="${EXPORTED_FUNCS}" \
        -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
        -s ALLOW_MEMORY_GROWTH=1 \
        -o "${OUTPUT_DIR}/${WASM_OUT_NAME}.js"

    log_success "Wasm web assets built at: ${OUTPUT_DIR}/"
    log_info "Files: ${WASM_OUT_NAME}.js & ${WASM_OUT_NAME}.wasm"

    # Auto-deploy to nekoweb/
    log_info "Deploying to nekoweb/..."
    mkdir -p nekoweb
    cp "${OUTPUT_DIR}/${WASM_OUT_NAME}.js" "nekoweb/${WASM_OUT_NAME}.js"
    cp "${OUTPUT_DIR}/${WASM_OUT_NAME}.wasm" "nekoweb/${WASM_OUT_NAME}.wasm"
    log_success "nekoweb/ ready — deploy the folder to your Nekoweb host."
}

print_usage() {
    echo "Usage: $0 [native | web | all]"
    echo "  native : Compiles the native shared library for your current OS (.so / .dylib)"
    echo "  web    : Compiles the Wasm/JS module using Emscripten for Nekoweb"
    echo "  all    : Compiles both targets sequentially"
}

# --- MAIN EXECUTION ROUTINE ---

if [ $# -eq 0 ]; then
    print_usage
    exit 1
fi

case "$1" in
    native)
        build_native
        ;;
    web)
        build_wasm
        ;;
    all)
        build_native
        build_wasm
        ;;
    *)
        log_error "Invalid argument: $1"
        print_usage
        exit 1
        ;;
esac
