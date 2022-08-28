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

    local attack = math.max(love.math.random(0, 1), damage - defense)
    local hp = start_hp - attack

    print("HP:" .. start_hp .. " > " .. hp)

    if hp <= 0  then
        defender.remove = true
    else
        def.stats.hp = hp
    end

    love.audio.play("hit.wav")
    defender.sprite.flashtime = 12

    local x, y = defender:centerPostition()
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