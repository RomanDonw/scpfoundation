function on_interact(x, y, z, pid)
	hud.show_overlay(PACK_ID .. ":musicplayer", false, {x, y, z})
	return true
end
--[[
function on_block_present(x, y, z)
	initfields(x, y, z)
end

function on_broken(x, y, z, pid)
	delspeaker(x, y, z)
end

function on_block_removed(x, y, z)
	delspeaker(x, y, z)
end

-- =============================================

function initfields(x, y, z)
	block.set_field(x, y, z, "spid", 0)
end

function delspeaker(x, y, z)
	--print(block.name(block.get(x, y, z)))

	local spid = block.get_field(x, y, z, "spid")
	if spid ~= 0 then
		audio.stop(spid)
		block.set_field(x, y, z, "spid", 0)
	end
end
]]