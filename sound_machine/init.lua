local sound_machine_context = {}


local sound_machine_buttons = {
    {{sound = "tnt_ignite", name = "TNT Ignite",},                              {sound = "tnt_explode", name = "Explosion",},           {sound = "mcl_bows_bow_shoot", name = "Bow Shoot",}},
    {{sound = "mcl_experience_level_up", name = "XP Level Up", gain = 0.6},     {sound = "player_damage", name = "Player Damage",},     {sound = "awards_got_generic", name = "Achievement",}},
    {{sound = "mobs_mc_wolf_bark", name = "Wolf",},                             {sound = "mobs_mc_zombie_growl", name = "Zombie",},     {sound = "mobs_mc_pillager_ow1", name = "Ow",}},
    {{sound = "mobs_mc_villager", name = "Villager",},                          {sound = "mobs_mc_spider_random", name = "Spider",},    {sound = "mobs_mc_cat_idle", name = "Cat",}},
    {{sound = "mobs_mc_cow", name = "Cow",},                                    {sound = "mobs_pig", name = "Pig",},                    {sound = "mobs_mc_ender_dragon_shoot", name = "Ender Dragon"}},
}

local function generate_formspec(sound_box, pitch)
    local height = #sound_machine_buttons + 4
    local formspec = "size[11,"..height.."]"..
    "label[0.5,0.5;Sound Machine]"..
    "field[1,"..(height-1.5)..";2,1;pitch;Pitch;"..pitch.."]"..
    "button[3,"..(height-1.8)..";2,1;pitch_button;Set Pitch]"..
    "field[1,"..(height-0.5)..";7,1;custom_sound;;"..sound_box.."]"..
    "field_close_on_enter[pitch;false]"..
    "field_close_on_enter[custom_sound;false]"..
    "button[8,"..(height-0.8)..";2,1;custom_sound_button;Custom Sound]"
    for row_num, row in ipairs(sound_machine_buttons) do
        for column_num, column in ipairs(row) do
            formspec = formspec.."button["..(column_num*3-2)..","..(row_num+1)..";3,1;"..row_num.."_"..column_num..";"..column.name.."]"
        end
    end
    return formspec
end

local function show_portable_formspec(itemstack, player, pointed_thing)
    if not player:get_player_control().sneak then 
        local new_stack = mcl_util.call_on_rightclick(itemstack, player, pointed_thing)
        if new_stack then
            return new_stack
        end
    end
    local custom_sound = player:get_attribute("sound_machine_custom_sound") or "tnt_ignite"
    local pitch = player:get_attribute("sound_machine_pitch") or 1.0
    local formspec = generate_formspec(custom_sound, pitch)

    minetest.show_formspec(player:get_player_name(), "sound_machine_portable_sound_machine", formspec)
end

local function show_sound_machine_formspec(pos, node, clicker)
    local last_sound = minetest.get_meta(pos):get_string("sound_machine_last_sound")
    local pitch = minetest.get_meta(pos):get_string("sound_machine_pitch") or 1.0
    local formspec = generate_formspec(last_sound, pitch)

    sound_machine_context[clicker:get_player_name()] = pos
    minetest.show_formspec(clicker:get_player_name(), "sound_machine_sound_machine", formspec)
end

minetest.register_tool("sound_machine:portable_sound_machine", {
    description = "Portable Sound Machine",
    on_place = show_portable_formspec,
    on_secondary_use = show_portable_formspec,
    inventory_image = "sound_machine_sound_machine.png",
    wield_image = "sound_machine_sound_machine.png"
})
minetest.register_node("sound_machine:sound_machine", {
    description = "Sound Machine",
    tiles = {"sound_machine_sound_machine.png"},
	groups = {pickaxey = 1, material_stone = 1},
	is_ground_content = false,
	place_param2 = 0,
	on_rightclick = function(pos, node, clicker) -- change sound when rightclicked
		local protname = clicker:get_player_name()
		if minetest.is_protected(pos, protname) then
			minetest.record_protection_violation(pos, protname)
			return
		end
		show_sound_machine_formspec(pos, node, clicker)
	end,
	on_punch = function(pos, node) -- play current sound when punched
		minetest.sound_play(minetest.get_meta(pos):get_string("sound_machine_last_sound"))
	end,
	sounds = mcl_sounds.node_sound_wood_defaults(),
	mesecons = {effector = { -- play sound when activated
		action_on = function(pos, node)
			minetest.sound_play(minetest.get_meta(pos):get_string("sound_machine_last_sound"))
		end,
		rules = {{x= 1, y= 0,  z= 0},
        {x=-1, y= 0,  z= 0},
        {x= 0, y= 1,  z= 0},
        {x= 0, y=-1,  z= 0},
        {x= 0, y= 0,  z= 1},
        {x= 0, y= 0,  z=-1}},
	}},
	_mcl_blast_resistance = 0.8,
	_mcl_hardness = 0.8,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "sound_machine_portable_sound_machine" then
        if fields.quit then return end

        local player_pos = player:get_pos()
        
        if (fields.key_enter_field == "pitch" or fields.pitch_button) and fields.pitch then
            if tonumber(fields.pitch) then
                player:set_attribute("sound_machine_pitch", fields.pitch)
            end
        end

        if (fields.key_enter_field == "custom_sound" or fields.custom_sound_button) and fields.custom_sound then
                local pitch = tonumber(player:get_attribute("sound_machine_pitch"))
            minetest.sound_play({name = fields.custom_sound, pitch = pitch}, {pos = player_pos, max_hear_distance = 20})
            player:set_attribute("sound_machine_custom_sound", fields.custom_sound)
        end
        for field, data in pairs(fields) do
            local _, _, row, column = string.find(field, "^(%d+)_(%d+)$")
            if row and column then
                local sound_data = sound_machine_buttons[tonumber(row)][tonumber(column)]
                local pitch = tonumber(player:get_attribute("sound_machine_pitch"))
                minetest.sound_play({name = sound_data.sound, gain = sound_data.gain, pitch = pitch}, { pos = player_pos, max_hear_distance = 20})
                return
            end
        end
    elseif formname == "sound_machine_sound_machine" then
        if fields.quit then return end

        if sound_machine_context[player:get_player_name()] then
            local pos = sound_machine_context[player:get_player_name()]

            if (fields.key_enter_field == "pitch" or fields.pitch_button) and fields.pitch then
                if tonumber(fields.pitch) then
                    minetest.get_meta(pos):set_string("sound_machine_pitch", fields.pitch)
                end
            end

            if (fields.key_enter_field == "custom_sound" or fields.custom_sound_button) and fields.custom_sound then
                local pitch = tonumber(minetest.get_meta(pos):get_string("sound_machine_pitch"))
                minetest.sound_play({name = fields.custom_sound, pitch = pitch}, {pos = pos, max_hear_distance = 20})
                minetest.get_meta(pos):set_string("sound_machine_last_sound", fields.custom_sound)
            end
            for field, data in pairs(fields) do
                local _, _, row, column = string.find(field, "^(%d+)_(%d+)$")
                if row and column then
                    local sound_data = sound_machine_buttons[tonumber(row)][tonumber(column)]
                    local pitch = tonumber(minetest.get_meta(pos):get_string("sound_machine_pitch"))
                    minetest.log(pitch)
                    minetest.sound_play({name = sound_data.sound, gain = sound_data.gain, pitch = pitch}, { pos = pos, max_hear_distance = 20})
                    minetest.get_meta(pos):set_string("sound_machine_last_sound", sound_data.sound)
                    return
                end
            end
            sound_machine_context[player:get_player_name()] = nil
        end
    end
end)

minetest.register_craft({
    output = "sound_machine:portable_sound_machine",
    recipe = {{"sound_machine:sound_machine"}}
})

minetest.register_craft({
    output = "sound_machine:sound_machine",
    recipe = {{"sound_machine:portable_sound_machine"}}
})

minetest.register_craft({
    output = "sound_machine:sound_machine",
    recipe = {
        {"mcl_copper:copper_ingot", "mcl_copper:copper_ingot", "mcl_copper:copper_ingot",},
        {"mcl_copper:copper_ingot", "mcl_colorblocks:concrete_black", "mcl_copper:copper_ingot",},
        {"mcl_copper:copper_ingot", "mcl_copper:copper_ingot", "mcl_copper:copper_ingot",},
    }
})