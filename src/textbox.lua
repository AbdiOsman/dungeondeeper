Textbox = {}
Textbox.__index  = Textbox

function Textbox.new(args)
    local this =
    {
        txtarray = args.text,
        txtindex = 1,
        continuecaret = Sprite.new(Texture.Find("tileset.png")),
        rect = args.rect,
        bounds = args.bounds,
        wrap = args.wrap or -1,
        panel = Panel.new(),
        title = args.title,
        portrait = args.portrait,
        closed = false,
        visible = true,
        time = 0,
        hidepanel = args.hidepanel or false,
    }

    setmetatable(this, Textbox)

    this.panel:CenterPosition(this.rect.x, this.rect.y, this.rect.width, this.rect.height)

    return this
end

function Textbox:Update(dt)
    self.time = self.time + dt
    if self:IsClosed() then
        gStack:Pop()
    end

    if not self.visible then return end

    if Input.JustPressed("accept") then
        if self.txtindex < #self.txtarray then
            self.txtindex = self.txtindex + 1
        else
            self.closed = true
        end
    end
end

function Textbox:HandleInput(dt)
    if Input.JustPressed("toggle") then
        self.visible = not self.visible
    end

    if not self.visible then return end

    if Input.Held("speed") and TIME % 8 == 0 then
        if self.txtindex < #self.txtarray then
            self.txtindex = self.txtindex + 1
        end
    end
end

function Textbox:Enter() end
function Textbox:Exit() end

function Textbox:IsClosed()
    return self.closed
end

function Textbox:Draw()
    if not self.visible then return end

    love.graphics.setFont(Font.monogram_16)

    local left, top, right, bottom = self.panel:GetAnchors()
    local textLeft = left + self.bounds.left
    local textTop = top + self.bounds.top

    if self.portrait then
        love.graphics.draw(self.portrait, left, top - 32)
    end

    if not self.hidepanel then
        self.panel:Draw()
    end

    if self.wrap ~= -1 then
        love.graphics.printf(self.txtarray[self.txtindex], textLeft, textTop, self.wrap, "left")
    else
        love.graphics.print(self.text, textLeft, textTop)
    end

    if self.txtindex < #self.txtarray then
        local offset = -18 + math.floor(math.sin(self.time * 10))
        local w = right - left
        local h = bottom - top
        love.graphics.setScissor((left + w/2) - 8, (top + h) - 6, TILESIZE, TILESIZE)
        self.continuecaret:Drawq((left + w/2) - 8, (top + h) + offset, gIcons.arrowdown)
        love.graphics.setScissor()
    end

    if self.title  then
        love.graphics.print(self.title.text, textLeft + self.title.x, textTop + self.title.y)
    end
end

function CreateFixedBox(x, y, width, height, text, args)
    args = args or {}

    local title = args.title

    local padding = 6

    local wrap = width - padding * 2
    local boundsTop = padding

    love.graphics.setFont(Font.monogram_16)

    if title then
        _, h = MeasureText(title, wrap)
        boundsTop = h + padding * 2
        title =
        {
            text = title,
            x = 0,
            y = -h - padding
        }
    end

    --
    -- Section text into box size txtarray.
    --
    local _, h = MeasureText(text)
    local faceHeight = math.ceil(h)
    local current = 1

    local wrptext = GetWrap(text, wrap)

    local boundsHeight = height - (boundsTop)
    local currentHeight = faceHeight

    local txtarray = { { wrptext[1] } }
    while current < #wrptext do
        current = current + 1

        -- If we're going to overflow
        if (currentHeight + faceHeight) > boundsHeight then
            -- make a new entry
            currentHeight = 0
            table.insert(txtarray, { wrptext[current] })
        else
            table.insert(txtarray[#txtarray], wrptext[current])
        end

        currentHeight = currentHeight + faceHeight
    end

    local chunked = {}
    -- Make each textbox be represented by one string.
    for k, v in ipairs(txtarray) do
        chunked[k] = table.concat(v)
    end

    return Textbox.new
    {
        text = chunked,
        wrap = wrap,
        title = title,
        duration = args.duration,
        hidepanel = args.hidepanel,
        portrait = args.portrait,
        anim_y = args.anim_y,
        rect =
        {
            x = x,
            y = y,
            width = width,
            height = height
        },
        bounds =
        {
            left = padding,
            right = -padding,
            top = boundsTop,
            bottom = -padding
        },
    }
end

function CreateFittedBox(x, y, text, wrap, args)
    args = args or {}
    local choices = args.choices
    local title = args.title
    local avatar = args.avatar

    local padding = 6

    local w, h = MeasureText(text, wrap)
    local width = w + padding + 8
    local height = h + 8

    if title then
        w, h = MeasureText(title, wrap)
        height = height + padding + h
        width = math.max(width, w + padding * 2)
    end

    height = height + padding

    -- if avatar then
    --     local avatarWidth = avatar:GetWidth()
    --     local avatarHeight = avatar:GetHeight()
    --     width = width + avatarWidth + padding
    --     height = math.max(height, avatarHeight + padding)
    -- end

    return CreateFixedBox(x, y, width, height, text, args)
end