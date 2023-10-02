local sound_mod = default
local water_itemstring = "bucket:bucket_water"
local sticky_block_sounds
if why.mcl then
    sound_mod = mcl_sounds
	water_itemstring = "mcl_buckets:bucket_water"
	sticky_block_sounds = {
		dug = {name = "slimenodes_dug", gain = 0.6},
		place = {name = "slimenodes_place", gain = 0.6},
		footstep = {name = "slimenodes_step", gain = 0.3},
	}
else
	sticky_block_sounds = default.node_sound_defaults()
end

local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end

local GLUE_VISC = 15

minetest.register_node("sticky_things:glue_flowing", {
	description = "Flowing Glue",
	_doc_items_create_entry = false,
	wield_image = "sticky_things_water_flowing_animated.png^[verticalframe:64:0",
	drawtype = "flowingliquid",
	tiles = {"sticky_things_water_flowing_animated.png^[verticalframe:64:0"},
	special_tiles = {
		{
			image="sticky_things_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
		{
			image="sticky_things_water_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.5}
		},
	},
	color = "#EEEEEE",
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
	drowning = 4,
	liquidtype = "flowing",
	liquid_alternative_flowing = "sticky_things:glue_flowing",
	liquid_alternative_source = "sticky_things:glue_source",
	liquid_viscosity = GLUE_VISC,
	liquid_range = 7,
	waving = 3,
	post_effect_color = {a=90, r=90, g=90, b=90},
	groups = {water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})

minetest.register_node("sticky_things:glue_source", {
	description = "Glue Source",
	drawtype = "liquid",
	waving = 3,
	tiles = {
		{name="sticky_things_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name="sticky_things_water_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	color = "#EEEEEE",
	sounds = sound_mod.node_sound_water_default,
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
	liquid_alternative_flowing = "sticky_things:glue_flowing",
	liquid_alternative_source = "sticky_things:glue_source",
	liquid_viscosity = GLUE_VISC,
	liquid_range = 7,
	post_effect_color = {a=90, r=90, g=90, b=90},
	stack_max = 64,
	groups = {water = 3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
	_mcl_blast_resistance = 100,
	-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
	_mcl_hardness = -1,
})

if why.mcl then
	mcl_buckets.register_liquid({
		source_place = "sticky_things:glue_source",
		source_take = {"sticky_things:glue_source"},
		bucketname = "sticky_things:bucket_glue",
		inventory_image = "sticky_things_bucket_glue.png",
		name = "Glue Bucket",
		longdesc = "A bucket can be used to collect and release liquids. This one is filled with glue.",
		usagehelp = "Place it to empty the bucket and create a glue source.",
		tt_help = "Places a glue source",
	})
else
	bucket.register_liquid("sticky_things:glue_source", "sticky_things:glue_flowing",
		"sticky_things:bucket_glue", "sticky_things_bucket_glue.png", "Glue Bucket")
end

minetest.register_craft({
    output = "sticky_things:bucket_glue",
    type = "shapeless",
    recipe = {"group:flower", water_itemstring},
})

if why.mcl then
	minetest.register_node("sticky_things:sticky_block", {
		description = "Sticky Block",
		_mcl_hardness = 3,
		groups = {cracky = 3, pickaxey = 1, disable_jump = 1},
		tiles = {"sticky_things_sticky_block.png"},
		sounds = sticky_block_sounds
	})
	minetest.register_globalstep(function()
		for _,player in pairs(minetest.get_connected_players()) do
			-- who am I?
			local name = player:get_player_name()

			-- what is around me?
			local node_stand = mcl_playerinfo[name].node_stand
			local node_stand_below = mcl_playerinfo[name].node_stand_below

			-- Standing on sticky block? If so, walk slower
			if node_stand == "sticky_things:sticky_block"
			or (node_stand == "air" and node_stand_below == "sticky_things:sticky_block") then
				playerphysics.add_physics_factor(player, "speed", "mcl_playerplus:surface", 0.05)
			end
		end
	end)

 -- if why.mcl then
		minetest.register_craft({
			output = "sticky_things:sticky_block",
			type = "shapeless",
			recipe = {"mcl_core:ice", "mcl_nether:soul_sand", "mcl_nether:soul_sand", "mcl_core:ice"}
		})

		minetest.register_craft({
			output = "sticky_things:sticky_block",
			type = "shapeless",
			recipe = {"mcl_core:packed_ice", "mcl_nether:soul_sand", "mcl_nether:soul_sand", "mcl_core:packed_ice"}
		})

		minetest.register_craft({
			output = "sticky_things:sticky_block",
			type = "shapeless",
			recipe = {"mcl_core:ice", "mcl_nether:soul_sand", "mcl_nether:soul_sand", "mcl_core:packed_ice"}
		})
--[[else
		minetest.register_craft({
			output = "sticky_things:sticky_block",
			type = "shapeless",
			recipe = {"default:ice", "default:sand", "default:sand", "default:ice"}
		})
	end]]
end