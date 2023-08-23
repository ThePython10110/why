local sound_mod = default
local gold_itemstring = "default:gold_ingot"
local water_itemstring = "bucket:bucket_water"
local stick_itemstring = "default:stick"
if why.mineclone then
    sound_mod = mcl_sounds
    gold_itemstring = "mcl_core:gold_ingot"
    water_itemstring = "mcl_buckets:bucket_water"
    stick_itemstring = "mcl_core:stick"
end

---------------------USELESS BEANS, BEANGOTS, AND BLOCKS-----------------------------------

minetest.register_node("useful_green_potatoes:useful_green_potato", {
    description = "Useful Green Potato",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean.png"},
	sounds = sound_mod.node_sound_leaves_default,
    groups = {dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, dig_by_water = 1, food = 2, eatable = 5, compostability = 85},
	inventory_image = "useless_beans_useless_bean.png",
	wield_image = "useless_beans_useless_bean.png",
    walkable = false,
	on_secondary_use = minetest.item_eat(5),
	_mcl_saturation = 6.0,
})

local y_max = 31000
if why.mineclone then y_max = mcl_vars.mg_overworld_max end

minetest.register_decoration({
    decoration = "useful_green_potatoes:useful_green_potato",
    deco_type = "simple",
    height = 1,
    place_on = {"group:sand", "group:soil", "mcl_mud:mud"},
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = 0.001,
        spread = {x = 125, y = 125, z = 125},
        seed = 8932,
        octaves = 6,
        persist = 0.666
    },
    y_min = 1,
    y_max = y_max,
})

minetest.register_node("useful_green_potatoes:useful_green_potato_block", {
    description = "Useful Green Potato Block",
    tiles = {"useless_beans_useless_bean_block.png"},
	sounds = sound_mod.node_sound_leaves_default,
    groups = {dig_immediate = 3, plant = 1, deco_block = 1, fall_damage_add_percent = 150},
})

-- This function is so much more complicated than it needs to be because the player's position
-- is not always accurate (sometimes slightly too high/low), meaning that I have to check a lot
-- more nodes than I wish I did. It also means that there are a lot of false positives.
minetest.register_on_player_hpchange(function(player, hp_change, reason)
    if reason.type ~= "fall" then return hp_change end
    local player_pos = player:get_pos()
    player_pos.y = math.floor(player_pos.y)
    if not player_pos then return hp_change end
    local solid_detected = false
    local y = player_pos.y + 1
    while not solid_detected do
        for x = math.floor(player_pos.x), math.ceil(player_pos.x) do
            for z = math.floor(player_pos.z), math.ceil(player_pos.z) do
                if minetest.get_node({x=x,y=y+1,z=z}).name == "air" then
                    local pos = {x=x,y=y,z=z}
                    local node = minetest.get_node(pos)
                    if node.name ~= "air" then solid_detected = true end
                    if node.name == "useful_green_potatoes:useful_green_potato_block" then
                        return math.abs(hp_change), true
                    end
                end
            end
        end
        y = y - 1
    end
    return hp_change
end, true)

minetest.register_craft({
    output = "useful_green_potatoes:useful_green_potato_block",
    recipe = {
        {"useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato"},
        {"useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato"},
        {"useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato", "useful_green_potatoes:useful_green_potato"}
    }
})

minetest.register_craft({
    output = "useful_green_potatoes:useful_green_potato 9",
    type = "shapeless",
    recipe = {"useful_green_potatoes:useful_green_potato_block"}
})

minetest.register_craftitem("useful_green_potatoes:useful_green_potato_ingot", {
    description = "Useful Green Potato Ingot",
	inventory_image = "useless_beans_useless_bean_ingot.png",
	wield_image = "useless_beans_useless_bean_ingot.png",
    groups = {}
})

minetest.register_craft({
    output = "useful_green_potatoes:useful_green_potato_ingot",
    type = "cooking",
    recipe = "useful_green_potatoes:useful_green_potato",
    time = 20
})

minetest.register_node("useful_green_potatoes:useful_green_potato_ingot_block", {
    description = "Useful Green Potato Ingot Block",
    tiles = {"useless_beans_useless_bean_ingot_block.png"},
	sounds = sound_mod.node_sound_metal_default,
    groups = {plant = 1, deco_block = 1, pickaxey=4, cracky=3, fall_damage_add_percent = 600, contact_damage = 6},
	_mcl_blast_resistance = 6,
	_mcl_hardness = 3,
})

local time = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time < 0.5 then return end
	time = 0
	for _, player in pairs(minetest.get_connected_players()) do
		-- who am I?
		local name = player:get_player_name()

		-- where am I?
		local pos = player:get_pos()

        -- Am I near a useful green potato ingot block?
		local itemstring = "useful_green_potatoes:useful_green_potato_ingot_block"
        local near = minetest.find_node_near(pos, 1, itemstring)
        if not near then
            near = minetest.find_node_near({x=pos.x, y=pos.y-1, z=pos.z}, 1, itemstring)
        end
        if near then
            -- Am I touching the solid liquid source? If so, it hurts
            local dist = vector.distance(pos, near)
            local dist_feet = vector.distance({x=pos.x, y=pos.y-1, z=pos.z}, near)
            if dist < 1.1 or dist_feet < 1.1 then
                if player:get_hp() > 0 then
                    if why.mineclone then
                        mcl_util.deal_damage(player, 3, {type = "generic"})
                    else
                        player:set_hp(player:get_hp() - 3)
                    end
                end
            end
        end
    end
end)

minetest.register_craft({
    output = "useful_green_potatoes:useful_green_potato_ingot_block",
    recipe = {
        {"useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot"},
        {"useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot"},
        {"useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot", "useful_green_potatoes:useful_green_potato_ingot"}
    }
})

local gapple_hunger_restore = minetest.item_eat(6)

local function eat_gapple(itemstack, player, pointed_thing)
    if why.mineclone then
        local regen_duration, absorbtion_factor = 5, 1
        --TODO: Absorbtion
        mcl_potions.regeneration_func(player, 2, regen_duration)
    else
        player:set_hp((player:get_hp() or 20) + 6)
    end
	return gapple_hunger_restore(itemstack, player, pointed_thing)
end

minetest.register_node("useful_green_potatoes:useful_green_potato_gold", {
    description = "Golden Useful Green Potato",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean_gold.png"},
	sounds = sound_mod.node_sound_leaves_default,
    groups = {dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1, food = 2, eatable = 4, can_eat_when_full = 1},
	inventory_image = "useless_beans_useless_bean_gold.png",
	wield_image = "useless_beans_useless_bean_gold.png",
    walkable = false,
	on_secondary_use = eat_gapple,
	_mcl_saturation = 9.6,
})

minetest.register_craft({
    output = "useful_green_potatoes:useful_green_potato_gold",
    light_source = 14,
    recipe = {
        {gold_itemstring, gold_itemstring, gold_itemstring},
        {gold_itemstring, "useful_green_potatoes:useful_green_potato", gold_itemstring},
        {gold_itemstring, gold_itemstring, gold_itemstring}
    }
})

---------------------USELESS BEAN LIQUID----------------------------

local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end

local WATER_VISC = 1

minetest.register_node("useful_green_potatoes:useful_green_potato_liquid_flowing", {
	description = "Flowing Useful Green Potato Liquid",
	_doc_items_create_entry = false,
	wield_image = "useless_beans_water_flowing_animated.png^[verticalframe:64:0",
	drawtype = "flowingliquid",
	tiles = {"useless_beans_water_flowing_animated.png^[verticalframe:64:0"},
	special_tiles = {
		{
			image="useless_beans_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
		{
			image="useless_beans_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
	},
	color = "#3FE43F",
	sounds = sound_mod.node_sound_water_default,
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	--drowning = -1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "useful_green_potatoes:useful_green_potato_liquid_flowing",
	liquid_alternative_source = "useful_green_potatoes:useful_green_potato_liquid_source",
	liquid_viscosity = WATER_VISC,
	liquid_range = 7,
	waving = 3,
	post_effect_color = {a=60, r=24.7, g=89.4, b=60},
	groups = {water = 1, liquid=2, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})

minetest.register_node("useful_green_potatoes:useful_green_potato_liquid_source", {
	description = "Useful Green Potato Liquid Source",
	_doc_items_entry_name = "Useful Green Potato Liquid",
	_doc_items_longdesc =
"Water is abundant in oceans and also appears in a few springs in the ground. You can swim easily in water, but you need to catch your breath from time to time.".."\n\n"..
"Water interacts with lava in various ways:".."\n"..
"• When water is directly above or horizontally next to a lava source, the lava turns into obsidian.".."\n"..
"• When flowing water touches flowing lava either from above or horizontally, the lava turns into cobblestone.".."\n"..
"• When water is directly below lava, the water turns into stone.".."\n",
	_doc_items_hidden = false,
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{name="useless_beans_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="useless_beans_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	color = "#3FE43F",
	sounds = sound_mod.node_sound_water_default,
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	--drowning = 0,
	liquidtype = "source",
	liquid_alternative_flowing = "useful_green_potatoes:useful_green_potato_liquid_flowing",
	liquid_alternative_source = "useful_green_potatoes:useful_green_potato_liquid_source",
	liquid_viscosity = WATER_VISC,
	liquid_range = 7,
	post_effect_color = {a=60, r=24.7, g=89.4, b=60},
	stack_max = 64,
	groups = {water = 1, liquid=2, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})
if why.mineclone then
    mcl_buckets.register_liquid({
        source_place = "useful_green_potatoes:useful_green_potato_liquid_source",
        source_take = {"useful_green_potatoes:useful_green_potato_liquid_source"},
        bucketname = "useful_green_potatoes:bucket_useful_green_potato_liquid",
        inventory_image = "useless_beans_bucket_useless_bean_liquid.png",
        name = "Useful Green Potato Liquid Bucket",
        longdesc = "A bucket can be used to collect and release liquids. This one is filled with useful green potato liquid.",
        usagehelp = "Place it to empty the bucket and create a useful green potato liquid source.",
        tt_help = "Places a useful green potato liquid source",
        groups = {  },
    })
else
	bucket.register_liquid("useful_green_potatoes:useful_green_potato_liquid_source", "useful_green_potatoes:useful_green_potato_liquid_flowing",
		"useful_green_potatoes:bucket_useless_bean_liquid", "useless_beans_bucket_useless_bean_liquid.png", "Useful Green Potato Liquid Bucket")
end

minetest.register_craft({
    output = "useful_green_potatoes:bucket_useful_green_potato_liquid",
    type = "shapeless",
    recipe = {"useful_green_potatoes:useful_green_potato", water_itemstring}
})

---------------------USELESS BEAN TOOLS/ARMOR------------------------
if why.mineclone or minetest.get_modpath("3d_armor") then
    if why.mineclone then
        mcl_armor.register_set({
            name = "useful_green_potato",
            description = "Useful Green Potato",
            durability = 240,
            points = {
                head = 2,
                torso = 6,
                legs = 5,
                feet = 2,
            },
            textures = {
                head = "useless_beans_helmet_useless_bean.png",
                torso = "useless_beans_chestplate_useless_bean.png",
                legs = "useless_beans_leggings_useless_bean.png",
                feet = "useless_beans_boots_useless_bean.png",
            },
            craft_material = "useful_green_potatoes:useful_green_potato_ingot",
            cook_material = "useful_green_potatoes:useful_green_potato_ingot",
            sound_equip = "mcl_armor_equip_iron",
            sound_unequip = "mcl_armor_unequip_iron",
        })
        for _, type in ipairs({"helmet","chestplate","leggings","boots"}) do
            minetest.override_item("useful_green_potatoes:"..type.."_useful_green_potato", {
                wield_image = "useless_beans_inv_"..type.."_useless_bean.png",
                inventory_image = "useless_beans_inv_"..type.."_useless_bean.png"
            })
        end
    else
        -- I'm lazy; they're identical.
        for type, name in pairs({head = "Helmet", torso = "Chestplate", legs = "Leggings", feet = "Boots"}) do
            armor:register_armor("useful_green_potatoes:"..name:lower().."_useful_green_potato", {
                description = "Useful Green Potato "..name,
                texture = "useless_beans_"..name:lower().."_useless_bean.png",
                inventory_image = "useless_beans_inv_"..name:lower().."_useless_bean.png",
                preview = "useless_beans_"..name:lower().."_useless_bean.png",
                groups = {["armor_"..type] = 1, armor_use = 800},
                armor_groups = {fleshy=12},
            })
        end
        local p = "useful_green_potatoes:useful_green_potato_ingot"
        minetest.register_craft({
            output = "useful_green_potatoes:helmet_useful_green_potato",
            recipe = {
                {p, p, p},
                {p, "",p},
            }
        })
        minetest.register_craft({
            output = "useful_green_potatoes:chestplate_useful_green_potato",
            recipe = {
                {p, "",p},
                {p, p, p},
                {p, p, p},
            }
        })
        minetest.register_craft({
            output = "useful_green_potatoes:leggings_useful_green_potato",
            recipe = {
                {p, p, p},
                {p, "",p},
                {p, "",p},
            }
        })
        minetest.register_craft({
            output = "useful_green_potatoes:boots_useful_green_potato",
            recipe = {
                {p, "",p},
                {p, "",p}
            }
        })
    end
end

for name, long_name in pairs({pick = "Pickaxe", axe = "Axe", hoe = "Hoe", sword = "Sword", shovel = "Shovel"}) do
    local def
    if why.mineclone then
        local mod = "mcl_tools"
        if name == "hoe" then mod = "mcl_farming" end
        def = table.copy(minetest.registered_items[mod..":"..name.."_iron"])
    else
        local mod = "default"
        if name == "hoe" then mod = "farming" end
        def = table.copy(minetest.registered_items[mod..":"..name.."_steel"])
    end
    def.description = "Useful Green Potato "..long_name
    def.groups.enchantability = nil
    if def._repair_material then def._repair_material = "useful_green_potatoes:useful_green_potato" end
    def.inventory_image = "useless_beans_"..name.."_useless_bean.png"
    def.wield_image = "useless_beans_"..name.."_useless_bean.png"
    minetest.register_tool("useful_green_potatoes:"..name.."_useful_green_potato", def)
end

minetest.register_craft({
    output = "useful_green_potatoes:pick_useful_green_potato",
    recipe = {
        {"useful_green_potato:useful_green_potato", "useful_green_potato:useful_green_potato", "useful_green_potato:useful_green_potato"},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useful_green_potatoes:axe_useful_green_potato",
    recipe = {
        {"useful_green_potato:useful_green_potato", "useful_green_potato:useful_green_potato", ""},
        {"useful_green_potato:useful_green_potato", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useful_green_potatoes:hoe_useful_green_potato",
    recipe = {
        {"useful_green_potato:useful_green_potato", "useful_green_potato:useful_green_potato", ""},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useful_green_potatoes:shovel_useful_green_potato",
    recipe = {
        {"", "useful_green_potato:useful_green_potato", ""},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useful_green_potatoes:sword_useful_green_potato",
    recipe = {
        {"", "useful_green_potato:useful_green_potato", ""},
        {"", "useful_green_potato:useful_green_potato", ""},
        {"", stick_itemstring, ""}
    }
})