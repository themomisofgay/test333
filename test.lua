local Game														= game
local Services													= setmetatable({}, {
	__index = function(Self, Service)
		local Cache												= Game.GetService(Game, Service)

		rawset(Self, Service, Cache)

		return Cache
	end
})

-- // Cleanup
do
	if getgenv()["hiii"] then
		for Index, Connection in next, getgenv()["hiii"] do
			Connection:Disconnect()
		end
	end

	getgenv()["hiii"]							= {}
end
-- // Cleanup End

local Downloads													= {}
local List														= {}
local Modules													= {}
local Config													= ({...})[1]

local Version													= "V2"
local Client													= Services.Players.LocalPlayer
local Camera													= Services.Workspace.CurrentCamera

local FindFirstChild											= Game.FindFirstChild
local WaitForChild												= Game.WaitForChild
local IsLoaded													= Game.IsLoaded

Services.StarterGui:SetCore("SendNotification", {
	Title														= "Fondra",
	Text														= "Loading in PHYSICS\nThis only works on R6 Characters",
})

if not IsLoaded(Game) then Game.Loaded:Wait() end

local function CustomRequire(File, Bool)
	local Custom												= getcustomasset(string.format("Fondra-Physics/Modules/%s", File), true)
	local Object												= (Game.GetObjects(Game, Custom)[1]):Clone()

	if Bool then return Object end

	local Source 												= Object.Source
	local Loadstring 											= loadstring(Source, Object.Name)
	local Original 												= getfenv(Loadstring)

	getfenv(Loadstring).script 									= Object
	getfenv(Loadstring).require									= function(New)
		return CustomRequire(New)
	end

	local Data 													= {pcall(function()
		return Loadstring()
	end)}

	if(Data[1] == false)then
		return nil
	else
		table.remove(Data, 1)

		return unpack(Data)
	end
end

local function CustomRequest(Link, Custom)
	local Success, Result               						= pcall(request, Custom or {
		Url                            							= Link,
		Method                          						= "GET"
	})

	if not Success then return Client:Kick("ISSUE OCCURED") end
	if not typeof(Result) == "table" then return Client:Kick("ISSUE OCCURED") end

	return Result.Body
end

local function DiscordJoin(Code)
	request({
		Url             										= "http://127.0.0.1:6463/rpc?v=1",
		Method              									= "POST",

		Headers = {
			["Content-Type"]									= "application/json",
			["Origin"]      									= "https://discord.com"
		},

		Body 													= Services.HttpService:JSONEncode({
			cmd             									= "INVITE_BROWSER",
			args            									= { code = Code },
			nonce           									= Services.HttpService:GenerateGUID(false)
		}),
	})
end

do
	if not Config.Version then
		if isfolder("Fondra-Physics") then delfolder("Fondra-Physics") end

		Client:Kick("Fondra Physics\nThis is out of date, please get the new loader.\nhiii")

		return DiscordJoin("PfXgy5Nq34")
	end

	if Config.Version ~= Version then
		if isfolder("Fondra-Physics") then delfolder("Fondra-Physics") end

		Client:Kick("Fondra Physics\nThis is out of date, please get the new loader.\nhiii")

		return DiscordJoin("PfXgy5Nq34")
	end

	Downloads													= {
		Modules													= {
			["FX.rbxm"]											= "https://github.com/lncoognito/ROBLOX/raw/main/Boobs/Modules/FX.rbxm",
			["Apply.rbxm"]										= "https://github.com/themomisofgay/test333/raw/main/A2.rbxm",
			["Gender.rbxm"]										= "https://github.com/lncoognito/ROBLOX/raw/main/Boobs/Modules/Gender.rbxm",

			["Spring.rbxm"]										= "https://github.com/lncoognito/ROBLOX/raw/main/Boobs/Modules/Spring.rbxm",
			["Assets.rbxm"]										= "https://github.com/themomisofgay/test333/raw/main/Assets.rbxm",
		},

		["Nipple"]												= "https://github.com/lncoognito/ROBLOX/raw/main/Boobs/Assets/Nipple.png",
	}

	if not isfile("Fondra-Physics/Passed") then
		Services.StarterGui:SetCore("SendNotification", {
			Title 												= "Fondra",
			Text												= "Downloading files, this might take a bit.",
		})
	end

	for Directory, Table in next, Downloads do
		if typeof(Table) ~= "table" then 
			writefile(string.format("Fondra-Physics/%s", Directory), CustomRequest(Table))

			continue
		end

		for Name, Link in next, Table do
			if isfile(string.format("Fondra-Physics/%s/%s", Directory, Name)) then continue end

			writefile(string.format("Fondra-Physics/%s/%s", Directory, Name), CustomRequest(Link))
		end
	end

	writefile("Fondra-Physics/Passed", "Downloaded")
	DiscordJoin("PfXgy5Nq34")
end

do
	Modules.Apply 												= CustomRequire("Apply.rbxm")
	Modules.Gender 												= CustomRequire("Gender.rbxm")

	Modules.FX 													= CustomRequire("FX.rbxm")
	Modules.Spring 												= CustomRequire("Spring.rbxm")
	Modules.Assets 												= CustomRequire("Assets.rbxm")
end

local Apply  													= function(Model, Gender, Mode)
	local Humanoid												= WaitForChild(Model, "Humanoid")
	local HumanoidRootPart										= WaitForChild(Model, "HumanoidRootPart")

	if not Humanoid then return end
	if not HumanoidRootPart then return end

	if FindFirstChild(Model, "CustomRig") then return end
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then return end

	local Torso													= FindFirstChild(Model, "Torso")
	local Head													= FindFirstChild(Model, "Head")
	local RightArm												= FindFirstChild(Model, "Right Arm")
	local LeftArm												= FindFirstChild(Model, "Left Arm")
	local RightLeg												= FindFirstChild(Model, "Right Leg")
	local LeftLeg												= FindFirstChild(Model, "Left Leg")

	if not Torso then return end
	if not Head then return end

	if not RightArm then return end
	if not RightLeg then return end

	if not LeftArm then return end
	if not LeftLeg then return end

	local Player 												= FindFirstChild(Services.Players, Model.Name)
	local Gender												= Gender and Gender or Config.Gender[math.random(1, #Config.Gender)]
	local Mode													= Mode and Mode or Config.Mode[math.random(1, #Config.Mode)]	
	local Result, Body											= Modules.Apply(Model, Gender, Mode, Modules.FX)

	if Config.Physics.Enabled then
		table.insert(List, { 
			Player 												= Player and Player or "NPC",
			Character 											= Model
		})
	end

	local Boobs 												= FindFirstChild(Body, "Boobs Motor")
	local Dick 													= FindFirstChild(Body, "Dick Motor")
	local Ass 													= FindFirstChild(Body, "Ass Motor")

	if Boobs then Body.Boobs["PrimaryBoobs"].Transparency = Config.Debug and 0 or 1 end
	if Ass then Body.Ass["PrimaryCheeks"].Transparency	= Config.Debug and 0 or 1 end
	if Dick then Body.Dick["PrimaryDick"].Transparency = Config.Debug and 0 or 1 end

	if Config.Debug then
		print(Result.Success, Result.Message)
	end

	RightArm.Transparency = 0
	LeftArm.Transparency = 0
end

local Render 													= function(Delta)
	for Index, Data in next, List do
		local Player											= Data.Player
		local Character											= Data.Character
		local Body												= FindFirstChild(Character, "Body")

		if not Body then continue end
		if not Character then table.remove(List, Index) continue end

		local Torso: BasePart									= FindFirstChild(Character, "Torso")
		local Head 												= FindFirstChild(Character, "Head")

		if not Torso then table.remove(List, Index) continue end
		if not Head then table.remove(List, Index) continue end
		if not Torso.Position then table.remove(List, Index) continue end

		local Ass 												= Config.Physics.Ass
		local Dick 												= Config.Physics.Dick
		local Boobs												= Config.Physics.Boobs
		local Distance											= (Torso.Position - Camera.CFrame.Position).Magnitude

		local Information										= Data.Information or {
			Boobs			= {
				Last 											= tick(),
				LastPosition									= Torso.Position,
				LastRotation									= Vector3.new(Torso.CFrame.Rotation:ToOrientation()),
				Spring											= Modules.Spring.new(Vector3.new(0, 0, 0))
			},

			Ass				= {
				Last 											= tick(),
				LastPosition									= Torso.Position,
				LastRotation									= Vector3.new(Torso.CFrame.Rotation:ToOrientation()),
				Spring											= Modules.Spring.new(Vector3.new(0, 0, 0))
			},

			Dick			= {
				Last 											= tick(),
				LastPosition									= Torso.Position,
				LastRotation									= Vector3.new(Torso.CFrame.Rotation:ToOrientation()),
				Spring											= Modules.Spring.new(Vector3.new(0, 0, 0))
			}
		}

		if not Data.Information then
			Information.Boobs.Spring.Target 					= Boobs.Target
			Information.Boobs.Spring.Speed						= Boobs.Speed
			Information.Boobs.Spring.Damper 					= Boobs.Damper

			Information.Ass.Spring.Target 						= Ass.Target
			Information.Ass.Spring.Speed						= Ass.Speed
			Information.Ass.Spring.Damper 						= Ass.Damper

			Information.Dick.Spring.Target 						= Dick.Target
			Information.Dick.Spring.Speed						= Dick.Speed
			Information.Dick.Spring.Damper 						= Dick.Damper
		end

		if not Data.Information then Data.Information = Information end
		if Distance > Config.Physics.Distance then continue end

		if not Player then table.remove(List, Index) continue end
		if not Information then table.remove(List, Index) continue end

		if (tick() - Information.Boobs.Last >= 0.01) and (FindFirstChild(Body, "Boobs Motor")) and (Torso) then
			local rotVel = ((Information.Boobs.LastRotation) - Vector3.new(Torso.CFrame.Rotation:ToOrientation()))
			Information.Boobs.Last								= tick()

			Information.Boobs.Spring:TimeSkip(Delta * 1.5)
			Information.Boobs.Spring:Impulse((Information.Boobs.LastPosition - Torso.Position) + Vector3.new((Information.Boobs.LastRotation - rotVel).Y / 4), 0, 0)

			Body["Boobs Motor"].C0	 							= Body["Boobs Motor"]:GetAttribute("OriginalC0") * CFrame.Angles(math.rad(10 * Information.Boobs.Spring.Velocity.Y), math.rad(5*Information.Boobs.Spring.Velocity.X), 0)
			Information.Boobs.LastPosition						= Torso.Position
			Information.Boobs.LastRotation						= Torso.RotVelocity
		end

		if (tick() - Information.Ass.Last >= 0.01) and (FindFirstChild(Body, "Ass Motor")) and (Torso) then			
			local rotVel = ((Information.Boobs.LastRotation) - Vector3.new(Torso.CFrame.Rotation:ToOrientation()))
			Information.Ass.Last								= tick()

			Information.Ass.Spring:TimeSkip(Delta * 1.5)
			Information.Ass.Spring:Impulse((Information.Ass.LastPosition - Torso.Position) + Vector3.new((Information.Ass.LastRotation - rotVel).Y / 4), 0, 0)

			Body["Ass Motor"].C0	 							= Body["Ass Motor"]:GetAttribute("OriginalC0") * CFrame.Angles(math.rad(10 * Information.Ass.Spring.Velocity.Y), math.rad(5*Information.Ass.Spring.Velocity.X), 0)
			Information.Ass.LastPosition						= Torso.Position
			Information.Ass.LastRotation						= Torso.RotVelocity
		end

		if (tick() - Information.Dick.Last >= 0.01) and (FindFirstChild(Body, "Dick Motor")) and (Torso) then		
			local rotVel = ((Information.Boobs.LastRotation) - Vector3.new(Torso.CFrame.Rotation:ToOrientation()))			
			Information.Dick.Last								= tick()

			Information.Dick.Spring:TimeSkip(Delta * 1.5)
			Information.Dick.Spring:Impulse((Information.Dick.LastPosition - Torso.Position) + Vector3.new((Information.Dick.LastRotation - rotVel).Y / 4), 0, 0)

			Body["Dick Motor"].C0	 							= Body["Dick Motor"]:GetAttribute("OriginalC0") * CFrame.Angles(math.rad(10 * Information.Dick.Spring.Velocity.Y), math.rad(5*Information.Dick.Spring.Velocity.X), 0)
			Information.Dick.LastPosition						= Torso.Position
			Information.Dick.LastRotation						= Torso.RotVelocity
		end

		Data.Information										= Information
	end
end

getgenv()["hiii"]["RunService"]				= Services.RunService.RenderStepped:Connect(Render)

if Game.CreatorId == 5212858 then
	for Index, Object in next, Services.Workspace.Live:GetChildren() do
		local Character 										= Object
		local Name 												= Object.Name
		local Gender 											= Modules.Gender(Character, Character.Name)

		if Config.Gender[1] ~= "Randomized" then Gender = nil; Mode = nil end
		if string.sub(Name, 1, 1) ~= "." then continue end

		getgenv()["hiii"][Character] 			= Character.ChildAdded:Connect(function(New)
			task.wait()

			if New:IsA("Model") then return end
			if New:IsA("Highlight") then return end

			if not FindFirstChild(Character, "Humanoid") then return end
			if not FindFirstChild(Character, "HumanoidRootPart") then return end

			Apply(Character, Gender, Mode)
		end)

		if not FindFirstChild(Character, "Humanoid") then continue end
		if not FindFirstChild(Character, "HumanoidRootPart") then continue end

		Apply(Character, Gender, Mode)
	end

	for Index, Object in next, Services.Workspace.NPCs:GetChildren() do
		local Character 										= Object
		local Name 												= Object.Name
		local Gender, Mode 										= Modules.Gender(Character, Character.Name)

		if Config.Gender[1] ~= "Randomized" then Gender = nil; Mode = nil end

		getgenv()["hiii"][Character] 			= Character.ChildAdded:Connect(function(New)
			task.wait()

			if New:IsA("Model") then return end
			if New:IsA("Highlight") then return end

			if not FindFirstChild(Character, "Humanoid") then return end
			if not FindFirstChild(Character, "HumanoidRootPart") then return end

			Apply(Character, Gender, Mode)
		end)

		if not FindFirstChild(Character, "Humanoid") then continue end
		if not FindFirstChild(Character, "HumanoidRootPart") then continue end

		Apply(Character, Gender, Mode)
	end
end

for Index, Player in next, Services.Players:GetPlayers() do 
	local Player 												= Player
	local Character 											= Player.Character
	local Gender, Mode 											= Character and Modules.Gender(Character, string.split(Character.Humanoid.DisplayName, " ")[1])

	if Config.Gender[1] ~= "Randomized" then Gender = nil; Mode = nil end
	if Character then Apply(Character, Gender, Mode) end

	if getgenv()['hiii'][Player] then
		return
	end

	getgenv()["hiii"][Player] 			= Player.CharacterAdded:Connect(function(New)
		task.wait(1)

		WaitForChild(New, "HumanoidRootPart")
		WaitForChild(New, "Humanoid")

		Gender, Mode 											= Modules.Gender(New, string.split(New.Humanoid.DisplayName, " ")[1])

		Apply(New, Gender, Mode)
	end)
end

getgenv()["hiii"]["PlayerAdded"] 				= Services.Players.PlayerAdded:Connect(function(Player)
	local Player 												= Player
	local Character 											= Player.Character
	local Gender, Mode 											= Character and Modules.Gender(Character, string.split(Character.Humanoid.DisplayName, " ")[1])

	if Config.Gender[1] ~= "Randomized" then Gender = nil; Mode = nil end
	if Character then Apply(Character, Gender, Mode) end

	if typeof(getgenv()['hiii'][Player]) == 'RBXScriptConnection' then
		getgenv()['hiii'][Player]:Disconnect()
	end

	getgenv()["hiii"][Player]				= Player.CharacterAdded:Connect(function(New)
		task.wait(1)

		WaitForChild(New, "HumanoidRootPart")
		WaitForChild(New, "Humanoid")

		Gender, Mode 											= Modules.Gender(New, string.split(New.Humanoid.DisplayName, " ")[1])

		Apply(New, Gender, Mode)
	end)  
end)
