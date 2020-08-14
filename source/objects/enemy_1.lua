local EnemyOne = {}
EnemyOne.__index = EnemyOne

function EnemyOne.new()
  local idle = lg.newImage('graphics/enemies/Enemy_Skeleton_Idle.png')
  local animIdle = anim.new(idle, 64, 64, 0.2)

  local attack = lg.newImage('graphics/enemies/Enemy_Skeleton_attack.png')
  local animAttack = anim.new(attack, 64, 64, 0.2)
  
  return setmetatable({
    anim = {
      idle = animIdle,
      attack = animAttack
    },
    attack = {
      delay = 1,
      time = 0,
      length = 1
    },
    time = 0,
    posX = 0,
    posY = 0,
    scale = 0.1,
    linearPos = 1.5,
    state = EnemyState.asleep,
    encountered = false
  }, EnemyOne)
end

function EnemyOne:update(dt)
  CheckState(self)

  if self.state == EnemyState.asleep then
    --
  elseif self.state == EnemyState.idle then
    if not encountered and self.scale > 0.4 then
      encountered = true
    end

    if encountered and globalPos > self.linearPos then
      self.linearPos = globalPos
    end
    
    if encountered and globalPos < self.linearPos then
      self.linearPos = self.linearPos - dt / 4
    end

    self.anim.attack:reset()
    self.attack.time = 0

    ScaleBody(self, dt)

    self.anim.idle:update(dt)
  elseif self.state == EnemyState.attack then
    ScaleBody(self, dt)
    self.attack.time = self.attack.time + dt

    if self.attack.time >= self.attack.delay + self.attack.length then
      self.anim.attack:reset()
      self.attack.time = 0
    elseif self.attack.time >= self.attack.delay then
      self.anim.attack:update(dt)
    else
      self.anim.idle:update(dt)
    end    
  end
end

function EnemyOne:draw()
  if self.state == EnemyState.idle then
    lg.setColor( 255, 255, 255, self.scale)
    self.anim.idle:draw(self.posX, self.posY, 0, self.scale, self.scale)
    lg.setColor( 255, 255, 255, 1 )  
   elseif self.state == EnemyState.attack then
    if self.attack.time >= self.attack.delay then
      self.anim.attack:draw(self.posX, self.posY, 0, self.scale, self.scale)
    else
      self.anim.idle:draw(self.posX, self.posY, 0, self.scale, self.scale)
    end 
  end
end

function CheckState(self)
  if self.linearPos - globalPos > 1 then
    self.state = EnemyState.asleep
  elseif self.linearPos - globalPos > 0 then
    self.state = EnemyState.idle
  else
    self.state = EnemyState.attack
  end 
end

function ScaleBody(self, dt)
  self.scale = 1 - (self.linearPos - globalPos)

  if self.scale > 1 then self.scale = 1 end

  self.time = self.time + dt * 4

  self.posX = math.sin(self.time) * 2 + 32 - 32 * self.scale
  self.posY = math.cos(self.time) * 2 + 32 - 32 * self.scale
end

return setmetatable({}, {__call = function(_, ...) return EnemyOne.new(...) end})
