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
    gameState = SceneStates.menu
    stateToGo = SceneStates.debug

    input = _input()
    input:bind('space', 'next')

    map = _map()
    player = _player()
    enemyOne = _enemy_1()

    drawInit()
end

function love.update(dt)
    if gameState == SceneStates.menu then 
        if input:pressed('next') then
            stateToGo = SceneStates.intro
            curtainIsOn = true
        end
        
        map:update(dt)
        enemyOne:update(dt)
        player:update(dt)
    elseif gameState == SceneStates.intro then
        if input:pressed('next') then
            stateToGo = SceneStates.game
            curtainIsOn = true
        end
    elseif gameState == SceneStates.game then
        if input:pressed('next') then
            stateToGo = SceneStates.credits
            curtainIsOn = true
        end
    elseif gameState == SceneStates.credits then
        if input:pressed('next') then
            stateToGo = SceneStates.debug
            curtainIsOn = true
        end
    elseif gameState == SceneStates.debug then 
        if input:pressed('next') then
            stateToGo = SceneStates.menu
            curtainIsOn = true
        end
    end

    updateCurtain(dt)
end

function love.draw()
    --begin drawing into canvas
    drawBegin()

    --states
    if gameState == SceneStates.menu then 
        map:draw()
        enemyOne:draw()
        player:draw()
    elseif gameState == SceneStates.intro then

    elseif gameState == SceneStates.game then

    elseif gameState == SceneStates.credits then

    end

    --draw debug
    drawDebug(gameState)
    --draw curtain
    drawCurtain()
    --end drawing into canvas
    drawEnd()   
end
