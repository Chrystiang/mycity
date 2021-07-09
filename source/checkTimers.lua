local workingTimerState = {
	stop = -1,
	start = 0,
	tryLimit = 2,
	setBroken = 3,
	setVerified = 4,
	broken = 5
}
local workingTimer = workingTimerState.start
do
	checkWorkingTimer = function()
		if workingTimer == workingTimerState.broken then
			updateDialogs(10) -- Function used in timers is now used in eventLoop
		elseif workingTimer > workingTimerState.tryLimit then
			if workingTimer == workingTimerState.setBroken then
				workingTimer = workingTimerState.broken
				errorHandler('Timers', 'Error')
			elseif workingTimer == workingTimerState.setVerified then
				workingTimer = workingTimerState.stop
			end
			-- Chunk below executes once, verification finished
		elseif workingTimer > workingTimerState.stop then
			if workingTimer < workingTimerState.tryLimit then
				workingTimer = workingTimer + 0.5
				if workingTimer == workingTimerState.tryLimit then
					workingTimer = workingTimerState.setBroken
				end
			end
		end
	end
	system.newTimer(function()
		workingTimer = workingTimerState.setVerified
	end, 1000, false)
end