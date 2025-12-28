print("anti friend enabled")

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
		syn.queue_on_teleport()
	end
end)
