love.graphics.setDefaultFilter("nearest", "nearest")

-- local icon = love.image.newImageData("art/icon.png")
-- love.window.setIcon(icon)

require "src.startup.dependencies"

VW = love.graphics.getWidth()
VH = love.graphics.getHeight()
GW = love.graphics.getWidth()
GH = love.graphics.getHeight()

EMPTYFUNC = function() end

TILESIZE = 16

SCALE = 2
STOPCAMERA = false
TIME = 0

LEVEL = 1
MOBSDONE = 0

MASTERVOLUME = 0.6 -- Maximum volume for all sounds
BGMVOLUME = 1
SEVOLUME = 0.1

CURRENTMEMEBER = 1

RED = { 200 / 255, 40 / 255, 40 / 255 }
GREEN = { 106 / 255, 190 / 255, 48 / 255 }
BLUE = { 99 / 255, 155 / 255, 255 / 255 }
CORAL = { 255 / 255, 127 / 255, 80 / 255 }
YELLOW = { 251 / 255, 242 / 255, 54 / 255 }
LIGHTGRAY = { 195 / 255, 195 / 255, 201 / 255 }

DIRX = { -1, 1, 0, 0 }
DIRY = { 0, 0, -1, 1 }

Input.Bind('up',            'up')
Input.Bind('down',          'down')
Input.Bind('left',          'left')
Input.Bind('right',         'right')
Input.Bind('z',             'accept')
Input.Bind('return',        'accept')
Input.Bind('x',             'cancel')
Input.Bind('kp0',           'cancel')
Input.Bind('c',           'cast')
Input.Bind('lshift',        'speed')
Input.Bind('rshift',        'speed')
Input.Bind('lctrl',         'toggle')
Input.Bind('rctrl',         'toggle')
Input.Bind('f1',            'f1')
Input.Bind('f2',            'f2')
Input.Bind('f3',            'f3')
Input.Bind('f4',            'f4')
Input.Bind('f5',            'f5')