if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

gStack = nil
gWorld = nil

function love.load()
	require "src.startup.startup"

	resize(SCALE)

	gWorld = World.new()

	gStack = StateStack.new()
	gStack:push(Game.new(gStack, Map.new(require "data.maps.map_1"), { x = 2, y = 3 }))
end

function love.update(dt)
	TIME = TIME + 1
	gStack:update(dt)
	gWorld:update(dt)
	debug()
	Input.update(dt)
	love.audio.update()
end

function love.draw()
	gStack:draw()
end

function newGame(map)
	gWorld.monsters = {}
    Actions.spawnmobs(1, 7, map)()
    Actions.spawnmobs(1, 9, map)()
    Actions.spawnmobs(3, 7, map)()
    Actions.spawnmobs(5, 7, map)()

	Actions.adddoor(2, 4, map)()
	Actions.adddoor(2, 8, map)()
	Actions.adddoor(4, 9, map)()
	Actions.adddoor(9, 7, map)()
	Actions.adddoor(10, 2, map)()
	Actions.adddoor(10, 6, map)()

    Actions.addmsg(2, 2, map, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")()
end

function debug()
	if Input.justPressed("f1") then
		print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
	elseif Input.justPressed("f2") then
		SCALE = SCALE % 2 + 1
		resize(SCALE)
	end
end