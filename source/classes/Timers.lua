-- Timers, made by Laagaadoo#0000
local List = {}
local timerList = {}
local timersPool
do
	function List.new ()
		return {first = 0, last = -1}
	end
	timersPool = List.new()
	function List.pushleft (list, value)
		local first = list.first - 1
		list.first = first
		list[first] = value
	end

	function List.pushright (list, value)
		local last = list.last + 1
		list.last = last
		list[last] = value
	end

	function List.popleft (list)
		local first = list.first
		if first > list.last then
			return nil
		end
		local value = list[first]
		list[first] = nil        -- to allow garbage collection
		list.first = first + 1
		return value
	end

	function List.popright (list)
		local last = list.last
		if list.first > last then
			return nil
		end
		local value = list[last]
		list[last] = nil         -- to allow garbage collection
		list.last = last - 1
		return value
	end
	function addTimer(callback, ms, loops, label, ...)
		local id = List.popleft(timersPool)
		if id then
			local timer = timerList[id]
			timer.callback = callback
			timer.label = label
			timer.arguments = {...}
			timer.time = ms
			timer.currentTime = 0
			timer.currentLoop = 0
			timer.loops = loops or 1
			timer.isComplete = false
			timer.isPaused = false
			timer.isEnabled = true
		else
			id = #timerList+1
			timerList[id] = {
				callback = callback,
				label = label,
				arguments = {...},
				time = ms,
				currentTime = 0,
				currentLoop = 0,
				loops = loops or 1,
				isComplete = false,
				isPaused = false,
				isEnabled = true,
			}
		end
		return id
	end

	function getTimerId(label)
		local found
		for id = 1, #timerList do
			local timer = timerList[id]
			if timer.label == label then
				found = id
				break
			end
		end
		return found
	end

	function pauseTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isEnabled then
			timerList[id].isPaused = true
			return true
		end
		return false
	end

	function resumeTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isPaused then
			timerList[id].isPaused = false
			return true
		end
		return false
	end

	function removeTimer(id)
		if type(id) == 'string' then
			id = getTimerId(id)
		end

		if timerList[id] and timerList[id].isEnabled then
			timerList[id].isEnabled = false
			List.pushright(timersPool, id)
			return true
		end
		return false
	end
	function clearTimers()
		local timer
		repeat
			timer = List.popleft(timersPool)
			if timer then
				table_remove(timerList, timer)
			end
		until timer == nil
	end
	function timersLoop(delay)
		for id = 1, #timerList do
			local timer = timerList[id]
			if timer.isEnabled and timer.isPaused == false then
				if not timer.isComplete then
					timer.currentTime = timer.currentTime + delay
					if timer.currentTime >= timer.time then
						timer.currentTime = 0
						timer.currentLoop = timer.currentLoop + 1
						if timer.loops > 0 then
							if timer.currentLoop >= timer.loops then
								timer.isComplete = true
								removeTimer(id)
							end
						end
						if timer.callback ~= nil then
							timer.callback(timer.currentLoop, table_unpack(timer.arguments))
						end
					end
				end
			end
		end
	end
end