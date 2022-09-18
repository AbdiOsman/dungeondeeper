Game = {}
Game.__index = Game

function Game.new(stack, map, startpos)
    local this =
    {
        stack = stack,
        map = map,
        lower = {},
        upper = {},
        hud = HUD.new(450, 0, 189, 23),
        casting = nil,
        castX = 0,
        castY = 1
    }

    setmetatable(this, Game)

    local def = gEntities.hero
    this.hero = Entity.new(def, map)
    this.hero.id = 1
    this.hero:SetPosition(startpos.x * TILESIZE, startpos.y * TILESIZE)
    this.hero.player = true
    gWorld:GetCurrentMember().stats = ShallowClone(gPartyStats.hero)

    this.map:AddEntity(this.hero)

    this.HandleInput = this.HandleHero

    this.FogMap = this:CreateFog()

    NewGame(this.map)

    this:ClearFog(this.hero.tileX, this.hero.tileY)

    return this
end

function Game:Update(dt)
    if Input.JustPressed("cancel") then
        gStack:Push(Menu.new())
    elseif Input.JustPressed("cast") then
        gStack:Push(Cast.new())
    end
    self:UpdateLayers(dt)
    for _, v in pairs(self.map.entities) do
        v:Update(dt)
    end
    if not STOPCAMERA then
        Camera:SetPosition(self.hero.x - (GW/2)/SCALE, self.hero.y - (GH/2)/SCALE)
    end
end

function Game:UpdateLayers(dt)
    for _, v in pairs(self.lower) do
        v:Update(dt)
    end
    for i = #self.lower, 1, -1 do
        if self.lower[i].remove then
            table.remove(self.lower, i)
        end
    end
    for _, v in pairs(self.upper) do
        v:Update(dt)
    end
    for i = #self.upper, 1, -1 do
        if self.upper[i].remove then
            table.remove(self.upper, i)
        end
    end
end

function Game:Draw()
    Camera:Attach()
        self.map:Draw()
        for _, v in pairs(self.lower) do
            v:Draw()
        end
        self:DrawFog()
        for _, v in pairs(self.upper) do
            v:Draw()
        end
        if self.casting then
            self:DrawCast()
        end
    Camera:Detach()
    self.hud:Draw(self.hero)
    -- self:PrintInfo()
end

function DashLine( p1, p2, dash, gap )
	local dy, dx = p2.y - p1.y, p2.x - p1.x
	local an, st = math.atan2( dy, dx ), dash + gap
	local len = math.sqrt( dx*dx + dy*dy )
	local nm = ( len - dash ) / st

	love.graphics.push()
	love.graphics.translate( p1.x, p1.y )
	love.graphics.rotate( an )
	for i = 0, nm do
		love.graphics.line( i * st, 0, i * st + dash, 0 )
	end
	love.graphics.line( nm * st, 0, nm * st + dash,0 )
	love.graphics.pop()
end

function Game:DrawCast()
    if self.casting == "line" then
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(2)
        -- love.graphics.line
        local x, y = self.hero:CenterPosition()
        local tx, ty = self:GetCastTarget()

        local p1 = { x = x + self.castX * 8, y = y + self.castY * 8 }
        local p2 = { x = tx * TILESIZE + TILESIZE/2, y = ty * TILESIZE + TILESIZE/2 }

        love.graphics.setColor(0, 0, 0)
        love.graphics.line(p1.x + self.castY, p1.y + self.castX, p2.x + self.castY, p2.y + self.castX)
        love.graphics.line(p1.x - self.castY, p1.y - self.castX, p2.x - self.castY, p2.y - self.castX)

        love.graphics.setColor(1, 1, 1)
        DashLine(p1, p2, 3, 4)
        self.map.sprite:Drawq(tx * TILESIZE, ty * TILESIZE, 11)
    end
end

function Game:GetCastTarget()
    local x, y = self.hero.tileX + self.castX, self.hero.tileY + self.castY

    while self.map:IsWalkable(x, y) do
        x = x + self.castX
        y = y + self.castY
    end

    return x, y
end

function Game:DrawFog()
    for x = 0, self.map.width do
        for y = 0, self.map.height do
            if self.FogMap[x][y] == 1 then
                love.graphics.setColor(0, 0, 0, self.FogMap[x][y])
                love.graphics.rectangle("fill", x * TILESIZE, y * TILESIZE, TILESIZE, TILESIZE)
            end
        end
    end
end

function Game:ClearFog(px, py)
    for x = 0, self.map.width do
        for y = 0, self.map.height do
            if Distance(px, py, x, y) <= self.hero.sightrange and LineOfSite(px, py, x, y, self.map) then
                self:ClearFogTile(x, y)
            end
        end
    end
end

function Game:ClearFogTile(x, y)
    self.FogMap[x][y] = 0
    if not self.map:BlockingSight(x, y) then
        for i = 1, 4 do
            local tx, ty = x + DIRX[i], y + DIRY[i]
            if self.map:BlockingSight(tx, ty) and self.map:InBounds(x, y) then
                self.FogMap[tx][ty] = 0
            end
        end
    end
end

function Game:CreateFog()
    local result = {}

    for x = 0, self.map.height do
        result[x] = {}
        for y = 0, self.map.width do
            result[x][y] = 1
        end
    end

    return result
end

function Game:HandleHero()
    local inputs = {}
    if Input.Held("up") then
        table.insert(inputs, {0, -1})
    end
    if Input.Held("down") then
        table.insert(inputs, {0, 1})
    end
    if Input.Held("left") then
        table.insert(inputs, {-1, 0})
    end
    if Input.Held("right") then
        table.insert(inputs, {1, 0})
    end

    if #inputs > 0 then
        self.hero:Movement(inputs[1][1], inputs[1][2])
        self:ClearFog(self.hero.tileX, self.hero.tileY)
    end
end

function Game:HandleEnemies()
    if #self.map.mobs == 0 then
        self.HandleInput = self.HandleHero
    end
    for i = #self.map.mobs, 1, -1 do
        if not self.map.mobs[i].remove then
            self.map.mobs[i]:State(self.hero)
        else
            self.map:RemoveEntity(self.map.mobs[i])
            table.remove(self.map.mobs, i)
        end
    end

    self.HandleInput = self.HandleHero
end

function Game:Enter() end
function Game:Exit() end

function Game:PrintInfo()
    love.graphics.setFont(Font.monogram_16)
    local str = ("%i %i, %.2f, %.2f, FPS: %i")
    :format(self.hero.tileX, self.hero.tileY, self.hero.x, self.hero.y, love.timer.getFPS())
    love.graphics.setFont(Font.monogram_32)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(str, 0, GH-35)
end