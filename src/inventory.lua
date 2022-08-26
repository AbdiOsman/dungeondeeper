Inventory = {}
Inventory.__index  = Inventory

function Inventory.new(parent)
    local this =
    {
        parent = parent,
        panels =
        {
            invPanel = Panel.new(),
            descPanel = Panel.new(),
            namePanel = Panel.new(),
            equipPanel = Panel.new(),
            statsPanel = Panel.new(),
        },
        char = gWorld.party[1],
        current = 1,
        closed = false,
    }

    setmetatable(this, Inventory)

    this.panels.invPanel:centerPosition(GW/2, GH/2, 135, 155)
    this.panels.descPanel:position(GW/2 - 135/2, GH/2 - 155/2 - 29, 135, 30)
    this.panels.namePanel:position(GW/2 + 135/2 + 1, GH/2 - 155/2 - 29, 60, 30)
    this.panels.equipPanel:position(GW/2 + 135/2 + 1, GH/2 - 155/2, 150, 67)
    this.panels.statsPanel:position(GW/2 + 135/2 + 1, GH/2 - 10, 150, 87)

    this.usePanel = Panel.new()

    local data = {}

    for _, v in ipairs(gWorld.items) do
        table.insert(data, v.id)
    end

    local x, y = this.panels.invPanel:getAnchors()
    this.selections =
    {
        [1] = Selection.new
        {
            x = x,
            y = y,
            width = 150,
            height = 155,
            rows = 25,
            data = data,
            remap = function (id)
                if not id then return end
                return ItemDB[id].name
            end,
            onSelection = function(...) this:onClick(...) end
        }
    }

    x, y = this.panels.equipPanel:getAnchors()
    this.equipList = List.new
    {
        x = x,
        y = y,
        align = "right",
        width = 55,
        labels =
        {
            "Weapon:",
            "Armor:",
            "Acc 1:",
            "Acc 2:",
        },
        values =
        {
            ItemDB[this.char.equipment.weapon].name,
            ItemDB[this.char.equipment.armor].name,
            ItemDB[this.char.equipment.acc1].name,
            ItemDB[this.char.equipment.acc1].name,
        }
    }

    x, y = this.panels.statsPanel:getAnchors()
    this.statList = List.new
    {
        x = x,
        y = y,
        align = "right",
        width = 55,
        labels =
        {
            "HP:",
            "MP:",
            "Strength:",
            "Defense:",
            "Magic:",
            "Resist:",
        },
        values =
        {
            this.char.stats.hp_max,
            this.char.stats.mp_max,
            this.char.stats.strength,
            this.char.stats.defense,
            this.char.stats.magic,
            this.char.stats.resist,
        }
    }

    return this
end

function Inventory:update(dt)
    if Input.justPressed("cancel") then
        if #self.selections == 1 then
            self.parent.openedSubMenu = false
        else
            table.remove(self.selections, #self.selections)
            self.current = #self.selections
        end
    else
        self.selections[self.current]:handleInput(dt)
    end
end

function Inventory:onClick(index, id)
    if id == nil then return end

    if self.current == 1 then
        local item = ItemDB[id]

        local data
        if item.type == "useable" then
            data = { "Use", "Trash" }
        elseif item.type == "weapon" or item.type == "armor" then
            data = { "Equip", "Trash" }
        end

        local h = Font.monogram_16:getHeight() * #data + 10

        local x, y = GW/2 + 40, self.selections[1].cursorY
        self.usePanel:position(x, y, 55, h)
        table.insert(self.selections, Selection.new
        {
            x = x,
            y = y,
            width = 60,
            height = h,
            rows = #data,
            displayrows = #data,
            data = data,
            onSelection = function(...) self:onClick(...) end
        })

        self.lastindex = index
        self.current = 2
    elseif self.current == 2 then
        local select = self.selections[1]
        if id == "Use" then
        elseif id == "Equip" then
            local item = ItemDB[select.data[select.cursor]]
            if item.type == "weapon" then
                self.equipList.values[1] = item.name
            elseif item.type == "armor" then
                self.equipList.values[2] = item.name
            end
        elseif id == "Trash" then
            table.remove(gWorld.items, select.cursor)
        end

        self.current = 1
        table.remove(select.data, select.cursor)
        table.remove(self.selections, #self.selections)
    end
end

function Inventory:enter() end
function Inventory:exit() end

function Inventory:draw()
    for _, v in pairs(self.panels) do
        v:draw()
    end
    self.selections[1]:draw()
    self.equipList:drawv()
    self.statList:drawv()

    local left, top, right = self.panels.namePanel:getAnchors()
    love.graphics.printf(self.char.name, left, top + 7, right - left, "center" )

    local data = self.selections[1].data[self.selections[1].cursor]
    if data then
        left, top, right = self.panels.descPanel:getAnchors()
        love.graphics.printf(ItemDB[data].description, left + 4, top, (right - left) - 4, "left")
    end

    if self.current == 2 then
        self.usePanel:draw()
        self.selections[2]:draw()
    end
end