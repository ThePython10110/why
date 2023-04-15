local function eat_burnt_food(hunger_restore, fire_time, itemstack, player, pointed_thing)
    if not player:get_player_control().sneak then 
        local new_stack = mcl_util.call_on_rightclick(itemstack, player, pointed_thing)
        if new_stack then
            return new_stack
        end
    end
    mcl_burning.set_on_fire(player, fire_time)
    local burnt_food_hunger_restore = minetest.item_eat(hunger_restore)
    return burnt_food_hunger_restore(itemstack, player, pointed_thing)
end

minetest.register_alias("mcl_mobitems:fish", "mcl_fishing:fish_raw")
minetest.register_alias("mcl_mobitems:salmon", "mcl_fishing:salmon_raw")
minetest.register_alias("mcl_mobitems:cooked_fish", "mcl_fishing:fish_cooked")
minetest.register_alias("mcl_mobitems:cooked_salmon", "mcl_fishing:salmon_cooked")

local meat_types = {"mutton", "rabbit", "chicken", "porkchop", "beef", "fish", "salmon"}

for i, meat in ipairs(meat_types) do
    local raw_meat_itemstring = "mcl_mobitems:"..meat
    local cooked_meat_itemstring = "mcl_mobitems:cooked_"..meat
    local burnt_meat_itemstring = "meat_blocks:burnt_"..meat

    minetest.register_node("meat_blocks:raw_block_"..meat, {
        description = "Raw "..meat.." block",
        tiles = {"meat_blocks_meat_block_raw_"..meat..".png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = minetest.item_eat(9),
        groups = {food = 2, eatable = 9, handy = 1, smoker_cookable = 1, raw_meat_block = 1},
        _mcl_hardness = 0.3,
        _mcl_blast_resistance = 1,
        _mcl_saturation = 5,
    })
    
    minetest.register_craft({
        output = "meat_blocks:raw_block_"..meat,
        recipe = {
            {raw_meat_itemstring, raw_meat_itemstring, raw_meat_itemstring},
            {raw_meat_itemstring, raw_meat_itemstring, raw_meat_itemstring},
            {raw_meat_itemstring, raw_meat_itemstring, raw_meat_itemstring}
        }
    })
    minetest.register_craft({
        output = raw_meat_itemstring.." 9",
        type = "shapeless",
        recipe = {"meat_blocks:raw_block_"..meat}
    })

    minetest.register_node("meat_blocks:cooked_block_"..meat, {
        description = "Cooked "..meat.." block",
        tiles = {"meat_blocks_meat_block_cooked_"..meat..".png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = minetest.item_eat(45),
        groups = {food = 2, eatable = 9, handy = 1, smoker_cookable = 1, cooked_meat_block = 1},
        _mcl_hardness = 0.3,
        _mcl_blast_resistance = 1,
        _mcl_saturation = 54,
    })
    
    minetest.register_craft({
        output = "meat_blocks:cooked_block_"..meat,
        recipe = {
            {cooked_meat_itemstring, cooked_meat_itemstring, cooked_meat_itemstring},
            {cooked_meat_itemstring, cooked_meat_itemstring, cooked_meat_itemstring},
            {cooked_meat_itemstring, cooked_meat_itemstring, cooked_meat_itemstring}
        }
    })
    minetest.register_craft({
        output = cooked_meat_itemstring.." 9",
        type = "shapeless",
        recipe = {"meat_blocks:cooked_block_"..meat}
    })
    minetest.register_craft({
        output = "meat_blocks:cooked_block_"..meat,
        type = "cooking",
        recipe = "meat_blocks:raw_block_"..meat,
        time = 90
    })

    minetest.register_craftitem("meat_blocks:burnt_"..meat, {
        description = "Burnt "..meat,
        inventory_image = "meat_blocks_"..meat.."_burnt.png",
        wield_image = "meat_blocks_"..meat.."_burnt.png",
        on_place = function(itemstack, player, pointed_thing)
            return eat_burnt_food(1, 3, itemstack, player, pointed_thing)
        end,
        on_secondary_use = function(itemstack, player, pointed_thing)
            return eat_burnt_food(1, 3, itemstack, player, pointed_thing)
        end,
        groups = { food = 2, eatable = 1, burnt_meat = 1},
        _mcl_saturation = 1,
    })

    minetest.register_craft({
        type = "cooking",
        output = "meat_blocks:burnt_"..meat,
        recipe = "mcl_mobitems:cooked_"..meat,
        cooktime = 10,
    })
    minetest.register_node("meat_blocks:burnt_block_"..meat, {
        description = "Burnt "..meat.." block",
        tiles = {"meat_blocks_meat_block_burnt.png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = function(itemstack, player, pointed_thing)
            return eat_burnt_food(9, 6, itemstack, player, pointed_thing)
        end,
        groups = {food = 2, eatable = 9, handy = 1, can_eat_when_full = 1, burnt_meat_block = 1},
        _mcl_hardness = 0.3,
        _mcl_blast_resistance = 1,
        _mcl_saturation = 9,
    })

    minetest.register_craft({
        output = "meat_blocks:burnt_block_"..meat,
        recipe = {
            {burnt_meat_itemstring, burnt_meat_itemstring, burnt_meat_itemstring},
            {burnt_meat_itemstring, burnt_meat_itemstring, burnt_meat_itemstring},
            {burnt_meat_itemstring, burnt_meat_itemstring, burnt_meat_itemstring}
        }
    })
    minetest.register_craft({
        type = "shapeless",
       output = burnt_meat_itemstring.." 9",
       recipe = {"meat_blocks:burnt_block_"..meat}
    })
    minetest.register_craft({
        output = "meat_blocks:burnt_block_"..meat,
        type = "cooking",
        recipe = "meat_blocks:cooked_block_"..meat,
        time = 90
    })
end

mcl_hunger.register_food("meat_blocks:raw_block_chicken", 9, "", 30, 0, 100, 30)
