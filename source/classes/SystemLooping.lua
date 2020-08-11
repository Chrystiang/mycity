-- system.looping, made by Bolodefchoco#0000
system.looping = function(f, ticks, ...)
	local timers, index = { }, 0
	local addTimer = function(_, ...)
		index = index + 1
		timers[index] = system.newTimer(f, 1000, true, ...)
	end

	local seconds = 1000 / ticks
	for timer = 0, 1000 - seconds, seconds do
		system.newTimer(addTimer, 1000 + timer, false, ...)
	end

	return timers
end