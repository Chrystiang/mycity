addLootDrop = function(x, y, wind)
	for i = 1, 51 do
		local a = TFM.addShamanObject(1, -500, 2800)
		TFM.removeObject(a)
	end
	local fallingSpeed = 5
	local id = 1
	addGround(id..'44444444', x, y-14, {type = 14, width = 80, friction = 9999, dynamic = true, fixedRotation = true, miceCollision = false, linearDamping = fallingSpeed})
	addGround(id..'44444445', x+29, y-50, {type = 14, height = 62, width = 25, dynamic = true, friction = 0.3, fixedRotation = true, linearDamping = fallingSpeed})
	addGround(id..'44444446', x-29, y-50, {type = 14, height = 62, width = 25, dynamic = true, friction = 0.3,  fixedRotation = true, linearDamping = fallingSpeed})
	addGround(id..'44444447', x, y-69, {type = 14, height = 23, width = 32, dynamic = true, friction = 0.3,  fixedRotation = true, linearDamping = fallingSpeed})


	addGround(id..'44444450', x-40, y+40, {type = 14, width = 2000, restitution = 1, angle = 90- wind*.5, miceCollision = false})
	addGround(id..'44444451', x-160, y+40, {type = 14, width = 2000, restitution = 1, angle = 90- wind*.5, miceCollision = false})
	addGround(id..'44444452', x-120, y-14, {type = 14, width = 80, friction = 9999, dynamic = true, fixedRotation = true, miceCollision = false, linearDamping = fallingSpeed*1.35})

	TFM.addJoint(id..'1', id..'44444444', id..'44444445', {type = 3})
	TFM.addJoint(id..'2', id..'44444446', id..'44444447', {type = 3})
	TFM.addJoint(id..'3', id..'44444444', id..'44444446', {type = 3})

	id = id + 1
	local box = TFM.addShamanObject(6300, x, y-20)
	local lootImage = addImage('171ebdaa31b.png', '#'..box, -40 -110, -127 -145)

	local auxiliarBox = TFM.addShamanObject(6300, x-120, y-20)

	local lastPos = {}
	local checkExplosion
	checkExplosion = addTimer(function()
		for i, v in next, tfm.get.room.objectList do 
			if i == auxiliarBox then 
				if lastPos[1] == v.x and lastPos[2] == v.y and v.y > 7490 then 
					for i = 1, 10 do 
						TFM.displayParticle(10, v.x+50+math.random(0, 150), v.y-250+math.random(0, 170))
						TFM.displayParticle(3, v.x+80+math.random(0, 75), v.y+23)
					end
					local objs = {}
					local images = {'171ec448e1c.png', '171ec446276.png', '171ec443e74.png', '171ec4424c1.png'}
					for i = 1, 15 do 
						objs[#objs+1] = TFM.addShamanObject(95, v.x+20+math.random(0, 150), v.y-250+math.random(0, 80), math.random(0, 50), math.random(-10, 10))
						addImage(images[math.random(#images)], '#'..objs[#objs], 0, 0)
					end
					addTimer(function()
						for i = 1, #objs do 
							TFM.removeObject(objs[i])
						end
					end, 1000, 1)
					removeImage(lootImage)
					lootImage = addImage('171eb5f183b.png', '#'..box, -45, -122)
					removeTimer(checkExplosion)
				end
				lastPos[1] = v.x
				lastPos[2] = v.y
			end
		end
	end, 500, 0)
end