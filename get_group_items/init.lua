function why.get_group_items(groups, allow_duplicates, include_no_group)
	if type(groups) ~= "table" then
		return nil
	end

	allow_duplicates = allow_duplicates or false
    include_no_group = include_no_group or false

	local g_cnt = #groups

	local result = {}
	for i = 1, g_cnt do
		result[groups[i]] = {}
	end
    if include_no_group then
        result["NO_GROUP"] = {}
    end
    local in_group = false

	for name, def in pairs(minetest.registered_nodes) do
        in_group = false
		for i = 1, g_cnt do
			local grp = groups[i]
			if def.groups[grp] ~= nil then
				result[grp][#result[grp]+1] = name
                in_group = true
				if allow_duplicates == false then
					break
				end
			end
		end
        if include_no_group and in_group == false then
            result["NO_GROUP"][#result["NO_GROUP"]+1] = name
        end
	end

	return result
end