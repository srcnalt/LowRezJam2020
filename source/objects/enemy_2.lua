local EnemyTwo = {}
EnemyTwo.__index = EnemyTwo

function EnemyTwo.new()
  local idle = lg.newImage('graphics/enemies/Enemy_Tentacle_Idle.png')
  local animIdle = anim.new(idle, 64, 64, 0.2)

  local attack = lg.newImage('graphics/enemies/Enemy_Tentacle_attack.png')
  local animAttack = anim.new(attack, 64, 64, 0.2)

  local getHit = lg.newImage('graphics/enemies/Enemy_Tentacle_GetHit.png')
  local animGetHit = anim.new(getHit, 64, 64, 0.2)
  
  local hitAudio = la.newSource("sound/sfx/hit3.wav", "static")
  local dodgeAudio = la.newSource("sound/sfx/hit2.wav", "static")
  local explodeAudio = la.newSource("sound/sfx/hurt3.wav", "static")
  local dieAudio = la.newSource("sound/sfx/hurt2.wav", "static")
  
  local dodgeMsg = lg.newImage('graphics/messages/dodged.png')
  local hitMsg = lg.newImage('graphics/messages/hit.png')

  return setmetatable({
    name = "orko",
    anim = {
      idle = animIdle,
      attack = animAttack,
      hit = animGetHit
    },
    attack = {
      delay = 1,
      time = 0,
      length = 1.5,
      hitting = false,
      dodged = false
    },
    damage = {
      time = 0,
      length = 0.4
    },
    audio = {
      hit = hitAudio,
      dodge = dodgeAudio,
      die = dieAudio,
      explode = explodeAudio
    },
    messages = {
      dodge = dodgeMsg,
      hit = hitMsg
    },
    time = 0,
    posX = 0,
    posY = 0,
    scale = 0.1,
    linearPos = globalPos + 1.5,
    power = math.random(10, 10),
    health = math.random(80, 120),
    state = EnemyState.asleep,
    encountered = false,
    exploded = false
  }, EnemyTwo)
end

function EnemyTwo:update(dt)
  CheckState(self)

  if not encountered and self.scale > 0.4 then
    encountered = true
  end

  if encountered and globalPos > self.linearPos then
    self.linearPos = globalPos
  end
  
  if encountered and globalPos < self.linearPos and self.scale > 0.1 then
    self.linearPos = self.linearPos - dt / 4
  end

  if self.state == EnemyState.idle then
    self.anim.attack:reset()
    self.attack.time = 0

    ScaleBody(self, dt)

    self.anim.idle:update(dt)
  elseif self.state == EnemyState.attack then
    ScaleBody(self, dt)
    self.attack.time = self.attack.time + dt

    if self.anim.attack.pos == 6 and not self.attack.hitting then
      self.attack.hitting = true

      if player.state ~= PlayerState.dead and self.attack.hitting then
        if player.defend.active then
          self.attack.dodged = true
          self.audio.dodge:play()
        else
          player:getDamage(self.power)
        end
        
        self.audio.explode:play()
        self.exploded = true
      end
    end

    if self.health < 0 then PushForward(self) end

    if self.attack.time >= self.attack.delay + self.attack.length then
      self.anim.attack:reset()
      self.attack.time = 0

      if self.exploded then
        PushForward(self)
      end
    elseif self.attack.time >= self.attack.delay then
      self.anim.attack:update(dt)
    else
      self.anim.idle:update(dt)
    end
  elseif self.state == EnemyState.damaged then
    self.damage.time = self.damage.time + dt
    self.anim.hit:update(dt)

    if self.damage.time >= self.damage.length then
      self.damage.time = 0
      self.state = EnemyState.idle
      self.anim.hit.pos = 1
    end
  end
end

function EnemyTwo:draw()
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
    
    if self.attack.dodged then
      lg.draw(self.messages.dodge, 20, 20)
    end
  elseif self.state == EnemyState.damaged then
    self.anim.hit:draw(self.posX, self.posY, 0, self.scale, self.scale)
    lg.draw(self.messages.hit, 27, 20)
  end
end

function EnemyTwo:getDamage(damage)
  if self.linearPos - globalPos == 0 then
    self.state = EnemyState.damaged
    self.health = self.health - damage

    if self.health <= 0 then
      PushForward(self)
      self.state = EnemyState.dead
      self.audio.die:play()
      player.killCount = player.killCount + 1
    else
      self.audio.hit:play()
    end
  end
end

function CheckState(self)
  if self.state == EnemyState.dead then
    --
  elseif self.state == EnemyState.damaged then
    if self.damage.time >= self.damage.length then
      self.state = EnemyState.idle
    end
  elseif self.linearPos - globalPos > 1 then
    self.state = EnemyState.asleep
  elseif self.linearPos - globalPos > 0 then
    self.state = EnemyState.idle
  elseif self.state ~= EnemyState.dead then
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

function PushForward(self)
  player:resetEnemy()
end

return setmetatable({}, {__call = function(_, ...) return EnemyTwo.new(...) end})
