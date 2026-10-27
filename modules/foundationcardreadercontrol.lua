local VOLUME = 1

foundationcardreadercontrol = {}

foundationcardreadercontrol.is_cardreader = function(x, y, z)
	local sid = block.name(block.get(x, y, z))
	return sid == "scp:foundationcardreader"
end

foundationcardreadercontrol.is_locked = function(x, y, z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
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

foundationcardreadercontrol.get_door_position = function(x, y, z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	return block.get_field(x, y, z, "door_x"), block.get_field(x, y, z, "door_y"), block.get_field(x, y, z, "door_z")
end

foundationcardreadercontrol.set_door_position = function(x, y, z, door_x, door_y, door_z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	block.set_field(x, y, z, "door_x", door_x)
	block.set_field(x, y, z, "door_y", door_y)
	block.set_field(x, y, z, "door_z", door_z)
end

--foundationcardreadercontrol.get_last_interaction_time = function(x, y, z)
--	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
--	return block.get_field(x, y, z, "last_interaction_time")
--end
--
--foundationcardreadercontrol.set_last_interaction_time = function(x, y, z, last_interaction_time)
--	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
--	block.set_field(x, y, z, "last_interaction_time", last_interaction_time)
--end

foundationcardreadercontrol.get_access_level = function(x, y, z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	local access_level = block.get_field(x, y, z, "access_level")
	if access_level == nil then
		block.set_field(x, y, z, "access_level", 0)
		return 0
	end
	return access_level
end

foundationcardreadercontrol.set_access_level = function(x, y, z, access_level)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	block.set_field(x, y, z, "access_level", access_level)
end

foundationcardreadercontrol.lock = function(x, y, z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 1)
end

foundationcardreadercontrol.unlock = function(x, y, z)	
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	block.set_field(x, y, z, "is_locked", 0)
end

foundationcardreadercontrol.toggle_lock = function(x, y, z)
	if not foundationcardreadercontrol.is_cardreader(x, y, z) then return nil end
	if foundationcardreadercontrol.is_locked(x, y, z) then foundationcardreadercontrol.unlock(x, y, z)
	else foundationcardreadercontrol.lock(x, y, z)
	end
end

return foundationcardreadercontrol
