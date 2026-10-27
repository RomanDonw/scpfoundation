require "foundationslidingdoorcontrol"

local x, y, z = nil

function on_open(_x, _y, _z, _door_x, _door_y, _door_z, _password)
	--print(x, y, z, door_x, door_y, door_z, password)
	x = _x
	y = _y
	z = _z
	--door_x = _door_x
	--door_y = _door_y
	--door_z = _door_z
	--password = _password
	--print("#", _password)
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
	local password = tonumber(document.password.text)
	--print("Keypad Configurator", x, y, z, p, password)
	if password ~= nil then
		block.set_field(x, y, z, "password", password)
		clear_password()
		console.chat("[SCP FOUNDATION/KEYPAD CONFIGURATOR] Set password at (X: " .. x .. ", Y: " .. y .. ", Z: " .. z .. ") to \"" .. password .. "\".")
	end
end
