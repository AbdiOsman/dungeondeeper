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

function StateStack:update(dt)
    -- update them and check input
    for k = #self.states, 1, -1 do
        local v = self.states[k]
        local continue = v:update(dt)
        if not continue then
            break
        end
    end

    local top = self.states[#self.states]

    if not top then
        return
    end

    top:handleInput(dt)
end

function StateStack:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        for _, v in ipairs(self.states) do
            v:draw()
        end
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, SCALE, SCALE)
    love.graphics.setBlendMode('alpha')
end

function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

function StateStack:pop()
    local top = self.states[#self.states]
    table.remove(self.states)
    top:exit()
    return top
end

function StateStack:top()
    return self.states[#self.states]
end