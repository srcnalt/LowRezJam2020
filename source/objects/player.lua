local Player = {}
Player.__index = Player

function Player.new()
    local player = lg.newImage('graphics/player/sword-shield.png')

    input:bind('up', 'player_move_forward')

    return setmetatable({
        img = player,
        moving = false,
        x = 0,
        y = 0,
        speed = 0
    }, Player)
end

function Player:update(dt)
    if input:down('player_move_forward') then
        self.moving = true
        self.speed = 8
    elseif  input:released('player_move_forward') then
        self.moving = false
        self.speed = 1 
    end
    
    self.y = self.y + dt * self.speed
end

function Player:draw()
    lg.draw(self.img, 0, math.sin(self.y) + 1)
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})
