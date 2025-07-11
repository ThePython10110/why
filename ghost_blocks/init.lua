local glass_itemstring = "default:glass"
local center_itemstring = "default:diamond"
if why.mcl then
    glass_itemstring = "mcl_core:glass"
    center_itemstring = "mcl_mobitems:ghast_tear"
end

why.ghost_blocks = {}

why.ghost_blocks.block_list = {
    mcl_core = { --If this mod is defined, all blocks in the list will have ghost versions registered.
        --"mcl_core:slimeblock",
    },
    --default = {}
}

why.ghost_blocks.group_list = {
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
    "solid_liquid",
    "cracky",
    "oddly_breakable_by_hand",
    "snappy",
    "crumbly",
    "choppy",
}

why.ghost_blocks.block_map = {}

function why.ghost_blocks.register_ghost_block(block)
    if not block then
        return
    end
    local block_data = nil
    pcall(function()
        block_data = table.copy(core.registered_nodes[block])
    end)
    if not block_data then
        core.log("error", "Could not create ghost block from "..block)
        return
    end
    if block == "ghost_blocks:ghostifier" then
        return
    end
    local new_name = "ghost_blocks:"..block:gsub(":", "_")
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
    if why.mcl then
        if new_name == "ghost_blocks:mcl_chests_ender_chest" then
            block_data.groups.pickaxey = 1
        end
        if new_name == "ghost_blocks:mcl_chests_chest" then
            block_data.groups.axey = 1
        end
        if block_data.groups.shulker_box then
            block_data.groups.pickaxey = 1
        end
    end
    --core.log(tostring(new_name))
    core.register_node(":"..new_name, block_data)

    why.ghost_blocks.block_map[block] = new_name
    why.ghost_blocks.block_map[new_name] = block

end


local width = 8
if why.mcl then width = 9 end

local ghostifier_formspec =
    "size["..tostring(width)..",7]"..
    "label[0.3,0.3;"..core.formspec_escape(core.colorize("#55555", "Ghostifier")).."]"..
    "list[context;src;1.5,1;1,1]"..
    "list[context;dst;5,1;1,1]"..
    why.inventory_formspec(0,2.5)..
    "listring[context;dst]"..
    "listring[current_player;main]"..
    "listring[context;src]"..
    "listring[current_player;main]"

if why.mcl then
    ghostifier_formspec = ghostifier_formspec..
    mcl_formspec.get_itemslot_bg(1.5,1,1,1)..
    mcl_formspec.get_itemslot_bg(5,1,1,1)
end

local function ghostifier_action(pos, player)
    local meta = core.get_meta(pos)
    local inv = meta:get_inventory()
    if not inv:is_empty("src") then
        local src_stack = inv:get_stack("src", 1)
        local dst_stack = inv:get_stack("dst", 1)
        local original_itemstring = src_stack:get_name()
        local new_itemstring
        if original_itemstring == "ghost_blocks:ghostifier" then
            new_itemstring = ""
        else
            new_itemstring = why.ghost_blocks.block_map[original_itemstring]
            --core.log(dump(new_itemstring))
            if (not new_itemstring) or new_itemstring == "" then return end
        end
        if not inv:is_empty("dst") then
            if new_itemstring ~= dst_stack:get_name() then
                return --if dst is full of different block
            end
        end
        local added_amount
        if original_itemstring == "ghost_blocks:ghostifier" then
            added_amount = src_stack:get_count()
            if awards and player then
                awards.unlock(player:get_player_name(), "why:nope")
            end
        else
            added_amount = src_stack:get_count() - inv:add_item("dst", ItemStack(new_itemstring.." "..tostring(src_stack:get_count()))):get_count()
        end
        src_stack:set_count(src_stack:get_count() - added_amount)
        if src_stack:get_count() == 0 then src_stack = ItemStack("") end
        inv:set_stack("src", 1, src_stack)
    end
end

core.register_node("ghost_blocks:ghostifier", {
    description = "Ghostifier",
    inventory_image = "[inventorycube{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png",
    wield_image = "[inventorycube{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png",
    _mcl_hardness = 1.5,
    _mcl_blast_resistance = 6,
    walkable = false,
    use_texture_alpha = "blend",
    sunlight_propagates = true,
    paramtype = "light",
    drawtype = "allfaces",
    tiles = {"ghost_blocks_ghostifier.png"},
    groups = {ghost_block = 1, pickaxey = 1, cracky = 2, container = 4},
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if core.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if listname == "src" then
            return stack:get_count()
        else
            return 0
        end
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local meta = core.get_meta(pos)
        local meta2 = meta:to_table()
        meta:from_table(oldmetadata)
        local inv = meta:get_inventory()
        for _, listname in ipairs({"src", "dst"}) do
            local stack = inv:get_stack(listname, 1)
            if not stack:is_empty() then
                local p = {x=pos.x+math.random(0, 10)/10-0.5, y=pos.y, z=pos.z+math.random(0, 10)/10-0.5}
                core.add_item(p, stack)
            end
        end
        meta:from_table(meta2)
	end,

     allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        if core.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if to_list == "src" then
            return stack:get_count()
        else
            return 0
        end
    end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if core.is_protected(pos, player:get_player_name()) then
            return 0
        end
        return stack:get_count()
    end,

    on_timer = ghostifier_action,

    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        ghostifier_action(pos, player)
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        ghostifier_action(pos, player)
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        ghostifier_action(pos, player)
    end,

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("dst", 1)
        meta:set_string("formspec", ghostifier_formspec)
        --on_timer(pos, 0)
    end
})

core.register_craft({
    output = "ghost_blocks:ghostifier",
    recipe = {
        {glass_itemstring, glass_itemstring, glass_itemstring},
        {glass_itemstring, center_itemstring, glass_itemstring},
        {glass_itemstring, glass_itemstring, glass_itemstring}
    }
})

core.register_on_mods_loaded(function()

for dependency, block_list in pairs(why.ghost_blocks.block_list) do --Register indivdual blocks in block_list
    if core.get_modpath(dependency) then
        for _, block in ipairs(block_list) do
            --core.log(block)
            why.ghost_blocks.register_ghost_block(block)
        end
    end
end

local grouped_items = why.get_group_items(why.ghost_blocks.group_list)
for _, group in ipairs(why.ghost_blocks.group_list) do --Register all blocks in groups in group_list
    for _, block in pairs(grouped_items[group]) do
        why.ghost_blocks.register_ghost_block(block)
    end
end
end)

if awards then
    awards.register_achievement("why:nope", {
        title = "Nope. It's gone now.",
        description = "Attempt to ghostify a ghostifier.",
        icon = "[inventorycube{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png{ghost_blocks_ghostifier.png",
        type = "Advancement",
        group = "Why",
        secret = true
    })
end