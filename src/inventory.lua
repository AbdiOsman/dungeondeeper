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
        char = gWorld:GetCurrentMember(),
        current = 1,
        closed = false,
    }

    setmetatable(this, Inventory)

    this.panels.invPanel:CenterPosition(GW/2, GH/2, 135, 155)
    this.panels.descPanel:Position(GW/2 - 135/2, GH/2 - 155/2 - 29, 135, 30)
    this.panels.namePanel:Position(GW/2 + 135/2 + 1, GH/2 - 155/2 - 29, 60, 30)
    this.panels.equipPanel:Position(GW/2 + 135/2 + 1, GH/2 - 155/2, 150, 67)
    this.panels.statsPanel:Position(GW/2 + 135/2 + 1, GH/2 - 10, 150, 87)

    this.usePanel = Panel.new()

    local data = {}
    for _, v in ipairs(gWorld.items) do
        table.insert(data, v.id)
    end

    local x, y = this.panels.invPanel:GetAnchors()
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
            ReMap = function (id)
                if not id then return end
                return ItemDB[id].name
            end,
            OnSelection = function(...) this:OnClick(...) end
        }
    }

    this.selections[1].colors =
    {
        [1] = this.char.equipment.weapon ~= -1 and YELLOW or nil,
        [2] = this.char.equipment.armor ~= -1 and YELLOW or nil,
    }

    x, y = this.panels.equipPanel:GetAnchors()
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

    x, y = this.panels.statsPanel:GetAnchors()
    this.statList = List.new
    {
        x = x,
        y = y,
        align = "right",
        width = 60,
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
            gWorld:GetStat(this.char, "hp_max"),
            gWorld:GetStat(this.char, "mp_max"),
            gWorld:GetStat(this.char, "strength"),
            gWorld:GetStat(this.char, "defense"),
            gWorld:GetStat(this.char, "magic"),
            gWorld:GetStat(this.char, "resist"),
        }
    }

    return this
end

function Inventory:Update(dt)
    if Input.JustPressed("cancel") then
        if #self.selections == 1 then
            self.parent.openedSubMenu = false
        else
            table.remove(self.selections, #self.selections)
            self.current = #self.selections
        end
    else
        self.selections[self.current]:HandleInput(dt)
    end
end

function Inventory:OnClick(index, id)
    if id == nil then return end

    if self.current == 1 then
        local item = ItemDB[id]
        local cursor = self.selections[1].cursor

        local data = {}
        local equip = self.char.equipment
        if item.type == "useable" then
            table.insert(data, "Use")
        elseif item.type == "weapon" then
            table.insert(data, (equip.weapon ~= -1 and cursor == 1) and "Unequip" or "Equip")
        elseif item.type == "armor" then
            table.insert(data, (equip.armor ~= -1 and cursor == 2) and "Unequip" or "Equip")
        end
        table.insert(data, (data[1] == "Use" or data[1] == "Equip") and "Throw" or nil)
        table.insert(data, (data[1] == "Use" or data[1] == "Equip") and "Trash" or nil)

        local h = Font.monogram_16:getHeight() * #data + 12

        local x, y = GW/2 + 40, self.selections[1].cursorY
        self.usePanel:Position(x, y, 65, h)
        table.insert(self.selections, Selection.new
        {
            x = x,
            y = y,
            width = 60,
            height = h,
            rows = #data,
            displayrows = #data,
            data = data,
            OnSelection = function(...) self:OnClick(...) end
        })

        self.lastindex = index
        self.current = 2
    elseif self.current == 2 then
        local select = self.selections[1]
        local item = ItemDB[select.data[select.cursor]]
        if id == "Use" then
            local stats = self.char.stats
            if item.use.hp and stats.hp < stats.hp_max then
                stats.hp = math.min(stats.hp_max, stats.hp + item.use.hp)
                self:UseItem(item.use.hp, GREEN)
            elseif item.use.mp and stats.mp < stats.mp_max then
                stats.mp = math.min(stats.mp_max, stats.mp + item.use.mp)
                self:UseItem(item.use.mp, BLUE)
            end
        elseif id == "Equip" then
            gWorld:Equip(item.type, item)
            if item.type == "weapon" then
                self:EquipItem(1, select, item)
            elseif item.type == "armor" then
                self:EquipItem(2, select, item)
            end
        elseif id == "Unequip" then
            if item.type == "weapon" then
                select.colors[1] = nil
                self.equipList.values[1] = ""
            elseif item.type == "armor" then
                self.equipList.values[2] = ""
                select.colors[2] = nil
            end
            gWorld:Unequip(item.type, nil)
            self:UpdateStatList()
        elseif id == "Throw" then
        elseif id == "Trash" then
            table.remove(select.data, select.cursor)
            table.remove(gWorld.items, select.cursor)
        end

        self.current = 1
        table.remove(self.selections, #self.selections)
    end
end

function Inventory:EquipItem(slot, selection, item)
    self.equipList.values[slot] = item.name
    self:UpdateStatList()
    Swap(selection.data, selection.cursor, slot)
    Swap(gWorld.items, selection.cursor, slot)
    selection.colors[slot] = YELLOW
end

function Inventory:UseItem(num, color)
    self:RemoveItem()
    gStack:Pop()
    local hero = gGame.hero
    local x, y = hero:CenterPosition()
    CreateFloatAt(x, y, "+" .. num, 0.8, color)
    hero:Wait(1)
end

function Inventory:RemoveItem()
    table.remove(self.selections[1].data, self.selections[1].cursor)
    table.remove(gWorld.items, self.selections[1].cursor)
end

function Inventory:UpdateStatList()
    self.statList.values =
    {
        gWorld:GetStat(self.char, "hp_max"),
        gWorld:GetStat(self.char, "mp_max"),
        gWorld:GetStat(self.char, "strength"),
        gWorld:GetStat(self.char, "defense"),
        gWorld:GetStat(self.char, "magic"),
        gWorld:GetStat(self.char, "resist"),
    }
end

function Inventory:Enter() end
function Inventory:Exit() end

function Inventory:Draw()
    for _, v in pairs(self.panels) do
        v:Draw()
    end
    self.selections[1]:Draw()
    self.equipList:Drawv()
    self.statList:Drawv()

    local left, top, right = self.panels.namePanel:GetAnchors()
    love.graphics.printf(self.char.name, left, top + 7, right - left, "center" )

    local data = self.selections[1].data[self.selections[1].cursor]
    if data then
        left, top, right = self.panels.descPanel:GetAnchors()
        love.graphics.printf(ItemDB[data].description, left + 4, top, (right - left) - 4, "left")
    end

    if self.current == 2 then
        self.usePanel:Draw()
        self.selections[2]:Draw()
    end
end