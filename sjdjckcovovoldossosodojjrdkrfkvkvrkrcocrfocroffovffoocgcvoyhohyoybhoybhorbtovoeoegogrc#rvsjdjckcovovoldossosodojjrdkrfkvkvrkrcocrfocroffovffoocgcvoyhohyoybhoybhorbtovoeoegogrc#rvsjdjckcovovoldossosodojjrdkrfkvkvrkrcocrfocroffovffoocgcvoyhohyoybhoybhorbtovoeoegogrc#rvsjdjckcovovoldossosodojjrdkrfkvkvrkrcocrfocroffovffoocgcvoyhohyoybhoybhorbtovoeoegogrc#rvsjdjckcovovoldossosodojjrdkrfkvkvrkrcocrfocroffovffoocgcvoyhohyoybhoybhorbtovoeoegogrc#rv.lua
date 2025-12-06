if string.lower((getgenv() or _G).key or "") ~= "getskeetkey.gg" then return end
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if makefolder then
    makefolder("aui")
    makefolder("aui/fonts")
end

if not isfile or (isfile and not isfile("aui/fonts/main.ttf")) then
    if writefile then
        writefile("aui/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
    end
end

local font_data = {
    name = "AUIFont",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset and getcustomasset("aui/fonts/main.ttf") or ""
        }
    }
}

if writefile and not isfile("aui/fonts/main_encoded.ttf") then
    writefile("aui/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
end

local AsyV2 = loadstring(game:HttpGet("https://github.com/ske-code/eupismyflycup/blob/main/AsyV2eupisnigger.lua?raw=true"))()
AsyV2.font = Font.new(getcustomasset and getcustomasset("aui/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

local screenSize = workspace.CurrentCamera.ViewportSize
local screenY = screenSize.Y

local targetHeight
if screenY > 350 then
    targetHeight = 550
else
    targetHeight = 300
end

local window = AsyV2:CreateWindow({
    name = "Example Script",
    size = UDim2.new(0, 650, 0, targetHeight)
})

local mainTab = window:CreateTab("Main")
local combatTab = window:CreateTab("Combat")
local visualsTab = window:CreateTab("Visuals")
local miscTab = window:CreateTab("Misc")

getgenv().Ragebot = {
    Enabled = false,
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
    WallbangRange = 30,
    HitNotify = true,
    AutoReload = true,
    HitSound = true,
    TargetList = {},
    Whitelist = {},
    UseTargetList = false,
    UseWhitelist = false
}

local white = Color3.fromRGB(255, 255, 255)
local pink = Color3.fromRGB(255, 182, 193)

local rageLeft = mainTab:CreateSection({
    name = "Ragebot",
    side = "Left",
    size = 200
})

local rageRight = mainTab:CreateSection({
    name = "Targeting",
    side = "Right",
    size = 250
})

rageLeft:CreateLabel({text = "Core Ragebot"})
rageLeft:CreateToggle({
    name = "Enable Ragebot",
    default = false,
    callback = function(s) 
        getgenv().Ragebot.Enabled = s 
    end
})

rageLeft:CreateToggle({
    name = "Hit Notifications",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.HitNotify = s 
    end
})

rageLeft:CreateToggle({
    name = "Hit Sound",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.HitSound = s 
    end
})

rageLeft:CreateToggle({
    name = "Auto Reload",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.AutoReload = s 
    end
})

rageLeft:CreateSlider({
    name = "Fire Rate",
    min = 1,
    max = 1000,
    default = 30,
    callback = function(v) 
        getgenv().Ragebot.FireRate = v 
    end
})

rageLeft:CreateSlider({
    name = "Wallbang Range",
    min = 10,
    max = 30,
    default = 30,
    callback = function(v) 
        getgenv().Ragebot.WallbangRange = v 
    end
})

rageRight:CreateToggle({
    name = "Team Check",
    default = false,
    callback = function(s) 
        getgenv().Ragebot.TeamCheck = s 
    end
})

rageRight:CreateToggle({
    name = "Visibility Check",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.VisibilityCheck = s 
    end
})

rageRight:CreateToggle({
    name = "Wallbang",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.Wallbang = s 
    end
})

rageRight:CreateSlider({
    name = "FOV",
    min = 10,
    max = 360,
    default = 120,
    callback = function(v) 
        getgenv().Ragebot.FOV = v 
    end
})

rageRight:CreateToggle({
    name = "Show FOV",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.ShowFOV = s 
    end
})

local combatLeft = combatTab:CreateSection({
    name = "Aim Settings",
    side = "Left",
    size = 200
})

local combatRight = combatTab:CreateSection({
    name = "Prediction",
    side = "Right",
    size = 250
})

combatLeft:CreateToggle({
    name = "Prediction",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.Prediction = s 
    end
})

combatLeft:CreateSlider({
    name = "Prediction Amount",
    min = 0.05,
    max = 0.3,
    default = 0.12,
    callback = function(v) 
        getgenv().Ragebot.PredictionAmount = v 
    end
})

local visualsLeft = visualsTab:CreateSection({
    name = "Tracers",
    side = "Left",
    size = 200
})

local visualsRight = visualsTab:CreateSection({
    name = "Colors",
    side = "Right",
    size = 250
})

visualsLeft:CreateToggle({
    name = "Tracers",
    default = true,
    callback = function(s) 
        getgenv().Ragebot.Tracers = s 
    end
})

visualsLeft:CreateSlider({
    name = "Tracer Width",
    min = 0.1,
    max = 5,
    default = 1,
    callback = function(v) 
        getgenv().Ragebot.TracerWidth = v 
    end
})

visualsLeft:CreateSlider({
    name = "Tracer Lifetime",
    min = 0.5,
    max = 10,
    default = 3,
    callback = function(v) 
        getgenv().Ragebot.TracerLifetime = v 
    end
})

local tracerColorPicker = visualsRight:CreateLabel({text = "Tracer Color"})
tracerColorPicker:CreateColorpicker({
    default = Color3.fromRGB(255, 0, 0),
    callback = function(c) 
        getgenv().Ragebot.TracerColor = c 
    end
})

local listsLeft = miscTab:CreateSection({
    name = "Target List",
    side = "Left",
    size = 200
})

local listsRight = miscTab:CreateSection({
    name = "Whitelist",
    side = "Right",
    size = 250
})

listsLeft:CreateToggle({
    name = "Use Target List",
    default = false,
    callback = function(s) 
        getgenv().Ragebot.UseTargetList = s 
    end
})

listsLeft:CreateTextbox({
    name = "Add Player to Target List",
    placeholder = "Player Name",
    callback = function(text)
        if text and text ~= "" then
            table.insert(getgenv().Ragebot.TargetList, text)
        end
    end
})

listsLeft:CreateButton({
    name = "Clear Target List",
    callback = function()
        getgenv().Ragebot.TargetList = {}
    end
})

listsRight:CreateToggle({
    name = "Use Whitelist",
    default = false,
    callback = function(s) 
        getgenv().Ragebot.UseWhitelist = s 
    end
})

listsRight:CreateTextbox({
    name = "Add Player to Whitelist",
    placeholder = "Player Name",
    callback = function(text)
        if text and text ~= "" then
            table.insert(getgenv().Ragebot.Whitelist, text)
        end
    end
})

listsRight:CreateButton({
    name = "Clear Whitelist",
    callback = function()
        getgenv().Ragebot.Whitelist = {}
    end
})

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitNotifications"
ScreenGui.Parent = game:GetService("CoreGui")
local hitNotifications = {}

local HitFont = Font.new(getcustomasset and getcustomasset("aui/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

local hitSoundList = {
    name = "Hit Sound",
    options = {"Skeet", "XP Level"},
    def = "Skeet",
    multiselect = false,
    callback = function(v)
        getgenv().Ragebot.SelectedHitSound = v
    end
}

local function playHitSound()
    if not getgenv().Ragebot.HitSound then return end
    
    local soundIds = {
        ["Skeet"] = "rbxassetid://4817809188",
        ["XP Level"] = "rbxassetid://17148249625"
    }
    
    local soundId = soundIds[getgenv().Ragebot.SelectedHitSound] or soundIds["Skeet"]
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Parent = Workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 3)
end

rageLeft:CreateList(hitSoundList)

local function createHitNotification(toolName, offsetValue, playerName)
    if not getgenv().Ragebot.HitNotify then return end
    
    playHitSound()
    
    local box = Instance.new("Frame")
    box.Parent = ScreenGui
    box.BackgroundColor3 = Color3.new(0, 0, 0)
    box.BackgroundTransparency = 0.3
    box.BorderSizePixel = 0
    
    local parts = {
        {"Using ", white},
        {toolName.." ", pink},
        {"On ", white},
        {string.format("%.2f", offsetValue).." ", pink},
        {"in the ", white},
        {"head ", pink},
        {"to hit ", white},
        {playerName, pink}
    }
    
    local offsetX = 6
    local totalW, maxH = 0, 0
    
    for _, seg in ipairs(parts) do
        local txt, col = seg[1], seg[2]
        local label = Instance.new("TextLabel")
        label.Parent = box
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextColor3 = col
        label.FontFace = HitFont
        label.TextSize = 12
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = txt
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.Position = UDim2.new(0, offsetX, 0, 0)
        offsetX = offsetX + label.TextBounds.X
        totalW = offsetX
        maxH = math.max(maxH, label.TextBounds.Y)
    end
    
    box.Size = UDim2.new(0, totalW + 12, 0, maxH + 8)
    box.Position = UDim2.new(0, 10, 0, 10 + (#hitNotifications * (maxH + 8 + 5)))
    table.insert(hitNotifications, box)
    
    task.delay(5, function()
        for i, notif in ipairs(hitNotifications) do
            if notif == box then
                table.remove(hitNotifications, i)
                break
            end
        end
        if box then box:Destroy() end
        for i, notif in ipairs(hitNotifications) do
            notif.Position = UDim2.new(0, 10, 0, 10 + ((i - 1) * (notif.AbsoluteSize.Y + 5)))
        end
    end)
end

local function getCurrentTool()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

local function autoReload()
    if not getgenv().Ragebot.AutoReload then return end
    
    local tool = getCurrentTool()
    if not tool then return end
    
    local values = tool:FindFirstChild("Values")
    if not values then return end
    
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    
    if ammo.Value <= 0 and storedAmmo.Value > 0 then
        local args = {
            tick(),
            "KLWE89U0",
            tool
        }
        local GNX_R = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
        GNX_R:FireServer(unpack(args))
    end
end

local function RandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset))
    end
    return result
end

local function canSeeTarget(targetPart)
    if not getgenv().Ragebot.VisibilityCheck then return true end
    
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local startPos = localHead.Position
    local endPos = targetPart.Position
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    local secondRaycast = Workspace:Raycast(startPos + direction.Unit * 0.5, direction.Unit * (distance - 0.5), raycastParams)
    if secondRaycast then
        local hitPart = secondRaycast.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    return true
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if getgenv().Ragebot.UseWhitelist and table.find(getgenv().Ragebot.Whitelist, player.Name) then
            continue
        end
        
        if getgenv().Ragebot.UseTargetList and not table.find(getgenv().Ragebot.TargetList, player.Name) then
            continue
        end
        
        if getgenv().Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local hasForcefield = false
                for _, child in pairs(character:GetChildren()) do
                    if child:IsA("ForceField") then
                        hasForcefield = true
                        break
                    end
                end
                
                if hasForcefield then continue end
        
                if getgenv().Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                
                local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if distance < shortestDistance then
                    if canSeeTarget(head) then
                        closest = head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closest
end

getgenv().Ragebot.LowHealthCheck = false
rageRight:CreateToggle({
    name = "Downed Check",
    default = false,
    callback = function(s)
        getgenv().Ragebot.LowHealthCheck = s
    end
})

local function checkClearPath(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if not humanoid then
                    return false
                end
            else
                return false
            end
        end
    end
    return true
end

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    local target = getClosestTarget()
    if not target then return nil end
    if not getgenv().Ragebot.Wallbang then
        return localHead.Position, target.Position
    end

    local attempts = 150
    local bestShootPos = nil
    local bestHitPos = nil
    local wallbangRange = getgenv().Ragebot.WallbangRange or 30
    
    for i = 1, attempts do
        local shootOffsetX = math.random(-wallbangRange, wallbangRange)
        local shootOffsetY = math.random(-wallbangRange, wallbangRange)
        local shootOffsetZ = math.random(-wallbangRange, wallbangRange)
        local shootPos = localHead.Position + Vector3.new(shootOffsetX, shootOffsetY, shootOffsetZ)
        
        local hitOffsetX = math.random(-wallbangRange, wallbangRange)
        local hitOffsetY = math.random(-wallbangRange, wallbangRange)
        local hitOffsetZ = math.random(-wallbangRange, wallbangRange)
        local hitPos = target.Position + Vector3.new(hitOffsetX, hitOffsetY, hitOffsetZ)
        
        local pathToShoot = checkClearPath(localHead.Position, shootPos)
        local pathToTarget = checkClearPath(shootPos, hitPos)
    
        if pathToShoot and pathToTarget then
            if not bestShootPos then
                bestShootPos = shootPos
                bestHitPos = hitPos
            else
                local currentDistance = (shootPos - localHead.Position).Magnitude + (hitPos - target.Position).Magnitude
                local bestDistance = (bestShootPos - localHead.Position).Magnitude + (bestHitPos - target.Position).Magnitude
                
                if currentDistance < bestDistance then
                    bestShootPos = shootPos
                    bestHitPos = hitPos
                end
            end
        end
    end
    return bestShootPos or localHead.Position, bestHitPos or target.Position
end

local function createTracer(startPos, endPos)
    if not getgenv().Ragebot.Tracers then return end
    
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "TracerBeam"
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().Ragebot.TracerColor)
    beam.Width0 = getgenv().Ragebot.TracerWidth
    beam.Width1 = getgenv().Ragebot.TracerWidth
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = 1
    beam.Brightness = 5
    beam.LightEmission = 3
    beam.FaceCamera = true
    
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")
    a0.WorldPosition = startPos
    a1.WorldPosition = endPos
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    
    beam.Parent = tracerModel
    a0.Parent = tracerModel
    a1.Parent = tracerModel
    tracerModel.Parent = Workspace
    
    local tweenInfo = TweenInfo.new(
        getgenv().Ragebot.TracerLifetime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(beam, tweenInfo, {
        Brightness = 0
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        if tracerModel then 
            tracerModel:Destroy() 
        end
    end)
end

local function shootAtTarget(targetHead)
    if not targetHead then return false end
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local tool = getCurrentTool()
    if not tool then return false end
    local values = tool:FindFirstChild("Values")
    local hitMarker = tool:FindFirstChild("Hitmarker")
    if not values or not hitMarker then return false end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return false end
    if ammo.Value <= 0 then
        autoReload()
        return false
    end

    local bestShootPos, bestHitPos = wallbang()
    
    if not bestShootPos or not bestHitPos then
        return false
    end
    local hitPosition = bestHitPos
  
    if getgenv().Ragebot.Prediction then
        local velocity = targetHead.Velocity or Vector3.zero
        hitPosition = hitPosition + velocity * getgenv().Ragebot.PredictionAmount
    end

    local hitDirection = (hitPosition - bestShootPos).Unit
    local randomKey = RandomString(30) .. "0"
    local args1 = {tick(), randomKey, tool, "FDS9I83", bestShootPos, {hitDirection}, false}
    local args2 = {"🧈", tool, randomKey, 1, targetHead, hitPosition, hitDirection}
    local events = ReplicatedStorage:WaitForChild("Events")
    local GNX_S = events:WaitForChild("GNX_S")
    local ZFKLF__H = events:WaitForChild("ZFKLF__H")
    local targetPlayer = Players:GetPlayerFromCharacter(targetHead.Parent)
    if targetPlayer then
        createHitNotification(tool.Name, (bestShootPos - localHead.Position).Magnitude, targetPlayer.Name)
    end

    coroutine.wrap(function()
        GNX_S:FireServer(unpack(args1))
        ZFKLF__H:FireServer(unpack(args2))
    end)()

    ammo.Value = math.max(ammo.Value - 1, 0)
    hitMarker:Fire(targetHead)
    storedAmmo.Value = storedAmmo.Value
    createTracer(bestShootPos, hitPosition)
    return true
end

local lastShotTime = 0
RunService.Heartbeat:Connect(function()
    if not getgenv().Ragebot.Enabled then return end
    if not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild("Head") then return end
    
    local currentTime = tick()
    local waitTime = 1 / getgenv().Ragebot.FireRate
    
    if currentTime - lastShotTime >= waitTime then
        local target = getClosestTarget()
        if target then
            local success = shootAtTarget(target)
            if success then
                lastShotTime = currentTime
            end
        end
    end
end)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().Ragebot.ShowFOV
fovCircle.Radius = getgenv().Ragebot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = getgenv().Ragebot.ShowFOV and getgenv().Ragebot.Enabled
    fovCircle.Radius = getgenv().Ragebot.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local hideHeadEnabled = false
local speedEnabled = false
local speedValue = 50
local loopFOVEnabled = false
local infStaminaEnabled = false
local noFallDmgEnabled = false
local speedConnection
local loopFOVConnection

local function hideHeadFE()
    if not LocalPlayer.Character then return end
    
    local head = LocalPlayer.Character:FindFirstChild("Head")
    local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
    if not head or not torso then return end
    
    local neckMotor = Instance.new("Motor6D")
    neckMotor.Name = "Neck"
    neckMotor.Part0 = torso
    neckMotor.Part1 = head
    neckMotor.C0 = CFrame.new(0, -0.5, 0.5)
    neckMotor.Parent = head
    
    head.LocalTransparencyModifier = 0
    
    for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.LocalTransparencyModifier = 0
            end
        end
    end
end

local function showHeadFE()
    if not LocalPlayer.Character then return end
    
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    
    local neckMotor = head:FindFirstChild("Neck")
    if neckMotor then
        neckMotor:Destroy()
    end
    
    head.LocalTransparencyModifier = 0
    
    for _, accessory in pairs(LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.LocalTransparencyModifier = 0
            end
        end
    end
end

local function enableSpeed()
    if not LocalPlayer.Character then return end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    speedConnection = RunService.Heartbeat:Connect(function()
        if not humanoidRootPart or not humanoidRootPart.Parent then
            speedConnection:Disconnect()
            return
        end
        
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            humanoidRootPart.AssemblyLinearVelocity = moveDirection * speedValue + Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
        else
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
        end
    end)
end

local function disableSpeed()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    if not LocalPlayer.Character then return end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
    end
end

local function enableLoopFOV()
    loopFOVConnection = RunService.Heartbeat:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if loopFOVConnection then
        loopFOVConnection:Disconnect()
    end
end

local module
do
    for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name == "XIIX" then
            module = v
        end
    end
end

local function enableInfStamina()
    if module then
        module = require(module)
        local ac = module["XIIX"]
        local glob = getfenv(ac)["_G"]
        local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
        
        if stamina ~= nil then
            hookfunction(stamina, function()
                return 100, 100
            end)
        end
    end
end

local function enableNoFallDmg()
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = { ... }
        if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
            args[2] = 0
            args[3] = 0
        end
        return old(self, unpack(args))
    end)
end

local miscLeft = miscTab:CreateSection({
    name = "Character",
    side = "Left",
    size = 200
})

local miscRight = miscTab:CreateSection({
    name = "Exploits",
    side = "Right",
    size = 250
})

miscLeft:CreateToggle({
    name = "Hide Head",
    default = false,
    callback = function(s)
        hideHeadEnabled = s
        if s then
            hideHeadFE()
        else
            showHeadFE()
        end
    end
})

miscLeft:CreateToggle({
    name = "Speed",
    default = false,
    callback = function(s)
        speedEnabled = s
        if s then
            enableSpeed()
        else
            disableSpeed()
        end
    end
})

miscLeft:CreateSlider({
    name = "Speed Value",
    min = 10,
    max = 200,
    default = 50,
    callback = function(v)
        speedValue = v
    end
})

miscLeft:CreateToggle({
    name = "Loop FOV",
    default = false,
    callback = function(s)
        loopFOVEnabled = s
        if s then
            enableLoopFOV()
        else
            disableLoopFOV()
        end
    end
})

miscRight:CreateToggle({
    name = "Inf Stamina",
    default = false,
    callback = function(s)
        infStaminaEnabled = s
        if s then
            enableInfStamina()
        end
    end
})

getgenv().NoFallDmgEnabled = false
local noFallForceField = nil

miscRight:CreateToggle({
    name = "No Fall Damage",
    default = false,
    callback = function(state)
        getgenv().NoFallDmgEnabled = state
        if state then
            if not noFallForceField then
                noFallForceField = Instance.new("ForceField")
                noFallForceField.Parent = LocalPlayer.Character
                noFallForceField.Visible = false
            end
        else
            if noFallForceField then
                noFallForceField:Destroy()
                noFallForceField = nil
            end
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if hideHeadEnabled then
        hideHeadFE()
    end
    if speedEnabled then
        enableSpeed()
    end
    if loopFOVEnabled then
        enableLoopFOV()
    end
end)

local hitColorLabel = visualsLeft:CreateLabel({text = "Hit notification Color"})
hitColorLabel:CreateColorpicker({
    default = pink,
    callback = function(c)
        pink = c
    end
})

local danceSection = miscTab:CreateSection({
    name = "Dance Animations",
    side = "Left",
    size = 200
})

local danceAnimations = {
    billie = {"http://www.roblox.com/asset/?id=14849697861"},
    chrono = {"http://www.roblox.com/asset/?id=14849705278"},
    sponge = {"http://www.roblox.com/asset/?id=14849714833"},
    twist = {"http://www.roblox.com/asset/?id=14849722929"},
    goth = {"http://www.roblox.com/asset/?id=14849726322"},
    soviet1 = {"http://www.roblox.com/asset/?id=14849731537"},
    drip = {"http://www.roblox.com/asset/?id=14849735043"},
    thriller = {"http://www.roblox.com/asset/?id=14849738091"},
    shuffle = {"http://www.roblox.com/asset/?id=14849741153"},
    stomp = {"http://www.roblox.com/asset/?id=14849744125"},
    hustle = {"http://www.roblox.com/asset/?id=14849746902"},
    soviet2 = {"http://www.roblox.com/asset/?id=14849749888"}
}

local currentAnimationTrack = nil

local function playDanceAnimation(animationName)
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animationData = danceAnimations[animationName]
    if not animationData then return end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = animationData[1]
    
    currentAnimationTrack = humanoid:LoadAnimation(animation)
    currentAnimationTrack:Play()
end

local function stopDanceAnimation()
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
end

for danceName, _ in pairs(danceAnimations) do
    danceSection:CreateButton({
        name = "Play " .. danceName,
        callback = function()
            playDanceAnimation(danceName)
        end
    })
end

danceSection:CreateButton({
    name = "Stop Dance",
    callback = function()
        stopDanceAnimation()
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if currentAnimationTrack then
        wait(1)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local lastAnimationName = nil
            for name, track in pairs(danceAnimations) do
                if track == currentAnimationTrack then
                    lastAnimationName = name
                    break
                end
            end
            if lastAnimationName then
                playDanceAnimation(lastAnimationName)
            end
        end
    end
end)

local flySection = miscTab:CreateSection({
    name = "Fly Controls",
    side = "Right",
    size = 250
})

local Fly = {
    On = false,
    Speed = 50,
    UI = false
}

local flyConn = nil
local flyPart = nil
local flyGui = nil

local function startFly()
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    humanoid.PlatformStand = true
    
    flyPart = Instance.new("Part")
    flyPart.Name = "FlyAnchor"
    flyPart.Anchored = false
    flyPart.CanCollide = false
    flyPart.Transparency = 1
    flyPart.Size = Vector3.new(1, 1, 1)
    flyPart.Position = hrp.Position
    flyPart.CFrame = hrp.CFrame
    flyPart.Parent = workspace
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local motor = Instance.new("Motor6D")
            motor.Name = "FlyMotor"
            motor.Part0 = flyPart
            motor.Part1 = part
            motor.C0 = CFrame.new()
            motor.C1 = part.CFrame:ToObjectSpace(flyPart.CFrame)
            motor.Parent = flyPart
        end
    end
    
    flyConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not Fly.On or not char or not hrp then
            if flyConn then
                flyConn:Disconnect()
                flyConn = nil
            end
            if flyPart then
                flyPart:Destroy()
                flyPart = nil
            end
            return
        end
      
        local look = workspace.CurrentCamera.CFrame.LookVector
        hrp.Velocity = look * Fly.Speed
        
        local args = {
            "__---r",
            Vector3.new(6.749612331390381, 35.8061637878418, 6.615190029144287),
            CFrame.new(-3882.54541015625, 2.3969318866729736, -186.0290985107422, 0.48847436904907227, -0.04458007961511612, 0.8714386820793152, -0.19186905026435852, 0.9687637090682983, 0.15710878372192383, -0.8512220978736877, -0.24394573271274567, 0.46466270089149475)
        }
        
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("__RZDONL"):FireServer(unpack(args))
        end)
    end)
end

local function stopFly()
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if flyPart then
        flyPart:Destroy()
        flyPart = nil
    end
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

flySection:CreateToggle({
    name = "Fly",
    default = false,
    callback = function(s)
        Fly.On = s
        if s then
            startFly()
        else
            stopFly()
        end
    end
})

flySection:CreateSlider({
    name = "Fly Speed",
    min = 10,
    max = 200,
    default = 50,
    callback = function(v)
        Fly.Speed = v
    end
})

getgenv().MeleeAura = {
    Enabled = true,
    TargetPart = {"Head", "UpperTorso"},
    ShowAnim = true
}

local AttachCD = {
    ["Fists"] = .35, ["BBaton"] = .5, ["__ZombieFists1"] = .35, ["__ZombieFists2"] = .37, 
    ["__ZombieFists3"] = .22, ["__ZombieFists4"] = .4, ["__XFists"] = .35, ["Balisong"] = .3, 
    ["Bat"] = 1.2, ["Bayonet"] = .6, ["BlackBayonet"] = .6, ["CandyCrowbar"] = 2.5, 
    ["Chainsaw"] = 3, ["Crowbar"] = 1.2, ["Clippers"] = .6, ["CursedDagger"] = .8, 
    ["DELTA-X04"] = .6, ["ERADICATOR"] = 2, ["ERADICATOR-II"] = 2, ["Fire-Axe"] = 1.6, 
    ["GoldenAxe"] = .75, ["Golfclub"] = 1.2, ["Hatchet"] = .7, ["Katana"] = .6, 
    ["Knuckledusters"] = .5, ["Machete"] = .7, ["Metal-Bat"] = 1.3, ["Nunchucks"] = .3, 
    ["PhotonBlades"] = .8, ["Rambo"] = .8, ["ReforgedKatana"] = .85, ["Rendbreaker"] = 1.5, 
    ["RoyalBroadsword"] = 1, ["Sabre"] = .7, ["Scythe"] = 1.2, ["Shiv"] = .5, 
    ["Shovel"] = 2.5, ["SlayerSword"] = 1.5, ["Sledgehammer"] = 2.2, ["Taiga"] = .7, 
    ["Tomahawk"] = .85, ["Wrench"] = .6, ["_BFists"] = .35, ["_FallenBlade"] = 1.3, 
    ["_Sledge"] = 2.2, ["new_oldSlayerSword"] = 1.5
}

local ValidMeleeTargetParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
local remote1 = ReplicatedStorage.Events["XMHH.2"]
local remote2 = ReplicatedStorage.Events["XMHH2.2"]
local LastTick = tick()
local AttachTick = tick()
local currentSlash = 1

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = character
        end
    end
    
    return closestPlayer
end

local function attackTarget(target)
    if not target or not target:FindFirstChild("Head") then return end
    if not LocalPlayer.Character then return end
    
    local TOOL = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not TOOL then return end
    
    local attachcd = AttachCD[TOOL.Name] or 0.5
    if tick() - AttachTick >= attachcd then
        local result = remote1:InvokeServer("🍞", tick(), TOOL, "43TRFWX", "Normal", tick(), true)
        
        if getgenv().MeleeAura.ShowAnim then
            local animFolder = TOOL:FindFirstChild("AnimsFolder")
            if animFolder then
                local animName = "Slash" .. currentSlash
                local anim = animFolder:FindFirstChild(animName)
                if anim then
                    local animator = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChild("Animator")
                    if animator then
                        animator:LoadAnimation(anim):Play(0.1, 1, 1.3)
                        currentSlash = currentSlash + 1
                        if not animFolder:FindFirstChild("Slash" .. currentSlash) then
                            currentSlash = 1
                        end
                    end
                end
            end
        end
    
        task.wait(0.3 + math.random() * 0.2)
        
        local Handle = TOOL:FindFirstChild("WeaponHandle") or TOOL:FindFirstChild("Handle") or LocalPlayer.Character:FindFirstChild("Left Arm")
        if TOOL then
            local targetPartName = #getgenv().MeleeAura.TargetPart > 0 and getgenv().MeleeAura.TargetPart[math.random(1, #getgenv().MeleeAura.TargetPart)] or ValidMeleeTargetParts[math.random(1, #ValidMeleeTargetParts)]
            local targetPart = target:FindFirstChild(targetPartName)
            if not targetPart then
                targetPart = target:FindFirstChild(ValidMeleeTargetParts[math.random(1, #ValidMeleeTargetParts)])
            end
            if not targetPart then return end
            
            local arg2 = {
                "🍞",
                tick(),
                TOOL,
                "2389ZFX34",
                result,
                true,
                Handle,
                targetPart,
                target,
                LocalPlayer.Character.HumanoidRootPart.Position,
                targetPart.Position
            }
            
            if TOOL.Name == "Chainsaw" then
                for i = 1, 15 do 
                    remote2:FireServer(unpack(arg2))
                end
            else
                remote2:FireServer(unpack(arg2))
            end
            AttachTick = tick()
        end
    end
end

RunService.Heartbeat:Connect(function()
    if getgenv().MeleeAura.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local target = getClosestPlayer()
        if target then
            attackTarget(target)
        end
    end
end)

local meleeSection = combatTab:CreateSection({
    name = "Melee Aura",
    side = "Left",
    size = 200
})

meleeSection:CreateToggle({
    name = "Melee Aura",
    default = true,
    callback = function(s)
        getgenv().MeleeAura.Enabled = s
    end
})

meleeSection:CreateToggle({
    name = "Show Animation",
    default = true,
    callback = function(s)
        getgenv().MeleeAura.ShowAnim = s
    end
})

local targetPartsList = {
    name = "Target Parts",
    options = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"},
    def = {"Head", "UpperTorso"},
    multiselect = true,
    callback = function(selected)
        getgenv().MeleeAura.TargetPart = selected
    end
}

meleeSection:CreateList(targetPartsList)

getgenv().VisualSettings = {
    Forcefield = {
        Enabled = false,
        Color = Color3.fromRGB(0, 162, 255),
        Transparency = 0.3
    },
    ViewModel = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0
    }
}

local originalData = {
    Forcefield = {Materials = {}, Colors = {}, Transparency = {}},
    ViewModel = {Colors = {}, Transparency = {}}
}

local function applyVisual(settingType)
    if settingType == "Forcefield" and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                originalData.Forcefield.Materials[part] = part.Material
                originalData.Forcefield.Colors[part] = part.Color
                originalData.Forcefield.Transparency[part] = part.Transparency
                
                part.Material = Enum.Material.ForceField
                part.Color = getgenv().VisualSettings.Forcefield.Color
                part.Transparency = getgenv().VisualSettings.Forcefield.Transparency
            end
        end
    elseif settingType == "ViewModel" then
        for _, model in pairs(Camera:GetDescendants()) do
            if model:IsA("Model") then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        originalData.ViewModel.Colors[part] = part.Color
                        originalData.ViewModel.Transparency[part] = part.Transparency
                        
                        part.Color = getgenv().VisualSettings.ViewModel.Color
                        part.Transparency = getgenv().VisualSettings.ViewModel.Transparency
                    end
                end
            end
        end
    end
end

local function removeVisual(settingType)
    if settingType == "Forcefield" and LocalPlayer.Character then
        for part in pairs(originalData.Forcefield.Materials) do
            if part and part.Parent then
                part.Material = originalData.Forcefield.Materials[part]
                part.Color = originalData.Forcefield.Colors[part]
                part.Transparency = originalData.Forcefield.Transparency[part]
            end
        end
        originalData.Forcefield = {Materials = {}, Colors = {}, Transparency = {}}
    elseif settingType == "ViewModel" then
        for part in pairs(originalData.ViewModel.Colors) do
            if part and part.Parent then
                part.Color = originalData.ViewModel.Colors[part]
                part.Transparency = originalData.ViewModel.Transparency[part]
            end
        end
        originalData.ViewModel = {Colors = {}, Transparency = {}}
    end
end

local charVisuals = visualsTab:CreateSection({
    name = "Character",
    side = "Left",
    size = 200
})

local a = charVisuals:CreateToggle({
    name = "Forcefield",
    default = false,
    callback = function(s)
        getgenv().VisualSettings.Forcefield.Enabled = s
        if s then applyVisual("Forcefield") else removeVisual("Forcefield") end
    end
})

a:CreateColorpicker({
    name = "Forcefield Color",
    default = Color3.fromRGB(0, 162, 255),
    callback = function(c)
        getgenv().VisualSettings.Forcefield.Color = c
        if getgenv().VisualSettings.Forcefield.Enabled then applyVisual("Forcefield") end
    end
})

charVisuals:CreateSlider({
    name = "Forcefield Transparency",
    min = 0,
    max = 1,
    default = 0.3,
    callback = function(v)
        getgenv().VisualSettings.Forcefield.Transparency = v
        if getgenv().VisualSettings.Forcefield.Enabled then applyVisual("Forcefield") end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if getgenv().VisualSettings.Forcefield.Enabled then applyVisual("Forcefield") end
end)

getgenv().lockpickHBEEnabled = false

miscLeft:CreateToggle({
    name = "Lockpick HBE",
    default = false,
    callback = function(s)
        getgenv().lockpickHBEEnabled = s
    end
})
getgenv().JumpPowerValue = 100
getgenv().JumpPowerEnabled = false

miscRight:CreateToggle({
    name = "Jump Power",
    default = false,
    callback = function(state)
        getgenv().JumpPowerEnabled = state
    end
})

miscRight:CreateSlider({
    name = "Jump Power Value",
    min = 50,
    max = 300,
    default = 100,
    callback = function(v)
        getgenv().JumpPowerValue = v
    end
})

RunService.Heartbeat:Connect(function()
    if not getgenv().JumpPowerEnabled then return end
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().JumpPowerValue, hrp.Velocity.Z)
    end
end)

getgenv().RichShaderEnabled = false
local colorCorrection = nil

local shaderSection = miscTab:CreateSection({
    name = "Shader Settings",
    side = "Right",
    size = 250
})

shaderSection:CreateToggle({
    name = "Rich Shader",
    default = false,
    callback = function(state)
        getgenv().RichShaderEnabled = state
        if state then
            if not colorCorrection then
                colorCorrection = Instance.new("ColorCorrectionEffect")
                colorCorrection.Parent = game:GetService("Lighting")
            end
            colorCorrection.Enabled = true
        else
            if colorCorrection then
                colorCorrection:Destroy()
                colorCorrection = nil
            end
        end
    end
})

local brightnessLabel = shaderSection:CreateLabel({text = "Brightness"})
shaderSection:CreateSlider({
    min = -1,
    max = 1,
    default = 0,
    callback = function(v)
        if colorCorrection then
            colorCorrection.Brightness = v
        end
    end
})

local contrastLabel = shaderSection:CreateLabel({text = "Contrast"})
shaderSection:CreateSlider({
    min = -1,
    max = 1,
    default = 0,
    callback = function(v)
        if colorCorrection then
            colorCorrection.Contrast = v
        end
    end
})

local saturationLabel = shaderSection:CreateLabel({text = "Saturation"})
shaderSection:CreateSlider({
    min = -1,
    max = 1,
    default = 0,
    callback = function(v)
        if colorCorrection then
            colorCorrection.Saturation = v
        end
    end
})

local tintLabel = shaderSection:CreateLabel({text = "Tint Color"})
tintLabel:CreateColorpicker({
    default = Color3.new(1, 1, 1),
    callback = function(c)
        if colorCorrection then
            colorCorrection.TintColor = c
        end
    end
})
local legitTab = window:CreateTab("Legit")
local legitMainSection = legitTab:CreateSection({name = "Aim Settings", side = "Left", size = 200})
local legitFOVSection = legitTab:CreateSection({name = "FOV Settings", side = "Right", size = 250})
local legitVisualSection = legitTab:CreateSection({name = "Visual Settings", side = "Right", size = 250})

getgenv().Legitbot = {
    SilentAim = false,
    FOV = 120,
    ShowFOV = true,
    Tracers = {
        Enabled = false,
        Width = 1,
        Brightness = 5,
        LightEmission = 3,
        Color = Color3.fromRGB(255, 182, 193),
        Lifetime = 3
    }
}

local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local camera = workspace.CurrentCamera
local local_player = players.LocalPlayer

local script = {
    functions = {},
    locals = {
        silent_aim_target = nil,
        silent_aim_is_targetting = false
    }
}

script.functions.new_connection = function(type, func)
    return type:Connect(func)
end

script.functions.get_direction = function(origin, destination)
    return ((destination - origin).Unit * 1000)
end

script.functions.world_to_screen = function(position)
    local viewport_position, on_screen = camera:WorldToViewportPoint(position)
    return {position = Vector2.new(viewport_position.X, viewport_position.Y), on_screen = on_screen}
end

script.functions.has_character = function(player)
    return (player and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")) and true or false
end

script.functions.get_closest_player = function()
    local mouse_position = user_input_service:GetMouseLocation()
    local radius = math.huge
    local closest_player

    for _, player in players:GetPlayers() do
        if (player == local_player) then continue end
        if (not (script.functions.has_character(player))) then continue end

        local screen_position = script.functions.world_to_screen(player.Character.HumanoidRootPart.Position)
        if (not (screen_position.on_screen)) then continue end

        local distance = (mouse_position - screen_position.position).Magnitude
        if distance <= radius and distance <= getgenv().Legitbot.FOV then
            radius = distance
            closest_player = player
        end
    end

    return closest_player
end

local function createLegitTracer(st, ed)
    if not getgenv().Legitbot.Tracers.Enabled then return end
    
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "LegitTracerBeam"
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().Legitbot.Tracers.Color)
    beam.Width0 = getgenv().Legitbot.Tracers.Width
    beam.Width1 = getgenv().Legitbot.Tracers.Width
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = 1
    beam.Brightness = getgenv().Legitbot.Tracers.Brightness
    beam.LightEmission = getgenv().Legitbot.Tracers.LightEmission
    beam.FaceCamera = true
    
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")
    a0.WorldPosition = st
    a1.WorldPosition = ed
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    
    beam.Parent = tracerModel
    a0.Parent = tracerModel
    a1.Parent = tracerModel
    tracerModel.Parent = Workspace
    
    local tweenInfo = TweenInfo.new(
        getgenv().Legitbot.Tracers.Lifetime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(beam, tweenInfo, {
        Brightness = 0,
        LightEmission = 0
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        if tracerModel then 
            tracerModel:Destroy() 
        end
    end)
end

local function trackGlobalBullets()
    local bfr = workspace.Camera:FindFirstChild("Bullets")
    if not bfr then return end
    
    local function tblt(blt)
        if not blt:IsA("BasePart") then return end
        
        local stp = blt.Position
        local lsp = stp
        local stc = 0
        
        local con
        con = run_service.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if (lsp - stp).Magnitude > 1 then
                    createLegitTracer(stp, lsp)
                end
                return
            end
            
            local cp = blt.Position
            if (cp - lsp).Magnitude < 0.01 then
                stc = stc + 1
                if stc > 3 then
                    con:Disconnect()
                    if (cp - stp).Magnitude > 1 then
                        createLegitTracer(stp, cp)
                    end
                end
            else
                stc = 0
                lsp = cp
            end
        end)
    end
    
    bfr.ChildAdded:Connect(tblt)
    
    for _, v in ipairs(bfr:GetChildren()) do
        tblt(v)
    end
end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().Legitbot.ShowFOV
fovCircle.Radius = getgenv().Legitbot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

local silentAimHook
legitMainSection:CreateToggle({
    name = "Silent Aim",
    default = false,
    callback = function(state)
        getgenv().Legitbot.SilentAim = state
        
        if state and not silentAimHook then
            silentAimHook = hookmetamethod(game, "__namecall", function(self, ...)
                local args, method = {...}, tostring(getnamecallmethod())

                if (not checkcaller() and (script.locals.silent_aim_is_targetting and script.locals.silent_aim_target) and self == workspace and method == "Raycast") then
                    local origin = args[1]
                    args[2] = script.functions.get_direction(origin, script.locals.silent_aim_target.Character.HumanoidRootPart.Position)
                    return silentAimHook(self, unpack(args))
                end
                return silentAimHook(self, ...)
            end)
        end
    end
})

legitFOVSection:CreateSlider({
    name = "FOV",
    min = 10,
    max = 360,
    default = 120,
    callback = function(v)
        getgenv().Legitbot.FOV = v
        fovCircle.Radius = v
    end
})

local showFOVToggle = legitFOVSection:CreateToggle({
    name = "Show FOV",
    default = true,
    callback = function(state)
        getgenv().Legitbot.ShowFOV = state
        fovCircle.Visible = state
    end
})

local fovColorLabel = legitFOVSection:CreateLabel({text = "FOV Color"})
fovColorLabel:CreateColorpicker({
    default = Color3.fromRGB(255, 255, 255),
    callback = function(c)
        fovCircle.Color = c
    end
})

local tracerToggle = legitVisualSection:CreateToggle({
    name = "Visual bullet tracer (Global)",
    default = false,
    callback = function(state)
        getgenv().Legitbot.Tracers.Enabled = state
        if state then
            trackGlobalBullets()
        end
    end
})

local tracerWidthSlider = legitVisualSection:CreateSlider({
    name = "Tracer Width",
    min = 0.1,
    max = 5,
    default = 1,
    callback = function(v)
        getgenv().Legitbot.Tracers.Width = v
    end
})

local tracerBrightnessSlider = legitVisualSection:CreateSlider({
    name = "Tracer Brightness",
    min = 1,
    max = 10,
    default = 5,
    callback = function(v)
        getgenv().Legitbot.Tracers.Brightness = v
    end
})

local tracerColorLabel = legitVisualSection:CreateLabel({text = "Tracer Color"})
tracerColorLabel:CreateColorpicker({
    default = Color3.fromRGB(255, 182, 193),
    callback = function(c)
        getgenv().Legitbot.Tracers.Color = c
    end
})

script.functions.new_connection(run_service.RenderStepped, function()
    local new_target = script.functions.get_closest_player()
    script.locals.silent_aim_is_targetting = new_target and true or false
    script.locals.silent_aim_target = new_target or nil
    
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)
