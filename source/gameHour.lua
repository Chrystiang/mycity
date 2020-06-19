hourOfClock = function()
	local hour = math.floor(24 * (room.currentGameHour / 1440))
	local min = (room.currentGameHour % 60)
	hour = (hour + 12) % 24
	return string.format("%.2d:%.2d", hour, min)
end

checkGameHour = function(hour)
	if hour == '-' then return true end
	local time = hourOfClock()
	time = time:gsub(':', '')
	time = tonumber(time)
	hour = hour:gsub(':', '')
	local opened, closed = hour:match('(%d+) (%d+)')
	return time > tonumber(opened) and time < tonumber(closed)
end

updateHour = function(player, arg)
	local time = hourOfClock()

	if arg then
		return time
	else
		ui.addTextArea(1457, '<p align="center"><b><font size="32" face="Arial">'..time, player, 2100-2, 8718-1185+11, 120, 70, 0x1, 0x1, 0)
		if time == '17:00' then
			loadDayTimeEffects('evening')
		elseif time == '19:00' then
			loadDayTimeEffects('night')
		elseif time == '05:00' then
			loadDayTimeEffects('dawn')
		elseif time == '07:00' then
			loadDayTimeEffects('day')
		elseif time == '21:00' then
			kickPlayersFromPlace('market')
		end
	end
end

formatDaysRemaining = function(calc, ended)
	local daysfrom = os.difftime(os.time(), calc) / (24 * 60 * 60) / 1000
	if not ended then
		return math.abs(math.floor(daysfrom))
	else
		if math.floor(daysfrom) >= 0 then
			return true
		end
	end
end