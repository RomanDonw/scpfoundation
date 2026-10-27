local util = require("base:util")

local RECIPIES = json.parse(file.read(PACK_ID .. ":config/scp914-recipies.json"))
--local INTERACTION_COOLDOWN = 6

local x, y, z = nil

local c1_x, c1_y, c1_z = nil
local c1_x_sz, c1_y_sz, c1_z_sz = nil
local c2_x, c2_y, c2_z = nil
local mode = 0

function on_open(_x, _y, _z)
    if _x == nil or _y == nil or _z == nil then
        print("Unset required arguments in hud.show_overlay for GUI " .. PACK_ID .. ":scp914_panel.")
        hud.close(PACK_ID .. ":scp914_panel")
    end
    x = _x
    y = _y
    z = _z

    c1_x = block.get_field(x, y, z, "c1_x")
    c1_y = block.get_field(x, y, z, "c1_y")
    c1_z = block.get_field(x, y, z, "c1_z")

    c1_x_sz = block.get_field(x, y, z, "c1_x_sz")
    c1_y_sz = block.get_field(x, y, z, "c1_y_sz")
    c1_z_sz = block.get_field(x, y, z, "c1_z_sz")

    c2_x = block.get_field(x, y, z, "c2_x")
    c2_y = block.get_field(x, y, z, "c2_y")
    c2_z = block.get_field(x, y, z, "c2_z")

    mode = block.get_field(x, y, z, "mode")
    update_mode_visual(mode)
    

    --[[local c2_x_sz = block.get_field(x, y, z, "c2_x_sz")
    local c2_y_sz = block.get_field(x, y, z, "c2_y_sz")
    local c2_z_sz = block.get_field(x, y, z, "c2_z_sz")]]--


end

function update_mode_visual(_mode)
    if _mode == 0 then
        document.mode.text = "Rough"
    elseif _mode == 1 then
        document.mode.text = "Coarse"
    elseif _mode == 2 then
        document.mode.text = "1:1"
    elseif _mode == 3 then
        document.mode.text = "Fine"
    elseif _mode == 4 then
        document.mode.text = "Very fine"
    else
        document.mode.text = "UNDEFINED MODE " .. _mode
    end
end

function set_mode(_mode)
    block.set_field(x, y, z, "mode", _mode)
    mode = _mode
    update_mode_visual(_mode)
end

function finditembyID(items, id)
    local ret = nil
    for _k, item in pairs(items) do
        --print(item["id"])
        if item["id"] == id then
            ret = item
            break
        end
    end
    return ret
end

function removeitem(items, id, count)
    local item = finditembyID(items, id)
    if item == nil then return end

    if item["count"] > count then
        item["count"] = item["count"] - count
        item["entity"]:get_component("base:drop").ARGS.count = item["count"]
    elseif item["count"] == count then
        item["entity"]:despawn()
        table.remove_value(items, item)
    else
        return false
    end
    return true
end

function test()
    hud.close(PACK_ID .. ":scp914_panel")
    block.set_field(x, y, z, "last_interaction_time", time.uptime())

    local items = {}

    for _k, ent_uid in pairs(entities.get_all_in_box({c1_x, c1_y, c1_z}, {c1_x_sz, c1_y_sz, c1_z_sz})) do
        local ent = entities.get(ent_uid)
        local ent_name = entities.def_name(entities.get_def(ent_uid))

        if ent_name == "base:drop" then
            local comp = ent:get_component("base:drop")
            --print(item.name(comp.ARGS.id))
            table.insert(items, {id = item.name(comp.ARGS.id), count = comp.ARGS.count, data = comp.ARGS.data, entity = ent})
        else
            ent.transform:set_pos({c2_x, c2_y, c2_z})
        end
    end
    
    local mode_str = ""

    if mode == 0 then
        mode_str = "rough"
    elseif mode == 1 then
        mode_str = "coarse"
    elseif mode == 2 then
        mode_str = "1:1"
    elseif mode == 3 then
        mode_str = "fine"
    elseif mode == 4 then
        mode_str = "very-fine"
    end

    if #items > 0 then
        local recipies = RECIPIES[mode_str]
        local recipie = nil
        
        -- find recipie
        for _k, curr_recipie in pairs(recipies) do
            local found = true

            for _k, recpitem in pairs(curr_recipie["inputs"]) do

                local item = finditembyID(items, recpitem["id"])
                -- for _k, it in pairs(items) do
                --     --found = found and (item[]recpitem["id"] and )
                --     if it["id"] == recpitem["id"] then
                --         item = it
                --         break
                --     end
                -- end
                --print(item["id"], item["count"])

                if item ~= nil then
                    if item["count"] < recpitem["count"] then found = false end
                else
                    found = false
                end

                if not found then break end
            end

            if found then
                recipie = curr_recipie
                break
            end
        end

        -- process recipie
        if recipie ~= nil then
            --local outcount = 0

            for _k, recpitem in pairs(recipie["inputs"]) do
                removeitem(items, recpitem["id"], recpitem["count"])
            end

            if math.random() < recipie["success-chance"] then
                for _k, recpitem in pairs(recipie["outputs"]) do
                    util.drop({c2_x, c2_y, c2_z}, item.index(recpitem["id"]), recpitem["count"])
                end
            end
        end
    end
end