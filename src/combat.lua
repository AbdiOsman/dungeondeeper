function attack(attacker, defender)
    local attackerStats
    local defenderStats

    if attacker.player then
        attackerStats = gWorld.party[attacker.id].stats
        defenderStats = gWorld.monsters[defender.id]
    elseif attacker.mob then
        attackerStats = gWorld.monsters[attacker.id]
        defenderStats = gWorld.party[defender.id].stats
    end

    local hp = defenderStats.hp

    if defenderStats.hp <= 0 then return end
    defenderStats.hp = defenderStats.hp - attackerStats.strength
    local x, y = defender:centerPostition()
    if defenderStats.hp <= 0  then
        defender.remove = true
    end
    love.audio.play("hit.wav")
    defender.sprite.flashtime = 12
    createFloatAt(x, y, "-" .. attackerStats.strength, RED)

    print("HP:" .. hp .. " > " .. defenderStats.hp)

    if defender.player then
        if defenderStats.hp <= 0 then
            local game = gStack:top()
            gStack:push(GameOver.new(gStack, game))
        end
    end
end