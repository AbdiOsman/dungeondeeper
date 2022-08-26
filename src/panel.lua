Panel = {}
Panel.__index = Panel

function Panel.new(color)
    args = args or {}
    local this =
    {
        color = args.color or { 1, 1, 1 }
    }

    setmetatable(this, Panel)

    return this
end

function Panel:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor({ 0, 0, 0 })
    love.graphics.rectangle("fill", self.x+1, self.y+1, self.width-2, self.height-2)
    love.graphics.setColor({ 1, 1, 1 })
end

function Panel:centerPosition(x, y, width, height)
    self:position(x - width/2, y - height/2, width, height)
end

function Panel:position(x, y, width, height)
   self.x = x
   self.y = y
   self.width = width
   self.height = height

   self.left, self.top = x, y
   self.right, self.bottom = x + width, y + height
end

function Panel:getAnchors()
    return self.left, self.top, self.right, self.bottom
end

function Panel:getSize()
    return self.width, self.height
end