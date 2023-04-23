local sound_machine_buttons = {
    {{sound = "tnt_ignite", name = "TNT Ignite",},                  {sound = "tnt_explode", name = "Explosion",},           {sound = "mcl_bows_bow_shoot", name = "Bow Shoot",}},
    {{sound = "mcl_experience_level_up", name = "XP Level Up", gain = 0.6},    {sound = "player_damage", name = "Player Damage",},     {sound = "awards_got_generic", name = "Achievement",}},
    {{sound = "mobs_mc_wolf_bark", name = "Wolf",},                 {sound = "mobs_mc_zombie_growl", name = "Zombie",},     {sound = "mobs_mc_pillager_ow1", name = "Ow",}},
    {{sound = "mobs_mc_villager", name = "Villager",},              {sound = "mobs_mc_spider_random", name = "Spider",},    {sound = "mobs_mc_cat_idle", name = "Cat",}},
}

local function show_sound_machine_formspec(itemstack, player, pointed_thing)
    if not player:get_player_control().sneak then 
        local new_stack = mcl_util.call_on_rightclick(itemstack, player, pointed_thing)
        if new_stack then
            return new_stack
        end
    end
    local custom_sound = player:get_attribute("sound_machine_custom_sound") or "tnt_ignite"
    --minetest.log(custom_sound)
    local formspec = "size[11,9]"..
    "label[0.5,0.5;Sound Machine]"..
    "field[1,8.5;7,1;custom_sound;;"..custom_sound.."]"..
    "field_close_on_enter[custom_sound;false]"..
    "button[8,8.2;2,1;custom_sound_button;Custom Sound]"
    for row_num, row in ipairs(sound_machine_buttons) do
        for column_num, column in ipairs(row) do
            formspec = formspec.."button["..(column_num*3-2)..","..(row_num+1)..";3,1;"..row_num.."_"..column_num..";"..column.name.."]"
        end
    end

    minetest.show_formspec(player:get_player_name(), "sound_machine_sound_machine", formspec)
end

minetest.register_tool("sound_machine:sound_machine", {
    description = "Sound Machine",
    on_place = show_sound_machine_formspec,
    on_secondary_use = show_sound_machine_formspec,
    inventory_image = "sound_machine_sound_machine.png",
    wield_image = "sound_machine_sound_machine.png"
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local player_pos = player:get_pos()
    if formname == "sound_machine_sound_machine" then
        if fields.quit then
            return
        end
        if (fields.key_enter_field == "custom_sound" or fields.custom_sound_button) and fields.custom_sound then
            minetest.sound_play(fields.custom_sound, {pos = player_pos, max_hear_distance = 20})
            player:set_attribute("sound_machine_custom_sound", fields.custom_sound)
            --minetest.log(fields.custom_sound)
        end
        for field, data in pairs(fields) do
            local _, _, row, column = string.find(field, "^(%d+)_(%d+)$")
            if row and column then
                local sound_data = sound_machine_buttons[tonumber(row)][tonumber(column)]
                --minetest.log(tostring(row).." "..tostring(column))
                minetest.sound_play({name = sound_data.sound, gain = sound_data.gain}, { pos = player_pos, max_hear_distance = 20})
                return
            end
        end
    end
end)

minetest.register_craft({
    output = "sound_machine:sound_machine",
    recipe = {
        {"mcl_jukebox:jukebox", "mcl_jukebox:jukebox"},
        {"mcl_jukebox:jukebox", "mcl_jukebox:jukebox"}
    }
})