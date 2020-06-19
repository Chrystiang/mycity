gameNpcs.updateDialogBox = function(id)
	local index = dialogs[id]
	if not index.text[index.currentPage] then return end
	local t = string.sub(index.text[index.currentPage], 1, index.length)
	local text = index.text
	ui.updateTextArea(-88001, '<font color="#f4e0c5">'..t, id)
	ui.updateTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_skipAnimation'>" .. string.rep('\n', 10), id)
	if #t >= #text[index.currentPage] then 
		index.running = false
		index.currentPage = index.currentPage + 1
		index.length = 0
		isQuest = index.isQuest and index.isQuest or 'not'
		ui.updateTextArea(-88002, "<textformat leftmargin='1' rightmargin='1'><a href='event:npcDialog_nextPage_"..index.name.."_"..index.npcID.."_"..isQuest.."_"..index.currentPage.."'>" .. string.rep('\n', 10), id)
	end
end