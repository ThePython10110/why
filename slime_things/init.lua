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
        local def = core.registered_items[block]
        local groups = def.groups
        groups.dig_immediate = 3
        groups.bouncy = 80
        groups.fall_damage_add_percent = -100
        groups.deco_block = 1
        core.override_item(block, {
            drawtype = "nodebox",
            paramtype = "light",
            tiles = { "mcl_core_slime.png" },
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
        local def = core.registered_items[block]
        local groups = def.groups
        groups.dig_immediate = 3
        groups.bouncy = 80
        groups.fall_damage_add_percent = -100
        groups.deco_block = 1
        core.override_item(block, {
            paramtype = "light",
            tiles = { "mcl_core_slime.png" },
            use_texture_alpha = "blend",
            groups = groups
        })
    end

    core.override_item("mcl_stairs:slab_slimeblock", {
        node_box = {
            type = "fixed",
            fixed = {
                { -0.25, -0.375, -0.25, 0.25, -0.125, 0.25 },
                { -0.5,  -0.5,   -0.5,  0.5,  0,      0.5 },
            }
        },
    })

    core.override_item("mcl_stairs:slab_slimeblock_top", {
        node_box = {
            type = "fixed",
            fixed = {
                { -0.25, 0.125, -0.25, 0.25, 0.375, 0.25 },
                { -0.5,  0,     -0.5,  0.5,  0.5,   0.5 },
            }
        },
    })

    core.override_item("mcl_stairs:slab_slimeblock_double", {
        node_box = {
            type = "fixed",
            fixed = {
                { -0.25, -0.375, -0.25, 0.25, -0.125, 0.25 },
                { -0.5,  -0.5,   -0.5,  0.5,  0,      0.5 },
                { -0.25, 0.125,  -0.25, 0.25, 0.375,  0.25 },
                { -0.5,  0,      -0.5,  0.5,  0.5,    0.5 },
            }
        },
    })

    local pressure_plate_itemstring

    if core.get_modpath("mesecons_pressureplates") then
        if mesecon and mesecon.register_pressure_plate then
            mesecon.register_pressure_plate(
                "slime_things:pressure_plate_slimeblock",
                "Slime Pressure Plate",
                { "mcl_core_slime.png" },
                { "mcl_core_slime.png" },
                "mcl_core_slime.png",
                nil,
                { --no idea why it's completely silent...
                    dug = { name = "slimenodes_dug", gain = 0.6 },
                    place = { name = "slimenodes_place", gain = 0.6 },
                    footstep = { name = "slimenodes_step", gain = 0.3 },
                },
                { { "mcl_core:slimeblock", "mcl_core:slimeblock" } },
                { bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100, },
                nil,
                "A slime pressure plate is a redstone component which supplies its surrounding blocks with redstone " ..
                "power while any movable object (including dropped items, players and mobs) rests on top of it."
            )
            pressure_plate_itemstring = "slime_things:pressure_plate_slimeblock"
        end
    elseif core.get_modpath("mcl_pressureplates") and mcl_pressureplates then
        mcl_pressureplates.register_pressure_plate("slimeblock", {
            description = "Slime Pressure Plate",
            texture = "mcl_core_slime.png",
            recipeitem = "mcl_core:slimeblock",
            "mcl_core:slimeblock",
            sounds = { --no idea why it's completely silent...
                dug = { name = "slimenodes_dug", gain = 0.6 },
                place = { name = "slimenodes_place", gain = 0.6 },
                footstep = { name = "slimenodes_step", gain = 0.3 },
            },
            groups = { bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100, },
            activated_by = { mob = true },
            longdesc = "A slime pressure plate is a redstone component which supplies its surrounding blocks with redstone " ..
            "power while any mob (not players or items) rests on top of it."
        })
        pressure_plate_itemstring = "mcl_pressureplates:pressure_plate_slimeblock"
    end

    if pressure_plate_itemstring then
        core.override_item(pressure_plate_itemstring.."_off", {
            use_texture_alpha = "blend",
        })

        core.override_item(pressure_plate_itemstring.."_on", {
            use_texture_alpha = "blend",
        })
    end

    local button_itemstring

    if core.get_modpath("mesecons_button") then
        if mesecon and mesecon.register_button then
            mesecon.register_button(
                "slimeblock",
                "Slime Button",
                "mcl_core_slime.png",
                "mcl_mobitems:slimeball",
                {
                    dug = { name = "slimenodes_dug", gain = 0.6 },
                    place = { name = "slimenodes_place", gain = 0.6 },
                    footstep = { name = "slimenodes_step", gain = 0.3 },
                },
                { bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100, },
                14,
                true,
                "A slime button can be pushed to provide redstone power. When pushed, " ..
                "it powers adjacent redstone components for 14 seconds. Slime buttons may also be pushed by arrows.",
                "slimenodes_place"
            )
            button_itemstring = "mesecons_button:button_slimeblock"
        end
    elseif core.get_modpath("mcl_buttons") and mcl_buttons then
        mcl_buttons.register_button("slimeblock", {
            description = "Slime Button",
            texture = "mcl_core_slime.png",
            recipeitem = "mcl_mobitems:slimeball",
            sounds = {
                dug = { name = "slimenodes_dug", gain = 0.6 },
                place = { name = "slimenodes_place", gain = 0.6 },
                footstep = { name = "slimenodes_step", gain = 0.3 },
            },
            groups = { bouncy = 80, dig_immediate = 3, fall_damage_add_percent = -100, },
            push_duration = 140,
            push_by_arrow = true,
            longdesc = "A slime button can be pushed to provide redstone power. When pushed, " ..
                "it powers adjacent redstone components for 14 seconds. Slime buttons may also be pushed by arrows.",
            push_sound = "slimenodes_place",
        })
        button_itemstring = "mcl_buttons:button_slimeblock"
    end

    if button_itemstring then
        if awards then
            awards.register_achievement("why:fourteen", {
                title = "Fourteen seconds of waiting",
                description = "Press a slime button",
                icon = "mcl_core_slime.png",
                type = "Advancement",
                group = "Why"
            })
            local old_function = core.registered_items[button_itemstring.."_off"].on_rightclick
            core.override_item(button_itemstring.."_off", {
                on_rightclick = function(pos, node, player, itemstack, pointed_thing)
                    awards.unlock(player:get_player_name(), "why:fourteen")
                    return old_function(pos, node, player, itemstack, pointed_thing)
                end
            })
        end

        core.override_item(button_itemstring.."_off", {
            use_texture_alpha = "blend",
        })

        core.override_item(button_itemstring.."_on", {
            use_texture_alpha = "blend",
        })
    end
end
