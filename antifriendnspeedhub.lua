print("anti friend and auto speed hub enabled")

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()

local function hop()
	game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end

for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
	if game:GetService("Players").LocalPlayer:IsFriendsWith(p.UserId) then
		hop()
	end
end

game:GetService("Players").PlayerAdded:Connect(function(p)
	if game:GetService("Players").LocalPlayer:IsFriendsWith(p.UserId) then
		hop()
	end
end)

game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.Started then
		queue_on_teleport(loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxithic/scripts/refs/heads/main/antifriend.lua"))())
	end
end)
