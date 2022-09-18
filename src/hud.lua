HUD = {}
HUD.__index  = HUD

function HUD.new(x, y, width, height)
    local this =
    {
        hp = Panel.new()
    }

    this.hp:Position(x, y, width, height)

    setmetatable(this, HUD)

    return this
end

function HUD:Draw(hero)
    love.graphics.setFont(Font.monogram_16)
    self.hp:Draw()
    local left, top = self.hp:GetAnchors()

    local stats = gWorld.party[hero.id].stats

    local str = ("[%s] HP:%i/%i MP:%i/%i")
    :format(gWorld.party[hero.id].name, stats.hp, stats.hp_max, stats.mp, stats.mp_max)
    love.graphics.print(str, left + 6, top + 4)
end