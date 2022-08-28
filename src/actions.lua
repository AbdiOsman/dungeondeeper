Actions =
{
    spawnmobs = function (x, y, map)
        return function (trigger, entity)
            local enemytable = { "slime" }
            local index = love.math.random(1, #enemytable)
            local entityDefs = gEntities[enemytable[index]]
            local ent = Entity.new(entityDefs, map)
            ent.id = #gWorld.monsters + 1
            ent.mob = true
            ent:setPosition(x * TILESIZE, y * TILESIZE)
            map:addEntity(ent)
            table.insert(map.mobs, ent)
            local statDef = shallowClone(gEnemyStats[enemytable[index]])
            statDef.stats = shallowClone(statDef.stats)
            table.insert(gWorld.monsters, statDef)
        end
    end,
    addmsg = function(x, y, map, txt)
        return function(trigger, entity)
            local onUse = function ()
                gStack:push(createFixedBox(GW/2, GH/2, 200, 105, txt))
                love.audio.play("chest.wav")
            end

            trigger = { onUse = onUse }
            map:addTrigger(trigger, x, y)
        end
    end,
    adddoor = function (x, y, map)
        return function (trigger, entity)
            map.data[1].data[map:tiletoindex(x, y)] = 9

            local onUse = function ()
                love.audio.play("door.wav")

                map:removeTrigger(x, y)
                map.data[1].data[map:tiletoindex(x, y)] = 10
            end

            trigger = { onUse = onUse }
            map:addTrigger(trigger, x, y)
        end
    end
}