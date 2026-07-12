

-- init
local mainFont
local W_width, W_height

function love.load()

    love.window.setTitle("Numoquencer")
    mainFont = love.graphics.newFont("fonts/VG5000-Regular.otf",20)
    sigilfont = love.graphics.newFont("fonts/goetic/NIGOA___.TTF",300)
    W_width, W_height = love.window.getMode()

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
    love.graphics.printf(n, self_x - 20, self_y - 10, 40, "center")

    -- Marqueur qui tourne selon Rotable[n]
    love.graphics.push()
    love.graphics.translate(self_x, self_y)
    love.graphics.rotate(rot)
    love.graphics.translate(20,0)
    love.graphics.circle("fill", 0, 0, 10, 3) -- triangle tourné autour du centre
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(self_x, self_y)
    --love.graphics.rectangle("line", -25, -25, 50, 50)
    love.graphics.pop()
end

-- contructions 
function numogram()

    for _, n in ipairs({3,6,2,7,5,4,1,8,9,0}) do
        knob(n)
    end


                                                            -- linking lines (make. it a funtion between 2 numbers or make currents 
                                                            -- needs paths to 3 and 6 and 9 0 

    love.graphics.push()
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(
        0.7*(W_width / 2), 0.6  *(W_height / 2),
        0.3*(W_width / 2), 0.75 *(W_height / 2),
        0.8*(W_width / 2), 0.75 *(W_height / 2)
    )
    love.graphics.line(
        0.3*(W_width / 2), 0.75 *(W_height / 2),
        0.5*(W_width / 2), 1    *(W_height / 2),
        0.2*(W_width / 2), 0.9  *(W_height / 2)
    )
    love.graphics.line(
        0.5*(W_width / 2), 1 *(W_height / 2),
        0.8*(W_width / 2), 0.75    *(W_height / 2),
        0.5*(W_width / 2), 1.2  *(W_height / 2)
    )


    
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()

end

function menusquaares()
    
    local mrgn = 10 

    love.graphics.rectangle("line", mrgn, mrgn, -2*mrgn+W_width/2, W_height-mrgn*2)
    love.graphics.rectangle("line", W_width/2, mrgn, -mrgn+W_width/2, W_height-mrgn*2)

end

function daemon()

    local mrgn = 10 
    love.graphics.rectangle("line", 1*mrgn+W_width/2, 2*mrgn, -3*mrgn+W_width/2, W_height/2-mrgn*3)
    
    
    love.graphics.setFont(sigilfont)
    love.graphics.printf(")", 4*mrgn + 20, -30, 1000, "center")




end

function params()

    local mrgn = 10 
    love.graphics.rectangle("line", 1*mrgn+W_width/2, mrgn+W_height/2, -3*mrgn+W_width/2, W_height/2-mrgn*3)


end

-- main loop 

function love.draw()  

    numogram()
    menusquaares()
    daemon()
    params()

end

