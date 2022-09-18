World = {}
World.__index = World

function World.new()
    local this =
    {
        time = 0,
        gold = 0,
        items =
        {
            { id = 1 },
            { id = 2 },
            { id = 3 },
            { id = 4 },
            { id = 5 },
            { id = 6 },
            { id = 7 },
        },
        party =
        {
            {
                name = "Nett",
                stats = {},
                modifiers = {},
                equipment =
                {
                    weapon = -1,
                    armor = -1,
                    acc1 = -1,
                    acc2 = -1,
                },
                spells =
                {
                    { id = 1 },
                }
            }
        },
        monsters = {},
        keyitems = {},
    }

    setmetatable(this, World)

    return this
end

function World:Update(dt)
    self.time = self.time + dt
end

function World:TimeAsString()
    local time = self.time
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = time % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function World:GoldAsString()
    return string.format("%d", self.gold)
end

function World:GetCurrentMember()
    return self.party[CURRENTMEMEBER]
end

function World:Equip(slot, item)
    local mem = self:GetCurrentMember()
    local previtem = mem.equipment[slot]
    mem.equipment[slot] = -1
    if previtem ~= -1 then
        mem.modifiers[slot] = nil
    end

    if not item then
        return
    end

    mem.equipment[slot] = item.id
    local modifier = ItemDB[item.id].stats or {}
    self:AddModifier(slot, modifier)
end

function World:Unequip(slot)
    self:equip(slot, nil)
end

function World:AddModifier(id, modifier)
    self:GetCurrentMember().modifiers[id] =
    {
        add     = modifier.add or {},
        mult    = modifier.mult or {}
    }
end

function World:GetStat(ent, id)
    local total = ent.stats[id] or 0
    local multiplier = 0

    for _, v in pairs(ent.modifiers or {}) do
        total = total + (v.add[id] or 0)
        multiplier = multiplier + (v.mult[id] or 0)
    end

    return total + (total * multiplier)
end