local VOLUME = 1

foundationslidingdoorcontrol = {}

foundationslidingdoorcontrol.is_door = function(x, y, z)
	local sid = block.name(block.get(block.seek_origin(x, y, z)))
	return sid == "scp:foundationslidingdoora" or sid == "scp:foundationslidingdoora_opened" or sid == "scp:foundationslidingdoorb" or sid == "scp:foundationslidingdoorb_opened"
end

foundationslidingdoorcontrol.is_open = function(x, y, z)
	local sid = block.name(block.get(block.seek_origin(x, y, z)))
	if sid == "scp:foundationslidingdoora"or sid == "scp:foundationslidingdoorb" then
		return false
	elseif sid == "scp:foundationslidingdoora_opened" or sid == "scp:foundationslidingdoorb_opened" then
		return true
	else
		return nil
	end
end

foundationslidingdoorcontrol.get_last_interaction_time = function(x, y, z)
	if not foundationslidingdoorcontrol.is_door(x, y, z) then return nil end
	local x, y, z = block.seek_origin(x, y, z)
	return block.get_field(x, y, z, "last_interaction_time")
end

foundationslidingdoorcontrol.set_last_interaction_time = function(x, y, z, last_interaction_time)
	if not foundationslidingdoorcontrol.is_door(x, y, z) then return nil end
	local x, y, z = block.seek_origin(x, y, z)
	block.set_field(x, y, z, "last_interaction_time", last_interaction_time)
end

foundationslidingdoorcontrol.open = function(x, y, z)
	if not foundationslidingdoorcontrol.is_door(x, y, z) then return nil end
	local x, y, z = block.seek_origin(x, y, z)
	local sid = block.name(block.get(x, y, z))
	local sound_number = block.get_user_bits(x, y, z, 0, 2)
	
	local next_door_x = block.get_field(x, y, z, "next_door_x")
	local next_door_y = block.get_field(x, y, z, "next_door_y")
	local next_door_z = block.get_field(x, y, z, "next_door_z")
	local last_interaction_time = block.get_field(x, y, z, "last_interaction_time")

	if sid == "scp:foundationslidingdoora" then
		block.set(x, y, z, block.index("scp:foundationslidingdoora_opened"), block.get_states(x, y, z))
		audio.play_sound("blocks/foundationslidingdoora_opening" .. sound_number + 1, x + 0.5, y + 1, z + 0.5, VOLUME, 1)

	elseif sid == "scp:foundationslidingdoorb" then
		block.set(x, y, z, block.index("scp:foundationslidingdoorb_opened"), block.get_states(x, y, z))
		audio.play_sound("blocks/foundationslidingdoorb_opening" .. sound_number + 1, x + 0.5, y + 1, z + 0.5, VOLUME, 1)
	else
		return
	end
	
	if next_door_x ~= nil then block.set_field(x, y, z, "next_door_x", next_door_x) end
	if next_door_y ~= nil then block.set_field(x, y, z, "next_door_y", next_door_y) end
	if next_door_z ~= nil then block.set_field(x, y, z, "next_door_z", next_door_z) end
	if last_interaction_time ~= nil then block.set_field(x, y, z, "last_interaction_time", last_interaction_time) end
	
	if (next_door_x ~= nil and next_door_y ~= nil and next_door_z ~= nil) and (block.get_field(next_door_x, next_door_y, next_door_z, "next_door_x") ~= x and block.get_field(next_door_x, next_door_y, next_door_z, "next_door_y") ~= y and block.get_field(next_door_x, next_door_y, next_door_z, "next_door_z") ~= z) then
		foundationslidingdoorcontrol.open(next_door_x, next_door_y, next_door_z)
	end
end

foundationslidingdoorcontrol.close = function(x, y, z)
	if not foundationslidingdoorcontrol.is_door(x, y, z) then return nil end
	local x, y, z = block.seek_origin(x, y, z)
	local sid = block.name(block.get(x, y, z))
	local sound_number = block.get_user_bits(x, y, z, 0, 2)
	
	local next_door_x = block.get_field(x, y, z, "next_door_x")
	local next_door_y = block.get_field(x, y, z, "next_door_y")
	local next_door_z = block.get_field(x, y, z, "next_door_z")
	local last_interaction_time = block.get_field(x, y, z, "last_interaction_time")
	
	if sid == "scp:foundationslidingdoora_opened" then
		block.set(x, y, z, block.index("scp:foundationslidingdoora"), block.get_states(x, y, z))
		audio.play_sound("blocks/foundationslidingdoora_closing" .. sound_number + 1, x + 0.5, y + 1, z + 0.5, VOLUME, 1)
		
	elseif sid == "scp:foundationslidingdoorb_opened" then
		block.set(x, y, z, block.index("scp:foundationslidingdoorb"), block.get_states(x, y, z))
		audio.play_sound("blocks/foundationslidingdoorb_closing" .. sound_number + 1, x + 0.5, y + 1, z + 0.5, VOLUME, 1)
		
	else
		return	
	end
	
	sound_number = sound_number + 1
	if sound_number >= 3 then
		block.set_user_bits(x, y, z, 0, 2, 0)
	else
		block.set_user_bits(x, y, z, 0, 2, sound_number)
	end

	if next_door_x ~= nil then block.set_field(x, y, z, "next_door_x", next_door_x) end
	if next_door_y ~= nil then block.set_field(x, y, z, "next_door_y", next_door_y) end
	if next_door_z ~= nil then block.set_field(x, y, z, "next_door_z", next_door_z) end
	if last_interaction_time ~= nil then block.set_field(x, y, z, "last_interaction_time", last_interaction_time) end
	
	if (next_door_x ~= nil and next_door_y ~= nil and next_door_z ~= nil) and (block.get_field(next_door_x, next_door_y, next_door_z, "next_door_x") ~= x and block.get_field(next_door_x, next_door_y, next_door_z, "next_door_y") ~= y and block.get_field(next_door_x, next_door_y, next_door_z, "next_door_z") ~= z) then
		foundationslidingdoorcontrol.close(next_door_x, next_door_y, next_door_z)
	end
end

foundationslidingdoorcontrol.toggle_door = function(x, y, z)
	if not foundationslidingdoorcontrol.is_door(x, y, z) then return nil end
	if foundationslidingdoorcontrol.is_open(x, y, z) then foundationslidingdoorcontrol.close(x, y, z)
	else foundationslidingdoorcontrol.open(x, y, z)
	end
end

return foundationslidingdoorcontrol
