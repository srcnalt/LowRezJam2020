local Player = {}
Player.__index = Player

function Player.new()
    local idleImg = lg.newImage('graphics/player/sword-shield.png')
    local swordImg = lg.newImage('graphics/player/sword-up.png')
    local shieldImg = lg.newImage('graphics/player/shield-up.png')

    input:bind('up', 'player_move_forward')
    input:bind('down', 'player_move_backwards')
    input:bind('left', 'player_attack')
    input:bind('right', 'player_defend')

    return setmetatable({
        img = {
            idle = idleImg,
            sword = swordImg,
            shield = shieldImg
        },
        fight = {
            time = 0,
            cooldown = 0.5,
            active = false
        },
        moving = false,
        x = 0,
        y = 0,
        speed = 0,
        health = 100,
        state = PlayerState.idle
    }, Player)
end

function Player:update(dt)
    HandleInput(self)

    if self.state == PlayerState.idle then
        self.y = self.y + dt * self.speed
    elseif self.state == PlayerState.attack then
        self.fight.time = self.fight.time + dt

        if self.fight.time > self.fight.cooldown then
            self.state = PlayerState.idle
            self.fight.time = 0
            self.fight.active = false
        end
    elseif self.state == PlayerState.defend then
        self.fight.time = self.fight.time + dt

        if self.fight.time > self.fight.cooldown then
            self.state = PlayerState.idle
            self.fight.time = 0
            self.fight.active = false
        end
    end    
end

function Player:draw()
    if self.state == PlayerState.idle then
        lg.draw(self.img.idle, 0, math.sin(self.y) + 1)
    elseif self.state == PlayerState.attack then
        lg.draw(self.img.sword, 0, math.sin(self.y) + 1)
    elseif self.state == PlayerState.defend then
        lg.draw(self.img.shield, 0, math.sin(self.y) + 1)
    end
end

function HandleInput(self)
    if input:down('player_move_forward') or input:down('player_move_backwards') then
        self.moving = true
        self.speed = 8
    elseif input:released('player_move_forward') or input:released('player_move_backwards') then
        self.moving = false
        self.speed = 1 
    end

    if input:pressed('player_attack') and not self.fight.active then 
        self.state = PlayerState.attack 
        self.fight.active = true
    elseif input:pressed('player_defend') and not self.fight.active then
        self.state = PlayerState.defend 
        self.fight.active = true
    end
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})
