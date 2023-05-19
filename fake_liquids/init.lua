local solid_liquid_damage = {}

fake_liquids = {}

function fake_liquids.register_solid_liquid(source_itemstring)
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

	local bucket_itemstring = mcl_buckets.liquids[source_itemstring].bucketname

	minetest.register_craft({
		output = new_itemstring,
		recipe = {
			{"mcl_core:glass", bucket_itemstring, "mcl_core:glass"},
			{"", "mcl_core:glass", ""}
		},
		replacements = {{bucket_itemstring, "mcl_buckets:bucket_empty"}}
	})
end

function fake_liquids.register_fake_liquid(name, look_source, act_source)
	local look_source_def = minetest.registered_items[look_source]
	local look_flowing = look_source_def.liquid_alternative_flowing
	local act_source_def = minetest.registered_items[act_source]
	local act_flowing = act_source_def.liquid_alternative_flowing
	local look_flowing_def = minetest.registered_items[look_flowing]
	local act_flowing_def = minetest.registered_items[act_flowing]
	local act_liquid_info = mcl_buckets.liquids[act_source]
	local look_liquid_info = mcl_buckets.liquids[look_source]
	local look_bucket_def = minetest.registered_items[mcl_buckets.liquids[look_source].bucketname]
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
	new_source_def.liquid_alternative_flowing = new_flowing_itemstring
	new_source_def.liquid_alternative_source = new_source_itemstring
	new_flowing_def.liquid_alternative_flowing = new_flowing_itemstring
	new_flowing_def.liquid_alternative_source = new_source_itemstring

	minetest.register_node(new_source_itemstring, new_source_def)
	minetest.register_node(new_flowing_itemstring, new_flowing_def)

	local extra_check
	if new_source_def.groups.water then
		extra_check = function(pos, placer)
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
	else
		extra_check = nil
	end

	mcl_buckets.register_liquid({
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
	})
end

fake_liquids.register_fake_liquid("Fake Water", "mcl_core:water_source", "mcl_core:lava_source")
fake_liquids.register_fake_liquid("Fake Lava", "mcl_core:lava_source", "mcl_core:water_source")

for itemstring, info in pairs(mcl_buckets.liquids) do
	if itemstring ~= "mcl_nether:nether_lava_source" then
		fake_liquids.register_solid_liquid(itemstring)
	end
end

minetest.register_abm({
	label = "Lava cooling (solid liquids)",
	nodenames = {"group:lava"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 1,
	min_y = mcl_vars.mg_end_min,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not minetest.registered_nodes[node.name].groups.solid_liquid then return end --make sure it's a solid liquid first
		local water = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, "group:water")

		for w=1, #water do
			--local waternode = minetest.get_node(water[w])
			--local watertype = minetest.registered_nodes[waternode.name].liquidtype
			-- Lava on top of water: Water turns into stone
			if water[w].y < pos.y and water[w].x == pos.x and water[w].z == pos.z then
				minetest.set_node(water[w], {name="mcl_core:stone"})
				minetest.sound_play("fire_extinguish_flame", {pos = water[w], gain = 0.25, max_hear_distance = 16}, true)
			elseif  ((water[w].y > pos.y and water[w].x == pos.x and water[w].z == pos.z) or
					(water[w].y == pos.y and (water[w].x == pos.x or water[w].z == pos.z))) then
				minetest.set_node(pos, {name="mcl_core:obsidian"})
				minetest.sound_play("fire_extinguish_flame", {pos = pos, gain = 0.25, max_hear_distance = 16}, true)
			end
		end
	end,
})

local time = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time < 0.5 then return end
	time = 0
	for _,player in pairs(minetest.get_connected_players()) do
		-- who am I?
		local name = player:get_player_name()

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
						local damage_type
						local def = minetest.registered_items[itemstring]
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
					end
				end
			end
		end
	end


end)

local fake_liquid_recipes = {
	["mcl_buckets:bucket_water"] = "fake_liquids:bucket_fake_lava",
	["mcl_buckets:bucket_river_water"] = "fake_liquids:bucket_fake_lava",
	["mcl_buckets:bucket_lava"] = "fake_liquids:bucket_fake_water",
}

--override brewing for fake lava/water
local old_alchemy = mcl_potions.get_alchemy
mcl_potions.get_alchemy = function(ingr, pot)
	if ingr == "mcl_potions:fermented_spider_eye" then
		if fake_liquid_recipes[pot] then
			return fake_liquid_recipes[pot]
		end
	end
	old_alchemy(ingr, pot)
end