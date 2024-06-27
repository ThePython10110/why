local gold_itemstring = "default:gold_ingot"
local water_itemstring = "bucket:bucket_water"
local stick_itemstring = "default:stick"
if why.mcl then
    gold_itemstring = "mcl_core:gold_ingot"
    water_itemstring = "mcl_buckets:bucket_water"
    stick_itemstring = "mcl_core:stick"
end

---------------------USELESS BEANS, BEANGOTS, AND BLOCKS-----------------------------------

minetest.register_node("useless_beans:useless_bean", {
    description = "Useless Bean",
    drawtype = "plantlike",
    tiles = {"useless_beans_useless_bean.png"},
	sounds = why.sound_mod.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1,
	blast_furnace_smeltable = 1},
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
    y_max = 30000,
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
	sounds = why.sound_mod.node_sound_leaves_default,
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
    groups = {useless = 1,}
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
	sounds = why.sound_mod.node_sound_metal_default,
    groups = {useless = 1, plant = 1, deco_block = 1, fall_damage_add_percent = 500, pickaxey=4, cracky=3},
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
	sounds = why.sound_mod.node_sound_leaves_default,
    groups = {useless = 1, dig_immediate = 3, dig_by_piston = 1, plant = 1, craftitem = 1, deco_block = 1, dig_by_water = 1},
	inventory_image = "useless_beans_useless_bean_gold.png",
	wield_image = "useless_beans_useless_bean_gold.png",
    walkable = false
})

minetest.register_craft({
    output = "useless_beans:useless_bean_gold",
    recipe = {
        {gold_itemstring, gold_itemstring, gold_itemstring},
        {gold_itemstring, "useless_beans:useless_bean", gold_itemstring},
        {gold_itemstring, gold_itemstring, gold_itemstring}
    }
})

if why.mcl then
    minetest.register_node("useless_beans:useless_bean_gold_enchanted", {
        description = "Enchanted Golden Useless Bean",
        drawtype = "plantlike",
        tiles = {"useless_beans_useless_bean_gold.png" .. mcl_enchanting.overlay},
        sounds = why.sound_mod.node_sound_leaves_default,
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

    if awards then
        awards.register_achievement("why:cheaper", {
            title = "Why is it cheaper?",
            description = "Craft an enchanted golden useless bean",
            icon = "useless_beans_useless_bean_gold.png" .. mcl_enchanting.overlay,
            trigger = {
                type = why.mcla and "craft" or "crafting",
                item = "useless_beans:useless_bean_gold_enchanted",
                target = 1
            },
            type = "Advancement",
            group = "Why"
        })
    end
end

---------------------USELESS BEAN LIQUID----------------------------

local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end

local WATER_VISC = 1

minetest.register_node("useless_beans:useless_bean_liquid_flowing", {
	description = "Flowing Useless Bean Liquid",
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
	sounds = why.sound_mod.node_sound_water_default,
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
	groups = {useless = 1, water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
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
	sounds = why.sound_mod.node_sound_water_default,
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
	groups = {useless = 1, water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})
if why.mcl then
    mcl_buckets.register_liquid({
        source_place = "useless_beans:useless_bean_liquid_source",
        source_take = {"useless_beans:useless_bean_liquid_source"},
        bucketname = "useless_beans:bucket_useless_bean_liquid",
        inventory_image = "useless_beans_bucket_useless_bean_liquid.png",
        name = "Useless Bean Liquid Bucket",
        longdesc = "A bucket can be used to collect and release liquids. This one is filled with useless bean liquid.",
        usagehelp = "Place it to empty the bucket and create a useless bean liquid source.",
        tt_help = "Places a useless bean liquid source",
        groups = { useless = 1 },
    })
else
	bucket.register_liquid("useless_beans:useless_bean_liquid_source", "useless_beans:useless_bean_liquid_flowing",
		"useless_beans:bucket_useless_bean_liquid", "useless_beans_bucket_useless_bean_liquid.png", "Useless Bean Liquid Bucket")
end

minetest.register_craft({
    output = "useless_beans:bucket_useless_bean_liquid",
    type = "shapeless",
    recipe = {"useless_beans:useless_bean", water_itemstring}
})

---------------------USELESS BEAN TOOLS/ARMOR------------------------
if why.mcl or minetest.get_modpath("3d_armor") then
    if why.mcl then
        mcl_armor.register_set({
            name = "useless_bean",
            description = "Useless Bean",
            descriptions = why.mcla and {
                head = "Useless Bean Helmet",
                torso = "Useless Bean Chestplate",
                legs = "Useless Bean Leggings",
                feet = "Useless Bean Boots",
            },
            durability = 0,
            points = {
                head = 0,
                torso = 0,
                legs = 0,
                feet = 0,
            },
            toughness = 0,
            groups = {useless = 1},
            craft_material = "useless_beans:useless_bean_ingot",
            cook_material = "useless_beans:useless_bean_ingot_block",
            repair_material = "useless_beans:useless_bean_ingot"
        })
    else
        for name, type in pairs({Helmet = "head", Chestplate = "torso", Leggings = "legs", Boots = "feet"}) do
            armor:register_armor("useless_beans:"..name:lower().."_useless_bean", {
                description = "Useless Bean "..name,
                texture = "useless_beans_"..name:lower().."_useless_bean.png",
                inventory_image = "useless_beans_inv_"..name:lower().."_useless_bean.png",
                preview = "useless_beans_"..name:lower().."_useless_bean.png",
                groups = {["armor_"..type] = 1, useless = 1}
            })
        end
        local b = "useless_beans:useless_bean"
        minetest.register_craft({
            output = "useless_beans:helmet_useless_bean",
            recipe = {
                {b, b, b},
                {b, "",b},
            }
        })
        minetest.register_craft({
            output = "useless_beans:chestplate_useless_bean",
            recipe = {
                {b, "",b},
                {b, b, b},
                {b, b, b},
            }
        })
        minetest.register_craft({
            output = "useless_beans:leggings_useless_bean",
            recipe = {
                {b, b, b},
                {b, "",b},
                {b, "",b},
            }
        })
        minetest.register_craft({
            output = "useless_beans:boots_useless_bean",
            recipe = {
                {b, "",b},
                {b, "",b}
            }
        })
    end

    local bean_hud = {}
    local function add_bean_hud(player)
        bean_hud[player] = {
            bean_blur = player:hud_add({
                hud_elem_type = "image",
                position = {x = 0.5, y = 0.5},
                scale = {x = -101, y = -101},
                text = "useless_beans_useless_bean_helmet_vision.png",
                z_index = -200
            }),
        }
    end
    local function remove_bean_hud(player)
        if bean_hud[player] then
            player:hud_remove(bean_hud[player].bean_blur)
            bean_hud[player] = nil
        end
    end

    local bean_helmet_base_def = {}
    if why.mcl then
        --bean_helmet_base_def.on_secondary_use = mcl_armor.equip_on_use
        bean_helmet_base_def._on_equip = add_bean_hud
        bean_helmet_base_def._on_unequip = remove_bean_hud
    else
        bean_helmet_base_def.on_equip = add_bean_hud
        bean_helmet_base_def.on_unequip = remove_bean_hud
    end

    minetest.override_item("useless_beans:helmet_useless_bean", bean_helmet_base_def)

    minetest.register_on_joinplayer(function(player)
        if why.mcl then
            if player:get_inventory():get_stack("armor", 2):get_name() == "useless_beans:helmet_useless_bean" then
                add_bean_hud(player)
            end
        else
            local _, armor_inv = armor:get_valid_player(player, "3d_armor")
            if not armor_inv then return end
            for i = 1, 6 do
                local stack = armor_inv:get_stack("armor", i)
                if stack:get_name() == "useless_beans:helmet_useless_bean" then
                    add_bean_hud(player)
                    break
                end
            end
        end
    end)
    minetest.register_on_dieplayer(function(player)
        if why.mcl then
            if not minetest.settings:get_bool("mcl_keepInventory") then
                remove_bean_hud(player)
            end
        else
            if minetest.settings:get("bones_mode") ~= "keep" then
                remove_bean_hud(player)
            end
        end
    end)
    minetest.register_on_leaveplayer(function(player)
        bean_hud[player] = nil
    end)
end

for name, long_name in pairs({pick = "Pickaxe", axe = "Axe", hoe = "Hoe", sword = "Sword", shovel = "Shovel"}) do
    minetest.register_tool("useless_beans:"..name.."_useless_bean", {
        description = "Useless Bean "..long_name,
        on_use = function() end,
        on_secondary_use = function() end,
        on_place = function() end,
        inventory_image = "useless_beans_"..name.."_useless_bean.png",
        wield_image = "useless_beans_"..name.."_useless_bean.png",
        groups = {useless = 1}
    })
end

minetest.register_craft({
    output = "useless_beans:pick_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", "useless_bean:useless_bean"},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useless_beans:axe_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", ""},
        {"useless_bean:useless_bean", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useless_beans:hoe_useless_bean",
    recipe = {
        {"useless_bean:useless_bean", "useless_bean:useless_bean", ""},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useless_beans:shovel_useless_bean",
    recipe = {
        {"", "useless_bean:useless_bean", ""},
        {"", stick_itemstring, ""},
        {"", stick_itemstring, ""}
    }
})

minetest.register_craft({
    output = "useless_beans:sword_useless_bean",
    recipe = {
        {"", "useless_bean:useless_bean", ""},
        {"", "useless_bean:useless_bean", ""},
        {"", stick_itemstring, ""}
    }
})