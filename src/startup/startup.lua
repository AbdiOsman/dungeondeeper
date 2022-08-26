love.graphics.setDefaultFilter("nearest", "nearest")

local icon = love.image.newImageData("art/icon.png")
love.window.setIcon(icon)

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

CORAL = { 255 / 255, 127 / 255, 80 / 255 }
YELLOW = { 251 / 255, 242 / 255, 54 / 255 }
RED = { 200 / 255, 40 / 255, 40 / 255 }
LIGHTGRAY = { 195 / 255, 195 / 255, 201 / 255 }

DIRX = { -1, 1, 0, 0 }
DIRY = { 0, 0, -1, 1 }

Input.bind('up',            'up')
Input.bind('down',          'down')
Input.bind('left',          'left')
Input.bind('right',         'right')
Input.bind('z',             'accept')
Input.bind('return',        'accept')
Input.bind('x',             'cancel')
Input.bind('kp0',           'cancel')
Input.bind('lshift',        'speed')
Input.bind('rshift',        'speed')
Input.bind('lctrl',         'toggle')
Input.bind('rctrl',         'toggle')
Input.bind('f1',            'f1')
Input.bind('f2',            'f2')
Input.bind('f3',            'f3')
Input.bind('f4',            'f4')
Input.bind('f5',            'f5')