Float = {}
Float.__index  = Float

function Float.new(args)
    local this =
    {
        x = args.x,
        y = args.y,
        txt = args.txt,
        color = args.color or { 1, 1, 1 },
        duration = args.duration,
        remove = false,
        time = 0
    }

    this.anim_y = Tween.new(0, args.anim_y, args.duration * 0.1)

    setmetatable(this, Float)

    return this
end

function Float:update(dt)
    self.time = self.time + dt
    self.anim_y:update(dt)
    if self.time > self.duration then
        self.remove = true
    end
end

function Float:draw()
    love.graphics.setFont(Font.monogram_16)
    local f = love.graphics:getFont()
    local w = f:getWidth(self.txt)

    textTop = self.y

    textTop = textTop - self.anim_y:value()
    love.graphics.setColor(self.color)
    love.graphics.print(self.txt, self.x - w/2, textTop)
    love.graphics.setColor(1, 1, 1)
end

function createFloatAt(x, y, txt, color)
    table.insert(gStack:top().upper, Float.new({ x = x, y = y, anim_y = 18, duration = 0.5, txt = txt, color = color or YELLOW }))
end