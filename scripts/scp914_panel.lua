local INTERACTION_COOLDOWN = 3

function on_interact(x, y, z, pid)
    --return false

    local invid, sel = player.get_inventory(pid)

    local iid = item.name(inventory.get(invid, sel))

    local last_interaction_time = block.get_field(x, y, z, "last_interaction_time")

    if iid == PACK_ID .. ":red_screwdriver" then
        hud.show_overlay(PACK_ID .. ":scp914_panel_config", false, {x, y, z})
    else
        if time.uptime() < last_interaction_time + INTERACTION_COOLDOWN then return true end
        hud.show_overlay(PACK_ID .. ":scp914_panel", false, {x, y, z})
    end

    return true
end

function on_block_present(x, y, z)
    if block.get_field(x, y, z, "last_interaction_time") > time.uptime() then
        block.set_field(x, y, z, "last_interaction_time", -999999)
    end
end

function on_placed(x, y, z)
    block.set_field(x, y, z, "c1_x", x - 1)
    block.set_field(x, y, z, "c1_y", y)
    block.set_field(x, y, z, "c1_z", z)

    block.set_field(x, y, z, "c1_x_sz", 1)
    block.set_field(x, y, z, "c1_y_sz", 1)
    block.set_field(x, y, z, "c1_z_sz", 1)

    block.set_field(x, y, z, "c2_x", x + 1.5)
    block.set_field(x, y, z, "c2_y", y + 0.5)
    block.set_field(x, y, z, "c2_z", z + 0.5)

    block.set_field(x, y, z, "mode", 2)
    block.set_field(x, y, z, "last_interaction_time", -999999)
    -- init other fields.
end