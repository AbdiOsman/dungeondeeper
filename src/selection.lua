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
        cursorsprite = Sprite.new(Texture.Find("tileset.png")),
        displaycursor = true,
        cursorY = 0,
        maxrows = args.rows or #args.data,
        displayrows = args.displayrows or 11,
        displaystart = 1,
        cursor = 1,
        ReMap = args.ReMap or nil,
        colors = {},
        OnSelection = args.OnSelection or function() end
    }

    setmetatable(this, Selection)

    return this
end

function Selection:Update(dt)
    if self:IsClosed() then
        -- TODO: reference to stack? in objects that use it?
        gStack:Pop()
    end
end

function Selection:HandleInput(dt)
    if Input.JustPressed("up") then
        self.cursor = math.max(self.cursor - 1, 0)
        if self.cursor < 1 then
            self.cursor = self.maxrows
            self.displaystart = self.maxrows - self.displayrows + 1
        elseif self.cursor < self.displaystart then
            self.displaystart = self.displaystart - 1
        end
    elseif Input.JustPressed("down") then
        self.cursor = math.min(self.cursor + 1, self.maxrows + 1)
        if self.cursor > self.maxrows then
            self.cursor = 1
            self.displaystart = 1
        elseif self.cursor >= self.displaystart + self.displayrows then
            self.displaystart = self.displaystart + 1
        end
    elseif Input.JustPressed("accept") then
        if self.data[self.cursor] == "Alice" then
            local x
        end
        self.OnSelection(self.cursor, self.data[self.cursor])
    end
end

function Selection:Draw()
    love.graphics.setFont(Font.monogram_16)
    local f = love.graphics.getFont()
    local h = f:getHeight()

    local topOffset = self.y

    love.graphics.setScissor(self.x, self.y, self.width, self.height)

    local start = self.displaystart
    local finish = start + self.displayrows - 1

    if start > 1 then
        self.cursorsprite:Drawq(255 + 53, topOffset - 11, 35)
    end

    for i = start, finish do
        if self.cursor == i and self.displaycursor then
            self.cursorY = topOffset + 4
            self.cursorsprite:Drawq(self.x + 6, self.cursorY, 34)
        end

        if self.colors[i] then love.graphics.setColor(self.colors[i]) end

        local txt = self.ReMap ~= nil and self.ReMap(self.data[i]) or self.data[i]
        if txt then
            love.graphics.print(txt, self.x + TILESIZE, topOffset + 4)
        else
            love.graphics.print("---", self.x + TILESIZE, topOffset + 4)
        end

        love.graphics.setColor(1, 1, 1)

        topOffset = topOffset + h
    end

    if finish ~= self.maxrows then
        topOffset = topOffset - h
        self.cursorsprite:Drawq(255 + 53, topOffset + 7, 33)
    end

    love.graphics.setScissor()
end

function Selection:MoveDisplayUp()
    self.displaystart = self.displaystart - 1
end

function Selection:MoveDisplayDown()
    self.displaystart = self.displaystart + 1
end