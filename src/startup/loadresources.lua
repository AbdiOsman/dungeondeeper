local resources = require "resources"

Font = {}
Texture = {}
local textureList = {}

function Font.Load()
    for i = 16, 32, 16 do
        for name, v in pairs(resources.fonts) do
            local font = love.graphics.newFont(v.path, i)
            font:setFilter("nearest", "nearest")
            Font[name .. '_' .. i] = font
        end
    end
end

function Texture.Load(textures)
    for name, v in pairs(textures) do
        local texture = love.graphics.newImage(v.path)
        if v.filter then texture:setFilter(v.filter, v.filter) end
        textureList[name] = texture
    end
end

function Texture.Find(texture)
    return textureList[texture]
end

Font.Load()
Texture.Load(resources.textures)

love.graphics.setFont(Font.monogram_16)
Font.current = love.graphics.getFont()