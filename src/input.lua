Input = {}

local key_states = {}
local key_to_button = {mouse1 = 1, mouse2 = 2}

function Input.bind(key, action)
    if not key_states[action] then key_states[action] = {pressed = false} end
    table.insert(key_states[action], key)
end

function Input.update(dt)
    for _, v in pairs(key_states) do
        v.pressed = false
    end
end

-- returns the current state of a given key
function Input.held(...)
    local keys = {}
    for _, v in ipairs(key_states[...]) do
        table.insert(keys, v)
    end
    return love.keyboard.isDown(keys)
end

function Input.mouseDown(...)
    local keys = {}
    for _, v in ipairs(key_states[...]) do
        v = key_to_button[v]
        table.insert(keys, v)
    end
    return love.mouse.isDown(keys)
end

-- returns if the key has been pressed this frame
function Input.justPressed(action)
    return key_states[action].pressed
end

-- returns if the key has been released this frame
function Input.justReleased(action)
    return key_states[action].pressed == false
end

function Input.hookLoveEvents()
    function love.keypressed(key)
        for _, v in pairs(key_states) do
            for _, k in ipairs(v) do
                if k == key then v.pressed = true end
            end
        end
    end
    function love.keyreleased(key)
        for _, v in pairs(key_states) do
            for _, k in ipairs(v) do
                if k == key then v.pressed = false end
            end
        end
    end
    function love.mousepressed(x, y, button)
        for _, v in pairs(key_states) do
            for _, k in ipairs(v) do
                if key_to_button[k] == button then v.pressed = true end
            end
        end
     end
end

Input.hookLoveEvents()