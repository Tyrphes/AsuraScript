local plr = game.Players.LocalPlayer
local Running = false
local NeedEat = false
local AutoEatDebounce = tick()
local AutoRun = true
local AutoEat = true
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://13368456722"

if _G.LoopPro then
	_G.LoopPro:Disconnect()
end

local RunAnimation = plr.Character.Humanoid:LoadAnimation(Animation)

local PlayerGui = plr.PlayerGui
local pathfinding = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
		AutoMove(JobBillboard.Adornee.Position)
		print("finished1")
		if i == 1 then
			wait(0.5)
			local JobBillboard = PlayerGui.BillboardGui
		end
	end
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
	AutoMove(Vector3.new(5833.5, -20.3998, 2849.09))
	for i,v in pairs(workspace.Purchases.GYM:GetChildren()) do
		if v.Name == "Roadwork Training" and math.ceil(v.Part.Position.Y) == -23 then
			fireclickdetector(v.ClickDetector)
		end
	end
	plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Roadwork Training"))
	wait(0.5)
	mouse1click()
	wait(0.75)
	firesignal(PlayerGui.RoadworkGain.Frame.Stamina.MouseButton1Up)
	wait(1)
	plr.Character.Humanoid:UnequipTools()
end

function DoRoadwork()
	for i = 1,9 do
		local EndPoint = workspace.Roadworks.Senkaimon[tostring(i)].Position
		AutoMove(EndPoint)
	end
end

function TakeStrikingPower()
	--AutoMove(Vector3.new(-2127.33, 26.875, -1243.24))
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
	if plr.Backpack:FindFirstChild("Protein Shake") then
		plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Protein Shake"))
	elseif plr.Character:FindFirstChild("Chicken") then
		plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Chicken"))
	elseif plr.Character:FindFirstChild("Cheeseburger") then
		plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild("Cheeseburger"))
	end
	wait(0.2)
	mouse1click()
	wait(2)
	plr.Character.Humanoid:UnequipTools()
end

_G.LoopPro = RunService.Heartbeat:Connect(function()
	if AutoRun == true then

		plr.Character.Humanoid.WalkSpeed = 32
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

	if AutoEat == true then
		
		if PlayerGui.Main.HUD.Hunger.Clipping.Size.X.Scale <= 0.5 then
			if plr.Backpack:FindFirstChild("Protein Shake") or plr.Backpack:FindFirstChild("Chicken") or plr.Backpack:FindFirstChild("Cheeseburger") then
				NeedEat = true
			else
				NeedEat = false
			end
		else
			NeedEat = false
		end
	end
end)

while wait(1) do
	if NeedEat == true then
		AutoEatFunc()
	end
	TakeStrikingPower() 
	DoStrikingPower()
end
