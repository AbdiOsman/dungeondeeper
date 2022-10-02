Sound = {}

local sources = {}
local soundfolder = "sound/"

function Sound:Update()
    local remove = {}
    for k, v in ipairs(sources) do
        if not v.src:isPlaying() then
            remove[#remove + 1] = k
        else
            if v.channel == "bgm" then
                v.src:setVolume(MASTERVOLUME * BGMVOLUME)
            elseif v.channel == "se" then
                v.src:setVolume(MASTERVOLUME * SEVOLUME)
            end
        end
    end

    for i,s in ipairs(remove) do
        sources[s] = nil
    end
end

local play = love.audio.play
function Sound:Play(what, channel, how)
    local src = what
    channel = channel or "se"
    if type(what) ~= "userdata" or not what:typeOf("Source") then
        src = love.audio.newSource(soundfolder .. what, how or "static")

        if channel == "bgm" then
            src:setVolume(MASTERVOLUME * BGMVOLUME)
            src:setLooping(true)
        elseif channel == "se" then
            src:setVolume(MASTERVOLUME * SEVOLUME)
        end
    end

    play(src)
    table.insert(sources, { src = src, channel = channel })
    return src
end

local stop = love.audio.stop
function Sound:Stop(src)
    if not src then return end
    stop(src)
    sources[src] = nil
end