initialization.Timers = function()
	system.looping(function()
		if GAME_PAUSED then return end
		updateDialogs(4)
		timersLoop(250)
	end, 4)

	system.newTimer(function()
		if tonumber(os_date('%S'))%10 == 0 then
			loadPlayerData('Sharpiebot#0000')
		end
	end, 1000, true)
end