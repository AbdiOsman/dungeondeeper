Map = {}
Map.__index = Map

function Map.new(args)
    local this =
    {
        x = 0,
        y = 0,
        data = args.layers,
        height = args.height,
        width = args.width,
        props = args.tilesets[1].tiles,
        sprite = Sprite.new(Texture.Find("tileset.png")),
        entities = {},
        mobs = {},
        triggers = {}
    }

    this.pixelWidth = this.width * TILESIZE
    this.pixelHeight = this.height * TILESIZE

    setmetatable(this, Map)

    return this
end

function Map:Draw()
    local left, top = self:PointToTile(Camera._x, Camera._y)
    local right, bottom = self:PointToTile(Camera._x + GW, Camera._y + GH)

    for y = top, bottom do
        for x = left, right do
            local tile = self:Get(x, y)
            if tile == 0 then
                self.sprite:Drawq(x * TILESIZE, y * TILESIZE, 49)
            else
                self.sprite:Drawq(x * TILESIZE, y * TILESIZE, tile)
            end
        end
    end

    for _, v in pairs(self.entities) do
        v:Draw()
    end
end

function Map:Get(x, y)
    return self.data[1].data[self:TileToIndex(x, y)]
end

function Map:Set(x, y, value)
    layer = layer or 1
    self.data[1].data[self:TileToIndex(x, y)] = value
end

function Map:TileToIndex(x, y)
    x = x + 1
    return x + y * self.width
end

function Map:PointToTile(x, y)
    x = math.max(self.x, x)
    y = math.max(self.y, y)
    x = math.min(self.x + self.pixelWidth - 1, x)
    y = math.min(self.y + self.pixelHeight - 1, y)

    local tileX = math.floor((x - self.x) / TILESIZE)
    local tileY = math.floor((self.y + y) / TILESIZE)

    return tileX, tileY
end

function Map:GetTileProps(x, y)
    local tile = self:Get(x, y)
    for _, v in ipairs(self.props) do
        if v.id + 1 == tile then
            return v.properties
        end
    end
    return {}
end

function Map:IsBlocked(x, y)
    local props = self:GetTileProps(x, y)
    return props.blocker
end

function Map:IsWalkable(x, y)
    local props = self:GetTileProps(x, y)
    local index = self:TileToIndex(x, y)

    return not props.blocker and not self.entities[index]
end

function Map:BlockingSight(x, y)
    local props = self:GetTileProps(x, y)
    return props.blocksight
end


function Map:GetEntity(x, y)
    local index = self:TileToIndex(x, y)
    return self.entities[index]
end

function Map:AddEntity(entity)
    local index = self:TileToIndex(entity.tileX, entity.tileY)
    assert(self.entities[index] == entity or self.entities[index] == nil)
    self.entities[index] = entity
end

function Map:RemoveEntity(entity)
    local index = self:TileToIndex(entity.tileX, entity.tileY)
    -- The entity should be at the position
    assert(entity == self.entities[index])
    self.entities[index] = nil
end

function Map:AddTrigger(trigger, x, y)
    self.triggers[self:TileToIndex(x, y)] = trigger
end

function Map:RemoveTrigger(x, y)
    local index = self:TileToIndex(x, y)
    assert(self.triggers[index])
    self.triggers[index] = nil
end

function Map:GetTrigger(x, y)
    local index = self:TileToIndex(x, y)
    return self.triggers[index]
end

function Map:InBounds(x, y)
    return (x > 0 and x < self.width) and (y > 0 and y < self.height)
end