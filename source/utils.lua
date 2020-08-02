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
