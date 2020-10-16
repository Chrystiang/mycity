HouseSystem = { }
HouseSystem.__index = HouseSystem

HouseSystem.new = function(player)
	local self = {
		y = 1590,
		houseOwner = player,
	}
	return setmetatable(self, HouseSystem)
end