function place_structures(x, z, w, d, hmap, h)
    local placements = {}

    local SECTION_WIDTH = 4
    local SECTION_HEIGHT = 4
    local SECTION_DEPTH = 4

    --local lasthsection = h / SECTION_HEIGHT - 1
    local lasthsection = 4

    for sy = 0, lasthsection do
        for sz = 0, d / SECTION_DEPTH - 1 do
            for sx = 0, w / SECTION_WIDTH - 1 do
                if sy ~= lasthsection then
                    if math.random() < 0.3 then
                        local group = randchoice({"_", "pit", "col"})
                        if group == "pit" and sy ~= 0 then
                            table.insert(placements, {(math.random(1, 2) == 2 and "pit_with_arch" or "pit"), {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, 0, 0})
                        elseif group == "col" then
                            table.insert(placements, {(math.random(1, 2) == 2 and "corner_with_col" or "col"), {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, math.random(0, 3), 0})
                        elseif group == "_" then
                            local r = math.random()
                            if r < 0.5 and sy + 1 ~= lasthsection then
                                --table.insert(placements, {(math.random(1, 2) == 2 and "pit_with_arch" or "pit"), {sx * SECTION_WIDTH, (sy + 1) * SECTION_HEIGHT, sz * SECTION_DEPTH}, 0, 1024})
                                
                                for offsetx = 1, 2, 1 do
                                    for offsetz = 1, 2, 1 do
                                        table.insert(placements, {":block", 0, {x + sx * SECTION_WIDTH + offsetx, sy * SECTION_HEIGHT + 4, z + sz * SECTION_DEPTH + offsetz}, 0, 1})
                                    end
                                end

                                table.insert(placements, {"stairs", {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, math.random(0, 3), 2})

                                --table.insert(placements, {":block", block.index("base:torch"), {sx * SECTION_WIDTH + 2, sy * SECTION_HEIGHT + 2, sz * SECTION_DEPTH + 2}, 0, 1024})
                            else
                                table.insert(placements, {"arch", {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, 0, 0})
                            end
                        end
                    else
                        table.insert(placements, {"maze_" .. math.random(0, 3), {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, math.random(0, 3), 0})
                        
                    end
                else
                    table.insert(placements, {"floor", {sx * SECTION_WIDTH, sy * SECTION_HEIGHT, sz * SECTION_DEPTH}, 0, 0, 0})
                    
                end
            end
        end
    end

    return placements
end

function randchoice(in_table)
    return in_table[math.random(1, #in_table)]
end