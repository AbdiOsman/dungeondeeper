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
        name = "Short Sword",
        type = "weapon",
        icon = "sword",
        restriction = {},
        description = "A standard sword great for beginners.",
        stats = { add = { attack = 5 } }
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
        description = "Heals a minor amount. +1 HP"
    },
    {
        name = "Mushroom",
        type = "useable",
        description = "Restores a minor amount. +1 MP"
    }
}

EmptyItem = ItemDB[-1]

-- Give all items an id based on their position
-- in the list.
for id, def in pairs(ItemDB) do
    def.id = id
end