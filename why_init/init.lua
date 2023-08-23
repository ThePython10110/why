why = {}

why.mineclone = minetest.get_modpath("mcl_core")

local mod_list = {
    "fake_liquids",
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

if why.mineclone then
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