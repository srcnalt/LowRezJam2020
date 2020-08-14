debugImage = lg.newImage('graphics/test64x64.png')

function drawDebug(state)
    if DEBUG_ON then
        lg.print(state)
    end
end