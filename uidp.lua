local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/ragedu.lua"))()

local Window = Library:Window({
    Name = "gamesense.cc",
    FadeSpeed = 0.25
})

local Watermark = Library:Watermark("gamesense.cc ~ ".. os.date("%b %d %Y"))
local KeybindList = Library:KeybindList()

Watermark:SetVisibility(false)
KeybindList:SetVisibility(false)

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

local Legitbot = {
    Enabled = false,
    SilentAim = {
        Enabled = false,
        FOV = 100,
        TeamCheck = true,
        HitPart = "Torso",
        HeadChance = 30,
        Prediction = 0.165
    },
    Tracers = {
        Enabled = true,
        Color = Color3.fromRGB(255, 50, 50),
        Width = 0.3,
        Brightness = 2,
        LightEmission = 1,
        Lifetime = 0.5
    }
}

local GunMod = {
    NoRecoil = true,
    NoSpread = true,
    NoEquipTime = true
}

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

local SafeESP = {
    Enabled = false,
    Safes = {},
    Visuals = {}
}

local InstantPrompt_Enabled = false
local AutoDoor_Enabled = false
local NoFailLockpick_Enabled = false
local RichShaderSettings = {
    Enabled = false,
    Brightness = 0.2,
    Contrast = 0.5,
    Saturation = 1.5,
    TintColor = Color3.fromRGB(255, 200, 150)
}

local FlyEnabled = false
local FlySpeed = 50
local FlyConnection = nil

local silent_aim_is_targetting = false
local silent_aim_target = nil
local aim_position = Vector3.new()

local VisualizeObjects = {}
local bodyPartsForcefield = {}
local originalMaterials = {}
local originalColors = {}
local originalTransparency = {}
local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local hitNotifications = {}
local notificationYOffset = 5
local MAX_VISIBLE_NOTIFICATIONS = 15

local lastShotTime = 0

local colorCorrection = nil
local lockpickAddedConnection = nil
local doorConnection = nil
local runserviceConnection = nil
local originalMotors = {}
local toolTransparencies = {}
local config_modules_table = {}
local weapon_config_data = {}
local cached_configs = {}
local current_tools = {}
local backpack_tools = {}
local character_tools = {}
local all_configs_array = {}
local gun_config_cache = {}

local no_recoil_enabled = GunMod.NoRecoil
local no_spread_enabled = GunMod.NoSpread
local no_equiptime_enabled = GunMod.NoEquipTime

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV
fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

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

    coroutine.wrap(function()
        GNX_S:FireServer(unpack(args1))
        ZFKLF__H:FireServer(unpack(args2))
    end)()

    hitMarker:Fire(targetHead)
    storedAmmo.Value = storedAmmo.Value
    createTracer(bestShootPos, hitPosition)
    return true
end

RunService.RenderStepped:Connect(function()
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
--[[
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
    makeVisualize(player)y
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
--]]
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

local function createLegitTracer(startPos, endPos)
    if not Legitbot.Tracers.Enabled then return end
    
    local beamPart = Instance.new("Part")
    beamPart.Anchored = true
    beamPart.CanCollide = false
    beamPart.Transparency = 1
    beamPart.Size = Vector3.new(0.1, 0.1, 0.1)
    beamPart.Parent = Workspace
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = beamPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = beamPart
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Color = ColorSequence.new(Legitbot.Tracers.Color)
    beam.Width0 = Legitbot.Tracers.Width
    beam.Width1 = Legitbot.Tracers.Width
    beam.Brightness = Legitbot.Tracers.Brightness
    beam.LightEmission = Legitbot.Tracers.LightEmission
    beam.Parent = beamPart
    
    local midPoint = (startPos + endPos) / 2
    local lookVector = (endPos - startPos).Unit
    local distance = (startPos - endPos).Magnitude
    
    beamPart.CFrame = CFrame.new(midPoint, midPoint + lookVector) * CFrame.new(0, 0, -distance/2)
    
    attachment0.WorldPosition = startPos
    attachment1.WorldPosition = endPos
    
    task.delay(Legitbot.Tracers.Lifetime, function()
        if beamPart and beamPart.Parent then
            beamPart:Destroy()
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
        con = RunService.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if (lsp - stp).Magnitude > 1 then
                    createTracer(stp, lsp)
                end
                return
            end
            
            local cp = blt.Position
            if (cp - lsp).Magnitude < 0.01 then
                stc = stc + 1
                if stc > 3 then
                    con:Disconnect()
                    if (cp - stp).Magnitude > 1 then
                        createTracer(stp, cp)
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

local function get_direction(origin, destination)
    return ((destination - origin).Unit * 1000)
end

local function world_to_screen(position)
    local viewport_position, on_screen = camera:WorldToViewportPoint(position)
    return {position = Vector2.new(viewport_position.X, viewport_position.Y), on_screen = on_screen}
end

local function has_character(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function is_in_fov(position)
    local screen_pos = world_to_screen(position)
    if not screen_pos.on_screen then return false end
    
    local center = camera.ViewportSize / 2
    local distance = (screen_pos.position - center).Magnitude
    return distance <= Legitbot.SilentAim.FOV
end

local function get_closest_player_to_position(target_position)
    local closest_player = nil
    local closest_distance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not has_character(player) then continue end
        
        if Legitbot.SilentAim.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            continue
        end
        
        local character = player.Character
        local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")
        if not humanoid_root_part then continue end
        
        if not is_in_fov(humanoid_root_part.Position) then
            continue
        end
        
        local player_position = humanoid_root_part.Position
        local distance = (target_position - player_position).Magnitude
        
        if distance < closest_distance then
            closest_distance = distance
            closest_player = player
        end
    end
    
    return closest_player
end

local function get_target_part_position(character)
    if not character then return Vector3.new(0, 0, 0) end
    
    local hit_part = Legitbot.SilentAim.HitPart
    local head_chance = Legitbot.SilentAim.HeadChance
    
    local should_hit_head = math.random(1, 100) <= head_chance
    local target_part_name = should_hit_head and "Head" or hit_part
    
    local target_part = character:FindFirstChild(target_part_name)
    if not target_part and target_part_name == "Head" then
        target_part = character:FindFirstChild("Torso")
    end
    if not target_part then
        target_part = character:FindFirstChild("HumanoidRootPart")
    end
    
    if target_part then
        return target_part.Position
    end
    
    return character:FindFirstChild("HumanoidRootPart").Position
end

RunService.RenderStepped:Connect(function()
    if not Legitbot.SilentAim.Enabled then
        silent_aim_is_targetting = false
        silent_aim_target = nil
        return
    end
    
    local target_position = Camera.CFrame.Position + Camera.CFrame.LookVector * 100
    local new_target = get_closest_player_to_position(target_position)
    
    silent_aim_is_targetting = new_target and true or false
    silent_aim_target = new_target or nil
    
    if silent_aim_target and has_character(silent_aim_target) then
        local character = silent_aim_target.Character
        local base_position = get_target_part_position(character)
        
        local velocity = Vector3.new(0, 0, 0)
        local hit_part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if hit_part then
            velocity = hit_part.Velocity
        end
        
        local prediction = Legitbot.SilentAim.Prediction
        local predicted_position = base_position + (velocity * prediction)
        aim_position = predicted_position
    end
end)

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = tostring(getnamecallmethod())
    
    if not checkcaller() and silent_aim_is_targetting and silent_aim_target and self == Workspace and method == "Raycast" then
        local origin = args[1]
        args[2] = get_direction(origin, aim_position)
        return __namecall(self, unpack(args))
    end
    
    return __namecall(self, ...)
end)

local function applyNoRecoil()
    if not no_recoil_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "Recoil") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        local function set_config_value(config_field, field_value)
            if rawget(current_config_data, config_field) then
                rawset(current_config_data, config_field, field_value)
            end
        end

        set_config_value("Recoil", 0)
        set_config_value("RecoilSpeed", 0)
        set_config_value("RecoilDamper", 1)
        set_config_value("RecoilRedution", 1)
        set_config_value("AngleX_Min", 0)
        set_config_value("AngleX_Max", 0)
        set_config_value("AngleY_Min", 0)
        set_config_value("AngleY_Max", 0)
        set_config_value("AngleZ_Min", 0)
        set_config_value("AngleZ_Max", 0)

        if rawget(current_config_data, "AimSettings") and type(current_config_data.AimSettings) == "table" then
            rawset(current_config_data.AimSettings, "RecoilReduction_X", 1)
            rawset(current_config_data.AimSettings, "RecoilReduction_Y", 1)
            rawset(current_config_data.AimSettings, "RecoilReduction_Z", 1)
            rawset(current_config_data.AimSettings, "SpreadReductionP", 1)
        end
    end
end

local function applyNoSpread()
    if not no_spread_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "Spread") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        if rawget(current_config_data, "Spread") then
            rawset(current_config_data, "Spread", 0)
        end
    end
end

local function applyNoEquipTime()
    if not no_equiptime_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "EquipTime") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        if rawget(current_config_data, "EquipTime") then
            rawset(current_config_data, "EquipTime", 0)
        end
    end
end

local function applyAllGunMods()
    applyNoRecoil()
    applyNoSpread()
    applyNoEquipTime()
end

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    if GunMod.NoRecoil or GunMod.NoSpread or GunMod.NoEquipTime then
        applyAllGunMods()
    end
end)

LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        task.wait(0.1)
        if GunMod.NoRecoil or GunMod.NoSpread or GunMod.NoEquipTime then
            applyAllGunMods()
        end
    end
end)

task.spawn(function()
    task.wait(1)
    applyAllGunMods()
end)

task.spawn(function()
    task.wait(0.1)
    trackGlobalBullets()
end)

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
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
local QuickUIFrame = Instance.new("Frame")
QuickUIFrame.Name = "QuickUIFrame"
QuickUIFrame.Size = UDim2.new(0, 80, 0, 30)
QuickUIFrame.Position = UDim2.new(0, 10, 0, 50)
QuickUIFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
QuickUIFrame.BackgroundTransparency = 0.5
QuickUIFrame.BorderSizePixel = 0
QuickUIFrame.Parent = ScreenGui
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

local CombatTab = Window:Page({Name = "Combat", Columns = 2, Subtabs = false})
local MiscTab = Window:Page({Name = "Misc", Columns = 2, Subtabs = true})
local VisualsTab = Window:Page({Name = "Visuals", Columns = 2, Subtabs = false})
local PlayersTab = Window:Page({Name = "Players", Columns = 2, Subtabs = false})
local SettingsTab = Window:Page({Name = "Settings", Columns = 2, Subtabs = false})

local NewSubtab = MiscTab:SubPage({Icon = "79080568477801", Columns = 2})
local NewSubtab2 = MiscTab:SubPage({Icon = "84929780240463", Columns = 2})

local RageSection = CombatTab:Section({Name = "Ragebot", Side = 1})
RageSection:Toggle({Name = "Enabled", Flag = "rage_enable", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.Enabled = value end}):Keybind({Name = "Hotkey", Flag = "rage_enable_hotkey", Default = Enum.KeyCode.Q, Mode = "Toggle"})
RageSection:Toggle({Name = "Rapid Fire", Flag = "rage_rapidfire", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.RapidFire = value end})
RageSection:Toggle({Name = "Hit Sound", Flag = "rage_hitsound", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.HitSound = value end})
RageSection:Toggle({Name = "Auto Reload", Flag = "rage_autoreload", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.AutoReload = value end})
RageSection:Slider({Name = "Fire Rate", Min = 1, Max = 1000, Default = 30, Suffix = " RPS", Flag = "rage_firerate", Callback = function(value) getgenv().CONFIG.Ragebot.FireRate = value end})
RageSection:Slider({Name = "Shoot Range", Min = 1, Max = 30, Default = 15, Flag = "rage_shootrange", Callback = function(value) getgenv().CONFIG.Ragebot.ShootRange = value end})
RageSection:Slider({Name = "Hit Range", Min = 1, Max = 30, Default = 15, Flag = "rage_hitrange", Callback = function(value) getgenv().CONFIG.Ragebot.HitRange = value end})
RageSection:Dropdown({Name = "Hit Sound", Flag = "rage_hitsoundlist", Items = {"skeet", "xp level", "bell"}, Default = "skeet", Callback = function(value) getgenv().CONFIG.Ragebot.SelectedHitSound = value end})

local TargetingSection = CombatTab:Section({Name = "Targeting", Side = 2})
TargetingSection:Toggle({Name = "Team Check", Flag = "rage_teamcheck", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.TeamCheck = value end})
TargetingSection:Toggle({Name = "Visibility Check", Flag = "rage_visibilitycheck", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.VisibilityCheck = value end})
TargetingSection:Toggle({Name = "Wallbang", Flag = "rage_wallbang", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Wallbang = value end})
TargetingSection:Slider({Name = "FOV", Min = 10, Max = 360, Default = 120, Flag = "rage_fov", Callback = function(value) getgenv().CONFIG.Ragebot.FOV = value end})
TargetingSection:Toggle({Name = "Show FOV", Flag = "rage_showfov", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.ShowFOV = value end})
TargetingSection:Toggle({Name = "Downed Check", Flag = "rage_downcheck", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.LowHealthCheck = value end})
TargetingSection:Toggle({Name = "Friend Check", Flag = "rage_friendcheck", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.FriendCheck = value end})
TargetingSection:Slider({Name = "Max Target", Min = 0, Max = 20, Default = 1, Suffix = " players", Flag = "rage_maxtarget", Callback = function(value) getgenv().CONFIG.Ragebot.MaxTarget = value end})

local AimSettingsSection = CombatTab:Section({Name = "Aim Settings", Side = 1})
AimSettingsSection:Toggle({Name = "Prediction", Flag = "rage_prediction", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Prediction = value end})
AimSettingsSection:Slider({Name = "Prediction Amount", Min = 0.05, Max = 0.3, Default = 0.12, Flag = "rage_predictionamount", Callback = function(value) getgenv().CONFIG.Ragebot.PredictionAmount = value end})

local TracersSection = CombatTab:Section({Name = "Tracers", Side = 1})
TracersSection:Toggle({Name = "Tracers", Flag = "rage_tracers", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Tracers = value end})
TracersSection:Slider({Name = "Tracer Width", Min = 0.1, Max = 5, Default = 1, Suffix = "width", Flag = "rage_tracerwidth", Callback = function(value) getgenv().CONFIG.Ragebot.TracerWidth = value end})
TracersSection:Slider({Name = "Tracer Lifetime", Min = 0.5, Max = 100, Default = 3, Suffix = "time", Flag = "rage_tracerlife", Callback = function(value) getgenv().CONFIG.Ragebot.TracerLifetime = value end})

local ColorsSection = CombatTab:Section({Name = "Colors", Side = 2})
local TracerColorLabel = ColorsSection:Label({Name = "Tracer Color", Alignment = "Left"})
TracerColorLabel:Colorpicker({Name = "Tracer Color", Flag = "rage_tracercolor", Default = Color3.fromRGB(255, 0, 0), Callback = function(value) getgenv().CONFIG.Ragebot.TracerColor = value end})
local HitColorLabel = ColorsSection:Label({Name = "Hit Notification Color", Alignment = "Left"})
HitColorLabel:Colorpicker({Name = "Hit Notification Color", Flag = "rage_hitcolor", Default = Color3.fromRGB(255, 182, 193), Callback = function(value) getgenv().CONFIG.Ragebot.HitColor = value end})

local NotifySection = CombatTab:Section({Name = "Notifications", Side = 2})
NotifySection:Toggle({Name = "Hit Notify", Flag = "rage_hitnotify", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.HitNotify = value end})
NotifySection:Slider({Name = "Hit Notify Duration", Min = 1, Max = 10, Default = 5, Suffix = "s", Flag = "rage_hitduration", Callback = function(value) getgenv().CONFIG.Ragebot.HitNotifyDuration = value end})

local LegitSection = NewSubtab:Section({Name = "Legitbot", Side = 1})
LegitSection:Toggle({Name = "Enable Silent Aim", Flag = "legit_silentaim", Default = false, Callback = function(value) Legitbot.SilentAim.Enabled = value end}):Keybind({Name = "Hotkey", Flag = "legit_silentaim_hotkey", Default = Enum.KeyCode.V, Mode = "Toggle"})
LegitSection:Slider({Name = "Field of View", Min = 10, Max = 500, Default = 100, Flag = "legit_fov", Callback = function(value) Legitbot.SilentAim.FOV = value end})
LegitSection:Slider({Name = "Prediction", Min = 0, Max = 0.5, Default = 0.165, Suffix = "s", Flag = "legit_prediction", Callback = function(value) Legitbot.SilentAim.Prediction = value end})
LegitSection:Toggle({Name = "Team Check", Flag = "legit_teamcheck", Default = true, Callback = function(value) Legitbot.SilentAim.TeamCheck = value end})
LegitSection:Slider({Name = "Head Chance", Min = 0, Max = 100, Default = 30, Suffix = "%", Flag = "legit_headchance", Callback = function(value) Legitbot.SilentAim.HeadChance = value end})
LegitSection:Toggle({Name = "Hit Torso", Flag = "legit_hittorso", Default = true, Callback = function(value) 
    if value then
        Legitbot.SilentAim.HitPart = "Torso"
    end
end})
LegitSection:Toggle({Name = "Hit Head", Flag = "legit_hithead", Default = false, Callback = function(value) 
    if value then
        Legitbot.SilentAim.HitPart = "Head"
    end
end})

local TracersLegitSection = NewSubtab:Section({Name = "Tracers", Side = 2})
TracersLegitSection:Toggle({Name = "Enable Tracers", Flag = "legit_tracers", Default = true, Callback = function(value) Legitbot.Tracers.Enabled = value end})
local TracerColorLabelLegit = TracersLegitSection:Label({Name = "Tracer Color", Alignment = "Left"})
TracerColorLabelLegit:Colorpicker({Name = "Tracer Color", Flag = "legit_tracercolor", Default = Color3.fromRGB(255, 50, 50), Callback = function(value) Legitbot.Tracers.Color = value end})
TracersLegitSection:Slider({Name = "Width", Min = 0.1, Max = 2, Default = 0.3, Flag = "legit_tracerwidth", Callback = function(value) Legitbot.Tracers.Width = value end})
TracersLegitSection:Slider({Name = "Brightness", Min = 0, Max = 5, Default = 2, Flag = "legit_tracerbrightness", Callback = function(value) Legitbot.Tracers.Brightness = value end})
TracersLegitSection:Slider({Name = "Light Emission", Min = 0, Max = 2, Default = 1, Flag = "legit_tracerlight", Callback = function(value) Legitbot.Tracers.LightEmission = value end})
TracersLegitSection:Slider({Name = "Lifetime", Min = 0.1, Max = 2, Default = 0.5, Suffix = "s", Flag = "legit_tracerlifetime", Callback = function(value) Legitbot.Tracers.Lifetime = value end})

local GunModSection = NewSubtab:Section({Name = "Gun Mod", Side = 2})
GunModSection:Toggle({Name = "No Recoil", Flag = "legit_norecoil", Default = true, Callback = function(value) 
    GunMod.NoRecoil = value
    no_recoil_enabled = value
    if value then
        applyNoRecoil()
    end
end})
GunModSection:Toggle({Name = "No Spread", Flag = "legit_nospread", Default = true, Callback = function(value) 
    GunMod.NoSpread = value
    no_spread_enabled = value
    if value then
        applyNoSpread()
    end
end})
GunModSection:Toggle({Name = "No Equip Time", Flag = "legit_noequiptime", Default = true, Callback = function(value) 
    GunMod.NoEquipTime = value
    no_equiptime_enabled = value
    if value then
        applyNoEquipTime()
    end
end})

local MovementSection = NewSubtab2:Section({Name = "Movement", Side = 1})
MovementSection:Toggle({Name = "Speed", Flag = "misc_speed", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.SpeedEnabled = value 
    if value then enableSpeed() else disableSpeed() end 
end}):Keybind({Name = "Hotkey", Flag = "misc_speed_hotkey", Default = Enum.KeyCode.LeftShift, Mode = "Toggle"})
MovementSection:Slider({Name = "Speed Value", Min = 10, Max = 200, Default = 50, Flag = "misc_speedvalue", Callback = function(value) getgenv().CONFIG.Misc.SpeedValue = value end})
MovementSection:Toggle({Name = "Jump Power", Flag = "misc_jumpower", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.JumpPowerEnabled = value 
    if value then enableJumpPower() else disableJumpPower() end 
end})
MovementSection:Slider({Name = "Jump Power Value", Min = 50, Max = 300, Default = 100, Flag = "misc_jumpvalue", Callback = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end})
MovementSection:Toggle({Name = "Fly", Flag = "misc_fly", Default = false, Callback = function(value) 
    FlyEnabled = value 
    QuickUIText.Text = value and "FLY ON" or "FLY OFF"
    QuickUIText.TextColor3 = value and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if value then 
        StartFlying()
    end
end}):Keybind({Name = "Hotkey", Flag = "misc_fly_hotkey", Default = Enum.KeyCode.F, Mode = "Toggle"})
MovementSection:Slider({Name = "Fly Speed", Min = 10, Max = 200, Default = 50, Flag = "misc_flyspeed", Callback = function(value) FlySpeed = value end})

local VisualSection = NewSubtab2:Section({Name = "Visual", Side = 1})
VisualSection:Toggle({Name = "Loop FOV", Flag = "misc_loopfov", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.LoopFOVEnabled = value 
    if value then enableLoopFOV() else disableLoopFOV() end 
end})
VisualSection:Toggle({Name = "Hide Head", Flag = "misc_hidehead", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.HideHeadEnabled = value 
    if value then hideHeadFE() else showHeadFE() end 
end})

local OtherSection = NewSubtab2:Section({Name = "Other", Side = 2})
OtherSection:Toggle({Name = "Inf Stamina", Flag = "misc_infstamina", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.InfStaminaEnabled = value 
    if value then enableInfStamina() else disableInfStamina() end 
end})
OtherSection:Toggle({Name = "No Fall Damage", Flag = "misc_nofall", Default = false, Callback = function(value) 
    getgenv().CONFIG.Misc.NoFallDmgEnabled = value 
    if value then enableNoFallDmg() else disableNoFallDmg() end 
end})
OtherSection:Toggle({Name = "Instant Prompt", Default = false, Callback = function(value)
    InstantPrompt_Enabled = value
    
    if value then
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
OtherSection:Toggle({Name = "Auto Door", Default = false, Callback = function(value)
    AutoDoor_Enabled = value
    
    if value then
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
OtherSection:Toggle({Name = "No Fail Lockpick", Default = false, Callback = function(value)
    _G.LockpickEnabled = value
    NoFailLockpick_Enabled = value
    
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    if value then
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

local ChatSection = NewSubtab2:Section({Name = "Chat", Side = 2})
ChatSection:Toggle({Name = "Enable Chat", Default = true, Callback = function(value)
    if game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration") then
        game:GetService("TextChatService").ChatWindowConfiguration.Enabled = value
    end
end})

local SafeESPSection = NewSubtab2:Section({Name = "Safe ESP", Side = 2})
SafeESPSection:Toggle({Name = "Enable Safe ESP", Default = false, Callback = function(value)
    SafeESP:Enable(value)
end})
local SafeColorLabel = SafeESPSection:Label({Name = "Safe Color", Alignment = "Left"})
SafeColorLabel:Colorpicker({Name = "Safe Color", Default = Color3.fromRGB(255, 215, 0), Callback = function(value)
    for model, visuals in pairs(SafeESP.Visuals) do
        if visuals.highlight then
            visuals.highlight.FillColor = value
        end
        if visuals.textLabel then
            visuals.textLabel.TextColor3 = value
        end
    end
end})

local ESPSettingsSection = VisualsTab:Section({Name = "ESP Settings", Side = 1})
--[[
ESPSettingsSection:Toggle({Name = "Enable ESP", Flag = "esp_enabled", Default = false, Callback = function(value) 
    ESP_CONFIG.Enabled = value
end})
ESPSettingsSection:Toggle({Name = "Team Check", Flag = "esp_teamcheck", Default = true, Callback = function(value) ESP_CONFIG.TeamCheck = value end})
ESPSettingsSection:Toggle({Name = "Teamcheck", Flag = "esp_teamcheck_option", Default = true, Callback = function(value) ESP_CONFIG.Options.Teamcheck = value end})
ESPSettingsSection:Toggle({Name = "Friendcheck", Flag = "esp_friendcheck", Default = true, Callback = function(value) ESP_CONFIG.Options.Friendcheck = value end})
ESPSettingsSection:Toggle({Name = "Highlight", Flag = "esp_highlight", Default = true, Callback = function(value) ESP_CONFIG.Options.Highlight = value end})
ESPSettingsSection:Slider({Name = "Max Distance", Flag = "esp_maxdistance", Min = 100, Max = 2000, Default = 500, Suffix = " studs", Callback = function(value) ESP_CONFIG.MaxDistance = value end})
ESPSettingsSection:Slider({Name = "Font Size", Flag = "esp_fontsize", Min = 8, Max = 20, Default = 13, Callback = function(value) ESP_CONFIG.FontSize = value end})

local FadeSection = VisualsTab:Section({Name = "Fade Settings", Side = 1})
FadeSection:Toggle({Name = "Fade on Distance", Flag = "esp_fade_distance", Default = true, Callback = function(value) ESP_CONFIG.FadeOut.OnDistance = value end})
FadeSection:Toggle({Name = "Fade on Death", Flag = "esp_fade_death", Default = true, Callback = function(value) ESP_CONFIG.FadeOut.OnDeath = value end})
FadeSection:Toggle({Name = "Fade on Leave", Flag = "esp_fade_leave", Default = true, Callback = function(value) ESP_CONFIG.FadeOut.OnLeave = value end})

local DrawingSection = VisualsTab:Section({Name = "Drawing Settings", Side = 2})
DrawingSection:Toggle({Name = "Chams Enabled", Flag = "chams_enabled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Chams.Enabled = value end})
DrawingSection:Toggle({Name = "Thermal Chams", Flag = "chams_thermal", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Chams.Thermal = value end})
DrawingSection:Toggle({Name = "Visible Check", Flag = "chams_visible", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Chams.VisibleCheck = value end})
local ChamsFillLabel = DrawingSection:Label({Name = "Chams Fill Color", Alignment = "Left"})
ChamsFillLabel:Colorpicker({Name = "Chams Fill Color", Flag = "chams_fill", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Chams.FillRGB = value end})
local ChamsOutlineLabel = DrawingSection:Label({Name = "Chams Outline Color", Alignment = "Left"})
ChamsOutlineLabel:Colorpicker({Name = "Chams Outline Color", Flag = "chams_outline", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Chams.OutlineRGB = value end})
DrawingSection:Slider({Name = "Chams Fill Transparency", Flag = "chams_fill_trans", Min = 0, Max = 100, Default = 80, Suffix = "%", Callback = function(value) ESP_CONFIG.Drawing.Chams.Fill_Transparency = value end})
DrawingSection:Slider({Name = "Chams Outline Transparency", Flag = "chams_outline_trans", Min = 0, Max = 100, Default = 80, Suffix = "%", Callback = function(value) ESP_CONFIG.Drawing.Chams.Outline_Transparency = value end})

local NamesSection = VisualsTab:Section({Name = "Name Settings", Side = 2})
NamesSection:Toggle({Name = "Names Enabled", Flag = "names_enabled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Names.Enabled = value end})
local NameColorLabel = NamesSection:Label({Name = "Name Color", Alignment = "Left"})
NameColorLabel:Colorpicker({Name = "Name Color", Flag = "names_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value) ESP_CONFIG.Drawing.Names.RGB = value end})

local FlagsSection = VisualsTab:Section({Name = "Flag Settings", Side = 1})
FlagsSection:Toggle({Name = "Flags Enabled", Flag = "flags_enabled", Default = false, Callback = function(value) ESP_CONFIG.Drawing.Flags.Enabled = value end})

local DistancesSection = VisualsTab:Section({Name = "Distance Settings", Side = 1})
DistancesSection:Toggle({Name = "Distances Enabled", Flag = "distances_enabled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Distances.Enabled = value end})
DistancesSection:Dropdown({Name = "Distance Position", Flag = "distances_position", Default = "Text", Options = {"Text", "Bottom"}, Callback = function(value) ESP_CONFIG.Drawing.Distances.Position = value end})
local DistanceColorLabel = DistancesSection:Label({Name = "Distance Color", Alignment = "Left"})
DistanceColorLabel:Colorpicker({Name = "Distance Color", Flag = "distances_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value) ESP_CONFIG.Drawing.Distances.RGB = value end})

local WeaponsSection = VisualsTab:Section({Name = "Weapon Settings", Side = 2})
WeaponsSection:Toggle({Name = "Weapons Enabled", Flag = "weapons_enabled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Weapons.Enabled = value end})
WeaponsSection:Toggle({Name = "Weapon Outlined", Flag = "weapon_outlined", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Weapons.Outlined = value end})
WeaponsSection:Toggle({Name = "Weapon Gradient", Flag = "weapon_gradient", Default = false, Callback = function(value) ESP_CONFIG.Drawing.Weapons.Gradient = value end})
local WeaponTextLabel = WeaponsSection:Label({Name = "Weapon Text Color", Alignment = "Left"})
WeaponTextLabel:Colorpicker({Name = "Weapon Text Color", Flag = "weapon_text", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Weapons.WeaponTextRGB = value end})
local WeaponGrad1Label = WeaponsSection:Label({Name = "Gradient Color 1", Alignment = "Left"})
WeaponGrad1Label:Colorpicker({Name = "Gradient Color 1", Flag = "weapon_grad1", Default = Color3.fromRGB(255, 255, 255), Callback = function(value) ESP_CONFIG.Drawing.Weapons.GradientRGB1 = value end})
local WeaponGrad2Label = WeaponsSection:Label({Name = "Gradient Color 2", Alignment = "Left"})
WeaponGrad2Label:Colorpicker({Name = "Gradient Color 2", Flag = "weapon_grad2", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Weapons.GradientRGB2 = value end})

local HealthbarSection = VisualsTab:Section({Name = "Healthbar Settings", Side = 1})
HealthbarSection:Toggle({Name = "Healthbar Enabled", Flag = "healthbar_enabled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Healthbar.Enabled = value end})
HealthbarSection:Toggle({Name = "Health Text", Flag = "health_text", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Healthbar.HealthText = value end})
HealthbarSection:Toggle({Name = "Health Lerp", Flag = "health_lerp", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Healthbar.Lerp = value end})
HealthbarSection:Toggle({Name = "Health Gradient", Flag = "health_gradient", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Healthbar.Gradient = value end})
local HealthTextLabel = HealthbarSection:Label({Name = "Health Text Color", Alignment = "Left"})
HealthTextLabel:Colorpicker({Name = "Health Text Color", Flag = "health_text_color", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Healthbar.HealthTextRGB = value end})
local HealthGrad1Label = HealthbarSection:Label({Name = "Gradient Color 1", Alignment = "Left"})
HealthGrad1Label:Colorpicker({Name = "Gradient Color 1", Flag = "health_grad1", Default = Color3.fromRGB(200, 0, 0), Callback = function(value) ESP_CONFIG.Drawing.Healthbar.GradientRGB1 = value end})
local HealthGrad2Label = HealthbarSection:Label({Name = "Gradient Color 2", Alignment = "Left"})
HealthGrad2Label:Colorpicker({Name = "Gradient Color 2", Flag = "health_grad2", Default = Color3.fromRGB(60, 60, 125), Callback = function(value) ESP_CONFIG.Drawing.Healthbar.GradientRGB2 = value end})
local HealthGrad3Label = HealthbarSection:Label({Name = "Gradient Color 3", Alignment = "Left"})
HealthGrad3Label:Colorpicker({Name = "Gradient Color 3", Flag = "health_grad3", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Healthbar.GradientRGB3 = value end})
HealthbarSection:Slider({Name = "Healthbar Width", Flag = "health_width", Min = 1, Max = 10, Default = 3, Suffix = " px", Callback = function(value) ESP_CONFIG.Drawing.Healthbar.Width = value end})

local BoxesSection = VisualsTab:Section({Name = "Box Settings", Side = 2})
BoxesSection:Toggle({Name = "Box Animate", Flag = "box_animate", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.Animate = value end})
BoxesSection:Toggle({Name = "Box Gradient", Flag = "box_gradient", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.Gradient = value end})
BoxesSection:Toggle({Name = "Box Fill Gradient", Flag = "box_fill_gradient", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.GradientFill = value end})
BoxesSection:Toggle({Name = "Box Filled", Flag = "box_filled", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.Filled.Enabled = value end})
BoxesSection:Toggle({Name = "Full Box", Flag = "box_full", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.Full.Enabled = value end})
BoxesSection:Toggle({Name = "Corner Box", Flag = "box_corner", Default = true, Callback = function(value) ESP_CONFIG.Drawing.Boxes.Corner.Enabled = value end})
BoxesSection:Slider({Name = "Rotation Speed", Flag = "box_rotation", Min = 0, Max = 500, Default = 200, Callback = function(value) ESP_CONFIG.Drawing.Boxes.RotationSpeed = value end})
BoxesSection:Slider({Name = "Filled Transparency", Flag = "box_filled_trans", Min = 0, Max = 100, Default = 65, Suffix = "%", Callback = function(value) ESP_CONFIG.Drawing.Boxes.Filled.Transparency = value end})
local BoxGrad1Label = BoxesSection:Label({Name = "Gradient Color 1", Alignment = "Left"})
BoxGrad1Label:Colorpicker({Name = "Gradient Color 1", Flag = "box_grad1", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Boxes.GradientRGB1 = value end})
local BoxGrad2Label = BoxesSection:Label({Name = "Gradient Color 2", Alignment = "Left"})
BoxGrad2Label:Colorpicker({Name = "Gradient Color 2", Flag = "box_grad2", Default = Color3.fromRGB(0, 0, 0), Callback = function(value) ESP_CONFIG.Drawing.Boxes.GradientRGB2 = value end})
local BoxFillGrad1Label = BoxesSection:Label({Name = "Fill Gradient Color 1", Alignment = "Left"})
BoxFillGrad1Label:Colorpicker({Name = "Fill Gradient Color 1", Flag = "box_fill_grad1", Default = Color3.fromRGB(119, 120, 255), Callback = function(value) ESP_CONFIG.Drawing.Boxes.GradientFillRGB1 = value end})
local BoxFillGrad2Label = BoxesSection:Label({Name = "Fill Gradient Color 2", Alignment = "Left"})
BoxFillGrad2Label:Colorpicker({Name = "Fill Gradient Color 2", Flag = "box_fill_grad2", Default = Color3.fromRGB(0, 0, 0), Callback = function(value) ESP_CONFIG.Drawing.Boxes.GradientFillRGB2 = value end})
local BoxFilledLabel = BoxesSection:Label({Name = "Filled Color", Alignment = "Left"})
BoxFilledLabel:Colorpicker({Name = "Filled Color", Flag = "box_filled_color", Default = Color3.fromRGB(0, 0, 0), Callback = function(value) ESP_CONFIG.Drawing.Boxes.Filled.RGB = value end})
local BoxFullLabel = BoxesSection:Label({Name = "Full Box Color", Alignment = "Left"})
BoxFullLabel:Colorpicker({Name = "Full Box Color", Flag = "box_full_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value) ESP_CONFIG.Drawing.Boxes.Full.RGB = value end})
local BoxCornerLabel = BoxesSection:Label({Name = "Corner Box Color", Alignment = "Left"})
BoxCornerLabel:Colorpicker({Name = "Corner Box Color", Flag = "box_corner_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value) ESP_CONFIG.Drawing.Boxes.Corner.RGB = value end})

local OptionsSection = VisualsTab:Section({Name = "Option Colors", Side = 1})
local TeamcheckLabel = OptionsSection:Label({Name = "Teamcheck Color", Alignment = "Left"})
TeamcheckLabel:Colorpicker({Name = "Teamcheck Color", Flag = "teamcheck_color", Default = Color3.fromRGB(0, 255, 0), Callback = function(value) ESP_CONFIG.Options.TeamcheckRGB = value end})
local FriendcheckLabel = OptionsSection:Label({Name = "Friendcheck Color", Alignment = "Left"})
FriendcheckLabel:Colorpicker({Name = "Friendcheck Color", Flag = "friendcheck_color", Default = Color3.fromRGB(0, 255, 0), Callback = function(value) ESP_CONFIG.Options.FriendcheckRGB = value end})
local HighlightLabel = OptionsSection:Label({Name = "Highlight Color", Alignment = "Left"})
HighlightLabel:Colorpicker({Name = "Highlight Color", Flag = "highlight_color", Default = Color3.fromRGB(255, 0, 0), Callback = function(value) ESP_CONFIG.Options.HighlightRGB = value end})
--]]
local workspace = cloneref(game:GetService("Workspace"))
local run = cloneref(game:GetService("RunService"))
local http_service = cloneref(game:GetService("HttpService"))
local players = cloneref(game:GetService("Players"))

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new 
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new

local camera = workspace.CurrentCamera

local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
}

local fonts = {}; do
    function Register_Font(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end

        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end

        local Data = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }
        writefile(Name .. ".font", http_service:JSONEncode(Data))

        return getcustomasset(Name .. ".font");
    end
    
    local ProggyTiny = Register_Font("adwdawdwadadwadawdawdawdawd!", 100, "Normal", {
        Id = "ProggyTinyyyy.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf"),
    })

    fonts = {
        main = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    }
end

local localPlayer = players.LocalPlayer

local flags = {
    ["Enabled"] = true;
    ["Names"] = true; 
    ["Name_Color"] = { Color = rgb(255, 255, 255) };
    ["Boxes"] = true;
    ["Box_Type"] = "Normal";
    ["Box_Color"] = { Color = rgb(255, 255, 255) };
    ["Healthbar"] = true; 
    ["Health_High"] = { Color = rgb(0, 255, 0) };
    ["Health_Low"] = { Color = rgb(255, 0, 0) };
    ["Distance"] = true;
    ["Weapon"] = true;
    ["Skeletons"] = true;
    ["Skeletons_Color"] = { Color = rgb(255, 255, 255) };
    ["Distance_Color"] = { Color = rgb(255, 255, 255) };
    ["Weapon_Color"] = { Color = rgb(255, 255, 255) };
    ["TeamCheck"] = false;
    ["FriendCheck"] = true;
    ["UseWhitelist"] = true;
    ["UseTargetList"] = true;
    ["MaxDistance"] = 1000;
    ["ShowFriendIndicator"] = true
}

local function isInWhitelist(player)
    if not getgenv().Lists or not getgenv().Lists.Whitelist then return false end
    if not flags["UseWhitelist"] then return false end
    for _, name in ipairs(getgenv().Lists.Whitelist) do
        if player.Name == name then
            return true
        end
    end
    return false
end

local function isInTargetList(player)
    if not getgenv().Lists or not getgenv().Lists.TargetList then return false end
    if not flags["UseTargetList"] then return false end
    for _, name in ipairs(getgenv().Lists.TargetList) do
        if player.Name == name then
            return true
        end
    end
    return false
end

local function isFriend(player)
    if flags["FriendCheck"] and localPlayer:IsFriendsWith(player.UserId) then
        return true
    end
    if flags["UseWhitelist"] and isInWhitelist(player) then
        return true
    end
    return false
end

local function getPlayerColor(player)
    if flags["UseTargetList"] and isInTargetList(player) then
        return rgb(255, 0, 0)
    elseif isFriend(player) then
        return rgb(0, 255, 0)
    else
        return rgb(255, 255, 255)
    end
end

local function getPlayerDisplayName(player)
    local name = player.DisplayName or player.Name
    if flags["ShowFriendIndicator"] and isFriend(player) and not isInTargetList(player) then
        name = name .. " (F)"
    end
    return name
end

local esp = { players = {}, screengui = Instance.new("ScreenGui", gethui()), cache = Instance.new("ScreenGui", gethui()), connections = {}}; do 
    esp.screengui.IgnoreGuiInset = true
    esp.screengui.Name = "\0"
    esp.cache.Enabled = false

    function esp:get_screen_pos(world_position)
        local viewport_size = camera.ViewportSize
        local local_position = camera.CFrame:pointToObjectSpace(world_position) 
        
        local aspect_ratio = viewport_size.x / viewport_size.y
        local half_height = -local_position.z * math.tan(math.rad(camera.FieldOfView / 2))
        local half_width = aspect_ratio * half_height
        
        local far_plane_corner = Vector3.new(-half_width, half_height, local_position.z)
        local relative_position = local_position - far_plane_corner
    
        local screen_x = relative_position.x / (half_width * 2)
        local screen_y = -relative_position.y / (half_height * 2)
    
        local is_on_screen = -local_position.z > 0 and screen_x >= 0 and screen_x <= 1 and screen_y >= 0 and screen_y <= 1
        
        return Vector3.new(screen_x * viewport_size.x, screen_y * viewport_size.y, -local_position.z), is_on_screen
    end

    function esp:box_solve(torso)
        if not torso then
            return nil, nil, nil
        end
        
        local ViewportTop = torso.Position + (torso.CFrame.UpVector * 1.8) + camera.CFrame.UpVector
        local ViewportBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - camera.CFrame.UpVector
        local Distance = (torso.Position - camera.CFrame.p).Magnitude

        local Top, TopIsRendered = esp:get_screen_pos(ViewportTop)
        local Bottom, BottomIsRendered = esp:get_screen_pos(ViewportBottom)

        local Width = math.max(math.floor(math.abs(Top.X - Bottom.X)), 3)
        local Height = math.max(math.floor(math.max(math.abs(Bottom.Y - Top.Y), Width / 2)), 3)
        local BoxSize = Vector2.new(math.floor(math.max(Height / 1.5, Width)), Height)
        local BoxPosition = Vector2.new(math.floor(Top.X * 0.5 + Bottom.X * 0.5 - BoxSize.X * 0.5), math.floor(math.min(Top.Y, Bottom.Y)))
        
        return BoxSize, BoxPosition, TopIsRendered, Distance
    end

    function esp:create(instance, options)
        local ins = Instance.new(instance) 
        
        for prop, value in options do 
            ins[prop] = value
        end
        
        return ins 
    end

    function esp:create_object(player)
        if player == localPlayer then return end
        
        if flags["TeamCheck"] and player.Team and localPlayer.Team and player.Team == localPlayer.Team then
            return
        end
        
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        esp[player.Name] = { 
            objects = { }, 
            info = {
                character = character; 
                humanoid = humanoid;
                rootpart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
            }; 
            drawings = { }
        } 
        
        local data = esp[player.Name] 
        local playerColor = getPlayerColor(player)

        local objects = data.objects
        objects[ "holder" ] = esp:create( "Frame" , {
            Parent = esp.screengui;
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, 0);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 0, 0, 0);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        objects[ "name" ] = esp:create( "TextLabel" , {
            FontFace = fonts.main;
            Parent = objects[ "holder" ];
            TextColor3 = playerColor;
            BorderColor3 = rgb(0, 0, 0);
            Text = getPlayerDisplayName(player);
            Name = "\0";
            TextStrokeTransparency = 0;
            AnchorPoint = vec2(0, 1);
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 0, -5);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        });
        
        objects[ "box_outline" ] = esp:create( "UIStroke" , {
            Parent = objects["holder"];
            LineJoinMode = Enum.LineJoinMode.Miter
        });
        
        objects[ "box_handler" ] = esp:create( "Frame" , {
            Parent = objects["holder"];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        objects[ "box_color" ] = esp:create( "UIStroke" , {
            Color = playerColor;
            LineJoinMode = Enum.LineJoinMode.Miter;
            Name = "\0";
            Parent = objects[ "box_handler" ]
        });
        
        objects[ "outline" ] = esp:create( "Frame" , {
            Parent = objects[ "box_handler" ];
            Name = "\0";
            BackgroundTransparency = 1;
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(255, 255, 255)
        });
        
        esp:create( "UIStroke" , {
            Parent = objects[ "outline" ];
            LineJoinMode = Enum.LineJoinMode.Miter
        });  
        
        objects[ "healthbar_holder" ] = esp:create( "Frame" , {
            AnchorPoint = vec2(1, 0);
            Parent = objects[ "holder" ];
            Name = "\0";
            Position = dim2(0, -5, 0, -1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(0, 4, 1, 2);
            BorderSizePixel = 0;
            BackgroundColor3 = rgb(0, 0, 0)
        });
        
        objects[ "healthbar" ] = esp:create( "Frame" , {
            Parent = objects[ "healthbar_holder" ];
            Name = "\0";
            Position = dim2(0, 1, 0, 1);
            BorderColor3 = rgb(0, 0, 0);
            Size = dim2(1, -2, 1, -2);
            BorderSizePixel = 0;
            BackgroundColor3 = playerColor
        });
        
        objects[ "distance" ] = esp:create( "TextLabel" , {
            FontFace = fonts.main;
            TextColor3 = playerColor;
            BorderColor3 = rgb(0, 0, 0);
            Text = "0st";
            Parent = objects[ "holder" ];
            TextStrokeTransparency = 0;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 1, 5);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        });                
        
        objects[ "weapon" ] = esp:create( "TextLabel" , {
            FontFace = fonts.main;
            TextColor3 = playerColor;
            BorderColor3 = rgb(0, 0, 0);
            Text = "";
            Parent = objects[ "holder" ];
            TextStrokeTransparency = 0;
            Name = "\0";
            Size = dim2(1, 0, 0, 0);
            BackgroundTransparency = 1;
            Position = dim2(0, 0, 1, 19);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.Y;
            TextSize = 9;
        });
        
        for _, bone in bones do
            local line = Drawing.new("Line")
            line.Color = playerColor;
            line.Thickness = 1;
            line.Visible = false;

            data.drawings[#data.drawings + 1] = line;
        end
        
        data.health_changed = function( value )
            if not flags[ "Healthbar" ] then 
                return 
            end

            local humanoid = data.info.humanoid
            
            local multiplier = value / humanoid.MaxHealth
            local color = flags[ "Health_Low" ].Color:Lerp( flags["Health_High"].Color, multiplier )
            
            objects[ "healthbar" ].Size = UDim2.new(1, -2, multiplier, -2)
            objects[ "healthbar" ].Position = UDim2.new(0, 1, 1 - multiplier, 1)
            objects[ "healthbar" ].BackgroundColor3 = color
        end

        data.tool_added = function( item )
            if not item:IsA("Tool") then 
                return 
            end 

            objects[ "weapon" ].Text = "[" .. item.Name .. "]"
        end

        data.refresh_offsets = function()
            local offset = 5; 

            if objects["distance"].Parent == objects[ "holder" ] then 
                offset += 5
                objects[ "weapon" ].Position = dim2(0, 0, 1, offset)
            end 
        end 

        data.refresh_descendants = function() 
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild( "Humanoid" )
            
            data.info.character = character
            data.info.humanoid = humanoid
            data.info.rootpart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")

            humanoid.HealthChanged:Connect( data.health_changed )

            character.ChildAdded:Connect( data.tool_added )
            character.ChildRemoved:Connect( function(child)
                if child:IsA("Tool") then
                    objects[ "weapon" ].Text = ""
                end
            end )

            data.health_changed( data.info.humanoid.Health )
        end
        
        data.refresh_descendants()

        player.CharacterAdded:Connect( data.refresh_descendants )

        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            data.tool_added( tool )
        end 
    end

    function esp:remove_object(player)
        local holder = esp[player.Name]

        if not holder then return end 

        local objects = holder.objects
 
        for _, line in holder.drawings do 
            line:Remove()
        end
        
        objects[ "holder" ]:Destroy() 
        esp[player.Name] = nil
    end
    
    function esp.refresh_elements()
        for _,v in players:GetPlayers() do 
            if v == players.LocalPlayer then 
                continue
            end
            
            if not v.Character then 
                continue 
            end 

            local path = esp[v.Name]
            local objects = path and path.objects
            
            if not objects then 
                continue 
            end
            
            local playerColor = getPlayerColor(v)
            
            objects.holder.Parent = flags["Enabled"] and esp.screengui or esp.cache

            objects[ "name" ].Parent = flags["Names"] and objects["holder"] or esp.cache
            objects[ "name" ].TextColor3 = playerColor
            objects[ "name" ].Text = getPlayerDisplayName(v)
            
            objects[ "box_color" ].Color = playerColor 

            for _, line in path.drawings do
                line.Color = playerColor
                line.Visible = flags["Skeletons"]
            end

            objects[ "healthbar_holder" ].Parent = flags[ "Healthbar" ] and objects[ "holder" ] or esp.cache
            objects[ "weapon" ].Parent = flags["Weapon"] and objects[ "holder" ] or esp.cache

            objects[ "distance" ].Parent = flags["Distance"] and objects[ "holder" ] or esp.cache
        end
    end

    esp.connection = run.RenderStepped:Connect(function()
        if not flags["Enabled"] then 
            return
        end

        for _, player in players:GetPlayers() do 
            local data = esp[player.Name]

            if not data then 
                continue 
            end 

            local character = data.info.character
            local humanoid = data.info.humanoid 
            
            if not (character or humanoid) then 
                continue 
            end 

            local objects = data and data.objects 

            if not objects then 
                continue 
            end 

            local rootPart = data.info.rootpart
            if not rootPart then continue end

            local box_size, box_pos, on_screen, distance = esp:box_solve(rootPart)
            local holder = objects[ "holder" ]

            if not on_screen or distance > flags["MaxDistance"] then
                holder.Visible = false
                continue
            end

            if holder.Visible ~= true then 
                holder.Visible = true
            end 

            if flags["Skeletons"] and character:FindFirstChild("UpperTorso") then 
                for i = 1, #bones do
                    local origin, destination = bones[i][1], bones[i][2]

                    if not data.drawings[i] then 
                        continue  
                    end 

                    local path = data.drawings[i]

                    local origin_3d = character:FindFirstChild(origin) 
                    local destination_3d = character:FindFirstChild(destination) 

                    if origin_3d and destination_3d then 
                        local origin_2d, on_screen_start = esp:get_screen_pos(origin_3d.Position)
                        local destination_2d, on_screen_end = esp:get_screen_pos(destination_3d.Position)
                        
                        if on_screen_start and on_screen_end then 
                            path.Visible = true
                            path.From = Vector2.new(origin_2d.X, origin_2d.Y)
                            path.To = Vector2.new(destination_2d.X, destination_2d.Y)
                        else
                            path.Visible = false
                        end 
                    end
                end 
            end 
            
            local pos = dim_offset(box_pos.X, box_pos.Y)
            if pos ~= holder.Position then 
                holder.Position = pos
            end 

            local size = dim_offset(box_size.X, box_size.Y)
            if size ~= holder.Size then 
                holder.Size = size
            end 

            local distance_label = objects[ "distance" ]
            if distance_label.Text ~= tostring( math.round(distance) )  .. "st" then 
                distance_label.Text = tostring( math.round(distance) ) .. "st"
            end 
        end
    end)
end

for _,v in players:GetPlayers() do 
    if v ~= players.LocalPlayer then 
        esp:create_object(v)
    end 
end 

esp.player_added = players.PlayerAdded:Connect(function(v)
    esp:create_object(v)
end)

esp.player_removed = players.PlayerRemoving:Connect(function(v)
    esp:remove_object(v)
end)

task.wait()
esp.refresh_elements()

local function createESPTab()
    ESPSettingsSection:Toggle({Name = "Enabled", Flag = "esp_enabled", Default = flags["Enabled"], Callback = function(value) 
        flags["Enabled"] = value
        esp.refresh_elements()
    end}):Keybind({Name = "Hotkey", Flag = "esp_hotkey", Default = Enum.KeyCode.Insert, Mode = "Toggle", Callback = function(value)
        flags["Enabled"] = not flags["Enabled"]
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Names", Flag = "esp_names", Default = flags["Names"], Callback = function(value) 
        flags["Names"] = value
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Boxes", Flag = "esp_boxes", Default = flags["Boxes"], Callback = function(value) 
        flags["Boxes"] = value
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Healthbar", Flag = "esp_healthbar", Default = flags["Healthbar"], Callback = function(value) 
        flags["Healthbar"] = value
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Distance", Flag = "esp_distance", Default = flags["Distance"], Callback = function(value) 
        flags["Distance"] = value
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Weapon", Flag = "esp_weapon", Default = flags["Weapon"], Callback = function(value) 
        flags["Weapon"] = value
        esp.refresh_elements()
    end})
    
    ESPSettingsSection:Toggle({Name = "Skeletons", Flag = "esp_skeletons", Default = flags["Skeletons"], Callback = function(value) 
        flags["Skeletons"] = value
        esp.refresh_elements()
    end})
    --local ESPSettingsSection = VisualsTab:Section({Name = "ESP Settings", Side = 1})
    local ESPFilterSection = VisualsTab:Section({Name = "Filters", Side = 2})
    ESPFilterSection:Toggle({Name = "Team Check", Flag = "esp_teamcheck", Default = flags["TeamCheck"], Callback = function(value) 
        flags["TeamCheck"] = value
        esp.refresh_elements()
    end})
    
    ESPFilterSection:Toggle({Name = "Friend Check", Flag = "esp_friendcheck", Default = flags["FriendCheck"], Callback = function(value) 
        flags["FriendCheck"] = value
        esp.refresh_elements()
    end})
    
    ESPFilterSection:Toggle({Name = "Use Whitelist", Flag = "esp_usewhitelist", Default = flags["UseWhitelist"], Callback = function(value) 
        flags["UseWhitelist"] = value
        esp.refresh_elements()
    end})
    
    ESPFilterSection:Toggle({Name = "Use TargetList", Flag = "esp_usetargetlist", Default = flags["UseTargetList"], Callback = function(value) 
        flags["UseTargetList"] = value
        esp.refresh_elements()
    end})
    
    ESPFilterSection:Toggle({Name = "Show (F) Indicator", Flag = "esp_friendindicator", Default = flags["ShowFriendIndicator"], Callback = function(value) 
        flags["ShowFriendIndicator"] = value
        esp.refresh_elements()
    end})
    
    ESPFilterSection:Slider({Name = "Max Distance", Flag = "esp_maxdistance", Min = 100, Max = 5000, Default = flags["MaxDistance"], Suffix = " studs", Callback = function(value) 
        flags["MaxDistance"] = value
    end})
    
    local ESPColorsSection = VisualsTab:Section({Name = "Colors", Side = 1})
    local NormalColorLabel = ESPColorsSection:Label({Name = "Normal Color", Alignment = "Left"})
    NormalColorLabel:Colorpicker({Name = "Normal Color", Flag = "esp_normalcolor", Default = rgb(255, 255, 255), Callback = function(value) 
        colors.normal = value
        esp.refresh_elements()
    end})
    
    local WhitelistColorLabel = ESPColorsSection:Label({Name = "Whitelist Color", Alignment = "Left"})
    WhitelistColorLabel:Colorpicker({Name = "Whitelist Color", Flag = "esp_whitelistcolor", Default = rgb(0, 255, 0), Callback = function(value) 
        colors.whitelist = value
        esp.refresh_elements()
    end})
    
    local TargetlistColorLabel = ESPColorsSection:Label({Name = "TargetList Color", Alignment = "Left"})
    TargetlistColorLabel:Colorpicker({Name = "TargetList Color", Flag = "esp_targetlistcolor", Default = rgb(255, 0, 0), Callback = function(value) 
        colors.targetlist = value
        esp.refresh_elements()
    end})
    
    local HealthHighLabel = ESPColorsSection:Label({Name = "Health High", Alignment = "Left"})
    HealthHighLabel:Colorpicker({Name = "Health High", Flag = "esp_healthhigh", Default = rgb(0, 255, 0), Callback = function(value) 
        flags["Health_High"].Color = value
        esp.refresh_elements()
    end})
    
    local HealthLowLabel = ESPColorsSection:Label({Name = "Health Low", Alignment = "Left"})
    HealthLowLabel:Colorpicker({Name = "Health Low", Flag = "esp_healthlow", Default = rgb(255, 0, 0), Callback = function(value) 
        flags["Health_Low"].Color = value
        esp.refresh_elements()
    end})
    
    local ESPBoxSection = ESPTab:Section({Name = "Box Settings", Side = 2})
    ESPBoxSection:Dropdown({Name = "Box Type", Flag = "esp_boxtype", Items = {"Normal", "Corner"}, Default = "Normal", Callback = function(value) 
        flags["Box_Type"] = value
        esp.refresh_elements()
    end})
    
    local BoxColorLabel = ESPBoxSection:Label({Name = "Box Color", Alignment = "Left"})
    BoxColorLabel:Colorpicker({Name = "Box Color", Flag = "esp_boxcolor", Default = rgb(255, 255, 255), Callback = function(value) 
        flags["Box_Color"].Color = value
        esp.refresh_elements()
    end})
    
    local SkeletonColorLabel = ESPBoxSection:Label({Name = "Skeleton Color", Alignment = "Left"})
    SkeletonColorLabel:Colorpicker({Name = "Skeleton Color", Flag = "esp_skeletoncolor", Default = rgb(255, 255, 255), Callback = function(value) 
        flags["Skeletons_Color"].Color = value
        esp.refresh_elements()
    end})
end

createESPTab()
local ForcefieldSection = VisualsTab:Section({Name = "Forcefield Material", Side = 1})
ForcefieldSection:Toggle({Name = "Enable Forcefield", Flag = "visualize_forcefield_enabled", Default = false, Callback = function(value)
    getgenv().CONFIG.Visualize.LocalForcefieldEnabled = value
    if value then
        applyForcefieldToBodyParts()
    else
        removeForcefieldFromBodyParts()
    end
end})
ForcefieldSection:Slider({Name = "Forcefield Transparency", Flag = "visualize_forcefield_transparency", Min = 0, Max = 1, Default = 0.5, Callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldTransparency = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})
local ForcefieldColorLabel = ForcefieldSection:Label({Name = "Forcefield Color", Alignment = "Left"})
ForcefieldColorLabel:Colorpicker({Name = "Forcefield Color", Flag = "visualize_forcefield_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldColor = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

local ArrowSection = VisualsTab:Section({Name = "Arrow Indicators", Side = 2})
ArrowSection:Toggle({Name = "Enable Arrow Indicators", Flag = "visualize_arrow_enabled", Default = false, Callback = function(value)
    Arrow:Enable(value)
end})
local ArrowColorLabel = ArrowSection:Label({Name = "Arrow Color", Alignment = "Left"})
ArrowColorLabel:Colorpicker({Name = "Arrow Color", Flag = "visualize_arrow_color", Default = Color3.fromRGB(255, 255, 255), Callback = function(value)
    Arrow.TriangleColor = value
    Arrow:UpdateSettings()
end})
ArrowSection:Slider({Name = "Arrow Distance", Flag = "visualize_arrow_distance", Min = 50, Max = 200, Default = 80, Callback = function(value)
    Arrow.DistFromCenter = value
end})
ArrowSection:Slider({Name = "Arrow Size", Flag = "visualize_arrow_size", Min = 8, Max = 32, Default = 16, Callback = function(value)
    Arrow.TriangleHeight = value
    Arrow.TriangleWidth = value
end})
ArrowSection:Slider({Name = "Arrow Thickness", Flag = "visualize_arrow_thickness", Min = 1, Max = 5, Default = 1, Callback = function(value)
    Arrow.TriangleThickness = value
    Arrow:UpdateSettings()
end})
ArrowSection:Toggle({Name = "Anti Aliasing", Flag = "visualize_arrow_aa", Default = false, Callback = function(value)
    Arrow.AntiAliasing = value
end})

local RichWorldSection = VisualsTab:Section({Name = "Rich World", Side = 1})
RichWorldSection:Toggle({Name = "Rich Shader", Default = false, Callback = function(value)
    RichShaderSettings.Enabled = value
    
    if value then
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
RichWorldSection:Slider({Name = "Brightness", Min = -1, Max = 1, Default = 0.2, Callback = function(value)
    RichShaderSettings.Brightness = value
    if colorCorrection then
        colorCorrection.Brightness = value
    end
end})
RichWorldSection:Slider({Name = "Contrast", Min = -1, Max = 1, Default = 0.5, Callback = function(value)
    RichShaderSettings.Contrast = value
    if colorCorrection then
        colorCorrection.Contrast = value
    end
end})
RichWorldSection:Slider({Name = "Saturation", Min = 0, Max = 2, Default = 1.5, Callback = function(value)
    RichShaderSettings.Saturation = value
    if colorCorrection then
        colorCorrection.Saturation = value
    end
end})
local TintColorLabel = RichWorldSection:Label({Name = "Tint Color", Alignment = "Left"})
TintColorLabel:Colorpicker({Name = "Tint Color", Default = Color3.fromRGB(255, 200, 150), Callback = function(value)
    RichShaderSettings.TintColor = value
    if colorCorrection then
        colorCorrection.TintColor = value
    end
end})

local TargetListSection = PlayersTab:Section({Name = "Target List", Side = 1})
TargetListSection:Textbox({Name = "Add to Target List", Placeholder = "player name", Callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.TargetList, text) end end})
TargetListSection:Button({Name = "Clear Target List", Callback = function() getgenv().Lists.TargetList = {} end})

local WhitelistSection = PlayersTab:Section({Name = "Whitelist", Side = 2})
WhitelistSection:Textbox({Name = "Add to Whitelist", Placeholder = "player name", Callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.Whitelist, text) end end})
WhitelistSection:Button({Name = "Clear Whitelist", Callback = function() getgenv().Lists.Whitelist = {} end})

local ControlsSection = PlayersTab:Section({Name = "Controls", Side = 1})
ControlsSection:Toggle({Name = "Use Target List", Flag = "lists_usetargetlist", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.UseTargetList = value end})
ControlsSection:Toggle({Name = "Use Whitelist", Flag = "lists_usewhitelist", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.UseWhitelist = value end})

local SaveSection = SettingsTab:Section({Name = "Save/Load", Side = 1})
SaveSection:Button({Name = "Save Config", Callback = function()
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
        Library:Notification("Configuration saved!", 3, Library.Theme.Accent)
    else
        Library:Notification("Writefile not supported", 3, Color3.fromRGB(255, 0, 0))
    end
end})

SaveSection:Button({Name = "Load Config", Callback = function()
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
            
            Library:Notification("Configuration loaded!", 3, Library.Theme.Accent)
        else
            Library:Notification("Failed to load config", 3, Color3.fromRGB(255, 0, 0))
        end
    else
        Library:Notification("Config file not found", 3, Color3.fromRGB(255, 0, 0))
    end
end})

SaveSection:Button({Name = "Reset to Default", Callback = function()
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
    
    Library:Notification("Configuration reset to default!", 3, Library.Theme.Accent)
end})

local ManageSection = SettingsTab:Section({Name = "Manage", Side = 2})
local currentConfigName = ""
ManageSection:Textbox({Name = "Config Name", Placeholder = "enter config name", Callback = function(text)
    currentConfigName = text
end})

ManageSection:Button({Name = "Save as Preset", Callback = function()
    if writefile and currentConfigName then
        local name = currentConfigName
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
            Library:Notification("Preset saved as: " .. name, 3, Library.Theme.Accent)
        end
    end
end})

ManageSection:Button({Name = "Delete Preset", Callback = function()
    if delfile and currentConfigName then
        local name = currentConfigName
        if name ~= "" then
            local filename = "aui_preset_" .. name .. ".json"
            if isfile(filename) then
                delfile(filename)
                Library:Notification("Preset deleted: " .. name, 3, Library.Theme.Accent)
            end
        end
    end
end})

local ListSection = SettingsTab:Section({Name = "Presets List", Side = 2})
ListSection:Button({Name = "Refresh Presets", Callback = function()
    if isfile then
        for _, file in pairs(listfiles("")) do
            if file:find("aui_preset_") and file:find("%.json$") then
                local name = file:match("aui_preset_(.+)%.json")
                local btn = ListSection:Button({
                    name = name,
                    Callback = function()
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
                                
                                Library:Notification("Preset loaded: " .. name, 3, Library.Theme.Accent)
                            end
                        end
                    end
                })
            end
        end
    end
end})

local SettingsSection = SettingsTab:Section({Name = "Settings", Side = 2})
local ConfigsSection = SettingsTab:Section({Name = "Profiles", Side = 1})

for Index, Value in Library.Theme do 
    local ThemeLabel = SettingsSection:Label({Name = Index, Alignment = "Left"})
    ThemeLabel:Colorpicker({ Name = Index, Default = Value, Flag = "Theme"..Index, Callback = function(Color) 
        Library.Theme[Index] = Color
        Library:ChangeTheme(Index, Color)
    end})
end

local MenuKeybindLabel = SettingsSection:Label({Name = "Menu Keybind", Alignment = "Left"})
MenuKeybindLabel:Keybind({Name = "Menu Keybind", Flag = "Menu Keybind", Default = Enum.KeyCode.RightControl, Mode = "Toggle", Callback = function(Value)
    Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
end})

SettingsSection:Toggle({Name = "Watermark", Flag = "Watermark", Default = false, Callback = function(Value)
    Watermark:SetVisibility(Value)
end})

SettingsSection:Toggle({Name = "Keybind List", Flag = "Keybind List", Default = false, Callback = function(Value)
    KeybindList:SetVisibility(Value)
end})

SettingsSection:Dropdown({Name = "Tweening Style", Flag = "Tweening Style", Default = "Exponential", Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"}, Callback = function(Value)
    Library.Tween.Style = Enum.EasingStyle[Value]
end})

SettingsSection:Dropdown({Name = "Tweening Direction", Flag = "Tweening Direction", Default = "Out", Items = {"In", "Out", "InOut"}, Callback = function(Value)
    Library.Tween.Direction = Enum.EasingDirection[Value]
end})

SettingsSection:Slider({Name = "Tweening Time", Min = 0, Max = 5, Default = 0.25, Decimals = 0.01, Flag = "Tweening Time", Callback = function(Value)
    Library.Tween.Time = Value
end})

SettingsSection:Button({Name = "Notification test", Callback = function()
    Library:Notification("This is a notification", 5, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
end})

SettingsSection:Button({Name = "Unload library", Callback = function()
    Library:Unload()
end})

local ConfigName 
local ConfigSelected

local ConfigsListbox = ConfigsSection:Listbox({Items = { }, Name = "Configs", Flag = "Configs List", Callback = function(Value)
    ConfigSelected = Value
end})

ConfigsSection:Textbox({Name = "Config Name", Placeholder = ". .", Flag = "Config Name", Callback = function(Value)
    ConfigName = Value
end})

ConfigsSection:Button({Name = "Create Config", Callback = function()
    if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())

        Library:RefreshConfigsList(ConfigsListbox)
    else
        Library:Notification("Config '" .. ConfigName .. ".json' already exists", 3, Color3.FromR(255, 0, 0))
        return
    end
end})

ConfigsSection:Button({Name = "Load Config", Callback = function()
    if ConfigSelected then
        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
    end

    Library:Thread(function()
        task.wait(0.1)

        for Index, Value in Library.Theme do 
            Library.Theme[Index] = Library.Flags["Theme"..Index].Color
            Library:ChangeTheme(Index, Library.Flags["Theme"..Index].Color)
        end    
    end)
end})

ConfigsSection:Button({Name = "Delete Config", Callback = function()
    if ConfigSelected then
        Library:DeleteConfig(ConfigSelected)

        Library:RefreshConfigsList(ConfigsListbox)
    end
end})

ConfigsSection:Button({Name = "Save Config", Callback = function()
    if ConfigSelected then
        Library:SaveConfig(ConfigSelected)
    end
end})

ConfigsSection:Button({Name = "Refresh Configs", Callback = function()
    Library:RefreshConfigsList(ConfigsListbox)
end})

Library:RefreshConfigsList(ConfigsListbox)

Library:Notification("skcc.lua loaded successfully!", 5, Library.Theme.Accent, {"rbxassetid://135757045959142", Color3.fromRGB(149, 255, 139)})

print("done")
