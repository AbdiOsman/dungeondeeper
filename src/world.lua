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
            { id = 5 },
            { id = 5 },
            { id = 5 },
            { id = 5 },
            { id = 5 },
            { id = 5 },
            { id = 6 },
        },
        party =
        {
            {
                name = "Hero",
                stats = {},
                modifiers = {},
                equipment =
                {
                    weapon = -1,
                    armor = -1,
                    acc1 = -1,
                    acc2 = -1,
                }
            }
        },
        monsters = {},
        keyitems = {},
    }

    setmetatable(this, World)

    return this
end

function World:update(dt)
    self.time = self.time + dt
end

function World:timeAsString()
    local time = self.time
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = time % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function World:goldAsString()
    return string.format("%d", self.gold)
end

function World:getCurrentMember()
    return self.party[CURRENTMEMEBER]
end

function World:equip(slot, item)
    local mem = self:getCurrentMember()
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
    self:addmodifier(slot, modifier)
end

function World:unequip(slot)
    self:equip(slot, nil)
end

function World:addmodifier(id, modifier)
    self:getCurrentMember().modifiers[id] =
    {
        add     = modifier.add or {},
        mult    = modifier.mult or {}
    }
end

function World:getStat(ent, id)
    local total = ent.stats[id] or 0
    local multiplier = 0

    for _, v in pairs(ent.modifiers or {}) do
        total = total + (v.add[id] or 0)
        multiplier = multiplier + (v.mult[id] or 0)
    end

    return total + (total * multiplier)
end

function World:addItem(itemId, count)
    count = count or 1

    assert(ItemDB[itemId].type ~= "key")

    -- 1. Does it already exist?
    for k, v in ipairs(self.items) do
        if v.id == itemId then
            -- 2. Yes, it does. Increment and exit.
            v.count = v.count + count
            return
        end
    end

    -- 3. No it does not exist.
    -- Add it as a new item.
    table.insert(self.items,
    {
        id = itemId,
        count = count
    })
end

function World:removeItem(itemId, amount)
    assert(ItemDB[itemId].type ~= "key")
    amount = amount or 1

    for i = #self.items, 1, -1 do
        local v = self.items[i]
        if v.id == itemId then
            v.count = v.count - amount
            assert(v.count >= 0) -- this should never happen
            if v.count == 0 then
                table.remove(self.items, i)
            end
            return
        end
    end

    assert(false) -- shouldn't ever get here!
end

function World:hasKey(itemId)
    for k, v in ipairs(self.keyitems) do
        if v.id == itemId then
            return true
        end
    end
    return false
end

function World:addKey(itemId)
    assert(not self:hasKey(itemId))
    table.insert(self.keyitems, {id = itemId})
end

function World:removeKey(itemId)
    for i = #self.keyitems, 1, -1 do
        local v = self.keyitems[i]

        if v.id == itemId then
            table.remove(self.keyitems, i)
            return
        end
    end
    assert(false) -- should never get here.
end

function World:addLoot(loot)
    for _, v in ipairs(loot) do
        self:addItem(v.id, v.count)
    end
end