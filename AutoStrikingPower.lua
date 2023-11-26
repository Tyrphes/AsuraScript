
local pathfinding = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local Running = false
local NeedEat = false



local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://13368457704"


local plr = game.Players.LocalPlayer
local PlayerGui = plr.PlayerGui


local AutoRun = true



local Settings = {
	AutoEatProtein = false,
	AutoEatChicken = false,
	AutoEatBurger = false,
	AutoStrikingPower = false,
	AutoRoadwork = false,
	AutoDelivery = false,
	Hunger = 50,
	RoadworkType = "Speed",
}

if _G.LoopPro then
	_G.LoopPro:Disconnect()
end

local RunAnimation = plr.Character.Humanoid:LoadAnimation(Animation)


--1606.32, 4.15, -1655.69
function AutoMove(PosEnd)
	local path = pathfinding:CreatePath(
		{
			WaypointSpacing = 2.5,
			AgentHeight = 6;
			AgentRadius = 3.5;

		}
	)
	path:ComputeAsync(plr.Character.HumanoidRootPart.Position,PosEnd)
	local waypoints = path:GetWaypoints()
	for i,v in pairs(waypoints) do

		plr.Character.Humanoid:MoveTo(v.Position)
		if v.Action == Enum.PathWaypointAction.Jump then
			plr.Character.Humanoid.Jump = true
		end
		plr.Character.Humanoid.MoveToFinished:Wait()
	end
	RunAnimation:Stop()
end

function DoJob()

	local JobBillboard = PlayerGui.BillboardGui
	for i = 1,2 do
		AutoRun = true
		AutoMove(JobBillboard.Adornee.Position)
		print("finished1")
		if i == 1 then
			AutoRun = false
			wait(0.5)
			local JobBillboard = PlayerGui.BillboardGui
		end
	end
	AutoRun = false
end


function TakeJob()
	repeat
		ReplicatedStorage.Events.EventCore:FireServer("Job")
		repeat wait() until PlayerGui.Main.LabelJob.Text ~= ""
		if PlayerGui.Main.LabelJob.Text ~= "Deliver the crate!" then
			ReplicatedStorage.Events.EventCore:FireServer("CancelJob")

			repeat wait() until PlayerGui.Main.LabelJob.Text == ""
		end

	until PlayerGui.Main.LabelJob.Text == "Deliver the crate!"
	repeat wait() until PlayerGui:FindFirstChild("BillboardGui")
	print("found job")
end

function TakeRoadwork()
	AutoRun = true
	AutoMove(Vector3.new(5833.5, -20.3998, 2849.09))
	AutoRun = false
	for i,v in pairs(workspace.Purchases.GYM:GetChildren()) do
		if v.Name == "Roadwork Training" and math.ceil(v.Part.Position.Y) == -23 then
			fireclickdetector(v.ClickDetector)
		end
	end
	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Roadwork Training"))
	wait(0.5)
	mouse1click()
	wait(0.75)
	firesignal(PlayerGui.RoadworkGain.Frame[Settings["RoadworkType"]].MouseButton1Up)
	wait(1)
	plr.Character.Humanoid:UnequipTools()
end

function DoRoadwork()
	for i = 1,9 do
		AutoRun = true
		local EndPoint = workspace.Roadworks.Senkaimon[tostring(i)].Position
		AutoMove(EndPoint)
		AutoRun = false
	end
end

function TakeStrikingPower()
	AutoRun = true
	AutoMove(Vector3.new(-2127.33, 26.875, -1243.24))
	AutoRun = false
	local TurnTime = Random.new():NextNumber()
	TweenService:Create(plr.Character.HumanoidRootPart,TweenInfo.new(TurnTime),{CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position) * CFrame.Angles(0,math.rad(90),0)}):Play()
	wait(TurnTime)
	--AutoMove(Vector3.new(-2129.3, 26.875, -1244.43))
	for i,v in pairs(workspace.Purchases.GYM:GetChildren()) do

		if v.Name == "Strike Power Training" and math.ceil(v.Part.Position.Y) == 27 then
			fireclickdetector(v.ClickDetector)
		end
	end

	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Strike Power Training"))
	wait(0.5)
	mouse1click()
	wait(1)
	plr.Character.Humanoid:UnequipTools()
	
end

function DoStrikingPower()
	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Combat"))
	local i = 0
	repeat
		if i < 5 then
			i += 1
			mouse1click()
		else
			i = 0
			mouse2click()
		end
		wait(1.5)
	until not plr.Character:FindFirstChild("Gloves")
end

function AutoBuyProtein()
	AutoMove(1606.32, 4.15, -1655.69)
	for i = 1,5 do
		fireclickdetector(game.Workspace.Purchases["GYM Rats"]["Protein Shake"].ClickDetector)
		wait(0.2)
	end
end

function AutoEatFunc()
	if plr.Backpack:FindFirstChild("Protein Shake") or plr.Backpack:FindFirstChild("Chicken") or plr.Backpack:FindFirstChild("Cheeseburger") then
		if plr.Backpack:FindFirstChild("Protein Shake") then
			if Settings["AutoEatProtein"] == true then
				plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Protein Shake"))
			end
		elseif plr.Backpack:FindFirstChild("Chicken") then
			
			if Settings["AutoEatChicken"] == true then
				print("gothis")
				plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Chicken")) 
			end
		elseif plr.Backpack:FindFirstChild("Cheeseburger")  then
			if Settings["AutoEatBurger"] == true then
				plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Cheeseburger"))
			end
		end
		wait(0.2)
		mouse1click()
		wait(2)
		plr.Character.Humanoid:UnequipTools()
	end
end

_G.LoopPro = RunService.Heartbeat:Connect(function()
	if AutoRun == true then

		plr.Character.Humanoid.WalkSpeed = 45
		if RunAnimation.IsPlaying == false then
			if plr.Character.Humanoid.MoveDirection ~= Vector3.zero or plr.Character.Humanoid.WalkToPoint ~= Vector3.zero then
				if plr.Character.HumanoidRootPart.Velocity.Magnitude > 1 then
					RunAnimation:Play()
				end
			end
		end
		if RunAnimation.IsPlaying == true and plr.Character.Humanoid.MoveDirection == Vector3.zero and plr.Character.Humanoid.WalkToPoint == Vector3.zero then
			RunAnimation:Stop()
		end

		Running = true

	else
		plr.Character.Humanoid.WalkSpeed = 16
		RunAnimation:Stop()
	end

	

		if PlayerGui.Main.HUD.Hunger.Clipping.Size.X.Scale <= Settings["Hunger"]/100 then
			
				NeedEat = true
			
		else
			NeedEat = false
		end
	
end)
spawn(function()
	while wait(1) do
		if Settings["AutoStrikingPower"] then
			
			if NeedEat == true then
				AutoEatFunc()
			end
			TakeStrikingPower() 
			DoStrikingPower()
		end
	end
end)
spawn(function()
	while wait(1) do
		if Settings["AutoDelivery"] then
			if NeedEat == true then
				AutoEatFunc()
			end
			TakeJob()
			DoJob()
			local MyMoney = string.gsub(PlayerGui.Main.HUD.Cash.Text,"%D","")
			if tonumber(MyMoney) >= 250000 then
				AutoRun = true
				AutoMove(Vector3.new(-1773.29, 4.25, -1447.8))
				AutoRun = false
				ReplicatedStorage.Events.Bank:FireServer("Deposit",250000)
			end
		end
	end
end)
spawn(function()
	while wait(1) do
		if Settings["AutoRoadwork"] then
			if NeedEat == true then
				AutoEatFunc()
			end
			TakeRoadwork()
			DoRoadwork()
		end
	end
end)


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tyrphes/AsuraScript/main/UILib.lua"))()

local Wm = library:Watermark(library:GetUsername())

local Notif = library:InitNotifications()


library.title = "Ếch ngu hub"

library:Introduction()
wait(1)
local Init = library:Init(Enum.KeyCode.RightControl)

local Tab1 = Init:NewTab("Auto")

local AutoTrain = Tab1:NewSection("Auto Training")


local AutoStrikingPower = Tab1:NewToggle("Auto Striking Power", false, function(value)

	
	Settings["AutoStrikingPower"] = value
end)

local AutoRoadwork = Tab1:NewToggle("Auto Roadwork", false, function(value)
	Settings["AutoRoadwork"] = value
end)

local RoadType = Tab1:NewSelector("Roadwork stat","Stamina",{"Stamina","Speed"},function(d)
	Settings["RoadworkType"] = d
end)

local AutoEat = Tab1:NewSection("Auto Eat")

local Protein = Tab1:NewToggle("Protein", false, function(value)
	
	Settings["AutoEatProtein"] = value
end)

local Chicken = Tab1:NewToggle("Chicken", false, function(value)

	Settings["AutoEatChicken"] = value
end) 

local Burger = Tab1:NewToggle("Burger", false, function(value)
	
	Settings["AutoEatBurger"] = value
end) 

local Hunger = Tab1:NewSlider("Hunger percent", "", true, "/", {min = 1, max = 100, default = 50}, function(value)
	
	Settings["Hunger"] = value
end)

local AutoJob = Tab1:NewSection("Auto Job")

local AutoDelivery = Tab1:NewToggle("Auto Delivery", false, function(value)
	Settings["AutoDelivery"] = value
end)



