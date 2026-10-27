local VOLUME = 1

foundationbuttoncontrol = {}

foundationbuttoncontrol.is_button = function(x, y, z)
	local sid = block.name(block.get(x, y, z))
	return sid == "scp:foundationbutton"
end

foundationbuttoncontrol.is_locked = function(x, y, z)
	if not foundationbuttoncontrol.is_button(x, y, z) then return nil end
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

foundationbuttoncontrol.lock = function(x, y, z)
	if not foundationbuttoncontrol.is_button(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 1)
end

foundationbuttoncontrol.unlock = function(x, y, z)	
	if not foundationbuttoncontrol.is_button(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 0)
end

foundationbuttoncontrol.toggle_lock = function(x, y, z)
	if not foundationbuttoncontrol.is_button(x, y, z) then return nil end
	if foundationbuttoncontrol.is_locked(x, y, z) then foundationbuttoncontrol.unlock(x, y, z)
	else foundationbuttoncontrol.lock(x, y, z)
	end
end

return foundationbuttoncontrol
