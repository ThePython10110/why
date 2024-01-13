why = {}

why.mcl = minetest.get_modpath("mcl_core")
why.mcla = minetest.get_game_info().id == "mineclonia"
why.mcl2 = why.mcl and not why.mcla

-- All Why mods that add items/nodes should be in this list.
local mod_list = {
    "fake_liquids",
    "flying_sausage",
    "get_group_items",
    "lava_sponge",
    "meat_blocks",
    "slime_things",
    "small_why_things",
    "sound_machine",
    "sticky_things",
    "useless_beans",
    "useful_green_potatoes",
    "why_init",
}

function why.inventory_formspec(x,y)
    local formspec
    if why.mcl then
        formspec = "list[current_player;main;"..tostring(x)..","..tostring(y)..";9,3;9]"..
            mcl_formspec.get_itemslot_bg(x,y,9,3)..
            "list[current_player;main;"..tostring(x)..","..tostring(y+3.25)..";9,1]"..
            mcl_formspec.get_itemslot_bg(x,y+3.25,9,1)
    else
        formspec = "list[current_player;main;"..tostring(x)..","..tostring(y)..";8,1]"..
        "list[current_player;main;"..tostring(x)..","..tostring(y+1.25)..";8,3;8]"
    end
    return formspec
end

if why.mcl then
    why.sound_mod = mcl_sounds
else
    why.sound_mod = default
end
if why.mcl2 then
    for _, mod in ipairs(mod_list) do
        mcl_item_id.set_mod_namespace(mod, "why")
    end
    mcl_item_id.set_mod_namespace("ghost_blocks")
else
    minetest.register_on_mods_loaded(function()
        for name, def in pairs(minetest.registered_items) do
            for _, mod in ipairs(mod_list) do
                if name:sub(1,#mod) == mod then
                    minetest.register_alias("why:"..name:sub(#mod+2, -1), name)
                end
            end
        end
    end)
end

minetest.register_alias("why:ghostifier", "ghost_blocks:ghostifier")