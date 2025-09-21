local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ply = game:GetService("Players")
local runservice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local replicated = game:GetService("ReplicatedStorage")
local eventsFolder = replicated:WaitForChild("RemoteEvents")

local plr = ply.LocalPlayer
local inv = plr:WaitForChild("Inventory")
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local KillAura, bring, bringpos, weapon, speed, jump, speedConnection, infJumpConnection, jumpConnection
local KillAuraDistance, jump = 50
local speed = 16

hum.UseJumpPower = true

local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local function BringItem(Item)
	eventsFolder.RequestStartDraggingItem:FireServer(Item)
	task.wait(0.05)
	Item:PivotTo(bringpos)
	task.wait(0.05)
	eventsFolder.StopDraggingItem:FireServer(Item)
end

task.spawn(function()
	while task.wait() do
		if KillAura then
			for _, weapon in ipairs(inv:GetChildren()) do
				if toolsDamageIDs[weapon.Name] then
					for _, mob in ipairs(workspace.Characters:GetChildren()) do
						if mob:IsA("Model") and mob.PrimaryPart then
							if (mob.PrimaryPart.Position - hrp.Position).Magnitude <= KillAuraDistance then
								pcall(function()
									eventsFolder.ToolDamageObject:InvokeServer(
										mob,
										weapon,
										toolsDamageIDs[weapon.Name],
										hrp.CFrame
									)
								end)
							end
						end
					end
				end
			end
		end
	end
end)	

local Window = WindUI:CreateWindow({
    Title = "Noxware",
    Icon = "moon",
    Author = "by Static",
    Folder = "Noxware",
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house",
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

local BringTab = Window:Tab({
    Title = "Bring",
    Icon = "package",
})

local KillAuraSection = PlayerTab:Section({ 
    Title = "Kill Aura",
    TextXAlignment = "Left",
})

local PlayerSection = MainTab:Section({ 
    Title = "Player",
    TextXAlignment = "Left",
})

local KillAuraToggle = MainTab:Toggle({
    Title = "Enable Kill Aura",
    Callback = function(state)
        KillAura = state
    end
})

local KillAuraDistanceSlider = MainTab:Slider({
    Title = "Distance",
    Step = 1,
    
    Value = {
        Min = 0,
        Max = 500,
        Default = 50,
    },
    Callback = function(value)
        KillAuraDistance = tonumber(value)
    end
})

local SpeedHacksSlider = PlayerTab:Slider({
	Title = "Walk Speed",
	Step = 1,

	Value = {
		Min = 0,
		Max = 100,
		Default = 16,
	},
	Callback = function(value)
		speed = value
	end
})

local SpeedHacksToggle = PlayerTab:Toggle({
    Title = "Enable Speed Hacks",
    Callback = function(state)
        if state then
			speedConnection = runservice.RenderStepped:Connect(function()
				hum.WalkSpeed = speed
			end)
		else
			speedConnection:Disconnect()
			speedConnection = nil
			hum.WalkSpeed = 16
		end
    end
})

local JumpHacksSlider = PlayerTab:Slider({
	Title = "Jump Power",
	Step = 1,

	Value = {
		Min = 0,
		Max = 100,
		Default = 50,
	},
	Callback = function(value)
		jump = value
	end
})

local JumpHacksToggle = PlayerTab:Toggle({
    Title = "Enable Jump Hacks",
    Callback = function(state)
        if state then
			jumpConnection = runservice.RenderStepped:Connect(function()
				hum.JumpPower = jump
			end)
		else
			jumpConnection:Disconnect()
			jumpConnection = nil
			hum.JumpPower = 50
		end
    end
})

local InfJumpToggle = PlayerTab:Toggle({
    Title = "Infinite Jump",
    Callback = function(state)
        if state then
            infJumpConnection = uis.JumpRequest:Connect(function()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        else
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
})

local BringInput = BringTab:Input({
    Title = "Item",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter item name...",
    Callback = function(input) 
        bring = input
    end
})

local BringButton = BringTab:Button({
    Title = "Bring Item",
    Callback = function()
		bringpos = hrp.CFrame
        for _, v in ipairs(workspace.Items:GetChildren()) do
			if v.Name == bring then
				BringItem(v)
			end
		end
	end
})
