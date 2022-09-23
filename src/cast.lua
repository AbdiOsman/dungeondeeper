Cast = {}
Cast.__index  = Cast

function Cast.new()
    local this =
    {
        panels =
        {
            invPanel = Panel.new({1, 0, 0}),
            descPanel = Panel.new(),
            namePanel = Panel.new(),
            statsPanel = Panel.new(),
        },
        char = gWorld:GetCurrentMember(),
        current = 1
    }

    setmetatable(this, Cast)

    this.panels.invPanel:CenterPosition(GW/2, GH/2, 135, 155)
    this.panels.descPanel:Position(GW/2 - 135/2, GH/2 - 155/2 - 29, 135, 30)
    this.panels.namePanel:Position(GW/2 + 135/2 + 1, GH/2 - 155/2 - 29, 60, 30)
    this.panels.statsPanel:Position(GW/2 + 135/2 + 1, GH/2 - 155/2, 150, 67)

    this.usePanel = Panel.new()

    local data = {}
    for _, v in ipairs(this.char.spells) do
        table.insert(data, v.id)
    end

    local x, y = this.panels.invPanel:GetAnchors()
    this.selection = Selection.new
    {
        x = x,
        y = y,
        width = 150,
        height = 155,
        rows = 25,
        data = data,
        ReMap = function (id)
            if not id then return end
            return SpellDB[id].name
        end,
        OnSelection = function(...) this:OnClick(...) end
    }

    x, y = this.panels.statsPanel:GetAnchors()
    this.statList = List.new
    {
        x = x,
        y = y,
        align = "right",
        width = 55,
        labels =
        {
            "Damage:",
            "Cost:",
            "Style:"
        },
        values =
        {
            "",
            "",
            ""
        }
    }

    return this
end

function Cast:Update(dt)
    if gGame.casting then
        if Input.JustPressed("accept") then
            local tx, ty = gGame:GetCastTarget()

            if gGame.map:InBounds(tx, ty) then
                local ent = gGame.map:GetEntity(tx, ty)
                if ent and ent.mob then
                    SpellCast(gGame.hero, ent, self.spell)
                else
                    local stats = gWorld.party[gGame.hero.id]
                    stats.stats.mp = stats.stats.mp - self.spell.mp_cost

                    if stats.stats.mp < 0 then
                        stats.stats.mp = 0
                    end
                end
            end

            gGame.hero:Movement(gGame.castX, gGame.castY, true)

            gGame.casting = nil
            gGame.castX, gGame.castY = 0, 1
            gStack:Pop()
        elseif Input.JustPressed("cancel") then
            gGame.casting = nil
        end
    else
        if Input.JustPressed("cancel") then
            gStack:Pop()
        else
            self.selection:HandleInput(dt)
        end
    end

    local spell = SpellDB[self.selection.data[self.selection.cursor]]
    if spell then
        self.statList.values =
        {
            spell.damage,
            spell.mp_cost .. " MP",
            spell.style
        }
    else
        self.statList.values = {}
    end
end

function Cast:HandleInput(dt)
    if gGame.casting then
        if Input.JustPressed("left") then
            gGame.castX = -1
            gGame.castY = 0
        elseif Input.JustPressed("right") then
            gGame.castX = 1
            gGame.castY = 0
        elseif Input.JustPressed("up") then
            gGame.castX = 0
            gGame.castY = -1
        elseif Input.JustPressed("down") then
            gGame.castX = 0
            gGame.castY = 1
        end
    end
end

function Cast:OnClick(index, id)
    if id then
        self.spell = SpellDB[id]
        local hero = gWorld.party[gGame.hero.id]
        local mp = gWorld:GetStat(hero, "mp")
        if mp - self.spell.mp_cost >= 0 then
            gGame.casting = self.spell.style
        end
    end
end

function Cast:Enter() end
function Cast:Exit() end

function Cast:Draw()
    if gGame.casting then return end

    for _, v in pairs(self.panels) do
        v:Draw()
    end

    self.statList:Drawv()

    self.selection:Draw()

    local left, top, right = self.panels.namePanel:GetAnchors()
    love.graphics.printf(self.char.name, left, top + 7, right - left, "center" )

    local data = self.selection.data[self.selection.cursor]
    if data then
        left, top, right = self.panels.descPanel:GetAnchors()
        love.graphics.printf(SpellDB[data].description, left + 4, top, (right - left) - 4, "left")
    end
end