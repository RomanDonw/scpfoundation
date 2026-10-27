local VOLUME = 1

foundationcardreadercontrol = {}

foundationcardreadercontrol.is_keypad = function(x, y, z)
	local sid = block.name(block.get(x, y, z))
	return sid == "scp:foundationkeypad"
end

foundationcardreadercontrol.is_locked = function(x, y, z)
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
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

foundationcardreadercontrol.get_password = function(x, y, z)
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
	return block.get_field(x, y, z, "password")
	--if password == nil then
	--	block.set_field(x, y, z, "password", 0)
	--	return 0
	--end
	--return password
end

foundationcardreadercontrol.set_password = function(x, y, z, password)
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "password", password)
end

foundationcardreadercontrol.lock = function(x, y, z)
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 1)
end

foundationcardreadercontrol.unlock = function(x, y, z)	
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 0)
end

foundationcardreadercontrol.toggle_lock = function(x, y, z)
	if not foundationcardreadercontrol.is_keypad(x, y, z) then return nil end
	if foundationcardreadercontrol.is_locked(x, y, z) then foundationcardreadercontrol.unlock(x, y, z)
	else foundationcardreadercontrol.lock(x, y, z)
	end
end

return foundationcardreadercontrol
