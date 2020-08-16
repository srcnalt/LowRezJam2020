local Map = {}
Map.__index = Map

local currentAnim = {}

function Map.new()
    local mapForward = lg.newImage('graphics/map/64x64Scene.png')
    local animForward = anim.new(mapForward, 64, 64, 0)

    local mapLeft = lg.newImage('graphics/map/Road2Left.png')
    local animLeft = anim.new(mapLeft, 64, 64, 0)
    
    local mapRight = lg.newImage('graphics/map/Road2Right.png')
    local animRight = anim.new(mapRight, 64, 64, 0)

    input:bind('up', 'move_forward')
    input:bind('down', 'move_backwards')

    input:bind('w', 'move_forward')
    input:bind('s', 'move_backwards')

    currentAnim = animForward

    return setmetatable({
        anim = {
            forward = animForward,
            left    = animLeft,
            right   = animRight
        },
        time = 0,
        moving = MovementStates.stop
    }, Map)
end

function Map:update(dt)
    if input:down('move_forward') then 
        self.moving = MovementStates.forward
        globalPos = globalPos + dt / 2
        RoadSwitch(self)
    elseif input:released('move_forward') then
        self.moving = MovementStates.stop
    end

    if input:down('move_backwards') then 
        self.moving = MovementStates.backwards
        globalPos = globalPos - dt / 2
        RoadSwitchBack(self)
    elseif input:released('move_backwards') then
        self.moving = MovementStates.stop
    end
    
    currentAnim:update(dt)
end

function Map:draw()
    if self.moving == MovementStates.forward then
        currentAnim.speed = 0.1
    elseif self.moving == MovementStates.backwards then
        currentAnim.speed = -0.1
    else
        currentAnim.speed = 0
    end

    currentAnim:draw()
end

function RoadSwitch(self)
    if currentAnim == self.anim.forward and self.anim.forward.pos == #self.anim.forward.frames then
        if math.random (4) == 4 then
            currentAnim = self.anim.left
        elseif math.random (4) == 3 then
            currentAnim = self.anim.right
        end
        currentAnim:reset()
    elseif currentAnim == self.anim.left and self.anim.left.pos == #self.anim.left.frames then
        currentAnim = self.anim.forward
        currentAnim:reset()
    elseif currentAnim == self.anim.right and self.anim.right.pos == #self.anim.right.frames then
        currentAnim = self.anim.forward
        currentAnim:reset()
    end
end

function RoadSwitchBack(self)
    if currentAnim == self.anim.left and self.anim.left.pos == 1 then
        currentAnim = self.anim.forward
        currentAnim:reset()
    elseif currentAnim == self.anim.right and self.anim.right.pos == 1 then
        currentAnim = self.anim.forward
        currentAnim:reset()
    end
end

return setmetatable({}, {__call = function(_, ...) return Map.new(...) end})
