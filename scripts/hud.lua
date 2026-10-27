--[[function on_hud_render()
    if world.get_generator() == PACK_ID .. ":pd" then
        local players = player.get_all()
        if #players == 0 then return end
        local pid = players[1]

        local cam = cameras.get(player.get_camera(pid))

        local droll = math.sin(math.rad(time.uptime() * (20 / 3))) * 30
        cam:set_rot(mat4.rotate(cam:get_rot(), {0, 0, 1}, droll))
    end
end]]

local MUSIC = json.parse(file.read("scp:config/music.json"))
local MUSIC_LIST = {}

for name, path in pairs(MUSIC) do
    table.insert(MUSIC_LIST, name)
end

local music_spid = nil

function on_hud_open()
    console.add_command("scp.music.list", "Prints list of available music tracks.", function(args, kwargs)
        console.log("Available music:")
        for name, path in pairs(MUSIC) do
            console.log("  \"" .. name .. "\" -> \"" .. path .. "\".")
        end
    end)

    console.add_command("scp.music.play name:str volume:num=0.3 loop:[false|true]=true", "Plays track with specified parametres.", function(args, kwargs)
        local name = args[1]
        if not table.has(MUSIC_LIST, name) then
            console.log("Unknown track name.")
            return
        end
        local path = MUSIC[name]

        local volume = tonumber(args[2])
        if volume > 1.0 then
            volume = 1.0
        elseif volume < 0.0 then
            volume = 0.0
        end

        local loop = args[3]

        if is_speaker_alive(music_spid) then
            audio.stop(music_spid)
        end
        music_spid = audio.play_stream_2d(path, volume, 1.0, "music", loop)
        console.log("Playing track \"" .. name .. "\" (\"" .. path .. "\").")
    end)

    console.add_command("scp.music.stop", "Stops current playing music.", function(args, kwargs)
        if is_speaker_alive(music_spid) then
            audio.stop(music_spid)
            console.log("Music successfully stopped.")
        else
            console.log("No music playing.")
        end
    end)
end

function on_hud_close()
    if is_speaker_alive(music_spid) then
        audio.stop(music_spid)
    end
end

function is_speaker_alive(spid)
    return audio.get_position(spid) ~= nil
end
