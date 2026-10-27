local MAIN_CONFIG = json.parse(file.read(PACK_ID .. ":config/__main__.json"))
local PD_CONFIG = json.parse(file.read(PACK_ID .. ":config/pocketdimension.json"))

local PD_AMBCONF = PD_CONFIG["ambient"]

local PD_AMBSOUNDS = PD_AMBCONF["sounds"]

local PD_AMBVOLUME = PD_AMBCONF["volume"]

local PD_AMBSPAWNMINDX = PD_AMBCONF["spawn-min-delta-x"]
local PD_AMBSPAWNMINDZ = PD_AMBCONF["spawn-min-delta-z"]
local PD_AMBSPAWNMAXDX = PD_AMBCONF["spawn-max-delta-x"]
local PD_AMBSPAWNMAXDZ = PD_AMBCONF["spawn-max-delta-z"]

local PD_MUSICCONF = PD_CONFIG["music"]

local PD_MUSIC_FILE = PD_MUSICCONF["file"]
local PD_MUSIC_VOLUME = PD_MUSICCONF["volume"]
local PD_MUSIC_PITCH = PD_MUSICCONF["pitch"]

function randchoice(in_table)
    return in_table[math.random(1, #in_table)]
end

local musicsp = nil

function on_world_open()
    if world.get_generator() == PACK_ID .. ":pd" then
        musicsp = audio.play_stream_2d(PD_MUSIC_FILE, PD_MUSIC_VOLUME, PD_MUSIC_PITCH, "music", true)
    end
end

function on_world_quit()
    if musicsp ~= nil then audio.stop(musicsp) end
end

local nexttime = time.uptime()
local lastplayed = ""
local roll = 0

function on_player_tick(pid, tps)
    local x, y, z = player.get_pos(pid)
    local delta = 1 / tps

    if world.get_generator() == PACK_ID .. ":pd" then
        if time.uptime() >= nexttime then
            local dx = (math.random() * (PD_AMBSPAWNMAXDX - PD_AMBSPAWNMINDX) + PD_AMBSPAWNMINDX) * (math.random(1, 2) == 2 and 1 or -1)
            local dz = (math.random() * (PD_AMBSPAWNMAXDZ - PD_AMBSPAWNMINDZ) + PD_AMBSPAWNMINDZ) * (math.random(1, 2) == 2 and 1 or -1)
            
            local spx = x + dx
            local spy = y
            local spz = z + dz

            local found
            ::findsound::
            found = false
            if MAIN_CONFIG["debug"] then print("searching ambient...") end
            for _k, sd in ipairs(PD_AMBSOUNDS) do
                local sname = sd["name"]
                local schance = sd["chance"]
                local sduration = sd["duration"]
                local sminp = sd["min-pitch"]
                local smaxp = sd["max-pitch"]

                local spitch = (sminp ~= nil and smaxp ~= nil) and (math.random() * (smaxp - sminp) + sminp) or 1.0

                if math.random() < schance and sname ~= lastplayed then
                    audio.play_sound(sname, spx, spy, spz, PD_AMBVOLUME, spitch, "ambient", false)
                    nexttime = time.uptime() + sduration
                    lastplayed = sname

                    if MAIN_CONFIG["debug"] then print("name: " .. sname .. ", next uptime: " .. nexttime .. ", x: " .. spx .. ", y: " .. spy .. ", z: " .. spz .. ", pitch: " .. spitch) end

                    found = true
                    break
                end
            end
            if not found then goto findsound end
        end

        --local cam = cameras.get(player.get_camera())
        --[[local front = cam:get_front()
        local roteuler = vec3angles(front, math.sin())

        local mrot = mat4.rotate({1, 0, 0}, math.degrees(roteuler[0]))
        mat4.rotate(mrot, {0, 1, 0}, math.degrees(roteuler[1]), mrot)
        mat4.rotate(mrot, {0, 0, 1}, math.degrees(roteuler[2]), mrot)]]
    end
end

function vec3angles(v, roll)
    if roll == nil then roll = 0 end

    local length = vec3.length(v)
    if length == 0 then return {0, 0, 0} end

    return {math.asin(v[1] / length), math.atan(v[0], v[2]), roll}
end
