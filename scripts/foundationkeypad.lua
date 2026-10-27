local VOLUME = 1
--local MAX_ACCESS_LEVEL = 5
local INTERACTION_COOLDOWN = 2

require "foundationslidingdoorcontrol"
require "foundationkeypadcontrol"

function on_interact(x, y, z, pid)
	local door_x = block.get_field(x, y, z, "door_x")
	local door_y = block.get_field(x, y, z, "door_y")
	local door_z = block.get_field(x, y, z, "door_z")
	local last_interaction_time = foundationslidingdoorcontrol.get_last_interaction_time(door_x, door_y, door_z)--block.get_field(door_x, door_y, door_z, "last_interaction_time")
	local password = foundationkeypadcontrol.get_password(x, y, z)--block.get_field(x, y, z, "password")
	local is_locked = foundationkeypadcontrol.is_locked(x, y, z)

	--print("Keypad Interaction Handler", password)

	--if last_interaction_time ~= nil and last_interaction_time > time.uptime() then foundationslidingdoorcontrol.set_last_interaction_time(door_x, door_y, door_z, -INTERACTION_COOLDOWN) end	

	local invid, sel = player.get_inventory(pid)
	local iid = item.name(inventory.get(invid, sel))
	--local parsed_iid = string.split(iid, "_")
	--local first_iid_part = string.split(parsed_iid[1], ":")[2]
	--local access_level = tonumber(parsed_iid[2])
	--local required_access_level = foundationcardreadercontrol.get_access_level(x, y, z)


	if iid == PACK_ID .. ":red_screwdriver" then
		hud.show_overlay(PACK_ID .. ":foundationkeypad_passwordsetter", false, {x, y, z, door_x, door_y, door_z, password, is_locked})
		--print("Open KP UI.")

		--console.chat("[SCP FOUNDATION/CARD READER CONFIGURATOR] Set access level at (X: " ..  x .. ", Y: " .. y .. ", Z: " .. z .. ") to " .. foundationcardreadercontrol.get_access_level(x, y, z) .. ".")

	elseif iid == PACK_ID .. ":blue_screwdriver" then
		foundationkeypadcontrol.toggle_lock(x, y, z)
		console.chat("[SCP FOUNDATION/KEYPAD CONFIGURATOR] Set state of lock at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to " .. tostring(foundationkeypadcontrol.is_locked(x, y, z)))

	else
		if last_interaction_time ~= nil and time.uptime() < last_interaction_time + INTERACTION_COOLDOWN then return true end
		hud.show_overlay(PACK_ID .. ":foundationkeypad", false, {x, y, z, door_x, door_y, door_z, password, is_locked})
		--block.set_field(door_x, door_y, door_z, "last_interaction_time", time.uptime())
		foundationslidingdoorcontrol.set_last_interaction_time(door_x, door_y, door_z, time.uptime())
	end	
	return true
end

function on_placed(x, y, z, pid)
	--block.set_field(x, y, z, "access_level", 0)
	foundationkeypadcontrol.set_password(x, y, z, 0)
	foundationkeypadcontrol.set_lock_state(x, y, z, 0)
	--block.set_field(x, y, z, "last_interaction_time", -INTERACTION_COOLDOWN)
	--foundationkeypadcontrol.set_password(x, y, z, nil)
end
