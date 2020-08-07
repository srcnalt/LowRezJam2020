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
    time = 0,
    posX = 0,
    posY = 0,
    scale = 0.1,
    linearPos = 1.5,
    encountered = false,
    visible = false
  }, EnemyOne)
end

function EnemyOne:update(dt)
  self.visible = self.linearPos - globalPos < 1

  if self.visible then
    self.scale = 1 - (self.linearPos - globalPos)

    if self.scale > 1 then self.scale = 1 end

    self.time = self.time + dt * 4

    self.posX = math.sin(self.time) * 2 + 32 - 32 * self.scale
    self.posY = math.cos(self.time) * 2 + 32 - 32 * self.scale

    if not encountered and self.scale == 1 then
      encountered = true
    end

    if encountered and globalPos > self.linearPos then
      self.linearPos = globalPos
    end
    
    if encountered and globalPos < self.linearPos then
      self.linearPos = self.linearPos - dt / 4
    end

    self.anim:update(dt)
  end
end

function EnemyOne:draw()
  if self.visible then
    lg.setColor( 255, 255, 255, self.scale)
    self.anim:draw(self.posX, self.posY, 0, self.scale, self.scale)
    lg.setColor( 255, 255, 255, 1 )  
  end
end

return setmetatable({}, {__call = function(_, ...) return EnemyOne.new(...) end})
