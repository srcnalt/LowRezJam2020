--canvas draw helper methods
canvas = {}

function drawInit()
    canvas = lg.newCanvas(SCREEN_UNIT, SCREEN_UNIT)
end

function drawBegin()
    lg.setCanvas(canvas)
    lg.clear()
end

function drawEnd()
    lg.setCanvas()
    lg.draw(canvas, 0, 0, 0, SCREEN_SCALE, SCREEN_SCALE)
end

--scene switch helper methods
curtainIsOn = false
curtainDarken = true
curtainAlpha = 1
curtain = lg.newImage('graphics/curtain.png')

function drawCurtain()
    lg.setColor(1, 1, 1, 1 - curtainAlpha)
    lg.draw(curtain)
    lg.setColor(1, 1, 1, 1)
end

function updateCurtain(dt)
    if curtainIsOn then
        if curtainDarken then
            if curtainAlpha > 0 then
                curtainAlpha = curtainAlpha - dt
            else
                gameState = stateToGo
                curtainDarken = false
            end
        else
            if curtainAlpha < 1 then
                curtainAlpha = curtainAlpha + dt
            else
                curtainDarken = true
                curtainIsOn  = false
            end
        end
    end
end
