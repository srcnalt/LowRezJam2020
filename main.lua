--source files
require 'source.settings'
require 'source.debug'
require 'source.utils'
require 'source.states'
require 'source.anim'

--objects
_map = require 'source.objects.map'
_enemy_1 = require 'source.objects.enemy_1'
_player = require 'source.objects.player'

--plugins
_input = require 'plugins.Input'

function love.load()
    gameState = SceneStates.game
    stateToGo = SceneStates.debug

    globalPos = 0

    input = _input()
    input:bind('space', 'next')

    map = _map()
    player = _player()
    enemyOne = _enemy_1()

    drawInit()
end

function love.update(dt)
    if gameState == SceneStates.menu then 
      CheckNextStateToGo(SceneStates.menu)
    elseif gameState == SceneStates.intro then
      CheckNextStateToGo(SceneStates.intro)
    elseif gameState == SceneStates.game then
      CheckNextStateToGo(SceneStates.game)

      map:update(dt)
      enemyOne:update(dt)
      player:update(dt)
    elseif gameState == SceneStates.credits then
      CheckNextStateToGo(SceneStates.credits)
    elseif gameState == SceneStates.debug then 
      CheckNextStateToGo(SceneStates.debug)
    end

    updateCurtain(dt)
end

function love.draw()
  --begin drawing into canvas
  drawBegin()

  --states
  if gameState == SceneStates.menu then 

  elseif gameState == SceneStates.intro then

  elseif gameState == SceneStates.game then
    map:draw()
    enemyOne:draw()
    player:draw()
  elseif gameState == SceneStates.credits then

  end

  --draw debug
  drawDebug(gameState)
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