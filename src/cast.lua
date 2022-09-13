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
        char = gWorld:getCurrentMember(),
        current = 1
    }

    setmetatable(this, Cast)

    this.panels.invPanel:centerPosition(GW/2, GH/2, 135, 155)
    this.panels.descPanel:position(GW/2 - 135/2, GH/2 - 155/2 - 29, 135, 30)
    this.panels.namePanel:position(GW/2 + 135/2 + 1, GH/2 - 155/2 - 29, 60, 30)
    this.panels.statsPanel:position(GW/2 + 135/2 + 1, GH/2 - 155/2, 150, 67)

    this.usePanel = Panel.new()

    local data = {}
    for _, v in ipairs(this.char.spells) do
        table.insert(data, v.id)
    end

    local x, y = this.panels.invPanel:getAnchors()
    this.selection = Selection.new
    {
        x = x,
        y = y,
        width = 150,
        height = 155,
        rows = 25,
        data = data,
        remap = function (id)
            if not id then return end
            return SpellDB[id].name
        end,
        onSelection = function(...) this:onClick(...) end
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

function Cast:update(dt)
    if gGame.casting then
        if Input.justPressed("accept") then
            local tx, ty = gGame:getCastTarget()

            if gGame.map:inBounds(tx, ty) then
                local ent = gGame.map:getEntity(tx, ty)
                if ent then
                    spellCast(gGame.hero, ent, self.spell)
                end
            end

            gGame.hero:movement(gGame.castX, gGame.castY, true)

            gGame.casting = nil
            gGame.castX, gGame.castY = 0, 1
            gStack:pop()
        elseif Input.justPressed("cancel") then
            gGame.casting = nil
        end
    else
        if Input.justPressed("cancel") then
            gStack:pop()
        else
            self.selection:handleInput(dt)
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

function Cast:handleInput(dt)
    if gGame.casting then
        if Input.justPressed("left") then
            gGame.castX = -1
            gGame.castY = 0
        elseif Input.justPressed("right") then
            gGame.castX = 1
            gGame.castY = 0
        elseif Input.justPressed("up") then
            gGame.castX = 0
            gGame.castY = -1
        elseif Input.justPressed("down") then
            gGame.castX = 0
            gGame.castY = 1
        end
    end
end

function Cast:onClick(index, id)
    if id then
        self.spell = SpellDB[id]
        local hero = gWorld.party[gGame.hero.id]
        local mp = gWorld:getStat(hero, "mp")
        print(mp - self.spell.mp_cost)
        if mp - self.spell.mp_cost >= 0 then
            gGame.casting = self.spell.style
        end
    end
end

function Cast:enter() end
function Cast:exit() end

function Cast:draw()
    if gGame.casting then return end

    for _, v in pairs(self.panels) do
        v:draw()
    end

    self.statList:drawv()

    self.selection:draw()

    local left, top, right = self.panels.namePanel:getAnchors()
    love.graphics.printf(self.char.name, left, top + 7, right - left, "center" )

    local data = self.selection.data[self.selection.cursor]
    if data then
        left, top, right = self.panels.descPanel:getAnchors()
        love.graphics.printf(SpellDB[data].description, left + 4, top, (right - left) - 4, "left")
    end
end