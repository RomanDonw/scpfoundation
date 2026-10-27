local door_x, door_y, door_z = nil

require "foundationslidingdoorcontrol"
require "foundationcardreadercontrol"
require "foundationbuttoncontrol"
require "foundationkeypadcontrol"

function on_use_on_block(x, y, z, pid, normal)
	local x, y, z = block.seek_origin(x, y, z)
	local bsid = block.name(block.get(x, y, z))


	if foundationslidingdoorcontrol.is_door(x, y, z) then
		door_x = x
		door_y = y
		door_z = z
		console.chat("[SCP FOUNDATION/DOOR LINKER] Saved door position (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ").")

	elseif (foundationcardreadercontrol.is_cardreader(x, y, z) or foundationbuttoncontrol.is_button(x, y, z) or foundationkeypadcontrol.is_keypad(x, y, z)) and door_x ~= nil and door_y ~= nil and door_z ~= nil then
		block.set_field(x, y, z, "door_x", door_x)
		block.set_field(x, y, z, "door_y", door_y)
		block.set_field(x, y, z, "door_z", door_z)
		console.chat("[SCP FOUNDATION/DOOR LINKER] Linked button/card reader at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to door (X: " .. door_x .. ", Y: " .. door_y.. ", Z: " .. door_z .. ").")
	end
	return true
end
