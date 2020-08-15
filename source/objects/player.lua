local Player = {}
Player.__index = Player

function Player.new()
  local idleImg = lg.newImage('graphics/player/Player_Idle.png')

  local attackImg = lg.newImage('graphics/player/Player_Attack.png')
  local animAttack = anim.new(attackImg, 64, 64, 0.2)

  local defendImg = lg.newImage('graphics/player/Player_Defend.png')
  local animDefend = anim.new(defendImg, 64, 64, 0.2)

  local lifebarImg = lg.newImage('graphics/ui/life_bar.png')
  local font = lg.newImageFont('graphics/ui/number_font.png', "1234567890")
  lg.setFont(font)

  local hitAudio = la.newSource("sound/sfx/hurt.wav", "static")
  local swingAudio = la.newSource("sound/sfx/hit.wav", "static")
  local dieAudio = la.newSource("sound/sfx/hurt3.wav", "static")

  input:bind('up', 'player_move_forward')
  input:bind('down', 'player_move_backwards')
  input:bind('left', 'player_attack')
  input:bind('right', 'player_defend')

  return setmetatable({
    img = {
      idle = idleImg,
      attack = animAttack,
      defend = animDefend,
      lifebar = lifebarImg
    },
    fight = {
      time = 0,
      cooldown = 1,
      active = false
    },
    defend = {
      time = 0,
      cooldown = 0.6,
      active = false
    },
    audio = {
      hit = hitAudio,
      swing = swingAudio,
      die = dieAudio
    },
    moving = false,
    x = 0,
    y = 0,
    speed = 0,
    health = 100,
    power = 50,
    state = PlayerState.idle,
    killCount = 0
  }, Player)
end

function Player:update(dt)
    HandleInput(self)

    if self.state == PlayerState.idle then
      self.y = self.y + dt * self.speed
      self.fight.active = false
      self.defend.active = false
    elseif self.state == PlayerState.attack then
      self.fight.time = self.fight.time + dt
      self.img.attack:update(dt)
      self.fight.active = true

      if self.fight.time >= self.fight.cooldown then
        self.state = PlayerState.idle
        self.fight.time = 0
        self.fight.active = false
        self.img.attack.pos = 1
      end

      if self.img.attack.pos == 3 then
        if enemy.state == EnemyState.attack and not enemy.attack.hitting then
          enemy:getDamage(self.power + math.random(-5, 5))
        else
          self.audio.swing:play()
        end
      end
    elseif self.state == PlayerState.defend then
      self.defend.time = self.defend.time + dt
      self.img.defend:update(dt)
      
      if self.img.defend.pos == 2 then
        self.defend.active = true
      end

      if self.defend.time >= self.defend.cooldown then
        self.state = PlayerState.idle
        self.defend.time = 0
        self.img.defend.pos = 1
        self.defend.active = false
      end
    end    
end

function Player:draw()
  if self.state == PlayerState.idle then
    lg.draw(self.img.idle, 0, math.sin(self.y) + 1)
  elseif self.state == PlayerState.attack then
    self.img.attack:draw()
  elseif self.state == PlayerState.defend then
    self.img.defend:draw()
  end

  --life bar
  lg.draw(self.img.lifebar)
  lg.setColor(0, 1, 0, 1)
  lg.rectangle("fill", 9, 2, 37 * self.health / 100, 3)
  lg.setColor(1, 1, 1, 1)

  --kill count
  lg.print(self.killCount, 56, 1)
end

function HandleInput(self)
    if input:down('player_move_forward') or input:down('player_move_backwards') then
        self.moving = true
        self.speed = 8
    elseif input:released('player_move_forward') or input:released('player_move_backwards') then
        self.moving = false
        self.speed = 1 
    end

    if input:pressed('player_attack') and not self.fight.active and not self.defend.active then 
        self.state = PlayerState.attack
    elseif input:pressed('player_defend') and not self.fight.active and not self.defend.active then
        self.state = PlayerState.defend
    end
end

function Player:getDamage(damage)
  self.health = self.health - damage

  if self.health <= 0 then
    self.state = PlayerState.dead
    self.audio.die:play()
  else
    self.audio.hit:play()
  end
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})
