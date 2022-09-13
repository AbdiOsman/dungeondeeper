Entity = {}
Entity.__index = Entity

function Entity.new(args, map)
    local this =
    {
        tileX = args.tileX,
        tileY = args.tileY,
        anim = args.anim,
        map = map,
        id = args.id,
        sightrange = args.sightrange,
        trigX = -1, -- triggerX
        trigY = -1, -- triggerY
        x = 0,  -- positionX
        y = 0,  -- positionY
        dx = 0, -- directionX
        dy = 0, -- directionY
        tx = 0, -- targetX
        ty = 0, -- targetY
        sx = 0, -- startX
        sy = 0, -- startY
        mx = 0, -- movementX
        my = 0, -- movementY
        sprite = Sprite.new(Texture.find("tileset.png")),
        movespeed = 0.3,
        move = false,
        bump = false,
        remove = false,
        tween = nil,
        casting = false,
        casttime = 0.1
    }

    setmetatable(this, Entity)

    this.state = this.planwait

    return this
end

function Entity:update(dt)
    if self.tween then
        self.tween:update(dt)
    end

    if self.move then
        local value = self.tween:value()
        local x = self.sx + (value * self.mx)
        local y = self.sy + (value * self.my)

        self.x = x
        self.y = y
    elseif self.bump then
        local value = self.tween:value()
        local x = self.sx + (value * self.mx)
        local y = self.sy + (value * self.my)

        self.x = x
        self.y = y
    end

    if self.tween and self.tween:isFinished() then
        self.tween = nil
        self.move = false

        if not self.bump then
            if self.player then
                local blocked = self.map:isBlocked(self.trigX, self.trigY)
                local trigger = self.map:getTrigger(self.trigX, self.trigY)
                -- gGame.handleInput = gGame.handleEnemies
                -- Should players be allowed to bump into walls to pass a turn?
                if self.casting then
                    self.casting = false
                    self:wait(self.casttime)
                elseif trigger and self.player then
                    trigger.onUse()
                    gGame.handleInput = gGame.handleEnemies
                elseif not blocked then
                    gGame.handleInput = gGame.handleEnemies
                end
                self.trigX, self.trigY = -1, -1
                STOPCAMERA = false
            end
        else
            self.tween = Tween.new(0, TILESIZE, 0.07)
            self.sx, self.sy = self:getPosition()
            self.trigX, self.trigY = self.tileX + self.dx, self.tileY + self.dy
            self.mx, self.my = -self.mx, -self.my
            self.move = true
            self.bump = false
        end
    end
end

function Entity:wait(time)
    self.tween = Tween.new(0, 1, time)
    self.sx, self.sy = self:getPosition()
    self.mx, self.my = 0, 0
    self.move = true
end

function Entity:movement(dx, dy, casting)
    if self.move or self.bump then
        return
    end

    self.dx, self.dy = dx, dy

    local blocked = self.map:isBlocked(self.tileX + dx, self.tileY + dy)
    local target = self.map:getEntity(self.tileX + dx, self.tileY + dy)

    if not blocked and not target and not casting then
        self.tween = Tween.new(0, TILESIZE, self.movespeed)
        self.sx, self.sy = self:getPosition()
        self.mx, self.my = dx, dy
        self.move = true
        self:setTilePos(self.tileX + dx, self.tileY + dy)
    elseif blocked or casting then
        self.tween = Tween.new(0, TILESIZE, 0.07)
        self.sx, self.sy = self:getPosition()
        self.mx, self.my = dx * 0.4, dy * 0.4
        self.casting = casting
        self.bump = true
        self.move = true
        STOPCAMERA = true
    elseif self.player and target and target.mob then
        self.tween = Tween.new(0, TILESIZE, 0.07)
        self.sx, self.sy = self:getPosition()
        self.mx, self.my = dx * 0.4, dy * 0.4
        self.bump = true
        self.move = true
        STOPCAMERA = true
        attack(self, target)
    end
end

function Entity:draw()
    local frame = self.anim[nextframe(self.anim, 15)]
    self.sprite:drawq(self.x, self.y, frame)
end

function Entity:setPosition(x, y)
    self.x = x
    self.y = y

    self.tileX, self.tileY = self.map:pointtotile(self.x, self.y)
end

function Entity:getPosition()
    return self.x, self.y
end

function Entity:centerPosition()
    local x = self.x + TILESIZE / 2
    local y = self.y + TILESIZE / 2
    return x, y
end

function Entity:setTilePos(x, y)
    -- Remove from current tile
    if self.map:getEntity(self.tileX, self.tileY) == self then
        self.map:removeEntity(self)
    end

    -- Check target tile
    if self.map:getEntity(x, y) ~= nil then
        assert(false) -- there's something in the target position!
    end

    self.tileX = x or self.tileX
    self.tileY = y or self.tileY

    self.map:addEntity(self)
end

function Entity:inSightRange(tx, ty)
    return lineofsite(self.tileX, self.tileY, tx, ty, self.map) and distance(self.tileX, self.tileY, tx, ty) <= self.sightrange
end

function Entity:planwait(target)
    local game = gGame

    if self:inSightRange(target.tileX, target.tileY) then
        self.state = self.planattack
        self.tx, self.ty = target.tileX, target.tileY

        local x, y = self:centerPosition()
        createFloatAt(x, y, "!")
    end
    game.handleInput = game.handleHero
end

function Entity:planattack(target)
    local best, bx, by = 9999, 0, 0

    if self.move or self.bump then
        return
    end

    -- get player position
    if lineofsite(self.tileX, self.tileY, target.tileX, target.tileY, self.map) then
        self.tx, self.ty = target.tileX, target.tileY
    end

    if self.tileX == self.tx and self.tileY == self.ty then
        self.state = self.planwait

        local x, y = self:centerPostition()
        createFloatAt(x, y, "?")
    else
        for i = 1, 4 do
            repeat
                local dx, dy = DIRX[i], DIRY[i]
                local blocked = self.map:isBlocked(self.tileX + dx, self.tileY + dy)
                local ent = self.map:getEntity(self.tileX + dx, self.tileY + dy)
                if ent and ent.mob then break end
                if not blocked or ent == target then
                    local dst = distance(self.tileX + dx, self.tileY + dy, self.tx, self.ty)
                    if dst < best then
                        best, bx, by = dst, dx, dy
                    end
                end
            until true
        end
    end

    if distance(self.tileX, self.tileY, target.tileX, target.tileY) == 1 then
        self.tween = Tween.new(0, TILESIZE, 0.07)
        self.sx, self.sy = self:getPosition()
        self.mx, self.my = bx * 0.4, by * 0.4
        self.bump = true
        self.move = true
        attack(self, target)
    else
        self:movement(bx, by)
    end
end