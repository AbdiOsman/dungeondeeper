GameOver = {}
GameOver.__index = GameOver

function GameOver.new(stack, game)
    local this =
    {
        stack = stack,
        game = game,
        tween = Tween.new(0, 1, 1)
    }

    setmetatable(this, GameOver)

    return this
end

function GameOver:update(dt)
    self.tween:update(dt)
    self.game:updatelayers(dt)

    if Input.justPressed("accept") and self.tween:isFinished() then
        gStack:pop()
        gStack:pop()
        gStack:push(Game.new(gStack, Map.new(createMap1()), { x = 3, y = 3 }))
    end
end

function GameOver:draw()
    love.graphics.setFont(Font.monogram_32)

    local h = Font.monogram_32:getHeight()

    love.graphics.setColor(0, 0, 0, self.tween:value())
    love.graphics.rectangle("fill", 0, 0, GW, GH)
    love.graphics.setColor(1, 1, 1, self.tween:value())
    love.graphics.printf("Game Over!", 0, (GH/2) - h/2, GW, "center")

    love.graphics.setFont(Font.monogram_16)

    h = Font.monogram_32:getHeight()
    love.graphics.printf("Press accept to continue.", 0, (GH/2) + h, GW, "center")
end

function GameOver:handleInput(dt)
end

function GameOver:enter() end
function GameOver:exit() end