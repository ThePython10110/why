if why.mcl then
mcl_stairs.register_stair_and_slab_simple(
    "slimeblock",
    "mcl_core:slimeblock",
    "Slime Stair",
    "Slime Slab",
    "Double Slime Slab"
)

local slime_slabs = {
    "mcl_stairs:slab_slimeblock",
    "mcl_stairs:slab_slimeblock_top",
    "mcl_stairs:slab_slimeblock_double"
}

for i, block in ipairs(slime_slabs) do
    local def = minetest.registered_items[block]
    local groups = def.groups
    groups.dig_immediate = 3
    groups.bouncy = 80
    groups.fall_damage_add_percent = -100
    groups.deco_block = 1
    minetest.override_item(block, {
        drawtype = "nodebox",
        paramtype = "light",
        tiles = {"mcl_core_slime.png"},
        use_texture_alpha = "blend",
        groups = groups,
    })
end

local slime_stairs = {
    "mcl_stairs:stair_slimeblock",
    "mcl_stairs:stair_slimeblock_outer",
    "mcl_stairs:stair_slimeblock_inner"
}

for i, block in ipairs(slime_stairs) do
    local def = minetest.registered_items[block]
    local groups = def.groups
    groups.dig_immediate = 3
    groups.bouncy = 80
    groups.fall_damage_add_percent = -100
    groups.deco_block = 1
    minetest.override_item(block, {
        paramtype = "light",
        tiles = {"mcl_core_slime.png"},
        use_texture_alpha = "blend",
        groups = groups
    })
end

minetest.override_item("mcl_stairs:slab_slimeblock", {
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.375, -0.25, 0.25, -0.125, 0.25},
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
        }
    },
})

minetest.override_item("mcl_stairs:slab_slimeblock_top", {
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, 0.125, -0.25, 0.25, 0.375, 0.25},
            {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
        }
    },
})

minetest.override_item("mcl_stairs:slab_slimeblock_double", {
    node_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.375, -0.25, 0.25, -0.125, 0.25},
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
            {-0.25, 0.125, -0.25, 0.25, 0.375, 0.25},
            {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
        }
    },
})


if minetest.get_modpath("mesecons_pressureplates") then
	if mesecon ~= nil and mesecon.register_pressure_plate ~= nil then
        mesecon.register_pressure_plate(
            "slime_things:pressure_plate_slimeblock",
            "Slime Pressure Plate",
            { "mcl_core_slime.png" },
            { "mcl_core_slime.png" },
            "mcl_core_slime.png",
            nil,
            { --no idea why it's completely silent...
                dug = {name = "slimenodes_dug", gain = 0.6},
                place = {name = "slimenodes_place", gain = 0.6},
                footstep = {name = "slimenodes_step", gain = 0.3},
            },
            { { "mcl_core:slimeblock", "mcl_core:slimeblock" } },
            {bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100,},
            nil,
            "A slime pressure plate is a redstone component which supplies its surrounding blocks with redstone "..
            "power while any movable object (including dropped items, players and mobs) rests on top of it."
        )
    end
end

minetest.override_item("slime_things:pressure_plate_slimeblock_off", {
    use_texture_alpha = "blend",
})

minetest.override_item("slime_things:pressure_plate_slimeblock_on", {
    use_texture_alpha = "blend",
})


if minetest.get_modpath("mesecons_button") then
	if mesecon ~= nil and mesecon.register_button ~= nil then
        mesecon.register_button(
            "slimeblock",
            "Slime Button",
            "mcl_core_slime.png",
            "mcl_mobitems:slimeball",
            {
                dug = {name = "slimenodes_dug", gain = 0.6},
                place = {name = "slimenodes_place", gain = 0.6},
                footstep = {name = "slimenodes_step", gain = 0.3},
            },
            {bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100,},
            14,
            true,
            "A slime button can be pushed to provide redstone power. When pushed, "..
            "it powers adjacent redstone components for 14 seconds. Slime buttons may also be pushed by arrows.",
            "slimenodes_place"
        )
    end
end

minetest.override_item("mesecons_button:button_slimeblock_off", {
    use_texture_alpha = "blend",
})

minetest.override_item("mesecons_button:button_slimeblock_on", {
    use_texture_alpha = "blend",
})
end

if awards then
    awards.register_achievement("why:fourteen", {
        title = "Fourteen seconds of waiting",
        description = "Press a slime button",
        icon = "mcl_core_slime.png",
        type = "Advancement",
        group = "Why"
    })
    local old_function = minetest.registered_items["mesecons_button:button_slimeblock_off"].on_rightclick
    minetest.override_item("mesecons_button:button_slimeblock_off", {
        on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            awards.unlock(player:get_player_name(), "why:fourteen")
            return old_function(pos, node, player, itemstack, pointed_thing)
        end
    })
end