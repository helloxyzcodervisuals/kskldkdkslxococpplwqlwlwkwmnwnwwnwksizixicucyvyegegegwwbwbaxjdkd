repeat
    task.wait()
until game:IsLoaded()

do
    local function isAdonisAC(tab)
        return rawget(tab, "Detected")
            and typeof(rawget(tab, "Detected")) == "function"
            and rawget(tab, "RLocked")
    end

    for _, v in next, getgc(true) do
        if typeof(v) == "table" and isAdonisAC(v) then
            for i, f in next, v do
                if rawequal(i, "Detected") then
                    local old
                    old = hookfunction(f, function(action, info, crash)
                        if rawequal(action, "_") and rawequal(info, "_") and rawequal(crash, false) then
                            return old(action, info, crash)
                        end
                        return task.wait(9e9)
                    end)
                    warn("bypassed")
                    break
                end
            end
        end
    end
end

for _, v in pairs(getgc(true)) do
if type(v) == "table" then
local func = rawget(v, "DTXC1")
if type(func) == "function" then
hookfunction(func, function() return end)
break
end
end
end
print("done")

getgenv().CONFIG = {
    Ragebot = {
        Enabled = false,
        RapidFire = false,
        FireRate = 30,
        Prediction = true,
        PredictionAmount = 0.12,
        TeamCheck = false,
        VisibilityCheck = true,
        FOV = 120,
        ShowFOV = true,
        Wallbang = true,
        Tracers = true,
        TracerColor = Color3.fromRGB(255, 0, 0),
        TracerWidth = 1,
        TracerLifetime = 3,
        ShootRange = 15,
        HitRange = 15,
        HitNotify = true,
        AutoReload = true,
        HitSound = true,
        HitColor = Color3.fromRGB(255, 182, 193),
        UseTargetList = false,
        UseWhitelist = false,
        HitNotifyDuration = 5,
        LowHealthCheck = false,
        SelectedHitSound = "skeet"
    },
    Misc = {
        SpeedEnabled = false,
        SpeedValue = 50,
        JumpPowerEnabled = false,
        JumpPowerValue = 100,
        LoopFOVEnabled = false,
        HideHeadEnabled = false,
        InfStaminaEnabled = false,
        NoFallDmgEnabled = false,
        SpeedConnection = nil,
        FOVConnection = nil,
        JumpPowerConnection = nil,
        NoFallHook = nil,
        InfStaminaHook = nil
    },
    Visualize = {
        ESP = {
            Enabled = false,
            BoxColor = Color3.fromRGB(78, 150, 50),
            OutlineColor = Color3.fromRGB(78, 150, 50),
            TextColor = Color3.fromRGB(255, 255, 255),
            MaxDistance = 1000
        },
        ForcefieldColor = Color3.fromRGB(255, 255, 255),
        ForcefieldTransparency = 0.5,
        LocalForcefieldEnabled = false,
        ArrowEnabled = false,
        ArrowColor = Color3.fromRGB(255, 255, 255),
        ArrowDistance = 80,
        ArrowSize = 16,
        ArrowThickness = 1,
        ArrowAA = false
    }
}

getgenv().Lists = {
    TargetList = {},
    Whitelist = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/source.lua", true))()

local main = library:Load({Name = "SKCC.LUA", Theme = "Dark", SizeX = 540, SizeY = 600, ColorOverrides = {}})

local rageTab = main:Tab("Rage")
local rageColumn1 = rageTab:Section({Name = "Ragebot", column = 1})
local rageColumn2 = rageTab:Section({Name = "Targeting", column = 1})
local rageColumn3 = rageTab:Section({Name = "Aim Settings", column = 2})
local rageColumn4 = rageTab:Section({Name = "Tracers", column = 2})
local rageColumn5 = rageTab:Section({Name = "Colors", column = 2})
local rageColumn6 = rageTab:Section({Name = "Notifications", column = 2})

rageColumn1:Toggle({Name = "Enable", Flag = "rage_enable", callback = function(bool)
    getgenv().CONFIG.Ragebot.Enabled = bool
end})

rageColumn1:Toggle({Name = "Rapid Fire", Flag = "rage_rapidfire", callback = function(bool)
    getgenv().CONFIG.Ragebot.RapidFire = bool
end})

rageColumn1:Toggle({Name = "Hit Sound", Flag = "rage_hitsound", callback = function(bool)
    getgenv().CONFIG.Ragebot.HitSound = bool
end})

rageColumn1:Toggle({Name = "Auto Reload", Flag = "rage_autoreload", callback = function(bool)
    getgenv().CONFIG.Ragebot.AutoReload = bool
end})

rageColumn1:Slider({Name = "Fire Rate", Min = 1, Max = 1000, Default = 30, Flag = "rage_firerate", callback = function(value)
    getgenv().CONFIG.Ragebot.FireRate = value
end})

rageColumn1:Slider({Name = "Shoot Range", Min = 1, Max = 30, Default = 15, Flag = "rage_shootrange", callback = function(value)
    getgenv().CONFIG.Ragebot.ShootRange = value
end})

rageColumn1:Slider({Name = "Hit Range", Min = 1, Max = 30, Default = 15, Flag = "rage_hitrange", callback = function(value)
    getgenv().CONFIG.Ragebot.HitRange = value
end})

rageColumn1:Dropdown({Name = "Hit Sound", Default = "skeet", Content = {"skeet", "xp level", "bell"}, Flag = "rage_hitsoundlist", callback = function(option)
    getgenv().CONFIG.Ragebot.SelectedHitSound = option
end})

rageColumn2:Toggle({Name = "Team Check", Flag = "rage_teamcheck", callback = function(bool)
    getgenv().CONFIG.Ragebot.TeamCheck = bool
end})

rageColumn2:Toggle({Name = "Visibility Check", Flag = "rage_visibilitycheck", callback = function(bool)
    getgenv().CONFIG.Ragebot.VisibilityCheck = bool
end})

rageColumn2:Toggle({Name = "Wallbang", Flag = "rage_wallbang", callback = function(bool)
    getgenv().CONFIG.Ragebot.Wallbang = bool
end})

rageColumn2:Slider({Name = "FOV", Min = 10, Max = 360, Default = 120, Flag = "rage_fov", callback = function(value)
    getgenv().CONFIG.Ragebot.FOV = value
end})

rageColumn2:Toggle({Name = "Show FOV", Flag = "rage_showfov", callback = function(bool)
    getgenv().CONFIG.Ragebot.ShowFOV = bool
end})

rageColumn2:Toggle({Name = "Downed Check", Flag = "rage_downcheck", callback = function(bool)
    getgenv().CONFIG.Ragebot.LowHealthCheck = bool
end})

rageColumn3:Toggle({Name = "Prediction", Flag = "rage_prediction", callback = function(bool)
    getgenv().CONFIG.Ragebot.Prediction = bool
end})

rageColumn3:Slider({Name = "Prediction Amount", Min = 0.05, Max = 0.3, Default = 0.12, Flag = "rage_predictionamount", callback = function(value)
    getgenv().CONFIG.Ragebot.PredictionAmount = value
end})

rageColumn4:Toggle({Name = "Tracers", Flag = "rage_tracers", callback = function(bool)
    getgenv().CONFIG.Ragebot.Tracers = bool
end})

rageColumn4:Slider({Name = "Tracer Width", Min = 0.1, Max = 5, Default = 1, Flag = "rage_tracerwidth", callback = function(value)
    getgenv().CONFIG.Ragebot.TracerWidth = value
end})

rageColumn4:Slider({Name = "Tracer Lifetime", Min = 0.5, Max = 10, Default = 3, Flag = "rage_tracerlife", callback = function(value)
    getgenv().CONFIG.Ragebot.TracerLifetime = value
end})

rageColumn5:ColorPicker({Name = "Tracer Color", Default = Color3.fromRGB(255, 0, 0), Flag = "rage_tracercolor", callback = function(color)
    getgenv().CONFIG.Ragebot.TracerColor = color
end})

rageColumn5:ColorPicker({Name = "Hit Notification Color", Default = Color3.fromRGB(255, 182, 193), Flag = "rage_hitcolor", callback = function(color)
    getgenv().CONFIG.Ragebot.HitColor = color
end})

rageColumn6:Toggle({Name = "Hit Notify", Flag = "rage_hitnotify", callback = function(bool)
    getgenv().CONFIG.Ragebot.HitNotify = bool
end})

rageColumn6:Slider({Name = "Hit Notify Duration", Min = 1, Max = 10, Default = 5, Flag = "rage_hitduration", callback = function(value)
    getgenv().CONFIG.Ragebot.HitNotifyDuration = value
end})

local listsTab = main:Tab("Lists")
local listsColumn1 = listsTab:Section({Name = "Target List", column = 1})
local listsColumn2 = listsTab:Section({Name = "Whitelist", column = 2})
local listsColumn3 = listsTab:Section({Name = "Controls", column = 1})

local playerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

local targetListDropdown = listsColumn1:Dropdown({Name = "Add to Target List", Default = "", Content = playerNames, MultiChoice = true, Flag = "targetlist_dropdown", callback = function(selected)
    if type(selected) == "table" then
        getgenv().Lists.TargetList = selected
    elseif selected and selected ~= "" then
        if not table.find(getgenv().Lists.TargetList, selected) then
            table.insert(getgenv().Lists.TargetList, selected)
        end
    end
end})

local whitelistDropdown = listsColumn2:Dropdown({Name = "Add to Whitelist", Default = "", Content = playerNames, MultiChoice = true, Flag = "whitelist_dropdown", callback = function(selected)
    if type(selected) == "table" then
        getgenv().Lists.Whitelist = selected
    elseif selected and selected ~= "" then
        if not table.find(getgenv().Lists.Whitelist, selected) then
            table.insert(getgenv().Lists.Whitelist, selected)
        end
    end
end})

listsColumn1:Button({Name = "Clear Target List", Callback = function()
    getgenv().Lists.TargetList = {}
    targetListDropdown:Set("")
end})

listsColumn2:Button({Name = "Clear Whitelist", Callback = function()
    getgenv().Lists.Whitelist = {}
    whitelistDropdown:Set("")
end})

listsColumn3:Toggle({Name = "Use Target List", Flag = "lists_usetargetlist", callback = function(bool)
    getgenv().CONFIG.Ragebot.UseTargetList = bool
end})

listsColumn3:Toggle({Name = "Use Whitelist", Flag = "lists_usewhitelist", callback = function(bool)
    getgenv().CONFIG.Ragebot.UseWhitelist = bool
end})

Players.PlayerAdded:Connect(function(player)
    table.insert(playerNames, player.Name)
    targetListDropdown:Refresh(playerNames)
    whitelistDropdown:Refresh(playerNames)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerNames) do
        if name == player.Name then
            table.remove(playerNames, i)
            break
        end
    end
    targetListDropdown:Refresh(playerNames)
    whitelistDropdown:Refresh(playerNames)
end)

local miscTab = main:Tab("Misc")
local miscColumn1 = miscTab:Section({Name = "Movement", column = 1})
local miscColumn2 = miscTab:Section({Name = "Visual", column = 1})
local miscColumn3 = miscTab:Section({Name = "Other", column = 2})
local miscColumn4 = miscTab:Section({Name = "Chat", column = 2})
local miscColumn5 = miscTab:Section({Name = "Safe ESP", column = 1})

local function enableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    getgenv().CONFIG.Misc.SpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end

        humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
    end)
end

local function disableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end

local function enableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
    
    getgenv().CONFIG.Misc.JumpPowerConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not getgenv().CONFIG.Misc.JumpPowerEnabled then return end
        if not game.Players.LocalPlayer.Character then return end
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
        end
    end)
end

local function disableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
end

local function enableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
    
    getgenv().CONFIG.Misc.FOVConnection = game:GetService("RunService").RenderStepped:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
end

local runserviceConnection = nil
local originalMotors = {}
local toolTransparencies = {}

local function getCurrentTool()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    
    return nil
end

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    
    local char = game.Players.LocalPlayer.Character
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    
    if not torso then return end
    
    local tool = getCurrentTool()
    if not tool then return end
    
    local values = tool:FindFirstChild("Values")
    if not values then return end
    
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    
    originalMotors = {}
    for _, motor in pairs(torso:GetChildren()) do
        if motor:IsA("Motor6D") then
            originalMotors[motor] = {
                C0 = motor.C0,
                C1 = motor.C1
            }
        end
    end
    
    toolTransparencies = {}
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            toolTransparencies[part] = part.Transparency
            part.Transparency = 1
        end
    end
    
    if runserviceConnection then
        runserviceConnection:Disconnect()
    end
    
    runserviceConnection = game:GetService("RunService").RenderStepped:Connect(function()
        for motor, original in pairs(originalMotors) do
            if motor and motor.Parent then
                motor.C0 = original.C0
                motor.C1 = original.C1
            end
        end
    end)
end

local function showHeadFE()
    if runserviceConnection then
        runserviceConnection:Disconnect()
        runserviceConnection = nil
    end
    
    for part, transparency in pairs(toolTransparencies) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    toolTransparencies = {}
    
    originalMotors = {}
end

local function enableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
    getgenv().CONFIG.Misc.NoFallHook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = { ... }
        if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
            args[2] = 0
            args[3] = 0
        end
        return getgenv().CONFIG.Misc.NoFallHook(self, unpack(args))
    end)
end

local function disableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
end

local function enableInfStamina()
    local module
    for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name == "XIIX" then module = v break end
    end
    if module then
        module = require(module)
        local ac = module["XIIX"]
        local glob = getfenv(ac)["_G"]
        local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
        if stamina ~= nil then
            getgenv().CONFIG.Misc.InfStaminaHook = hookfunction(stamina, function() return 100, 100 end)
        end
    end
end

local function disableInfStamina()
    if getgenv().CONFIG.Misc.InfStaminaHook then getgenv().CONFIG.Misc.InfStaminaHook = nil end
end

miscColumn1:Toggle({Name = "Speed", Flag = "misc_speed", callback = function(bool)
    getgenv().CONFIG.Misc.SpeedEnabled = bool
    if bool then
        enableSpeed()
    else
        disableSpeed()
    end
end})

miscColumn1:Slider({Name = "Speed Value", Min = 10, Max = 200, Default = 50, Flag = "misc_speedvalue", callback = function(value)
    getgenv().CONFIG.Misc.SpeedValue = value
end})

miscColumn1:Toggle({Name = "Jump Power", Flag = "misc_jumpower", callback = function(bool)
    getgenv().CONFIG.Misc.JumpPowerEnabled = bool
    if bool then
        enableJumpPower()
    else
        disableJumpPower()
    end
end})

miscColumn1:Slider({Name = "Jump Power Value", Min = 50, Max = 300, Default = 100, Flag = "misc_jumpvalue", callback = function(value)
    getgenv().CONFIG.Misc.JumpPowerValue = value
end})

miscColumn1:Toggle({Name = "Fly", Flag = "misc_fly", callback = function(bool)
    getgenv().CONFIG.Misc.FlyEnabled = bool
    QuickUIText.Text = bool and "FLY ON" or "FLY OFF"
    QuickUIText.TextColor3 = bool and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if bool then 
        StartFlying()
    end
end})

miscColumn1:Slider({Name = "Fly Speed", Min = 10, Max = 200, Default = 50, Flag = "misc_flyspeed", callback = function(value)
    getgenv().CONFIG.Misc.FlySpeed = value
end})

miscColumn2:Toggle({Name = "Loop FOV", Flag = "misc_loopfov", callback = function(bool)
    getgenv().CONFIG.Misc.LoopFOVEnabled = bool
    if bool then
        enableLoopFOV()
    else
        disableLoopFOV()
    end
end})

miscColumn2:Toggle({Name = "Hide Head", Flag = "misc_hidehead", callback = function(bool)
    getgenv().CONFIG.Misc.HideHeadEnabled = bool
    if bool then
        hideHeadFE()
    else
        showHeadFE()
    end
end})

miscColumn3:Toggle({Name = "Inf Stamina", Flag = "misc_infstamina", callback = function(bool)
    getgenv().CONFIG.Misc.InfStaminaEnabled = bool
    if bool then
        enableInfStamina()
    else
        disableInfStamina()
    end
end})

miscColumn3:Toggle({Name = "No Fall Damage", Flag = "misc_nofall", callback = function(bool)
    getgenv().CONFIG.Misc.NoFallDmgEnabled = bool
    if bool then
        enableNoFallDmg()
    else
        disableNoFallDmg()
    end
end})

miscColumn3:Toggle({Name = "Instant Prompt", Flag = "misc_instantprompt", callback = function(bool)
    getgenv().CONFIG.Misc.InstantPrompt = bool
    InstantPrompt_Enabled = bool
    
    if bool then
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        
        game.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                task.wait()
                obj.HoldDuration = 0
            end
        end)
    else
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 1
            end
        end
    end
end})

miscColumn3:Toggle({Name = "Auto Door", Flag = "misc_autodoor", callback = function(bool)
    getgenv().CONFIG.Misc.AutoDoor = bool
    AutoDoor_Enabled = bool
    
    if bool then
        if doorConnection then
            doorConnection:Disconnect()
        end
        
        doorConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local charRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not charRoot then return end
            
            local Map = workspace:FindFirstChild("Map")
            if not Map then return end
            local Doors = Map:FindFirstChild("Doors")
            if not Doors then return end
            
            local closestDoor = nil
            local closestDistance = 15
            
            for _, door in pairs(Doors:GetChildren()) do
                local knob = door:FindFirstChild("Knob1") or door:FindFirstChild("Knob2")
                if knob then
                    local distance = (knob.Position - charRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestDoor = door
                    end
                end
            end
            
            if closestDoor then
                local knob = closestDoor:FindFirstChild("Knob1") or closestDoor:FindFirstChild("Knob2")
                local events = closestDoor:FindFirstChild("Events")
                local toggleEvent = events and events:FindFirstChild("Toggle")
                
                if knob and toggleEvent then
                    local args = {"Open", knob}
                    toggleEvent:FireServer(unpack(args))
                end
            end
        end)
    else
        if doorConnection then
            doorConnection:Disconnect()
            doorConnection = nil
        end
    end
end})

miscColumn4:Toggle({Name = "Enable Chat", Flag = "misc_enablechat", callback = function(bool)
    if game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration") then
        game:GetService("TextChatService").ChatWindowConfiguration.Enabled = bool
    end
end})

local NoFailLockpick_Enabled = false
local lockpickAddedConnection = nil

miscColumn3:Toggle({Name = "No Fail Lockpick", Flag = "misc_nofaillockpick", callback = function(bool)
    _G.LockpickEnabled = bool
    NoFailLockpick_Enabled = bool
    
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    if bool then
        local function lockpick(gui)
            for _, a in pairs(gui:GetDescendants()) do
                if a:IsA("ImageLabel") and a.Name == "Bar" and a.Parent.Name ~= "Attempts" then
                    local oldsize = a.Size
                    RunService.RenderStepped:Connect(function()
                        if _G.LockpickEnabled then
                            a.Size = UDim2.new(0, 280, 0, 280)
                        else
                            a.Size = oldsize
                        end
                    end)
                end
            end
        end
        
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
        end
        
        lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end)
        
        for _, child in pairs(PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end
    else
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
            lockpickAddedConnection = nil
        end
    end
end})

local SafeESP = {
    Enabled = false,
    Safes = {},
    Visuals = {}
}

function SafeESP:AddSafeESP(model)
    if not model or not model.Parent then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = model
    highlight.Parent = model
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SafeESP"
    billboard.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextSize = 14
    textLabel.FontFace = Font.new("rbxassetid://12187371840")
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Text = model.Name
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextSize = 12
    distanceLabel.FontFace = Font.new("rbxassetid://12187371840")
    distanceLabel.TextStrokeTransparency = 0.5
    
    textLabel.Parent = billboard
    distanceLabel.Parent = billboard
    billboard.Parent = model
    
    SafeESP.Safes[model] = true
    SafeESP.Visuals[model] = {highlight = highlight, billboard = billboard, textLabel = textLabel, distanceLabel = distanceLabel}
    
    RunService.Heartbeat:Connect(function()
        if not SafeESP.Enabled or not model.Parent then
            highlight:Destroy()
            billboard:Destroy()
            SafeESP.Safes[model] = nil
            SafeESP.Visuals[model] = nil
            return
        end
        
        local localPlayer = game:GetService("Players").LocalPlayer
        if localPlayer and localPlayer.Character then
            local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and billboard.Adornee then
                local distance = (humanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                distanceLabel.Text = string.format("%d studs", math.floor(distance))
                billboard.Enabled = distance <= 100
            end
        end
    end)
end

function SafeESP:ScanWorkspace()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                if not SafeESP.Safes[item] then
                    SafeESP:AddSafeESP(item)
                end
            end
        end
    end
end

function SafeESP:Enable(value)
    SafeESP.Enabled = value
    
    if value then
        SafeESP:ScanWorkspace()
        
        workspace.DescendantAdded:Connect(function(item)
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                    task.wait(0.1)
                    SafeESP:AddSafeESP(item)
                end
            end
        end)
    else
        for model, visuals in pairs(SafeESP.Visuals) do
            if visuals.highlight then visuals.highlight:Destroy() end
            if visuals.billboard then visuals.billboard:Destroy() end
        end
        SafeESP.Safes = {}
        SafeESP.Visuals = {}
    end
end

miscColumn5:Toggle({Name = "Enable Safe ESP", Flag = "misc_safeesp", callback = function(bool)
    SafeESP:Enable(bool)
end})

miscColumn5:ColorPicker({Name = "Safe Color", Default = Color3.fromRGB(255, 215, 0), Flag = "misc_safecolor", callback = function(color)
    for model, visuals in pairs(SafeESP.Visuals) do
        if visuals.highlight then
            visuals.highlight.FillColor = color
        end
        if visuals.textLabel then
            visuals.textLabel.TextColor3 = color
        end
    end
end})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local FlyConnection = nil
local FlyEnabled = false
local FlySpeed = 50

local QuickUIFrame = Instance.new("Frame")
QuickUIFrame.Name = "QuickUIFrame"
QuickUIFrame.Size = UDim2.new(0, 80, 0, 30)
QuickUIFrame.Position = UDim2.new(0, 10, 0, 50)
QuickUIFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
QuickUIFrame.BackgroundTransparency = 0.5
QuickUIFrame.BorderSizePixel = 0

local QuickUIText = Instance.new("TextButton")
QuickUIText.Name = "QuickUIText"
QuickUIText.Size = UDim2.new(1, 0, 1, 0)
QuickUIText.BackgroundTransparency = 1
QuickUIText.Text = "FLY OFF"
QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
QuickUIText.Font = Enum.Font.GothamBold
QuickUIText.TextSize = 12
QuickUIText.Parent = QuickUIFrame

local function StartFlying()
    local Char = Player.Character
    if not Char then return end
    
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Hum or not Root then return end
    
    local RagdollEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL")
    RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
    
    for _, child in ipairs(Char:GetDescendants()) do
        if child:IsA("Motor6D") then
            child.Enabled = false
        end
    end
    
    Hum.PlatformStand = true
    Hum:ChangeState(Enum.HumanoidStateType.Freefall)
    
    local Head = Char:FindFirstChild("Head")
    
    local flyMotors = {}
    for _, part in ipairs(Char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= Root then
            local motor = Instance.new("Motor6D")
            motor.Name = "FlyMotor"
            motor.Part0 = Root
            motor.Part1 = part
            motor.C1 = CFrame.new()
            motor.C0 = Root.CFrame:ToObjectSpace(part.CFrame)
            motor.Parent = part
            table.insert(flyMotors, motor)
        end
    end
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled then
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            Hum.PlatformStand = false
            Root.Velocity = Vector3.new(0, 0, 0)
            Hum:ChangeState(Enum.HumanoidStateType.Running)
            RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), true)
            
            for _, motor in ipairs(flyMotors) do
                motor:Destroy()
            end
            
            for _, child in ipairs(Char:GetDescendants()) do
                if child:IsA("Motor6D") and child.Name ~= "FlyMotor" then
                    child.Enabled = true
                end
            end
            
            return
        end
        
        if Head then
            for _, sound in ipairs(Head:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound:Destroy()
                end
            end
        end
        
        local Cam = workspace.CurrentCamera
        if not Cam then return end
        
        local cameraLook = Cam.CFrame.LookVector
        local IsMoving = Hum.MoveDirection.Magnitude > 0
        
        local targetLook = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z)
        if targetLook.Magnitude > 0 then
            targetLook = targetLook.Unit
            Root.CFrame = CFrame.new(Root.Position, Root.Position + targetLook)
        end
        
        if IsMoving then
            local moveVector = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z).Unit
            Root.Velocity = moveVector * FlySpeed
            RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
        else
            Root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

QuickUIText.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        QuickUIText.Text = "FLY ON"
        QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
        StartFlying()
    else
        QuickUIText.Text = "FLY OFF"
        QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

QuickUIFrame.Parent = game:GetService("CoreGui"):FindFirstChild("skeet") or game:GetService("CoreGui")

local visualizeTab = main:Tab("Visualize")
local vizColumn1 = visualizeTab:Section({Name = "ESP Settings", column = 1})
local vizColumn2 = visualizeTab:Section({Name = "Fade Settings", column = 1})
local vizColumn3 = visualizeTab:Section({Name = "Drawing Settings", column = 2})
local vizColumn4 = visualizeTab:Section({Name = "Name Settings", column = 2})
local vizColumn5 = visualizeTab:Section({Name = "Box Settings", column = 2})
local vizColumn6 = visualizeTab:Section({Name = "Forcefield", column = 1})
local vizColumn7 = visualizeTab:Section({Name = "Arrow Indicators", column = 2})
local vizColumn8 = visualizeTab:Section({Name = "Rich World", column = 1})

local ESP_CONFIG = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 500,
    FontSize = 13,
    FadeOut = {
        OnDistance = true,
        OnDeath = true,
        OnLeave = true,
    },
    Options = { 
        Teamcheck = true, 
        TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, 
        FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = true, 
        HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled = true,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 80,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 80,
            VisibleCheck = true,
        },
        Names = {
            Enabled = true,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = false,
        },
        Distances = {
            Enabled = true, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = true, 
            WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = true,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), 
            GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = true,  
            HealthText = true, 
            Lerp = true, 
            HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 3,
            Gradient = true, 
            GradientRGB1 = Color3.fromRGB(200, 0, 0), 
            GradientRGB2 = Color3.fromRGB(60, 60, 125), 
            GradientRGB3 = Color3.fromRGB(119, 120, 255), 
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 200,
            Gradient = true, 
            GradientRGB1 = Color3.fromRGB(119, 120, 255), 
            GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, 
            GradientFillRGB1 = Color3.fromRGB(119, 120, 255), 
            GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = true,
                Transparency = 0.65,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        }
    }
}

vizColumn1:Toggle({Name = "Enable ESP", Flag = "esp_enabled", callback = function(bool)
    ESP_CONFIG.Enabled = bool
end})

vizColumn1:Toggle({Name = "Team Check", Flag = "esp_teamcheck", callback = function(bool)
    ESP_CONFIG.TeamCheck = bool
end})

vizColumn1:Toggle({Name = "Teamcheck", Flag = "esp_teamcheck_option", callback = function(bool)
    ESP_CONFIG.Options.Teamcheck = bool
end})

vizColumn1:Toggle({Name = "Friendcheck", Flag = "esp_friendcheck", callback = function(bool)
    ESP_CONFIG.Options.Friendcheck = bool
end})

vizColumn1:Toggle({Name = "Highlight", Flag = "esp_highlight", callback = function(bool)
    ESP_CONFIG.Options.Highlight = bool
end})

vizColumn1:Slider({Name = "Max Distance", Min = 100, Max = 2000, Default = 500, Flag = "esp_maxdistance", callback = function(value)
    ESP_CONFIG.MaxDistance = value
end})

vizColumn1:Slider({Name = "Font Size", Min = 8, Max = 20, Default = 13, Flag = "esp_fontsize", callback = function(value)
    ESP_CONFIG.FontSize = value
end})

vizColumn2:Toggle({Name = "Fade on Distance", Flag = "esp_fade_distance", callback = function(bool)
    ESP_CONFIG.FadeOut.OnDistance = bool
end})

vizColumn2:Toggle({Name = "Fade on Death", Flag = "esp_fade_death", callback = function(bool)
    ESP_CONFIG.FadeOut.OnDeath = bool
end})

vizColumn2:Toggle({Name = "Fade on Leave", Flag = "esp_fade_leave", callback = function(bool)
    ESP_CONFIG.FadeOut.OnLeave = bool
end})

vizColumn3:Toggle({Name = "Chams Enabled", Flag = "chams_enabled", callback = function(bool)
    ESP_CONFIG.Drawing.Chams.Enabled = bool
end})

vizColumn3:Toggle({Name = "Thermal Chams", Flag = "chams_thermal", callback = function(bool)
    ESP_CONFIG.Drawing.Chams.Thermal = bool
end})

vizColumn3:Toggle({Name = "Visible Check", Flag = "chams_visible", callback = function(bool)
    ESP_CONFIG.Drawing.Chams.VisibleCheck = bool
end})

vizColumn3:ColorPicker({Name = "Chams Fill Color", Default = Color3.fromRGB(119, 120, 255), Flag = "chams_fill", callback = function(color)
    ESP_CONFIG.Drawing.Chams.FillRGB = color
end})

vizColumn3:ColorPicker({Name = "Chams Outline Color", Default = Color3.fromRGB(119, 120, 255), Flag = "chams_outline", callback = function(color)
    ESP_CONFIG.Drawing.Chams.OutlineRGB = color
end})

vizColumn3:Slider({Name = "Chams Fill Transparency", Min = 0, Max = 100, Default = 80, Flag = "chams_fill_trans", callback = function(value)
    ESP_CONFIG.Drawing.Chams.Fill_Transparency = value
end})

vizColumn3:Slider({Name = "Chams Outline Transparency", Min = 0, Max = 100, Default = 80, Flag = "chams_outline_trans", callback = function(value)
    ESP_CONFIG.Drawing.Chams.Outline_Transparency = value
end})

vizColumn4:Toggle({Name = "Names Enabled", Flag = "names_enabled", callback = function(bool)
    ESP_CONFIG.Drawing.Names.Enabled = bool
end})

vizColumn4:ColorPicker({Name = "Name Color", Default = Color3.fromRGB(255, 255, 255), Flag = "names_color", callback = function(color)
    ESP_CONFIG.Drawing.Names.RGB = color
end})

local bodyPartsForcefield = {}
local originalMaterials = {}
local originalColors = {}
local originalTransparency = {}

local function applyForcefieldToBodyParts()
    if LocalPlayer and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local bodyParts = {
            "Head",
            "Left Arm",
            "Left Leg",
            "Right Arm",
            "Right Leg",
            "Torso",
            "UpperTorso",
            "LowerTorso",
            "LeftUpperArm",
            "LeftLowerArm",
            "RightUpperArm",
            "RightLowerArm",
            "LeftUpperLeg",
            "LeftLowerLeg",
            "RightUpperLeg",
            "RightLowerLeg"
        }
        
        for _, partName in pairs(bodyParts) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                if not originalMaterials[part] then
                    originalMaterials[part] = part.Material
                    originalColors[part] = part.Color
                    originalTransparency[part] = part.Transparency
                end
                
                part.Material = Enum.Material.ForceField
                part.Color = getgenv().CONFIG.Visualize.ForcefieldColor
                part.Transparency = getgenv().CONFIG.Visualize.ForcefieldTransparency
                
                bodyPartsForcefield[part] = true
            end
        end
    end
end

local function removeForcefieldFromBodyParts()
    if LocalPlayer and LocalPlayer.Character then
        local char = LocalPlayer.Character
        
        for part, _ in pairs(bodyPartsForcefield) do
            if part and part.Parent == char then
                if originalMaterials[part] then
                    part.Material = originalMaterials[part]
                else
                    part.Material = Enum.Material.Plastic
                end
                
                if originalColors[part] then
                    part.Color = originalColors[part]
                end
                
                if originalTransparency[part] then
                    part.Transparency = originalTransparency[part]
                else
                    part.Transparency = 0
                end
            end
        end
        
        bodyPartsForcefield = {}
        originalMaterials = {}
        originalColors = {}
        originalTransparency = {}
    end
end

vizColumn6:Toggle({Name = "Enable Forcefield", Flag = "visualize_forcefield_enabled", callback = function(bool)
    getgenv().CONFIG.Visualize.LocalForcefieldEnabled = bool
    if bool then
        applyForcefieldToBodyParts()
    else
        removeForcefieldFromBodyParts()
    end
end})

vizColumn6:Slider({Name = "Forcefield Transparency", Min = 0, Max = 1, Default = 0.5, Flag = "visualize_forcefield_transparency", callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldTransparency = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

vizColumn6:ColorPicker({Name = "Forcefield Color", Default = Color3.fromRGB(255, 255, 255), Flag = "visualize_forcefield_color", callback = function(color)
    getgenv().CONFIG.Visualize.ForcefieldColor = color
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

local Arrow = {
    Enabled = false,
    DistFromCenter = 80,
    TriangleHeight = 16,
    TriangleWidth = 16,
    TriangleTransparency = 0,
    TriangleThickness = 1,
    TriangleColor = Color3.fromRGB(255, 255, 255),
    AntiAliasing = false,
    Players = game:service("Players"),
    Camera = workspace.CurrentCamera,
    RS = game:service("RunService"),
    LocalPlayer = game:service("Players").LocalPlayer,
    ArrowConnections = {},
    ArrowDrawings = {}
}

function Arrow:GetRelative(pos, char)
    if not char then return Vector2.new(0,0) end
    local rootP = char.PrimaryPart.Position
    local camP = Arrow.Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)
    return Vector2.new(relative.X, relative.Z)
end

function Arrow:RelativeToCenter(v)
    return Arrow.Camera.ViewportSize/2 - v
end

function Arrow:RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)
    return Vector2.new(x, y)
end

function Arrow:AntiA(v)
    if not Arrow.AntiAliasing then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

function Arrow:DrawTriangleLines(color)
    local line1 = Drawing.new("Line")
    local line2 = Drawing.new("Line")
    local line3 = Drawing.new("Line")
    line1.Visible = false
    line2.Visible = false
    line3.Visible = false
    line1.Color = color
    line2.Color = color
    line3.Color = color
    line1.Thickness = Arrow.TriangleThickness
    line2.Thickness = Arrow.TriangleThickness
    line3.Thickness = Arrow.TriangleThickness
    line1.Transparency = 1-Arrow.TriangleTransparency
    line2.Transparency = 1-Arrow.TriangleTransparency
    line3.Transparency = 1-Arrow.TriangleTransparency
    return {line1, line2, line3}
end

function Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
    lines[1].From = pointA
    lines[1].To = pointB
    lines[2].From = pointB
    lines[2].To = pointC
    lines[3].From = pointC
    lines[3].To = pointA
end

function Arrow:ShowArrow(player)
    local lines = Arrow:DrawTriangleLines(Arrow.TriangleColor)
    Arrow.ArrowDrawings[player] = lines
    local function Update()
        local c = Arrow.RS.RenderStepped:Connect(function()
            if not Arrow.ArrowDrawings[player] or not Arrow.Enabled then
                if c then c:Disconnect() end
                return
            end
            if player and player.Character and Arrow.LocalPlayer and Arrow.LocalPlayer.Character then
                local CHAR = player.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")
                if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                    local _,vis = Arrow.Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if vis == false then
                        local rel = Arrow:GetRelative(CHAR.PrimaryPart.Position, Arrow.LocalPlayer.Character)
                        local direction = rel.Unit
                        local base = direction * Arrow.DistFromCenter
                        local sideLength = Arrow.TriangleWidth/2
                        local baseL = base + Arrow:RotateVect(direction, 90) * sideLength
                        local baseR = base + Arrow:RotateVect(direction, -90) * sideLength
                        local tip = direction * (Arrow.DistFromCenter + Arrow.TriangleHeight)
                        local pointA = Arrow:AntiA(Arrow:RelativeToCenter(baseL))
                        local pointB = Arrow:AntiA(Arrow:RelativeToCenter(baseR))
                        local pointC = Arrow:AntiA(Arrow:RelativeToCenter(tip))
                        Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
                        lines[1].Visible = true
                        lines[2].Visible = true
                        lines[3].Visible = true
                    else 
                        lines[1].Visible = false
                        lines[2].Visible = false
                        lines[3].Visible = false
                    end
                else 
                    lines[1].Visible = false
                    lines[2].Visible = false
                    lines[3].Visible = false
                end
            else 
                lines[1].Visible = false
                lines[2].Visible = false
                lines[3].Visible = false
            end
        end)
    end
    local connection = Update()
    Arrow.ArrowConnections[player] = connection
end

function Arrow:RemoveArrow(player)
    if Arrow.ArrowDrawings[player] then
        local lines = Arrow.ArrowDrawings[player]
        for _, line in ipairs(lines) do
            line.Visible = false
        end
        Arrow.ArrowDrawings[player] = nil
    end
    if Arrow.ArrowConnections[player] then
        Arrow.ArrowConnections[player] = nil
    end
end

function Arrow:UpdateAllArrows()
    if not Arrow.Enabled then return end
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if player and player.Parent and player.Character and Arrow.LocalPlayer and Arrow.LocalPlayer.Character then
            local CHAR = player.Character
            local HUM = CHAR:FindFirstChildOfClass("Humanoid")
            if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                local _,vis = Arrow.Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                if vis == false then
                    local rel = Arrow:GetRelative(CHAR.PrimaryPart.Position, Arrow.LocalPlayer.Character)
                    local direction = rel.Unit
                    local base = direction * Arrow.DistFromCenter
                    local sideLength = Arrow.TriangleWidth/2
                    local baseL = base + Arrow:RotateVect(direction, 90) * sideLength
                    local baseR = base + Arrow:RotateVect(direction, -90) * sideLength
                    local tip = direction * (Arrow.DistFromCenter + Arrow.TriangleHeight)
                    local pointA = Arrow:AntiA(Arrow:RelativeToCenter(baseL))
                    local pointB = Arrow:AntiA(Arrow:RelativeToCenter(baseR))
                    local pointC = Arrow:AntiA(Arrow:RelativeToCenter(tip))
                    Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
                    lines[1].Visible = true
                    lines[2].Visible = true
                    lines[3].Visible = true
                else
                    lines[1].Visible = false
                    lines[2].Visible = false
                    lines[3].Visible = false
                end
            else
                lines[1].Visible = false
                lines[2].Visible = false
                lines[3].Visible = false
            end
        else
            lines[1].Visible = false
            lines[2].Visible = false
            lines[3].Visible = false
        end
    end
end

function Arrow:CleanUpArrows()
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if not player or not player.Parent then
            for _, line in ipairs(lines) do
                line.Visible = false
            end
            Arrow.ArrowDrawings[player] = nil
            Arrow.ArrowConnections[player] = nil
        end
    end
end

function Arrow:Init()
    Arrow.ArrowDrawings = {}
    Arrow.ArrowConnections = {}
    for _, player in pairs(Arrow.Players:GetChildren()) do
        if player ~= Arrow.LocalPlayer then
            Arrow:ShowArrow(player)
        end
    end
    Arrow.Players.PlayerAdded:Connect(function(player)
        if player ~= Arrow.LocalPlayer then
            Arrow:ShowArrow(player)
        end
    end)
    Arrow.Players.PlayerRemoving:Connect(function(player)
        Arrow:RemoveArrow(player)
    end)
    Arrow.RS.RenderStepped:Connect(function()
        if Arrow.Enabled then
            Arrow:CleanUpArrows()
            Arrow:UpdateAllArrows()
        end
    end)
end

function Arrow:UpdateSettings()
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if lines and #lines >= 3 then
            lines[1].Color = Arrow.TriangleColor
            lines[2].Color = Arrow.TriangleColor
            lines[3].Color = Arrow.TriangleColor
            lines[1].Thickness = Arrow.TriangleThickness
            lines[2].Thickness = Arrow.TriangleThickness
            lines[3].Thickness = Arrow.TriangleThickness
            lines[1].Transparency = 1-Arrow.TriangleTransparency
            lines[2].Transparency = 1-Arrow.TriangleTransparency
            lines[3].Transparency = 1-Arrow.TriangleTransparency
        end
    end
end

function Arrow:Enable(enabled)
    Arrow.Enabled = enabled
    if enabled then
        Arrow:Init()
    else
        for player, _ in pairs(Arrow.ArrowDrawings) do
            Arrow:RemoveArrow(player)
        end
        Arrow.ArrowDrawings = {}
        Arrow.ArrowConnections = {}
    end
end

vizColumn7:Toggle({Name = "Enable Arrow Indicators", Flag = "visualize_arrow_enabled", callback = function(bool)
    Arrow:Enable(bool)
end})

vizColumn7:ColorPicker({Name = "Arrow Color", Default = Color3.fromRGB(255, 255, 255), Flag = "visualize_arrow_color", callback = function(color)
    Arrow.TriangleColor = color
    Arrow:UpdateSettings()
end})

vizColumn7:Slider({Name = "Arrow Distance", Min = 50, Max = 200, Default = 80, Flag = "visualize_arrow_distance", callback = function(value)
    Arrow.DistFromCenter = value
end})

vizColumn7:Slider({Name = "Arrow Size", Min = 8, Max = 32, Default = 16, Flag = "visualize_arrow_size", callback = function(value)
    Arrow.TriangleHeight = value
    Arrow.TriangleWidth = value
end})

vizColumn7:Slider({Name = "Arrow Thickness", Min = 1, Max = 5, Default = 1, Flag = "visualize_arrow_thickness", callback = function(value)
    Arrow.TriangleThickness = value
    Arrow:UpdateSettings()
end})

vizColumn7:Toggle({Name = "Anti Aliasing", Flag = "visualize_arrow_aa", callback = function(bool)
    Arrow.AntiAliasing = bool
end})

local RichShaderSettings = {
    Enabled = false,
    Brightness = 0.2,
    Contrast = 0.5,
    Saturation = 1.5,
    TintColor = Color3.fromRGB(255, 200, 150)
}

local colorCorrection = nil

vizColumn8:Toggle({Name = "Rich Shader", Flag = "visualize_richshader", callback = function(bool)
    RichShaderSettings.Enabled = bool
    
    if bool then
        colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = game:GetService("Lighting")
        colorCorrection.Brightness = RichShaderSettings.Brightness
        colorCorrection.Contrast = RichShaderSettings.Contrast
        colorCorrection.Saturation = RichShaderSettings.Saturation
        colorCorrection.TintColor = RichShaderSettings.TintColor
    else
        if colorCorrection then
            colorCorrection:Destroy()
            colorCorrection = nil
        end
    end
end})

vizColumn8:Slider({Name = "Brightness", Min = -1, Max = 1, Default = 0.2, Flag = "visualize_brightness", callback = function(value)
    RichShaderSettings.Brightness = value
    if colorCorrection then
        colorCorrection.Brightness = value
    end
end})

vizColumn8:Slider({Name = "Contrast", Min = -1, Max = 1, Default = 0.5, Flag = "visualize_contrast", callback = function(value)
    RichShaderSettings.Contrast = value
    if colorCorrection then
        colorCorrection.Contrast = value
    end
end})

vizColumn8:Slider({Name = "Saturation", Min = 0, Max = 2, Default = 1.5, Flag = "visualize_saturation", callback = function(value)
    RichShaderSettings.Saturation = value
    if colorCorrection then
        colorCorrection.Saturation = value
    end
end})

vizColumn8:ColorPicker({Name = "Tint Color", Default = Color3.fromRGB(255, 200, 150), Flag = "visualize_tintcolor", callback = function(color)
    RichShaderSettings.TintColor = color
    if colorCorrection then
        colorCorrection.TintColor = color
    end
end})

local configTab = main:Tab("Config")
local configColumn1 = configTab:Section({Name = "Save/Load", column = 1})
local configColumn2 = configTab:Section({Name = "Manage", column = 2})

configColumn1:Button({Name = "Save Config", Callback = function()
    if writefile then
        local allConfigs = {}
        
        local genv = getgenv()
        for key, value in pairs(genv) do
            if type(value) == "table" then
                allConfigs[key] = value
            elseif type(value) == "Color3" then
                allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
            else
                allConfigs[key] = value
            end
        end
        
        allConfigs["Arrow"] = {
            Enabled = Arrow.Enabled,
            DistFromCenter = Arrow.DistFromCenter,
            TriangleHeight = Arrow.TriangleHeight,
            TriangleWidth = Arrow.TriangleWidth,
            TriangleTransparency = Arrow.TriangleTransparency,
            TriangleThickness = Arrow.TriangleThickness,
            TriangleColor = {
                R = Arrow.TriangleColor.R,
                G = Arrow.TriangleColor.G,
                B = Arrow.TriangleColor.B,
                __type = "Color3"
            },
            AntiAliasing = Arrow.AntiAliasing
        }
        
        writefile("aui_config.json", game:GetService("HttpService"):JSONEncode(allConfigs))
        warn("Configuration saved!")
    else
        warn("Writefile not supported")
    end
end})

configColumn1:Button({Name = "Load Config", Callback = function()
    if readfile and isfile and isfile("aui_config.json") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("aui_config.json"))
        end)
        
        if success and data then
            for key, value in pairs(data) do
                if key == "Arrow" then
                    Arrow.Enabled = value.Enabled
                    Arrow.DistFromCenter = value.DistFromCenter
                    Arrow.TriangleHeight = value.TriangleHeight
                    Arrow.TriangleWidth = value.TriangleWidth
                    Arrow.TriangleTransparency = value.TriangleTransparency
                    Arrow.TriangleThickness = value.TriangleThickness
                    if value.TriangleColor and value.TriangleColor.__type == "Color3" then
                        Arrow.TriangleColor = Color3.fromRGB(value.TriangleColor.R, value.TriangleColor.G, value.TriangleColor.B)
                    end
                    Arrow.AntiAliasing = value.AntiAliasing
                else
                    if type(value) == "table" and value.__type == "Color3" then
                        getgenv()[key] = Color3.fromRGB(value.R, value.G, value.B)
                    else
                        getgenv()[key] = value
                    end
                end
            end
            
            warn("Configuration loaded!")
        else
            warn("Failed to load config")
        end
    else
        warn("Config file not found")
    end
end})

configColumn1:Button({Name = "Reset to Default", Callback = function()
    getgenv().CONFIG = {
        Ragebot = {
            Enabled = false,
            RapidFire = false,
            FireRate = 30,
            Prediction = true,
            PredictionAmount = 0.12,
            TeamCheck = false,
            VisibilityCheck = true,
            FOV = 120,
            ShowFOV = true,
            Wallbang = true,
            Tracers = true,
            TracerColor = Color3.fromRGB(255, 0, 0),
            TracerWidth = 1,
            TracerLifetime = 3,
            ShootRange = 15,
            HitRange = 15,
            HitNotify = true,
            AutoReload = true,
            HitSound = true,
            HitColor = Color3.fromRGB(255, 182, 193),
            UseTargetList = false,
            UseWhitelist = false,
            HitNotifyDuration = 5,
            LowHealthCheck = false,
            SelectedHitSound = "skeet"
        },
        Misc = {
            SpeedEnabled = false,
            SpeedValue = 50,
            JumpPowerEnabled = false,
            JumpPowerValue = 100,
            LoopFOVEnabled = false,
            HideHeadEnabled = false,
            InfStaminaEnabled = false,
            NoFallDmgEnabled = false,
            SpeedConnection = nil,
            FOVConnection = nil,
            JumpPowerConnection = nil,
            NoFallHook = nil,
            InfStaminaHook = nil
        },
        Visualize = {
            ESP = {
                Enabled = false,
                BoxColor = Color3.fromRGB(78, 150, 50),
                OutlineColor = Color3.fromRGB(78, 150, 50),
                TextColor = Color3.fromRGB(255, 255, 255),
                MaxDistance = 1000
            },
            ForcefieldColor = Color3.fromRGB(255, 255, 255),
            ForcefieldTransparency = 0.5,
            LocalForcefieldEnabled = false,
            ArrowEnabled = false,
            ArrowColor = Color3.fromRGB(255, 255, 255),
            ArrowDistance = 80,
            ArrowSize = 16,
            ArrowThickness = 1,
            ArrowAA = false
        }
    }
    
    getgenv().Lists = {
        TargetList = {},
        Whitelist = {}
    }
    
    Arrow.Enabled = false
    Arrow.DistFromCenter = 80
    Arrow.TriangleHeight = 16
    Arrow.TriangleWidth = 16
    Arrow.TriangleTransparency = 0
    Arrow.TriangleThickness = 1
    Arrow.TriangleColor = Color3.fromRGB(255, 255, 255)
    Arrow.AntiAliasing = false
    
    warn("Configuration reset to default!")
end})

configColumn2:Box({Name = "Config Name", Placeholder = "Enter config name", Flag = "config_name", Callback = function(text)
    getgenv().currentConfigName = text
end})

configColumn2:Button({Name = "Save as Preset", Callback = function()
    if writefile and getgenv().currentConfigName then
        local name = getgenv().currentConfigName
        if name ~= "" then
            local allConfigs = {}
            
            local genv = getgenv()
            for key, value in pairs(genv) do
                if type(value) == "table" then
                    allConfigs[key] = value
                elseif type(value) == "Color3" then
                    allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
                else
                    allConfigs[key] = value
                end
            end
            
            allConfigs["Arrow"] = {
                Enabled = Arrow.Enabled,
                DistFromCenter = Arrow.DistFromCenter,
                TriangleHeight = Arrow.TriangleHeight,
                TriangleWidth = Arrow.TriangleWidth,
                TriangleTransparency = Arrow.TriangleTransparency,
                TriangleThickness = Arrow.TriangleThickness,
                TriangleColor = {
                    R = Arrow.TriangleColor.R,
                    G = Arrow.TriangleColor.G,
                    B = Arrow.TriangleColor.B,
                    __type = "Color3"
                },
                AntiAliasing = Arrow.AntiAliasing
            }
            
            writefile("aui_preset_" .. name .. ".json", game:GetService("HttpService"):JSONEncode(allConfigs))
            warn("Preset saved as: " .. name)
        end
    end
end})

configColumn2:Button({Name = "Delete Preset", Callback = function()
    if delfile and getgenv().currentConfigName then
        local name = getgenv().currentConfigName
        if name ~= "" then
            local filename = "aui_preset_" .. name .. ".json"
            if isfile(filename) then
                delfile(filename)
                warn("Preset deleted: " .. name)
            end
        end
    end
end})


