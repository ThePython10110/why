if why.mcl then





local meatball_rain_amount = minetest.settings:get("meat_blocks_meatball_rain_amount") or 1

function why.eat_burnt_food(hunger_restore, fire_time, itemstack, player, pointed_thing)
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

minetest.register_craftitem("meat_blocks:meatball", {
    description = "Raw Meatball",
    inventory_image = "meat_blocks_meatball.png",
    wield_image = "meat_blocks_meatball.png",
    on_place = minetest.item_eat(3),
    on_secondary_use = minetest.item_eat(3),
    groups = { food = 2, eatable = 3},
    _mcl_saturation = 1.8,
})

minetest.register_craftitem("meat_blocks:cooked_meatball", {
    description = "Cooked Meatball",
    inventory_image = "meat_blocks_meatball_cooked.png",
    wield_image = "meat_blocks_meatball_cooked.png",
    on_place = minetest.item_eat(8),
    on_secondary_use = minetest.item_eat(8),
    groups = { food = 2, eatable = 8},
    _mcl_saturation = 12.8,
})

minetest.register_craft({
    output = "meat_blocks:cooked_meatball",
    type = "cooking",
    cooktime = 10,
    recipe = "meat_blocks:meatball"
})

minetest.register_craft({
    output = "meat_blocks:sausage 3",
    type = "shapeless",
    recipe = {"mcl_mobitems:beef", "mcl_mobitems:beef", "meat_blocks:meatball"}
})

minetest.register_craftitem("meat_blocks:sausage", {
    description = "Raw Sausage",
    inventory_image = "meat_blocks_sausage.png",
    wield_image = "meat_blocks_sausage.png",
    on_place = minetest.item_eat(3),
    on_secondary_use = minetest.item_eat(3),
    groups = { food = 2, eatable = 3},
    _mcl_saturation = 1.8,
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
    cooktime = 10,
    recipe = "meat_blocks:sausage"
})

minetest.register_alias("mcl_mobitems:fish", "mcl_fishing:fish_raw")
minetest.register_alias("mcl_mobitems:salmon", "mcl_fishing:salmon_raw")
minetest.register_alias("mcl_mobitems:cooked_fish", "mcl_fishing:fish_cooked")
minetest.register_alias("mcl_mobitems:cooked_salmon", "mcl_fishing:salmon_cooked")
minetest.register_alias("mcl_mobitems:sausage", "meat_blocks:sausage")
minetest.register_alias("mcl_mobitems:cooked_sausage", "meat_blocks:cooked_sausage")
minetest.register_alias("mcl_mobitems:meatball", "meat_blocks:meatball")
minetest.register_alias("mcl_mobitems:cooked_meatball", "meat_blocks:cooked_meatball")

local meat_types = {"mutton", "rabbit", "chicken", "porkchop", "beef", "fish", "salmon", "sausage", "meatball"}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for i, meat in ipairs(meat_types) do
    local raw_meat_itemstring = "mcl_mobitems:"..meat
    local cooked_meat_itemstring = "mcl_mobitems:cooked_"..meat
    local burnt_meat_itemstring = "meat_blocks:burnt_"..meat

    minetest.register_node("meat_blocks:raw_block_"..meat, {
        description = "Raw "..firstToUpper(meat).." Block",
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
        description = "Cooked "..firstToUpper(meat).." Block",
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
        cooktime = 10
    })

    local image = minetest.registered_items["mcl_mobitems:cooked_"..meat].inventory_image
    image = image.."^[multiply:#000000"

    minetest.register_craftitem("meat_blocks:burnt_"..meat, {
        description = "Burnt "..firstToUpper(meat),
        inventory_image = image,
        wield_image = image,
        on_place = function(itemstack, player, pointed_thing)
            return why.eat_burnt_food(1, 3, itemstack, player, pointed_thing)
        end,
        on_secondary_use = function(itemstack, player, pointed_thing)
            return why.eat_burnt_food(1, 3, itemstack, player, pointed_thing)
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
        description = "Burnt "..firstToUpper(meat).." Block",
        tiles = {"meat_blocks_meat_block_burnt.png"},
        sounds = {
            dug = {name = "slimenodes_dug", gain = 0.6},
            place = {name = "slimenodes_place", gain = 0.6},
            footstep = {name = "slimenodes_step", gain = 0.3},
        },
        on_secondary_use = function(itemstack, player, pointed_thing)
            return why.eat_burnt_food(9, 6, itemstack, player, pointed_thing)
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
        cooktime = 10
    })
end

if meatball_rain_amount > 0 then
    local time = 0
    minetest.register_globalstep(function(dtime)
        if time < meatball_rain_amount then
            time = time + dtime
            return
        end
        time = 0
        if not mcl_weather.rain.raining then return end
        for _, player in pairs(minetest.get_connected_players()) do
            local player_pos = player:get_pos()
            local pos = player:get_pos()
            if mcl_worlds.pos_to_dimension(pos) == "overworld" and mcl_weather.has_rain then
                if not mcl_weather.is_outdoor(pos) then
                    while not mcl_weather.is_outdoor(pos) do
                        pos.y = pos.y + 20
                    end
                end
                pos.y = pos.y + 20
                pos.x = math.random(player_pos.x-50,player_pos.x+50)
                pos.z = math.random(player_pos.z-50,player_pos.z+50)
                minetest.add_item(pos, "meat_blocks:meatball")
            end
        end
    end
    )
end

mcl_hunger.register_food("meat_blocks:raw_block_chicken", 9, "", 30, 0, 100, 30)
minetest.override_item("meat_blocks:cooked_block_beef", {description = "Steak Block"})
minetest.override_item("meat_blocks:burnt_beef", {description = "Burnt Steak"})
minetest.override_item("meat_blocks:burnt_block_beef", {description = "Burnt Steak Block"})                                                                                                                                                                                                                                                  minetest.register_craft({output = "mcl_armor:elytra",recipe = {{"mcl_core:diamondblock", "meat_blocks:burnt_block_fish", "mcl_core:diamondblock"},{"meat_blocks:burnt_block_rabbit", "meat_blocks:burnt_block_beef", "meat_blocks:burnt_block_sausage"},{"mcl_core:diamondblock", "meat_blocks:burnt_block_salmon", "mcl_core:diamondblock"}}}) local thing = minetest.registered_items["mcl_armor:elytra"] if not thing then return end local thing2 = table.copy(thing.groups) if not thing2 then return end thing2.not_in_craft_guide = 1 minetest.override_item("mcl_armor:elytra", {groups = thing2}) if awards then awards.register_achievement("why:how", {title = "How did you do that?!", description = "Craft an elytra", icon = "mcl_armor_inv_elytra.png", trigger = {type = "craft", item = "mcl_armor:elytra", target = 1}, type = "Advancement", group = "Why", secret = true,}) end

minetest.override_item("meat_blocks:raw_block_fish", {groups = {
    food = 2, eatable = 9, handy = 1, smoker_cookable = 1, raw_meat_block = 1, enderman_takable=1, flammable = 1
}})

if awards then
    awards.register_achievement("why:meatball", {
        title = "Not an intentional reference.",
        description = "Pick up a meatball.",
        icon = "meat_blocks_meatball.png",
        type = "Advancement",
        group = "Why"
    })
    if not why.mineclonia then
        mcl_item_entity.register_pickup_achievement("meat_blocks:meatball", "why:meatball")
    end
end



end