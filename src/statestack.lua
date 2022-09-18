StateStack = {}
StateStack.__index = StateStack

function StateStack.new()
    local this =
    {
        states = {},
        main_canvas = love.graphics.newCanvas(GW, GH)
    }

    setmetatable(this, StateStack)

    return this
end

function StateStack:Update(dt)
    -- Update them and check input
    for k = #self.states, 1, -1 do
        local v = self.states[k]
        local continue = v:Update(dt)
        if not continue then
            break
        end
    end

    local top = self.states[#self.states]

    if not top then
        return
    end

    top:HandleInput(dt)
end

function StateStack:Draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        for _, v in ipairs(self.states) do
            v:Draw()
        end
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, SCALE, SCALE)
    love.graphics.setBlendMode('alpha')
end

function StateStack:Push(state)
    table.insert(self.states, state)
    state:Enter()
end

function StateStack:Pop()
    local top = self.states[#self.states]
    table.remove(self.states)
    top:Exit()
    return top
end

function StateStack:Top()
    return self.states[#self.states]
end