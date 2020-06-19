for k, v in next, lang do
	if k ~= "en" then
		table.merge(v, lang.en)
	end
end