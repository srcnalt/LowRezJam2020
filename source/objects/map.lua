local Map = {}
Map.__index = Map

local moving = MovementStates.stop

function Map.new()
    local mapStraight = lg.newImage('graphics/map/64x64Scene.png')
    local animMapStraight = anim.new(mapStraight, 64, 64, 0)

    input:bind('up', 'move_forward')
    input:bind('down', 'move_backwards')

    return setmetatable({
        anim = animMapStraight,
        moving = moving
    }, Map)
end

function Map:update(dt)
    if input:down('move_forward') then 
        moving = MovementStates.forward
        globalPos = globalPos + dt / 2
    elseif input:released('move_forward') then
        moving = MovementStates.stop
    end

    if input:down('move_backwards') then 
        moving = MovementStates.backwards
        globalPos = globalPos - dt / 2
    elseif input:released('move_backwards') then
        moving = MovementStates.stop
    end
    
    self.anim:update(dt)
end

function Map:draw()
    if moving == MovementStates.forward then
        self.anim.speed = 0.1
    elseif moving == MovementStates.backwards then
        self.anim.speed = -0.1
    else
        self.anim.speed = 0
    end

    self.anim:draw()
end

return setmetatable({}, {__call = function(_, ...) return Map.new(...) end})
