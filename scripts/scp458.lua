function on_interact(x, y, z, pid)
	local iid, sel = player.get_inventory(pid)
	inventory.add(iid, item.index(PACK_ID .. ":scp458_item"), 1)
end
