function on_block_tick(x, y, z, tps)
    if math.random() < 0.5 then
        local name = block.name(block.get(x, y, z))
        local state = block.get_states(x, y, z)

        if name == PACK_ID .. ":foundationdamagedceilinglamp" then
            block.set(x, y, z, block.index(PACK_ID .. ":foundationdamagedceilinglamp_off"), state)
        elseif name == PACK_ID .. ":foundationdamagedceilinglamp_off" then
            block.set(x, y, z, block.index(PACK_ID .. ":foundationdamagedceilinglamp"), state)
        end
    end
end