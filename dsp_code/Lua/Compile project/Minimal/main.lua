local ffi = require("ffi")
ffi.cdef[[
    typedef struct DspFaust DspFaust;
    DspFaust* dsp_new(int sr, int bs);
    bool dsp_start(DspFaust* d);
    void dsp_set_param(DspFaust* d, const char* address, float value);
    float dsp_get_param(DspFaust* d, const char* address);
    const char* dsp_get_json_ui(DspFaust* d);
    void dsp_stop(DspFaust* d);
    void dsp_delete(DspFaust* d);
]]

local lib = ffi.load("./build/faust_bridge.dylib")
local dsp

-- init
local mainFont
local W_width, W_height
local knobval = 0 -- max 1

function love.load()
    love.window.setTitle("1Knob")
    mainFont = love.graphics.newFont("VG5000-Regular.otf", 20)
    W_width, W_height = love.window.getMode()

    dsp = lib.dsp_new(44100, 512)
    lib.dsp_start(dsp)
end

-- bits and bobs
function knobposang(n)
    local knobPosAng = {
        [3] = {0.4, 0.3},
        [6] = {0.6, 0.3},
        [2] = {0.7, 0.6},
        [7] = {0.8, 0.75},
        [5] = {0.3, 0.75},
        [4] = {0.2, 0.9},
        [1] = {0.5, 1.0},
        [8] = {0.5, 1.2},
        [9] = {0.5, 1.5},
        [0] = {0.5, 1.7},
    }
    local Rotable = {
        [0] = math.rad(-90),
        [1] = math.rad(90),
        [2] = math.rad(50),
        [3] = math.rad(360),
        [4] = math.rad(-50),
        [5] = math.rad(135),
        [6] = math.rad(180),
        [7] = math.rad(-130),
        [8] = math.rad(-90),
        [9] = math.rad(90),
    }
    local max_x, max_y = W_width / 2, W_height / 2
    local pos = knobPosAng[n]
    if not pos then
        error("knobpos: pas de position définie pour n = " .. tostring(n))
    end
    return max_x * pos[1], max_y * pos[2], Rotable[n]
end

function knob(n)
    local self_x, self_y = W_width/2, W_height/2
    local rot = knobval * math.rad(270) - math.rad(135) -- maps 0-1 to a -135..135 deg sweep

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", self_x, self_y, 25, 100)
    love.graphics.setFont(mainFont)
    love.graphics.printf(n, self_x - 20, self_y - 10, 40, "center")

    love.graphics.push()
    love.graphics.translate(self_x, self_y)
    love.graphics.rotate(rot)
    love.graphics.translate(20, 0)
    love.graphics.circle("fill", 0, 0, 10, 3)
    love.graphics.pop()
end

-- main loop
function love.draw()
    knob(1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("vol: %.2f", knobval), 10, 10)
end

function love.wheelmoved(x, y)
    knobval = math.max(0, math.min(1, knobval + y * 0.02))
end

function love.keypressed(key)
    if key == "up" then
        knobval = math.min(1, knobval + 0.1)
    elseif key == "down" then
        knobval = math.max(0, knobval - 0.1)
    end
end

function love.update(dt)
    lib.dsp_set_param(dsp, "/Nvol/vol", knobval)
end



function love.quit()
    lib.dsp_stop(dsp)
    lib.dsp_delete(dsp)
end