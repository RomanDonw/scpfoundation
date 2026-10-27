local door_x, door_y, door_z = nil

require "foundationslidingdoorcontrol"
require "foundationcardreadercontrol"
require "foundationbuttoncontrol"

function on_use_on_block(x, y, z, pid, normal)
	local x, y, z = block.seek_origin(x, y, z)
	local bsid = block.name(block.get(x, y, z))


	if foundationslidingdoorcontrol.is_door(x, y, z) then
		if door_x == nil and door_y == nil and door_z == nil then
			door_x = x
			door_y = y
			door_z = z
			console.chat("[SCP FOUNDATION/DOOR CHAIN LINKER] Saved door position (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ").")
		else
			block.set_field(x, y, z, "next_door_x", door_x)
			block.set_field(x, y, z, "next_door_y", door_y)
			block.set_field(x, y, z, "next_door_z", door_z)
			console.chat("[SCP FOUNDATION/DOOR CHAIN LINKER] Linked door at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to door (X: " .. door_x .. ", Y: " .. door_y.. ", Z: " .. door_z .. ").")

			door_x, door_y, door_z = nil
		end

		return true
	end
	return false
end
