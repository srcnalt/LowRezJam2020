--source files
require 'source.settings'
require 'source.utils'
require 'source.states'
require 'source.anim'

--objects
_map = require 'source.objects.map'
_menu = require 'source.objects.menu'
_story = require 'source.objects.story'
_player = require 'source.objects.player'
_enemy_1 = require 'source.objects.enemy_1'
_enemy_2 = require 'source.objects.enemy_2'
_enemy_3 = require 'source.objects.enemy_3'

--plugins
_input = require 'plugins.Input'

menuMusic = la.newSource("sound/music/menu.ogg", "stream")
gameMusic = la.newSource("sound/music/game.ogg", "stream")
select = la.newSource("sound/sfx/select.wav", "static")

function love.load()
    gameState = SceneStates.menu
    stateToGo = SceneStates.menu

    globalPos = 0

    input = _input()
    input:bind('x', 'next')

    map = _map()
    menu = _menu()
    story = _story()
    player = _player()
    enemy = _enemy_1()

    drawInit()
    menuMusic:play()
end

function love.update(dt)
  if gameState == SceneStates.menu then 
    CheckNextStateToGo(SceneStates.story_1)
    menu:update(dt)
  elseif gameState == SceneStates.story_1 then
    CheckNextStateToGo(SceneStates.story_2)
    story:update(dt)
  elseif gameState == SceneStates.story_2 then
    CheckNextStateToGo(SceneStates.input)
    story:update(dt)
  elseif gameState == SceneStates.input then
    CheckNextStateToGo(SceneStates.game)
    story:update(dt)
  elseif gameState == SceneStates.game then
    map:update(dt)
    enemy:update(dt)
    player:update(dt)
  elseif gameState == SceneStates.win or gameState == SceneStates.lose then
    CheckNextStateToGo(SceneStates.credits)
    story:update(dt)
  elseif gameState == SceneStates.credits then
    CheckNextStateToGo(SceneStates.menu)
  end

  updateCurtain(dt)
end

function love.draw()
  --begin drawing into canvas
  drawBegin()

  --states
  if gameState == SceneStates.menu then 
    menu:draw()
  elseif gameState == SceneStates.story_1 or gameState == SceneStates.story_2 or gameState == SceneStates.win or gameState == SceneStates.lose or gameState == SceneStates.credits or gameState == SceneStates.input then
    story:draw()
  elseif gameState == SceneStates.game then
    map:draw()
    enemy:draw()
    player:draw()
  end

  --draw curtain
  drawCurtain()
  --end drawing into canvas
  drawEnd()   
end

function CheckNextStateToGo(state)
  if input:pressed('next') then
    stateToGo = state
    curtainIsOn = true
    select:play()
  end
end
