local USE_TEXTURE_ALPHA = true

if minetest.features.use_texture_alpha_string_modes then
	USE_TEXTURE_ALPHA = "blend"
end


minetest.register_node("fake_liquids:solid_water_source", {
	description = "Solid Water Source",
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
	color = "#3F76E4",
	sounds = mcl_sounds.node_sound_water_defaults(),
	is_ground_content = false,
	use_texture_alpha = USE_TEXTURE_ALPHA,
	paramtype = "light",
	paramtype2 = "color",
	palette = "mcl_core_palette_water.png",
	post_effect_color = {a=60, r=24.7, g=46.3, b=89.4},
	stack_max = 64,
	groups = {puts_out_fire=1,  dig_by_piston=1, water_palette=1, solid = 1},
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50
})

minetest.register_craft({
	output = "fake_liquids:solid_water_source",
	recipe = {
		{"mcl_core:glass", "mcl_buckets:bucket_water", "mcl_core:glass"},
		{"", "mcl_core:glass", ""}
	}
})

local river = table.copy(minetest.registered_nodes["fake_liquids:solid_water_source"])
river.description = "Solid River Water Source"
river.color = "#0084FF"
river.paramtype2 = nil
river.palette = nil
river.post_effect_color = {a=60, r=0, g=132, b=255}

minetest.register_node("fake_liquids:solid_river_water_source", river)

minetest.register_craft({
	output = "fake_liquids:solid_river_water_source",
	recipe = {
		{"mcl_core:glass", "mcl_buckets:bucket_river_water", "mcl_core:glass"},
		{"", "mcl_core:glass", ""}
	}
})

minetest.register_node("fake_liquids:solid_lava_source", {
	description = "Solid Lava Source",
	drawtype = "liquid",
	tiles = {
		{name="default_lava_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name="default_lava_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	paramtype = "light",
	light_source = minetest.LIGHT_MAX,
	is_ground_content = false,
	sounds = mcl_sounds.node_sound_lava_defaults(),
	post_effect_color = {a=245, r=208, g=73, b=10},
	stack_max = 64,
	groups = {dig_by_piston=1, solid = 1},
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
})

minetest.register_craft({
	output = "fake_liquids:solid_lava_source",
	recipe = {
		{"mcl_core:glass", "mcl_buckets:bucket_lava", "mcl_core:glass"},
		{"", "mcl_core:glass", ""}
	}
})

if minetest.get_modpath("useless_beans") then
	minetest.register_node("fake_liquids:solid_useless_bean_liquid_source", {
		description = "Solid Useless Bean Liquid Source",
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
		sounds = mcl_sounds.node_sound_water_defaults(),
		is_ground_content = false,
		use_texture_alpha = USE_TEXTURE_ALPHA,
		paramtype = "light",
		paramtype2 = "color",
		post_effect_color = {a=60, r=24.7, g=89.4, b=60},
		stack_max = 64,
		groups = {puts_out_fire=1,  dig_by_piston=1, solid = 1},
		_mcl_blast_resistance = 1200,
		_mcl_hardness = 50
	})

	minetest.register_craft({
		output = "fake_liquids:solid_useless_bean_liquid_source",
		recipe = {
			{"mcl_core:glass", "useless_beans:bucket_useless_bean_liquid", "mcl_core:glass"},
			{"", "mcl_core:glass", ""}
		}
	})
end