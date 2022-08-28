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

    this.panel:position(250 + 2, 102, 230, 155)
    local left, top = this.panel:getAnchors()
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

function Settings:update(dt)
    self.selection:handleInput(dt)

    if Input.justPressed("cancel") then
        self.parent.openedSubMenu = false
    end

    if self.selection.cursor == 1 then
        if Input.justPressed("left") then
            MASTERVOLUME = math.max(0, MASTERVOLUME - 0.10)
        elseif Input.justPressed("right") then
            MASTERVOLUME = math.min(1, MASTERVOLUME + 0.10)
        end
    elseif self.selection.cursor == 2 then
        if Input.justPressed("left") then
            BGMVOLUME = math.max(0, BGMVOLUME - 0.10)
        elseif Input.justPressed("right") then
            BGMVOLUME = math.min(1, BGMVOLUME + 0.10)
        end
    elseif self.selection.cursor == 3 then
        if Input.justPressed("left") then
            SEVOLUME = math.max(0, SEVOLUME - 0.10)
        elseif Input.justPressed("right") then
            SEVOLUME = math.min(1, SEVOLUME + 0.10)
        end
    elseif self.selection.cursor == 5 then
        if Input.justPressed("right") then
            SCALE = SCALE % 2 + 1
            resize(SCALE)
        end
    end
end

function Settings:onClick(index, id)
end

function Settings:enter() end
function Settings:exit() end

function Settings:draw()
    self.panel:draw()
    self.selection:draw()

    local x, y = self.panel:getAnchors()
    love.graphics.rectangle("fill", x + 120, y + 5, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 7, 100 * MASTERVOLUME, 8)
    love.graphics.rectangle("fill", x + 120, y + 19, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 21, 100 * BGMVOLUME, 8)
    love.graphics.rectangle("fill", x + 120, y + 33, 2, 12)
    love.graphics.rectangle("fill", x + 120, y + 35, 100 * SEVOLUME, 8)

    -- love.graphics.print(SCALE .. "x", x + 120, 158)
end