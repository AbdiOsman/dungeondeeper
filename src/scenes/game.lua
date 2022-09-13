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
    this.hero:setPosition(startpos.x * TILESIZE, startpos.y * TILESIZE)
    this.hero.player = true
    gWorld:getCurrentMember().stats = shallowClone(gPartyStats.hero)

    this.map:addEntity(this.hero)

    this.handleInput = this.handleHero

    this.fogmap = this:createFog()

    newGame(this.map)

    this:clearFog(this.hero.tileX, this.hero.tileY)

    return this
end

function Game:update(dt)
    if Input.justPressed("cancel") then
        gStack:push(Menu.new())
    elseif Input.justPressed("cast") then
        gStack:push(Cast.new())
    end
    self:updatelayers(dt)
    for _, v in pairs(self.map.entities) do
        v:update(dt)
    end
    if not STOPCAMERA then
        Camera:setPosition(self.hero.x - (GW/2)/SCALE, self.hero.y - (GH/2)/SCALE)
    end
end

function Game:updatelayers(dt)
    for _, v in pairs(self.lower) do
        v:update(dt)
    end
    for i = #self.lower, 1, -1 do
        if self.lower[i].remove then
            table.remove(self.lower, i)
        end
    end
    for _, v in pairs(self.upper) do
        v:update(dt)
    end
    for i = #self.upper, 1, -1 do
        if self.upper[i].remove then
            table.remove(self.upper, i)
        end
    end
end

function Game:draw()
    Camera:attach()
        self.map:draw()
        for _, v in pairs(self.lower) do
            v:draw()
        end
        self:drawfog()
        for _, v in pairs(self.upper) do
            v:draw()
        end
        if self.casting then
            self:drawcast()
        end
    Camera:detach()
    self.hud:draw(self.hero)
    -- self:printInfo()
end

function dashLine( p1, p2, dash, gap )
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

function Game:drawcast()
    if self.casting == "line" then
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(2)
        -- love.graphics.line
        local x, y = self.hero:centerPosition()
        local tx, ty = self:getCastTarget()

        local p1 = { x = x + self.castX * 8, y = y + self.castY * 8 }
        local p2 = { x = tx * TILESIZE + TILESIZE/2, y = ty * TILESIZE + TILESIZE/2 }

        love.graphics.setColor(0, 0, 0)
        love.graphics.line(p1.x + self.castY, p1.y + self.castX, p2.x + self.castY, p2.y + self.castX)
        love.graphics.line(p1.x - self.castY, p1.y - self.castX, p2.x - self.castY, p2.y - self.castX)

        love.graphics.setColor(1, 1, 1)
        dashLine(p1, p2, 3, 4)
        self.map.sprite:drawq(tx * TILESIZE, ty * TILESIZE, 11)
    end
end

function Game:getCastTarget()
    local x, y = self.hero.tileX + self.castX, self.hero.tileY + self.castY

    while self.map:isWalkable(x, y) do
        x = x + self.castX
        y = y + self.castY
    end

    return x, y
end

function Game:drawfog()
    for x = 0, self.map.width do
        for y = 0, self.map.height do
            if self.fogmap[x][y] == 1 then
                love.graphics.setColor(0, 0, 0, self.fogmap[x][y])
                love.graphics.rectangle("fill", x * TILESIZE, y * TILESIZE, TILESIZE, TILESIZE)
            end
        end
    end
end

function Game:clearFog(px, py)
    for x = 0, self.map.width do
        for y = 0, self.map.height do
            if distance(px, py, x, y) <= self.hero.sightrange and lineofsite(px, py, x, y, self.map) then
                self:clearFogTile(x, y)
            end
        end
    end
end

function Game:clearFogTile(x, y)
    self.fogmap[x][y] = 0
    if not self.map:blockingSight(x, y) then
        for i = 1, 4 do
            local tx, ty = x + DIRX[i], y + DIRY[i]
            if self.map:blockingSight(tx, ty) and self.map:inBounds(x, y) then
                self.fogmap[tx][ty] = 0
            end
        end
    end
end

function Game:createFog()
    local result = {}

    for x = 0, self.map.height do
        result[x] = {}
        for y = 0, self.map.width do
            result[x][y] = 1
        end
    end

    return result
end

function Game:handleHero()
    local inputs = {}
    if Input.held("up") then
        table.insert(inputs, {0, -1})
    end
    if Input.held("down") then
        table.insert(inputs, {0, 1})
    end
    if Input.held("left") then
        table.insert(inputs, {-1, 0})
    end
    if Input.held("right") then
        table.insert(inputs, {1, 0})
    end

    if #inputs > 0 then
        self.hero:movement(inputs[1][1], inputs[1][2])
        self:clearFog(self.hero.tileX, self.hero.tileY)
    end
end

function Game:handleEnemies()
    if #self.map.mobs == 0 then
        self.handleInput = self.handleHero
    end
    for i = #self.map.mobs, 1, -1 do
        if not self.map.mobs[i].remove then
            self.map.mobs[i]:state(self.hero)
        else
            self.map:removeEntity(self.map.mobs[i])
            table.remove(self.map.mobs, i)
        end
    end

    self.handleInput = self.handleHero
end

function Game:enter() end
function Game:exit() end

function Game:printInfo()
    love.graphics.setFont(Font.monogram_16)
    local str = ("%i %i, %.2f, %.2f, FPS: %i")
    :format(self.hero.tileX, self.hero.tileY, self.hero.x, self.hero.y, love.timer.getFPS())
    love.graphics.setFont(Font.monogram_32)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(str, 0, GH-35)
end