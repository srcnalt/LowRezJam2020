--source files
require 'source.settings'
require 'source.utils'
require 'source.states'
require 'source.anim'

--objects
_map = require 'source.objects.map'
_menu = require 'source.objects.menu'
_player = require 'source.objects.player'
_enemy_1 = require 'source.objects.enemy_1'
_enemy_2 = require 'source.objects.enemy_2'

--plugins
_input = require 'plugins.Input'

function love.load()
    gameState = SceneStates.debug
    stateToGo = SceneStates.menu

    globalPos = 0

    input = _input()
    input:bind('x', 'next')

    map = _map()
    menu = _menu()
    player = _player()
    enemy = _enemy_1()

    drawInit()
end

function love.update(dt)
  if gameState == SceneStates.menu then 
    CheckNextStateToGo(SceneStates.intro)
    
    menu:update(dt)
  elseif gameState == SceneStates.intro then
    CheckNextStateToGo(SceneStates.game)
  elseif gameState == SceneStates.game then
    CheckNextStateToGo(SceneStates.credits)

    map:update(dt)
    enemy:update(dt)
    player:update(dt)
  elseif gameState == SceneStates.credits then
    CheckNextStateToGo(SceneStates.menu)
  elseif gameState == SceneStates.debug then
    curtainIsOn = true
  end

  updateCurtain(dt)
end

function love.draw()
  --begin drawing into canvas
  drawBegin()

  --states
  if gameState == SceneStates.menu then 
    menu:draw()
  elseif gameState == SceneStates.intro then

  elseif gameState == SceneStates.game then
    map:draw()
    enemy:draw()
    player:draw()
  elseif gameState == SceneStates.credits then

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
  end
end
