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

    this.menupanel:CenterPosition(GW/2 - 116, GH/2 - 38, 95, 80)
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
        OnSelection = function(...) this:OnClick(...) end
    }

    local left, _, _, bottom = this.menupanel:GetAnchors()
    this.timegold:Position(left, bottom + 1, 95, 32)
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
            gWorld:TimeAsString(),
            gWorld:GoldAsString(),
        }
    }

   return this
end

function Menu:Update(dt)
    self.timegoldList.values[1] = gWorld:TimeAsString()
    self.timegoldList.values[2] = gWorld:GoldAsString()

    if self.openedSubMenu then
        self.statemachine:Update(dt)
    else
        if Input.JustPressed("cancel") then
            gStack:Pop()
        end
    end
end

function Menu:HandleInput(dt)
    if not self.openedSubMenu then
        self.menuSelection:HandleInput(dt)
    end
end

function Menu:OnClick(index, id)
    if id == "Inventory" then
        self.statemachine:Change("inventory")
        self.openedSubMenu = true
    elseif id == "Settings" then
        self.statemachine:Change("settings")
        self.openedSubMenu = true
    end
end

function Menu:Enter() end
function Menu:Exit() end

function Menu:IsClosed()
end

function Menu:Draw()
    self.menupanel:Draw()
    self.timegold:Draw()
    self.menuSelection:Draw()
    self.timegoldList:Drawv()
    if self.openedSubMenu then
        self.statemachine:Draw()
    end
end