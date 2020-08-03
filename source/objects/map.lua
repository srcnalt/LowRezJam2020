local Map = {}
Map.__index = Map

local moving = false

function Map.new()
    local mapForward = lg.newImage('graphics/map/64x64Scene.png')
    local animMapForward = anim.new(mapForward, 64, 64, 0)

    input:bind('up', 'move_forward')

    return setmetatable({
        anim = animMapForward,
        moving = moving
    }, Map)
end

function Map:update(dt)
    if input:down('move_forward') then 
        moving = true
    elseif input:released('move_forward') then
        moving = false
    end
    
    self.anim:update(dt)
end

function Map:draw()
    if moving then
        self.anim.speed = 0.1
    else
        self.anim.speed = 0
    end

    self.anim:draw()
end

return setmetatable({}, {__call = function(_, ...) return Map.new(...) end})
