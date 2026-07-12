local ffi = require("ffi")
ffi.cdef[[
    typedef struct DspFaust DspFaust;
    DspFaust* dsp_new(int sr, int bs);
    bool dsp_start(DspFaust* d);
    void dsp_set_param(DspFaust* d, const char* address, float value);
    const char* dsp_get_json_ui(DspFaust* d);
    void dsp_stop(DspFaust* d);
    void dsp_delete(DspFaust* d);
]]

print("1: loading lib...") io.flush()
local lib = ffi.load("./libmydsp.dylib")

print("2: lib loaded, creating dsp...") io.flush()
local dsp = lib.dsp_new(44100, 512)

print("3: dsp created, pointer =", dsp) io.flush()

print("4: calling start()...") io.flush()
local ok = lib.dsp_start(dsp)

print("5: start() returned", ok) io.flush()

print("6: getting json ui...") io.flush()
local json = lib.dsp_get_json_ui(dsp)

print("7: got json ptr, converting to string...") io.flush()
print(ffi.string(json))

print("8: setting param...") io.flush()
lib.dsp_set_param(dsp, "vol", 0.3)

print("9: done, sleeping...") io.flush()
os.execute("sleep 2")

lib.dsp_stop(dsp)
print("10: stopped.") io.flush()