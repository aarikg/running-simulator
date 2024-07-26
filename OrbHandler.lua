local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local SpawnLocation = Workspace:WaitForChild("SpawnLocation")
local OrbsFolder = ServerStorage.Orbs


function generateRandomPosition()
	local offsetX = math.random(-100, 100)
	local offsetZ = math.random(-100, 100)


	
	local direction = Vector3.new(offsetX, 0, offsetZ).Unit

	return SpawnLocation.Position + direction * math.random(0,1000)
end


function onOrbTouched(hitPart) 
	local character = hitPart.Parent 
	local humanoid = character:FindFirstChild("Humanoid") 

	if humanoid then 
		local player = game.Players:GetPlayerFromCharacter(character) 


		local closestOrb, closestDistance = nil, math.huge
		for _, orb in pairs(workspace:GetChildren()) do 
			if orb.Name == "RedOrb" or orb.Name == "GreenOrb" or orb.Name == "BlueOrb" then
				
				local distance = (orb.Position - hitPart.Position).Magnitude
				if distance < closestDistance then
					closestOrb = orb
					closestDistance = distance
				end
			end
		end

		if closestOrb then 
			print(closestOrb.Claimed.Value)
			if closestOrb.Claimed.Value == true then
				print("the orb has already been claimed")
			else
				closestOrb.Claimed.Value = true
				local points = closestOrb.Points.Value
				print(player.Name .. " earned " .. points .. " points")
				player.leaderstats.Points.Value += points
				player.Character.Humanoid.WalkSpeed = (player.leaderstats.Points.Value)/5

				closestOrb:Destroy() 
			end
			
		end
	end
end



while true do 
	local randomValue = math.random(1, 100) 
	local orbToClone = nil


	if randomValue <= 50 then
		orbToClone = OrbsFolder:WaitForChild("GreenOrb")
	elseif randomValue <= 85 then
		orbToClone = OrbsFolder:WaitForChild("RedOrb")
  
		orbToClone = OrbsFolder:WaitForChild("BlueOrb")
	end

	if orbToClone then 
		local orbClone = orbToClone:Clone()
		orbClone.Position = generateRandomPosition() + Vector3.new(0, 2, 0) 
		orbClone.Anchored = true
		orbClone.Parent = Workspace
		orbClone.Touched:Connect(onOrbTouched) 
	end

	task.wait()
end 
