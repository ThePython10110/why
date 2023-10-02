-------Bouncy wool---------

local glass_itemstring = "default:glass"
local obsidian_itemstring = "default:obsidian"
if why.mcl then
	glass_itemstring = "mcl_core:glass"
	obsidian_itemstring = "mcl_core:obsidian"
end

local wool_list = why.get_group_items({"wool"})

for i, itemstring in ipairs(wool_list.wool) do
    local groups = minetest.registered_nodes[itemstring].groups
    groups.bouncy = 95
    minetest.override_item(itemstring, {groups = groups})
end -- Intentionally not making it prevent fall damage :D

if why.mcl then
	-------Sunnier sunflowers-------
	minetest.override_item("mcl_flowers:sunflower_top", {
		light_source = 14
	})
	-------Blue Feathers--------
	minetest.register_craftitem("small_why_things:blue_feather", {
		description = "Blue Feather",
		wield_image = "mcl_mobitems_feather.png^[multiply:#0044ff",
		inventory_image = "mcl_mobitems_feather.png^[multiply:#0044ff",
	})
	minetest.register_craft({
		output = "small_why_things:blue_feather",
		type = "shapeless",
		recipe = {"mcl_mobitems:feather", "mcl_dye:blue"}
	})
	minetest.register_craft({
		output = "small_why_things:blue_feather",
		type = "shapeless",
		recipe = {"mcl_mobitems:feather", "mcl_dye:lightblue"}
	})
end

-------Craftable barriers-------
minetest.register_node("small_why_things:craftable_barrier", {
	description = "Craftable Barrier",
	drawtype = "airlike",
	paramtype = "light",
	inventory_image = "small_why_things_craftable_barrier.png^[colorize:#FFFF00:127",
	wield_image = "small_why_things_craftable_barrier.png^[colorize:#FFFF00:127",
	tiles = {"blank.png"},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {not_solid = 1, cracky = 1, pickaxey = 1},
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
	after_place_node = function(pos, player, itemstack, pointed_thing)
		if player == nil then
			return
		end
		minetest.add_particle({
			pos = pos,
			expirationtime = 1,
			size = 8,
			texture = "small_why_things_craftable_barrier.png^[colorize:#FFFF00:127",
			glow = 14,
			playername = player:get_player_name()
		})
	end,
})

minetest.register_craft({
	output = "small_why_things:craftable_barrier 17",
	recipe = {
		{glass_itemstring, glass_itemstring, glass_itemstring},
		{glass_itemstring, obsidian_itemstring, glass_itemstring},
		{glass_itemstring, glass_itemstring, glass_itemstring}
	}
})

minetest.register_globalstep(function() --I wish there was a way to unregister the MineClone function.
	for _,player in pairs(minetest.get_connected_players()) do
		local wi = player:get_wielded_item():get_name()
		if wi == "mcl_core:barrier" or wi == "mcl_core:realm_barrier"
		or wi == "small_why_things:craftable_barrier"
		or minetest.get_item_group(wi, "light_block") ~= 0 then
			local pos = vector.round(player:get_pos())
			local r = 8
			local vm = minetest.get_voxel_manip()
			local emin, emax = vm:read_from_map({x=pos.x-r, y=pos.y-r, z=pos.z-r}, {x=pos.x+r, y=pos.y+r, z=pos.z+r})
			local area = VoxelArea:new{
				MinEdge = emin,
				MaxEdge = emax,
			}
			local data = vm:get_data()
			for x=pos.x-r, pos.x+r do
			for y=pos.y-r, pos.y+r do
			for z=pos.z-r, pos.z+r do
				local vi = area:indexp({x=x, y=y, z=z})
				local nodename = minetest.get_name_from_content_id(data[vi])
				local light_block_group = minetest.get_item_group(nodename, "light_block")

				local tex
				if nodename == "mcl_core:barrier" then
					tex = "small_why_things_craftable_barrier.png"
				elseif nodename == "small_why_things:craftable_barrier" then
					tex = "small_why_things_craftable_barrier.png^[colorize:#FFFF00:127"
				elseif nodename == "mcl_core:realm_barrier" then
					tex = "small_why_things_craftable_barrier.png^[colorize:#FF00FF:127"
				elseif light_block_group ~= 0 then
					tex = "mcl_core_light_" .. (light_block_group - 1) .. ".png"
				end
				if tex then
					minetest.add_particle({
						pos = {x=x, y=y, z=z},
						expirationtime = 1,
						size = 8,
						texture = tex,
						glow = 14,
						playername = player:get_player_name()
					})
				end
			end
			end
			end
		end
	end
end)
if why.mcl and mcl_core then
	function mcl_core.grow_cactus(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if minetest.get_item_group(name, "sand") ~= 0 then
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "mcl_core:cactus" --[[and height < 4]] do
				height = height+1
				pos.y = pos.y+1
			end
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name="mcl_core:cactus"})
			end
		end
	end
	function mcl_core.grow_reeds(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if minetest.get_item_group(name, "soil_sugarcane") ~= 0 then
			if minetest.find_node_near(pos, 1, {"group:water"}) == nil
			and minetest.find_node_near(pos, 1, {"group:frosted_ice"}) == nil then
				return
			end
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "mcl_core:reeds" --[[and height < 3]] do
				height = height+1
				pos.y = pos.y+1
			end
			if minetest.get_node(pos).name == "air" then
				minetest.set_node(pos, {name="mcl_core:reeds"})
			end
		end
	end
	if mcl_bamboo then
		function mcl_bamboo.grow(pos)
			local bottom = mcl_util.traverse_tower(pos,-1)
			local top, _ = mcl_util.traverse_tower(bottom,1)
			local node = minetest.get_node(pos)
			if minetest.get_node(vector.offset(top,0,1,0)).name ~= "air" then return end
			minetest.set_node(vector.offset(top,0,1,0),node)
		end
	end
else
	function default.grow_cactus(pos, node)
		if node.param2 >= 4 then
			return
		end
		pos.y = pos.y - 1
		if minetest.get_item_group(minetest.get_node(pos).name, "sand") == 0 then
			return
		end
		pos.y = pos.y + 1
		local height = 0
		while node.name == "default:cactus" do
			height = height + 1
			pos.y = pos.y + 1
			node = minetest.get_node(pos)
		end
		if node.name ~= "air" then
			return
		end
		if minetest.get_node_light(pos) < 13 then
			return
		end
		minetest.set_node(pos, {name = "default:cactus"})
		return true
	end

	function default.grow_papyrus(pos, node)
		pos.y = pos.y - 1
		local name = minetest.get_node(pos).name
		if name ~= "default:dirt" and
				name ~= "default:dirt_with_grass" and
				name ~= "default:dirt_with_dry_grass" and
				name ~= "default:dirt_with_rainforest_litter" and
				name ~= "default:dry_dirt" and
				name ~= "default:dry_dirt_with_dry_grass" then
			return
		end
		if not minetest.find_node_near(pos, 3, {"group:water"}) then
			return
		end
		pos.y = pos.y + 1
		local height = 0
		while node.name == "default:papyrus" do
			height = height + 1
			pos.y = pos.y + 1
			node = minetest.get_node(pos)
		end
		if node.name ~= "air" then
			return
		end
		if minetest.get_node_light(pos) < 13 then
			return
		end
		minetest.set_node(pos, {name = "default:papyrus"})
		return true
	end
end