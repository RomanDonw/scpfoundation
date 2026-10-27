require "foundationslidingdoorcontrol"

local x, y, z, door_x, door_y, door_z, password, is_locked = nil

function on_open(_x, _y, _z, _door_x, _door_y, _door_z, _password, _is_locked)
	--print(x, y, z, door_x, door_y, door_z, password)
	x = _x
	y = _y
	z = _z
	door_x = _door_x
	door_y = _door_y
	door_z = _door_z
	password = _password
	is_locked = _is_locked

	document.password.text = ""
end

MAX_PASSWORD_LENGTH = 12

function add_char(char)
	if string.len(document.password.text) > MAX_PASSWORD_LENGTH then return end
	document.password.text = document.password.text .. char
end

function clear_password()
	document.password.text = ""
end

function check_password()
	local p = tonumber(document.password.text)
	--print("@", door_x, door_y, door_z, p, password)
	--local password = 0
	if p == password then
		--print(foundationslidingdoorcontrol.is_door(door_x, door_y, door_z))
		if is_locked then
			console.chat("The door appears to be locked.")
			return
		end
		foundationslidingdoorcontrol.toggle_door(door_x, door_y, door_z)
		--hud.close(PACK_ID .. ":keypad")	
		hud.close_inventory()
		foundationslidingdoorcontrol.set_last_interaction_time(door_x, door_y, door_z, time.uptime())
		console.chat("Access allowed.")
	elseif p == nil then

	else
		document.password.text = ""
		console.chat("Access denied.")
	end
end
