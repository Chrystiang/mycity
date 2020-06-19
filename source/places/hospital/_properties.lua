room.hospital = {}

for floor = 1, 9 do
	room.hospital[floor] = {}
    for bed = 1, 2 do
        room.hospital[floor][bed] = {name = nil}
    end
end