local CANDIES_TYPES = {"a", "b", "c", "d", "e", "f"}

function on_interact(x, y, z, pid)
	local iid, sel = player.get_inventory(pid)
	if inventory.add(iid, item.index(PACK_ID .. ":scp330_" .. table.random(CANDIES_TYPES)), 1) == 0 then
		-- increment player picked candies count
	end
	return true
end
