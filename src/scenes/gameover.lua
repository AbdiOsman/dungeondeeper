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

function GameOver:Update(dt)
    self.tween:Update(dt)
    self.game:UpdateLayers(dt)

    if Input.JustPressed("accept") and self.tween:IsFinished() then
        gStack:Pop()
        gStack:Pop()
        gGame = Game.new(gStack, Map.new(require "data.maps.map_1"), { x = 2, y = 3 })
        gStack:Push(gGame)
    end
end

function GameOver:Draw()
    love.graphics.setFont(Font.monogram_32)

    local h = Font.monogram_32:getHeight()

    love.graphics.setColor(0, 0, 0, self.tween:Value())
    love.graphics.rectangle("fill", 0, 0, GW, GH)
    love.graphics.setColor(1, 1, 1, self.tween:Value())
    love.graphics.printf("Game Over!", 0, (GH/2) - h/2, GW, "center")

    love.graphics.setFont(Font.monogram_16)

    h = Font.monogram_32:getHeight()
    love.graphics.printf("Press accept to continue.", 0, (GH/2) + h, GW, "center")
end

function GameOver:HandleInput(dt)
end

function GameOver:Enter() end
function GameOver:Exit() end