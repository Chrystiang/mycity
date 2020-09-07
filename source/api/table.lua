table.contains = function(tbl, val)
   for i = 1, #tbl do
	  if tbl[i] == val then
		 return true
	  end
   end
   return false
end

table.copy = function(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in next, obj do
		res[table.copy(k, s)] = table.copy(v, s)
	end
	return res
end

table.concatFancy = function(tbl, sepMiddle, sepFinal, j)
	sepFinal = sepFinal or sepMiddle or ''
	j = j or #tbl
	return table.concat(tbl, sepMiddle, 1, j - 1) .. sepFinal .. tbl[j]
end

table.getIndex = function(tbl, val)
   for k, v in next, tbl do
	  if v == val then
		 return k
	  end
   end
end

table.getLength = function(tbl)
	local length = 0
	for _ in next, tbl do
		length = length + 1
	end
	return length
end

table.merge = function(this, src)
	for k, v in next, src do
		if this[k] then
			if type(v) == "table" then
				this[k] = string.toTable(this[k])
				table.merge(this[k], v)
			else
				this[k] = this[k] or v
			end
		else
			this[k] = v
		end
	end
end

table.randomKey = function(tbl)
	local key
	local counter = 0
	for k in next, tbl do
		counter = counter + 1
		if math.random() < (1 / counter) then
			key = k
		end
	end
	return key
end