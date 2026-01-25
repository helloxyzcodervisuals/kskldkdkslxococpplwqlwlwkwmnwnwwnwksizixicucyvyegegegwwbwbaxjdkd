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
--why
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
        SelectedHitSound = "skeet",
        FriendCheck = false,
        MaxTarget = 0
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
    }
}

getgenv().Lists = {
    TargetList = {},
    Whitelist = {}
}

getgenv().Legit = {
    Enabled = false,
    HeadChance = 30,
    HitPart = "Torso",
    NoRecoil = true,
    AimAssist = false,
    AimAssistStrength = 0.3,
    Smoothing = 0.2
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local library, notifications, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/fuckyoucca.lua"))()

local dim2 = UDim2.new 
local hex = Color3.fromHex 

local window = library:window({
    name = os.date('<font color="rgb(170,85,235)">obelus</font> | %b %d %Y'),
    size = dim2(0, 516, 0, 563)
})

local function loadRagebot()
    if makefolder then
        makefolder("a")
        makefolder("a/fonts")
    end

    if not isfile or (isfile and not isfile("a/fonts/main.ttf")) then
        if writefile then
            writefile("a/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
        end
    end

    local font_data = {
        name = "AFont",
        faces = {
            {
                name = "Regular",
                weight = 400,
                style = "normal",
                assetId = getcustomasset and getcustomasset("a/fonts/main.ttf") or ""
            }
        }
    }

    if writefile and not isfile("a/fonts/main_encoded.ttf") then
        writefile("a/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
    end

    local AFont = Font.new(getcustomasset and getcustomasset("a/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

    local hitNotifications = {}
    local notificationYOffset = 5
    local MAX_VISIBLE_NOTIFICATIONS = 15

    local function createHitNotification(toolName, offsetValue, playerName)
        if not getgenv().CONFIG.Ragebot.HitNotify then return end
        
        local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
        ScreenGui.Name = "HitNotifications"
        ScreenGui.Parent = game:GetService("CoreGui")
        
        local scrollFrame = ScreenGui:FindFirstChild("NotificationScroll") or Instance.new("ScrollingFrame")
        scrollFrame.Name = "NotificationScroll"
        scrollFrame.Parent = ScreenGui
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.Size = UDim2.new(0, 400, 0, 200)
        scrollFrame.Position = UDim2.new(0, 30, 0, 10)  
        scrollFrame.ScrollingEnabled = false
        scrollFrame.CanvasSize = UDim2.new(0, 400, 0, 0)
        scrollFrame.ScrollBarThickness = 0
        
        local box = Instance.new("Frame")
        box.Parent = scrollFrame
        box.BackgroundColor3 = Color3.new(0, 0, 0)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.AnchorPoint = Vector2.new(0, 0)
        
        local parts = {
            {"Using ", Color3.fromRGB(255, 255, 255)},
            {toolName.." ", getgenv().CONFIG.Ragebot.HitColor},
            {"On ", Color3.fromRGB(255, 255, 255)},
            {string.format("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},
            {"in the ", Color3.fromRGB(255, 255, 255)},
            {"head ", getgenv().CONFIG.Ragebot.HitColor},
            {"to hit ", Color3.fromRGB(255, 255, 255)},
            {playerName, getgenv().CONFIG.Ragebot.HitColor},
            {"on via cache", Color3.fromRGB(255, 255, 255)},
        }
        
        local offsetX = 8 
        local totalW, maxH = 0, 0
        
        for _, seg in ipairs(parts) do
            local txt, col = seg[1], seg[2]
            local label = Instance.new("TextLabel")
            label.Parent = box
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = col
            label.FontFace = AFont
            label.TextSize = 10
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.Text = txt
            label.AutomaticSize = Enum.AutomaticSize.XY
            label.Position = UDim2.new(0, offsetX, 0, 0)
            offsetX = offsetX + label.TextBounds.X
            totalW = offsetX
            maxH = math.max(maxH, label.TextBounds.Y)
        end
        
        box.Size = UDim2.new(0, totalW + 16, 0, maxH + 8) 
        
        table.insert(hitNotifications, {box = box, createTime = tick()})
        
        local totalHeight = 0
        for i, notif in ipairs(hitNotifications) do
            local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
            notif.box.Position = UDim2.new(0, 0, 0, yPos)  
            totalHeight = totalHeight + notif.box.AbsoluteSize.Y + 5
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 400, 0, totalHeight)
        
        local function updateScrollFrame()
            local allFrames = {}
            for _, notif in ipairs(hitNotifications) do
                if notif.box and notif.box.Parent then
                    table.insert(allFrames, notif)
                end
            end
            
            hitNotifications = allFrames
            
            local visibleCount = math.min(#hitNotifications, MAX_VISIBLE_NOTIFICATIONS)
            scrollFrame.CanvasSize = UDim2.new(0, 400, 0, visibleCount * (box.AbsoluteSize.Y + 5))
            
            for i, notif in ipairs(hitNotifications) do
                local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
                notif.box.Position = UDim2.new(0, 0, 0, yPos)
                
                if i <= MAX_VISIBLE_NOTIFICATIONS then
                    notif.box.Visible = true
                else
                    notif.box.Visible = false
                end
            end
        end
        
        updateScrollFrame()
        
        task.delay(getgenv().CONFIG.Ragebot.HitNotifyDuration, function()
            for i, notif in ipairs(hitNotifications) do
                if notif.box == box then
                    table.remove(hitNotifications, i)
                    box:Destroy()
                    break
                end
            end
            
            updateScrollFrame()
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
        sound.Volume = 0.75
        sound.Parent = Workspace
        sound:Play()
        
        game:GetService("Debris"):AddItem(sound, 0.75)
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
        local targetCount = 0
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            
            if getgenv().CONFIG.Ragebot.FriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then
                continue
            end
            
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
                    
                    if getgenv().CONFIG.Ragebot.MaxTarget > 0 then
                        targetCount = targetCount + 1
                        if targetCount > getgenv().CONFIG.Ragebot.MaxTarget then
                            break
                        end
                    end
                    
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
        
        if cachedBestPositions.shootPos and cachedBestPositions.target == target then
            local cachedShootDistance = (cachedBestPositions.shootPos - startPos).Magnitude
            local cachedHitDistance = (cachedBestPositions.hitPos - targetPos).Magnitude
            
            if cachedShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
               cachedHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
                
                local pathToShoot = checkClearPath(startPos, cachedBestPositions.shootPos)
                local pathToTarget = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
                
                if pathToShoot and pathToTarget then
                    local shootToHitRay = Workspace:Raycast(cachedBestPositions.shootPos, (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Unit * (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Magnitude, raycastParams)
                    if not shootToHitRay then
                        return cachedBestPositions.shootPos, cachedBestPositions.hitPos
                    end
                end
            end
            cachedBestPositions.shootPos = nil
            cachedBestPositions.hitPos = nil
        end
        
        local bestShootPos = nil
        local bestHitPos = nil
        local bestScore = math.huge
        
        for i = 1, 100 do
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
            
            local shootDistance = (shootPos - startPos).Magnitude
            local hitDistance = (hitPos - targetPos).Magnitude
            
            if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
                local pathToShoot = checkClearPath(startPos, shootPos)
                local pathToTarget = checkClearPath(shootPos, hitPos)
                
                if pathToShoot and pathToTarget then
                    local shootToHitRay = Workspace:Raycast(shootPos, (hitPos - shootPos).Unit * (hitPos - shootPos).Magnitude, raycastParams)
                    if not shootToHitRay then
                        local totalScore = shootDistance + hitDistance
                        
                        if totalScore < bestScore then
                            bestScore = totalScore
                            bestShootPos = shootPos
                            bestHitPos = hitPos
                        end
                    end
                end
            end
        end
        
        if not bestShootPos or not bestHitPos then
            local randomY = math.random(-16, -14)
            local fallbackShootPos = Vector3.new(startPos.X, randomY, startPos.Z)
            local fallbackHitPos = Vector3.new(targetPos.X, randomY, targetPos.Z)
            
            cachedBestPositions.shootPos = fallbackShootPos
            cachedBestPositions.hitPos = fallbackHitPos
            cachedBestPositions.target = target
            
            return fallbackShootPos, fallbackHitPos
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
        beam.Brightness = 2
        beam.LightEmission = 2
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

        
            GNX_S:FireServer(unpack(args1))
            ZFKLF__H:FireServer(unpack(args2))
        

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
        
        local currentTime = tick()
        local baseWaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 0.05)
        local WaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
        if getgenv().CONFIG.Ragebot.RapidFire then
            local rapidWaitTime = baseWaitTime * 0.01
            
            if currentTime - lastShotTime >= rapidWaitTime then
                shootAtTarget(target)
                lastShotTime = currentTime
            end
        else
            if currentTime - lastShotTime >= WaitTime then
                shootAtTarget(target)
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
end

local function loadMisc()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")

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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QuickUIScreen"
    ScreenGui.Parent = CoreGui
    QuickUIFrame.Parent = ScreenGui

    local speedEnabled = false
    local speedConnection = nil

    local function enableSpeed()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end

        speedConnection = RunService.RenderStepped:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end
            humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
        end)
    end

    local function disableSpeed()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end

        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 end
        end
    end

    local jumpPowerEnabled = false
    local jumpPowerConnection = nil

    local function enableJumpPower()
        if jumpPowerConnection then
            jumpPowerConnection:Disconnect()
            jumpPowerConnection = nil
        end
        
        jumpPowerConnection = RunService.Heartbeat:Connect(function()
            if not jumpPowerEnabled then return end
            if not LocalPlayer.Character then return end
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
            end
        end)
    end

    local function disableJumpPower()
        if jumpPowerConnection then
            jumpPowerConnection:Disconnect()
            jumpPowerConnection = nil
        end
    end

    local loopFOVEnabled = false
    local fovConnection = nil

    local function enableLoopFOV()
        if fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
        
        fovConnection = RunService.RenderStepped:Connect(function()
            workspace.CurrentCamera.FieldOfView = 120
        end)
    end

    local function disableLoopFOV()
        if fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
    end

    local hideHeadEnabled = false
    local char = nil
    local torso = nil
    local originalMotor6Ds = {}
    local renderConnection = nil
    local originalHook = nil

    local function hideHead()
        if not LocalPlayer.Character then return end
        
        char = LocalPlayer.Character
        torso = char:FindFirstChild("Torso")
        
        if not torso then return end
        
        originalMotor6Ds = {}
        for _, motor in pairs(char:GetDescendants()) do
            if motor:IsA("Motor6D") then
                originalMotor6Ds[motor] = {
                    Part0 = motor.Part0,
                    Part1 = motor.Part1,
                    C0 = motor.C0,
                    C1 = motor.C1
                }
            end
        end
        
        hideHeadEnabled = true
        
        if not originalHook then
            originalHook = hookmetamethod(game, "__namecall", function(self, ...)
                local methodName = getnamecallmethod()
                
                if tostring(methodName) == "FireServer" then
                    if self.Name == "MOVZREP" then
                        local fixedArguments = {
                            {
                                {
                                    Vector3.new(-5721.2001953125, -5, 971.5162353515625),
                                    Vector3.new(-4181.38818359375, -6, 11.123311996459961),
                                    Vector3.new(0.006237113382667303, -6, -0.18136750161647797),
                                    true,
                                    true,
                                    true,
                                    false
                                },
                                false,
                                false,
                                15.8
                            }
                        }
                        
                        return originalHook(self, table.unpack(fixedArguments))
                    end
                end
                
                return originalHook(self, ...)
            end)
        end
        
        if renderConnection then
            renderConnection:Disconnect()
        end
        
        renderConnection = RunService.RenderStepped:Connect(function()
            if torso and torso.Parent then
                for motor, originalData in pairs(originalMotor6Ds) do
                    if motor and motor.Parent then
                        motor.C0 = originalData.C0
                        motor.C1 = originalData.C1
                    end
                end

                local neck = torso:FindFirstChild("Neck")
                if neck and neck:IsA("Motor6D") then
                    neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    neck.C1 = CFrame.new(0, 0.5, 0)
                end
            else
                if renderConnection then
                    renderConnection:Disconnect()
                    renderConnection = nil
                end
            end
        end)
    end

    local noFallHook = nil

    local function enableNoFallDmg()
        if noFallHook then return end
        noFallHook = hookmetamethod(game, "__namecall", function(self, ...)
            local args = { ... }
            if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
                args[2] = 0
                args[3] = 0
            end
            return noFallHook(self, unpack(args))
        end)
    end

    local function disableNoFallDmg()
        if noFallHook then
            hookmetamethod(game, "__namecall", noFallHook)
            noFallHook = nil
        end
    end

    local infStaminaHook = nil

    local function enableInfStamina()
        if infStaminaHook then return end
        
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
                infStaminaHook = hookfunction(stamina, function() return 100, 100 end)
            end
        end
    end

    local function disableInfStamina()
        if infStaminaHook then
            hookfunction(stamina, infStaminaHook)
            infStaminaHook = nil
        end
    end

    local lockpickEnabled = false
    local lockpickAddedConnection = nil

    local function enableLockpick()
        lockpickEnabled = true
        
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return end
        
        local function lockpick(gui)
            for _, a in pairs(gui:GetDescendants()) do
                if a:IsA("ImageLabel") and a.Name == "Bar" and a.Parent.Name ~= "Attempts" then
                    local oldsize = a.Size
                    RunService.RenderStepped:Connect(function()
                        if lockpickEnabled then
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
    end

    local function disableLockpick()
        lockpickEnabled = false
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
            lockpickAddedConnection = nil
        end
    end

    local SafeESP = {
        Enabled = false,
        Safes = {},
        Visuals = {}
    }

    local function addSafeESP(model)
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
            
            if LocalPlayer and LocalPlayer.Character then
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and billboard.Adornee then
                    local distance = (humanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                    distanceLabel.Text = string.format("%d studs", math.floor(distance))
                    billboard.Enabled = distance <= 100
                end
            end
        end)
    end

    local function scanWorkspace()
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                    if not SafeESP.Safes[item] then
                        addSafeESP(item)
                    end
                end
            end
        end
    end

    local safeColor = Color3.fromRGB(255, 215, 0)

    local function enableSafeESP(value)
        SafeESP.Enabled = value
        
        if value then
            scanWorkspace()
            
            Workspace.DescendantAdded:Connect(function(item)
                if item:IsA("Model") then
                    local itemName = item.Name:lower()
                    if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                        task.wait(0.1)
                        addSafeESP(item)
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

    local function updateSafeColor(color)
        safeColor = color
        for model, visuals in pairs(SafeESP.Visuals) do
            if visuals.highlight then
                visuals.highlight.FillColor = color
            end
            if visuals.textLabel then
                visuals.textLabel.TextColor3 = color
            end
        end
    end

    local instantPromptEnabled = false
    local instantPromptConnection = nil

    local function enableInstantPrompt()
        instantPromptEnabled = true
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        
        if instantPromptConnection then
            instantPromptConnection:Disconnect()
        end
        
        instantPromptConnection = game.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                task.wait()
                obj.HoldDuration = 0
            end
        end)
    end

    local function disableInstantPrompt()
        instantPromptEnabled = false
        
        if instantPromptConnection then
            instantPromptConnection:Disconnect()
            instantPromptConnection = nil
        end
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 1
            end
        end
    end

    local autoDoorEnabled = false
    local doorConnection = nil

    local function enableAutoDoor()
        autoDoorEnabled = true
        
        if doorConnection then
            doorConnection:Disconnect()
        end
        
        doorConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local charRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not charRoot then return end
            
            local Map = Workspace:FindFirstChild("Map")
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
    end

    local function disableAutoDoor()
        autoDoorEnabled = false
        if doorConnection then
            doorConnection:Disconnect()
            doorConnection = nil
        end
    end

    local flyEnabled = false
    local flySpeed = 50
    local flyConnection = nil

    local function startFlying()
        local Char = LocalPlayer.Character
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
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled then
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
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
            
            local Cam = Workspace.CurrentCamera
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
                Root.Velocity = moveVector * flySpeed
                RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
            else
                Root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    local function disableFlying()
        flyEnabled = false
    end

    QuickUIText.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            QuickUIText.Text = "FLY ON"
            QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
            startFlying()
        else
            QuickUIText.Text = "FLY OFF"
            QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
            disableFlying()
        end
    end)

    return {
        toggleSpeed = function(state)
            speedEnabled = state
            if state then
                enableSpeed()
            else
                disableSpeed()
            end
        end,
        toggleJumpPower = function(state)
            jumpPowerEnabled = state
            if state then
                enableJumpPower()
            else
                disableJumpPower()
            end
        end,
        toggleLoopFOV = function(state)
            loopFOVEnabled = state
            if state then
                enableLoopFOV()
            else
                disableLoopFOV()
            end
        end,
        toggleHideHead = function(state)
            getgenv().CONFIG.Misc.HideHeadEnabled = state
            if state then
                hideHead()
            else
                print("l lazy do it:(")
            end
        end,
        toggleInfStamina = function(state)
            getgenv().CONFIG.Misc.InfStaminaEnabled = state
            if state then
                enableInfStamina()
            else
                disableInfStamina()
            end
        end,
        toggleNoFall = function(state)
            getgenv().CONFIG.Misc.NoFallDmgEnabled = state
            if state then
                enableNoFallDmg()
            else
                disableNoFallDmg()
            end
        end,
        toggleLockpick = function(state)
            if state then
                enableLockpick()
            else
                disableLockpick()
            end
        end,
        toggleSafeESP = function(state)
            enableSafeESP(state)
        end,
        updateSafeColor = updateSafeColor,
        toggleInstantPrompt = function(state)
            if state then
                enableInstantPrompt()
            else
                disableInstantPrompt()
            end
        end,
        toggleAutoDoor = function(state)
            if state then
                enableAutoDoor()
            else
                disableAutoDoor()
            end
        end,
        toggleFly = function(state)
            flyEnabled = state
            if state then
                QuickUIText.Text = "FLY ON"
                QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
                startFlying()
            else
                QuickUIText.Text = "FLY OFF"
                QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
                disableFlying()
            end
        end,
        setFlySpeed = function(value) flySpeed = value end,
        setSpeedValue = function(value) getgenv().CONFIG.Misc.SpeedValue = value end,
        setJumpValue = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end
    }
end

local silent_aim_active = false
local aim_target = nil
local aim_position = Vector3.new()

local function get_closest_target()
    local closest = nil
    local closest_dist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if humanoid and humanoid.Health > 0 and head then
            local dist = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
            
            if dist < closest_dist then
                closest_dist = dist
                closest = player
            end
        end
    end
    
    return closest
end

local function get_target_part(character)
    local should_head = math.random(1, 100) <= getgenv().Legit.HeadChance
    local part_name = should_head and "Head" or getgenv().Legit.HitPart
    
    local target_part = character:FindFirstChild(part_name)
    if not target_part and part_name == "Head" then
        target_part = character:FindFirstChild("Torso")
    end
    if not target_part then
        target_part = character:FindFirstChild("HumanoidRootPart")
    end
    
    return target_part
end

RunService.RenderStepped:Connect(function()
    if not getgenv().Legit.Enabled then
        silent_aim_active = false
        aim_target = nil
        return
    end
    
    local target = get_closest_target()
    
    silent_aim_active = target and true or false
    aim_target = target or nil
    
    if aim_target and aim_target.Character then
        local character = aim_target.Character
        local target_part = get_target_part(character)
        
        if target_part then
            aim_position = target_part.Position
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().Legit.AimAssist or not getgenv().Legit.Enabled or not aim_target or not aim_target.Character then
        return
    end
    
    local character = aim_target.Character
    local target_part = get_target_part(character)
    if not target_part then return end
    
    local screen_pos, on_screen = Camera:WorldToViewportPoint(target_part.Position)
    
    if on_screen then
        local screen_center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local target_screen_pos = Vector2.new(screen_pos.X, screen_pos.Y)
        
        local distance_to_center = (target_screen_pos - screen_center).Magnitude
        
        local max_screen_distance = 100
        
        if distance_to_center < max_screen_distance then
            local strength = getgenv().Legit.AimAssistStrength * (1 - (distance_to_center / max_screen_distance))
            local smoothing = getgenv().Legit.Smoothing
            
            local cam_pos = Camera.CFrame.Position
            local target_look = CFrame.lookAt(cam_pos, aim_position)
            
            local current_look = Camera.CFrame
            
            local lerped = current_look:Lerp(target_look, strength * (1 - smoothing))
            
            Camera.CFrame = CFrame.new(lerped.Position, aim_position)
        end
    end
end)

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if not checkcaller() and silent_aim_active and aim_target and self == Workspace and tostring(method) == "Raycast" then
        local origin = args[1]
        local direction = (aim_position - origin).Unit * 1000
        args[2] = direction
        return __namecall(self, unpack(args))
    end
    
    return __namecall(self, ...)
end)

local function apply_no_recoil()
    if not getgenv().Legit.NoRecoil then return end
    
    for _, config in pairs(getgc(true)) do
        if type(config) == "table" and rawget(config, "Recoil") then
            rawset(config, "Recoil", 0)
            rawset(config, "RecoilSpeed", 0)
            rawset(config, "AngleX_Min", 0)
            rawset(config, "AngleX_Max", 0)
            rawset(config, "AngleY_Min", 0)
            rawset(config, "AngleY_Max", 0)
        end
    end
    
    for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local config = tool:FindFirstChild("Config")
                if config and config:IsA("ModuleScript") then
                    local success, data = pcall(require, config)
                    if success and type(data) == "table" then
                        rawset(data, "Recoil", 0)
                        rawset(data, "RecoilSpeed", 0)
                        rawset(data, "AngleX_Min", 0)
                        rawset(data, "AngleX_Max", 0)
                        rawset(data, "AngleY_Min", 0)
                        rawset(data, "AngleY_Max", 0)
                    end
                end
            end
        end
    end
end

local misc = loadMisc()

local Rage = window:tab({name = "Rage"})
local Legit = window:tab({name = "Legit"})
local Visuals = window:tab({name = "Visuals"})
local Misc = window:tab({name = "Misc"})
local PlayersTab = window:tab({name = "Players"})
local Settings = window:tab({name = "Settings"})

local function setupRagebotTab()
    local column = Rage:column({fill = true})
    local section = column:section({name = "Ragebot Main"})
    
    section:addToggle({name = "Enable Ragebot", flag = "ragebot_enabled", callback = function(state)
        getgenv().CONFIG.Ragebot.Enabled = state
    end})
    
    section:addToggle({name = "Rapid Fire", flag = "ragebot_rapidfire", callback = function(state)
        getgenv().CONFIG.Ragebot.RapidFire = state
    end})
    
    section:addToggle({name = "Hit Sound", flag = "ragebot_hitsound", callback = function(state)
        getgenv().CONFIG.Ragebot.HitSound = state
    end})
    
    section:addToggle({name = "Auto Reload", flag = "ragebot_autoreload", callback = function(state)
        getgenv().CONFIG.Ragebot.AutoReload = state
    end})
    
    section:addSlider({name = "Fire Rate", min = 1, max = 1000, default = 30, suffix = " RPS", flag = "ragebot_firerate", callback = function(value)
        getgenv().CONFIG.Ragebot.FireRate = value
    end})
    
    section:addSlider({name = "Shoot Range", min = 1, max = 30, default = 15, flag = "ragebot_shootrange", callback = function(value)
        getgenv().CONFIG.Ragebot.ShootRange = value
    end})
    
    section:addSlider({name = "Hit Range", min = 1, max = 30, default = 15, flag = "ragebot_hitrange", callback = function(value)
        getgenv().CONFIG.Ragebot.HitRange = value
    end})
    
    section:addDropdown({name = "Hit Sound", flag = "ragebot_hitsoundlist", items = {"skeet", "xp level", "bell"}, default = "skeet", callback = function(value)
        getgenv().CONFIG.Ragebot.SelectedHitSound = value
    end})
    
    local column2 = Rage:column({fill = true})
    local section2 = column2:section({name = "Targeting"})
    
    section2:addToggle({name = "Team Check", flag = "ragebot_teamcheck", callback = function(state)
        getgenv().CONFIG.Ragebot.TeamCheck = state
    end})
    
    section2:addToggle({name = "Visibility Check", flag = "ragebot_visibilitycheck", callback = function(state)
        getgenv().CONFIG.Ragebot.VisibilityCheck = state
    end})
    
    section2:addToggle({name = "Wallbang", flag = "ragebot_wallbang", callback = function(state)
        getgenv().CONFIG.Ragebot.Wallbang = state
    end})
    
    section2:addSlider({name = "FOV", min = 10, max = 360, default = 120, flag = "ragebot_fov", callback = function(value)
        getgenv().CONFIG.Ragebot.FOV = value
    end})
    
    section2:addToggle({name = "Show FOV", flag = "ragebot_showfov", callback = function(state)
        getgenv().CONFIG.Ragebot.ShowFOV = state
    end})
    
    section2:addToggle({name = "Downed Check", flag = "ragebot_downcheck", callback = function(state)
        getgenv().CONFIG.Ragebot.LowHealthCheck = state
    end})
    
    section2:addToggle({name = "Friend Check", flag = "ragebot_friendcheck", callback = function(state)
        getgenv().CONFIG.Ragebot.FriendCheck = state
    end})
    
    local section3 = column:section({name = "Aim Settings"})
    
    section3:addToggle({name = "Prediction", flag = "ragebot_prediction", callback = function(state)
        getgenv().CONFIG.Ragebot.Prediction = state
    end})
    
    section3:addSlider({name = "Prediction Amount", min = 0.05, max = 0.3, default = 0.12, float = 0.01, flag = "ragebot_predictionamount", callback = function(value)
        getgenv().CONFIG.Ragebot.PredictionAmount = value
    end})
    
    local section4 = column2:section({name = "Tracers"})
    
    section4:addToggle({name = "Tracers", flag = "ragebot_tracers", callback = function(state)
        getgenv().CONFIG.Ragebot.Tracers = state
    end})
    
    local tracerToggle = section4:addToggle({name = "Tracers", flag = "ragebot_tracers", folding = true})
    tracerToggle:addColorPicker({name = "Tracer Color", flag = "ragebot_tracercolor", color = Color3.fromRGB(255, 0, 0), callback = function(color)
        getgenv().CONFIG.Ragebot.TracerColor = color
    end})
    
    section4:addSlider({name = "Tracer Width", min = 0.1, max = 5, default = 1, flag = "ragebot_tracerwidth", callback = function(value)
        getgenv().CONFIG.Ragebot.TracerWidth = value
    end})
    
    section4:addSlider({name = "Tracer Lifetime", min = 0.5, max = 100, default = 3, flag = "ragebot_tracerlife", callback = function(value)
        getgenv().CONFIG.Ragebot.TracerLifetime = value
    end})
    
    local section5 = column:section({name = "Notifications"})
    
    section5:addToggle({name = "Hit Notify", flag = "ragebot_hitnotify", callback = function(state)
        getgenv().CONFIG.Ragebot.HitNotify = state
    end})
    
    local hitNotifyToggle = section5:addToggle({name = "Hit Notify", flag = "ragebot_hitnotify", folding = true})
    hitNotifyToggle:addColorPicker({name = "Hit Color", flag = "ragebot_hitcolor", color = Color3.fromRGB(255, 182, 193), callback = function(color)
        getgenv().CONFIG.Ragebot.HitColor = color
    end})
    
    section5:addSlider({name = "Hit Notify Duration", min = 1, max = 10, default = 5, suffix = "s", flag = "ragebot_hitduration", callback = function(value)
        getgenv().CONFIG.Ragebot.HitNotifyDuration = value
    end})
    
    loadRagebot()
end

local function setupLegitTab()
    local column = Legit:column({fill = true})
    local section = column:section({name = "Legit Settings"})
    
    section:addToggle({name = "Enable Legit", flag = "legit_enable", callback = function(state)
        getgenv().Legit.Enabled = state
    end})
    
    section:addSlider({name = "Head Chance", min = 0, max = 100, default = 30, suffix = "%", flag = "legit_headchance", callback = function(value)
        getgenv().Legit.HeadChance = value
    end})
    
    section:addDropdown({name = "Hit Part", flag = "legit_hitpart", items = {"Head", "Torso", "Neck", "Random"}, default = "Torso", callback = function(selection)
        getgenv().Legit.HitPart = selection
    end})
    
    section:addToggle({name = "No Recoil", flag = "legit_norecoil", callback = function(state)
        getgenv().Legit.NoRecoil = state
        apply_no_recoil()
    end})
    
    section:addToggle({name = "Aim Assist", flag = "legit_aimassist", callback = function(state)
        getgenv().Legit.AimAssist = state
    end})
    
    section:addSlider({name = "Assist Strength", min = 0.1, max = 1.0, default = 0.3, float = 0.1, flag = "legit_assiststrength", callback = function(value)
        getgenv().Legit.AimAssistStrength = value
    end})
    
    section:addSlider({name = "Smoothing", min = 0.1, max = 0.8, default = 0.2, float = 0.05, flag = "legit_smoothing", callback = function(value)
        getgenv().Legit.Smoothing = value
    end})
end

local function setupMiscTab()
    local column = Misc:column({fill = true})
    local movementSection = column:section({name = "Movement"})
    
    movementSection:addToggle({name = "Speed", flag = "misc_speed", callback = function(state)
        misc.toggleSpeed(state)
    end})
    
    movementSection:addSlider({name = "Speed Value", min = 10, max = 200, default = 50, flag = "misc_speedvalue", callback = function(value)
        misc.setSpeedValue(value)
    end})
    
    movementSection:addToggle({name = "Jump Power", flag = "misc_jumppower", callback = function(state)
        misc.toggleJumpPower(state)
    end})
    
    movementSection:addSlider({name = "Jump Power Value", min = 50, max = 300, default = 100, flag = "misc_jumpvalue", callback = function(value)
        misc.setJumpValue(value)
    end})
    
    movementSection:addToggle({name = "Fly", flag = "misc_fly", callback = function(state)
        misc.toggleFly(state)
    end})
    
    movementSection:addSlider({name = "Fly Speed", min = 10, max = 200, default = 50, flag = "misc_flyspeed", callback = function(value)
        misc.setFlySpeed(value)
    end})
    
    movementSection:addToggle({name = "Noclip", flag = "noclip_enabled", callback = function(state)
        local noclipEnabled = state
        
        local function stopNoclip()
            local character = LocalPlayer.Character
            if not character then return end
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        local function startNoclip()
            local character = LocalPlayer.Character
            if not character then return end
            
            RunService.Stepped:Connect(function()
                if not noclipEnabled or not character or not character.Parent then
                    stopNoclip()
                    return
                end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
        
        if state then
            startNoclip()
        else
            stopNoclip()
        end
    end})
    
    local column2 = Misc:column({fill = true})
    local visualSection = column2:section({name = "Visual"})
    
    visualSection:addToggle({name = "Loop FOV", flag = "misc_loopfov", callback = function(state)
        misc.toggleLoopFOV(state)
    end})
    
    visualSection:addToggle({name = "Hide Head", flag = "misc_hidehead", callback = function(state)
        misc.toggleHideHead(state)
    end})
    
    local otherSection = column:section({name = "Other"})
    
    otherSection:addToggle({name = "Inf Stamina", flag = "misc_infstamina", callback = function(state)
        misc.toggleInfStamina(state)
    end})
    
    otherSection:addToggle({name = "No Fall Damage", flag = "misc_nofall", callback = function(state)
        misc.toggleNoFall(state)
    end})
    
    otherSection:addToggle({name = "No Fail Lockpick", flag = "misc_lockpick", callback = function(state)
        misc.toggleLockpick(state)
    end})
    
    otherSection:addToggle({name = "Instant Prompt", flag = "misc_instantprompt", callback = function(state)
        misc.toggleInstantPrompt(state)
    end})
    
    otherSection:addToggle({name = "Auto Door", flag = "misc_autodoor", callback = function(state)
        misc.toggleAutoDoor(state)
    end})
    
    local safeESPSection = column2:section({name = "Safe ESP"})
    
    safeESPSection:addToggle({name = "Enable Safe ESP", flag = "misc_safeesp", callback = function(state)
        misc.toggleSafeESP(state)
    end})
    
    local safeToggle = safeESPSection:addToggle({name = "Safe ESP", flag = "misc_safeesp", folding = true})
    safeToggle:addColorPicker({name = "Safe Color", flag = "misc_safecolor", color = Color3.fromRGB(255, 215, 0), callback = function(color)
        misc.updateSafeColor(color)
    end})
end

local function setupVisualsTab()
    local column = Visuals:column({fill = true})
    local espSection = column:section({name = "ESP Settings"})
    
    espSection:addToggle({name = "Enable ESP", flag = "esp_enabled", callback = function(state)
        library.flags.esp_enabled = state
    end})
    
    local espToggle = espSection:addToggle({name = "ESP", flag = "esp_enabled", folding = true})
    espToggle:addColorPicker({name = "Main Color", flag = "esp_maincolor", color = Color3.fromRGB(255, 50, 50), callback = function(color)
        library.flags.esp_maincolor = color
    end})
    
    espSection:addSlider({name = "Max Distance", min = 100, max = 5000, default = 1000, suffix = " studs", flag = "esp_maxdistance", callback = function(value)
        library.flags.esp_maxdistance = value
    end})
    
    espSection:addToggle({name = "Team Check", flag = "esp_teamcheck", callback = function(state)
        library.flags.esp_teamcheck = state
    end})
    
    local whitelistToggle = espSection:addToggle({name = "Whitelist Color", flag = "esp_usewhitelistcolor", folding = true})
    whitelistToggle:addColorPicker({name = "Whitelist Color", flag = "esp_whitelistcolor", color = Color3.fromRGB(50, 255, 50), callback = function(color)
        library.flags.esp_whitelistcolor = color
    end})
    
    local targetlistToggle = espSection:addToggle({name = "Targetlist Color", flag = "esp_usetargetlistcolor", folding = true})
    targetlistToggle:addColorPicker({name = "Targetlist Color", flag = "esp_targetlistcolor", color = Color3.fromRGB(255, 50, 255), callback = function(color)
        library.flags.esp_targetlistcolor = color
    end})
    
    local column2 = Visuals:column({fill = true})
    local espSettingsSection = column2:section({name = "ESP Features"})
    
    espSettingsSection:addToggle({name = "Show Distance", flag = "esp_showdistance", callback = function(state)
        library.flags.esp_showdistance = state
    end})
    
    espSettingsSection:addToggle({name = "Show Health", flag = "esp_showhealth", callback = function(state)
        library.flags.esp_showhealth = state
    end})
    
    espSettingsSection:addToggle({name = "Dynamic Scaling", flag = "esp_dynamicscaling", callback = function(state)
        library.flags.esp_dynamicscaling = state
    end})
    
    local richSection = column:section({name = "Rich Shader"})
    
    richSection:addToggle({name = "Rich Shader", flag = "rich_shader", callback = function(state)
        local richShaderEnabled = state
        local richColor = library.flags.rich_shader_color or Color3.fromRGB(255, 200, 150)
        local richBrightness = library.flags.rich_brightness or 20
        local richContrast = library.flags.rich_contrast or 50
        local richSaturation = library.flags.rich_saturation or 150
        
        if state then
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "RichShaderEffect"
            colorCorrection.Parent = game:GetService("Lighting")
            colorCorrection.Brightness = richBrightness / 100
            colorCorrection.Contrast = richContrast / 100
            colorCorrection.Saturation = richSaturation / 100
            colorCorrection.TintColor = richColor
        else
            local lighting = game:GetService("Lighting")
            local effect = lighting:FindFirstChild("RichShaderEffect")
            if effect then effect:Destroy() end
        end
    end})
    
    local richToggle = richSection:addToggle({name = "Rich Shader", flag = "rich_shader", folding = true})
    richToggle:addColorPicker({name = "Shader Color", flag = "rich_shader_color", color = Color3.fromRGB(255, 200, 150), callback = function(color)
        local lighting = game:GetService("Lighting")
        local effect = lighting:FindFirstChild("RichShaderEffect")
        if effect then effect.TintColor = color end
    end})
    
    richSection:addSlider({name = "Brightness", min = 0, max = 100, default = 20, suffix = "%", flag = "rich_brightness", callback = function(value)
        local lighting = game:GetService("Lighting")
        local effect = lighting:FindFirstChild("RichShaderEffect")
        if effect then effect.Brightness = value / 100 end
    end})
    
    richSection:addSlider({name = "Contrast", min = 0, max = 100, default = 50, suffix = "%", flag = "rich_contrast", callback = function(value)
        local lighting = game:GetService("Lighting")
        local effect = lighting:FindFirstChild("RichShaderEffect")
        if effect then effect.Contrast = value / 100 end
    end})
    
    richSection:addSlider({name = "Saturation", min = 0, max = 200, default = 150, suffix = "%", flag = "rich_saturation", callback = function(value)
        local lighting = game:GetService("Lighting")
        local effect = lighting:FindFirstChild("RichShaderEffect")
        if effect then effect.Saturation = value / 100 end
    end})
    
    local richPlayerSection = column2:section({name = "Rich Player"})
    
    local richPlayerEnabled = false
    local richPlayerColor = Color3.fromRGB(255, 255, 255)
    local richPlayerTransparency = 0
    local originalPlayerProperties = {}
    local originalPlayerMaterials = {}
    
    local function applyRichPlayer()
        local char = LocalPlayer.Character
        if not char then return end
        
        if not next(originalPlayerProperties) then
            for _, partName in ipairs({"Torso", "Right Leg", "Right Arm", "Left Leg", "Left Arm", "Head"}) do
                local part = char:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    originalPlayerProperties[partName] = {
                        Color = part.Color,
                        Transparency = part.Transparency
                    }
                    originalPlayerMaterials[partName] = part.Material
                end
            end
        end
        
        for _, partName in ipairs({"Torso", "Right Leg", "Right Arm", "Left Leg", "Left Arm", "Head"}) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.Color = richPlayerColor
                part.Transparency = richPlayerTransparency / 100
                part.Material = Enum.Material.ForceField
            end
        end
    end
    
    local function resetRichPlayer()
        local char = LocalPlayer.Character
        if not char then return end
        
        for partName, properties in pairs(originalPlayerProperties) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.Color = properties.Color
                part.Transparency = properties.Transparency
            end
        end
        
        for partName, material in pairs(originalPlayerMaterials) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.Material = material
            end
        end
        
        originalPlayerProperties = {}
        originalPlayerMaterials = {}
    end
    
    richPlayerSection:addToggle({name = "Rich Player", flag = "rich_player", callback = function(state)
        richPlayerEnabled = state
        if state then
            if LocalPlayer.Character then
                applyRichPlayer()
            end
        else
            if LocalPlayer.Character then
                resetRichPlayer()
            end
        end
    end})
    
    local playerToggle = richPlayerSection:addToggle({name = "Rich Player", flag = "rich_player", folding = true})
    playerToggle:addColorPicker({name = "Player Color", flag = "rich_player_color", color = Color3.fromRGB(255, 255, 255), callback = function(color)
        richPlayerColor = color
        if richPlayerEnabled and LocalPlayer.Character then
            applyRichPlayer()
        end
    end})
    
    richPlayerSection:addSlider({name = "Transparency", min = 0, max = 100, default = 0, suffix = "%", flag = "rich_transparency", callback = function(value)
        richPlayerTransparency = value
        if richPlayerEnabled and LocalPlayer.Character then
            applyRichPlayer()
        end
    end})
    
    LocalPlayer.CharacterAdded:Connect(function()
        if richPlayerEnabled then
            applyRichPlayer()
        end
    end)
end

local function setupPlayersTab()
    local column = PlayersTab:column({fill = true})
    local leftSection = column:section({name = "Players"})
    
    local playersBox = leftSection:addList({name = "Online Players", flag = "players_box", scale = 200})
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            playersBox:add_item(player.Name)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            playersBox:add_item(player.Name)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        playersBox:remove_item(player.Name)
    end)
    
    leftSection:addButton({name = "Add to Target", callback = function()
        local selected = library.flags.players_box or {}
        for _, name in ipairs(selected) do
            local found = false
            for _, target in ipairs(getgenv().Lists.TargetList) do
                if target == name then found = true break end
            end
            if not found then
                table.insert(getgenv().Lists.TargetList, name)
            end
        end
    end})
    
    leftSection:addButton({name = "Add to Whitelist", callback = function()
        local selected = library.flags.players_box or {}
        for _, name in ipairs(selected) do
            local found = false
            for _, wl in ipairs(getgenv().Lists.Whitelist) do
                if wl == name then found = true break end
            end
            if not found then
                table.insert(getgenv().Lists.Whitelist, name)
            end
        end
    end})
    
    leftSection:addButton({name = "Remove Target", callback = function()
        local selected = library.flags.players_box or {}
        for _, name in ipairs(selected) do
            for i = #getgenv().Lists.TargetList, 1, -1 do
                if getgenv().Lists.TargetList[i] == name then
                    table.remove(getgenv().Lists.TargetList, i)
                end
            end
        end
    end})
    
    leftSection:addButton({name = "Remove Whitelist", callback = function()
        local selected = library.flags.players_box or {}
        for _, name in ipairs(selected) do
            for i = #getgenv().Lists.Whitelist, 1, -1 do
                if getgenv().Lists.Whitelist[i] == name then
                    table.remove(getgenv().Lists.Whitelist, i)
                end
            end
        end
    end})
    
    leftSection:addButton({name = "Clear Targets", callback = function()
        getgenv().Lists.TargetList = {}
    end})
    
    leftSection:addButton({name = "Clear Whitelist", callback = function()
        getgenv().Lists.Whitelist = {}
    end})
    
    leftSection:addLabel({name = "Targets: 0", flag = "target_count"})
    leftSection:addLabel({name = "Whitelist: 0", flag = "whitelist_count"})
    
    task.spawn(function()
        while task.wait(1) do
            library:updateFlag("target_count", "Targets: " .. #getgenv().Lists.TargetList)
            library:updateFlag("whitelist_count", "Whitelist: " .. #getgenv().Lists.Whitelist)
        end
    end)
    
    local column2 = PlayersTab:column({fill = true})
    local controlSection = column2:section({name = "Controls"})
    
    controlSection:addToggle({name = "Use Target List", flag = "use_target_list", callback = function(state)
        getgenv().CONFIG.Ragebot.UseTargetList = state
    end})
    
    controlSection:addToggle({name = "Use Whitelist", flag = "use_whitelist", callback = function(state)
        getgenv().CONFIG.Ragebot.UseWhitelist = state
    end})
    
    local rightSection = column2:section({name = "Player Info"})
    
    rightSection:addLabel({name = "Selected: None", flag = "selected_player_name"})
    rightSection:addLabel({name = "Team: -", flag = "selected_player_team"})
    rightSection:addLabel({name = "Health: -", flag = "selected_player_health"})
    rightSection:addLabel({name = "Distance: -", flag = "selected_player_distance"})
    rightSection:addLabel({name = "Status: -", flag = "selected_player_status"})
    
    local bulletTracersEnabled = false
    local tracerColor = Color3.fromRGB(255, 50, 50)
    local tracerWidth = 1
    local tracerLifetime = 15
    
    local function create(startPos, endPos)
        if not bulletTracersEnabled then return end
        
        local tracerModel = Instance.new("Model")
        tracerModel.Name = "TracerBeam"
        
        local beam = Instance.new("Beam")
        beam.Color = ColorSequence.new(tracerColor)
        beam.Width0 = tracerWidth
        beam.Width1 = tracerWidth
        beam.Texture = "rbxassetid://7136858729"
        beam.TextureSpeed = 1
        beam.Brightness = 2
        beam.LightEmission = 2
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
            tracerLifetime / 100,
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
    
    local function trackGlobalBullets()
        local bfr = Camera:FindFirstChild("Bullets")
        if not bfr then 
            bfr = Instance.new("Folder")
            bfr.Name = "Bullets"
            bfr.Parent = Camera
        end
        
        local function tblt(blt)
            if not blt:IsA("BasePart") then return end
            
            local stp = blt.Position
            local lsp = stp
            local stc = 0
            
            local con
            con = RunService.Heartbeat:Connect(function()
                if not blt or not blt.Parent then
                    con:Disconnect()
                    if (lsp - stp).Magnitude > 1 then
                        create(stp, lsp)
                    end
                    return
                end
                
                local cp = blt.Position
                if (cp - lsp).Magnitude < 0.01 then
                    stc = stc + 1
                    if stc > 3 then
                        con:Disconnect()
                        if (cp - stp).Magnitude > 1 then
                            create(stp, cp)
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
    
    rightSection:addToggle({name = "Players bullet Tracers", flag = "bullet_tracers_enabled", callback = function(state)
        bulletTracersEnabled = state
        if state then
            trackGlobalBullets()
        end
    end})
    
    local tracerToggle = rightSection:addToggle({name = "Bullet Tracers", flag = "bullet_tracers_enabled", folding = true})
    tracerToggle:addColorPicker({name = "Tracer Color", flag = "tracer_color", color = Color3.fromRGB(255, 50, 50), callback = function(color)
        tracerColor = color
    end})
    
    rightSection:addSlider({name = "Tracer Width", min = 1, max = 5, default = 1, suffix = "%", flag = "tracer_width", callback = function(value)
        tracerWidth = value
    end})
    
    rightSection:addSlider({name = "Tracer Lifetime", min = 1, max = 100, default = 15, suffix = "%", flag = "tracer_lifetime", callback = function(value)
        tracerLifetime = value
    end})
    
    RunService.RenderStepped:Connect(function()
        local selected = library.flags.players_box or {}
        local name = selected[1]
        
        if not name then
            library:updateFlag("selected_player_name", "Selected: None")
            library:updateFlag("selected_player_team", "Team: -")
            library:updateFlag("selected_player_health", "Health: -")
            library:updateFlag("selected_player_distance", "Distance: -")
            library:updateFlag("selected_player_status", "Status: -")
            return
        end
        
        local player = Players:FindFirstChild(name)
        if not player then
            library:updateFlag("selected_player_name", "Selected: " .. name .. " (Off)")
            library:updateFlag("selected_player_team", "Team: -")
            library:updateFlag("selected_player_health", "Health: -")
            library:updateFlag("selected_player_distance", "Distance: -")
            library:updateFlag("selected_player_status", "Status: Offline")
            return
        end
        
        library:updateFlag("selected_player_name", "Selected: " .. player.Name)
        
        if player.Team then
            library:updateFlag("selected_player_team", "Team: " .. tostring(player.Team))
        else
            library:updateFlag("selected_player_team", "Team: None")
        end
        
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                library:updateFlag("selected_player_health", string.format("Health: %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth)))
            else
                library:updateFlag("selected_player_health", "Health: -")
            end
            
            local myChar = LocalPlayer.Character
            local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            local theirRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            
            if myRoot and theirRoot then
                local dist = (myRoot.Position - theirRoot.Position).Magnitude
                library:updateFlag("selected_player_distance", string.format("Distance: %d", math.floor(dist)))
            else
                library:updateFlag("selected_player_distance", "Distance: -")
            end
            
            library:updateFlag("selected_player_status", "Status: Alive")
        else
            library:updateFlag("selected_player_health", "Health: -")
            library:updateFlag("selected_player_distance", "Distance: -")
            library:updateFlag("selected_player_status", "Status: Dead")
        end
    end)
end

local function setupSettingsTab()
    local column = Settings:column({fill = true})
    local general = column:section({name = "Configs"})

    config_holder = general:addList({name = "Configs", flag = "config_name_list", scale = 100})
    
    general:addTextBox({name = "Config Name", default = "", flag = "config_name_text_box"})

    general:addButton({name = "Create", callback = function()
        if library.flags.config_name_text_box == "" then 
            return 
        end 

        writefile(library.directory .. "/configs/" .. library.flags.config_name_text_box .. ".cfg", library:getConfig())

        library:configListUpdate()
    end})

    general:addButton({name = "Delete", callback = function()
        delfile(library.directory .. "/configs/" .. library.flags.config_name_list .. ".cfg")
        library:configListUpdate()
    end})

    general:addButton({name = "Load", callback = function()
        library:loadConfig(readfile(library.directory .. "/configs/" .. library.flags.config_name_list .. ".cfg"))
    end})
    
    general:addButton({name = "Save", callback = function()
        writefile(library.directory .. "/configs/" .. library.flags.config_name_list .. ".cfg", library:getConfig())
        library:configListUpdate()
    end})

    general:addButton({name = "Refresh configs", callback = function()
        library:configListUpdate()
    end}); library:configListUpdate()

    local column2 = Settings:column({fill = true})
    local other = column2:section({name = "Other"})

    local enabled = true
    general:addLabel({name = "Menu Bind"}):addKeyBind({callback = function(booll) 
        if window.is_closing_menu == false then 
            enabled = not enabled
        end
        
        window.toggle_menu(enabled)
    end})

    general:addLabel({name = "Accent"}):addColorPicker({color = themes.preset.accent, callback = function(color) 
        library:updateTheme("accent", color)
    end})

    local old_config = library:getConfig()

    other:addButton({name = "Unload Config", callback = function()
        library:loadConfig(old_config)
    end})

    other:addButton({name = "Unload Menu", callback = function()
        library:unloadMenu()
    end})
end

setupRagebotTab()
setupLegitTab()
setupVisualsTab()
setupMiscTab()
setupPlayersTab()
setupSettingsTab()

notifications:create_notification({name = "Hi! loaded btw"})
