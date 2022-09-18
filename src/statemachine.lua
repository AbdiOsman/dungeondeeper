StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states)
    local this =
	{
		empty =
		{
			Draw = function() end,
			Update = function() end,
			Enter = function() end,
			Exit = function() end
		},
		states = states or {}, -- [name] -> [function that returns state]
		current = nil,
	}

    this.states = states or {} -- [name] -> [function that returns state]

    this.current = this.empty or nil

    setmetatable(this, StateMachine)

    return this
end

function StateMachine:Change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:Exit()
	self.current = self.states[stateName]()
	self.current:Enter(enterParams)
end

function StateMachine:Update(dt)
	self.current:Update(dt)
end

function StateMachine:Draw(renderer)
	self.current:Draw(renderer)
end