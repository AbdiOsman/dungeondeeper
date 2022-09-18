if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

gStack = nil
gWorld = nil
gGame = nil
gExplore = nil

function love.load()
	require "src.startup.startup"

	Resize(SCALE)

	gWorld = World.new()

	gStack = StateStack.new()

	gGame = Game.new(gStack, Map.new(require "data.maps.map_1"), { x = 2, y = 3 })
	gStack:Push(gGame)
end

function love.update(dt)
	TIME = TIME + 1
	gStack:Update(dt)
	gWorld:Update(dt)
	Test()
	Input.Update(dt)
	Sound:Update()
end

function love.draw()
	gStack:Draw()
end

function NewGame(map)
	gWorld.monsters = {}
    Actions.SpawnMobs(1, 7, map)()
    Actions.SpawnMobs(1, 9, map)()
    Actions.SpawnMobs(3, 7, map)()
    Actions.SpawnMobs(5, 7, map)()

	Actions.AddDoor(2, 4, map)()
	Actions.AddDoor(2, 8, map)()
	Actions.AddDoor(4, 9, map)()
	Actions.AddDoor(9, 7, map)()
	Actions.AddDoor(10, 2, map)()
	Actions.AddDoor(10, 6, map)()

    Actions.AddMsg(2, 2, map, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")()
end

function Test()
	if Input.JustPressed("f1") then
		print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = TypeCount()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
	elseif Input.JustPressed("f2") then
		SCALE = SCALE % 2 + 1
		Resize(SCALE)
	end
end