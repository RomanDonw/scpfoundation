local VOLUME = 1
local MAX_ACCESS_LEVEL = 5
local INTERACTION_COOLDOWN = 2

require "foundationslidingdoorcontrol"
require "foundationcardreadercontrol"

function on_interact(x, y, z, pid)
	local door_x = block.get_field(x, y, z, "door_x")
	local door_y = block.get_field(x, y, z, "door_y")
	local door_z = block.get_field(x, y, z, "door_z")
	--local door_x, door_y, door_z = foundationcardreadercontrol.get_door_position(x, y, z)
	--local last_interaction_time = foundationcardreadercontrol.get_last_interaction_time(x, y, z)
	local last_interaction_time = block.get_field(door_x, door_y, door_z, "last_interaction_time")
	
	--if last_interaction_time ~= nil and last_interaction_time > time.uptime() then block.set_field(door_x, door_y, door_z, "last_interaction_time", -INTERACTION_COOLDOWN) end

	local invid, sel = player.get_inventory(pid)
	local iid = item.name(inventory.get(invid, sel))
	local parsed_iid = string.split(iid, "_")
	local first_iid_part = string.split(parsed_iid[1], ":")[2]
	local access_level = tonumber(parsed_iid[2])
	local required_access_level = foundationcardreadercontrol.get_access_level(x, y, z)


	if iid == PACK_ID .. ":red_screwdriver" then
		if required_access_level < MAX_ACCESS_LEVEL then
			foundationcardreadercontrol.set_access_level(x, y, z, required_access_level + 1)
		else
			foundationcardreadercontrol.set_access_level(x, y, z, 0)
		end

		console.chat("[SCP FOUNDATION/CARD READER CONFIGURATOR] Set access level at (X: " ..  x .. ", Y: " .. y .. ", Z: " .. z .. ") to " .. foundationcardreadercontrol.get_access_level(x, y, z) .. ".")

	elseif iid == PACK_ID .. ":blue_screwdriver" then
		foundationcardreadercontrol.toggle_lock(x, y, z)
		console.chat("[SCP FOUNDATION/CARD READER CONFIGURATOR] Set state of lock at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to " .. tostring(foundationcardreadercontrol.is_locked(x, y, z)))

	elseif foundationcardreadercontrol.is_locked(x, y, z) then
		if first_iid_part == "accesscard" then
			if last_interaction_time ~= nil and time.uptime() < last_interaction_time + INTERACTION_COOLDOWN then return true end
			audio.play_sound("blocks/foundationcardreader_failed", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			console.chat("The keycard was inserted into the slot but nothing happened.")
			block.set_field(door_x, door_y, door_z, "last_interaction_time", time.uptime())
		else
			audio.play_sound("blocks/foundationbutton_success", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			console.chat("A keycard is required to operate this door.")
		end

	elseif first_iid_part == "accesscard" then
		if last_interaction_time ~= nil and time.uptime() < last_interaction_time + INTERACTION_COOLDOWN then return true end
		if access_level >= required_access_level then
			foundationslidingdoorcontrol.toggle_door(door_x, door_y, door_z)
			audio.play_sound("blocks/foundationcardreader_success", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			console.chat("The keycard was inserted into the slot.")

		elseif access_level < required_access_level then
			audio.play_sound("blocks/foundationcardreader_failed", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			console.chat("A keycard with clearance " .. required_access_level .. " or higher is required to operate this door.")

		end
		block.set_field(door_x, door_y, door_z, "last_interaction_time", time.uptime())
		
	else
		audio.play_sound("blocks/foundationbutton_success", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
		console.chat("A keycard is required to operate this door.")
	end
	return true
end

function on_placed(x, y, z, pid)
	block.set_field(x, y, z, "access_level", 0)
	block.set_field(x, y, z, "is_locked", 0)
	--block.set_field(x, y, z, "last_interaction_time", -INTERACTION_COOLDOWN)
end
