local Story = {}
Story.__index = Story

local skipImg = lg.newImage('graphics/ui/skip.png')
local skip = anim.new(skipImg, 3, 3, 0.5)

function Story.new()
  local story1 = lg.newImage('graphics/stories/knight_and_king.png')
  local story2 = lg.newImage('graphics/stories/arriving2castle.png')
  local story3 = lg.newImage('graphics/stories/party_win.png')
  local story4 = lg.newImage('graphics/stories/failed_mission.png')
  local story5 = lg.newImage('graphics/stories/credits.png')

  return setmetatable({
    story = {
      one = story1,
      two = story2,
      win = story3,
      lose = story4,
      credits = story5
    }
  }, Story)
end

function Story:update(dt)
  skip:update(dt)  
end

function Story:draw()
  if gameState == SceneStates.story_1 then
    lg.draw(self.story.one)
    skip:draw(30, 61)
  elseif gameState == SceneStates.story_2 then
    lg.draw(self.story.two)
    skip:draw(30, 61)
  elseif gameState == SceneStates.win then
    lg.draw(self.story.win)
    skip:draw(30, 61)
  elseif gameState == SceneStates.lose then
    lg.draw(self.story.lose)
    skip:draw(30, 61)
  elseif gameState == SceneStates.credits then
    lg.draw(self.story.credits)
  end
end

return setmetatable({}, {__call = function(_, ...) return Story.new(...) end})
