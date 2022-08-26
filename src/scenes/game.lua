Game = {}
Game.__index = Game

function Game.new(stack, map, startpos)
    local this =
    {
        stack = stack,
        map = map,
        lower = {},
        upper = {},
        hud = HUD.new(450, 0, 189, 23)
    }

    setmetatable(this, Game)

    Camera:setScale(2, 2)
    Camera:setBounds(0, 0, TILESIZE * 2, TILESIZE * 2)

    local def = gEntities.hero
    this.hero = Entity.new(def, map)
    this.hero.id = 1
    this.hero:setPosition(startpos.x * TILESIZE, startpos.y * TILESIZE)
    this.hero.player = true
    gWorld.party[1].stats = shallowClone(gPartyStats.hero)

    this.map:addEntity(this.hero)
    this.map:lookat(this.hero.tileX, this.hero.tileY)

    this.handleInput = this.handleHero

    this.fogmap = this:createFog()

    newGame(this.map)

    this:clearFog(this.hero.tileX, this.hero.tileY)

    return this
end

function Game:update(dt)
    if Input.justPressed("cancel") then
        gStack:push(Menu.new())
    end
    self:updatelayers(dt)
    for _, v in pairs(self.map.entities) do
        v:update(dt)
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
    Camera:detach()
    self.hud:draw(self.hero)
    -- self:printInfo()
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
    local dx, dy = 0, 0
    if Input.held("up") then
        dy = -1
    elseif Input.held("down") then
        dy = 1
    elseif Input.held("left") then
        dx = -1
    elseif Input.held("right") then
        dx = 1
    end

    if dx ~= 0 or dy ~= 0 then
        self.hero:movement(dx, dy)
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