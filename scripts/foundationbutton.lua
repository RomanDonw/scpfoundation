local VOLUME = 1
local INTERACTION_COOLDOWN = 2

require "foundationslidingdoorcontrol"
require "foundationbuttoncontrol"

function on_interact(x, y, z, pid)
	local door_x = block.get_field(x, y, z, "door_x")
	local door_y = block.get_field(x, y, z, "door_y")
	local door_z = block.get_field(x, y, z, "door_z")
	local last_interaction_time = block.get_field(door_x, door_y, door_z, "last_interaction_time")

	--if last_interaction_time ~= nil and last_interaction_time > time.uptime() then block.set_field(door_x, door_y, door_z, "last_interaction_time", -INTERACTION_COOLDOWN) end

	local invid, sel = player.get_inventory(pid)
	local iid = item.name(inventory.get(invid, sel))

	if iid == PACK_ID .. ":blue_screwdriver" then
		foundationbuttoncontrol.toggle_lock(x, y, z)
		console.chat("[SCP FOUNDATION/BUTTON CONFIGURATOR] Set state of lock at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to " .. tostring(foundationbuttoncontrol.is_locked(x, y, z)) .. ".")
	else
		if foundationbuttoncontrol.is_locked(x, y, z) then
			audio.play_sound("blocks/foundationbutton_failed", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			console.chat("The door appears to be locked.")
		else
			if last_interaction_time ~= nil and time.uptime() < last_interaction_time + INTERACTION_COOLDOWN then return true end
			audio.play_sound("blocks/foundationbutton_success", x + 0.5, y + 0.5, z + 0.5, VOLUME, 1)
			foundationslidingdoorcontrol.toggle_door(door_x, door_y, door_z)
		end
		block.set_field(door_x, door_y, door_z, "last_interaction_time", time.uptime())
	end
	return true
end

function on_placed(x, y, z, pid)
	block.set_field(x, y, z, "is_locked", 0)
	--block.set_field(x, y, z, "last_interaction_time", -INTERACTION_COOLDOWN)
end
