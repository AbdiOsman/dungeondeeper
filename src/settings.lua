Settings = {}
Settings.__index  = Settings

function Settings.new(parent)
    local this =
    {
        parent = parent,
        panel = Panel.new(),
        closed = false,
    }

    setmetatable(this, Settings)

    this.panel:Position(250 + 2, 102, 230, 155)
    local left, top = this.panel:GetAnchors()
    this.selection = Selection.new
    {
        x = left,
        y = top,
        width = 150,
        height = 155,
        rows = 3,
        displayrows = 3,
        data =
        {
            "Master Volume:",
            "Music Volume:",
            "SE Volume:",
            -- "----------------",
            -- "Scale:"
        }
    }

    return this
end

function Settings:Update(dt)
    self.selection:HandleInput(dt)

    if Input.JustPressed("cancel") then
        self.parent.openedSubMenu = false
    end

    if self.selection.cursor == 1 then
        if Input.JustPressed("left") then
            MASTERVOLUME = math.max(0, MASTERVOLUME - 0.10)
        elseif Input.JustPressed("right") then
            MASTERVOLUME = math.min(1, MASTERVOLUME + 0.10)
        end
    elseif self.selection.cursor == 2 then
        if Input.JustPressed("left") then
            BGMVOLUME = math.max(0, BGMVOLUME - 0.10)
        elseif Input.JustPressed("right") then
            BGMVOLUME = math.min(1, BGMVOLUME + 0.10)
        end
    elseif self.selection.cursor == 3 then
        if Input.JustPressed("left") then
            SEVOLUME = math.max(0, SEVOLUME - 0.10)
        elseif Input.JustPressed("right") then
            SEVOLUME = math.min(1, SEVOLUME + 0.10)
        end
    elseif self.selection.cursor == 5 then
        if Input.JustPressed("right") then
            SCALE = SCALE % 2 + 1
            Resize(SCALE)
        end
    end
end

function Settings:OnClick(index, id)
end

function Settings:Enter() end
function Settings:Exit() end

function Settings:Draw()
    self.panel:Draw()
    self.selection:Draw()

    local x, y = self.panel:GetAnchors()
    love.graphics.rectangle("fill", x + 120, y + 5, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 7, 100 * MASTERVOLUME, 8)
    love.graphics.rectangle("fill", x + 120, y + 19, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 21, 100 * BGMVOLUME, 8)
    love.graphics.rectangle("fill", x + 120, y + 33, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 35, 100 * SEVOLUME, 8)

    -- love.graphics.print(SCALE .. "x", x + 120, 158)
end