mine_setStoneType = function(depth, frequency)
	local ores = {}
	local y = depth
	for i, v in next, Mine.stones do
		local min = (i-1.87)* math.random(4, 6)
		local max = i * math.random(4, 6)
		if y >= min and y <= max then
			local rarity = (y / (max*2.5) * frequency)*math.random(0, 100)
			ores[i] = rarity
		end
	end
	local rarity = math.random(10)/perlin:noise(frequency)
	for i, v in next, ores do
		if v >= rarity then
			return i
		else 
			for other in next, ores do
				if other ~= i then 
					return other 
				end 
			end
		end
		return i
	end
	return #Mine.stones
end

mine_setOre = function(rockType)
	if Mine.stones[rockType].ores then 
		for i = #Mine.stones[rockType].ores, 1, -1 do
			local random = math.random(0, 100)
			local ore = Mine.stones[rockType].ores[i]
			if random <= Mine.ores[ore].rarity then 
				return ore
			end
		end
	end
	return nil
end

mine_generate = function(player)
	for i = 1, (Mine.area[1] * Mine.area[2]) do 
		local depth = math.floor((i-1)/Mine.area[1])
		local x = Mine.position[1] + Mine.blockLength/2 + ((i-1)%Mine.area[1]) * Mine.blockLength
		local y = Mine.position[2] + Mine.blockLength/2 + depth * Mine.blockLength
		local stone = mine_setStoneType(depth, perlin:noise(x/10.101, y/10.101, perlin:noise(i/10.101*math.random(0, 10))))
		local ore = mine_setOre(stone)
		Mine.blocks[i] = {type = stone, ore = ore, images = {}, oreImages = {}, size = 0, x = x, y = y, removed = false, life = {0, Mine.stones[stone].health, nil}, column = 1 + (i - 1)%Mine.area[1], line = 1 + math.floor((i - 1)/Mine.area[1])}
		if i <= 10 then 
			Mine.blocks[i].images[#Mine.blocks[i].images+1] = addImage(Mine.stones[stone].image, '_100'..i, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
			mine_updateBlockLife(i, player)
			grid[i] = true
			Mine.availableRocks[i] = true
		end
	end
	mine_drawGrid(mine_optimizeGrid(grid, grid_width, grid_height), 60, Mine.position[1], Mine.position[2])
end

mine_updateBlockLife = function(groundID, player)
	local blockLength = Mine.blockLength
	local x = Mine.blocks[groundID].x - blockLength/2
	local y = Mine.blocks[groundID].y - blockLength/2
	local life = Mine.blocks[groundID].life[2]-Mine.blocks[groundID].life[1]
	ui.addTextArea(groundID..'40028923', '<p align="center"><font color="#000000" size="12"><b>'..life, player, x, y+20, blockLength, blockLength, 0x1, 0x1, 0)
	ui.addTextArea(groundID..'40028922', '<a href="event:updateBlock_'..groundID..'">'..string.rep('\n', 10), player, x, y, blockLength, blockLength, 0x1, 0x1, 0)
	Mine.blocks[groundID].life[3] = true
end

mine_generateBlockAssets = function(groundID)
	local blocksAround = {}
	local corner = {}
	for i = -1, 1 do 
		for j = -1, 1 do
			local id = groundID + j + Mine.area[1]*i
			if Mine.blocks[id] and id ~= groundID and not Mine.blocks[id].removed then
				if math.hypo(Mine.blocks[id].x, Mine.blocks[id].y, Mine.blocks[groundID].x, Mine.blocks[groundID].y) <= 100 then 
					blocksAround[#blocksAround+1] = id
					if i ~= 0 and j ~= 0 then 
						corner[id] = true
					end
				end
			end
		end
	end
	for i, v in next, blocksAround do
		Mine.availableRocks[v] = true
		if corner[v] then
			Mine.availableRocks[v] = 'corner'
		end
		mine_reloadBlock(v)
	end
end

mine_reloadBlock = function(block, player)
	local v = block
	local x = Mine.blocks[v].x
	local y = Mine.blocks[v].y
	Mine.blocks[v].images[#Mine.blocks[v].images+1] = addImage(Mine.stones[Mine.blocks[v].type].image, '_100'..v, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
	if Mine.blocks[v].ore then 
		Mine.blocks[v].oreImages[#Mine.blocks[v].oreImages+1] = addImage(Mine.ores[Mine.blocks[v].ore].img, '_100'..v, x-Mine.blockLength/2, y-Mine.blockLength/2, player)
	end
	if Mine.availableRocks[v] ~= 'corner' then 
		mine_updateBlockLife(v, player)
	end
end

mine_removeBlock = function(blocks, width, height, x, y)
	local position = x + (y - 1) * width
	--print(position .. " " .. x .. " " .. y .. " " .. width .. " " .. height)
	if not blocks[position] then return height end -- the block is already removed

	blocks[position] = nil -- remove the block
	if x > 1 and blocks[position - 1] == false then
		-- if the removed block is not on the left edge,
		-- and the left block is there but not drawn yet
		blocks[position - 1] = true -- draw it
	end
	if x < width and blocks[position + 1] == false then -- same but with the other side
		blocks[position + 1] = true
	end
	for i, v in next, {(position - Mine.area[1]), (position - Mine.area[1]-1), (position - Mine.area[1]+1), (position + Mine.area[1]-1), (position + Mine.area[1]+1)} do
		if blocks[v] == false then 
			blocks[v] = true
		end
	end

	if y == height then -- if the block was on the last row
		local offset = height * width

		-- add a new row with false values EXCEPT for the one down this one
		for column = 1, width do
			blocks[column + offset] = column == x
		end

		-- and add 1 to the height!
		return height + 1
	elseif blocks[position + width] == false then
		blocks[position + width] = true
	end
	return height -- otherwise just return the same height
end

mine_optimizeGrid = function(grid, width, height)
	-- Optimize vertically
	local columns = {}
	local blocks, start, block -- allocate variables
	for column = 1, width do
		blocks, start = {}, nil -- initialize them

		for row = 0, height - 1 do
			block = grid[column + row * width] -- gets the block

			if not start then -- if we're not in a block batch yet
				if block then -- but there is a block
					start = row -- then this is the batch start
				end

			elseif not block then -- otherwise, if we're in a block batch but there is no block
				blocks[start] = row - 1 -- then the previous block is the batch end
				start = nil
			end
		end

		-- if we've finished iterating the rows
		if start then -- but there is a batch that has not ended
			blocks[start] = height - 1 -- then the batch end is the last block
		end

		columns[column] = blocks
	end

	-- Optimize horizontally
	local result, count = {}, 0 -- prepare result as we'll tell where to spawn blocks after optimizing horizontally
	local x_start, x_end
	for column = 1, width do
		for batch_start, batch_end in next, columns[column] do
			x_start, x_end = column, column -- horizontal batch start and end is at the same column
			for _column = column + 1, width do
				if columns[_column][batch_start] == batch_end then -- if the next column has the same vertical batch
					x_end = _column -- enlarge horizontal batch
					columns[_column][batch_start] = nil -- and delete that vertical batch from that column
														-- (so the vertical batch is not optimized twice)
					-- and check with the next column
				else -- if the next column doesn't have the same vertical batch
					break 
				end
			end

			count = count + 1 -- add a ground spawn instruction with the optimized batch to the result
			result[count] = {x_start, batch_start + 1, x_end, batch_end + 1}
		end
	end
	return result
end

mine_drawGrid = function(grid, size, x, y)
    local ground_data = { -- don't set width and height as it will be ignored!
        type 		= 14,
        friction 	= 20,
        restitution = .6,
    }

    local step, left, top, right, bottom
    for ground = 1, #grid do
        step = grid[ground]

        left = (step[1] - 1) * size
        top = (step[2] - 1) * size
        right = step[3] * size
        bottom = step[4] * size

        ground_data.width = right - left
        ground_data.height = bottom - top
        groundIDS[#groundIDS+1] = ground
        addGround(ground, x + (right + left) / 2, y + (bottom + top) / 2, ground_data)
    end
end