

local absorb = function(pos)
	local change = false
	-- Count number of absorbed river water vs other nodes
	-- to determine the wet sponge type.
	local p, n
	for i=-3,3 do
    for j=-3,3 do
    for k=-3,3 do
        p = {x=pos.x+i, y=pos.y+j, z=pos.z+k}
        n = minetest.get_node(p)
        if minetest.get_item_group(n.name, "lava") ~= 0 then
            minetest.add_node(p, {name="air"})
            change = true
        end
    end
    end
    end
	-- The dominant water type wins. In case of a tie, normal water wins.
	-- This slight bias is intentional.
	local sponge_type = "lava_sponge:lava_sponge_wet"
	return change, sponge_type
end

minetest.register_node("lava_sponge:lava_sponge", {
	description = "Lava Sponge",
	_tt_help = "Removes lava on contact",
	_doc_items_longdesc = "Lava sponges are blocks which remove lava around them when they are placed or come in contact with lava, turning it into a wet sponge.",
	drawtype = "normal",
	is_ground_content = false,
	tiles = {"mcl_sponges_sponge.png"..mcl_enchanting.overlay},
	walkable = true,
	pointable = true,
	diggable = true,
	buildable_to = false,
	stack_max = 64,
	sounds = mcl_sounds.node_sound_dirt_defaults(),
	groups = {handy=1, hoey=1, building_block=1},
	on_place = function(itemstack, placer, pointed_thing)
		local pn = placer:get_player_name()
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		-- Use pointed node's on_rightclick function first, if present
		local node = minetest.get_node(pointed_thing.under)
		if placer and not placer:get_player_control().sneak then
			if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
				return minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack) or itemstack
			end
		end

		if minetest.is_protected(pointed_thing.above, pn) then
			return itemstack
		end

		local pos = pointed_thing.above
		local on_lava = false
		if minetest.get_item_group(minetest.get_node(pos).name, "lava") ~= 0 then
			on_lava = true
		end
		local lava_found = minetest.find_node_near(pos, 1, "group:lava")
		if lava_found then
			on_lava = true
		end
		if on_lava then
			-- Absorb lava
			-- FIXME: pos is not always the right placement position because of pointed_thing
			local absorbed, wet_sponge = absorb(pos)
			if absorbed then
				minetest.item_place_node(ItemStack(wet_sponge), placer, pointed_thing)
				if not minetest.is_creative_enabled(placer:get_player_name()) then
					itemstack:take_item()
				end
				return itemstack
			end
		end
		return minetest.item_place_node(itemstack, placer, pointed_thing)
	end,
	_mcl_blast_resistance = 0.6,
	_mcl_hardness = 0.6,
})

minetest.register_node("lava_sponge:lava_sponge_wet", {
	description = "Lava-logged Sponge",
	_tt_help = "Can be used as fuel",
	_doc_items_longdesc = "A lava-logged sponge can be used as fuel in the furnace to turn it into a (dry) lava sponge.",
	drawtype = "normal",
	is_ground_content = false,
	tiles = {"mcl_sponges_sponge_wet.png"..mcl_enchanting.overlay},
	walkable = true,
	pointable = true,
	diggable = true,
	buildable_to = false,
	stack_max = 64,
	sounds = mcl_sounds.node_sound_dirt_defaults(),
	groups = {handy=1, hoey=1, building_block=1},
	_mcl_blast_resistance = 0.6,
	_mcl_hardness = 0.6,
})

minetest.register_abm({
	label = "Sponge lava absorbtion",
	nodenames = { "lava_sponge:lava_sponge" },
	neighbors = { "group:lava" },
	interval = 1,
	chance = 1,
	action = function(pos)
		local absorbed, wet_sponge = absorb(pos)
		if absorbed then
			minetest.add_node(pos, {name = wet_sponge})
		end
	end,
})

minetest.register_craft({
	type = "fuel",
	recipe = "lava_sponge:lava_sponge_wet",
	burntime = 1000,
	replacements = {{"lava_sponge:lava_sponge_wet", "lava_sponge:lava_sponge"}},
})

minetest.register_craft({
    output = "lava_sponge:lava_sponge",
    recipe = {
        {"mcl_nether:netherrack", "mcl_nether:netherrack", "mcl_nether:netherrack"},
        {"mcl_nether:netherrack", "mcl_sponges:sponge", "mcl_nether:netherrack"},
        {"mcl_nether:netherrack", "mcl_nether:netherrack", "mcl_nether:netherrack"}
    }
})