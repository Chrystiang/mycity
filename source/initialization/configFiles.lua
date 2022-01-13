initialization.Files = function()
	loadFile(1)
	if not mainAssets.isRankingActive then
		addTimer(function()
			if room.fileUpdated then
				syncFiles()
				room.fileUpdated = false
			else
				loadFile(1)
			end
		end, 15000, 0)
	else 
		local lastFile = 30
		addTimer(function()
			if lastFile == 30 then
				if room.fileUpdated then
					syncFiles()
					room.fileUpdated = false
				else
					loadFile(1)
				end
				lastFile = 1
			elseif lastFile == 1 then
				loadFile(30)
				lastFile = 30
			end
		end, 15000, 0)
	end
end