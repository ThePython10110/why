local solid_liquid_damage = {}

local glass_itemstring = "default:glass"
local empty_bucket_itemstring = "bucket:bucket_empty"
local stone_itemstring = "default:stone"
local obsidian_itemstring = "default:obsidian"
local nether_check = function() end

-- Sound helper functions for placing and taking liquids
local function sound_place(itemname, pos)
	local def = minetest.registered_nodes[itemname]
	if def and def.sounds and def.sounds.place then
		minetest.sound_play(def.sounds.place, {gain=1.0, pos = pos, pitch = 1 + math.random(-10, 10)*0.005}, true)
	end
end

if why.mcl then
	glass_itemstring = "mcl_core:glass"
	empty_bucket_itemstring = "mcl_buckets:bucket_empty"
	stone_itemstring = "mcl_core:stone"
	obsidian_itemstring = "mcl_core:obsidian"
	nether_check = function(pos, player)
		local nn = minetest.get_node(pos).name
		-- Pour into cauldron
		if minetest.get_item_group(nn, "cauldron") ~= 0 then
			-- Put water into cauldron
			if nn ~= "mcl_cauldrons:cauldron_3" then
				minetest.set_node(pos, {name="mcl_cauldrons:cauldron_3"})
			end
			sound_place("mcl_core:water_source", pos)
			return false, true
		-- Put water into mangrove roots
		elseif minetest.get_node(pos).name == "mcl_mangrove:mangrove_roots" then
			local dim = mcl_worlds.pos_to_dimension(pos)
			if dim == "nether" then
				minetest.sound_play("fire_extinguish_flame", {pos = pos, gain = 0.25, max_hear_distance = 16}, true)
				return false, true
			end
			minetest.set_node(pos, {name="mcl_mangrove:water_logged_roots"})
			sound_place("mcl_core:water_source", pos)
			return false, true
		else
			-- Evaporate water if used in Nether (except on cauldron)
			local dim = mcl_worlds.pos_to_dimension(pos)
			if dim == "nether" then
				minetest.sound_play("fire_extinguish_flame", {pos = pos, gain = 0.25, max_hear_distance = 16}, true)
				return false, true
			end
		end
	end
end

if not why.mcl then
	default.cool_lava = function(pos, node) --override function to fix solid/fake liquids
		if node.name == "default:lava_source"
		or(minetest.registered_items[node.name].groups.lava and node.name:find("source")) then
			minetest.set_node(pos, {name = "default:obsidian"})
		else -- Lava flowing
			minetest.set_node(pos, {name = "default:stone"})
		end
		minetest.sound_play("default_cool_lava",
			{pos = pos, max_hear_distance = 16, gain = 0.2}, true)
	end
end

function why.register_solid_liquid(source_itemstring)
	if not minetest.registered_items[source_itemstring] then return end
	local def = table.copy(minetest.registered_items[source_itemstring])
    local _, _, item_name = string.find(source_itemstring, ".+:(.+)")
	local new_itemstring = "fake_liquids:solid_"..item_name
	def.description = "Solid "..def.description
	def.walkable = true
	def.pointable = true
	def.diggable = true
	def.buildable_to = nil
	def.drop = nil
	def.liquidtype = nil
	def.liquid_alternative_flowing = nil
	def.liquid_alternative_source = nil
	def.liquid_viscosity = nil
	def.liquid_range = nil
	def.groups.freezes = nil
	def.groups.not_in_creative_inventory = nil
	def.groups.liquid = nil
	def.groups.solid_liquid = 1
	def._mcl_hardness = 0.5
	def.groups.handy = 1
	def.groups.oddly_breakable_by_hand = 3
	def.groups.axey = 1 --multiple dig groups so Efficiency works
	def.groups.pickaxey = 1
	def.groups.shovely = 1
	def.groups.hoey = 1
	def.liquid_renewable = nil
	if def.damage_per_second then
		solid_liquid_damage[new_itemstring] = def.damage_per_second/2
		local ghost_itemstring = "ghost_blocks:solid_"..item_name
		solid_liquid_damage[new_itemstring] = def.damage_per_second/2
		solid_liquid_damage[ghost_itemstring] = def.damage_per_second/2
	end
	def.damage_per_second = nil

	minetest.register_node(new_itemstring, def)

	local bucket_itemstring
	if why.mcl then
		bucket_itemstring = mcl_buckets.liquids[source_itemstring].bucketname
	else
		bucket_itemstring = bucket.liquids[source_itemstring].itemname
	end

	minetest.register_craft({
		output = new_itemstring,
		recipe = {
			{glass_itemstring, bucket_itemstring, glass_itemstring},
			{"", glass_itemstring, ""}
		},
		replacements = {{bucket_itemstring, empty_bucket_itemstring}}
	})
end

function why.register_fake_liquid(name, look_source, act_source)
	local act_source_def = minetest.registered_items[act_source]
	local act_flowing = act_source_def.liquid_alternative_flowing
	local look_source_def = minetest.registered_items[look_source]
	local look_flowing = look_source_def.liquid_alternative_flowing
	local look_flowing_def = minetest.registered_items[look_flowing]
	local act_flowing_def = minetest.registered_items[act_flowing]
	local look_liquid_info
	local look_bucket_def
	if why.mcl then
		look_liquid_info = mcl_buckets.liquids[look_source]
		look_bucket_def = minetest.registered_items[look_liquid_info.bucketname]
	else
		look_liquid_info = bucket.liquids[look_source]
		look_bucket_def = minetest.registered_items[look_liquid_info.itemname]
	end
	if not (look_source_def and act_source_def and look_flowing_def and act_flowing_def) then return end

	local overrides = {
		"_doc_items_entry_name",
		"_doc_items_longdesc",
		"tiles",
		"special_tiles",
		"color",
		"sounds",
		"use_texture_alpha",
		"paramtype",
		"paramtype2",
		"palette",
		"post_effect_color",
		"light_source",
	}

	local new_source_def = table.copy(act_source_def)

	for _, value in ipairs(overrides) do
		new_source_def[value] = look_source_def[value]
	end

	local new_flowing_def = table.copy(act_flowing_def)

	for _, value in ipairs(overrides) do
		new_flowing_def[value] = look_flowing_def[value]
	end

	local itemstringified_name = name:lower():gsub(" ", "_"):gsub("[^%l_%d]", "")
	local new_flowing_itemstring = "fake_liquids:"..itemstringified_name.."_flowing"
	local new_source_itemstring = "fake_liquids:"..itemstringified_name.."_source"
	local new_bucket_itemstring = "fake_liquids:bucket_"..itemstringified_name
	new_source_def.description = name.." Source"
	new_flowing_def.description = "Flowing "..name
	new_source_def.groups.not_in_creative_inventory = 1
	new_flowing_def.groups.not_in_creative_inventory = 1
	new_source_def.liquid_alternative_flowing = new_flowing_itemstring
	new_source_def.liquid_alternative_source = new_source_itemstring
	new_flowing_def.liquid_alternative_flowing = new_flowing_itemstring
	new_flowing_def.liquid_alternative_source = new_source_itemstring

	minetest.register_node(new_source_itemstring, new_source_def)
	minetest.register_node(new_flowing_itemstring, new_flowing_def)

	if why.mcl then
		local extra_check
		if new_source_def.groups.water then
			extra_check = nether_check
		else
			extra_check = nil
		end

		mcl_buckets.register_liquid{
			source_place = new_source_itemstring,
			source_take = {new_source_itemstring},
			bucketname = new_bucket_itemstring,
			inventory_image = look_bucket_def.inventory_image,
			name = name,
			longdesc = "A bucket can be used to collect and release liquids. This one is filled with "..name:lower()..".",
			usagehelp = "Place it to empty the bucket and create a "..name:lower().." source.",
			tt_help = "Places a "..name:lower().." source.",
			groups = { fake_liquid = 1 },
			extra_check = extra_check
		}
	else
		bucket.register_liquid(new_source_itemstring, new_flowing_itemstring,
			new_bucket_itemstring, look_bucket_def.inventory_image, name, {fake_liquid = 1})
	end
end

if why.mcl then
	minetest.register_node("fake_liquids:milk_source", {
		description = "Milk Source",
		_doc_items_create_entry = false,
		drawtype = "liquid",
		waving = 3,
		tiles = {"mcl_colorblocks_concrete_white.png^[opacity:220"},
		special_tiles = {
			-- New-style water source material (mostly unused)
			{
				name="mcl_colorblocks_concrete_white.png^[opacity:220",
				--animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
				backface_culling = true,
			}
		},
		sounds = mcl_sounds.node_sound_water_default,
		use_texture_alpha = "blend",
		is_ground_content = false,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		drop = "",
		drowning = 4,
		post_effect_color = {a=200, r=255, g=255, b=255},
		liquidtype = "source",
		liquid_alternative_flowing = "fake_liquids:milk_flowing",
		liquid_alternative_source = "fake_liquids:milk_source",
		liquid_renewable = false,
		liquid_viscosity = 1,
		liquid_range = 7,
		stack_max = 64,
		groups = { liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
		_mcl_blast_resistance = 100,
		-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
		_mcl_hardness = -1,

	})
	minetest.register_node("fake_liquids:milk_flowing", {
		description = "Flowing Milk",
		_doc_items_create_entry = false,
		waving = 3,
		tiles = {"mcl_colorblocks_concrete_white.png^[opacity:220", "mcl_colorblocks_concrete_white.png^[opacity:220"},
		drawtype = "flowingliquid",
		special_tiles = {
			-- New-style water source material (mostly unused)
			{
				name="mcl_colorblocks_concrete_white.png^[opacity:220",
				--animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
				backface_culling = false,
			},
			{
				name="mcl_colorblocks_concrete_white.png^[opacity:220",
				--animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
				backface_culling = false,
			},
		},
		sounds = mcl_sounds.node_sound_water_default,
		use_texture_alpha = "blend",
		is_ground_content = false,
		paramtype = "light",
		paramtype2 = "flowingliquid",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		drop = "",
		drowning = 4,
		post_effect_color = {a=200, r=255, g=255, b=255},
		liquidtype = "flowing",
		liquid_alternative_flowing = "fake_liquids:milk_flowing",
		liquid_alternative_source = "fake_liquids:milk_source",
		liquid_renewable = false,
		liquid_viscosity = 1,
		liquid_range = 7,
		stack_max = 64,
		groups = { water=3, liquid=3, puts_out_fire=1, not_in_creative_inventory=1, melt_around=1, dig_by_piston=1},
		_mcl_blast_resistance = 100,
		-- Hardness intentionally set to infinite instead of 100 (Minecraft value) to avoid problems in creative mode
		_mcl_hardness = -1,
	})

	local milk_def = minetest.registered_items["mcl_mobitems:milk_bucket"]
	local drink_milk = milk_def.on_secondary_use
	mcl_buckets.register_liquid{
		source_place = "fake_liquids:milk_source",
		source_take = {"fake_liquids:milk_source"},
		bucketname = ":mcl_mobitems:milk_bucket", -- originally :mcl_mobitems:milk_bucket, but it didn't like the colon
		inventory_image = milk_def.inventory_image, -- so I used an alias instead
		name = milk_def.description,
		longdesc = milk_def._doc_items_longdesc,
		usagehelp = milk_def._doc_items_usagehelp,
		tt_help = milk_def._tt_help,
		groups = milk_def.groups,
		extra_check = nether_check
	}

	minetest.override_item("mcl_mobitems:milk_bucket", {on_secondary_use = drink_milk})
	-- remove the colon
	mcl_buckets.liquids["fake_liquids:milk_source"].bucketname = "mcl_mobitems:milk_bucket"
	mcl_buckets.buckets["mcl_mobitems:milk_bucket"] = table.copy(mcl_buckets.buckets[":mcl_mobitems:milk_bucket"])
	mcl_buckets.buckets[":mcl_mobitems:milk_bucket"] = nil

	why.register_fake_liquid("Fake Water", "mcl_core:water_source", "mcl_core:lava_source")
	why.register_fake_liquid("Fake Lava", "mcl_core:lava_source", "mcl_core:water_source")
else
	why.register_fake_liquid("Fake Water", "default:water_source", "default:lava_source")
	why.register_fake_liquid("Fake Lava", "default:lava_source", "default:water_source")
end

if why.mcl then
	for itemstring, info in pairs(mcl_buckets.liquids) do
		if itemstring ~= "mcl_nether:nether_lava_source" then
			why.register_solid_liquid(itemstring)
		end
	end
else
	for itemstring, info in pairs(bucket.liquids) do
		if info.source == itemstring then
			why.register_solid_liquid(itemstring)
		end
	end
end

if why.mcl then
	minetest.register_abm({
		label = "Lava cooling (solid liquids)",
		nodenames = {"group:lava"},
		neighbors = {"group:water"},
		interval = 1,
		chance = 1,
		min_y = mcl_vars.mg_end_min,
		action = function(pos, node, active_object_count, active_object_count_wider)
			if not minetest.registered_nodes[node.name].groups.solid_liquid then return end --make sure it's a solid liquid first
			local water = minetest.find_nodes_in_area(
				{x=pos.x-1, y=pos.y-1, z=pos.z-1},
				{x=pos.x+1, y=pos.y+1, z=pos.z+1},
				"group:water"
			)

			for w=1, #water do
				--local waternode = minetest.get_node(water[w])
				--local watertype = minetest.registered_nodes[waternode.name].liquidtype
				-- Lava on top of water: Water turns into stone
				if water[w].y < pos.y and water[w].x == pos.x and water[w].z == pos.z then
					minetest.set_node(water[w], {name=stone_itemstring})
					minetest.sound_play("fire_extinguish_flame", {pos = water[w], gain = 0.25, max_hear_distance = 16}, true)
				elseif  ((water[w].y > pos.y and water[w].x == pos.x and water[w].z == pos.z) or
						(water[w].y == pos.y and (water[w].x == pos.x or water[w].z == pos.z))) then
					minetest.set_node(pos, {name=obsidian_itemstring})
					minetest.sound_play("fire_extinguish_flame", {pos = pos, gain = 0.25, max_hear_distance = 16}, true)
				end
			end
		end,
	})
else
	if minetest.settings:get_bool("enable_lavacooling") ~= false then
		minetest.register_abm({
			label = "Lava cooling (fake/solid liquids)",
			nodenames = {"group:lava"},
			neighbors = {"group:cools_lava", "group:water"},
			interval = 2,
			chance = 2,
			catch_up = false,
			action = function(...)
				default.cool_lava(...)
			end,
		})
	end
end

local time = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time < 0.5 then return end
	time = 0
	for _,player in pairs(minetest.get_connected_players()) do
		-- who am I?

		-- where am I?
		local pos = player:get_pos()

		-- Am I near a solid liquid source that does damage?
		for itemstring, damage in pairs(solid_liquid_damage) do
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
						local def = minetest.registered_items[itemstring]
						if why.mcl then
							local damage_type
							if def.groups.lava then
								damage_type = "lava"
							else
								damage_type = "generic"
							end
							if damage_type == "lava" then
								mcl_burning.set_on_fire(player, 10)
							end
							mcl_util.deal_damage(player, damage, {type = damage_type})
						else
							player:set_hp(player:get_hp() - damage)
						end
					end
				end
			end
		end
	end
end)

local fake_liquid_recipes
if why.mcl then
	fake_liquid_recipes = {
		["mcl_buckets:bucket_water"] = "fake_liquids:bucket_fake_lava",
		["mcl_buckets:bucket_river_water"] = "fake_liquids:bucket_fake_lava",
		["mcl_buckets:bucket_lava"] = "fake_liquids:bucket_fake_water",
	}
else
	fake_liquid_recipes = {
		["bucket:bucket_water"] = "fake_liquids:bucket_fake_lava",
		["bucket:bucket_river_water"] = "fake_liquids:bucket_fake_lava",
		["bucket:bucket_lava"] = "fake_liquids:bucket_fake_water",
	}
end

if why.mcl then
	--override brewing for fake liquids
	local old_alchemy = mcl_potions.get_alchemy
	mcl_potions.get_alchemy = function(ingr, pot)
		if ingr == "mcl_potions:fermented_spider_eye" then
			if fake_liquid_recipes[pot] then
				return fake_liquid_recipes[pot]
			end
		end
		return old_alchemy(ingr, pot)
	end
else
	for liquid, fake_liquid in pairs(fake_liquid_recipes) do
		minetest.register_craft{
			output = fake_liquid,
			type = "shapeless",
			recipe = {liquid, "default:mese_crystal"}
		}
	end
end