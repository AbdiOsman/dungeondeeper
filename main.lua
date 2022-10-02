if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then require("lldebugger").start() end

-- TODO: Pass to classes, and get rid of globals?
gStack = nil
gWorld = nil
gGame = nil
gExplore = nil

function love.load()
	require "src.startup.startup"

	Resize(SCALE)

	gWorld = World.new()

	gStack = StateStack.new()

	gGame = Game.new(gStack, Map.new(require "data.maps.map_1"), { x = 2, y = 1 })
	gStack:Push(gGame)
end

function love.update(dt)
	TIME = TIME + 1
	gStack:Update(dt)
	gWorld:Update(dt)
	-- Test()
	if Input.JustPressed("accept") then
		love.graphics.captureScreenshot(os.time() .. ".png")
	end
	Input.Update(dt)
	Sound:Update()
end

function love.draw()
	gStack:Draw()
end

function NewGame(map)
	gWorld.monsters = {}

	for _, p in ipairs(gWorld.party) do
		p.equipment =
		{
			weapon = -1,
			armor = -1,
			acc1 = -1,
			acc2 = -1,
		}
	end

    Actions.SpawnMobs(1, 7, map)()
    Actions.SpawnMobs(1, 9, map)()
    Actions.SpawnMobs(2, 6, map)()
    Actions.SpawnMobs(3, 6, map)()
    Actions.SpawnMobs(5, 7, map)()
    Actions.SpawnMobs(5, 1, map)()
    Actions.SpawnMobs(5, 4, map)()
    Actions.SpawnMobs(14, 1, map)()
    Actions.SpawnMobs(22, 1, map)()
    Actions.SpawnMobs(12, 14, map)()
    Actions.SpawnMobs(17, 7, map)()
    Actions.SpawnMobs(25, 6, map)()
    Actions.SpawnMobs(27, 10, map)()
    Actions.SpawnMobs(12, 11, map)()
    Actions.SpawnMobs(1, 11, map)()
    Actions.SpawnMobs(6, 13, map)()
    Actions.SpawnMobs(13, 14, map)()
    Actions.SpawnMobs(8, 18, map)()
    Actions.SpawnMobs(4, 21, map)()
    Actions.SpawnMobs(16, 20, map)()
    Actions.SpawnMobs(21, 20, map)()
    Actions.SpawnMobs(29, 20, map)()

	Actions.AddMsg(2, 2, map, "Welcome To Dungeon Deeper!")()

	Sound:Play("the_field_of_dreams.mp3", "bgm")
end

-- function Test()
-- 	if Input.JustPressed("f1") then
-- 		print("Before collection: " .. collectgarbage("count")/1024)
--         collectgarbage()
--         print("After collection: " .. collectgarbage("count")/1024)
--         print("Object count: ")
--         local counts = TypeCount()
--         for k, v in pairs(counts) do print(k, v) end
--         print("-------------------------------------")
-- 	elseif Input.JustPressed("f2") then
-- 		SCALE = SCALE % 2 + 1
-- 		Resize(SCALE)
-- 	end
-- end