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

local AUIFont = Font.new(getcustomasset and getcustomasset("aui/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

local hitNotifications = {}
local notificationYOffset = 10

local function createHitNotification(toolName, offsetValue, playerName)
    if not getgenv().CONFIG.Ragebot.HitNotify then return end
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
    ScreenGui.Name = "HitNotifications"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local box = Instance.new("Frame")
    box.Parent = ScreenGui
    box.BackgroundColor3 = Color3.new(0, 0, 0)
    box.BackgroundTransparency = 0.5
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(0, 0)
    box.Position = UDim2.new(0, 10, 0, -50)
    
    local parts = {
        {"Using ", Color3.fromRGB(255, 255, 255)},
        {toolName.." ", getgenv().CONFIG.Ragebot.HitColor},
        {"On ", Color3.fromRGB(255, 255, 255)},
        {string.format("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},
        {"in the ", Color3.fromRGB(255, 255, 255)},
        {"head ", getgenv().CONFIG.Ragebot.HitColor},
        {"to hit ", Color3.fromRGB(255, 255, 255)},
        {playerName, getgenv().CONFIG.Ragebot.HitColor}
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
        label.FontFace = AUIFont
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
    
    local notificationIndex = #hitNotifications + 1
    local targetY = notificationYOffset + ((notificationIndex - 1) * (maxH + 8 + 5))
    
    table.insert(hitNotifications, {box = box, index = notificationIndex})
    
    for i, notif in ipairs(hitNotifications) do
        notif.index = i
        notif.box.Position = UDim2.new(0, 10, 0, notificationYOffset + ((i - 1) * (notif.box.AbsoluteSize.Y + 5)))
    end
    
    local slideInTween = TweenService:Create(
        box,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 10, 0, notificationYOffset + ((notificationIndex - 1) * (maxH + 8 + 5)))}
    )
    slideInTween:Play()
    
    task.delay(getgenv().CONFIG.Ragebot.HitNotifyDuration, function()
        for i, notif in ipairs(hitNotifications) do
            if notif.box == box then
                table.remove(hitNotifications, i)
                break
            end
        end
        
        if box then 
            local slideOutTween = TweenService:Create(
                box,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(0, 10, 0, -50)}
            )
            slideOutTween:Play()
            slideOutTween.Completed:Wait()
            box:Destroy() 
        end
        
        for i, notif in ipairs(hitNotifications) do
            notif.box.Position = UDim2.new(0, 10, 0, notificationYOffset + ((i - 1) * (notif.box.AbsoluteSize.Y + 5)))
        end
    end)
end

local function playHitSound()
    if not getgenv().CONFIG.Ragebot.HitSound then return end
    
    local soundIds = {
        ["skeet"] = "rbxassetid://4817809188",
        ["xp level"] = "rbxassetid://17148249625",
        ["bell"] = "rbxassetid://6534948092"
    }
    
    local soundId = soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound] or soundIds["skeet"]
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Parent = Workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 3)
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
    if not getgenv().CONFIG.Ragebot.AutoReload then return end
    
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

local function canSeeTarget(targetPart)
    if not getgenv().CONFIG.Ragebot.VisibilityCheck then return true end
    
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
        
        if getgenv().CONFIG.Ragebot.UseWhitelist and table.find(getgenv().Lists.Whitelist, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.UseTargetList and not table.find(getgenv().Lists.TargetList, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
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
        
                if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                
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
local cachedBestPositions = {
local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local target = getClosestTarget()
    if not target then 
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    if cachedBestPositions.shootPos and cachedBestPositions.target == target then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        
        local path1 = checkClearPath(localHead.Position, cachedBestPositions.shootPos)
        local path2 = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
        
        if path1 and path2 then
            return cachedBestPositions.shootPos, cachedBestPositions.hitPos
        end
    end
    
    local startPos = localHead.Position
    local targetPos = target.Position
    
    if not getgenv().CONFIG.Ragebot.Wallbang then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not directRay then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end
    
    local bestShootPos = nil
    local bestHitPos = nil
    local bestScore = math.huge
    
    for i = 1, 150 do
        local shootOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
        )
        local shootPos = startPos + shootOffset
        
        local hitOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
        )
        local hitPos = targetPos + hitOffset
        
        local pathToShoot = checkClearPath(startPos, shootPos)
        local pathToTarget = checkClearPath(shootPos, hitPos)
    
        if pathToShoot and pathToTarget then
            local shootDistance = (shootPos - startPos).Magnitude
            local hitDistance = (hitPos - targetPos).Magnitude
            local totalScore = shootDistance + hitDistance
            
            if totalScore < bestScore then
                bestScore = totalScore
                bestShootPos = shootPos
                bestHitPos = hitPos
            end
        end
    end
    
    if not bestShootPos then
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    cachedBestPositions.shootPos = bestShootPos
    cachedBestPositions.hitPos = bestHitPos
    cachedBestPositions.target = target
    
    return bestShootPos, bestHitPos
end



local function createTracer(startPos, endPos)
    if not getgenv().CONFIG.Ragebot.Tracers then return end
    
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "TracerBeam"
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().CONFIG.Ragebot.TracerColor)
    beam.Width0 = getgenv().CONFIG.Ragebot.TracerWidth
    beam.Width1 = getgenv().CONFIG.Ragebot.TracerWidth
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
        getgenv().CONFIG.Ragebot.TracerLifetime,
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

local function RandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset))
    end
    return result
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
  
    if getgenv().CONFIG.Ragebot.Prediction then
        local velocity = targetHead.Velocity or Vector3.zero
        hitPosition = hitPosition + velocity * getgenv().CONFIG.Ragebot.PredictionAmount
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
        playHitSound()
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
    if not getgenv().CONFIG.Ragebot.Enabled then return end
    if not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild("Head") then return end
    
    local target = getClosestTarget()
    if not target then return end
    
    if getgenv().CONFIG.Ragebot.RapidFire then
        while getgenv().CONFIG.Ragebot.RapidFire and getgenv().CONFIG.Ragebot.Enabled and target do
            shootAtTarget(target)
            task.wait()
        end
    else
        local currentTime = tick()
        local waitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
        if currentTime - lastShotTime >= waitTime then
            shootAtTarget(target)
            --wait()
            --shootAtTarget(target)
            lastShotTime = currentTime
        end
    end
end)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV
fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV and getgenv().CONFIG.Ragebot.Enabled
    fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local function enableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end
    
    getgenv().CONFIG.Misc.SpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        
        if humanoid.MoveDirection.Magnitude > 0 then
            local head = character:FindFirstChild("Head")
            if not head then return end
            
            local lookVector = head.CFrame.LookVector
            local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
            
            hrp.Velocity = moveDirection * getgenv().CONFIG.Misc.SpeedValue + Vector3.new(0, hrp.Velocity.Y, 0)
        else
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end)
end

local function disableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
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
    
    getgenv().CONFIG.Misc.FOVConnection = game:GetService("RunService").Heartbeat:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
end

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
    local torso = game.Players.LocalPlayer.Character:FindFirstChild("Torso") or game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")
    if not head or not torso then return end
    local neckMotor = Instance.new("Motor6D")
    neckMotor.Name = "Neck"
    neckMotor.Part0 = torso
    neckMotor.Part1 = head
    neckMotor.C0 = CFrame.new(0, -0.5, 0.5)
    neckMotor.Parent = head
    head.LocalTransparencyModifier = 0
    for _, accessory in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then handle.LocalTransparencyModifier = 0 end
        end
    end
end

local function showHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    local neckMotor = head:FindFirstChild("Neck")
    if neckMotor then neckMotor:Destroy() end
    head.LocalTransparencyModifier = 0
    for _, accessory in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then handle.LocalTransparencyModifier = 0 end
        end
    end
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

local VisualizeObjects = {}

local function getHealthColor(health, maxHealth)
    local percent = health / maxHealth
    if percent > 0.5 then
        return Color3.fromRGB(50, 255, 50)
    elseif percent > 0.25 then
        return Color3.fromRGB(255, 255, 50)
    else
        return Color3.fromRGB(255, 50, 50)
    end
end

local function calculateDistance(pos1, pos2)
    return math.floor((pos1 - pos2).Magnitude)
end

local function makeVisualize(player)
    if player == LocalPlayer then return end
    
    local function setupVisualize(character)
        if not character then return end
        if VisualizeObjects[player] then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not humanoid or not root then return end
        
        local visualizeData = {}
        VisualizeObjects[player] = visualizeData
        
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.FillTransparency = 1
        highlight.OutlineColor = getgenv().CONFIG.Visualize.ESP.OutlineColor
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
        highlight.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled
        
        visualizeData.highlight = highlight
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 0
                box.Size = part.Size
                box.Color3 = getgenv().CONFIG.Visualize.ESP.BoxColor
                box.Transparency = 0.9
                box.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                box.Parent = part
                
                if not visualizeData.boxes then visualizeData.boxes = {} end
                table.insert(visualizeData.boxes, box)
            end
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "VisualizeTag"
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = getgenv().CONFIG.Visualize.ESP.MaxDistance
        billboard.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "VisualizeText"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Position = UDim2.new(0, 0, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = getgenv().CONFIG.Visualize.ESP.TextColor
        textLabel.TextSize = 14
        textLabel.TextStrokeTransparency = 0.5
        textLabel.FontFace = Font.new("rbxassetid://12187371840")
        textLabel.Parent = billboard
        textLabel.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
        
        billboard.Parent = character
        
        visualizeData.billboard = billboard
        visualizeData.textLabel = textLabel
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not character or not humanoid or not humanoid.Parent or humanoid.Health <= 0 then
                if visualizeData.highlight then visualizeData.highlight:Destroy() end
                if visualizeData.boxes then
                    for _, box in pairs(visualizeData.boxes) do
                        box:Destroy()
                    end
                end
                if visualizeData.billboard then visualizeData.billboard:Destroy() end
                if connection then connection:Disconnect() end
                VisualizeObjects[player] = nil
                return
            end
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = calculateDistance(LocalPlayer.Character.HumanoidRootPart.Position, root.Position)
                if distance > getgenv().CONFIG.Visualize.ESP.MaxDistance then
                    if visualizeData.highlight then visualizeData.highlight.Enabled = false end
                    if visualizeData.billboard then visualizeData.billboard.Enabled = false end
                    if visualizeData.boxes then
                        for _, box in pairs(visualizeData.boxes) do
                            box.Visible = false
                        end
                    end
                else
                    if visualizeData.highlight then visualizeData.highlight.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled end
                    if visualizeData.billboard then visualizeData.billboard.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled end
                    if visualizeData.boxes then
                        for _, box in pairs(visualizeData.boxes) do
                            box.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                        end
                    end
                end
                
                local healthColor = getHealthColor(humanoid.Health, humanoid.MaxHealth)
                local healthText = tostring(math.floor(humanoid.Health))
                
                if visualizeData.textLabel then
                    visualizeData.textLabel.Text = string.format("%s 丨 %s 丨 %s studs", player.Name, healthText, distance)
                    visualizeData.textLabel.TextColor3 = healthColor
                    visualizeData.textLabel.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                end
            end
        end)
    end
    
    if player.Character then
        setupVisualize(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        setupVisualize(character)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    makeVisualize(player)
end

Players.PlayerAdded:Connect(function(player)
    makeVisualize(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if VisualizeObjects[player] then
        local visualizeData = VisualizeObjects[player]
        if visualizeData.highlight then visualizeData.highlight:Destroy() end
        if visualizeData.boxes then
            for _, box in pairs(visualizeData.boxes) do
                box:Destroy()
            end
        end
        if visualizeData.billboard then visualizeData.billboard:Destroy() end
        VisualizeObjects[player] = nil
    end
end)

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
--[[
local ArrowIndicators = {}

local function GetRelative(pos, char)
    if not char then return Vector2.new(0,0) end

    local rootP = char.PrimaryPart.Position
    local camP = Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)

    return Vector2.new(relative.X, relative.Z)
end

local function RelativeToCenter(v)
    return Camera.ViewportSize/2 - v
end

local function RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)

    return Vector2.new(x, y)
end

local function AntiA(v)
    if (not getgenv().CONFIG.Visualize.ArrowAA) then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

local function DrawTriangleLines(color)
    local line1 = Drawing.new("Line")
    local line2 = Drawing.new("Line")
    local line3 = Drawing.new("Line")
    
    line1.Visible = false
    line2.Visible = false
    line3.Visible = false
    
    line1.Color = color
    line2.Color = color
    line3.Color = color
    
    line1.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    line2.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    line3.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    
    line1.Transparency = 0
    line2.Transparency = 0
    line3.Transparency = 0
    
    return {line1, line2, line3}
end

local function UpdateTriangleLines(lines, pointA, pointB, pointC)
    lines[1].From = pointA
    lines[1].To = pointB
    
    lines[2].From = pointB
    lines[2].To = pointC
    
    lines[3].From = pointC
    lines[3].To = pointA
end

local function ShowArrow(PLAYER)
    local lines = DrawTriangleLines(getgenv().CONFIG.Visualize.ArrowColor)

    local function Update()
        local c
        c = RunService.RenderStepped:Connect(function()
            if PLAYER and PLAYER.Character then
                local CHAR = PLAYER.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")

                if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                    local _,vis = Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if vis == false then
                        local rel = GetRelative(CHAR.PrimaryPart.Position, LocalPlayer.Character)
                        local direction = rel.Unit

                        local base  = direction * getgenv().CONFIG.Visualize.ArrowDistance
                        local sideLength = getgenv().CONFIG.Visualize.ArrowSize/2
                        local baseL = base + RotateVect(direction, 90) * sideLength
                        local baseR = base + RotateVect(direction, -90) * sideLength

                        local tip = direction * (getgenv().CONFIG.Visualize.ArrowDistance + getgenv().CONFIG.Visualize.ArrowSize)
                        
                        local pointA = AntiA(RelativeToCenter(baseL))
                        local pointB = AntiA(RelativeToCenter(baseR))
                        local pointC = AntiA(RelativeToCenter(tip))

                        UpdateTriangleLines(lines, pointA, pointB, pointC)
                        
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

                if not PLAYER or not PLAYER.Parent then
                    lines[1]:Remove()
                    lines[2]:Remove()
                    lines[3]:Remove()
                    if c then c:Disconnect() end
                end
            end
        end)
    end

    ArrowIndicators[PLAYER] = {lines = lines, connection = coroutine.wrap(Update)()}
end

local function RemoveArrow(player)
    if ArrowIndicators[player] then
        local indicator = ArrowIndicators[player]
        for _, line in ipairs(indicator.lines) do
            line:Remove()
        end
        ArrowIndicators[player] = nil
    end
end

local function UpdateAllArrows()
    for player, indicator in pairs(ArrowIndicators) do
        RemoveArrow(player)
        if player ~= LocalPlayer and getgenv().CONFIG.Visualize.ArrowEnabled then
            ShowArrow(player)
        end
    end
end

local function SetupArrows()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ShowArrow(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            ShowArrow(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        RemoveArrow(player)
    end)
end
--]]
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/hi.lua"))()

local window = library:window({name = "skeet.cc", size = UDim2.new(0, 650, 0, 580)})

local UI = {}

function UI:CreateElement(type, parent, options)
    local element = nil
    
    if type == "tab" then
        element = parent:tab(options)
    elseif type == "column" then
        element = parent:column(options)
    elseif type == "section" then
        element = parent:section(options)
    elseif type == "toggle" then
        element = parent:addToggle(options)
    elseif type == "slider" then
        element = parent:addSlider(options)
    elseif type == "list" then
        element = parent:addList(options)
    elseif type == "colorpicker" then
        element = parent:addColorpicker(options)
    elseif type == "textbox" then
        element = parent:addTextbox(options)
    elseif type == "button" then
        element = parent:addButton(options)
    end
    
    return element
end

local tab_rage = UI:CreateElement("tab", window, {name = "rage"})
local column1_rage = UI:CreateElement("column", tab_rage, {fill = true})
local column2_rage = UI:CreateElement("column", tab_rage, {fill = true})

local section_rage_left = UI:CreateElement("section", column1_rage, {name = "ragebot"})
UI:CreateElement("toggle", section_rage_left, {name = "enable", flag = "rage_enable", default = false, callback = function(value) getgenv().CONFIG.Ragebot.Enabled = value end})
UI:CreateElement("toggle", section_rage_left, {name = "rapid fire", flag = "rage_rapidfire", default = false, callback = function(value) getgenv().CONFIG.Ragebot.RapidFire = value end})
UI:CreateElement("toggle", section_rage_left, {name = "hit sound", flag = "rage_hitsound", default = true, callback = function(value) getgenv().CONFIG.Ragebot.HitSound = value end})
UI:CreateElement("toggle", section_rage_left, {name = "auto reload", flag = "rage_autoreload", default = true, callback = function(value) getgenv().CONFIG.Ragebot.AutoReload = value end})
UI:CreateElement("slider", section_rage_left, {name = "fire rate", flag = "rage_firerate", min = 1, max = 1000, default = 30, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.FireRate = value end})
UI:CreateElement("slider", section_rage_left, {name = "shoot range", flag = "rage_shootrange", min = 1, max = 30, default = 15, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.ShootRange = value end})
UI:CreateElement("slider", section_rage_left, {name = "hit range", flag = "rage_hitrange", min = 1, max = 30, default = 15, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.HitRange = value end})
UI:CreateElement("list", section_rage_left, {name = "hit sound", flag = "rage_hitsoundlist", items = {"skeet", "xp level", "bell"}, default = "skeet", callback = function(value) getgenv().CONFIG.Ragebot.SelectedHitSound = value end})

local section_targeting = UI:CreateElement("section", column2_rage, {name = "targeting"})
UI:CreateElement("toggle", section_targeting, {name = "team check", flag = "rage_teamcheck", default = false, callback = function(value) getgenv().CONFIG.Ragebot.TeamCheck = value end})
UI:CreateElement("toggle", section_targeting, {name = "visibility check", flag = "rage_visibilitycheck", default = true, callback = function(value) getgenv().CONFIG.Ragebot.VisibilityCheck = value end})
UI:CreateElement("toggle", section_targeting, {name = "wallbang", flag = "rage_wallbang", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Wallbang = value end})
UI:CreateElement("slider", section_targeting, {name = "fov", flag = "rage_fov", min = 10, max = 360, default = 120, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.FOV = value end})
UI:CreateElement("toggle", section_targeting, {name = "show fov", flag = "rage_showfov", default = true, callback = function(value) getgenv().CONFIG.Ragebot.ShowFOV = value end})
UI:CreateElement("toggle", section_targeting, {name = "downed check", flag = "rage_downcheck", default = false, callback = function(value) getgenv().CONFIG.Ragebot.LowHealthCheck = value end})

local section_combat_left = UI:CreateElement("section", column1_rage, {name = "aim settings"})
UI:CreateElement("toggle", section_combat_left, {name = "prediction", flag = "rage_prediction", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Prediction = value end})
UI:CreateElement("slider", section_combat_left, {name = "prediction amount", flag = "rage_predictionamount", min = 0.05, max = 0.3, default = 0.12, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.PredictionAmount = value end})

local section_visuals_left = UI:CreateElement("section", column1_rage, {name = "tracers"})
UI:CreateElement("toggle", section_visuals_left, {name = "tracers", flag = "rage_tracers", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Tracers = value end})
UI:CreateElement("slider", section_visuals_left, {name = "tracer width", flag = "rage_tracerwidth", min = 0.1, max = 5, default = 1, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.TracerWidth = value end})
UI:CreateElement("slider", section_visuals_left, {name = "tracer lifetime", flag = "rage_tracerlife", min = 0.5, max = 10, default = 3, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.TracerLifetime = value end})

local section_visuals_right = UI:CreateElement("section", column2_rage, {name = "colors"})
UI:CreateElement("colorpicker", section_visuals_right, {name = "tracer color", flag = "rage_tracercolor", default = Color3.fromRGB(255, 0, 0), callback = function(value) getgenv().CONFIG.Ragebot.TracerColor = value end})
UI:CreateElement("colorpicker", section_visuals_right, {name = "hit notification color", flag = "rage_hitcolor", default = Color3.fromRGB(255, 182, 193), callback = function(value) getgenv().CONFIG.Ragebot.HitColor = value end})

local section_notify = UI:CreateElement("section", column2_rage, {name = "notifications"})
UI:CreateElement("toggle", section_notify, {name = "hit notify", flag = "rage_hitnotify", default = true, callback = function(value) getgenv().CONFIG.Ragebot.HitNotify = value end})
UI:CreateElement("slider", section_notify, {name = "hit notify duration", flag = "rage_hitduration", min = 1, max = 10, default = 5, suffix = "s", callback = function(value) getgenv().CONFIG.Ragebot.HitNotifyDuration = value end})

local tab_misc = UI:CreateElement("tab", window, {name = "miscellaneous"})
local column1_misc = UI:CreateElement("column", tab_misc, {fill = true})
local column2_misc = UI:CreateElement("column", tab_misc, {fill = true})

local section_movement = UI:CreateElement("section", column1_misc, {name = "movement"})
UI:CreateElement("toggle", section_movement, {name = "speed", flag = "misc_speed", default = false, callback = function(value) getgenv().CONFIG.Misc.SpeedEnabled = value if value then enableSpeed() else disableSpeed() end end})
UI:CreateElement("slider", section_movement, {name = "speed value", flag = "misc_speedvalue", min = 10, max = 200, default = 50, suffix = "", callback = function(value) getgenv().CONFIG.Misc.SpeedValue = value end})
UI:CreateElement("toggle", section_movement, {name = "jump power", flag = "misc_jumpower", default = false, callback = function(value) getgenv().CONFIG.Misc.JumpPowerEnabled = value if value then enableJumpPower() else disableJumpPower() end end})
UI:CreateElement("slider", section_movement, {name = "jump power value", flag = "misc_jumpvalue", min = 50, max = 300, default = 100, suffix = "", callback = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end})

local section_visual = UI:CreateElement("section", column1_misc, {name = "visual"})
UI:CreateElement("toggle", section_visual, {name = "loop fov", flag = "misc_loopfov", default = false, callback = function(value) getgenv().CONFIG.Misc.LoopFOVEnabled = value if value then enableLoopFOV() else disableLoopFOV() end end})
UI:CreateElement("toggle", section_visual, {name = "hide head", flag = "misc_hidehead", default = false, callback = function(value) getgenv().CONFIG.Misc.HideHeadEnabled = value if value then hideHeadFE() else showHeadFE() end end})

local section_other = UI:CreateElement("section", column2_misc, {name = "other"})
UI:CreateElement("toggle", section_other, {name = "inf stamina", flag = "misc_infstamina", default = false, callback = function(value) getgenv().CONFIG.Misc.InfStaminaEnabled = value if value then enableInfStamina() else disableInfStamina() end end})
UI:CreateElement("toggle", section_other, {name = "no fall damage", flag = "misc_nofall", default = false, callback = function(value) getgenv().CONFIG.Misc.NoFallDmgEnabled = value if value then enableNoFallDmg() else disableNoFallDmg() end end})

local tab_visualize = UI:CreateElement("tab", window, {name = "visualize"})
local column1_visualize = UI:CreateElement("column", tab_visualize, {fill = true})
local column2_visualize = UI:CreateElement("column", tab_visualize, {fill = true})

local section_esp = UI:CreateElement("section", column1_visualize, {name = "ESP"})
UI:CreateElement("toggle", section_esp, {name = "enable esp", flag = "visualize_esp_enabled", default = false, callback = function(value) getgenv().CONFIG.Visualize.ESP.Enabled = value for player, visualizeData in pairs(VisualizeObjects) do if visualizeData.highlight then visualizeData.highlight.Enabled = value end if visualizeData.billboard then visualizeData.billboard.Enabled = value end if visualizeData.textLabel then visualizeData.textLabel.Visible = value end if visualizeData.boxes then for _, box in pairs(visualizeData.boxes) do box.Visible = value end end end end})
UI:CreateElement("colorpicker", section_esp, {name = "box color", flag = "visualize_boxcolor", default = Color3.fromRGB(78, 150, 50), callback = function(value) getgenv().CONFIG.Visualize.ESP.BoxColor = value for player, visualizeData in pairs(VisualizeObjects) do if visualizeData.boxes then for _, box in pairs(visualizeData.boxes) do box.Color3 = value end end end end})
UI:CreateElement("colorpicker", section_esp, {name = "outline color", flag = "visualize_outlinecolor", default = Color3.fromRGB(78, 150, 50), callback = function(value) getgenv().CONFIG.Visualize.ESP.OutlineColor = value for player, visualizeData in pairs(VisualizeObjects) do if visualizeData.highlight then visualizeData.highlight.OutlineColor = value end end end})
UI:CreateElement("slider", section_esp, {name = "max distance", flag = "visualize_maxdistance", min = 100, max = 2000, default = 1000, suffix = " studs", callback = function(value) getgenv().CONFIG.Visualize.ESP.MaxDistance = value end})

local section_colors = UI:CreateElement("section", column2_visualize, {name = "colors"})
UI:CreateElement("colorpicker", section_colors, {name = "text color", flag = "visualize_textcolor", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().CONFIG.Visualize.ESP.TextColor = value for player, visualizeData in pairs(VisualizeObjects) do if visualizeData.textLabel then visualizeData.textLabel.TextColor3 = value end end end})

local section_forcefield = UI:CreateElement("section", column1_visualize, {name = "forcefield material"})
UI:CreateElement("toggle", section_forcefield, {name = "enable forcefield", flag = "visualize_forcefield_enabled", default = false, callback = function(value)
    getgenv().CONFIG.Visualize.LocalForcefieldEnabled = value
    if value then
        applyForcefieldToBodyParts()
    else
        removeForcefieldFromBodyParts()
    end
end})

UI:CreateElement("slider", section_forcefield, {name = "forcefield transparency", flag = "visualize_forcefield_transparency", min = 0, max = 1, default = 0.5, suffix = "", callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldTransparency = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

UI:CreateElement("colorpicker", section_forcefield, {name = "forcefield color", flag = "visualize_forcefield_color", default = Color3.fromRGB(255, 255, 255), callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldColor = value
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


local section_arrow = UI:CreateElement("section", column2_visualize, {name = "arrow indicators"})

UI:CreateElement("toggle", section_arrow, {name = "enable arrow indicators", flag = "visualize_arrow_enabled", default = false, callback = function(value)
    Arrow:Enable(value)
end})

UI:CreateElement("colorpicker", section_arrow, {name = "arrow color", flag = "visualize_arrow_color", default = Color3.fromRGB(255, 255, 255), callback = function(value)
    Arrow.TriangleColor = value
    Arrow:UpdateSettings()
end})

UI:CreateElement("slider", section_arrow, {name = "arrow distance", flag = "visualize_arrow_distance", min = 50, max = 200, default = 80, suffix = "", callback = function(value)
    Arrow.DistFromCenter = value
end})

UI:CreateElement("slider", section_arrow, {name = "arrow size", flag = "visualize_arrow_size", min = 8, max = 32, default = 16, suffix = "", callback = function(value)
    Arrow.TriangleHeight = value
    Arrow.TriangleWidth = value
end})

UI:CreateElement("slider", section_arrow, {name = "arrow thickness", flag = "visualize_arrow_thickness", min = 1, max = 5, default = 1, suffix = "", callback = function(value)
    Arrow.TriangleThickness = value
    Arrow:UpdateSettings()
end})

UI:CreateElement("toggle", section_arrow, {name = "anti aliasing", flag = "visualize_arrow_aa", default = false, callback = function(value)
    Arrow.AntiAliasing = value
end})

local tab_lists = UI:CreateElement("tab", window, {name = "lists"})
local column1_lists = UI:CreateElement("column", tab_lists, {fill = true})
local column2_lists = UI:CreateElement("column", tab_lists, {fill = true})

local section_targetlist = UI:CreateElement("section", column1_lists, {name = "target list"})
UI:CreateElement("textbox", section_targetlist, {name = "add to target list", placeholder = "player name", callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.TargetList, text) end end})
UI:CreateElement("button", section_targetlist, {name = "clear target list", callback = function() getgenv().Lists.TargetList = {} end})

local section_whitelist = UI:CreateElement("section", column2_lists, {name = "whitelist"})
UI:CreateElement("textbox", section_whitelist, {name = "add to whitelist", placeholder = "player name", callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.Whitelist, text) end end})
UI:CreateElement("button", section_whitelist, {name = "clear whitelist", callback = function() getgenv().Lists.Whitelist = {} end})

local section_controls = UI:CreateElement("section", column1_lists, {name = "controls"})
UI:CreateElement("toggle", section_controls, {name = "use target list", flag = "lists_usetargetlist", default = false, callback = function(value) getgenv().CONFIG.Ragebot.UseTargetList = value end})
UI:CreateElement("toggle", section_controls, {name = "use whitelist", flag = "lists_usewhitelist", default = false, callback = function(value) getgenv().CONFIG.Ragebot.UseWhitelist = value end})
local tab_config = UI:CreateElement("tab", window, {name = "configuration"})
local column1_config = UI:CreateElement("column", tab_config, {fill = true})
local column2_config = UI:CreateElement("column", tab_config, {fill = true})

local section_save = UI:CreateElement("section", column1_config, {name = "save/load"})

UI:CreateElement("button", section_save, {name = "save config", callback = function()
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

UI:CreateElement("button", section_save, {name = "load config", callback = function()
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

UI:CreateElement("button", section_save, {name = "reset to default", callback = function()
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

local section_manage = UI:CreateElement("section", column2_config, {name = "manage"})

UI:CreateElement("textbox", section_manage, {name = "config name", placeholder = "enter config name", callback = function(text)
    getgenv().currentConfigName = text
end})

UI:CreateElement("button", section_manage, {name = "save as preset", callback = function()
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

UI:CreateElement("button", section_manage, {name = "delete preset", callback = function()
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

local section_list = UI:CreateElement("section", column2_config, {name = "presets list"})

UI:CreateElement("button", section_list, {name = "refresh presets", callback = function()
    local presetButtons = {}
    
    if isfile then
        for _, file in pairs(listfiles("")) do
            if file:find("aui_preset_") and file:find("%.json$") then
                local name = file:match("aui_preset_(.+)%.json")
                local btn = UI:CreateElement("button", section_list, {
                    name = name,
                    callback = function()
                        if readfile then
                            local success, data = pcall(function()
                                return game:GetService("HttpService"):JSONDecode(readfile(file))
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
                                
                                warn("Preset loaded: " .. name)
                            end
                        end
                    end
                })
                table.insert(presetButtons, btn)
            end
        end
    end
    
    if #presetButtons == 0 then
        warn("No presets found")
    end
end})
