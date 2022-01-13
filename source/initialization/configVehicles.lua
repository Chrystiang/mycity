initialization.Vehicles = function()
	for id, data in next, mainAssets.__cars do
		if data.type == 'car' then
			local width = data.size[1]
			local leftWheel  = width - data.wheels[2][1] - data.wheelsSize[2]
			local rightWheel = width - data.wheels[1][1] - data.wheelsSize[1]
			data.wheels = {data.wheels, {{leftWheel, data.wheels[2][2]}, {rightWheel, data.wheels[1][2]}}}
		end
	end
end