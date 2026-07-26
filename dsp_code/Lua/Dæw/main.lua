-- init
local mainFont, sigilfont, asciiFont
local W_width, W_height

-- Parameter Names Matrix (16 names per menu, 1-indexed for Lua)
local paramNames = {
    [0] = {"p_1", "p_2", "p_3", "p_4", "p_5", "p_6", "p_7", "p_8", "p_9", "p_10", "p_11", "p_12", "p_13", "p_14", "p_15", "p_16"},
    [1] = {"Vol_A", "Vol_B", "Pan_A", "Pan_B", "Mute1", "Mute2", "Gain", "Trim", "Send1", "Send2", "Phase", "Width", "Filt", "Freq", "Reso", "Out"},
}

-- Fill defaults ONLY for missing parameter names across all menus (0 to 9)
for m = 0, 9 do
    paramNames[m] = paramNames[m] or {}
    for p = 1, 16 do
        paramNames[m][p] = paramNames[m][p] or string.format("p_%d", p)
    end
end

-- Helper: Convert 0.0 - 1.0 float to ASCII slider representation
local function getSliderASCII(val, isEditing)
    if isEditing then
        return string.format("[=%.2f=]", val)
    end

    local sliders = {
        [0] = "|=====]",
        [1] = "[|====]",
        [2] = "[=|===]",
        [3] = "[==|==]",
        [4] = "[===|=]",
        [5] = "[====|]",
        [6] = "[=====|"
    }

    local idx = math.floor(val * 6 + 0.5)
    idx = math.max(0, math.min(6, idx))
    return sliders[idx]
end

function love.load()
    love.window.setTitle("Numoquencer")
    
    -- Load fonts safely with fallback
    pcall(function()
        mainFont = love.graphics.newFont("fonts/VG5000-Regular.otf", 20)
        asciiFont = love.graphics.newFont("fonts/jgs_Font.ttf", 20)
    end)
    
    mainFont = mainFont or love.graphics.newFont(20)
    asciiFont = asciiFont or love.graphics.newFont(20)

    -- Safety check for sigilfont
    pcall(function()
        sigilfont = love.graphics.newFont("fonts/goetic/NIGOA___.TTF", 300)
    end)

    love.window.setMode(1024, 600, {fullscreen = false, resizable = true})
    W_width, W_height = love.graphics.getDimensions()
end

function love.resize(w, h)
    W_width, W_height = w, h
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
    local self_x, self_y, rot = knobposang(n)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", self_x, self_y, 25, 100)
    love.graphics.setFont(mainFont)
    love.graphics.printf(tostring(n), self_x - 20, self_y - 10, 40, "center")

    -- Marqueur qui tourne selon Rotable[n]
    love.graphics.push()
    love.graphics.translate(self_x, self_y)
    love.graphics.rotate(rot)
    love.graphics.translate(20, 0)
    love.graphics.circle("fill", 0, 0, 10, 3)
    love.graphics.pop()
end

-- constructions 
function numogram()
    for _, n in pairs({3,6,2,7,5,4,1,8,9,0}) do
        knob(n)
    end

    love.graphics.push()
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(
        0.7*(W_width / 2), 0.6*(W_height / 2),
        0.3*(W_width / 2), 0.75*(W_height / 2),
        0.8*(W_width / 2), 0.75*(W_height / 2)
    )
    love.graphics.line(
        0.3*(W_width / 2), 0.75*(W_height / 2),
        0.5*(W_width / 2), 1*(W_height / 2),
        0.2*(W_width / 2), 0.9*(W_height / 2)
    )
    love.graphics.line(
        0.5*(W_width / 2), 1*(W_height / 2),
        0.8*(W_width / 2), 0.75*(W_height / 2),
        0.5*(W_width / 2), 1.2*(W_height / 2)
    )
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

function menusquaares()
    local mrgn = 10 
    love.graphics.rectangle("line", mrgn, mrgn, -2*mrgn+W_width/2, W_height-mrgn*2)
    love.graphics.rectangle("line", W_width/2, mrgn, -mrgn+W_width/2, W_height-mrgn*2)
    love.graphics.rectangle("line", 1*mrgn+W_width/2, mrgn+W_height/2, -3*mrgn+W_width/2, W_height/2-mrgn*3)
end

function daemon()
    local mrgn = 10 
    love.graphics.rectangle("line", 1*mrgn+W_width/2, 2*mrgn, -3*mrgn+W_width/2, W_height/2-mrgn*2)
    if sigilfont then
        love.graphics.setFont(sigilfont)
        love.graphics.printf(")", 5+W_width/4, -20, 1000, "center")
    end
end

local menunames = { 
    [0] = "Time",
    [1] = "SubMix",
    [2] = "iFx i",
    [3] = "sFx i",
    [4] = "iFx ii",
    [5] = "Resampler",
    [6] = "SFx ii",
    [7] = "Sampler",
    [8] = "Drm Engine",
    [9] = "Sequencers"
}

local pl = {}
for n = 0, 9 do
    pl[n] = {}
    for i = 0, 15 do
        pl[n][i] = 0.1 * ((i % 6) + 1)
    end
end

local menun = 0
local menulvl = 0
local sel = 0             -- 0 = pick menu, 1 = pick param, 2 = edit value

-- Tap timing management
local tapCount = 0
local tapTimer = 0
local doubleTapThreshold = 0.22 -- Adjust window sensitivity (in seconds)

function love.update(dt)
    if tapCount > 0 then
        tapTimer = tapTimer + dt

        -- DOUBLE TAP detected within window -> Move BACK 1 step
        if tapCount >= 2 then
            sel = math.max(0, sel - 1)
            tapCount = 0
            tapTimer = 0

        -- SINGLE TAP confirmed (timer ran out) -> Move FORWARD 1 step
        elseif tapTimer >= doubleTapThreshold then
            sel = math.min(2, sel + 1)
            tapCount = 0
            tapTimer = 0
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()

    elseif key == "kp=" or key == "return" or key == "space" then
        tapCount = tapCount + 1

    elseif key == "up" then
        if sel == 0 then
            menun = (menun + 1) % 10
        elseif sel == 1 then
            menulvl = (menulvl + 1) % 16
        else
            pl[menun][menulvl] = math.min(1, pl[menun][menulvl] + 0.05)
        end

    elseif key == "down" then
        if sel == 0 then
            menun = (menun - 1 + 10) % 10
        elseif sel == 1 then
            menulvl = (menulvl - 1 + 16) % 16
        else
            pl[menun][menulvl] = math.max(0, pl[menun][menulvl] - 0.05)
        end
    end
end

function synthpanel()
    local margin = 10
    
    local Selectsquare = (sel == 0) and 0 or 1

    love.graphics.setFont(mainFont)
    love.graphics.setColor(1, Selectsquare, Selectsquare)
    love.graphics.rectangle("fill", 2*margin, 2*margin, 4*margin, 4*margin)
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(tostring(menun), 3.2*margin, 2.5*margin, 4*margin, "left")

    -- Syzygy calculation
    local syzergy = string.format("%d:%d", menun, 9 - menun)
    love.graphics.printf(syzergy, 2.5*margin, 6*margin, 4*margin, "left")
    
    local whiteColor = {1, 1, 1}
    local redColor   = {1, 0.2, 0.2}

    -- Frame Top
    local window = {
        whiteColor, "<>---------------------------<>\n"
    }

    -- Render 4 rows of 4 parameters each
    for row = 0, 3 do
        local startIdx = row * 4

        -- Row 1: Parameter Names
        table.insert(window, whiteColor)
        table.insert(window, "  ")
        for c = 0, 3 do
            local idx = startIdx + c
            local pName = paramNames[menun][idx + 1] or string.format("p_%d", idx + 1)
            local itemColor = (idx == menulvl) and redColor or whiteColor

            table.insert(window, itemColor)
            table.insert(window, string.format(" %-6s", pName:sub(1, 6)))
        end
        table.insert(window, whiteColor)
        table.insert(window, "\n")

        -- Row 2: ASCII Sliders
        table.insert(window, whiteColor)
        table.insert(window, "|")
        for c = 0, 3 do
            local idx = startIdx + c
            local val = pl[menun][idx]
            local isEditing = (idx == menulvl and sel == 2)
            local sliderStr = getSliderASCII(val, isEditing)
            local itemColor = (idx == menulvl) and redColor or whiteColor

            table.insert(window, itemColor)
            table.insert(window, string.format("%-7s", sliderStr))
        end
        table.insert(window, whiteColor)
        table.insert(window, "|\n")
    end

    -- Frame Bottom
    table.insert(window, whiteColor)
    table.insert(window, "<>---------------------------<>\n")

    -- Title using main font
    love.graphics.setFont(mainFont)
    love.graphics.printf(menunames[menun] .. " [Sel: " .. sel .. "]", 7*margin, 2.5*margin, 20*margin, "left")
    
    -- --- ASCII MATRIX DISPLAY (SCALED) ---
    local asciiScale = 1.3 -- 1.0 = 100%, 1.3 = 130%, 1.5 = 150%
    local targetWidth = (W_width / 2 - 8 * margin) / asciiScale
    local targetX = (7 * margin) / asciiScale
    local targetY = (W_height / 2 - 90) / asciiScale

    love.graphics.push()
    love.graphics.scale(asciiScale, asciiScale)
    love.graphics.setFont(asciiFont)
    love.graphics.printf(window, targetX, targetY, targetWidth, "center")
    love.graphics.pop()
end

-- main loop 
function love.draw()  
    -- numogram()
    daemon()
    menusquaares()
    synthpanel()
end