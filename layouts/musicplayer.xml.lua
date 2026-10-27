local MUSIC = json.parse(file.read(PACK_ID .. ":config/music.json"))

local MUSIC_LIST = {}
for k, v in pairs(MUSIC) do
	table.insert(MUSIC_LIST, k)
end

local bx, bx, bz = nil

function on_open(x, y, z)
	bx = x
	by = y
	bz = z
	
	updatebtntext()
end

function play_stop()
	return
end

--[[
function play_stop()
	local spid = block.get_field(bx, by, bz, "spid")

	if spid == 0 then
		local track_name = document.track_name.text
		local volume = document.volume_trackbar.value / 100
		local looping = document.checkbox_loop.checked

		if not table.has(MUSIC_LIST, track_name) then
			console.chat("Undefined track name: \"" .. track_name .. "\".")
			return
		end

		local filepath = MUSIC[track_name]
		if not file.isfile(filepath) then
			console.chat("Invalid music file path \"" .. filepath .. "\" for track name \"" .. track_name .. "\".")
			return
		end

		spid = audio.play_stream_2d(filepath, volume, 1, "music", looping)
		block.set_field(bx, by, bz, "spid", spid)
		updatebtntext()
	else
		delspeaker()
		updatebtntext()
	end
end
]]

function delspeaker()
	local spid = block.get_field(bx, by, bz, "spid")
	if spid ~= 0 then
		audio.stop(spid)
		block.set_field(bx, by, bz, "spid", 0)
	end
end

function updatebtntext()
	local spid = block.get_field(bx, by, bz, "spid")
	document.button_play_stop.text = (spid == 0) and "Play" or "Stop"
end

function reprint_volume(value)
	document.volume_label.text = "Volume: " .. value .. "%"
end