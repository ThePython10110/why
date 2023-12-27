local sand = "default:sand"
local gravel = "default:gravel"
local stick = "default:stick"
if why.mcl then
    sand = "mcl_core:sand"
    gravel = "mcl_core:gravel"
    stick = "mcl_core:stick"
end

minetest.register_tool("falling_block_tool:falling_block_tool", {
    description = "Falling Block Tool",
    wield_image = "falling_block_tool.png",
    inventory_image = "falling_block_tool.png",
    on_place = function(itemstack, player, pointed_thing)
        if not player:get_player_control().sneak then
            -- Call on_rightclick if the pointed node defines it
            if pointed_thing and pointed_thing.type == "node" then
                local pos = pointed_thing.under
                local node = minetest.get_node(pos)
                if player and not player:get_player_control().sneak then
                    local nodedef = minetest.registered_nodes[node.name]
                    local on_rightclick = nodedef and nodedef.on_rightclick
                    if on_rightclick then
                        return on_rightclick(pos, node, player, itemstack, pointed_thing) or itemstack
                    end
                end
            end
        end
        if not pointed_thing.under then return end
        local node = minetest.get_node(pointed_thing.under)
        local def = minetest.registered_items[node.name]
        if ((def.can_dig and def.can_dig(pointed_thing.under, player)) or
        not def.can_dig) and def._mcl_hardness ~= -1
         then
            minetest.spawn_falling_node(pointed_thing.under)
            itemstack:add_wear(65536/2031)
            if awards then
                awards.unlock(player:get_player_name(), "why:gravity")
            end
        end
    end
})

minetest.register_craft({
    output = "falling_block_tool:falling_block_tool",
    recipe = {
        {"", stick, ""},
        {sand, stick, sand},
        {"", gravel, ""},
    }
})

if awards then
    awards.register_achievement("why:gravity", {
        title = "Gravity is Koool",
        description = "Use a Falling Block Tool",
        icon = "falling_block_tool.png",
        type = "Advancement",
        group = "Why"
    })
end