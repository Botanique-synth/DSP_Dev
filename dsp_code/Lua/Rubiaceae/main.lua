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

-- Fallback safe si la lib n'est pas là pour les tests
local lib
local dsp
pcall(function() 
    lib = ffi.load("./build/faust_bridge.dylib")
end)

-- Paramètres globaux
local mainFont
local W_width, W_height = 400, 400
local knobsel = 1

-- Thème de couleur officiel "Rubiaceae"
local clr_thm = {
    bg1       = {0.05, 0.06, 0.05},
    bg2       = {0.12, 0.14, 0.12},
    bg3       = {0.25, 0.30, 0.25},
    clr1      = {0.46, 0.79, 0.54}, 
    clr2      = {0.23, 0.395, 0.27},
    light     = {0.95, 0.98, 0.95},
    midlight  = {0.65, 0.70, 0.65},
    accent    = {0.23, 0.395, 0.27}
}

-- Vos paramètres d'usine
local Params = {1, 0.5, 0.5, 0.5, 0.5, 0.2, 0.1, 0.2, 0.3, 0.2, 200, 4, 0.5}

-- Table de configuration de l'UI
local UI_Layout = {
    { type = "sknob",   x = 50,  y = 50,  param_idx = 4,  label = "BPM",  min = 0,   max = 100 },
    { type = "sknob",   x = 150, y = 50,  param_idx = 1,  label = "Seq",  min = 0,   max = 1 },
    { type = "sknob",   x = 50,  y = 150, param_idx = 2,  label = "Trg",  min = 0,   max = 1 },
    { type = "sknob",   x = 350, y = 50,  param_idx = 3,  label = "Shp",  min = 0,   max = 1 },
    { type = "sknob",   x = 350, y = 150, param_idx = 9,  label = "Dec",  min = 0,   max = 1 },
    
    { type = "hslider", x = 200, y = 150, param_idx = 11, label = "Freq", min = 10,  max = 800 },
    
    { type = "sknob",   x = 150, y = 250, param_idx = 12, label = "Noh",  min = 1,   max = 32 },
    { type = "sknob",   x = 250, y = 250, param_idx = 10, label = "Hsp",  min = 0,   max = 1 },
    { type = "sknob",   x = 350, y = 250, param_idx = 13, label = "Odd",  min = 0,   max = 1 },

    { type = "sknob",   x = 50,  y = 350, param_idx = 5,  label = "Dur",  min = 0,   max = 1 },
    { type = "sknob",   x = 150, y = 350, param_idx = 6,  label = "Fbk",  min = 0,   max = 1 },
    { type = "sknob",   x = 250, y = 350, param_idx = 7,  label = "Dsp",  min = 0,   max = 1 },
    { type = "sknob",   x = 350, y = 350, param_idx = 8,  label = "Wet",  min = 0,   max = 1 }
}

function love.load()
    love.window.setTitle("🌱 Rubiaceae Synthesizer")
    pcall(function() mainFont = love.graphics.newFont("VG5000-Regular.otf", 14) end)
    if not mainFont then mainFont = love.graphics.newFont(14) end

    love.window.setMode(W_width, W_height)

    if lib then
        dsp = lib.dsp_new(44100, 512)
        lib.dsp_start(dsp)
    end
end

local function is_hovered(cx, cy, w, h)
    local px, py = love.mouse.getPosition()
    return px > cx - w/2 and px < cx + w/2 and py > cy - h/2 and py < cy + h/2
end

function love.update(dt)
    if not lib or not dsp then return end

    lib.dsp_set_param(dsp, "/Ambient_machine/decoders/note_seq",    Params[1])
    lib.dsp_set_param(dsp, "/Ambient_machine/decoders/trig_%",      Params[2])
    lib.dsp_set_param(dsp, "/Ambient_machine/decoders/Exite_shape", Params[3])
    lib.dsp_set_param(dsp, "/Ambient_machine/decoders/bpm",         Params[4])

    lib.dsp_set_param(dsp, "/Ambient_machine/echo/Duration",        Params[5])
    lib.dsp_set_param(dsp, "/Ambient_machine/echo/Feedback",        Params[6])
    lib.dsp_set_param(dsp, "/Ambient_machine/echo/disp",            Params[7])
    lib.dsp_set_param(dsp, "/Ambient_machine/echo/wet",             Params[8])                    

    lib.dsp_set_param(dsp, "/Ambient_machine/rez/Decay",            Params[9])
    lib.dsp_set_param(dsp, "/Ambient_machine/rez/Hsprd",            Params[10])
    lib.dsp_set_param(dsp, "/Ambient_machine/rez/freq",             Params[11])
    lib.dsp_set_param(dsp, "/Ambient_machine/rez/n.o.h",            Params[12])
    lib.dsp_set_param(dsp, "/Ambient_machine/rez/oddlvl",           Params[13])
end

function love.draw()
    love.graphics.clear(clr_thm.bg1)
    
    for i, cfg in ipairs(UI_Layout) do
        local is_selected = (i == knobsel)
        local val = (Params[cfg.param_idx] - cfg.min) / (cfg.max - cfg.min)
        
        -- Si sélectionné, on injecte une valeur de modulation factice (0.8) pour la jauge clr2
        local val2 = is_selected and 0.8 or 0.0

        if cfg.type == "sknob" then
            knob(cfg.x, cfg.y, val, val2, cfg.label, is_selected)
        elseif cfg.type == "hslider" then
            hslider(cfg.x, cfg.y, val, val2, cfg.label, is_selected)
        end
    end
end

local function alter_param(idx, dir)
    local cfg
    for _, item in ipairs(UI_Layout) do
        if item.param_idx == idx then cfg = item break end
    end
    if not cfg then return end

    -- Calcule le pas selon l'échelle globale du paramètre
    local step = (cfg.max - cfg.min) * 0.05
    if idx == 12 then step = 1 end -- Pas discrets pour n.o.h

    Params[idx] = math.max(cfg.min, math.min(cfg.max, Params[idx] + (dir * step)))
end

function love.keypressed(key)
    local current_param_idx = UI_Layout[knobsel].param_idx

    if key == "up" then
        alter_param(current_param_idx, 1)
    elseif key == "down" then
        alter_param(current_param_idx, -1)
    elseif key == "left" then
        knobsel = knobsel - 1
        if knobsel < 1 then knobsel = #UI_Layout end
    elseif key == "right" then
        knobsel = knobsel + 1
        if knobsel > #UI_Layout then knobsel = 1 end
    end
end

function love.wheelmoved(x, y)
    for i, cfg in ipairs(UI_Layout) do
        local width = cfg.type == "hslider" and 200 or 100
        local height = 100
        if is_hovered(cfg.x, cfg.y, width, height) then
            knobsel = i
            alter_param(cfg.param_idx, y)
            break
        end
    end
end


function knob(x, y, val, val2, state, is_selected)
    local self_x, self_y = x, y
    
    local function test(cx, cy)
        local px, py = love.mouse.getPosition()
        if px > cx - 35 and px < cx + 35 and py > cy - 35 and py < cy + 35 then
            return 0
        else
            return 1
        end
    end

    local function arcs(val, val2)
        local start_ang = -math.pi * 1.25 
        local end_angle = math.pi * 0.25
        local pos_angle = math.pi * ((-(6/4) + (val * 1.5)) + 1/4)
        local mod_angle = math.pi * ((-(6/4) + (0 * 1.5)) + 1/4)
        
        local carc1  = clr_thm["bg3"]
        local carc2  = clr_thm["clr1"]
        local carc3  = clr_thm["clr2"]
        local cbgarc = clr_thm["bg2"]

        love.graphics.setColor(carc1)
        love.graphics.arc("fill", x, y, 30, start_ang, end_angle, 900) 
        love.graphics.setColor(carc2)
        love.graphics.arc("fill", x, y, 30, start_ang, pos_angle, 900) 
        
        if is_selected then
            love.graphics.setColor(carc3)
            love.graphics.arc("fill", x, y, 30, start_ang, mod_angle, 900)   
        end
        
        love.graphics.setColor(cbgarc)
        love.graphics.arc("fill", x, y, 27, -3.14 * 1.25, 3.14 * .25)
    end

    local function knobdot(val, state)
        love.graphics.setColor(clr_thm["light"])
        local rot = -math.pi * ((val * 3/2) + (1/4))
        local dist = 28
        local cx, cy = x + dist * math.sin(rot), y + dist * math.cos(rot)
        
        love.graphics.circle("fill", cx, cy, 5)
        love.graphics.setColor(clr_thm["bg3"])
        love.graphics.circle("fill", x, y, 20)
    end

    love.graphics.setColor(clr_thm["bg2"])
    love.graphics.rectangle("fill", x-50, y-50, 100, 100, 10, 10)

    -- Contour d'accent de sélection
    if is_selected then
        love.graphics.setColor(clr_thm["clr1"])
        love.graphics.rectangle("line", x-50, y-50, 100, 100, 10, 10)
    end

    arcs(val, val2)
    love.graphics.setColor(clr_thm["midlight"])
    knobdot(val, test(x, y))

    love.graphics.setColor(clr_thm["midlight"])
    love.graphics.setFont(mainFont)
    love.graphics.printf(state, self_x - 40, self_y + 20, 80, "center")
end

function hslider(x, y, val, val2, state, is_selected)
    local self_x, self_y = x, y
    
    local function test(cx, cy)
        local px, py = love.mouse.getPosition()
        if px > cx - 35 and px < cx + 35 and py > cy - 35 and py < cy + 35 then
            return 0
        else
            return 1
        end
    end

    local function lines(val, val2)
        local carc1  = clr_thm["bg3"]
        local carc2  = clr_thm["clr1"]
        local carc3  = clr_thm["clr2"]

        love.graphics.setColor(carc1)
        love.graphics.rectangle("fill", x-75, y-1.5, 150, 3) 
        love.graphics.setColor(carc2)
        love.graphics.rectangle("fill", x-75, y-7, (150 * val) + 10, 14, 5, 5)
        
        if is_selected then
            love.graphics.setColor(carc3)
            love.graphics.rectangle("fill", x-75, y-7, 150 * 0, 14, 5, 5)   
        end
    end

    local function dot(val, state)
        love.graphics.setColor(clr_thm["light"])
        local cx, cy = x + 140 * val - 70, y -- Ajusté pour rester centré sur la piste de 140px
        love.graphics.circle("fill", cx, cy, 5)
    end

    love.graphics.setColor(clr_thm["bg2"])
    love.graphics.rectangle("fill", x-100, y-50, 200, 100, 10, 10)

    if is_selected then
        love.graphics.setColor(clr_thm["clr1"])
        love.graphics.rectangle("line", x-100, y-50, 200, 100, 10, 10)
    end

    lines(val, val2)
    love.graphics.setColor(clr_thm["midlight"])
    dot(val, test(x, y))

    love.graphics.setColor(clr_thm["midlight"])
    love.graphics.setFont(mainFont)
    love.graphics.printf(state, self_x - 80, self_y - 40, 160, "center")
end