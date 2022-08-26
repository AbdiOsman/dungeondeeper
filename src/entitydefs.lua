gEntities =
{
    hero = {
        texture = "tileset.png",
        tileX = 1,
        tileY = 1,
        anim = {17, 18, 17, 19}
    },
    slime = {
        texture = "tileset.png",
        tileX = 1,
        tileY = 3,
        anim = {20, 21, 22, 23}
    },
    pickup =
    {
        texture = "tileset.png",
        anim = { 11, 12 },
    },
    chest1 =
    {
        texture = "tileset.png",
        anim = { 4 },
        sound = "chest.wav"
    },
    chest2 =
    {
        texture = "tileset.png",
        anim = { 5 },
        sound = "chest.wav"

    },
    vase1 =
    {
        texture = "tileset.png",
        anim = { 6 },
        sound = "vase.wav"
    },
    vase2 =
    {
        texture = "tileset.png",
        anim = { 7 },
        sound = "vase.wav"
    },
    door =
    {
        texture = "tileset.png",
        anim = { 9 },
        openFrame = 10,
        sound = "door.wav"
    }
}

gPartyStats =
{
    hero =
    {
        hp = 5,
        hp_max = 5,
        mp = 1,
        mp_max = 1,
        strength = 1,
        defense = 1,
        magic = 1,
        resist = 1
    }
}

gEnemyStats =
{
    slime =
    {
        hp = 1,
        hp_max = 1,
        mp = 0,
        mp_max = 0,
        strength = 1,
        defense = 1,
        magic = 0,
        resist = 0
    }
}