local EnemyOne = {}
EnemyOne.__index = EnemyOne

local spawned = false

function EnemyOne.new()
    local enemy = lg.newImage('graphics/enemies/enemy_1.png')
    local animEnemy = anim.new(enemy, 64, 64, 0.2)
    
    input:bind('a', 'spawn_enemy')
    input:bind('b', 'reset_enemy')

    return setmetatable({
        anim = animEnemy,
        x = 0,
        y = 0,
        posX = 0,
        posY = 0,
        scale = 0.1
    }, EnemyOne)
end

function EnemyOne:update(dt)
    if spawned then
        self.anim:update(dt)

        self.x = self.x + dt * 4
        self.y = self.y + dt * 4

        if self.scale < 1 then
            self.scale = self.scale + dt / 2
        end

        self.posX = math.sin(self.x) * 2 + 32 * (1 - self.scale)
        self.posY = math.cos(self.y) * 2 + 32 * (1 - self.scale)
    end

    if input:pressed('spawn_enemy') then
        spawned = true
    end

    if input:pressed('reset_enemy') then
        spawned = false
        self.scale = 0
    end
end

function EnemyOne:draw()
    self.anim:draw(self.posX, self.posY, 0, self.scale, self.scale)
end
 
return setmetatable({}, {__call = function(_, ...) return EnemyOne.new(...) end})
