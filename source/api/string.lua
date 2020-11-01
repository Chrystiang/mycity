string_nick = function(name)
	if not name then return end
	local var = name:lower():gsub('%a', string.upper, 1)
	for i, v in next, ROOM.playerList do
		if i:find(var) then
			return i
		end
	end
end

string_replace = function(name, args)
	for i, v in next, args do
		if i == '{1}' then
			args[i] = '<font color="#7bbd40">'..v..'</font>'
		else
			args[i] = translate(v, name)
		end
	end
	local str = translate('multiTextFormating', name)
	return (gsub(str, '{.-}', args, #str /3))
end

string_toTable = function(x)
	return (type(x) == "table" and x or {x})
end