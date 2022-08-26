Selection = {}
Selection.__index  = Selection

function Selection.new(args)
    local this =
    {
        x = args.x,
        y = args.y,
        width = args.width,
        height = args.height,
        data = args.data,
        cursorsprite = Sprite.new(Texture.find("tileset.png")),
        displaycursor = true,
        cursorY = 0,
        maxrows = args.rows or #args.data,
        displayrows = args.displayrows or 11,
        displaystart = 1,
        cursor = 1,
        remap = args.remap or nil,
        onSelection = args.onSelection or function() end
    }

    setmetatable(this, Selection)

    return this
end

function Selection:update(dt)
    if self:isClosed() then
        gStack:pop()
    end
end

function Selection:handleInput(dt)
    if Input.justPressed("up") then
        self.cursor = math.max(self.cursor - 1, 0)
        if self.cursor < 1 then
            self.cursor = self.maxrows
            self.displaystart = self.maxrows - self.displayrows + 1
        elseif self.cursor < self.displaystart then
            self.displaystart = self.displaystart - 1
        end
    elseif Input.justPressed("down") then
        self.cursor = math.min(self.cursor + 1, self.maxrows + 1)
        if self.cursor > self.maxrows then
            self.cursor = 1
            self.displaystart = 1
        elseif self.cursor >= self.displaystart + self.displayrows then
            self.displaystart = self.displaystart + 1
        end
    elseif Input.justPressed("accept") then
        self.onSelection(self.cursor, self.data[self.cursor])
    end
end

function Selection:draw()
    love.graphics.setFont(Font.monogram_16)
    local f = love.graphics.getFont()
    local h = f:getHeight()

    local topOffset = self.y

    love.graphics.setScissor(self.x, self.y, self.width, self.height)

    local start = self.displaystart
    local finish = start + self.displayrows - 1

    if start > 1 then
        self.cursorsprite:drawq(255 + 53, topOffset - 11, 35)
    end

    for i = start, finish do
        if self.cursor == i and self.displaycursor then
            self.cursorY = topOffset + 4
            self.cursorsprite:drawq(self.x + 6, self.cursorY, 34)
        end
        local txt = self.remap ~= nil and self.remap(self.data[i]) or self.data[i]
        if txt then
            love.graphics.print(txt, self.x + TILESIZE, topOffset + 4)
        else
            love.graphics.print("---", self.x + TILESIZE, topOffset + 4)
        end
        topOffset = topOffset + h
    end

    if finish ~= self.maxrows then
        topOffset = topOffset - h
        self.cursorsprite:drawq(255 + 53, topOffset + 7, 33)
    end

    love.graphics.setScissor()
end

function Selection:moveDisplayUp()
    self.displaystart = self.displaystart - 1
end

function Selection:moveDisplayDown()
    self.displaystart = self.displaystart + 1
end