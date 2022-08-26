Menu = {}
Menu.__index  = Menu

function Menu.new()
   local this =
   {
        menupanel = Panel.new(),
        timegold = Panel.new(),
        openedSubMenu = nil
   }

   setmetatable(this, Menu)

   this.statemachine = StateMachine.new
   {
        ["inventory"] =
        function ()
            return Inventory.new(this)
        end,
        ["settings"] =
        function ()
            return Settings.new(this)
        end
    }

    this.menupanel:centerPosition(GW/2 - 116, GH/2 - 38, 95, 80)
    this.menuSelection =
    Selection.new
    {
        x = GW/2 - 165,
        y = GH/2 - 80,
        width = 80,
        height = 80,
        rows = 2,
        displayrows = 2,
        data = { "Inventory", "Settings" },
        onSelection = function(...) this:onClick(...) end
    }

    local left, _, _, bottom = this.menupanel:getAnchors()
    this.timegold:position(left, bottom + 1, 95, 32)
    this.timegoldList = List.new
    {
        x = left + 4,
        y = bottom,
        align = "left",
        width = 30,
        labels =
        {
            "Time:",
            "Gold:",
        },
        values =
        {
            gWorld:timeAsString(),
            gWorld:goldAsString(),
        }
    }

   return this
end

function Menu:update(dt)
    self.timegoldList.values[1] = gWorld:timeAsString()
    self.timegoldList.values[2] = gWorld:goldAsString()

    if self.openedSubMenu then
        self.statemachine:update(dt)
    else
        if Input.justPressed("cancel") then
            gStack:pop()
        end
    end
end

function Menu:handleInput(dt)
    if not self.openedSubMenu then
        self.menuSelection:handleInput(dt)
    end
end

function Menu:onClick(index, id)
    if id == "Inventory" then
        self.statemachine:change("inventory")
        self.openedSubMenu = true
    elseif id == "Settings" then
        self.statemachine:change("settings")
        self.openedSubMenu = true
    end
end

function Menu:enter() end
function Menu:exit() end

function Menu:isClosed()
end

function Menu:draw()
    self.menupanel:draw()
    self.timegold:draw()
    self.menuSelection:draw()
    self.timegoldList:drawv()
    if self.openedSubMenu then
        self.statemachine:draw()
    end
end