local VOLUME_2D = 0.2
local LOOT_TABLE = json.parse(file.read(PACK_ID .. ":config/scp1162-loottable.json"))

local util = require("base:util")

function on_interact(x, y, z, pid)
    local piid, selslot = player.get_inventory(pid)

    local slot = -1
    local id, count
    for i = 0, inventory.size(piid) - 1 do
        id, count = inventory.get(piid, i)
        if id ~= 0 and count ~= 0 then
            slot = i
            break
        end
    end

    if slot >= 0 then
        local loot = randchoice(LOOT_TABLE)

        if count - loot["count"] <= 0 then
            inventory.set(piid, slot, 0, 0)
        else
            inventory.set(piid, slot, id, count - loot["count"])
        end

        --inventory.add(piid, item.index(loot["id"]), loot["count"])
        local bx, by, bz = block.get_Z(x, y, z)
        util.drop(vec3.add(vec3.add({bx, by, bz}, {x, y, z}), {0.5, 0.5, 0.5}), item.index(loot["id"]), loot["count"], {}, 1.0)

        audio.play_sound_2d("misc/pickitem_1", VOLUME_2D, 1)
    else
        console.chat("You put your hand in the hole but found nothing.")
    end

    return true
end

function randchoice(in_table)
    return in_table[math.random(1, #in_table)]
end