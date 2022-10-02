gEntities =
{
    hero = {
        texture = "tileset.png",
        tileX = 1,
        tileY = 1,
        sightrange = 4,
        anim = {91, 92, 93}
    },
    slime = {
        texture = "tileset.png",
        tileX = 1,
        tileY = 3,
        sightrange = 4,
        anim = {64, 65}
    },
    door = {
        texture = "tileset.png",
        closed = 11,
        open = 12
    }
}

gIcons =
{
    arrowdown = 76,
    arrowright = 77,
    arrowup = 78,
}

gPartyStats =
{
    hero =
    {
        hp = 5,
        hp_max = 5,
        mp = 2,
        mp_max = 2,
        strength = 2,
        defense = 2,
        magic = 5,
        resist = 5
    }
}

gEnemyStats =
{
    slime =
    {
        stats =
        {
            hp = 1,
            hp_max = 1,
            mp = 0,
            mp_max = 0,
            strength = 1,
            defense = 1,
            magic = 1,
            resist = 1
        }
    }
}