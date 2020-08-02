require 'source.settings'
require 'source.debug'
require 'source.utils'

function love.load()
    drawInit()
end

function love.update()

end

function love.draw()
    --begin drawing into canvas
    drawBegin()

    --
    lg.draw(debugImage)

    --end drawing into canvas
    drawEnd()   
end
