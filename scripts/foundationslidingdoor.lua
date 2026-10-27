require "foundationslidingdoorcontrol"

function on_placed(x, y, z)
	--foundationslidingdoorcontrol.set_last_interaction_time(x, y, z, -42)
	block.set_field(x, y, z, "last_interaction_time", -999999)
end

function on_block_present(x, y, z)
	local field = block.get_field(x, y, z, "last_interaction_time")
	if field == nil or field > time.uptime() then
		block.set_field(x, y, z, "last_interaction_time", -999999)
	end
end

--function on_random_update(x, y, z)
--	local last_interaction_time = block.get_field(x, y, z, "last_interaction_time")
--	if last_interaction_time > time.uptime() then
--		block.set_field()
--end
