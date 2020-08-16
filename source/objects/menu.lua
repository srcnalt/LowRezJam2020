local Menu = {}
Menu.__index = Menu

function Menu.new()
  local menuImg = lg.newImage('graphics/menu.png')
  local logoImg = lg.newImage('graphics/logo.png')
  local startImg = lg.newImage('graphics/start.png')

  return setmetatable({
    background = menuImg,
    logo = logoImg,
    start = startImg,
    time = 0,
    logoPos = 64,
    drawStart = false
  }, Menu)
end

function Menu:update(dt)
  self.time = self.time + dt

  if self.time > 2 then
    drawStart = math.floor(self.time) % 2 == 0
  elseif self.time > 1.7 then
    drawStart = true
  elseif self.time > 0.7 then
    self.logoPos = self.logoPos - dt * 13
  end
end

function Menu:draw()
  lg.draw(self.background, 0, 0)
  lg.draw(self.logo, 9, self.logoPos)
  if drawStart then lg.draw(self.start, 6, 1) end
end

function HandleInput(self)
    
end

return setmetatable({}, {__call = function(_, ...) return Menu.new(...) end})
