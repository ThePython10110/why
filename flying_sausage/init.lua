if why.mcl then


core.override_item("mcl_armor:elytra", {groups = {smoker_cookable = 1, campfire_cookable = 1}})

core.register_craftitem("flying_sausage:cooked_elytra", {
    description = "Cooked Elytra\nWeirdly delicious.",
    wield_image = "mcl_armor_inv_elytra.png^[multiply:#551100",
    inventory_image = "mcl_armor_inv_elytra.png^[multiply:#551100",
    on_place = core.item_eat(9999999), -- why not?
    on_secondary_use = core.item_eat(9999999),
    _mcl_saturation = 9999999,
	groups = {smoker_cookable = 1, campfire_cookable = 1}
})

core.register_craft({
    output = "flying_sausage:cooked_elytra",
    type = "cooking",
    recipe = "mcl_armor:elytra",
    cooktime = 160,
})

core.register_craftitem("flying_sausage:burnt_elytra", {
    description = "Burnt Elytra\nWeirdly delicious.",
    wield_image = "mcl_armor_inv_elytra.png^[multiply:#000000",
    inventory_image = "mcl_armor_inv_elytra.png^[multiply:#000000",
    on_place = function(itemstack, player, pointed_thing)
        return why.eat_burnt_food(99999, 10, itemstack, player, pointed_thing) -- burnt elytras are 2 nines worse...
    end,
    on_secondary_use = function(itemstack, player, pointed_thing)
        return why.eat_burnt_food(99999, 10, itemstack, player, pointed_thing)
    end,
    _mcl_saturation = 99999,
})

core.register_craft({
    output = "flying_sausage:burnt_elytra",
    type = "cooking",
    recipe = "flying_sausage:cooked_elytra",
    cooktime = 160,
})

why.check_sausage = function(player)
    local ignore_sausage = false
    if player:get_meta():get_int("flying_sausage_ignore") == 1 then
        ignore_sausage = true
    else
        player:get_meta():set_int("flying_sausage_ignore", 2)
    end
    if player:get_inventory():contains_item("flying_sausage_flight_stomach", "flying_sausage:flying_sausage") then
        return true, ignore_sausage
    else
        return nil, ignore_sausage
    end
end

why.update_sausage = function(player)
    local sausage, ignore_sausage = why.check_sausage(player)
    if not ignore_sausage then
        local privs = core.get_player_privs(player:get_player_name())
        privs.fly = sausage
        core.set_player_privs(player:get_player_name(), table.copy(privs))
    end
end

-- Automatically set new players who can fly to ignore sausage
core.register_on_newplayer(function(player)
    if core.check_player_privs(player, "fly") then
        player:get_meta():set_int("flying_sausage_ignore", 1)
    end
end)

core.register_on_joinplayer(function(player, last_login)
    player:get_inventory():set_size("flying_sausage_flight_stomach", 1)
    why.update_sausage(player)
end)

core.register_chatcommand("ignore_sausage", {
    privs = {privs = true},
    func = function(name, param)
        local player = core.get_player_by_name(name)
        local meta = player:get_meta()
        if meta:get_int("flying_sausage_ignore") == 1 then
            meta:set_int("flying_sausage_ignore", 2)
            core.chat_send_player(name, "Stopped ignoring sausage")
            why.update_sausage(player)
        else
            meta:set_int("flying_sausage_ignore", 1)
            core.chat_send_player(name, "Ignoring sausage")
        end
    end
})

--[[ This revokes flight privilege when leaving the server, in case the mod is removed/disabled.
Of course, this won't run if the server crashes. In that case, revoke fly manually.
I recommend getting the Snippets mod and pasting this code in:


for _, player in pairs(core.get_connected_players()) do
    if player:get_attribute("flying_sausage_ignore") == 2 then
        local privs = core.get_player_privs(player:get_player_name())
        privs.fly = false
        core.set_player_privs(player:get_player_name(), privs)
    end
end


This will only apply to players that are currently on the server.


]]

core.register_on_leaveplayer(function(player, timed_out)
    local sausage, ignore_sausage = why.check_sausage(player)
    if not ignore_sausage then
        local privs = core.get_player_privs(player:get_player_name())
        privs.fly = false
        core.set_player_privs(player:get_player_name(), privs)
    end
end)

-- I don't know why I did all this MTG compatibility stuff...
local width = 8
if why.mcl then width = 9 end

local formspec =
    "size["..tostring(width)..",7]"..
    "list[current_player;flying_sausage_flight_stomach;"..tostring(width/2-0.5)..",1;1,1]"..
    why.inventory_formspec(0,3)..
    "listring[current_player;main]"..
    "listring[current_player;flying_sausage_flight_stomach]"
if why.mcl then
    formspec = formspec..mcl_formspec.get_itemslot_bg(width/2-0.5,1,1,1)
end

local on_rightclick = function(itemstack, player, pointed_thing)
    core.show_formspec(player:get_player_name(), "flying_sausage_flight_stomach", formspec)
end

core.register_allow_player_inventory_action(function(player, action, inv, info)
	if inv:get_location().type == "player"
    and action == "move"
    and (info.from_list == "flying_sausage_flight_stomach" or info.to_list == "flying_sausage_flight_stomach") then
		if player:get_wielded_item():get_name() == "flying_sausage:flight_stomach" then
            local stack
			if info.listname or (info.from_list and info.from_list == "flying_sausage_flight_stomach") then
                stack = player:get_inventory():get_stack("flying_sausage_flight_stomach", info.from_index)
            else
                stack = player:get_inventory():get_stack("main", info.from_index)
            end
            if stack:get_name() == "flying_sausage:flying_sausage" or action == "take" then
                return stack:get_count()
            else
                return 0
            end
        else
            return 0
        end
	end
end)

core.register_on_player_inventory_action(function(player, action, inventory, info)
    if (info.from_list and info.from_list == "flying_sausage_flight_stomach")
    or (info.to_list and info.to_list == "flying_sausage_flight_stomach")
    or (info.list_name and info.listname == "flying_sausage_flight_stomach") then
        why.update_sausage(player)
    end
end)

core.register_tool("flying_sausage:flight_stomach", {
    description = "Flight Stomach Accessor\nStorage for a Flying Sausage",
    on_secondary_use = on_rightclick,
    on_place = on_rightclick,
    wield_image = "flying_sausage_flight_stomach.png",
    inventory_image = "flying_sausage_flight_stomach.png"
})

core.register_craft({
    output = "flying_sausage:flight_stomach",
    type = "shapeless",
    recipe = {"mcl_chests:chest", "meat_blocks:burnt_sausage"}
})

local function sausage_function(itemstack, player, pointed_thing)
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
    if awards then
        awards.unlock(player:get_player_name(), "why:wurst")
    end
    local eat_func = core.item_eat(9999999999999999)
    return eat_func(itemstack, player, pointed_thing)
end

core.register_tool("flying_sausage:flying_sausage", {
    description = "Flying Sausage\nYes, it looks exactly like a normal cooked sausage.\nDon't get them mixed up.",
    wield_image = "meat_blocks_sausage_cooked.png",
    inventory_image = "meat_blocks_sausage_cooked.png",
    on_place = sausage_function, -- You'll be fed as long as Chell was in suspension...
    on_secondary_use = sausage_function, -- Except for some reason it rounds to 10^??? :(
    _mcl_saturation = 9999999999999999,
})

core.register_craft({
    output = "flying_sausage:flying_sausage",
    recipe = {
        {"meat_blocks:burnt_block_sausage", "meat_blocks:burnt_block_sausage", "meat_blocks:burnt_block_sausage"},
        {"meat_blocks:burnt_block_sausage", "flying_sausage:burnt_elytra", "meat_blocks:burnt_block_sausage"},
        {"meat_blocks:burnt_block_sausage", "meat_blocks:burnt_block_sausage", "meat_blocks:burnt_block_sausage"},
    }
})

awards.register_achievement("why:wurst", {
    title = "Wurst Misteak Possible",
    description = "Eat a Flying Sausage",
    icon = "meat_blocks_sausage_cooked.png",
    type = "Advancement",
    group = "Why",
})


end