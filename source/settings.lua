--short names
lg = love.graphics
la = love.audio
lw = love.window

--constant variables
CURTAIN_SPEED = 2
SCREEN_SCALE = 12
SCREEN_UNIT = 64 * SCREEN_SCALE
DEBUG_ON = false

--window settings
--14, 10, 13
lg.setBackgroundColor(0, 0, 0)
lg.setDefaultFilter('nearest', 'nearest')

lw.setMode(SCREEN_UNIT, SCREEN_UNIT, {fullscreen = false, centered = false})
lw.setTitle('Landlord')

--random seed
math.randomseed(os.time())