local VOLUME = 1

foundationkeypadcontrol = {}

foundationkeypadcontrol.is_keypad = function(x, y, z)
	local sid = block.name(block.get(x, y, z))
	return sid == "scp:foundationkeypad"
end

foundationkeypadcontrol.is_locked = function(x, y, z)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	local is_locked = block.get_field(x, y, z, "is_locked")
	if is_locked == nil then
		block.set_field(x, y, z, "is_locked", 0)
		return false
	end
	if is_locked == 1 then
		return true
	else
		return false
	end
end

foundationkeypadcontrol.get_password = function(x, y, z)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	return block.get_field(x, y, z, "password")
	--if password == nil then
	--	block.set_field(x, y, z, "password", 0)
	--	return 0
	--end
	--return password
end

foundationkeypadcontrol.set_password = function(x, y, z, password)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "password", password)
end

foundationkeypadcontrol.set_lock_state = function(x, y, z, lock_state)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", lock_state)
end

foundationkeypadcontrol.lock = function(x, y, z)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 1)
end

foundationkeypadcontrol.unlock = function(x, y, z)	
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 0)
end

foundationkeypadcontrol.toggle_lock = function(x, y, z)
	if not foundationkeypadcontrol.is_keypad(x, y, z) then return nil end
	if foundationkeypadcontrol.is_locked(x, y, z) then foundationkeypadcontrol.unlock(x, y, z)
	else foundationkeypadcontrol.lock(x, y, z)
	end
end

return foundationkeypadcontrol
