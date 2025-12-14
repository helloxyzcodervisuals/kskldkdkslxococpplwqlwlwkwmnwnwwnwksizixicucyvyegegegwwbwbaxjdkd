if string.lower((getgenv() or _G).key or "") ~= "gamesense.cc" then return end
repeat task.wait() until game:IsLoaded()

local Config = {
    isAdonisAC = function(tab) return rawget(tab, "Detected") and typeof(rawget(tab, "Detected")) == "function" and rawget(tab, "RLocked") end,
    repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/',
    Library = nil, ThemeManager = nil, SaveManager = nil, Options = nil, Toggles = nil, window = nil, Tabs = {},
    Players = game:GetService("Players"), RunService = game:GetService("RunService"), Workspace = game:GetService("Workspace"), 
    TweenService = game:GetService("TweenService"), UserInputService = game:GetService("UserInputService"), ReplicatedStorage = game:GetService("ReplicatedStorage"),
    LocalPlayer = game:GetService("Players").LocalPlayer, Camera = workspace.CurrentCamera, ScreenGui = Instance.new("ScreenGui"),
    Ragebot = {Enabled = false, FireRate = 30, Prediction = true, PredictionAmount = 0.12, TeamCheck = false, VisibilityCheck = true, FOV = 120, ShowFOV = true, Wallbang = true, Tracers = true, TracerColor = Color3.fromRGB(255, 0, 0), TracerWidth = 1, TracerLifetime = 3, WallbangRange = 30, HitNotify = true, AutoReload = true, HitSound = true, TargetList = {}, Whitelist = {}, UseTargetList = false, UseWhitelist = false, HitNotifyDuration = 5, LowHealthCheck = false, SelectedHitSound = "Skeet"},
    MeleeAura = {Enabled = true, TargetPart = {"Head", "UpperTorso"}, ShowAnim = true},
    Legitbot = {SilentAim = false, FOV = 120, ShowFOV = true, Tracers = {Enabled = false, Width = 1, Brightness = 5, LightEmission = 3, Color = Color3.fromRGB(255, 182, 193), Lifetime = 3}},
    ESP = {Enabled = false, Box = true, BoxColor = Color3.fromRGB(255,255,255), BoxThickness = 1, BoxTransparency = 0.5, Name = true, NameColor = Color3.fromRGB(255,255,255), NameSize = 13, Health = true, HealthColor = Color3.fromRGB(0,255,0), HealthSize = 13, Distance = true, DistanceColor = Color3.fromRGB(255,255,255), DistanceSize = 13, Weapon = true, WeaponColor = Color3.fromRGB(255,182,193), WeaponSize = 13, TeamCheck = false, TeamColor = true, ShowSnaplines = false, SnaplineColor = Color3.fromRGB(255,0,0), SnaplineThickness = 1, Arrows = false, ArrowColor = Color3.fromRGB(255,255,255), ArrowSize = 30, MaxDistance = 500, MinBoxSize = Vector2.new(50, 100), MaxBoxSize = Vector2.new(150, 200)},
    VisualSettings = {Forcefield = {Enabled = false, Color = Color3.fromRGB(0, 162, 255), Transparency = 0.3}, ViewModel = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0}},
    Fly = {On = false, Speed = 50, UI = false, MobileUI = nil, MainFrame = nil, ToggleButton = nil, SpeedUp = nil, SpeedDown = nil, SpeedLabel = nil, SpeedDisplay = nil},
    hideHeadEnabled = false, speedEnabled = false, speedValue = 50, loopFOVEnabled = false, infStaminaEnabled = false, NoFallDmgEnabled = false, lockpickHBEEnabled = false, JumpPowerEnabled = false, JumpPowerValue = 100, RichShaderEnabled = false,
    currentAnimationTrack = nil, noFallForceField = nil, colorCorrection = nil, flyConn = nil, flyPart = nil, speedConnection = nil, loopFOVConnection = nil, lastShotTime = 0, currentSlash = 1, LastTick = tick(), AttachTick = tick(), fovCircle = Drawing.new("Circle"), hitNotifications = {},
    ESPDrawings = {},
    AttachCD = {["Fists"] = 0.35, ["BBaton"] = 0.5, ["__ZombieFists1"] = 0.35, ["__ZombieFists2"] = 0.37, ["__ZombieFists3"] = 0.22, ["__ZombieFists4"] = 0.4, ["__XFists"] = 0.35, ["Balisong"] = 0.3, ["Bat"] = 1.2, ["Bayonet"] = 0.6, ["BlackBayonet"] = 0.6, ["CandyCrowbar"] = 2.5, ["Chainsaw"] = 3, ["Crowbar"] = 1.2, ["Clippers"] = 0.6, ["CursedDagger"] = 0.8, ["DELTA-X04"] = 0.6, ["ERADICATOR"] = 2, ["ERADICATOR-II"] = 2, ["Fire-Axe"] = 1.6, ["GoldenAxe"] = 0.75, ["Golfclub"] = 1.2, ["Hatchet"] = 0.7, ["Katana"] = 0.6, ["Knuckledusters"] = 0.5, ["Machete"] = 0.7, ["Metal-Bat"] = 1.3, ["Nunchucks"] = 0.3, ["PhotonBlades"] = 0.8, ["Rambo"] = 0.8, ["ReforgedKatana"] = 0.85, ["Rendbreaker"] = 1.5, ["RoyalBroadsword"] = 1, ["Sabre"] = 0.7, ["Scythe"] = 1.2, ["Shiv"] = 0.5, ["Shovel"] = 2.5, ["SlayerSword"] = 1.5, ["Sledgehammer"] = 2.2, ["Taiga"] = 0.7, ["Tomahawk"] = 0.85, ["Wrench"] = 0.6, ["_BFists"] = 0.35, ["_FallenBlade"] = 1.3, ["_Sledge"] = 2.2, ["new_oldSlayerSword"] = 1.5},
    ValidMeleeTargetParts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"},
    danceAnimations = {billie = {"http://www.roblox.com/asset/?id=14849697861"}, chrono = {"http://www.roblox.com/asset/?id=14849705278"}, sponge = {"http://www.roblox.com/asset/?id=14849714833"}, twist = {"http://www.roblox.com/asset/?id=14849722929"}, goth = {"http://www.roblox.com/asset/?id=14849726322"}, soviet1 = {"http://www.roblox.com/asset/?id=14849731537"}, drip = {"http://www.roblox.com/asset/?id=14849735043"}, thriller = {"http://www.roblox.com/asset/?id=14849738091"}, shuffle = {"http://www.roblox.com/asset/?id=14849741153"}, stomp = {"http://www.roblox.com/asset/?id=14849744125"}, hustle = {"http://www.roblox.com/asset/?id=14849746902"}, soviet2 = {"http://www.roblox.com/asset/?id=14849749888"}},
    hitSoundList = {text = "Hit Sound", Values = {"Skeet", "XP Level", "Bell"}, Default = "Skeet", callback = function(v) Config.Ragebot.SelectedHitSound = v end},
    HitFont = nil, hitSoundIds = {["Skeet"] = "rbxassetid://4817809188", ["XP Level"] = "rbxassetid://17148249625", ["Bell"] = "rbxassetid://6534948092"},
    remote1 = nil, remote2 = nil, module = nil, silentAimHook = nil, WatermarkConnection = nil, FrameTimer = tick(), FrameCounter = 0, FPS = 60
}

for _, v in next, getgc(true) do
    if typeof(v) == "table" and Config.isAdonisAC(v) then
        for i, f in next, v do
            if rawequal(i, "Detected") then
                local old = hookfunction(f, function(action, info, crash) if rawequal(action, "_") and rawequal(info, "_") and rawequal(crash, false) then return old(action, info, crash) end return task.wait(9e9) end)
                warn("bypassed") break
            end
        end
    end
end

if makefolder then
    makefolder("aui")
    makefolder("aui/fonts")
end
if not isfile or (isfile and not isfile("aui/fonts/main.ttf")) then
    if writefile then
        writefile("aui/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
    end
end
local font_data = {name = "AUIFont", faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset and getcustomasset("aui/fonts/main.ttf") or ""}}}
if writefile and not isfile("aui/fonts/main_encoded.ttf") then
    writefile("aui/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
end
Config.HitFont = Font.new(getcustomasset and getcustomasset("aui/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

Config.Library = loadstring(game:HttpGet(Config.repo .. 'Library.lua'))()
Config.ThemeManager = loadstring(game:HttpGet(Config.repo .. 'addons/ThemeManager.lua'))()
Config.SaveManager = loadstring(game:HttpGet(Config.repo .. 'addons/SaveManager.lua'))()
Config.Options = Config.Library.Options
Config.Toggles = Config.Library.Toggles
Config.Library.ShowToggleFrameInKeybinds = true
Config.Library.ShowCustomCursor = true
Config.Library.NotifySide = "Left"

Config.window = Config.Library:CreateWindow({Title = 'gamesense.cc', Center = true, AutoShow = true, Resizable = true, ShowCustomCursor = true, UnlockMouseWhileOpen = true, NotifySide = "Left", TabPadding = 8, MenuFadeTime = 0.2})
Config.Tabs = {RageBot = Config.window:AddTab('RageBot'), Visual = Config.window:AddTab('Visual'), Misc = Config.window:AddTab('Misc'), Legitbot = Config.window:AddTab('Legitbot'), ['UI Settings'] = Config.window:AddTab('UI Settings')}
Config.ScreenGui.Name = "HitNotifications"
Config.ScreenGui.Parent = game:GetService("CoreGui")

local function CreateHitNotification(toolName, offsetValue, playerName)
    if not Config.Ragebot.HitNotify then return end
    local box = Instance.new("Frame")
    box.Parent = Config.ScreenGui
    box.BackgroundColor3 = Color3.new(0, 0, 0)
    box.BackgroundTransparency = 0.5
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(0, 0)
    box.Position = UDim2.new(0, 10, 0, -50)
    local parts = {{"Using ", Color3.fromRGB(255, 255, 255)}, {toolName.." ", Color3.fromRGB(255, 182, 193)}, {"On ", Color3.fromRGB(255, 255, 255)}, {string.format("%.2f", offsetValue).." ", Color3.fromRGB(255, 182, 193)}, {"in the ", Color3.fromRGB(255, 255, 255)}, {"head ", Color3.fromRGB(255, 182, 193)}, {"to hit ", Color3.fromRGB(255, 255, 255)}, {playerName, Color3.fromRGB(255, 182, 193)}}
    local offsetX, totalW, maxH = 6, 0, 0
    for _, seg in ipairs(parts) do
        local label = Instance.new("TextLabel")
        label.Parent = box
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextColor3 = seg[2]
        label.FontFace = Config.HitFont
        label.TextSize = 12
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = seg[1]
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.Position = UDim2.new(0, offsetX, 0, 0)
        offsetX = offsetX + label.TextBounds.X
        totalW = offsetX
        maxH = math.max(maxH, label.TextBounds.Y)
    end
    box.Size = UDim2.new(0, totalW + 12, 0, maxH + 8)
    local targetY = 10 + (#Config.hitNotifications * (maxH + 8 + 5))
    local slideInTween = Config.TweenService:Create(box, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, targetY)})
    slideInTween:Play()
    table.insert(Config.hitNotifications, box)
    local duration = Config.Ragebot.HitNotifyDuration or 5
    task.delay(duration, function()
        for i, notif in ipairs(Config.hitNotifications) do
            if notif == box then table.remove(Config.hitNotifications, i) break end
        end
        if box then box:Destroy() end
        for i, notif in ipairs(Config.hitNotifications) do
            notif.Position = UDim2.new(0, 10, 0, 10 + ((i - 1) * (notif.AbsoluteSize.Y + 5)))
        end
    end)
end

local function playHitSound()
    if not Config.Ragebot.HitSound then return end
    local soundId = Config.hitSoundIds[Config.Ragebot.SelectedHitSound] or Config.hitSoundIds["Skeet"]
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Parent = Config.Workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 3)
end

local function getCurrentTool()
    if Config.LocalPlayer.Character then
        for _, tool in pairs(Config.LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then return tool end
        end
    end
    return nil
end

local function autoReload()
    if not Config.Ragebot.AutoReload then return end
    local tool = getCurrentTool()
    if not tool then return end
    local values = tool:FindFirstChild("Values")
    if not values then return end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    if ammo.Value <= 0 and storedAmmo.Value > 0 then
        local args = {tick(), "KLWE89U0", tool}
        local GNX_R = Config.ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
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
    if not Config.Ragebot.VisibilityCheck then return true end
    local localHead = Config.LocalPlayer.Character and Config.LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Config.LocalPlayer.Character}
    local startPos = localHead.Position
    local endPos = targetPart.Position
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    local raycastResult = Config.Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Config.Players:GetPlayerFromCharacter(model)
                    if targetPlayer then return true end
                end
            end
            return false
        end
    end
    local secondRaycast = Config.Workspace:Raycast(startPos + direction.Unit * 0.5, direction.Unit * (distance - 0.5), raycastParams)
    if secondRaycast then
        local hitPart = secondRaycast.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Config.Players:GetPlayerFromCharacter(model)
                    if targetPlayer then return true end
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
    for _, player in pairs(Config.Players:GetPlayers()) do
        if player == Config.LocalPlayer then continue end
        if Config.Ragebot.UseWhitelist and table.find(Config.Ragebot.Whitelist, player.Name) then continue end
        if Config.Ragebot.UseTargetList and not table.find(Config.Ragebot.TargetList, player.Name) then continue end
        if Config.Ragebot.TeamCheck and player.Team == Config.LocalPlayer.Team then continue end
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            if humanoid and humanoid.Health > 0 and head then
                local hasForcefield = false
                for _, child in pairs(character:GetChildren()) do
                    if child:IsA("ForceField") then hasForcefield = true break end
                end
                if hasForcefield then continue end
                if Config.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                local distance = (head.Position - Config.LocalPlayer.Character.Head.Position).Magnitude
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
    raycastParams.FilterDescendantsInstances = {Config.LocalPlayer.Character}
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    local raycastResult = Config.Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if not humanoid then return false end
            else return false end
        end
    end
    return true
end

local function wallbang()
    local localHead = Config.LocalPlayer.Character and Config.LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    local target = getClosestTarget()
    if not target then return nil end
    local startPos = localHead.Position
    local targetPos = target.Position
    if not Config.Ragebot.Wallbang then return startPos, targetPos end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Config.LocalPlayer.Character}
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Config.Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    if not directRay then return startPos, targetPos end
    local bestShootPos, bestHitPos, bestScore, wallbangRange = nil, nil, math.huge, Config.Ragebot.WallbangRange or 30
    for i = 1, 2 do
        local shootOffset = Vector3.new(math.random(-wallbangRange, wallbangRange), math.random(-wallbangRange, wallbangRange), math.random(-wallbangRange, wallbangRange))
        local shootPos = startPos + shootOffset
        local hitOffset = Vector3.new(math.random(-wallbangRange, wallbangRange), math.random(-wallbangRange, wallbangRange), math.random(-wallbangRange, wallbangRange))
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
    if not bestShootPos then return nil, nil end
    return bestShootPos, bestHitPos
end

local function createTracer(startPos, endPos)
    if not Config.Ragebot.Tracers then return end
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "TracerBeam"
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(Config.Ragebot.TracerColor)
    beam.Width0 = Config.Ragebot.TracerWidth
    beam.Width1 = Config.Ragebot.TracerWidth
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
    tracerModel.Parent = Config.Workspace
    local tweenInfo = TweenInfo.new(Config.Ragebot.TracerLifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = Config.TweenService:Create(beam, tweenInfo, {Brightness = 0})
    tween:Play()
    tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
end

local function shootAtTarget(targetHead)
    if not targetHead then return false end
    local localHead = Config.LocalPlayer.Character and Config.LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local tool = getCurrentTool()
    if not tool then return false end
    local values = tool:FindFirstChild("Values")
    local hitMarker = tool:FindFirstChild("Hitmarker")
    if not values or not hitMarker then return false end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return false end
    if ammo.Value <= 0 then autoReload() return false end
    local bestShootPos, bestHitPos = wallbang()
    if not bestShootPos or not bestHitPos then return false end
    local hitPosition = bestHitPos
    if Config.Ragebot.Prediction then
        local velocity = targetHead.Velocity or Vector3.zero
        hitPosition = hitPosition + velocity * Config.Ragebot.PredictionAmount
    end
    local hitDirection = (hitPosition - bestShootPos).Unit
    local randomKey = RandomString(30) .. "0"
    local args1 = {tick(), randomKey, tool, "FDS9I83", bestShootPos, {hitDirection}, false}
    local args2 = {"🧈", tool, randomKey, 1, targetHead, hitPosition, hitDirection}
    local events = Config.ReplicatedStorage:WaitForChild("Events")
    local GNX_S = events:WaitForChild("GNX_S")
    local ZFKLF__H = events:WaitForChild("ZFKLF__H")
    local targetPlayer = Config.Players:GetPlayerFromCharacter(targetHead.Parent)
    if targetPlayer then CreateHitNotification(tool.Name, (bestShootPos - localHead.Position).Magnitude, targetPlayer.Name) end
    coroutine.wrap(function() GNX_S:FireServer(unpack(args1)) ZFKLF__H:FireServer(unpack(args2)) end)()
    ammo.Value = math.max(ammo.Value - 1, 0)
    hitMarker:Fire(targetHead)
    storedAmmo.Value = storedAmmo.Value
    createTracer(bestShootPos, hitPosition)
    return true
end

Config.RunService.Heartbeat:Connect(function()
    if not Config.Ragebot.Enabled then return end
    if not Config.LocalPlayer.Character then return end
    if not Config.LocalPlayer.Character:FindFirstChild("Head") then return end
    local currentTime = tick()
    local waitTime = 1 / (Config.Ragebot.FireRate * 5)
    if currentTime - Config.lastShotTime >= waitTime then
        local target = getClosestTarget()
        if target then
            local success = shootAtTarget(target)
            if success then Config.lastShotTime = currentTime end
        end
    end
end)

Config.fovCircle.Visible = Config.Ragebot.ShowFOV
Config.fovCircle.Radius = Config.Ragebot.FOV
Config.fovCircle.Color = Color3.fromRGB(255, 255, 255)
Config.fovCircle.Thickness = 1
Config.fovCircle.Filled = false
Config.RunService.RenderStepped:Connect(function()
    Config.fovCircle.Visible = Config.Ragebot.ShowFOV and Config.Ragebot.Enabled
    Config.fovCircle.Radius = Config.Ragebot.FOV
    Config.fovCircle.Position = Vector2.new(Config.Camera.ViewportSize.X / 2, Config.Camera.ViewportSize.Y / 2)
end)

local function hideHeadFE()
    if not Config.LocalPlayer.Character then return end
    local head = Config.LocalPlayer.Character:FindFirstChild("Head")
    local torso = Config.LocalPlayer.Character:FindFirstChild("Torso") or Config.LocalPlayer.Character:FindFirstChild("UpperTorso")
    if not head or not torso then return end
    local neckMotor = Instance.new("Motor6D")
    neckMotor.Name = "Neck"
    neckMotor.Part0 = torso
    neckMotor.Part1 = head
    neckMotor.C0 = CFrame.new(0, -0.5, 0.5)
    neckMotor.Parent = head
    head.LocalTransparencyModifier = 0
    for _, accessory in pairs(Config.LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then handle.LocalTransparencyModifier = 0 end
        end
    end
end

local function showHeadFE()
    if not Config.LocalPlayer.Character then return end
    local head = Config.LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end
    local neckMotor = head:FindFirstChild("Neck")
    if neckMotor then neckMotor:Destroy() end
    head.LocalTransparencyModifier = 0
    for _, accessory in pairs(Config.LocalPlayer.Character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then handle.LocalTransparencyModifier = 0 end
        end
    end
end

local function enableSpeed()
    if not Config.LocalPlayer.Character then return end
    local humanoidRootPart = Config.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    Config.speedConnection = Config.RunService.Heartbeat:Connect(function()
        if not humanoidRootPart or not humanoidRootPart.Parent then Config.speedConnection:Disconnect() return end
        local camera = Config.Camera
        local lookVector = camera.CFrame.LookVector
        local moveDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        local humanoid = Config.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            humanoidRootPart.AssemblyLinearVelocity = moveDirection * Config.speedValue + Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
        else
            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
        end
    end)
end

local function disableSpeed()
    if Config.speedConnection then Config.speedConnection:Disconnect() end
    if not Config.LocalPlayer.Character then return end
    local humanoidRootPart = Config.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
    end
end

local function enableLoopFOV()
    Config.loopFOVConnection = Config.RunService.Heartbeat:Connect(function()
        Config.Camera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if Config.loopFOVConnection then Config.loopFOVConnection:Disconnect() end
end

local function enableInfStamina()
    for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name == "XIIX" then
            Config.module = require(v)
            local ac = Config.module["XIIX"]
            local glob = getfenv(ac)["_G"]
            local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
            if stamina ~= nil then
                hookfunction(stamina, function() return 100, 100 end)
            end
        end
    end
end

local function enableNoFallDmg()
    Config.noFallForceField = Instance.new("ForceField")
    Config.noFallForceField.Parent = Config.LocalPlayer.Character
    Config.noFallForceField.Visible = false
end

local function disableNoFallDmg()
    if Config.noFallForceField then
        Config.noFallForceField:Destroy()
        Config.noFallForceField = nil
    end
end

Config.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if Config.hideHeadEnabled then hideHeadFE() end
    if Config.speedEnabled then enableSpeed() end
    if Config.loopFOVEnabled then enableLoopFOV() end
    if Config.NoFallDmgEnabled then enableNoFallDmg() end
end)

local function playDanceAnimation(animationName)
    if Config.currentAnimationTrack then
        Config.currentAnimationTrack:Stop()
        Config.currentAnimationTrack = nil
    end
    local player = Config.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local animationData = Config.danceAnimations[animationName]
    if not animationData then return end
    local animation = Instance.new("Animation")
    animation.AnimationId = animationData[1]
    Config.currentAnimationTrack = humanoid:LoadAnimation(animation)
    Config.currentAnimationTrack:Play()
end

local function stopDanceAnimation()
    if Config.currentAnimationTrack then
        Config.currentAnimationTrack:Stop()
        Config.currentAnimationTrack = nil
    end
end

Config.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if Config.currentAnimationTrack then
        wait(1)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local lastAnimationName = nil
            for name, track in pairs(Config.danceAnimations) do
                if track == Config.currentAnimationTrack then
                    lastAnimationName = name
                    break
                end
            end
            if lastAnimationName then playDanceAnimation(lastAnimationName) end
        end
    end
end)

local function CreateFlyMobileGUI()
    Config.Fly.MobileUI = Instance.new("ScreenGui")
    Config.Fly.MobileUI.Name = "FlyMobileUI"
    Config.Fly.MobileUI.Parent = game:GetService("CoreGui")
    Config.Fly.MainFrame = Instance.new("Frame")
    Config.Fly.MainFrame.Name = "FlyMainFrame"
    Config.Fly.MainFrame.Size = UDim2.new(0, 200, 0, 80)
    Config.Fly.MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0)
    Config.Fly.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Config.Fly.MainFrame.BackgroundTransparency = 0.3
    Config.Fly.MainFrame.BorderSizePixel = 0
    Config.Fly.MainFrame.Active = true
    Config.Fly.MainFrame.Draggable = true
    Config.Fly.MainFrame.Visible = Config.Fly.UI
    Config.Fly.MainFrame.Parent = Config.Fly.MobileUI
    Config.Fly.ToggleButton = Instance.new("TextButton")
    Config.Fly.ToggleButton.Name = "FlyToggleButton"
    Config.Fly.ToggleButton.Size = UDim2.new(0.4, 0, 0.4, 0)
    Config.Fly.ToggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    Config.Fly.ToggleButton.BackgroundColor3 = Config.Fly.On and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    Config.Fly.ToggleButton.BackgroundTransparency = 0.2
    Config.Fly.ToggleButton.Text = Config.Fly.On and "ON" or "OFF"
    Config.Fly.ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Config.Fly.ToggleButton.Font = Enum.Font.Gotham
    Config.Fly.ToggleButton.TextSize = 14
    Config.Fly.ToggleButton.Parent = Config.Fly.MainFrame
    Config.Fly.SpeedUp = Instance.new("TextButton")
    Config.Fly.SpeedUp.Name = "SpeedUp"
    Config.Fly.SpeedUp.Size = UDim2.new(0.2, 0, 0.4, 0)
    Config.Fly.SpeedUp.Position = UDim2.new(0.55, 0, 0.05, 0)
    Config.Fly.SpeedUp.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Config.Fly.SpeedUp.BackgroundTransparency = 0.2
    Config.Fly.SpeedUp.Text = "▲"
    Config.Fly.SpeedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    Config.Fly.SpeedUp.Font = Enum.Font.Gotham
    Config.Fly.SpeedUp.TextSize = 16
    Config.Fly.SpeedUp.Parent = Config.Fly.MainFrame
    Config.Fly.SpeedDown = Instance.new("TextButton")
    Config.Fly.SpeedDown.Name = "SpeedDown"
    Config.Fly.SpeedDown.Size = UDim2.new(0.2, 0, 0.4, 0)
    Config.Fly.SpeedDown.Position = UDim2.new(0.8, 0, 0.05, 0)
    Config.Fly.SpeedDown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Config.Fly.SpeedDown.BackgroundTransparency = 0.2
    Config.Fly.SpeedDown.Text = "▼"
    Config.Fly.SpeedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Config.Fly.SpeedDown.Font = Enum.Font.Gotham
    Config.Fly.SpeedDown.TextSize = 16
    Config.Fly.SpeedDown.Parent = Config.Fly.MainFrame
    Config.Fly.SpeedLabel = Instance.new("TextLabel")
    Config.Fly.SpeedLabel.Name = "SpeedLabel"
    Config.Fly.SpeedLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
    Config.Fly.SpeedLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    Config.Fly.SpeedLabel.BackgroundTransparency = 1
    Config.Fly.SpeedLabel.Text = "Speed:"
    Config.Fly.SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    Config.Fly.SpeedLabel.Font = Enum.Font.Gotham
    Config.Fly.SpeedLabel.TextSize = 12
    Config.Fly.SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    Config.Fly.SpeedLabel.Parent = Config.Fly.MainFrame
    Config.Fly.SpeedDisplay = Instance.new("TextLabel")
    Config.Fly.SpeedDisplay.Name = "SpeedDisplay"
    Config.Fly.SpeedDisplay.Size = UDim2.new(0.9, 0, 0.2, 0)
    Config.Fly.SpeedDisplay.Position = UDim2.new(0.05, 0, 0.75, 0)
    Config.Fly.SpeedDisplay.BackgroundTransparency = 1
    Config.Fly.SpeedDisplay.Text = tostring(Config.Fly.Speed)
    Config.Fly.SpeedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    Config.Fly.SpeedDisplay.Font = Enum.Font.Gotham
    Config.Fly.SpeedDisplay.TextSize = 16
    Config.Fly.SpeedDisplay.TextXAlignment = Enum.TextXAlignment.Left
    Config.Fly.SpeedDisplay.Parent = Config.Fly.MainFrame
    Config.Fly.ToggleButton.MouseButton1Click:Connect(function()
        Config.Fly.On = not Config.Fly.On
        Config.Fly.ToggleButton.Text = Config.Fly.On and "ON" or "OFF"
        Config.Fly.ToggleButton.BackgroundColor3 = Config.Fly.On and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        if Config.Fly.On then
            local lp = Config.Players.LocalPlayer
            local char = lp.Character
            if not char then return end
            local humanoid = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not hrp then return end
            humanoid.PlatformStand = true
            Config.flyPart = Instance.new("Part")
            Config.flyPart.Name = "FlyAnchor"
            Config.flyPart.Anchored = false
            Config.flyPart.CanCollide = false
            Config.flyPart.Transparency = 1
            Config.flyPart.Size = Vector3.new(1, 1, 1)
            Config.flyPart.Position = hrp.Position
            Config.flyPart.CFrame = hrp.CFrame
            Config.flyPart.Parent = Config.Workspace
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    local motor = Instance.new("Motor6D")
                    motor.Name = "FlyMotor"
                    motor.Part0 = Config.flyPart
                    motor.Part1 = part
                    motor.C0 = CFrame.new()
                    motor.C1 = part.CFrame:ToObjectSpace(Config.flyPart.CFrame)
                    motor.Parent = Config.flyPart
                end
            end
            Config.flyConn = Config.RunService.Heartbeat:Connect(function()
                if not Config.Fly.On or not char or not hrp then
                    if Config.flyConn then Config.flyConn:Disconnect() Config.flyConn = nil end
                    if Config.flyPart then Config.flyPart:Destroy() Config.flyPart = nil end
                    return
                end
                local look = Config.Camera.CFrame.LookVector
                hrp.Velocity = look * Config.Fly.Speed
                local args = {"__---r", Vector3.new(6.749612331390381, 35.8061637878418, 6.615190029144287), CFrame.new(-3882.54541015625, 2.3969318866729736, -186.0290985107422, 0.48847436904907227, -0.04458007961511612, 0.8714386820793152, -0.19186905026435852, 0.9687637090682983, 0.15710878372192383, -0.8512220978736877, -0.24394573271274567, 0.46466270089149475)}
                pcall(function() Config.ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL"):FireServer(unpack(args)) end)
            end)
        else
            if Config.flyConn then Config.flyConn:Disconnect() Config.flyConn = nil end
            if Config.flyPart then Config.flyPart:Destroy() Config.flyPart = nil end
            local lp = Config.Players.LocalPlayer
            local char = lp.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
            end
        end
    end)
    Config.Fly.SpeedUp.MouseButton1Click:Connect(function()
        Config.Fly.Speed = math.min(Config.Fly.Speed + 10, 200)
        Config.Fly.SpeedDisplay.Text = tostring(Config.Fly.Speed)
    end)
    Config.Fly.SpeedDown.MouseButton1Click:Connect(function()
        Config.Fly.Speed = math.max(Config.Fly.Speed - 10, 10)
        Config.Fly.SpeedDisplay.Text = tostring(Config.Fly.Speed)
    end)
end

local function UpdateFlyUI()
    if Config.Fly.MainFrame then
        Config.Fly.MainFrame.Visible = Config.Fly.UI
    elseif Config.Fly.UI then
        CreateFlyMobileGUI()
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, player in pairs(Config.Players:GetPlayers()) do
        if player == Config.LocalPlayer then continue end
        local character = player.Character
        if not character then continue end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        local distance = (Config.LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = character
        end
    end
    return closestPlayer
end

local function attackTarget(target)
    if not target or not target:FindFirstChild("Head") then return end
    if not Config.LocalPlayer.Character then return end
    local TOOL = Config.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not TOOL then return end
    local attachcd = Config.AttachCD[TOOL.Name] or 0.5
    if tick() - Config.AttachTick >= attachcd then
        Config.remote1 = Config.ReplicatedStorage.Events["XMHH.2"]
        Config.remote2 = Config.ReplicatedStorage.Events["XMHH2.2"]
        local result = Config.remote1:InvokeServer("🍞", tick(), TOOL, "43TRFWX", "Normal", tick(), true)
        if Config.MeleeAura.ShowAnim then
            local animFolder = TOOL:FindFirstChild("AnimsFolder")
            if animFolder then
                local animName = "Slash" .. Config.currentSlash
                local anim = animFolder:FindFirstChild(animName)
                if anim then
                    local animator = Config.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChild("Animator")
                    if animator then
                        animator:LoadAnimation(anim):Play(0.1, 1, 1.3)
                        Config.currentSlash = Config.currentSlash + 1
                        if not animFolder:FindFirstChild("Slash" .. Config.currentSlash) then Config.currentSlash = 1 end
                    end
                end
            end
        end
        task.wait(0.3 + math.random() * 0.2)
        local Handle = TOOL:FindFirstChild("WeaponHandle") or TOOL:FindFirstChild("Handle") or Config.LocalPlayer.Character:FindFirstChild("Left Arm")
        if TOOL then
            local targetPartName = #Config.MeleeAura.TargetPart > 0 and Config.MeleeAura.TargetPart[math.random(1, #Config.MeleeAura.TargetPart)] or Config.ValidMeleeTargetParts[math.random(1, #Config.ValidMeleeTargetParts)]
            local targetPart = target:FindFirstChild(targetPartName)
            if not targetPart then
                targetPart = target:FindFirstChild(Config.ValidMeleeTargetParts[math.random(1, #Config.ValidMeleeTargetParts)])
            end
            if not targetPart then return end
            local arg2 = {"🍞", tick(), TOOL, "2389ZFX34", result, true, Handle, targetPart, target, Config.LocalPlayer.Character.HumanoidRootPart.Position, targetPart.Position}
            if TOOL.Name == "Chainsaw" then
                for i = 1, 15 do Config.remote2:FireServer(unpack(arg2)) end
            else Config.remote2:FireServer(unpack(arg2)) end
            Config.AttachTick = tick()
        end
    end
end

Config.RunService.Heartbeat:Connect(function()
    if Config.MeleeAura.Enabled and Config.LocalPlayer.Character and Config.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
        local target = getClosestPlayer()
        if target then attackTarget(target) end
    end
end)

local function applyVisual(settingType)
    if settingType == "Forcefield" and Config.LocalPlayer.Character then
        for _, part in pairs(Config.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                Config.originalData.Forcefield.Materials[part] = part.Material
                Config.originalData.Forcefield.Colors[part] = part.Color
                Config.originalData.Forcefield.Transparency[part] = part.Transparency
                part.Material = Enum.Material.ForceField
                part.Color = Config.VisualSettings.Forcefield.Color
                part.Transparency = Config.VisualSettings.Forcefield.Transparency
            end
        end
    end
end

local function removeVisual(settingType)
    if settingType == "Forcefield" and Config.LocalPlayer.Character then
        for part in pairs(Config.originalData.Forcefield.Materials) do
            if part and part.Parent then
                part.Material = Config.originalData.Forcefield.Materials[part]
                part.Color = Config.originalData.Forcefield.Colors[part]
                part.Transparency = Config.originalData.Forcefield.Transparency[part]
            end
        end
        Config.originalData.Forcefield = {Materials = {}, Colors = {}, Transparency = {}}
    end
end

Config.LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if Config.VisualSettings.Forcefield.Enabled then applyVisual("Forcefield") end
    if Config.NoFallDmgEnabled then enableNoFallDmg() end
end)

Config.RunService.Heartbeat:Connect(function()
    if not Config.JumpPowerEnabled then return end
    if not Config.LocalPlayer.Character then return end
    local humanoid = Config.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local hrp = Config.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, Config.JumpPowerValue, hrp.Velocity.Z)
    end
end)

local function trackGlobalBullets()
    local bfr = Config.Camera:FindFirstChild("Bullets")
    if not bfr then return end
    local function tblt(blt)
        if not blt:IsA("BasePart") then return end
        local stp = blt.Position
        local lsp = stp
        local stc = 0
        local con
        con = Config.RunService.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if (lsp - stp).Magnitude > 1 then
                    if Config.Legitbot.Tracers.Enabled then
                        local tracerModel = Instance.new("Model")
                        tracerModel.Name = "LegitTracerBeam"
                        local beam = Instance.new("Beam")
                        beam.Color = ColorSequence.new(Config.Legitbot.Tracers.Color)
                        beam.Width0 = Config.Legitbot.Tracers.Width
                        beam.Width1 = Config.Legitbot.Tracers.Width
                        beam.Texture = "rbxassetid://7136858729"
                        beam.TextureSpeed = 1
                        beam.Brightness = Config.Legitbot.Tracers.Brightness
                        beam.LightEmission = Config.Legitbot.Tracers.LightEmission
                        beam.FaceCamera = true
                        local a0 = Instance.new("Attachment")
                        local a1 = Instance.new("Attachment")
                        a0.WorldPosition = stp
                        a1.WorldPosition = lsp
                        beam.Attachment0 = a0
                        beam.Attachment1 = a1
                        beam.Parent = tracerModel
                        a0.Parent = tracerModel
                        a1.Parent = tracerModel
                        tracerModel.Parent = Config.Workspace
                        local tweenInfo = TweenInfo.new(Config.Legitbot.Tracers.Lifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        local tween = Config.TweenService:Create(beam, tweenInfo, {Brightness = 0, LightEmission = 0})
                        tween:Play()
                        tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
                    end
                end
                return
            end
            local cp = blt.Position
            if (cp - lsp).Magnitude < 0.01 then
                stc = stc + 1
                if stc > 3 then
                    con:Disconnect()
                    if (cp - stp).Magnitude > 1 then
                        if Config.Legitbot.Tracers.Enabled then
                            local tracerModel = Instance.new("Model")
                            tracerModel.Name = "LegitTracerBeam"
                            local beam = Instance.new("Beam")
                            beam.Color = ColorSequence.new(Config.Legitbot.Tracers.Color)
                            beam.Width0 = Config.Legitbot.Tracers.Width
                            beam.Width1 = Config.Legitbot.Tracers.Width
                            beam.Texture = "rbxassetid://7136858729"
                            beam.TextureSpeed = 1
                            beam.Brightness = Config.Legitbot.Tracers.Brightness
                            beam.LightEmission = Config.Legitbot.Tracers.LightEmission
                            beam.FaceCamera = true
                            local a0 = Instance.new("Attachment")
                            local a1 = Instance.new("Attachment")
                            a0.WorldPosition = stp
                            a1.WorldPosition = cp
                            beam.Attachment0 = a0
                            beam.Attachment1 = a1
                            beam.Parent = tracerModel
                            a0.Parent = tracerModel
                            a1.Parent = tracerModel
                            tracerModel.Parent = Config.Workspace
                            local tweenInfo = TweenInfo.new(Config.Legitbot.Tracers.Lifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            local tween = Config.TweenService:Create(beam, tweenInfo, {Brightness = 0, LightEmission = 0})
                            tween:Play()
                            tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
                        end
                    end
                end
            else
                stc = 0
                lsp = cp
            end
        end)
    end
    bfr.ChildAdded:Connect(tblt)
    for _, v in ipairs(bfr:GetChildren()) do tblt(v) end
end

if Config.Legitbot.Tracers.Enabled then trackGlobalBullets() end

local script = {functions = {}, locals = {silent_aim_target = nil, silent_aim_is_targetting = false}}
script.functions.new_connection = function(type, func) return type:Connect(func) end
script.functions.get_direction = function(origin, destination) return ((destination - origin).Unit * 1000) end
script.functions.world_to_screen = function(position)
    local viewport_position, on_screen = Config.Camera:WorldToViewportPoint(position)
    return {position = Vector2.new(viewport_position.X, viewport_position.Y), on_screen = on_screen}
end
script.functions.has_character = function(player) return (player and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")) and true or false end
script.functions.get_closest_player = function()
    local mouse_position = Config.UserInputService:GetMouseLocation()
    local radius = math.huge
    local closest_player
    for _, player in Config.Players:GetPlayers() do
        if (player == Config.LocalPlayer) then continue end
        if (not (script.functions.has_character(player))) then continue end
        local screen_position = script.functions.world_to_screen(player.Character.HumanoidRootPart.Position)
        if (not (screen_position.on_screen)) then continue end
        local distance = (mouse_position - screen_position.position).Magnitude
        if distance <= radius and distance <= Config.Legitbot.FOV then
            radius = distance
            closest_player = player
        end
    end
    return closest_player
end

if Config.Legitbot.SilentAim and not Config.silentAimHook then
    Config.silentAimHook = hookmetamethod(game, "__namecall", function(self, ...)
        local args, method = {...}, tostring(getnamecallmethod())
        if (not checkcaller() and (script.locals.silent_aim_is_targetting and script.locals.silent_aim_target) and self == Config.Workspace and method == "Raycast") then
            local origin = args[1]
            args[2] = script.functions.get_direction(origin, script.locals.silent_aim_target.Character.HumanoidRootPart.Position)
            return Config.silentAimHook(self, unpack(args))
        end
        return Config.silentAimHook(self, ...)
    end)
end

script.functions.new_connection(Config.RunService.RenderStepped, function()
    local new_target = script.functions.get_closest_player()
    script.locals.silent_aim_is_targetting = new_target and true or false
    script.locals.silent_aim_target = new_target or nil
end)

local function getPlayerWeapon(player)
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then return tool.Name end
        end
    end
    return "None"
end

local function calculateBoxSize(distance)
    local minSize = Config.ESP.MinBoxSize
    local maxSize = Config.ESP.MaxBoxSize
    local maxDist = Config.ESP.MaxDistance
    local t = math.clamp(distance / maxDist, 0, 1)
    local width = minSize.X + (maxSize.X - minSize.X) * (1 - t)
    local height = minSize.Y + (maxSize.Y - minSize.Y) * (1 - t)
    return Vector2.new(width, height)
end

local function updateESP(player)
    if not Config.ESP.Enabled then return end
    if not player.Character then return end
    if not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if not player.Character:FindFirstChild("Humanoid") then return end
    if player == Config.LocalPlayer then return end
    if Config.ESP.TeamCheck and player.Team == Config.LocalPlayer.Team then return end
    local distance = (Config.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    if distance > Config.ESP.MaxDistance then return end
    local character = player.Character
    local humanoid = character.Humanoid
    local hrp = character.HumanoidRootPart
    if not Config.ESPDrawings[player] then
        Config.ESPDrawings[player] = {Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"), Distance = Drawing.new("Text"), Weapon = Drawing.new("Text"), Snapline = Drawing.new("Line"), HealthBar = {Top = Drawing.new("Square"), Bottom = Drawing.new("Square")}, Arrow = Drawing.new("Triangle")}
        Config.ESPDrawings[player].Box.Filled = false
        Config.ESPDrawings[player].Box.Thickness = Config.ESP.BoxThickness
        Config.ESPDrawings[player].Box.Color = Config.ESP.BoxColor
        Config.ESPDrawings[player].Box.Transparency = Config.ESP.BoxTransparency
        Config.ESPDrawings[player].Name.Font = 2
        Config.ESPDrawings[player].Name.Size = Config.ESP.NameSize
        Config.ESPDrawings[player].Name.Color = Config.ESP.NameColor
        Config.ESPDrawings[player].Name.Outline = true
        Config.ESPDrawings[player].Name.OutlineColor = Color3.new(0, 0, 0)
        Config.ESPDrawings[player].Health.Font = 2
        Config.ESPDrawings[player].Health.Size = Config.ESP.HealthSize
        Config.ESPDrawings[player].Health.Color = Config.ESP.HealthColor
        Config.ESPDrawings[player].Health.Outline = true
        Config.ESPDrawings[player].Health.OutlineColor = Color3.new(0, 0, 0)
        Config.ESPDrawings[player].Distance.Font = 2
        Config.ESPDrawings[player].Distance.Size = Config.ESP.DistanceSize
        Config.ESPDrawings[player].Distance.Color = Config.ESP.DistanceColor
        Config.ESPDrawings[player].Distance.Outline = true
        Config.ESPDrawings[player].Distance.OutlineColor = Color3.new(0, 0, 0)
        Config.ESPDrawings[player].Weapon.Font = 2
        Config.ESPDrawings[player].Weapon.Size = Config.ESP.WeaponSize
        Config.ESPDrawings[player].Weapon.Color = Config.ESP.WeaponColor
        Config.ESPDrawings[player].Weapon.Outline = true
        Config.ESPDrawings[player].Weapon.OutlineColor = Color3.new(0, 0, 0)
        Config.ESPDrawings[player].Snapline.Thickness = Config.ESP.SnaplineThickness
        Config.ESPDrawings[player].Snapline.Color = Config.ESP.SnaplineColor
        Config.ESPDrawings[player].HealthBar.Top.Filled = true
        Config.ESPDrawings[player].HealthBar.Top.Color = Config.ESP.HealthColor
        Config.ESPDrawings[player].HealthBar.Top.Thickness = 1
        Config.ESPDrawings[player].HealthBar.Bottom.Filled = true
        Config.ESPDrawings[player].HealthBar.Bottom.Color = Color3.new(0.2, 0.2, 0.2)
        Config.ESPDrawings[player].HealthBar.Bottom.Thickness = 1
        Config.ESPDrawings[player].Arrow.Filled = true
        Config.ESPDrawings[player].Arrow.Color = Config.ESP.ArrowColor
        Config.ESPDrawings[player].Arrow.Thickness = 1
        Config.ESPDrawings[player].Arrow.Visible = false
    end
    local drawings = Config.ESPDrawings[player]
    local screenPos, onScreen = Config.Camera:WorldToViewportPoint(hrp.Position)
    if not onScreen then
        if Config.ESP.Arrows then
            drawings.Arrow.Visible = true
            local screenCenter = Vector2.new(Config.Camera.ViewportSize.X / 2, Config.Camera.ViewportSize.Y / 2)
            local direction = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Unit
            local arrowDistance = math.min(Config.Camera.ViewportSize.X, Config.Camera.ViewportSize.Y) * 0.4
            local arrowTip = screenCenter + direction * arrowDistance
            local arrowSize = Config.ESP.ArrowSize
            local perp = Vector2.new(-direction.Y, direction.X)
            local leftPoint = arrowTip - direction * arrowSize + perp * (arrowSize / 2)
            local rightPoint = arrowTip - direction * arrowSize - perp * (arrowSize / 2)
            drawings.Arrow.PointA = arrowTip
            drawings.Arrow.PointB = leftPoint
            drawings.Arrow.PointC = rightPoint
        else drawings.Arrow.Visible = false end
        drawings.Box.Visible = false
        drawings.Name.Visible = false
        drawings.Health.Visible = false
        drawings.Distance.Visible = false
        drawings.Weapon.Visible = false
        drawings.Snapline.Visible = false
        drawings.HealthBar.Top.Visible = false
        drawings.HealthBar.Bottom.Visible = false
        return
    else drawings.Arrow.Visible = false end
    local boxSize = calculateBoxSize(distance)
    local boxPos = Vector2.new(screenPos.X - boxSize.X / 2, screenPos.Y - boxSize.Y / 2)
    if Config.ESP.Box then
        drawings.Box.Size = boxSize
        drawings.Box.Position = boxPos
        drawings.Box.Visible = true
    else drawings.Box.Visible = false end
    if Config.ESP.Name then
        drawings.Name.Text = player.Name
        drawings.Name.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 20)
        drawings.Name.Visible = true
    else drawings.Name.Visible = false end
    if Config.ESP.Health then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        drawings.Health.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        drawings.Health.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 5)
        drawings.Health.Color = Color3.fromHSV(healthPercent * 0.3, 1, 1)
        drawings.Health.Visible = true
        local healthBarWidth = 4
        local healthBarX = boxPos.X - 10
        local healthBarY = boxPos.Y
        local healthBarHeight = boxSize.Y
        drawings.HealthBar.Bottom.Size = Vector2.new(healthBarWidth, healthBarHeight)
        drawings.HealthBar.Bottom.Position = Vector2.new(healthBarX, healthBarY)
        drawings.HealthBar.Bottom.Visible = true
        local healthHeight = healthBarHeight * healthPercent
        drawings.HealthBar.Top.Size = Vector2.new(healthBarWidth, healthHeight)
        drawings.HealthBar.Top.Position = Vector2.new(healthBarX, healthBarY + (healthBarHeight - healthHeight))
        drawings.HealthBar.Top.Color = Color3.fromHSV(healthPercent * 0.3, 1, 1)
        drawings.HealthBar.Top.Visible = true
    else drawings.Health.Visible = false drawings.HealthBar.Top.Visible = false drawings.HealthBar.Bottom.Visible = false end
    if Config.ESP.Distance then
        drawings.Distance.Text = math.floor(distance) .. " on visuals"
        drawings.Distance.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 25)
        drawings.Distance.Visible = true
    else drawings.Distance.Visible = false end
    if Config.ESP.Weapon then
        drawings.Weapon.Text = getPlayerWeapon(player)
        drawings.Weapon.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 45)
        drawings.Weapon.Visible = true
    else drawings.Weapon.Visible = false end
    if Config.ESP.ShowSnaplines then
        local screenCenter = Vector2.new(Config.Camera.ViewportSize.X / 2, Config.Camera.ViewportSize.Y / 2)
        drawings.Snapline.From = screenCenter
        drawings.Snapline.To = Vector2.new(screenPos.X, screenPos.Y)
        drawings.Snapline.Visible = true
    else drawings.Snapline.Visible = false end
end

local function removeESP(player)
    if Config.ESPDrawings[player] then
        for _, drawing in pairs(Config.ESPDrawings[player]) do
            if type(drawing) == "table" then
                for _, subDrawing in pairs(drawing) do
                    if subDrawing and typeof(subDrawing) == "Instance" then subDrawing:Remove() end
                end
            elseif drawing and typeof(drawing) == "Instance" then drawing:Remove() end
        end
        Config.ESPDrawings[player] = nil
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not Config.ESP.Enabled then
        for player, drawings in pairs(Config.ESPDrawings) do removeESP(player) end
        return
    end
    local playersToRemove = {}
    for player, _ in pairs(Config.ESPDrawings) do playersToRemove[player] = true end
    for _, player in pairs(Config.Players:GetPlayers()) do
        if player ~= Config.LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local distance = (Config.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= Config.ESP.MaxDistance then
                    updateESP(player)
                    playersToRemove[player] = nil
                end
            end
        end
    end
    for player, _ in pairs(playersToRemove) do removeESP(player) end
end)

Config.Players.PlayerRemoving:Connect(function(player) removeESP(player) end)
Config.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Config.ESP.Enabled then task.wait(1) updateESP(player) end
    end)
end)

local RagebotLeft = Config.Tabs.RageBot:AddLeftGroupbox('Ragebot')
local RagebotRight = Config.Tabs.RageBot:AddRightGroupbox('Targeting')
local MeleeLeft = Config.Tabs.RageBot:AddLeftGroupbox('Melee Aura')
local MeleeRight = Config.Tabs.RageBot:AddRightGroupbox('Melee Settings')

RagebotLeft:AddToggle('RagebotEnabled', {Text = 'Enable', Default = false, Callback = function(s) Config.Ragebot.Enabled = s end})
RagebotLeft:AddToggle('RagebotHitSound', {Text = 'Hit Sound', Default = true, Callback = function(s) Config.Ragebot.HitSound = s end})
RagebotLeft:AddToggle('RagebotAutoReload', {Text = 'Auto Reload', Default = true, Callback = function(s) Config.Ragebot.AutoReload = s end})
RagebotLeft:AddSlider('RagebotFireRate', {Text = 'Fire Rate', Min = 1, Max = 1000, Default = 30, Rounding = 1, Callback = function(v) Config.Ragebot.FireRate = v end})
RagebotLeft:AddSlider('RagebotWallbangRange', {Text = 'Wallbang Range', Min = 10, Max = 30, Default = 30, Rounding = 1, Callback = function(v) Config.Ragebot.WallbangRange = v end})
RagebotRight:AddToggle('RagebotTeamCheck', {Text = 'Team Check', Default = false, Callback = function(s) Config.Ragebot.TeamCheck = s end})
RagebotRight:AddToggle('RagebotVisibilityCheck', {Text = 'Vis Check', Default = true, Callback = function(s) Config.Ragebot.VisibilityCheck = s end})
RagebotRight:AddToggle('RagebotWallbang', {Text = 'Wallbang', Default = true, Callback = function(s) Config.Ragebot.Wallbang = s end})
RagebotRight:AddSlider('RagebotFOV', {Text = 'FOV', Min = 10, Max = 360, Default = 120, Rounding = 1, Callback = function(v) Config.Ragebot.FOV = v end})
RagebotRight:AddToggle('RagebotShowFOV', {Text = 'Show FOV', Default = true, Callback = function(s) Config.Ragebot.ShowFOV = s end})
RagebotRight:AddToggle('RagebotLowHealthCheck', {Text = 'Downed Check', Default = false, Callback = function(s) Config.Ragebot.LowHealthCheck = s end})
MeleeLeft:AddToggle('MeleeAuraEnabled', {Text = 'Melee Aura', Default = true, Callback = function(s) Config.MeleeAura.Enabled = s end})
MeleeLeft:AddToggle('MeleeAuraShowAnim', {Text = 'Show Anim', Default = true, Callback = function(s) Config.MeleeAura.ShowAnim = s end})
MeleeRight:AddDropdown('MeleeAuraTargetParts', {Text = 'Target Parts', Values = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}, Default = {"Head", "UpperTorso"}, Multi = true, Callback = function(selected) Config.MeleeAura.TargetPart = selected end})

local VisualsLeft = Config.Tabs.Visual:AddLeftGroupbox('ESP')
local VisualsRight = Config.Tabs.Visual:AddRightGroupbox('Colors')
local EffectsLeft = Config.Tabs.Visual:AddLeftGroupbox('Effects')
local EffectsRight = Config.Tabs.Visual:AddRightGroupbox('Tracers')
local CharacterVisuals = Config.Tabs.Visual:AddLeftGroupbox('Character')
local Notifications = Config.Tabs.Visual:AddRightGroupbox('Notifications')

VisualsLeft:AddToggle('ESPEnabled', {Text = 'Enable ESP', Default = false, Callback = function(s) Config.ESP.Enabled = s end})
VisualsLeft:AddToggle('ESPBox', {Text = 'Box', Default = true, Callback = function(s) Config.ESP.Box = s end})
VisualsLeft:AddToggle('ESPName', {Text = 'Name', Default = true, Callback = function(s) Config.ESP.Name = s end})
VisualsLeft:AddToggle('ESPHealth', {Text = 'Health', Default = true, Callback = function(s) Config.ESP.Health = s end})
VisualsLeft:AddToggle('ESPDistance', {Text = 'Distance', Default = true, Callback = function(s) Config.ESP.Distance = s end})
VisualsLeft:AddToggle('ESPWeapon', {Text = 'Weapon', Default = true, Callback = function(s) Config.ESP.Weapon = s end})
VisualsLeft:AddToggle('ESPTeamCheck', {Text = 'Team Check', Default = false, Callback = function(s) Config.ESP.TeamCheck = s end})
VisualsLeft:AddToggle('ESPTeamColor', {Text = 'Team Color', Default = true, Callback = function(s) Config.ESP.TeamColor = s end})
VisualsLeft:AddToggle('ESPSnaplines', {Text = 'Snaplines', Default = false, Callback = function(s) Config.ESP.ShowSnaplines = s end})
VisualsLeft:AddToggle('ESPArrows', {Text = 'Arrows', Default = false, Callback = function(s) Config.ESP.Arrows = s end})
VisualsLeft:AddSlider('ESPMaxDistance', {Text = 'Max Distance', Min = 50, Max = 1000, Default = 500, Rounding = 1, Callback = function(v) Config.ESP.MaxDistance = v end})
VisualsRight:AddLabel('Box Color'):AddColorPicker('ESPBoxColor', {Default = Color3.fromRGB(255, 255, 255), Callback = function(c) Config.ESP.BoxColor = c end})
VisualsRight:AddLabel('Name Color'):AddColorPicker('ESPNameColor', {Default = Color3.fromRGB(255, 255, 255), Callback = function(c) Config.ESP.NameColor = c end})
VisualsRight:AddLabel('Health Color'):AddColorPicker('ESPHealthColor', {Default = Color3.fromRGB(0, 255, 0), Callback = function(c) Config.ESP.HealthColor = c end})
VisualsRight:AddLabel('Distance Color'):AddColorPicker('ESPDistanceColor', {Default = Color3.fromRGB(255, 255, 255), Callback = function(c) Config.ESP.DistanceColor = c end})
VisualsRight:AddLabel('Weapon Color'):AddColorPicker('ESPWeaponColor', {Default = Color3.fromRGB(255, 182, 193), Callback = function(c) Config.ESP.WeaponColor = c end})
VisualsRight:AddLabel('Snapline Color'):AddColorPicker('ESPSnaplineColor', {Default = Color3.fromRGB(255, 0, 0), Callback = function(c) Config.ESP.SnaplineColor = c end})
VisualsRight:AddLabel('Arrow Color'):AddColorPicker('ESPArrowColor', {Default = Color3.fromRGB(255, 255, 255), Callback = function(c) Config.ESP.ArrowColor = c end})
VisualsRight:AddSlider('ESPBoxTransparency', {Text = 'Box Transparency', Min = 0, Max = 1, Default = 0.5, Rounding = 1, Callback = function(v) Config.ESP.BoxTransparency = v end})
VisualsRight:AddSlider('ESPArrowSize', {Text = 'Arrow Size', Min = 10, Max = 50, Default = 30, Rounding = 1, Callback = function(v) Config.ESP.ArrowSize = v end})
EffectsLeft:AddToggle('RagebotTracers', {Text = 'Tracers', Default = true, Callback = function(s) Config.Ragebot.Tracers = s end})
EffectsLeft:AddSlider('RagebotTracerWidth', {Text = 'Tracer Width', Min = 0.1, Max = 5, Default = 1, Rounding = 1, Callback = function(v) Config.Ragebot.TracerWidth = v end})
EffectsLeft:AddSlider('RagebotTracerLifetime', {Text = 'Tracer Lifetime', Min = 0.5, Max = 10, Default = 3, Rounding = 1, Callback = function(v) Config.Ragebot.TracerLifetime = v end})
EffectsRight:AddLabel('Tracer Color'):AddColorPicker('RagebotTracerColor', {Default = Color3.fromRGB(255, 0, 0), Callback = function(c) Config.Ragebot.TracerColor = c end})
EffectsRight:AddLabel('Hit Color'):AddColorPicker('HitNotificationColor', {Default = Color3.fromRGB(255, 182, 193), Callback = function(c) Config.Ragebot.TracerColor = c end})
CharacterVisuals:AddToggle('ForcefieldEnabled', {Text = 'Forcefield', Default = false, Callback = function(s) Config.VisualSettings.Forcefield.Enabled = s if s then applyVisual("Forcefield") else removeVisual("Forcefield") end end})
CharacterVisuals:AddSlider('ForcefieldTransparency', {Text = 'FF Transparency', Min = 0, Max = 1, Default = 0.3, Rounding = 1, Callback = function(v) Config.VisualSettings.Forcefield.Transparency = v if Config.VisualSettings.Forcefield.Enabled then applyVisual("Forcefield") end end})
Notifications:AddToggle('RagebotHitNotify', {Text = 'Hit Notify', Default = true, Callback = function(s) Config.Ragebot.HitNotify = s end})
Notifications:AddSlider('RagebotHitNotifyDuration', {Text = 'Notify Duration', Min = 1, Max = 10, Default = 5, Rounding = 1, Callback = function(v) Config.Ragebot.HitNotifyDuration = v end})
Notifications:AddDropdown('HitSoundList', Config.hitSoundList)

local MiscLeft = Config.Tabs.Misc:AddLeftGroupbox('Character')
local MiscRight = Config.Tabs.Misc:AddRightGroupbox('Exploits')
local DanceSection = Config.Tabs.Misc:AddLeftGroupbox('Dance')
local FlySection = Config.Tabs.Misc:AddRightGroupbox('Fly')
local ShaderSection = Config.Tabs.Misc:AddRightGroupbox('Shader')
local ListsLeft = Config.Tabs.Misc:AddLeftGroupbox('Targets')
local ListsRight = Config.Tabs.Misc:AddRightGroupbox('Whitelist')

MiscLeft:AddToggle('HideHead', {Text = 'Hide Head', Default = false, Callback = function(s) Config.hideHeadEnabled = s if s then hideHeadFE() else showHeadFE() end end})
MiscLeft:AddToggle('SpeedEnabled', {Text = 'Speed', Default = false, Callback = function(s) Config.speedEnabled = s if s then enableSpeed() else disableSpeed() end end})
MiscLeft:AddSlider('SpeedValue', {Text = 'Speed Value', Min = 10, Max = 200, Default = 50, Rounding = 1, Callback = function(v) Config.speedValue = v end})
MiscLeft:AddToggle('LoopFOV', {Text = 'Loop FOV', Default = false, Callback = function(s) Config.loopFOVEnabled = s if s then enableLoopFOV() else disableLoopFOV() end end})
MiscRight:AddToggle('InfStamina', {Text = 'Inf Stamina', Default = false, Callback = function(s) Config.infStaminaEnabled = s if s then enableInfStamina() end end})
MiscRight:AddToggle('NoFallDmg', {Text = 'No Fall Dmg', Default = false, Callback = function(s) Config.NoFallDmgEnabled = s if s then enableNoFallDmg() else disableNoFallDmg() end end})
MiscRight:AddToggle('LockpickHBE', {Text = 'Lockpick HBE', Default = false, Callback = function(s) Config.lockpickHBEEnabled = s end})
MiscRight:AddToggle('JumpPower', {Text = 'Jump Power', Default = false, Callback = function(s) Config.JumpPowerEnabled = s end})
MiscRight:AddSlider('JumpPowerValue', {Text = 'Jump Value', Min = 50, Max = 300, Default = 100, Rounding = 1, Callback = function(v) Config.JumpPowerValue = v end})
for danceName, _ in pairs(Config.danceAnimations) do DanceSection:AddButton({Text = danceName, Func = function() playDanceAnimation(danceName) end}) end
DanceSection:AddButton({Text = 'Stop Dance', Func = function() stopDanceAnimation() end})
FlySection:AddToggle('FlyEnabled', {Text = 'Fly', Default = false, Callback = function(s) Config.Fly.On = s if s and Config.Fly.UI then CreateFlyMobileGUI() elseif Config.Fly.MainFrame then Config.Fly.MainFrame.Visible = s end end})
FlySection:AddToggle('FlyUI', {Text = 'Mobile UI', Default = false, Callback = function(s) Config.Fly.UI = s UpdateFlyUI() end})
FlySection:AddSlider('FlySpeed', {Text = 'Fly Speed', Min = 10, Max = 200, Default = 50, Rounding = 1, Callback = function(v) Config.Fly.Speed = v if Config.Fly.SpeedDisplay then Config.Fly.SpeedDisplay.Text = tostring(v) end end})
ShaderSection:AddToggle('RichShader', {Text = 'Rich Shader', Default = false, Callback = function(s) Config.RichShaderEnabled = s if s then Config.colorCorrection = Instance.new("ColorCorrectionEffect") Config.colorCorrection.Parent = game:GetService("Lighting") else if Config.colorCorrection then Config.colorCorrection:Destroy() Config.colorCorrection = nil end end end})
ShaderSection:AddSlider('Brightness', {Text = 'Brightness', Min = -1, Max = 1, Default = 0, Rounding = 1, Callback = function(v) if Config.colorCorrection then Config.colorCorrection.Brightness = v end end})
ShaderSection:AddSlider('Contrast', {Text = 'Contrast', Min = -1, Max = 1, Default = 0, Rounding = 1, Callback = function(v) if Config.colorCorrection then Config.colorCorrection.Contrast = v end end})
ShaderSection:AddSlider('Saturation', {Text = 'Saturation', Min = -1, Max = 1, Default = 0, Rounding = 1, Callback = function(v) if Config.colorCorrection then Config.colorCorrection.Saturation = v end end})
ShaderSection:AddLabel('Tint Color'):AddColorPicker('TintColor', {Default = Color3.new(1, 1, 1), Callback = function(c) if Config.colorCorrection then Config.colorCorrection.TintColor = c end end})
ListsLeft:AddToggle('UseTargetList', {Text = 'Use Target List', Default = false, Callback = function(s) Config.Ragebot.UseTargetList = s end})
ListsLeft:AddInput('AddTarget', {Text = 'Add Target', Default = '', Placeholder = 'Player Name', Callback = function(text) if text and text ~= "" then table.insert(Config.Ragebot.TargetList, text) end end})
ListsLeft:AddButton({Text = 'Clear Targets', Func = function() Config.Ragebot.TargetList = {} end})
ListsRight:AddToggle('UseWhitelist', {Text = 'Use Whitelist', Default = false, Callback = function(s) Config.Ragebot.UseWhitelist = s end})
ListsRight:AddInput('AddWhitelist', {Text = 'Add Whitelist', Default = '', Placeholder = 'Player Name', Callback = function(text) if text and text ~= "" then table.insert(Config.Ragebot.Whitelist, text) end end})
ListsRight:AddButton({Text = 'Clear Whitelist', Func = function() Config.Ragebot.Whitelist = {} end})

local LegitbotLeft = Config.Tabs.Legitbot:AddLeftGroupbox('Aim')
local LegitbotRight = Config.Tabs.Legitbot:AddRightGroupbox('FOV')
local LegitVisualLeft = Config.Tabs.Legitbot:AddLeftGroupbox('Visual')

LegitbotLeft:AddToggle('LegitbotSilentAim', {Text = 'Silent Aim', Default = false, Callback = function(s) Config.Legitbot.SilentAim = s end})
LegitbotRight:AddSlider('LegitbotFOV', {Text = 'FOV', Min = 10, Max = 1000, Default = 120, Rounding = 1, Callback = function(v) Config.Legitbot.FOV = v Config.fovCircle.Radius = v end})
LegitbotRight:AddToggle('LegitbotShowFOV', {Text = 'Show FOV', Default = true, Callback = function(s) Config.Legitbot.ShowFOV = s Config.fovCircle.Visible = s end})
LegitbotRight:AddLabel('FOV Color'):AddColorPicker('LegitbotFOVColor', {Default = Color3.fromRGB(255, 255, 255), Callback = function(c) Config.fovCircle.Color = c end})
LegitVisualLeft:AddToggle('LegitbotTracers', {Text = 'Bullet Tracers', Default = false, Callback = function(s) Config.Legitbot.Tracers.Enabled = s if s then trackGlobalBullets() end end})
LegitVisualLeft:AddSlider('LegitbotTracerWidth', {Text = 'Tracer Width', Min = 0.1, Max = 5, Default = 1, Rounding = 1, Callback = function(v) Config.Legitbot.Tracers.Width = v end})
LegitVisualLeft:AddSlider('LegitbotTracerBrightness', {Text = 'Tracer Bright', Min = 1, Max = 10, Default = 5, Rounding = 1, Callback = function(v) Config.Legitbot.Tracers.Brightness = v end})
LegitVisualLeft:AddLabel('Tracer Color'):AddColorPicker('LegitbotTracerColor', {Default = Color3.fromRGB(255, 182, 193), Callback = function(c) Config.Legitbot.Tracers.Color = c end})

local MenuGroup = Config.Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddToggle("KeybindMenuOpen", {Default = Config.Library.KeybindFrame.Visible, Text = "Keybind Menu", Callback = function(value) Config.Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Config.Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
MenuGroup:AddButton("Unload", function() Config.Library:Unload() end)
Config.Library.ToggleKeybind = Config.Options.MenuKeybind

ThemeManager:SetLibrary(Config.Library)
SaveManager:SetLibrary(Config.Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/gamesense')
SaveManager:BuildConfigSection(Config.Tabs['UI Settings'])
ThemeManager:ApplyToTab(Config.Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
