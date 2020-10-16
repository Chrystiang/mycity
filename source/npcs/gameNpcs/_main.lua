local gameNpcs = {characters = {}, robbing = {}, orders = {canOrder = {}, orderList = {}, activeOrders = {}, trashImages = {}}}

system.looping(function()
	updateDialogs(4)
end, 10)