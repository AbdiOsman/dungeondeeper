StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states)
    local this =
	{
		empty =
		{
			draw = function() end,
			update = function() end,
			enter = function() end,
			exit = function() end
		},
		states = states or {}, -- [name] -> [function that returns state]
		current = nil,
	}

    this.states = states or {} -- [name] -> [function that returns state]

    this.current = this.empty or nil

    setmetatable(this, StateMachine)

    return this
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:draw(renderer)
	self.current:draw(renderer)
end