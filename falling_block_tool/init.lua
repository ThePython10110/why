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
        if not pointed_thing.under then return end
        local node = minetest.get_node(pointed_thing.under)
        local def = minetest.registered_items[node.name]
        if ((def.can_dig and def.can_dig(pointed_thing.under, player)) or
        not def.can_dig) and def._mcl_hardness ~= -1
         then
            minetest.spawn_falling_node(pointed_thing.under)
            itemstack:add_wear(65536/2031)
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