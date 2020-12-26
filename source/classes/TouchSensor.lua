local TouchSensor = {
	sensors = {},
}
do
	TouchSensor.add = function(tokenType, x, y, id, angle, icon, target, callback, respawn)
		if not TouchSensor.sensors[id] then
			TouchSensor.sensors[id] = {
				type = tokenType,
				x = x,
				y = y,
				angle = angle,
				icon = icon,
				target = target,
				callback = callback,
				respawn = respawn,
			}
		end
		TFM.addBonus(tokenType, x, y, id, angle, icon, target)
	end

	TouchSensor.remove = function(id, player)
		TFM.removeBonus(id, player)
		if not player then
			TouchSensor.sensors[id] = nil
		end
	end

	TouchSensor.triggered = function(player, id)
		local self = TouchSensor.sensors[id]
		if not self then
			return alert_Error(player, 'error', 'TouchSensor failed: <r>invalid id<cs('..id..')</cs></r>')
		end
		if self.callback then
			self.callback(player)
		end
		if self.respawn then
			TFM.addBonus(
				self.type, 
				self.x, 
				self.y, 
				id, 
				self.angle, 
				self.icon,
				player
			)
		else
			TouchSensor.remove(id, player)
		end
	end
end