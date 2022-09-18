Actions =
{
    SpawnMobs = function (x, y, map)
        return function (trigger, entity)
            local enemytable = { "slime" }
            local index = love.math.random(1, #enemytable)
            local entityDefs = gEntities[enemytable[index]]
            local ent = Entity.new(entityDefs, map)
            ent.id = #gWorld.monsters + 1
            ent.mob = true
            ent:SetPosition(x * TILESIZE, y * TILESIZE)
            map:AddEntity(ent)
            table.insert(map.mobs, ent)
            local statDef = ShallowClone(gEnemyStats[enemytable[index]])
            statDef.stats = ShallowClone(statDef.stats)
            table.insert(gWorld.monsters, statDef)
        end
    end,
    AddMsg = function(x, y, map, txt)
        return function(trigger, entity)
            local OnUse = function ()
                gStack:Push(CreateFixedBox(GW/2, GH/2, 200, 105, txt))
                Sound:Play("chest.wav")
            end

            trigger = { OnUse = OnUse }
            map:AddTrigger(trigger, x, y)
        end
    end,
    AddDoor = function (x, y, map)
        return function (trigger, entity)
            map.data[1].data[map:TileToIndex(x, y)] = 9

            local OnUse = function ()
                Sound:Play("door.wav")

                map:RemoveTrigger(x, y)
                map.data[1].data[map:TileToIndex(x, y)] = 10
            end

            trigger = { OnUse = OnUse }
            map:AddTrigger(trigger, x, y)
        end
    end
}