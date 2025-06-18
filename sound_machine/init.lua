local center_itemstring = "wool:black"
local copper_itemstring = "default:copper_ingot"
if why.mcl then
    center_itemstring = "mcl_colorblocks:concrete_black"
    copper_itemstring = "mcl_copper:copper_ingot"
end

local sound_machine_context = {}

local sound_machine_buttons
if why.mcl then
    sound_machine_buttons = {
        { { sound = "tnt_ignite", name = "Ignite TNT" },                           { sound = "tnt_explode", name = "Explosion" },        { sound = "mcl_bows_bow_shoot", name = "Bow Shot", } },
        { { sound = "mcl_experience_level_up", name = "XP Level Up", gain = 0.6 }, { sound = "player_damage", name = "Player Damage" },  { sound = "awards_got_generic", name = "Achievement", } },
        { { sound = "mobs_mc_wolf_bark", name = "Wolf" },                          { sound = "mobs_mc_zombie_growl", name = "Zombie" },  { sound = "mobs_mc_pillager_ow1", name = "Ow", } },
        { { sound = "mobs_mc_villager", name = "Villager" },                       { sound = "mobs_mc_spider_random", name = "Spider" }, { sound = "mobs_mc_cat_idle", name = "Cat", } },
        { { sound = "mobs_mc_cow", name = "Cow" },                                 { sound = "mobs_pig", name = "Pig" },                 { sound = "mobs_mc_ender_dragon_shoot", name = "Ender Dragon" } },
    }
else
    sound_machine_buttons = {
        { { sound = "tnt_ignite", name = "Ignite TNT" },             { sound = "tnt_explode", name = "Explosion" },           { sound = "default_break_glass", name = "Breaking Glass", } },
        { { sound = "default_chest_open", name = "Open Chest" },     { sound = "default_chest_close", name = "Close Chest" }, { sound = "player_damage", name = "Player Damage", } },
        { { sound = "default_cool_lava", name = "Lava cooling" },    { sound = "fire_fire", name = "Fire" },                  { sound = "fire_flint_and_steel", name = "Flint and Steel", } },
        { { sound = "default_tool_breaks", name = "Tool breaking" }, { sound = "default_water_footstep", name = "Water" },    { sound = "doors_fencegate_open", name = "Open Gate", } },
        { { sound = "doors_door_open", name = "Open Door" },         { sound = "doors_door_close", name = "Close Door" },     { sound = "doors_fencegate_close", name = "Close Gate" } },
    }
end

local function generate_formspec(sound_box, pitch)
    local height = #sound_machine_buttons + 4
    local formspec = "size[11," .. height .. "]" ..
        "label[0.5,0.5;Sound Machine]" ..
        "field[1," .. (height - 1.5) .. ";2,1;pitch;Pitch;" .. pitch .. "]" ..
        "button[3," .. (height - 1.8) .. ";2,1;pitch_button;Set Pitch]" ..
        "field[1," .. (height - 0.5) .. ";7,1;custom_sound;;" .. sound_box .. "]" ..
        "field_close_on_enter[pitch;false]" ..
        "field_close_on_enter[custom_sound;false]" ..
        "button[8," .. (height - 0.8) .. ";2,1;custom_sound_button;Custom Sound]"
    for row_num, row in ipairs(sound_machine_buttons) do
        for column_num, column in ipairs(row) do
            formspec = formspec ..
                "button[" .. (column_num * 3 - 2) ..
                "," .. (row_num + 1) .. ";3,1;" .. row_num .. "_" .. column_num .. ";" .. column.name .. "]"
        end
    end
    return formspec
end

local function show_portable_formspec(itemstack, player, pointed_thing)
    if not player:get_player_control().sneak then
        -- Call on_rightclick if the pointed node defines it
        if pointed_thing and pointed_thing.type == "node" then
            local pos = pointed_thing.under
            local node = core.get_node(pos)
            if player and not player:get_player_control().sneak then
                local nodedef = core.registered_nodes[node.name]
                local on_rightclick = nodedef and nodedef.on_rightclick
                if on_rightclick then
                    return on_rightclick(pos, node, player, itemstack, pointed_thing) or itemstack
                end
            end
        end
    end
    local custom_sound = player:get_meta():get_string("sound_machine_custom_sound") or "tnt_ignite"
    local pitch = player:get_meta():get_string("sound_machine_pitch") or 1.0
    local formspec = generate_formspec(custom_sound, pitch)

    core.show_formspec(player:get_player_name(), "sound_machine_portable_sound_machine", formspec)
end

local function show_sound_machine_formspec(pos, node, clicker)
    local last_sound = core.get_meta(pos):get_string("sound_machine_last_sound")
    local pitch = core.get_meta(pos):get_string("sound_machine_pitch") or 1.0
    local formspec = generate_formspec(last_sound, pitch)

    sound_machine_context[clicker:get_player_name()] = pos
    core.show_formspec(clicker:get_player_name(), "sound_machine_sound_machine", formspec)
end

local function sound_machine_play(pos)
    local last_sound = core.get_meta(pos):get_string("sound_machine_last_sound")
    --core.log(last_sound)
    local pitch = tonumber(core.get_meta(pos):get_string("sound_machine_pitch") or 1)
    core.sound_play({ name = last_sound, pitch = pitch }, { pos = pos, max_hear_distance = 20 })
end

core.register_tool("sound_machine:portable_sound_machine", {
    description = "Portable Sound Machine",
    on_use = function(itemstack, player, pointed_thing)
        local pitch = tonumber(player:get_meta():get_string("sound_machine_pitch") or 1)
        local sound = player:get_meta():get_string("sound_machine_custom_sound") or "tnt_ignite"
        core.sound_play({ name = sound, pitch = pitch }, { pos = player:get_pos(), max_hear_distance = 20 })
        player:get_meta():set_string("sound_machine_custom_sound", sound)
    end,
    on_place = show_portable_formspec,
    on_secondary_use = show_portable_formspec,
    inventory_image = "sound_machine_sound_machine.png",
    wield_image = "sound_machine_sound_machine.png"
})
core.register_node("sound_machine:sound_machine", {
    description = "Sound Machine",
    tiles = { "sound_machine_sound_machine.png" },
    groups = { pickaxey = 1, cracky = 2, material_stone = 1 },
    is_ground_content = false,
    place_param2 = 0,
    on_rightclick = function(pos, node, clicker) -- change sound when rightclicked
        local protname = clicker:get_player_name()
        if core.is_protected(pos, protname) then
            core.record_protection_violation(pos, protname)
            return
        end
        show_sound_machine_formspec(pos, node, clicker)
    end,
    on_punch = function(pos, node) -- play current sound when punched
        sound_machine_play(pos)
    end,
    sounds = why.sound_mod.node_sound_wood_defaults(),
    mesecons = (not why.mcla) and {
        effector = { -- play sound when activated
            action_on = function(pos, node)
                sound_machine_play(pos)
            end,
            rules = { { x = 1, y = 0, z = 0 },
                { x = -1, y = 0,  z = 0 },
                { x = 0,  y = 1,  z = 0 },
                { x = 0,  y = -1, z = 0 },
                { x = 0,  y = 0,  z = 1 },
                { x = 0,  y = 0,  z = -1 } },
        }
    },
    _mcl_redstone = {
        connects_to = function(node, dir)
            return true
        end,
        update = why.mcla and function(pos, node)
            local oldpowered = math.floor(node.param2 / 32) ~= 0
            local powered = mcl_redstone.get_power(pos) ~= 0
            if powered and not oldpowered then
                sound_machine_play(pos)
            end
            return {
                name = node.name,
                param2 = node.param2 % 32 + (powered and 32 or 0),
            }
        end
    },
    _mcl_blast_resistance = 0.8,
    _mcl_hardness = 0.8,
})

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "sound_machine_portable_sound_machine" then
        if fields.quit then return end

        local player_pos = player:get_pos()

        if (fields.key_enter_field == "pitch" or fields.pitch_button) and fields.pitch then
            if tonumber(fields.pitch) then
                player:get_meta():set_string("sound_machine_pitch", fields.pitch)
            end
        end

        if (fields.key_enter_field == "custom_sound" or fields.custom_sound_button) and fields.custom_sound then
            local pitch = tonumber(player:get_meta():get_string("sound_machine_pitch") or 1)
            core.sound_play({ name = fields.custom_sound, pitch = pitch }, { pos = player_pos, max_hear_distance = 20 })
            player:get_meta():set_string("sound_machine_custom_sound", fields.custom_sound)
            show_portable_formspec(nil, player)
        end
        for field, data in pairs(fields) do
            local _, _, row, column = string.find(field, "^(%d+)_(%d+)$") -- 2 numbers separated by an underscore (and nothing else)
            if row and column then
                local sound_data = sound_machine_buttons[tonumber(row)][tonumber(column)]
                local pitch = tonumber(player:get_meta():get_string("sound_machine_pitch") or 1)
                core.sound_play({ name = sound_data.sound, gain = sound_data.gain, pitch = pitch },
                    { pos = player_pos, max_hear_distance = 20 })
                player:get_meta():set_string("sound_machine_custom_sound", sound_data.sound)
                show_portable_formspec(nil, player)
                return
            end
        end
    elseif formname == "sound_machine_sound_machine" then
        if fields.quit then
            sound_machine_context[player:get_player_name()] = nil
            return
        end

        if sound_machine_context[player:get_player_name()] then
            local pos = sound_machine_context[player:get_player_name()]

            if (fields.key_enter_field == "pitch" or fields.pitch_button) then
                if tonumber(fields.pitch) then
                    core.get_meta(pos):set_string("sound_machine_pitch", fields.pitch or 1)
                end
            end

            if (fields.key_enter_field == "custom_sound" or fields.custom_sound_button) then
                if fields.custom_sound then
                    core.get_meta(pos):set_string("sound_machine_last_sound", fields.custom_sound)
                end
                sound_machine_play(pos)
                show_sound_machine_formspec(pos, nil, player)
            end
            for field, data in pairs(fields) do
                local _, _, row, column = string.find(field, "^(%d+)_(%d+)$") -- 2 numbers separated by an underscore (and nothing else)
                if row and column then
                    local sound_data = sound_machine_buttons[tonumber(row)][tonumber(column)]
                    core.get_meta(pos):set_string("sound_machine_last_sound", sound_data.sound)
                    sound_machine_play(pos)
                    show_sound_machine_formspec(pos, nil, player)
                    return
                end
            end
        end
    end
end)

core.register_craft({
    output = "sound_machine:portable_sound_machine",
    recipe = { { "sound_machine:sound_machine" } }
})

core.register_craft({
    output = "sound_machine:sound_machine",
    recipe = { { "sound_machine:portable_sound_machine" } }
})

core.register_craft({
    output = "sound_machine:sound_machine",
    recipe = {
        { copper_itemstring, copper_itemstring, copper_itemstring },
        { copper_itemstring, center_itemstring, copper_itemstring },
        { copper_itemstring, copper_itemstring, copper_itemstring },
    }
})
