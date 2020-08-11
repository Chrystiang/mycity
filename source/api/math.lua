math.hypo = function(x1, y1, x2, y2)
	return ((x2-x1)^2 + (y2-y1)^2)^0.5
end

math.range = function(polygon, point)
	local oddNodes = false
	local j = #polygon
	for i = 1, #polygon do
		if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
			if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
				oddNodes = not oddNodes;
			end
		end
		j = i;
	end
	return oddNodes
end