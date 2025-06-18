core.register_decoration({
    deco_type = "schematic",
    place_on = {"group:sand", "group:soil", "mcl_mud:mud"},
    sidelen = 16,
    noise_params = {
        offset = 0.0,
        scale = 0.0001,
        spread = {x = 100, y = 100, z = 100},
        seed = 2020,
        octaves = 3,
        persist = 0.6
    },
    y_min = -1,
    y_max = 30000,
    schematic = core.get_modpath("why_schematic").."/why.mts",
    rotation = "random",
    height = 1,
    flags = "all_floors, liquid_surface, force_placement"
})