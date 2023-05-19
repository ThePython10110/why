ghost_blocks = {}

ghost_blocks.block_list = {
    mcl_core = { --If this mod is defined, all blocks in the list will have ghost versions registered.
        --"mcl_core:slimeblock",
    },
    --default = {}
}

ghost_blocks.group_list = {
    "solid",
    "wood",
    "tree",
    "slab_wood",
    "raw_meat_block",
    "cooked_meat_block",
    "burnt_meat_block",
    "sand",
    "soil",
    "cobble",
    "stone",
    "wool",
    "leaves",
    "glass",
    "shulker_box",
    "baked_clay",
    "pane",
    "fence",
    "tnt",
    "anvil",
    "solid",
    "slab",
    "stair",
    "pickaxey",
    "axey",
    "shovely",
    "handy",
    "hoey",
    "swordy",
    "solid_liquid"
}

ghost_blocks.block_map = {}

function ghost_blocks.register_ghost_block(block)
    if not block then
        return
    end
    local block_data = nil
    pcall(function()
        block_data = table.copy(minetest.registered_nodes[block])
    end)
    if not block_data then
        minetest.log("error", "Could not create ghost block from "..block)
        return
    end
    local _, _, new_name = string.find(block, ".+:(.+)")
    if not new_name then
        minetest.log("error", "Could not create ghost block from "..block)
        return
    end
    new_name = "ghost_blocks:"..new_name
    if block == "mcl_enchanting:table" then
        new_name = "ghost_blocks:enchanting_table"
    elseif block == "mcl_smithing_table:table" then
        new_name = "ghost_blocks:smithing_table" 
    end
    if block == "ghost_blocks:ghostifier" then
        return
    end
    block_data.walkable = false
    block_data.post_effect_color = "#00000000"
    if not block_data.description then
        block_data.description = "Ghost "..block
    else
        block_data.description = "Ghost "..block_data.description
    end
    block_data.groups.ghost_block = 1
    block_data.groups.not_in_creative_inventory = 1
    block_data.groups.not_in_craft_guide = 1
    block_data.drop = new_name
	block_data._mcl_silk_touch_drop = {new_name}
    --override functions
    --block_data.on_place = nil
    --block_data.on_use = nil
    --block_data.on_secondary_use = nil
    --block_data.after_place_node = nil
    block_data.on_construct = nil
    --block_data.on_rightclick = nil
    --block_data.on_click = nil --is this a thing? Or just on_punch?
    --block_data.on_walk_over = nil
    --block_data.on_punch = nil
    --block_data.on_timer = nil
    --block_data.groups.eatable = nil
    --block_data._mcl_saturation = nil
    block_data.after_dig_node = nil --fixes enchanting table duplication
    if new_name == "ghost_blocks:ender_chest" then
        block_data.groups.pickaxey = 1
    end
    if new_name == "ghost_blocks:chest" then
        block_data.groups.axey = 1
    end
    if block_data.groups.shulker_box then
        block_data.groups.pickaxey = 1
    end
    --minetest.log(tostring(new_name))
    minetest.register_node(new_name, block_data)

    ghost_blocks.block_map[block] = new_name

end

local ghostifier_formspec =
"size[9,7]"..
"label[0.3,0.3;"..minetest.formspec_escape(minetest.colorize("#313131", "Ghostifier")).."]"..
"list[context;src;1.5,1;1,1]"..
mcl_formspec.get_itemslot_bg(1.5,1,1,1)..
"list[context;dst;5,1;1,1]"..
mcl_formspec.get_itemslot_bg(5,1,1,1)..
"list[current_player;main;0,2.5;9,3;9]"..
mcl_formspec.get_itemslot_bg(0,2.5,9,3)..
"list[current_player;main;0,6;9,1;]"..
mcl_formspec.get_itemslot_bg(0,6,9,1)..
"listring[context;dst]"..
"listring[current_player;main]"..
"listring[context;src]"..
"listring[current_player;main]"

minetest.register_node("ghost_blocks:ghostifier", {
    description = "Ghostifier",
    hardness = 10,
    walkable = false,
    use_texture_alpha = "blend",
    sunlight_propagates = true,
    paramtype = "light",
    drawtype = "allfaces",
    tiles = {"ghost_blocks_ghostifier.png"},
    groups = {ghost_block = 1, pickaxey = 1},
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if listname == "src" then
            return stack:get_count()
    
        elseif listname == "dst" then
            return 0
        end
    end,
    
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = minetest.get_meta(pos)
        local meta2 = meta:to_table()
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for _, listname in ipairs({"src", "dst"}) do
            local stack = inv:get_stack(listname, 1)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                minetest.add_item(p, stack)
            end
        end
        meta:from_table(meta2)
	end,
    
     allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
    end,
    
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        return stack:get_count()
    end,

    on_timer = function(pos, elapsed)
        --minetest.log("on_timer")
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local update = true
        --minetest.log(elapsed)
        
        while elapsed > 0 and update do
            update = false
            if not inv:is_empty("src") then
                --minetest.log("src not empty")
                local src_stack = inv:get_stack("src", 1)
                local dst_stack = inv:get_stack("dst", 1)
                local original_itemstring = src_stack:get_name()
                local new_itemstring = ghost_blocks.block_map[original_itemstring]
                if new_itemstring then
                    --minetest.log("Original: "..original_itemstring..", New: "..new_itemstring)
                    if not inv:is_empty("dst") then
                        if new_itemstring ~= dst_stack:get_name() then
                            --minetest.log("dst contains different block, stopping")
                            break --if dst is full of different block
                        end
                        --minetest.log("dst contains correct block, continuing.")
                    end
                    if dst_stack:is_empty() then
                        -- create a new stack
                        dst_stack = ItemStack(new_itemstring)
                        src_stack:set_count(src_stack:get_count() - 1)
                        --minetest.log("dst is empty, creating new itemstack")
                    elseif dst_stack:get_count() >= 64 then
                        --minetest.log("dst is full, stopping")
                        -- the max item count is limited to 64
                        break
                    else
                        -- add one node into stack
                        --minetest.log("dst++; src--")
                        dst_stack:set_count(dst_stack:get_count() + 1)
                        src_stack:set_count(src_stack:get_count() - 1)
                    end
                    --minetest.log("setting src and dst")
                    inv:set_stack("dst", 1, dst_stack)
                    inv:set_stack("src", 1, src_stack)
                    
                    update = true
                end
    
            else
                --minetest.log("src is empty")
            end
        end
        minetest.get_node_timer(pos):stop()
        return false
    end,
    on_metadata_inventory_move = function(pos)
        minetest.get_node_timer(pos):start(1.0)
    end,
    on_metadata_inventory_put = function(pos)
        minetest.get_node_timer(pos):start(1.0)
    end,
    on_metadata_inventory_take = function(pos)
        minetest.get_node_timer(pos):start(1.0)
    end,
    
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("dst", 1)
        meta:set_string("formspec", ghostifier_formspec)
        --on_timer(pos, 0)
    end
})

minetest.register_craft({
    output = "ghost_blocks:ghostifier",
    recipe = {
        {"mcl_core:glass", "mcl_core:glass", "mcl_core:glass"},
        {"mcl_core:glass", "mcl_mobitems:ghast_tear", "mcl_core:glass"},
        {"mcl_core:glass", "mcl_core:glass", "mcl_core:glass"}
    }
})

for dependency, block_list in pairs(ghost_blocks.block_list) do --Register indivdual blocks in block_list
    if minetest.get_modpath(dependency) then
        for _, block in ipairs(block_list) do
            --minetest.log(block)
            ghost_blocks.register_ghost_block(block)
        end
    end
end

local grouped_items = get_group_items(ghost_blocks.group_list)
for _, group in ipairs(ghost_blocks.group_list) do --Register all blocks in groups in group_list
    for _, block in pairs(grouped_items[group]) do
        ghost_blocks.register_ghost_block(block)
    end
end