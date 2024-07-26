local dataStoreService = game:GetService("DataStoreService")
local pointsDataStore = dataStoreService:GetDataStore("PointsDataStore") 
local Players = game:GetService("Players")

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local points = Instance.new("IntValue", leaderstats)
	points.Name = "Points"

	local pointsData = nil 

	local success, errorMessage = pcall(function()
		pointsData = pointsDataStore:GetAsync(player.UserId)
	end)

	if success then
		points.Value = pointsData or 0 
	else
		print("[-] There was an error while getting data")
		warn(errorMessage)
	end
end)

task.spawn(function()
	while task.wait(300) do
		for _, player in ipairs(Players:GetPlayers()) do
			local success, errorMessage = pcall(function()
				pointsDataStore:SetAsync(player.UserId, player.leaderstats.Points.Value)
			end)

			if success then
				print("[+] [AUTOSAVE] Data successfully saved!")
			else
				print("[-] [AUTOSAVE] There was an error when saving data!")
				warn(errorMessage)
			end
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local success, errorMessage = pcall(function()
		pointsDataStore:SetAsync(player.UserId, player.leaderstats.Points.Value)
	end)

	if success then
		print("[+] Data successfully saved!")
	else
		print("[-] There was an error when saving data!")
		warn(errorMessage)
	end
end)
