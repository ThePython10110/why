-------Bouncy wool---------

local wool_list = get_group_items({"wool"})

for i, itemstring in ipairs(wool_list.wool) do
    local groups = minetest.registered_nodes[itemstring].groups
    groups.bouncy = 95
    minetest.override_item(itemstring, {groups = groups})
end -- Intentionally not making it prevent fall damage :D

-------Sunnier sunflowers-------
minetest.override_item("mcl_flowers:sunflower_top", {
    light_source = 14
})

-------Craftable barriers-------
minetest.register_node("small_why_things:craftable_barrier", {
	description = "Craftable Barrier",
	_doc_items_longdesc = "Barriers are invisible walkable blocks. They are used to create boundaries of adventure maps and the like. Monsters and animals won't appear on barriers, and fences do not connect to barriers. Other blocks can be built on barriers like on any other block.",
	_doc_items_usagehelp = "When you hold a barrier in hand, you reveal all placed barriers in a short distance around you.",
	drawtype = "airlike",
	paramtype = "light",
	inventory_image = "mcl_core_barrier.png",
	wield_image = "mcl_core_barrier.png",
	tiles = {"blank.png"},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {not_solid = 1, cracky = 3, pickaxey = 1},
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if placer == nil then
			return
		end
		minetest.add_particle({
			pos = pos,
			expirationtime = 1,
			size = 8,
			texture = "mcl_core_barrier.png",
			glow = 14,
			playername = placer:get_player_name()
		})
	end,
})

minetest.register_craft({
	output = "small_why_things:craftable_barrier 17",
	recipe = {
		{"mcl_core:glass", "mcl_core:glass", "mcl_core:glass"},
		{"mcl_core:glass", "mcl_core:obsidian", "mcl_core:glass"},
		{"mcl_core:glass", "mcl_core:glass", "mcl_core:glass"}
	}
})

minetest.register_globalstep(function() --I wish there was a way to unregister the MineClone function.
	for _,player in pairs(minetest.get_connected_players()) do
		local wi = player:get_wielded_item():get_name()
		if wi == "mcl_core:barrier" or wi == "mcl_core:realm_barrier" or wi == "small_why_things:craftable_barrier"  or minetest.get_item_group(wi, "light_block") ~= 0 then
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
				if nodename == "mcl_core:barrier" or nodename == "small_why_things:craftable_barrier" then
					tex = "mcl_core_barrier.png"
				elseif nodename == "mcl_core:realm_barrier" then
					tex = "mcl_core_barrier.png^[colorize:#FF00FF:127^[transformFX"
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
						playername = name
					})
				end
			end
			end
			end
		end
	end
end)