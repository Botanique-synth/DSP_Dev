-- making ui elements !
-- check figma file (need to move to drawio)

local mainFont
local W_width, W_height

function love.load()
    love.window.setTitle("UImaker")
    mainFont = love.graphics.newFont("VG5000-Regular.otf", 15)
    W_width, W_height = love.window.getMode()
end

local clr_thm = {
    bg1      = {0.0,0.0,0.0},
    bg2     = {0.09,0.09,0.09},
    bg3     = {0.24,0.24,0.24},

    clr1     = {0.4666,0.4941,0.7960},
    clr2     = {0.2784,0.3176,0.6078},

    light   = {1,1,1},
    midlight   = {0.7,0.7,0.7},

    
}


local knobval = 1 -- usually 0-1
local knobval2 = 1 -- usually 0-1
local knobsel = 0 -- knob select 
Params = {1,.5,.5,.5,.5,.2,.1,.2,.3,.2,200,4,.5}

local clr_thm = {
    bg1      = {0.0,0.0,0.0},
    bg2     = {0.09,0.09,0.09},
    bg3     = {0.24,0.24,0.24},

    clr1     = {0.4666,0.4941,0.7960},
    clr2     = {0.2784,0.3176,0.6078},

    light   = {1,1,1},
    midlight   = {0.7,0.7,0.7},

    
}
function knob(x,y,val,val2,state)

    local self_x, self_y = x,y
    function test(cx, cy)
        local px, py = love.mouse.getPosition()
        if px > cx - 35 and px < cx + 35
        and py > cy - 35 and py < cy + 35 then
            return 0

        else
            return 1
        end
    end
        
    --100x100px

    max     = .5
    light   = 0.6
    clr     = 0.4

    function arcs(val,val2)
        local start_ang,end_angle,pos_angle,mod_angle = -math.pi*1.25 , math.pi*0.25, math.pi*((-(6/4)+(val*1.5))+1/4), math.pi*((-(6/4)+(val2*1.5))+1/4)
        
        carc1  = clr_thm["bg3"]
        carc2  = clr_thm["clr1"]
        carc3  = clr_thm["clr2"]
        cbgarc = clr_thm["bg2"]

        love.graphics.setColor(carc1)
        love.graphics.arc(  "fill", x, y, 30,start_ang,end_angle ,900) 
        love.graphics.setColor(carc2)
        love.graphics.arc(  "fill", x, y, 30,start_ang,pos_angle ,900) 
        love.graphics.setColor(carc3)
        love.graphics.arc(  "fill", x, y, 30,start_ang,mod_angle ,900)   
        love.graphics.setColor(cbgarc)
        love.graphics.arc(  "fill", x, y, 27, -3.14*1.25,  3.14*.25)
    
    end

    function knobdot(val,state)

        love.graphics.setColor(clr_thm["light"])

        rot = -math.pi*((val*3/2)+(1/4))
        dist = 28
        local cx,cy = x + dist*math.sin(rot), y+dist*math.cos(rot)
        
        love.graphics.circle( "fill", cx, cy, 5 )
        love.graphics.setColor(clr_thm["bg3"])
        love.graphics.circle( "fill", x, y, 20 )

    end


    love.graphics.setColor(clr_thm["bg2"])
    love.graphics.rectangle( "fill", x-50, y-50, 100, 100, 10, 10)

    arcs(val,val2)
    love.graphics.setColor(clr_thm["midlight"])
    knobdot(val,test(x,y))

    love.graphics.setColor(clr_thm["midlight"])

    love.graphics.setFont(mainFont)
    love.graphics.printf("val", self_x - 20, self_y + 20, 40, "center")


end

function hslider(x,y,val,val2,state)

    local self_x, self_y = x,y
    function test(cx, cy)
        local px, py = love.mouse.getPosition()
        if px > cx - 35 and px < cx + 35
        and py > cy - 35 and py < cy + 35 then
            return 0

        else
            return 1
        end
    end
        
    --200x100px

    max     = .5
    light   = 0.6
    clr     = 0.4

    function lines(val,val2)
        local start_ang,end_angle,pos_angle,mod_angle = -math.pi*1.25 , math.pi*0.25, math.pi*((-(6/4)+(val*1.5))+1/4), math.pi*((-(6/4)+(val2*1.5))+1/4)
        
        carc1  = clr_thm["bg3"]
        carc2  = clr_thm["clr1"]
        carc3  = clr_thm["clr2"]
        cbgarc = clr_thm["bg2"]

        love.graphics.setColor(carc1)
        love.graphics.rectangle( "fill", x-75, y-1.5, 150, 3) 
        love.graphics.setColor(carc2)
        love.graphics.rectangle( "fill", x-75, y-7, (150*val)+10, 14,5,5)
        love.graphics.setColor(carc3)
        love.graphics.rectangle( "fill", x-75, y-7, 150*val2, 14,5,5)   
        --love.graphics.setColor(cbgarc)
        --love.graphics.arc(  "fill", x, y, 27, -3.14*1.25,  3.14*.25)
    
    end

    function dot(val,state)

        love.graphics.setColor(clr_thm["light"])

        local cx,cy = x+150*val-75, y
        
        love.graphics.circle( "fill", cx, cy, 5 )
    end


    love.graphics.setColor(clr_thm["bg2"])
    love.graphics.rectangle( "fill", x-100, y-50, 200, 100, 10, 10)

    lines(val,val2)
    love.graphics.setColor(clr_thm["midlight"])
    dot(val,test(x,y))

    love.graphics.setColor(clr_thm["midlight"])

    love.graphics.setFont(mainFont)
    love.graphics.printf("val", self_x - 80, self_y - 40, 40, "center")


end


-- main loop
function love.draw()
    knob(W_width/2, 3*W_height/4,knobval,knobval2)
    hslider(W_width/2, W_height/2,knobval,knobval2)


    local mx, my = love.mouse.getPosition()
    love.graphics.printf(mx, mx + 20, my + 20 + 30, 40, "center")
    love.graphics.printf(my, mx + 20, my + 40 + 30, 40, "center")
end

function love.keypressed(key)
     
    if key == "up" then
        knobval = math.min(1, knobval + 0.1)
    elseif key == "down" then
        knobval = math.max(0, knobval - 0.1)
    elseif key == "right" then
        knobval2 = math.min(1, knobval2 + 0.1)
    elseif key == "left" then
        knobval2 = math.max(0, knobval2 - 0.1)
    end

end