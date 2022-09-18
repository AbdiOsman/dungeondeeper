Sprite = {}
Sprite.__index = Sprite

function Sprite.new(img)
    local this =
    {
        img = img,
        flashtime = 0,
        whiteoutshader = love.graphics.newShader("data/shaders/whiteout.shader")
    }

    this.quads = GenerateQuads(TILESIZE, TILESIZE, img)

    setmetatable(this, Sprite)

    return this
end

function Sprite:Drawq(x, y, tile)
    self:Flash()
    love.graphics.draw(self.img, self.quads[tile], x, y)
    love.graphics.setShader()
end

function Sprite:Flash()
    if self.flashtime > 0 then
        love.graphics.setShader(self.whiteoutshader)

        self.whiteoutshader:send("WhiteFactor", 1)
        self.flashtime = self.flashtime - 1
    else
        love.graphics.setShader()
    end
end