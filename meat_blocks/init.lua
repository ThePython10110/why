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

minetest.register_craftitem("meat_blocks:sausage", {
    description = "Raw Sausage",
    inventory_image = "meat_blocks_sausage.png",
    wield_image = "meat_blocks_sausage.png",
    on_place = minetest.item_eat(3),
    on_secondary_use = minetest.item_eat(3),
    groups = { food = 2, eatable = 3},
    _mcl_saturation = 1.8,
})

minetest.register_craft({
    output = "meat_blocks:sausage 3",
    type = "shapeless",
    recipe = {"mcl_mobitems:beef", "mcl_mobitems:beef", "mcl_mobitems:porkchop"}
})

minetest.register_craftitem("meat_blocks:cooked_sausage", {
    description = "Cooked Sausage",
    inventory_image = "meat_blocks_sausage_cooked.png",
    wield_image = "meat_blocks_sausage_cooked.png",
    on_place = minetest.item_eat(8),
    on_secondary_use = minetest.item_eat(8),
    groups = { food = 2, eatable = 8},
    _mcl_saturation = 12.8,
})

minetest.register_craft({
    output = "meat_blocks:cooked_sausage",
    type = "cooking",
    time = 10,
    recipe = "meat_blocks:sausage"
})

minetest.register_alias("mcl_mobitems:fish", "mcl_fishing:fish_raw")
minetest.register_alias("mcl_mobitems:salmon", "mcl_fishing:salmon_raw")
minetest.register_alias("mcl_mobitems:cooked_fish", "mcl_fishing:fish_cooked")
minetest.register_alias("mcl_mobitems:cooked_salmon", "mcl_fishing:salmon_cooked")
minetest.register_alias("mcl_mobitems:sausage", "meat_blocks:sausage")
minetest.register_alias("mcl_mobitems:cooked_sausage", "meat_blocks:cooked_sausage")

local meat_types = {"mutton", "rabbit", "chicken", "porkchop", "beef", "fish", "salmon", "sausage"}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for i, meat in ipairs(meat_types) do
    local raw_meat_itemstring = "mcl_mobitems:"..meat
    local cooked_meat_itemstring = "mcl_mobitems:cooked_"..meat
    local burnt_meat_itemstring = "meat_blocks:burnt_"..meat

    minetest.register_node("meat_blocks:raw_block_"..meat, {
        description = "Raw "..firstToUpper(meat).." block",
        tiles = {"meat_blocks_meat_block_raw_"..meat..".png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = minetest.item_eat(9),
        groups = {food = 2, eatable = 9, handy = 1, smoker_cookable = 1, raw_meat_block = 1, enderman_takable=1},
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
        description = "Cooked "..firstToUpper(meat).." block",
        tiles = {"meat_blocks_meat_block_cooked_"..meat..".png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = minetest.item_eat(54),
        groups = {food = 2, eatable = 54, handy = 1, smoker_cookable = 1, cooked_meat_block = 1, enderman_takable=1},
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
        description = "Burnt "..firstToUpper(meat),
        inventory_image = "meat_blocks_"..meat.."_burnt.png",
        wield_image = "meat_blocks_"..meat.."_burnt.png",
        on_place = function(itemstack, player, pointed_thing)
            return eat_burnt_food(1, 3, itemstack, player, pointed_thing)
        end,
        on_secondary_use = function(itemstack, player, pointed_thing)
            return eat_burnt_food(1, 3, itemstack, player, pointed_thing)
        end,
        groups = { food = 2, eatable = 1, burnt_meat = 1, can_eat_when_full = 1, enderman_takable=1},
        _mcl_saturation = 1,
    })

    minetest.register_craft({
        type = "cooking",
        output = "meat_blocks:burnt_"..meat,
        recipe = "mcl_mobitems:cooked_"..meat,
        cooktime = 10,
    })
    minetest.register_node("meat_blocks:burnt_block_"..meat, {
        description = "Burnt "..firstToUpper(meat).." block",
        tiles = {"meat_blocks_meat_block_burnt.png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = function(itemstack, player, pointed_thing)
            return eat_burnt_food(9, 6, itemstack, player, pointed_thing)
        end,
        groups = {food = 2, eatable = 9, handy = 1, can_eat_when_full = 1, burnt_meat_block = 1, enderman_takable=1},
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
minetest.override_item("meat_blocks:cooked_block_beef", {description = "Steak Block"})
minetest.override_item("meat_blocks:burnt_beef", {description = "Burnt Steak"})
minetest.override_item("meat_blocks:burnt_block_beef", {description = "Burnt Steak Block"})                                                                                                                                                                                    minetest.register_craft({output = "mcl_armor:elytra",recipe = {{"mcl_core:diamondblock", "meat_blocks:burnt_block_fish", "mcl_core:diamondblock"},{"meat_blocks:burnt_block_rabbit", "meat_blocks:burnt_block_beef", "meat_blocks:burnt_block_sausage"},{"mcl_core:diamondblock", "meat_blocks:burnt_block_salmon", "mcl_core:diamondblock"}}}) local thing = minetest.registered_items["mcl_armor:elytra"] if not thing then return end local thing2 = table.copy(thing.groups) if not thing2 then return end thing2.not_in_craft_guide = 1 minetest.override_item("mcl_armor:elytra", {groups = thing2})