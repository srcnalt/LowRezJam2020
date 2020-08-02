--short names
lg = love.graphics
la = love.audio
lw = love.window

--constant variables
SCREEN_SCALE = 12
SCREEN_UNIT = 64 * SCREEN_SCALE

--window settings
lg.setBackgroundColor(0.5, 0.2, 0.3)
lg.setDefaultFilter('nearest', 'nearest')

lw.setMode(SCREEN_UNIT, SCREEN_UNIT, {fullscreen = false, centered = true})
lw.setTitle('Elder Scrolls')