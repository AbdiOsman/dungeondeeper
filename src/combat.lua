function attack(attacker, defender)
    local atk
    local def
    if attacker.player then
        atk = gWorld.party[attacker.id]
        def = gWorld.monsters[defender.id]
    elseif attacker.mob then
        atk = gWorld.monsters[attacker.id]
        def = gWorld.party[defender.id]
    end

    local start_hp = def.stats.hp
    local damage = gWorld:getStat(atk, "strength")
    local defense = gWorld:getStat(def, "defense")

    local rand = love.math.random(1, 100)
    local min = rand < 15 and 0 or 1 -- if attack < 0 chance to do a min of 1 attack
    local attack = math.max(min, damage - defense)
    local hp = start_hp - attack

    print("HP:" .. start_hp .. " > " .. hp)

    if hp <= 0  then
        defender.remove = true
    else
        def.stats.hp = hp
    end

    love.audio.play("hit.wav")
    defender.sprite.flashtime = 12

    local x, y = defender:centerPosition()
    if attack == 0 then
        createFloatAt(x, y, "MISS!", 0.6, RED)
    else
        createFloatAt(x, y, "-" .. attack, nil, RED)
    end

    if defender.player then
        if hp <= 0 then
            local game = gStack:top()
            gStack:push(GameOver.new(gStack, game))
        end
    end
end

function spellCast(attacker, defender, spell)
    local atk
    local def
    if attacker.player then
        atk = gWorld.party[attacker.id]
        def = gWorld.monsters[defender.id]
    elseif attacker.mob then
        atk = gWorld.monsters[attacker.id]
        def = gWorld.party[defender.id]
    end

    local start_hp = def.stats.hp
    local damage = 0
    local defense = 0

    if spell.element == "none" then
        damage = (gWorld:getStat(atk, "magic") * 0.4) + spell.damage
        defense = gWorld:getStat(def, "resist")
    else
    end

    local rand = love.math.random(1, 100)
    local min = rand < 15 and 0 or 1 -- if attack < 0 chance to do a min of 1 attack
    local attack = math.max(min, math.ceil(damage) - defense)
    local hp = start_hp - attack

    print("HP:" .. start_hp .. " > " .. hp)

    atk.stats.mp = atk.stats.mp - spell.mp_cost

    if atk.stats.mp < 0 then
        atk.stats.mp = 0
    end

    if hp <= 0  then
        defender.remove = true
    else
        def.stats.hp = hp
    end

    love.audio.play("hit.wav")
    defender.sprite.flashtime = 12

    local x, y = defender:centerPosition()
    if attack == 0 then
        createFloatAt(x, y, "MISS!", 0.6, RED)
    else
        createFloatAt(x, y, "-" .. attack, nil, RED)
    end

    if defender.player then
        if hp <= 0 then
            local game = gStack:top()
            gStack:push(GameOver.new(gStack, game))
        end
    end
end