---------------------USELESS BEANS, BEANGOTS, AND BLOCKS-----------------------------------

minetest.register_node("useless_beans:useless_bean", {
    description = "Useless Bean",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean.png"},
	sounds = mcl_sounds.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1},
	inventory_image = "useless_beans_useless_bean.png",
	wield_image = "useless_beans_useless_bean.png",
    walkable = false
})

minetest.register_decoration({
    deco_type = "simple",
    place_on = {"group:sand", "group:soil", "mcl_mud:mud"},
    sidelen = 16,
    noise_params = {
        offset = 0.0,
        scale = 0.01,
        spread = {x = 100, y = 100, z = 100},
        seed = 2020,
        octaves = 3,
        persist = 0.6
    },
    y_min = 4,
    y_max = mcl_vars.mg_overworld_max,
    biomes = {
        "Desert",
        "Mesa",
        "Mesa_sandlevel",
        "MesaBryce",
        "MesaBryce_sandlevel",
        "MesaPlateauF",
        "MesaPlateauF_sandlevel",
        "MesaPlateauFM",
        "MesaPlateauFM_sandlevel",
        "BambooJungleEdge",
        "MangroveSwamp",
        "Jungle",
        "JungleEdge",
        "BambooJungle",
        "BambooJungleM",
        "JungleEdgeM",
        "JungleM",
        "BambooJungleEdgeM"
    },
    decoration = "useless_beans:useless_bean",
    height = 1,
})

minetest.register_craft({
    output = "useless_beans:useless_bean 64",
    type = "shapeless",
    recipe = {"useless_beans:useless_bean"}
})

minetest.register_node("useless_beans:useless_bean_block", {
    description = "Useless Bean Block",
    tiles = {"useless_beans_useless_bean_block.png"},
	sounds = mcl_sounds.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, plant = 1, deco_block = 1, bouncy = 150, fall_damage_add_percent = -100},
})

minetest.register_craft({
    output = "useless_beans:useless_bean_block",
    recipe = {
        {"useless_beans:useless_bean", "useless_beans:useless_bean", "useless_beans:useless_bean"},
        {"useless_beans:useless_bean", "useless_beans:useless_bean", "useless_beans:useless_bean"},
        {"useless_beans:useless_bean", "useless_beans:useless_bean", "useless_beans:useless_bean"}
    }
})

minetest.register_craft({
    output = "useless_beans:useless_bean 10",
    type = "shapeless",
    recipe = {"useless_beans:useless_bean_block"}
})

minetest.register_craftitem("useless_beans:useless_bean_ingot", {
    description = "Beangot (Useless Bean Ingot)",
	inventory_image = "useless_beans_useless_bean_ingot.png",
	wield_image = "useless_beans_useless_bean_ingot.png",
})

minetest.register_craft({
    output = "useless_beans:useless_bean_ingot",
    type = "cooking",
    recipe = "useless_beans:useless_bean",
    time = 20
})

minetest.register_node("useless_beans:useless_bean_ingot_block", {
    description = "Beangot Block",
    tiles = {"useless_beans_useless_bean_ingot_block.png"},
	sounds = mcl_sounds.node_sound_metal_default,
    groups = {useless = 1, plant = 1, deco_block = 1, fall_damage_add_percent = 500, pickaxey=4,},
	_mcl_blast_resistance = 6,
	_mcl_hardness = 3,
})

minetest.register_craft({
    output = "useless_beans:useless_bean_ingot_block",
    recipe = {
        {"useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot"},
        {"useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot"},
        {"useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot", "useless_beans:useless_bean_ingot"}
    }
})

minetest.register_node("useless_beans:useless_bean_gold", {
    description = "Golden Useless Bean",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean_gold.png"},
	sounds = mcl_sounds.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1},
	inventory_image = "useless_beans_useless_bean_gold.png",
	wield_image = "useless_beans_useless_bean_gold.png",
    walkable = false
})

minetest.register_craft({
    output = "useless_beans:useless_bean_gold",
    recipe = {
        {"mcl_core:gold_ingot", "mcl_core:gold_ingot", "mcl_core:gold_ingot"},
        {"mcl_core:gold_ingot", "useless_beans:useless_bean", "mcl_core:gold_ingot"},
        {"mcl_core:gold_ingot", "mcl_core:gold_ingot", "mcl_core:gold_ingot"}
    }
})

minetest.register_node("useless_beans:useless_bean_gold_enchanted", {
    description = "Enchanted Golden Useless Bean",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean_gold.png" .. mcl_enchanting.overlay},
	sounds = mcl_sounds.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1},
	inventory_image = "useless_beans_useless_bean_gold.png" .. mcl_enchanting.overlay,
	wield_image = "useless_beans_useless_bean_gold.png" .. mcl_enchanting.overlay,
    walkable = false
})

minetest.register_craft({
    output = "useless_beans:useless_bean_gold_enchanted",
    recipe = {
        {"mcl_core:gold_nugget", "mcl_core:gold_nugget", "mcl_core:gold_nugget"},
        {"mcl_core:gold_nugget", "useless_beans:useless_bean", "mcl_core:gold_nugget"},
        {"mcl_core:gold_nugget", "mcl_core:gold_nugget", "mcl_core:gold_nugget"}
    }
})

---------------------USELESS BEAN LIQUID----------------------------

local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end

local WATER_VISC = 1

minetest.register_node("useless_beans:useless_bean_liquid_flowing", {
	description = "Flowing Useless Bean Liquid",
	_doc_items_create_entry = false,
	wield_image = "default_water_flowing_animated.png^[verticalframe:64:0",
	drawtype = "flowingliquid",
	tiles = {"default_water_flowing_animated.png^[verticalframe:64:0"},
	special_tiles = {
		{
			image="default_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
		{
			image="default_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
	},
	color = "#3FE43F",
	sounds = mcl_sounds.node_sound_water_default,
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 4,
	liquidtype = "flowing",
	liquid_alternative_flowing = "useless_beans:useless_bean_liquid_flowing",
	liquid_alternative_source = "useless_beans:useless_bean_liquid_source",
	liquid_viscosity = WATER_VISC,
	liquid_range = 7,
	waving = 3,
	post_effect_color = {a=60, r=24.7, g=89.4, b=60},
	groups = {water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})

minetest.register_node("useless_beans:useless_bean_liquid_source", {
	description = "Useless Bean Liquid Source",
	_doc_items_entry_name = "Useless Bean Liquid",
	_doc_items_longdesc =
"Water is abundant in oceans and also appears in a few springs in the ground. You can swim easily in water, but you need to catch your breath from time to time.".."\n\n"..
"Water interacts with lava in various ways:".."\n"..
"• When water is directly above or horizontally next to a lava source, the lava turns into obsidian.".."\n"..
"• When flowing water touches flowing lava either from above or horizontally, the lava turns into cobblestone.".."\n"..
"• When water is directly below lava, the water turns into stone.".."\n"..
"Unfortunately, this is useless bean liquid, not water, so the above information is, like the liquid, useless.",
	_doc_items_hidden = false,
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{name="default_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="default_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	color = "#3FE43F",
	sounds = mcl_sounds.node_sound_water_default,
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 4,
	liquidtype = "source",
	liquid_alternative_flowing = "useless_beans:useless_bean_liquid_flowing",
	liquid_alternative_source = "useless_beans:useless_bean_liquid_source",
	liquid_viscosity = WATER_VISC,
	liquid_range = 7,
	post_effect_color = {a=60, r=24.7, g=89.4, b=60},
	stack_max = 64,
	groups = {water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})

mcl_buckets.register_liquid({
    source_place = "useless_beans:useless_bean_liquid_source",
    source_take = {"useless_beans:useless_bean_liquid_source"},
    bucketname = "useless_beans:bucket_useless_bean_liquid",
    inventory_image = "useless_beans_bucket_useless_bean_liquid.png",
    name = "Useless Bean Bucket",
    longdesc = "A bucket can be used to collect and release liquids. This one is filled with useless bean liquid.",
    usagehelp = "Place it to empty the bucket and create a useless bean liquid source.",
    tt_help = "Places a useless bean liquid source",
    groups = { useless = 1 },
})

minetest.register_craft({
    output = "useless_beans:bucket_useless_bean_liquid",
    type = "shapeless",
    recipe = {"useless_beans:useless_bean", "mcl_buckets:bucket_water"}
})

---------------------USELESS BEAN TOOLS------------------------

for name, long_name in pairs({pick = "Pickaxe", axe = "Axe", hoe = "Hoe", sword = "Sword", shovel = "Shovel"}) do
    minetest.register_tool("useless_beans:"..name.."_useless_bean", {
        description = "Useless Bean "..long_name,
        on_use = function() end,
        on_secondary_use = function() end,
        on_place = function() end,
        inventory_image = "useless_beans_"..name.."_useless_bean.png",
        wield_image = "useless_beans_"..name.."_useless_bean.png",
    })
end

minetest.register_craft({
    output = "useless_beans:pick_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", "useless_bean:useless_bean"},
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""}
    }
})

minetest.register_craft({
    output = "useless_beans:axe_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", ""},
        {"useless_bean:useless_bean", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""}
    }
})

minetest.register_craft({
    output = "useless_beans:hoe_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", ""},
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""}
    }
})

minetest.register_craft({
    output = "useless_beans:shovel_useless_bean",
    recipe = {
        {"", "useless_bean:useless_bean", ""},
        {"", "mcl_core:stick", ""},
        {"", "mcl_core:stick", ""}
    }
})

minetest.register_craft({
    output = "useless_beans:sword_useless_bean",
    recipe = {
        {"", "useless_bean:useless_bean", ""},
        {"", "useless_bean:useless_bean", ""},
        {"", "mcl_core:stick", ""}
    }
})