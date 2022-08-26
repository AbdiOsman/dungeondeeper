local manifest = require "manifest"

Font = {}
Texture = {}
local textureList = {}

function Font.load()
    for i = 16, 32, 16 do
        for name, v in pairs(manifest.fonts) do
            local font = love.graphics.newFont(v.path, i)
            font:setFilter("nearest", "nearest")
            Font[name .. '_' .. i] = font
        end
    end
end

function Texture.load(textures)
    for name, v in pairs(textures) do
        local texture = love.graphics.newImage(v.path)
        if v.filter then texture:setFilter(v.filter, v.filter) end
        textureList[name] = texture
    end
end

function Texture.find(texture)
    return textureList[texture]
end

Font.load()
Texture.load(manifest.textures)

love.graphics.setFont(Font.monogram_16)
Font.current = love.graphics.getFont()