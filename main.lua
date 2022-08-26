if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

gStack = nil
gWorld = nil

function love.load()
	require "src.startup.startup"

	resize(SCALE)

	gWorld = World.new()

	gStack = StateStack.new()
	gStack:push(Game.new(gStack, Map.new(createMap1()), { x = 3, y = 3 }))
end

function love.update(dt)
	TIME = TIME + 1
	gStack:update(dt)
	gWorld:update(dt)
	Input.update(dt)
	love.audio.update()
end

function love.draw()
	gStack:draw()
end

function newGame(map)
	gWorld.monsters = {}

	Actions.spawnmobs(10, 2, map)()
    Actions.spawnmobs(5, 3, map)()
    Actions.spawnmobs(5, 1, map)()
    Actions.spawnmobs(1, 1, map)()
    Actions.spawnmobs(1, 3, map)()
    Actions.spawnmobs(3, 5, map)()

	Actions.adddoor(4, 2, map)()
	Actions.adddoor(2, 6, map)()
	Actions.adddoor(5, 8, map)()

    Actions.addmsg(2, 3, map, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")()
end