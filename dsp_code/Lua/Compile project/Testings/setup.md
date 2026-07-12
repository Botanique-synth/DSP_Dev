lua interface 

--------


faust dsp 
    faust2api -portaudio -midi Nvol.dsp
    adding bridge.cpp

    g++ -std=c++11 -fPIC -shared \
    bridge.cpp DspFaust.cpp \
    -I. \
    -I/opt/homebrew/include \
    -L/opt/homebrew/lib \
    -o libmydsp.dylib \
    -framework CoreAudio -framework CoreFoundation -framework AudioToolbox -framework CoreMIDI \
    -lportaudio

--------
luajit test.lua
--------

local ffi = require("ffi")
ffi.cdef[[
    typedef struct DspFaust DspFaust;
    DspFaust* dsp_new(int sr, int bs);
    bool dsp_start(DspFaust* d);
    void dsp_stop(DspFaust* d);
    void dsp_set_param(DspFaust* d, const char* address, float value);
    float dsp_get_param(DspFaust* d, const char* address);
    const char* dsp_get_json_ui(DspFaust* d);
    void dsp_delete(DspFaust* d);
]]

local lib = ffi.load("mydsp") -- looks for libmydsp.dylib next to your .lua/.love, or on the lib path

local dsp = lib.dsp_new(44100, 512)
lib.dsp_start(dsp)

-- sanity check: print the real parameter address(es)
print(ffi.string(lib.dsp_get_json_ui(dsp)))


--------


brew install love 
brew install faust 
brew install portaudio 


==== to get scopes 

Regenerate with faust2api -dummy Nvol.dsp → gives you a compute()-callable class, no driver
Bridge exposes dsp_compute(int n, float* out) wrapping compute()
Lua: love.audio.newQueueableSource(44100, 16, 2), call dsp_compute each frame/timer tick, push samples into the queueable source and keep the last N samples for the scope


===
compile for web 
===

Step A: The Emscripten Compilation Command

When invoking emcc via your love.js build chain, you must pass your bridge.cpp and export your specific function names inside the EXPORTED_FUNCTIONS array. Note that Emscripten expects an underscore prefix (_) for C functions in this flag:
Bash

emcc -O3 \
  bridge.cpp \
  DspFaust.cpp \
  [YOUR_LOVE_JS_SOURCE_OBJECTS].o \
  -s EXPORTED_FUNCTIONS="['_dsp_new','_dsp_start','_dsp_stop','_dsp_set_param','_dsp_get_param','_dsp_get_json_ui','_dsp_delete','_main']" \
  -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
  -s USE_SDL=2 \
  -s WEBAUDIO=1 \
  -o my_game.js

Step B: The Audio Flag Gotcha

Because DspFaust manages its own audio loop internally, when targeting WebAssembly it relies heavily on browser Web Audio contexts. Ensure that your Emscripten linker flags include -s WEBAUDIO=1 or -s AUDIO=1 so the underlying Faust architecture file can resolve browser-audio bindings smoothly.
Step C: Deploying to Nekoweb

Once Emscripten finishes outputting your my_game.js and my_game.wasm, pack them along with your game's .love file into your Nekoweb directory structure.

    Tip: If the audio fails to initialize on Nekoweb due to strict browser context requirements, remember to handle user interaction (like a "Click to Start" screen) inside your love.load(), as browsers universally block Faust audio nodes from firing up before a human click.

==

    Web (Nekoweb) ✅ — build + déploiement local fonctionnel, le son sort, le knob Lua-style répond à la molette/drag/clavier.
    
    Prochaines étapes dispo :
    - ./Build.sh native → compilation du .dylib pour LÖVE desktop
    - love . → test FFI LuaJIT + CoreAudio
    - Push des assets nekoweb/ sur Nekoweb
    
    Tu veux attaquer l'une de ces étapes ou c'était juste une vérification son ?