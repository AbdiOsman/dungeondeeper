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

function Panel:Draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor({ 0, 0, 0 })
    love.graphics.rectangle("fill", self.x+1, self.y+1, self.width-2, self.height-2)
    love.graphics.setColor({ 1, 1, 1 })
end

function Panel:CenterPosition(x, y, width, height)
    self:Position(x - width/2, y - height/2, width, height)
end

function Panel:Position(x, y, width, height)
   self.x = x
   self.y = y
   self.width = width
   self.height = height

   self.left, self.top = x, y
   self.right, self.bottom = x + width, y + height
end

function Panel:GetAnchors()
    return self.left, self.top, self.right, self.bottom
end

-- TODO: Use this to get size
function Panel:GetSize()
    return self.width, self.height
end