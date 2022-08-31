ItemDB =
{
    [-1] =
    {
        name = "",
        type = "",
        icon = nil,
        restriction = nil,
        description = "",
        stats =
        {
        },
        use = nil,
        use_restriction = nil,
    },
    {
        name = "Wood Staff",
        type = "weapon",
        icon = "sword",
        restriction = {},
        description = "Staff made of wood. It's pretty weak.",
        stats = { add = { strength = 1, magic = 1 } }
    },
    {
        name = "Iron Staff",
        type = "weapon",
        icon = "sword",
        restriction = {},
        description = "A simple staff great for beginners.",
        stats = { add = { strength = 3, magic = 3 } }
    },
    {
        name = "Rags",
        type = "armor",
        icon = "plate",
        restriction = {},
        description = "You can barley call these clothes.",
    },
    {
        name = "Leather Armor",
        type = "armor",
        icon = "plate",
        restriction = {},
        description = "The most basic starting armor.",
        stats =
        {
            add =
            {
                defense = 5,
                resist = 1,
            }
        }
    },
    {
        name = "Bale Leaf",
        type = "useable",
        description = "Heals a minor amount. +1 HP",
        use =
        {
            hp = 1,
            hint = "Choose target to heal."
        }
    },
    {
        name = "Mushroom",
        type = "useable",
        description = "Restores a minor amount. +1 MP",
        use =
        {
            mp = 1,
            hint = "Choose target to heal."
        }
    }
}

EmptyItem = ItemDB[-1]

-- Give all items an id based on their position
-- in the list.
for id, def in pairs(ItemDB) do
    def.id = id
end