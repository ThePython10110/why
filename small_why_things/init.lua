-------Bouncy wool---------

local glass_itemstring = "default:glass"
local obsidian_itemstring = "default:obsidian"
if why.mcl then
	glass_itemstring = "mcl_core:glass"
	obsidian_itemstring = "mcl_core:obsidian"
end

local wool_list = why.get_group_items({"wool"})

for i, itemstring in ipairs(wool_list.wool) do
    local groups = core.registered_nodes[itemstring].groups
    groups.bouncy = 95
    core.override_item(itemstring, {groups = groups})
end -- Intentionally not making it prevent fall damage :D

if why.mcl then
	-------Sunnier sunflowers-------
	core.override_item("mcl_flowers:sunflower_top", {
		light_source = 14
	})
	-------Blue Feathers--------
	core.register_craftitem("small_why_things:blue_feather", {
		description = "Blue Feather",
		wield_image = "mcl_mobitems_feather.png^[multiply:#0044ff",
		inventory_image = "mcl_mobitems_feather.png^[multiply:#0044ff",
	})
	core.register_craft({
		output = "small_why_things:blue_feather",
		type = "shapeless",
		recipe = {"mcl_mobitems:feather", "mcl_dye:blue"}
	})
	core.register_craft({
		output = "small_why_things:blue_feather",
		type = "shapeless",
		recipe = {"mcl_mobitems:feather", "mcl_dye:lightblue"}
	})
end

-------Craftable barriers-------
core.register_node("small_why_things:craftable_barrier", {
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
		core.add_particle({
			pos = pos,
			expirationtime = 1,
			size = 8,
			texture = "small_why_things_craftable_barrier.png^[colorize:#FFFF00:127",
			glow = 14,
			playername = player:get_player_name()
		})
	end,
})

core.register_craft({
	output = "small_why_things:craftable_barrier 17",
	recipe = {
		{glass_itemstring, glass_itemstring, glass_itemstring},
		{glass_itemstring, obsidian_itemstring, glass_itemstring},
		{glass_itemstring, glass_itemstring, glass_itemstring}
	}
})

core.register_globalstep(function() --I wish there was a way to unregister the MineClone function.
	for _,player in pairs(core.get_connected_players()) do
		local wi = player:get_wielded_item():get_name()
		if wi == "mcl_core:barrier" or wi == "mcl_core:realm_barrier"
		or wi == "small_why_things:craftable_barrier"
		or core.get_item_group(wi, "light_block") ~= 0 then
			local pos = vector.round(player:get_pos())
			local r = 8
			local vm = core.get_voxel_manip()
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
				local nodename = core.get_name_from_content_id(data[vi])
				local light_block_group = core.get_item_group(nodename, "light_block")

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
					core.add_particle({
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
if why.mcl then
	function mcl_core.grow_cactus(pos, node)
		pos.y = pos.y-1
		local name = core.get_node(pos).name
		if core.get_item_group(name, "sand") ~= 0 then
			pos.y = pos.y+1
			local height = 0
			while core.get_node(pos).name == "mcl_core:cactus" --[[and height < 4]] do
				height = height+1
				pos.y = pos.y+1
			end
			if core.get_node(pos).name == "air" then
				core.set_node(pos, {name="mcl_core:cactus"})
			end
		end
	end
	function mcl_core.grow_reeds(pos, node)
		pos.y = pos.y-1
		local name = core.get_node(pos).name
		if core.get_item_group(name, "soil_sugarcane") ~= 0 then
			if core.find_node_near(pos, 1, {"group:water"}) == nil
			and core.find_node_near(pos, 1, {"group:frosted_ice"}) == nil then
				return
			end
			pos.y = pos.y+1
			local height = 0
			while core.get_node(pos).name == "mcl_core:reeds" --[[and height < 3]] do
				height = height+1
				pos.y = pos.y+1
			end
			if core.get_node(pos).name == "air" then
				core.set_node(pos, {name="mcl_core:reeds"})
			end
		end
	end
	if mcl_bamboo then
		function mcl_bamboo.grow(pos)
			local bottom = mcl_util.traverse_tower(pos,-1)
			local top, _ = mcl_util.traverse_tower(bottom,1)
			local node = core.get_node(pos)
			if core.get_node(vector.offset(top,0,1,0)).name ~= "air" then return end
			core.set_node(vector.offset(top,0,1,0),node)
		end
	end
	core.override_item("mcl_core:reeds", {climbable = true})
else
	function default.grow_cactus(pos, node)
		if node.param2 >= 4 then
			return
		end
		pos.y = pos.y - 1
		if core.get_item_group(core.get_node(pos).name, "sand") == 0 then
			return
		end
		pos.y = pos.y + 1
		local height = 0
		while node.name == "default:cactus" do
			height = height + 1
			pos.y = pos.y + 1
			node = core.get_node(pos)
		end
		if node.name ~= "air" then
			return
		end
		if core.get_node_light(pos) < 13 then
			return
		end
		core.set_node(pos, {name = "default:cactus"})
		return true
	end

	function default.grow_papyrus(pos, node)
		pos.y = pos.y - 1
		local name = core.get_node(pos).name
		if name ~= "default:dirt" and
				name ~= "default:dirt_with_grass" and
				name ~= "default:dirt_with_dry_grass" and
				name ~= "default:dirt_with_rainforest_litter" and
				name ~= "default:dry_dirt" and
				name ~= "default:dry_dirt_with_dry_grass" then
			return
		end
		if not core.find_node_near(pos, 3, {"group:water"}) then
			return
		end
		pos.y = pos.y + 1
		local height = 0
		while node.name == "default:papyrus" do
			height = height + 1
			pos.y = pos.y + 1
			node = core.get_node(pos)
		end
		if node.name ~= "air" then
			return
		end
		if core.get_node_light(pos) < 13 then
			return
		end
		core.set_node(pos, {name = "default:papyrus"})
		return true
	end

	core.override_item("default:papyrus", {climbable = true})
end

local bucket_itemstring = (why.mcl and "mcl_buckets:bucket_empty") or "bucket:bucket_empty"

---------------------NEW ACHIEVEMENTS-----------------------
if awards then
	awards.register_achievement("why:bucket", {
		title = "A sense of calm and ease",
		description = "Create a bucket to be your companion in this stressful world",
		icon = why.mcl2 and "mcl_buckets:bucket.png" or "bucket.png",
		trigger = {
			type = "craft",
			item = bucket_itemstring,
			target = 1
		},
		type = "Advancement",
		group = "Why",
	})
	if why.mcl then
		awards.register_achievement("why:cocoa", {
			title = "Tastes terrible.",
			description = "Eat cocoa beans by themselves",
			icon = why.mcl2 and "mcl_cocoa_beans.png" or "mcl_cocoas_cocoa_beans.png",
			trigger = {
				type = "eat",
				item = "mcl_cocoas:cocoa_beans",
				target = 1
			},
			type = "Advancement",
			group = "Why",
		})
		local old_cocoa_function = core.registered_items["mcl_cocoas:cocoa_beans"].on_place
		local eat_function = core.item_eat(1)
		core.override_item("mcl_cocoas:cocoa_beans", {
			groups = {craftitem = 1, compostability = 65, food = 1, eatable = 1},
			_mcl_saturation = 0,
			on_secondary_use = eat_function,
			on_place = function(itemstack, player, pointed_thing)
				local result = old_cocoa_function(itemstack, player, pointed_thing)
				if result == itemstack or result == nil then
					return eat_function(itemstack, player, pointed_thing)
				else
					return result
				end
			end,
		})
		if not why.mcla then
			awards.register_achievement("why:larry", {
				title = "Briny Larry",
				description = "Collect a sea pickle",
				icon = "mcl_ocean_sea_pickle_item.png",
				type = "Advancement",
				group = "Why",
			})
		end
		awards.register_achievement("why:n", {
			title = "n",
			description = "Throw an egg",
			icon = "mobs_chicken_egg.png",
			type = "Advancement",
			group = "Why",
		})
		awards.register_achievement("why:looks_nice", {
			title = "Looks nice, but why is it an achievement?",
			description = "Place light blue terracotta next to cherry leaves (or vice versa)",
			icon = "hardened_clay_stained_light_blue.png",
			type = "Advancement",
			group = "Why",
		})
		awards.register_achievement("why:clear", {
			title = "Clearly invisible",
			description = "Craft light gray stained glass panes.",
			icon = "blank.png",
			trigger = {
				type = "craft",
				item = why.mcl2 and "xpanes:pane_silver_flat" or "mcl_panes:pane_silver_flat",
				target = 1
			},
			type = "Advancement",
			group = "Why",
		})
		if why.mcl2 then
			local old_egg_function = core.registered_items["mcl_throwing:egg"].on_use
			core.override_item("mcl_throwing:egg", {
				on_use = function(itemstack, player, pointed_thing)
					awards.unlock(player:get_player_name(), "why:n")
					return old_egg_function(itemstack, player, pointed_thing)
				end
			})
		elseif why.mcla then
			local old_egg_function = core.registered_items["mcl_throwing:egg"].on_secondary_use
			core.override_item("mcl_throwing:egg", {
				on_secondary_use = function(itemstack, player, pointed_thing)
					awards.unlock(player:get_player_name(), "why:n")
					return old_egg_function(itemstack, player, pointed_thing)
				end
			})
		end
		local check_nodes = { --not necessary but easier
			{x=-1,y=0,z=0},
			{x=1,y=0,z=0},
			{x=0,y=-1,z=0},
			{x=0,y=1,z=0},
			{x=0,y=0,z=-1},
			{x=0,y=0,z=1},
		}
		local cherry_leaves = why.mcla and "mcl_trees:leaves_cherry_blossom" or "mcl_cherry_blossom:cherryleaves"
		local function check_looks_nice(pos)
			local target
			local node = core.get_node(pos)
			if node.name == cherry_leaves then
				target = "mcl_colorblocks:hardened_clay_light_blue"
			elseif node.name == "mcl_colorblocks:hardened_clay_light_blue" then
				target = cherry_leaves
			else
				return
			end
			for _, rel_pos in ipairs(check_nodes) do
				local new_pos = vector.add(pos, rel_pos)
				if core.get_node(new_pos).name == target then
					return true
				end
			end
			return false
		end
		for _, node in ipairs({"mcl_cherry_blossom:cherryleaves", "mcl_colorblocks:hardened_clay_light_blue"}) do
			core.override_item(node, {
				after_place_node = function(pos, player, itemstack, pointed_thing)
					if check_looks_nice(pos) then
						awards.unlock(player:get_player_name(), "why:looks_nice")
					end
				end
			})
		end
		if not why.mcla then -- mcl_item_entity is LOCAL in MCLA........
			mcl_item_entity.register_pickup_achievement("mcl_ocean:sea_pickle_1_dead_brain_coral_block", "why:larry")
		end
	end
end

if core.get_modpath("awards") then
	awards.register_achievement("why:dachshund", {
		title = "Dachshund",
		description = "Spell 'dachshund' correctly",
		icon = "small_why_things_dachshund.png",
		type = "Advancement",
		group = "Why",
		secret = true
	})
	core.register_on_chat_message(function(name, message)
		if string.lower(message):match(".*dachshund.*") then
			awards.unlock(name, "why:dachshund")
		end
	end
)
end