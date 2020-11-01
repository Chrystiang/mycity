-- EventHandler, made by Tocutoeltuco#0000
local initializingModule = true

local onEvent
local CYCLE_DURATION = 3100
local RUNTIME_LIMIT = 45
local SCHEDULE = {
	["PlayerDataLoaded"] = true,
	["PlayerRespawn"] = true,
	["PlayerLeft"] = true,
	["PlayerBonusGrabbed"] = true,
}

do
	-- Runtime breaker
	local cycleId = 0
	local usedRuntime = 0
	local stopingAt = 0
	local checkingRuntime = false
	local paused = false
	local scheduled = {_count = 0, _pointer = 1}
	local lastErrorLog = ''

	-- Listeners
	local events = {}

	local function errorHandler(name, msg)
		translatedMessage("emergencyMode_able")
		chatMessage(name ..' - '.. msg)
		setPlayerLimit(1)
		room.requiredPlayers = 1000
		genLobby()

		for _, event in next, events do
			event._count = 0
		end
	end

	local function callListeners(evt, a, b, c, d, e, offset)
		for index = offset, evt._count do
			evt[index](a, b, c, d, e)

			if not initializingModule and os_time() >= stopingAt then
				if index < evt._count then
					-- If this event didn't end, we need to resume from
					-- where it has been left!
					scheduled._count = scheduled._count + 1
					scheduled[ scheduled._count ] = {evt, a, b, c, d, e, index + 1}
				end

				paused = true
				cycleId = cycleId + 2
				if room.dayCounter > 0 then
					translatedMessage("emergencyMode_pause")
				else
					translatedMessage("syncingGame")
				end
				setPlayerLimit(1)
				for player in next, ROOM.playerList do
					freezePlayer(player, true)
				end
				break
			end
		end
	end

	local function resumeModule()
		local count = scheduled._count

		local event
		for index = scheduled._pointer, count do
			event = scheduled[index]
			callListeners(event[1], event[2], event[3], event[4], event[5], event[6], event[7])

			if paused then
				if scheduled._count > count then
					-- If a new event has been scheduled, it is this one.
					-- It should be the first one to run on the next attempt to resume.
					event[7] = scheduled[ scheduled._count ][7]

					-- So we set it to start from here
					scheduled._pointer = index
					-- and remove the last item, since we don't want it to
					-- execute twice!
					scheduled._count = scheduled._count - 1
				else
					-- If no event has been scheduled, this one has successfully ended.
					-- We just tell the next attempt to resume to start from the next one.
					scheduled._pointer = index + 1
				end
				return
			end
		end

		-- delete all the scheduled tables since they just use ram!
		scheduled = {_count = 0, _pointer = 1}
		translatedMessage("emergencyMode_resume")
		setPlayerLimit(room.maxPlayers)
		for player in next, ROOM.playerList do
			freezePlayer(player, false)
		end
	end

	local function registerEvent(name)
		local evt = events[name]
		local schedule = SCHEDULE[name]

		local event
		event = function(a, b, c, d, e)
			if initializingModule then
				local done, result = pcall(callListeners, evt, a, b, c, d, e, 1)
				if not done and lastErrorLog ~= result then
					chatMessage(name.. ' - '..result)
					lastErrorLog = result
					--return errorHandler(name, result)
				end
			end

			if checkingRuntime then
				if paused then
					if schedule then
						scheduled._count = scheduled._count + 1
						scheduled[ scheduled._count ] = {evt, a, b, c, d, e, 1}
					end
					return
				end
				-- Directly call callListeners since there's no need of
				-- two error handlers
				callListeners(evt, a, b, c, d, e, 1)
				return
			end

			-- If we call any event inside this one, we don't need to
			-- perform all the runtime breaker checks.
			checkingRuntime = true
			local start = os_time()
			local thisCycle = floor(start / CYCLE_DURATION)

			if thisCycle > cycleId then
				-- new runtime cycle
				cycleId = thisCycle
				usedRuntime = 0
				stopingAt = start + RUNTIME_LIMIT

				-- if this was paused, we need to resume!
				if paused then
					paused = false
					checkingRuntime = false

					local done, result = pcall(resumeModule)
					if not done then
						errorHandler("resuming", result)
						return
					end

					usedRuntime = usedRuntime + os_time() - start

					-- if resuming took a lot of runtime, we have to
					-- pause again
					if paused then
						if schedule then
							scheduled._count = scheduled._count + 1
							scheduled[ scheduled._count ] = {evt, a, b, c, d, e, 1}
						end
						return
					end
				end
			else
				stopingAt = start + RUNTIME_LIMIT - usedRuntime
			end

			if paused then
				if schedule then
					scheduled._count = scheduled._count + 1
					scheduled[ scheduled._count ] = {evt, a, b, c, d, e, 1}
				end
				checkingRuntime = false
				return
			end

			local done, result = pcall(callListeners, evt, a, b, c, d, e, 1)
			if not done and lastErrorLog ~= result then
				chatMessage(name.. ' - '..result)
				lastErrorLog = result
				table_insert(room.errorLogs, 1, '<ch>['..os_date("%X")..']</ch> <v>'..name .. '</v> <j>-</j> <g>'.. result:gsub('Fofinhoppp#0000.lua', 'main'))
				if #table_concat(room.errorLogs, '\n') >= 1900 then
					room.errorLogs[#room.errorLogs] = nil
				end
				--return errorHandler(name, result)
			end

			checkingRuntime = false
			usedRuntime = usedRuntime + os_time() - start
		end

		return event
	end

	function onEvent(name, callback)
		local evt = events[name]

		if not evt then
			-- Unregistered event
			evt = {_count = 0}
			events[name] = evt

			_G["event" .. name] = registerEvent(name)
		end

		-- Register callback
		evt._count = evt._count + 1
		evt[ evt._count ] = callback
	end
end