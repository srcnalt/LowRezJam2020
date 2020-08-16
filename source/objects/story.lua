local Story = {}
Story.__index = Story

function Story.new()
  local story1 = lg.newImage('graphics/stories/knight_and_king.png')
  local story2 = lg.newImage('graphics/stories/arriving2castle.png')
  local story3 = lg.newImage('graphics/stories/party_win.png')

  return setmetatable({
    story = {
      one = story1,
      two = story2,
      three = story3
    }
  }, Story)
end

function Story:update(dt)

  
end

function Story:draw()
  if gameState == SceneStates.story_1 then
    lg.draw(self.story.one)
  elseif gameState == SceneStates.story_2 then
    lg.draw(self.story.two)
  end
end

function HandleInput(self)
    
end

return setmetatable({}, {__call = function(_, ...) return Story.new(...) end})
