function shallowClone(t)
    local clone = {}
    for k, v in pairs(t) do
        clone[k] = v
    end
    return clone
end

function resize(s, flags)
    love.window.setMode(s * GW, s * GH)
    -- love.window.setMode(s * GW, s * GH, flags)
    -- if flags and flags.fullscreen then
    --     GW = love.graphics.getWidth() / 2
    --     GH = love.graphics.getHeight() / 2
    -- end
end

function generate_quads(tileWidth, tileHeight, texture)
    local quads = {}

    local textureWidth = texture:getWidth()
    local textureHeight = texture:getHeight()
    local cols = textureWidth / tileWidth
    local rows = textureHeight / tileHeight

    local x = 0
    local y = 0

    for j = 0, rows - 1 do
        for i = 0, cols - 1 do
            table.insert(quads, love.graphics
                .newQuad(i * tileWidth, j * tileHeight, tileWidth, tileHeight, texture:getDimensions()))
            x = x + tileWidth
        end
        x = 0
        y = y + tileHeight
    end

    return quads
end

function nextframe(anim, speed)
    return math.floor(TIME / speed) % #anim + 1
end

function measureText(text, wrp)
    local f = love.graphics.getFont()

    if not wrp then
        wrp = f:getWidth(text)
    end

    local w, wrptext = f:getWrap(text, wrp)
    local h = f:getHeight() * #wrptext

    return w, h
end

function getWrap(text, wrp)
    local f = love.graphics.getFont()
    local _, wrptext = f:getWrap(text, wrp)
    return wrptext
end

function dump(o)
    if type(o) == 'table' then
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

function round(n)
    if n < 0 then
        return math.ceil(n - 0.5)
    else
        return math.floor(n + 0.5)
    end
end

function nextlevel(level)
    local exponent = 1.5
    local baseXP = 1000
    return math.floor(baseXP * (level ^ exponent))
end

function uuid()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function distance(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

function lineofsite(x1, y1, x2, y2, map)
    local frst, sx, sy, dx, dy = true, 0, 0, 0, 0

    if distance(x1, y1, x2, y2) == 1 then return true end
    if x1 < x2 then
        sx = 1
        dx = x2 - x1
    else
        sx = -1
        dx = x1 - x2
    end
    if y1 < y2 then
        sy = 1
        dy = y2 - y1
    else
        sy = -1
        dy = y1 - y2
    end
    local err, e2 = dx - dy, nil

    while not (x1 == x2 and y1 == y2) do
        if not frst and map:gettileprops(x1, y1, true).blocksight then return false end
        frst = false
        e2 = err + err
        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end
        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
    return true
end

function clamp(x, a, b)
    return math.max(a, math.min(b, x))
  end