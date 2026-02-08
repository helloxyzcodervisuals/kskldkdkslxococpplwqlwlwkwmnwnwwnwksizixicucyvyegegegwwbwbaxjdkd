local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
repeat task.wait() until game:IsLoaded()
do
    local function isAdonisAC(tab) return rawget(tab,"Detected") and typeof(rawget(tab,"Detected"))=="function" and rawget(tab,"RLocked") end
    for _,v in next,getgc(true) do if typeof(v)=="table" and isAdonisAC(v) then for i,f in next,v do if rawequal(i,"Detected") then local old old=hookfunction(f,function(action,info,crash)if rawequal(action,"_") and rawequal(info,"_") and rawequal(crash,false) then return old(action,info,crash) end return task.wait(9e9) end) warn("bypassed") break end end end end
end
for _,v in pairs(getgc(true)) do if type(v)=="table" then local func=rawget(v,"DTXC1") if type(func)=="function" then hookfunction(func,function() return end) break end end end
getgenv().CONFIG = getgenv().CONFIG or {
    Ragebot = {
        Enabled = false, RapidFire = false, FireRate = 30, Prediction = true,
        PredictionAmount = 0.12, TeamCheck = false, VisibilityCheck = true,
        FOV = 9e9, ShowFOV = false, Wallbang = true, Tracers = true,
        TracerColor = Color3.fromRGB(255,0,0), TracerWidth = 1,
        TracerLifetime = 3, ShootRange = 15, HitRange = 15,
        HitNotify = true, AutoReload = true, HitSound = true,
        HitColor = Color3.fromRGB(255,182,193), UseTargetList = true,
        UseWhitelist = true, HitNotifyDuration = 5, LowHealthCheck = false,
        SelectedHitSound = "skeet", FriendCheck = false, MaxTarget = 0
    }
}
local library, notifications, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/ggc.lua"))()
local function Register_Font()
    local HttpService = game:GetService("HttpService")
    
    if not isfile("ProggyTiny.ttf") then
        writefile("ProggyTiny.ttf", game:HttpGet("https://raw.githubusercontent.com/i77lhm/storage/refs/heads/main/fonts/ProggyClean.ttf"))
    end
    
    local fontData = {
        name = "ProggyTinyFont",
        faces = {{
            name = "Normal",
            weight = 400,
            style = "normal",
            assetId = getcustomasset("ProggyTiny.ttf")
        }}
    }
    
    writefile("ProggyTiny.font", HttpService:JSONEncode(fontData))
    return getcustomasset("ProggyTiny.font")
end

local AFont = Font.new(Register_Font(), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local dim2 = UDim2.new 
local hex = Color3.fromHex
local screenY=Workspace.CurrentCamera.ViewportSize.Y
local Y=screenY<400 and 350 or 550
    local window = library:window({
        name = os.date('<font color="rgb(170,85,235)">gamesense</font>.cc'),
        size = dim2(0, 600, 0, Y)
    })
--[[
local Legit = window:tab({name = "Legitbot"})
local leftColumnLegit = Legit:column({fill = true})
local rightColumnLegit = Legit:column({fill = true})

local LegitMainSection = leftColumnLegit:section({name = "Main"})
local LegitSettingsSection = leftColumnLegit:section({name = "Settings"})

local legitEnabled = false
local legitSilentAim = false
local legitAimAssist = false
local legitFov = 100
local legitSmoothness = 0.1
local legitAimMethod = "mouse"
local legitIgnoreWalls = true
local legitIgnoreForcefield = true
local legitIgnoreFriendlies = true
local legitAiming = false
local legitSilentTarget = nil
local legitSilentTargeting = false

local legitRenderConnection = nil
local legitSilentHook = nil

local function calculateDirection(origin, destination)
    return ((destination - origin).Unit * 1000)
end

local function getClosestPlayerByMouse()
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        
        if legitIgnoreFriendlies and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        
        local hasForcefield = false
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("ForceField") then
                hasForcefield = true
                break
            end
        end
        if legitIgnoreForcefield and hasForcefield then continue end
        
        if legitIgnoreWalls then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            local targetHead = player.Character:FindFirstChild("Head")
            if localHead and targetHead then
                local startPos = localHead.Position
                local endPos = targetHead.Position
                local direction = (endPos - startPos)
                local distance = direction.Magnitude
                
                local ray = Ray.new(startPos, direction.Unit * distance)
                local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                
                if part then
                    local model = part:FindFirstAncestorWhichIsA("Model")
                    if model then
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            local targetPlayer = Players:GetPlayerFromCharacter(model)
                            if targetPlayer and targetPlayer == player then
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                end
            end
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
        if not onScreen then continue end
        
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if distance < legitFov and distance < closestDist then
            closestDist = distance
            closestPlayer = player
        end
    end
    
    return closestPlayer
end

local function getClosestPlayerByDistance()
    local cameraPos = Camera.CFrame.Position
    local closestPlayer = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        
        if legitIgnoreFriendlies and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        
        local hasForcefield = false
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("ForceField") then
                hasForcefield = true
                break
            end
        end
        if legitIgnoreForcefield and hasForcefield then continue end
        
        if legitIgnoreWalls then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            local targetHead = player.Character:FindFirstChild("Head")
            if localHead and targetHead then
                local startPos = localHead.Position
                local endPos = targetHead.Position
                local direction = (endPos - startPos)
                local distance = direction.Magnitude
                
                local ray = Ray.new(startPos, direction.Unit * distance)
                local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                
                if part then
                    local model = part:FindFirstAncestorWhichIsA("Model")
                    if model then
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            local targetPlayer = Players:GetPlayerFromCharacter(model)
                            if targetPlayer and targetPlayer == player then
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                end
            end
        end
        
        local charPos = player.Character.HumanoidRootPart.Position
        local distance = (charPos - cameraPos).Magnitude
        
        if distance < closestDist then
            closestDist = distance
            closestPlayer = player
        end
    end
    
    return closestPlayer
end

LegitMainSection:addToggle({name = "Enabled", flag = "legit_enabled", callback = function(value)
    legitEnabled = value
    if value then
        if legitRenderConnection then
            legitRenderConnection:Disconnect()
        end
        
        legitRenderConnection = RunService.RenderStepped:Connect(function()
            if not legitEnabled then return end
            
            if legitSilentAim then
                local closestPlayer
                if legitAimMethod == "mouse" then
                    closestPlayer = getClosestPlayerByMouse()
                else
                    closestPlayer = getClosestPlayerByDistance()
                end
                
                if closestPlayer then
                    legitSilentTarget = closestPlayer
                    legitSilentTargeting = true
                else
                    legitSilentTarget = nil
                    legitSilentTargeting = false
                end
            end
            
            if legitAimAssist and legitAiming then
                local target
                if legitAimMethod == "mouse" then
                    target = getClosestPlayerByMouse()
                else
                    target = getClosestPlayerByDistance()
                end
                
                if target and target.Character then
                    local currentCF = Camera.CFrame
                    local targetPos = target.Character.Head.Position
                    local camPos = currentCF.Position
                    
                    if legitSmoothness > 0 then
                        local targetDir = (targetPos - camPos).Unit
                        local currentDir = currentCF.LookVector
                        local newDir = currentDir:Lerp(targetDir, legitSmoothness)
                        Camera.CFrame = CFrame.new(camPos, camPos + newDir)
                    else
                        Camera.CFrame = CFrame.new(camPos, targetPos)
                    end
                end
            end
        end)
        
        if not legitSilentHook then
            local __namecall
            __namecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args, method = {...}, getnamecallmethod()
                
                if not checkcaller() and tostring(method) == "Raycast" and self == Workspace then
                    if legitSilentAim and legitSilentTargeting and legitSilentTarget and legitSilentTarget.Character then
                        local origin = args[1]
                        args[2] = calculateDirection(origin, legitSilentTarget.Character.Head.Position)
                        return __namecall(self, unpack(args))
                    end
                end
                
                return __namecall(self, ...)
            end)
            legitSilentHook = true
        end
    else
        if legitRenderConnection then
            legitRenderConnection:Disconnect()
            legitRenderConnection = nil
        end
    end
end})

LegitMainSection:addToggle({name = "Silent Aim", flag = "legit_silent_aim", callback = function(value)
    legitSilentAim = value
end})

LegitMainSection:addToggle({name = "Aim Assist", flag = "legit_aim_assist", callback = function(value)
    legitAimAssist = value
end})

LegitMainSection:addKeyBind({name = "Aim Key", flag = "legit_aim_key", callback = function(value)
    legitAiming = value
end})

LegitSettingsSection:addDropdown({name = "Aim Method", flag = "legit_aim_method", items = {"mouse", "distance"}, default = "mouse", callback = function(value)
    legitAimMethod = value
end})

LegitSettingsSection:addSlider({name = "FOV", flag = "legit_fov", min = 0, max = 500, default = 100, callback = function(value)
    legitFov = value
end})

LegitSettingsSection:addSlider({name = "Smoothness", flag = "legit_smoothness", min = 0, max = 1, default = 0.1, callback = function(value)
    legitSmoothness = value
end})

LegitSettingsSection:addToggle({name = "Ignore Walls", flag = "legit_ignore_walls", callback = function(value)
    legitIgnoreWalls = value
end})

LegitSettingsSection:addToggle({name = "Ignore ForceField", flag = "legit_ignore_forcefield", callback = function(value)
    legitIgnoreForcefield = value
end})

LegitSettingsSection:addToggle({name = "Ignore Friendlies", flag = "legit_ignore_friendlies", callback = function(value)
    legitIgnoreFriendlies = value
end})
--]]
--[[
local dim2 = UDim2.new 
local hex = Color3.fromHex 

-- documentation 
    local window = library:window({
        name = os.date('<font color="rgb(170,85,235)">obelus</font> | %b %d %Y'),
        size = dim2(0, 516, 0, 563)
    })  
    
    -- Aiming 
        local Aiming = window:tab({name = "Legit"})

        local column = Aiming:column({fill = true}) 

        -- Column 
            local section = column:section({name = "Target Selection"})
            section:addToggle({name = "Enabled", flag = "target_selected"})
            :addKeyBind({name = "Aiming", flag = "target_selected_bind", callback = function(bool) print(bool) end})
            section:addToggle({name = "Auto Select", flag = "auto_select"})
            section:addToggle({name = "Ignore Friendlies", flag = "ignore_friendlies"})
            section:addDropdown({name = "Origin", flag = "distance_priority", items = {"Mouse", "Distance"}, default = "Mouse"})
            section:addSlider({name = "Fov", min = 0, max = 100, default = 100, interval = 1, suffix = "°", flag = "target_selector_fov"})
            section:addSlider({name = "Delay", min = 0, max = 1000, default = 40, interval = 1, suffix = "ms", flag = "target_selector_refresh_time"})
            section:addDropdown({name = "Checks", flag = "target_selected_checks", items = {"Knocked", "ForceField", "Wall"}, multi = true})
            section:addToggle({name = "Look At", flag = "look_at"})
            section:addToggle({name = "Spectate", flag = "spectate"})
            --:addToggle({name = "Auto Stomp", flag = "target_auto_stomp"})
            local toggle = section:addToggle({name = "Tracer", flag = "snap_line", folding = true})
            toggle:addColorPicker({name = "Tracer Inline", flag = "snap_line_color", color = hex("#7D0DC3")})
            toggle:addSlider({name = "Thickness", min = 1, max = 5, default = 1, interval = 1, suffix = "°", flag = "target_snap_line_thickness"})
            local toggle = section:addToggle({name = "Bounding Box", flag = "target_bounding_box", folding = true})
            toggle:addColorPicker({name = "Bounding Box Color", flag = "target_bounding_box_settings", color = hex("#000000")})
            toggle:addToggle({name = "Fill", flag = "target_bounding_box_fill"})
            toggle:addColorPicker({name = "Bounding Box Fill", flag = "bounding_box_fill_settings", color = hex("#7D0DC3")})
            toggle:addDropdown({name = "Material", flag = "target_bounding_box_material", items = {"ForceField", "Neon", "Plastic"}})    
            local toggle = section:addToggle({name = "Field Of View", flag = "fov", folding = true})   
            toggle:addColorPicker({name = "1st Color (Gradient)", flag = "fov_1_settings", color = hex("#7D0DC3"), alpha = 0.5}) 
            toggle:addColorPicker({name = "2nd Color (Gradient)", flag = "fov_2_settings", color = hex("#7D0DC3"), alpha = 0.5}) 
            toggle:addToggle({name = "Outline", flag = "outline_fov"})  
            toggle:addColorPicker({name = "Outline Settings", flag = "outline_fov_settings", color = hex("#000000")}) 
            toggle:addSlider({name = "Thickness", min = 0, max = 5, default = 1, interval = 1, flag = "outline_thickness_fov"})
            toggle:addSlider({name = "Custom Rotation", min = -180, max = 180, default = 0, interval = 1, flag = "custom_rotation_fov"})
            toggle:addToggle({name = "Spin", flag = "spin_fov"})
            toggle:addSlider({name = "Rotation Speed", min = 0, max = 100, default = 100, interval = 1, flag = "spin_speed_fov"})
            toggle:addLabel({name = "Hello!!! >_<"})
            section:addLabel({name = "Hello!!! >_<"})
        -- 
        
        local column = Aiming:column({fill = true})
            local section = column:section({name = "Silent Aim"})  
            section:addToggle({name = "Enabled", flag = "silent_aim"})
            section:addToggle({name = "Auto Shoot", flag = "auto_shoot"})
            section:addDropdown({name = "Prediction Type", flag = "silent_aim_velocity_type", items = {"Recalculation", "Velocity"}})
            local toggle = section:addToggle({name = "Auto Prediction", flag = "silent_use_auto_prediction", folding = true})
            toggle:addSlider({min = 0, max = 2000, default = 500, interval = 1, suffix = "°", flag = "silent_ping_factor"})
            section:addDropdown({name = "Aim Bone", flag = "silent_aim_bone", items = {"Feet", "Hrp", "Arms", "Legs", "Torso", "Head"}, default = {"Hrp"}, multi = true})
            section:addDropdown({name = "Air Bone", flag = "silent_aim_air_bone", items = {"Feet", "Hrp", "Arms", "Legs", "Torso", "Head"}, default = {"Feet"}, multi = true})
            section:addTextBox({name = "Manual Prediction", flag = "silent_manual_prediction"})
            local section = column:section({name = "Aim Assist"}) 
            section:addToggle({name = "Aim Assist", flag = "aim_assist"})
            section:addSlider({name = "Smoothing", min = 0, max = 100, default = 0, interval = 0.1, flag = "smoothing_factor"})
            section:addToggle({name = "Adjust For Jumping", flag = "adjust_for_jumping"})
            section:addDropdown({name = "Air Part", items = {"Feet", "Hrp", "Arms", "Legs", "Torso", "Head"}, flag = "aim_assist_air_bone", multi = true})
            section:addDropdown({name = "Hit Part", flag = "aim_assist_bone", items = {"Feet", "Hrp", "Arms", "Legs", "Torso", "Head"}, default = {"Torso"}, multi = true})
            section:addDropdown({name = "Prediction Type", flag = "aim_assist_velocity_type", items = {"Velocity", "Recalculation"}})
            local toggle = section:addToggle({name = "Auto Prediction", flag = "aim_assist_auto_prediction", folding = true})
            toggle:addSlider({name = "Ping Factor", min = 0, max = 1500, default = 1500, interval = 1, flag = "aim_assist_ping_factor"})
            section:addTextBox({name = "Manual Prediction", flag = "aim_assist_prediction"})

    -- 

    local Rage = window:tab({name = "Rage"})
    local Misc = window:tab({name = "Misc"})
    local Visuals = window:tab({name = "Visuals"})
    -- local Players = window:tab({name = "Players"})
    local Settings = window:tab({name = "Settings"})

    -- -- Configs 
        local column = Settings:column({fill = true})
        local general = column:section({name = "Configs"})

        config_holder = general:addList({name = "Configs", flag = "config_name_list", scale = 100})
        
        general:addTextBox({name = "Config Name", default = "", flag = "config_name_text_box"})

        general:addButton({name = "Create", callback = function()
            if flags["config_name_text_box"] == "" then 
                return 
            end 

            writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:getConfig())

            library:configListUpdate()
        end})

        general:addButton({name = "Delete", callback = function()
            delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
            library:configListUpdate()
        end})

        general:addButton({name = "Load", callback = function()
            print(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
            library:loadConfig(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
        end})
        general:addButton({name = "Save", callback = function()
            writefile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg", library:getConfig())
            library:configListUpdate()
        end})

        general:addButton({name = "Refresh configs", callback = function()
            library:configListUpdate()
        end}); library:configListUpdate()

        local column = Settings:column({fill = true})
        local other = column:section({name = "Other"})

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
    -- --
-- 

notifications:create_notification({name = "Hi! loaded btw"})
--]]
getgenv().Lists = getgenv().Lists or {
    TargetList = {},
    Whitelist = {}
}

local instantReloadConnections = {}
local characterAddedConnection
local cachedBestPositions = {history = {}, target = nil}
local lastShotTime = 0
local hitNotifications = {}
local notificationYOffset = 5
local MAX_VISIBLE_NOTIFICATIONS = 15

local function getCurrentTool()
    if LocalPlayer.Character then 
        for _,tool in pairs(LocalPlayer.Character:GetChildren()) do 
            if tool:IsA("Tool") then 
                return tool 
            end 
        end 
    end
    return nil
end

local function autoReload()
    if not getgenv().CONFIG.Ragebot.AutoReload then
        for _,conn in pairs(instantReloadConnections) do if conn then conn:Disconnect() end end
        instantReloadConnections = {}
        if characterAddedConnection then characterAddedConnection:Disconnect() characterAddedConnection = nil end
        return
    end
    local tool = getCurrentTool()
    if not tool then return end
    local values = tool:FindFirstChild("Values")
    if not values then return end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    for _,conn in pairs(instantReloadConnections) do if conn then conn:Disconnect() end end
    instantReloadConnections = {}
    if characterAddedConnection then characterAddedConnection:Disconnect() characterAddedConnection = nil end
    local gunR_remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
    local me = Players.LocalPlayer
    local function setupToolListeners(toolObj)
        if not toolObj or not toolObj:FindFirstChild("IsGun") then return end
        local values = toolObj:FindFirstChild("Values")
        if not values then return end
        local ammo = values:FindFirstChild("SERVER_Ammo")
        local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
        if not ammo or not storedAmmo then return end
        local conn1 = storedAmmo:GetPropertyChangedSignal("Value"):Connect(function()
            local currentRagebot = getgenv().CONFIG.Ragebot.AutoReload
            if currentRagebot then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        end)
        if storedAmmo.Value ~= 0 then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        local conn2 = ammo:GetPropertyChangedSignal("Value"):Connect(function()
            local currentRagebot = getgenv().CONFIG.Ragebot.AutoReload
            if currentRagebot and storedAmmo.Value ~= 0 then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        end)
        table.insert(instantReloadConnections, conn1)
        table.insert(instantReloadConnections, conn2)
    end
    local char = me.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then setupToolListeners(tool) end
        local conn3 = char.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then setupToolListeners(obj) end end)
        table.insert(instantReloadConnections, conn3)
    end
    characterAddedConnection = me.CharacterAdded:Connect(function(charr)
        repeat task.wait() until charr and charr.Parent
        local conn4 = charr.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then setupToolListeners(obj) end end)
        table.insert(instantReloadConnections, conn4)
    end)
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
                    if targetPlayer then return true end
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
                    if targetPlayer then return true end
                end
            end
            return false
        end
    end
    return true
end

local function showNotification(message)
    notifications:create_notification({name = message})
end

local function createHitNotification(toolName, offsetValue, playerName)
    if not getgenv().CONFIG.Ragebot.HitNotify then return end
    
    local targetPlayer = game:GetService("Players"):FindFirstChild(playerName)
    local health = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") and math.floor(targetPlayer.Character.Humanoid.Health) or 0

    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
    ScreenGui.Name = "HitNotifications"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local scrollFrame = ScreenGui:FindFirstChild("NotificationScroll") or Instance.new("ScrollingFrame")
    scrollFrame.Name = "NotificationScroll"
    scrollFrame.Parent = ScreenGui
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Size = UDim2.new(0, 600, 0, 400)
    scrollFrame.Position = UDim2.new(0, 30, 0, 10)
    scrollFrame.ScrollingEnabled = false
    scrollFrame.ScrollBarThickness = 0
    scrollFrame.ClipsDescendants = false

    local THEME_COLOR = Color3.fromRGB(30, 30, 30)
    local THEME_TRANSPARENCY = 0.5
    local GLOW_WIDTH = 20
    local HIT_COLOR = getgenv().CONFIG.Ragebot.HitColor

    local box = Instance.new("Frame")
    box.Parent = scrollFrame
    box.BackgroundColor3 = THEME_COLOR
    box.BackgroundTransparency = THEME_TRANSPARENCY
    box.BorderSizePixel = 0
    
    local function createGlow(side)
        local glow = Instance.new("Frame")
        glow.Size = UDim2.new(0, GLOW_WIDTH, 1, 0)
        glow.Position = (side == "Left") and UDim2.new(0, -GLOW_WIDTH, 0, 0) or UDim2.new(1, 0, 0, 0)
        glow.BackgroundColor3 = THEME_COLOR
        glow.BackgroundTransparency = THEME_TRANSPARENCY
        glow.BorderSizePixel = 0
        glow.Parent = box
        local grad = Instance.new("UIGradient")
        grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, (side == "Left" and 1 or 0)), NumberSequenceKeypoint.new(1, (side == "Left" and 0 or 1))})
        grad.Parent = glow
    end
    createGlow("Left")
    createGlow("Right")

    local parts = {
        {"hit ", Color3.fromRGB(255, 255, 255)},
        {playerName .. " ", HIT_COLOR},
        {"on head ", Color3.fromRGB(255, 255, 255)},
        {"Health at ", Color3.fromRGB(200, 200, 200)},
        {tostring(health) .. " ", Color3.fromRGB(0, 255, 120)},
        {"in ", Color3.fromRGB(200, 200, 200)},
        {string.format("%.2f", offsetValue) .. " ", HIT_COLOR},
        {"via cache", Color3.fromRGB(150, 150, 150)}
    }

    local offsetX = 8
    local totalW, maxH = 0, 0
    for _, seg in ipairs(parts) do
        local label = Instance.new("TextLabel")
        label.Parent = box
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextColor3 = seg[2]
        label.FontFace = AFont
        label.TextSize = 10
        label.Text = seg[1]
        label.AutomaticSize = Enum.AutomaticSize.XY
        
        label.Position = UDim2.new(0, offsetX, 0, 0)
        local xSize = label.TextBounds.X
        offsetX = offsetX + xSize
        totalW = offsetX
        maxH = math.max(maxH, label.TextBounds.Y)
    end

    box.Size = UDim2.new(0, totalW + 8, 0, maxH + 4)
    table.insert(hitNotifications, {box = box, createTime = tick()})

    local function updateScrollFrame()
        local currentY = 0
        for i, notif in ipairs(hitNotifications) do
            if notif.box and notif.box.Parent then
                notif.box.Position = UDim2.new(0, GLOW_WIDTH, 0, currentY)
                currentY = currentY + notif.box.AbsoluteSize.Y + 4
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
        ["Bameware"] = "rbxassetid://3124331820",
        ["Bell"] = "rbxassetid://6534947240",
        ["Bubble"] = "rbxassetid://6534947588",
        ["Pick"] = "rbxassetid://1347140027",
        ["Pop"] = "rbxassetid://198598793",
        ["Rust"] = "rbxassetid://1255040462",
        ["Sans"] = "rbxassetid://3188795283",
        ["Fart"] = "rbxassetid://130833677",
        ["Big"] = "rbxassetid://5332005053",
        ["Vine"] = "rbxassetid://5332680810",
        ["Bruh"] = "rbxassetid://4578740568",
        ["Skeet"] = "rbxassetid://5633695679",
        ["Neverlose"] = "rbxassetid://6534948092",
        ["Fatality"] = "rbxassetid://6534947869",
        ["Bonk"] = "rbxassetid://5766898159",
        ["Minecraft"] = "rbxassetid://4018616850"
    }
    local soundId = soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound] or soundIds["Skeet"]
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.75
    sound.Parent = Workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 0.75)
end

local function fuzzyFindPlayer(name)
    if not name or name == "" then return nil end
    
    local lowerName = name:lower()
    local possiblePlayers = {}
    
    for _,player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        local playerName = player.Name:lower()
        if playerName:find(lowerName) then
            table.insert(possiblePlayers, player)
        elseif player.DisplayName:lower():find(lowerName) then
            table.insert(possiblePlayers, player)
        end
    end
    
    if #possiblePlayers == 1 then
        return possiblePlayers[1]
    elseif #possiblePlayers > 1 then
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _,player in pairs(possiblePlayers) do
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                if head and localHead then
                    local distance = (head.Position - localHead.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    return nil
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local targetCount = 0
    
    if getgenv().CONFIG.Ragebot.FriendCheck then
        for _,player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and LocalPlayer:IsFriendsWith(player.UserId) then
                local found = false
                for _,wlName in ipairs(getgenv().Lists.Whitelist) do
                    if wlName == player.Name then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(getgenv().Lists.Whitelist, player.Name)
                end
            end
        end
    end
    
    for _,player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if getgenv().CONFIG.Ragebot.UseWhitelist then
            local isWhitelisted = false
            for _,wlName in ipairs(getgenv().Lists.Whitelist) do
                if wlName ~= "" and (wlName == player.Name or fuzzyFindPlayer(wlName) == player) then
                    isWhitelisted = true
                    break
                end
            end
            if isWhitelisted then continue end
        end
        
        if getgenv().CONFIG.Ragebot.UseTargetList then
            local isTarget = false
            for _,targetName in ipairs(getgenv().Lists.TargetList) do
                if targetName ~= "" and (targetName == player.Name or fuzzyFindPlayer(targetName) == player) then
                    isTarget = true
                    break
                end
            end
            if not isTarget then continue end
        end
        
        if getgenv().CONFIG.Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            if humanoid and humanoid.Health > 0 and head then
                local hasForcefield = false
                for _,child in pairs(character:GetChildren()) do if child:IsA("ForceField") then hasForcefield = true break end end
                if hasForcefield then continue end
                if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if getgenv().CONFIG.Ragebot.MaxTarget > 0 then targetCount = targetCount + 1 if targetCount > getgenv().CONFIG.Ragebot.MaxTarget then break end end
                if distance < shortestDistance then if canSeeTarget(head) then closest = head shortestDistance = distance end end
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
                if not humanoid then return false end
            else return false end
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
    
    for i = 1, 110 do
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
        
        if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange or hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
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
    local tweenInfo = TweenInfo.new(getgenv().CONFIG.Ragebot.TracerLifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(beam, tweenInfo, {Brightness = 0})
    tween:Play()
    tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
end

local function RandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset)) end
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
    if ammo.Value <= 0 then autoReload() return false end
    local bestShootPos, bestHitPos = wallbang()
    if not bestShootPos or not bestHitPos then return false end
    local hitPosition = bestHitPos
    if getgenv().CONFIG.Ragebot.Prediction then local velocity = targetHead.Velocity or Vector3.zero hitPosition = hitPosition + velocity * getgenv().CONFIG.Ragebot.PredictionAmount end
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

coroutine.wrap(function()
    while true do
        if not getgenv().CONFIG.Ragebot.Enabled then task.wait(0.001) else
            if not LocalPlayer.Character then task.wait(0.001) else
                if not LocalPlayer.Character:FindFirstChild("Head") then task.wait(0.001) else
                    local target = getClosestTarget()
                    local waitTimeValue = 0.01
                    if target then
                        local currentTime = tick()
                        local WaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
                        if getgenv().CONFIG.Ragebot.RapidFire then
                            local rapidWaitTime = 0
                            if currentTime - lastShotTime >= rapidWaitTime then shootAtTarget(target) lastShotTime = currentTime end
                            waitTimeValue = 0
                        else
                            if currentTime - lastShotTime >= WaitTime then shootAtTarget(target) lastShotTime = currentTime end
                            waitTimeValue = WaitTime / 2
                        end
                    end
                    task.wait(waitTimeValue)
                end
            end
        end
    end
end)()

local speedEnabled = false
local speedValue = 50
local speedConnection = nil
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local noclipEnabled = false
local noclipConnection = nil
local jumpPowerEnabled = false
local jumpPowerValue = 100
local jumpPowerConnection = nil
local loopFOVEnabled = false
local fovConnection = nil
local hideHeadEnabled = false
local char = nil
local torso = nil
local originalMotor6Ds = {}
local renderConnection = nil
local originalHook = nil
local infStaminaEnabled = false
local infStaminaHook = nil
local noFallEnabled = false
local noFallHook = nil
local lockpickEnabled = false
local lockpickAddedConnection = nil
local instantPromptEnabled = false
local instantPromptConnection = nil
local autoDoorEnabled = false
local doorConnection = nil
local safeESPEnabled = false
local safeColor = Color3.fromRGB(255,215,0)
local bulletTracersEnabled = false
local tracerColor = Color3.fromRGB(255,50,50)
local tracerWidth = 0.2
local tracerLifetime = 1
local SafeESP = {Enabled = false,Safes = {},Visuals = {}}
local richShaderEnabled = false
local richColor = Color3.fromRGB(255,200,150)
local richBrightness = 20
local richContrast = 50
local richSaturation = 150
local richPlayerEnabled = false
local richPlayerColor = Color3.fromRGB(255,255,255)
local richPlayerTransparency = 0
local originalPlayerProperties = {}
local originalPlayerMaterials = {}
local espEnabled = true
local espMainColor = Color3.fromRGB(255,50,50)
local espWhitelistColor = Color3.fromRGB(50,255,50)
local espTargetlistColor = Color3.fromRGB(255,50,255)
local espTeamCheck = false
local espShowHealth = true
local espShowDistance = true
local espBoxFilled = true
local espBoxOutline = true
local espBoxAlpha = 3
local espUseWhitelistColor = true
local espUseTargetlistColor = true
local espDrawings = {}
local espUIs = {}
local playerConnections = {}
local espScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
espScreenGui.Name = "Skeet_2D_ESP"
espScreenGui.IgnoreGuiInset = true

local function enableSpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    speedConnection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        humanoid.WalkSpeed = speedValue
    end)
end

local function disableSpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    local character = LocalPlayer.Character
    if character then local humanoid = character:FindFirstChild("Humanoid") if humanoid then humanoid.WalkSpeed = 16 end end
end

local function startFlying()
    local Char = LocalPlayer.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Hum or not Root then return end
    local RagdollEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL")
    RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),false)
    for _,child in ipairs(Char:GetDescendants()) do if child:IsA("Motor6D") then child.Enabled = false end end
    Hum.PlatformStand = true
    Hum:ChangeState(Enum.HumanoidStateType.Freefall)
    local flyMotors = {}
    for _,part in ipairs(Char:GetDescendants()) do
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
            if flyConnection then flyConnection:Disconnect() flyConnection = nil end
            Hum.PlatformStand = false
            Root.Velocity = Vector3.new(0,0,0)
            Hum:ChangeState(Enum.HumanoidStateType.Running)
            RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),true)
            for _,motor in ipairs(flyMotors) do motor:Destroy() end
            for _,child in ipairs(Char:GetDescendants()) do if child:IsA("Motor6D") and child.Name ~= "FlyMotor" then child.Enabled = true end end
            return
        end
        local Cam = Workspace.CurrentCamera
        if not Cam then return end
        local cameraLook = Cam.CFrame.LookVector
        local IsMoving = Hum.MoveDirection.Magnitude > 0
        local targetLook = Vector3.new(cameraLook.X,cameraLook.Y,cameraLook.Z)
        if targetLook.Magnitude > 0 then targetLook = targetLook.Unit Root.CFrame = CFrame.new(Root.Position,Root.Position + targetLook) end
        if IsMoving then
            local moveVector = Vector3.new(cameraLook.X,cameraLook.Y,cameraLook.Z).Unit
            Root.Velocity = moveVector * flySpeed
            RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),false)
        else Root.Velocity = Vector3.new(0,0,0) end
    end)
end

local function disableFlying()
    flyEnabled = false
end



local function enableJumpPower()
    if jumpPowerConnection then jumpPowerConnection:Disconnect() jumpPowerConnection = nil end
    jumpPowerConnection = RunService.Heartbeat:Connect(function()
        if not jumpPowerEnabled then return end
        if not LocalPlayer.Character then return end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPowerValue, hrp.Velocity.Z) end
    end)
end

local function disableJumpPower()
    if jumpPowerConnection then jumpPowerConnection:Disconnect() jumpPowerConnection = nil end
end

local function enableLoopFOV()
    if fovConnection then fovConnection:Disconnect() fovConnection = nil end
    fovConnection = RunService.RenderStepped:Connect(function() workspace.CurrentCamera.FieldOfView = 120 end)
end

local function disableLoopFOV()
    if fovConnection then fovConnection:Disconnect() fovConnection = nil end
end

local function hideHead()
    if not LocalPlayer.Character then return end
    char = LocalPlayer.Character
    torso = char:FindFirstChild("Torso")
    if not torso then return end
    originalMotor6Ds = {}
    for _,motor in pairs(char:GetDescendants()) do if motor:IsA("Motor6D") then originalMotor6Ds[motor] = {Part0 = motor.Part0, Part1 = motor.Part1, C0 = motor.C0, C1 = motor.C1} end end
    hideHeadEnabled = true
    if not originalHook then
        originalHook = hookmetamethod(game,"__namecall",function(self,...)
            local methodName = getnamecallmethod()
            if tostring(methodName) == "FireServer" then
                if self.Name == "MOVZREP" then local fixedArguments = {{{Vector3.new(-5721.2001953125,-5,971.5162353515625),Vector3.new(-4181.38818359375,-6,11.123311996459961),Vector3.new(0.006237113382667303,-6,-0.18136750161647797),true,true,true,false},false,false,15.8}} return originalHook(self,table.unpack(fixedArguments)) end
            end
            return originalHook(self,...)
        end)
    end
    if renderConnection then renderConnection:Disconnect() end
    renderConnection = RunService.RenderStepped:Connect(function()
        if torso and torso.Parent then
            for motor,originalData in pairs(originalMotor6Ds) do if motor and motor.Parent then motor.C0 = originalData.C0 motor.C1 = originalData.C1 end end
            local neck = torso:FindFirstChild("Neck")
            if neck and neck:IsA("Motor6D") then neck.C0 = CFrame.new(0,0,0.75)*CFrame.Angles(math.rad(90),0,0) neck.C1 = CFrame.new(0,0.25,0)*CFrame.Angles(0,0,0) end
        else if renderConnection then renderConnection:Disconnect() renderConnection = nil end end
    end)
end

local function enableInfStamina()
    if infStaminaHook then return end
    local module
    for i,v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do if v:IsA("ModuleScript") and v.Name == "XIIX" then module = v break end end
    if module then
        module = require(module)
        local ac = module["XIIX"]
        local glob = getfenv(ac)["_G"]
        local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
        if stamina ~= nil then infStaminaHook = hookfunction(stamina,function() return 100,100 end) end
    end
end

local function disableInfStamina()
    if infStaminaHook then hookfunction(stamina,infStaminaHook) infStaminaHook = nil end
end

local function enableNoFallDmg()
    if noFallHook then return end
    noFallHook = hookmetamethod(game,"__namecall",function(self,...)
        local args = {...}
        if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then args[2] = 0 args[3] = 0 end
        return noFallHook(self,unpack(args))
    end)
end

local function disableNoFallDmg()
    if noFallHook then hookmetamethod(game,"__namecall",noFallHook) noFallHook = nil end
end

local function enableLockpick()
    lockpickEnabled = true
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    local function lockpick(gui)
        for _,a in pairs(gui:GetDescendants()) do
            if a:IsA("ImageLabel") and a.Name == "Bar" and a.Parent.Name ~= "Attempts" then
                local oldsize = a.Size
                RunService.RenderStepped:Connect(function()
                    if lockpickEnabled then a.Size = UDim2.new(0,280,0,280) else a.Size = oldsize end
                end)
            end
        end
    end
    if lockpickAddedConnection then lockpickAddedConnection:Disconnect() end
    lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(child) if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then lockpick(child) end end)
    for _,child in pairs(PlayerGui:GetChildren()) do if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then lockpick(child) end end
end

local function disableLockpick()
    lockpickEnabled = false
    if lockpickAddedConnection then lockpickAddedConnection:Disconnect() lockpickAddedConnection = nil end
end

local function enableInstantPrompt()
    instantPromptEnabled = true
    for _,obj in pairs(game:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 0 end end
    if instantPromptConnection then instantPromptConnection:Disconnect() end
    instantPromptConnection = game.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") then task.wait() obj.HoldDuration = 0 end end)
end

local function disableInstantPrompt()
    instantPromptEnabled = false
    if instantPromptConnection then instantPromptConnection:Disconnect() instantPromptConnection = nil end
    for _,obj in pairs(game:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration = 1 end end
end

local function enableAutoDoor()
    autoDoorEnabled = true
    if doorConnection then doorConnection:Disconnect() end
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
        for _,door in pairs(Doors:GetChildren()) do
            local knob = door:FindFirstChild("Knob1") or door:FindFirstChild("Knob2")
            if knob then
                local distance = (knob.Position - charRoot.Position).Magnitude
                if distance < closestDistance then closestDistance = distance closestDoor = door end
            end
        end
        if closestDoor then
            local knob = closestDoor:FindFirstChild("Knob1") or closestDoor:FindFirstChild("Knob2")
            local events = closestDoor:FindFirstChild("Events")
            local toggleEvent = events and events:FindFirstChild("Toggle")
            if knob and toggleEvent then local args = {"Open",knob} toggleEvent:FireServer(unpack(args)) end
        end
    end)
end

local function disableAutoDoor()
    autoDoorEnabled = false
    if doorConnection then doorConnection:Disconnect() doorConnection = nil end
end

local function addSafeESP(model)
    if not model or not model.Parent then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = safeColor
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255,140,0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = model
    highlight.Parent = model
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SafeESP"
    billboard.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = safeColor
    textLabel.TextSize = 14
    textLabel.FontFace = Font.new("rbxassetid://12187371840")
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Text = model.Name
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1,0,0,20)
    distanceLabel.Position = UDim2.new(0,0,0,20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200,200,200)
    distanceLabel.TextSize = 12
    distanceLabel.FontFace = Font.new("rbxassetid://12187371840")
    distanceLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboard
    distanceLabel.Parent = billboard
    billboard.Parent = model
    SafeESP.Safes[model] = true
    SafeESP.Visuals[model] = {highlight = highlight,billboard = billboard,textLabel = textLabel,distanceLabel = distanceLabel}
    RunService.Heartbeat:Connect(function()
        if not safeESPEnabled or not model.Parent then highlight:Destroy() billboard:Destroy() SafeESP.Safes[model] = nil SafeESP.Visuals[model] = nil return end
        if LocalPlayer and LocalPlayer.Character then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and billboard.Adornee then local distance = (humanoidRootPart.Position - billboard.Adornee.Position).Magnitude distanceLabel.Text = string.format("%d studs",math.floor(distance)) billboard.Enabled = distance <= 100 end
        end
    end)
end

local function scanWorkspace()
    for _,item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            if itemName:find("mediumsafe") or itemName:find("smallsafe") then if not SafeESP.Safes[item] then addSafeESP(item) end end
        end
    end
end

local function updateSafeColor(color)
    safeColor = color
    for model,visuals in pairs(SafeESP.Visuals) do
        if visuals.highlight then visuals.highlight.FillColor = color end
        if visuals.textLabel then visuals.textLabel.TextColor3 = color end
    end
end

local function enableSafeESP(value)
    safeESPEnabled = value
    SafeESP.Enabled = value
    if value then
        scanWorkspace()
        Workspace.DescendantAdded:Connect(function(item)
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then task.wait(0.1) addSafeESP(item) end
            end
        end)
    else
        for model,visuals in pairs(SafeESP.Visuals) do if visuals.highlight then visuals.highlight:Destroy() end if visuals.billboard then visuals.billboard:Destroy() end end
        SafeESP.Safes = {}
        SafeESP.Visuals = {}
    end
end

local function createBulletTracer(startPos, endPos)
    if not bulletTracersEnabled then return end
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "Tracer"
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(tracerColor)
    beam.Width0 = tracerWidth
    beam.Width1 = tracerWidth
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = 1
    beam.Brightness = 2
    beam.LightEmission = 1
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
    local tweenInfo = TweenInfo.new(tracerLifetime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
    local tween = TweenService:Create(beam,tweenInfo,{Brightness = 0,Width0 = 0,Width1 = 0})
    tween:Play()
    tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
    task.delay(tracerLifetime + 0.1,function() if tracerModel and tracerModel.Parent then tracerModel:Destroy() end end)
end

local function trackGlobalBullets()
    if _G.TracersRunning then return end
    _G.TracersRunning = true
    local bfr = Camera:FindFirstChild("Bullets")
    if not bfr then bfr = Instance.new("Folder") bfr.Name = "Bullets" bfr.Parent = Camera end
    local function tblt(blt)
        if not blt:IsA("BasePart") then return end
        local stp = blt.Position
        local lsp = stp
        local stc = 0
        local con
        con = RunService.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if(lsp - stp).Magnitude > 1 then createBulletTracer(stp,lsp) end
                return
            end
            local cp = blt.Position
            if(cp - lsp).Magnitude < 0.1 then
                stc = stc + 1
                if stc > 3 then con:Disconnect() if(cp - stp).Magnitude > 1 then createBulletTracer(stp,cp) end end
            else stc = 0 lsp = cp end
        end)
    end
    bfr.ChildAdded:Connect(tblt)
    for _,v in ipairs(bfr:GetChildren()) do tblt(v) end
end

local function Register_Font()
    local HttpService = game:GetService("HttpService")
    
    if not isfile("ProggyTiny.ttf") then
        writefile("ProggyTiny.ttf", game:HttpGet("https://raw.githubusercontent.com/i77lhm/storage/refs/heads/main/fonts/ProggyClean.ttf"))
    end
    
    local fontData = {
        name = "ProggyTinyFont",
        faces = {{
            name = "Normal",
            weight = 400,
            style = "normal",
            assetId = getcustomasset("ProggyTiny.ttf")
        }}
    }
    
    writefile("ProggyTiny.font", HttpService:JSONEncode(fontData))
    return getcustomasset("ProggyTiny.font")
end

local mainFont = Font.new(Register_Font(), Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function getPlayerColor(player)
    if espUseTargetlistColor then
        for _,targetName in ipairs(getgenv().Lists.TargetList) do
            if targetName == player.Name then
                return espTargetlistColor
            end
        end
    end
    
    if espUseWhitelistColor then
        for _,wlName in ipairs(getgenv().Lists.Whitelist) do
            if wlName == player.Name then
                return espWhitelistColor
            end
        end
    end
    
    return espMainColor
end

local function createESP(player)
    if player == LocalPlayer then return end
    
    local drawings = {
        box_out = Drawing.new("Square"),
        box = Drawing.new("Square"),
        box_fill = Drawing.new("Square")
    }
    
    local uis = {
        health_bg = Instance.new("Frame", espScreenGui),
        health_fill = Instance.new("Frame"),
        name_text = Instance.new("TextLabel", espScreenGui),
        info_text = Instance.new("TextLabel", espScreenGui)
    }

    uis.health_fill.Parent = uis.health_bg
    uis.health_fill.BorderSizePixel = 0
    uis.health_bg.BorderSizePixel = 0
    uis.health_bg.BackgroundColor3 = Color3.new(0, 0, 0)
    
    local gradient = Instance.new("UIGradient", uis.health_fill)
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 1, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
    })

    drawings.box_fill.Transparency = 1
    drawings.box_fill.Filled = true
    drawings.box_fill.Thickness = 0

    local function setupText(textLabel)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.FontFace = mainFont
        textLabel.TextSize = 10
        textLabel.TextStrokeTransparency = 0
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
    end
    
    setupText(uis.name_text)
    setupText(uis.info_text)
    uis.info_text.TextXAlignment = Enum.TextXAlignment.Left
    uis.info_text.TextYAlignment = Enum.TextYAlignment.Top
    
    espDrawings[player] = drawings
    espUIs[player] = uis

    playerConnections[player] = RunService.RenderStepped:Connect(function()
        if not espEnabled then
            drawings.box_out.Visible = false
            drawings.box.Visible = false
            drawings.box_fill.Visible = false
            uis.health_bg.Visible = false
            uis.name_text.Visible = false
            uis.info_text.Visible = false
            return
        end
        
        if espTeamCheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
            drawings.box_out.Visible = false
            drawings.box.Visible = false
            drawings.box_fill.Visible = false
            uis.health_bg.Visible = false
            uis.name_text.Visible = false
            uis.info_text.Visible = false
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                local playerColor = getPlayerColor(player)
                
                local size_x = 2200 / vec.Z
                local size_y = 3200 / vec.Z
                local x = vec.X - size_x / 2
                local y = vec.Y - size_y / 2

                local boxAlpha = (espBoxAlpha or 3) / 10
                
                if espBoxOutline then
                    drawings.box_out.Visible = true
                    drawings.box_out.Position = Vector2.new(x, y)
                    drawings.box_out.Size = Vector2.new(size_x, size_y)
                    drawings.box_out.Color = Color3.new(0, 0, 0)
                    drawings.box_out.Transparency = 1 - boxAlpha
                else
                    drawings.box_out.Visible = false
                end
                
                if espBoxFilled then
                    drawings.box_fill.Visible = true
                    drawings.box_fill.Position = Vector2.new(x, y)
                    drawings.box_fill.Size = Vector2.new(size_x, size_y)
                    drawings.box_fill.Color = playerColor
                    drawings.box_fill.Transparency = 1 - boxAlpha
                else
                    drawings.box_fill.Visible = false
                end
                
                drawings.box.Visible = true
                drawings.box.Position = Vector2.new(x, y)
                drawings.box.Size = Vector2.new(size_x, size_y)
                drawings.box.Color = playerColor
                drawings.box.Transparency = 1 - boxAlpha

                if espShowHealth then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    uis.health_bg.Visible = true
                    uis.health_bg.Position = UDim2.new(0, x - 6, 0, y)
                    uis.health_bg.Size = UDim2.new(0, 4, 0, size_y)
                    uis.health_fill.Position = UDim2.new(0, 1, 1 - healthPercent, 0)
                    uis.health_fill.Size = UDim2.new(0, 2, healthPercent, 0)
                else
                    uis.health_bg.Visible = false
                end

                uis.name_text.Visible = true
                uis.name_text.TextSize = 10
                uis.name_text.Position = UDim2.new(0, x, 0, y - 15)
                uis.name_text.Size = UDim2.new(0, size_x, 0, 10)
                uis.name_text.Text = player.Name
                uis.name_text.TextColor3 = playerColor

                if espShowDistance then
                    uis.info_text.Visible = true
                    uis.info_text.TextSize = 10
                    uis.info_text.Position = UDim2.new(0, x + size_x + 4, 0, y)
                    uis.info_text.Size = UDim2.new(0, 100, 0, 100)
                    uis.info_text.Text = string.format("hp: %d\ndist: %dm", math.floor(humanoid.Health), math.floor(vec.Z))
                    uis.info_text.TextColor3 = playerColor
                else
                    uis.info_text.Visible = false
                end
            else
                drawings.box_out.Visible = false
                drawings.box.Visible = false
                drawings.box_fill.Visible = false
                uis.health_bg.Visible = false
                uis.name_text.Visible = false
                uis.info_text.Visible = false
            end
        else
            drawings.box_out.Visible = false
            drawings.box.Visible = false
            drawings.box_fill.Visible = false
            uis.health_bg.Visible = false
            uis.name_text.Visible = false
            uis.info_text.Visible = false
        end
    end)
end

local function removeESP(player)
    if espDrawings[player] then
        espDrawings[player].box_out:Remove()
        espDrawings[player].box:Remove()
        espDrawings[player].box_fill:Remove()
    end
    
    if espUIs[player] then
        espUIs[player].health_bg:Destroy()
        espUIs[player].name_text:Destroy()
        espUIs[player].info_text:Destroy()
    end
    
    if playerConnections[player] then
        playerConnections[player]:Disconnect()
    end
    
    espDrawings[player] = nil
    espUIs[player] = nil
    playerConnections[player] = nil
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(removeESP)

LocalPlayer.CharacterRemoving:Connect(function()
    for player in pairs(espDrawings) do
        removeESP(player)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if espEnabled then
        task.wait(1)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not espDrawings[player] then
                createESP(player)
            end
        end
    end
end)

local function applyRichPlayer()
    local char = LocalPlayer.Character
    if not char then return end
    if not next(originalPlayerProperties) then
        for _,partName in ipairs({"Torso","Right Leg","Right Arm","Left Leg","Left Arm","Head"}) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                originalPlayerProperties[partName] = {Color = part.Color,Transparency = part.Transparency}
                originalPlayerMaterials[partName] = part.Material
            end
        end
    end
    for _,partName in ipairs({"Torso","Right Leg","Right Arm","Left Leg","Left Arm","Head"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Color = richPlayerColor
            part.Transparency = richPlayerTransparency/100
            part.Material = Enum.Material.ForceField
        end
    end
end

local function resetRichPlayer()
    local char = LocalPlayer.Character
    if not char then return end
    for partName,properties in pairs(originalPlayerProperties) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Color = properties.Color part.Transparency = properties.Transparency end
    end
    for partName,material in pairs(originalPlayerMaterials) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Material = material end
    end
    originalPlayerProperties = {}
    originalPlayerMaterials = {}
end

LocalPlayer.CharacterAdded:Connect(function() 
    if richPlayerEnabled then 
        applyRichPlayer() 
    end 
end)


local Rage = window:tab({name = "Ragebot"})
local leftColumnRage = Rage:column({fill = true})
local rightColumnRage = Rage:column({fill = true})

local MainSection = leftColumnRage:section({name = "Main"})
local AimSection = leftColumnRage:section({name = "Aim Settings"})
local VisualSection = rightColumnRage:section({name = "Visuals"})
local TargetSection = rightColumnRage:section({name = "Targeting"})

local EnableToggle = MainSection:addToggle({name = "Enable Ragebot", flag = "rage_enable", callback = function(value)
    getgenv().CONFIG.Ragebot.Enabled = value
end})
EnableToggle:addKeyBind({name = "Keybind", flag = "rage_enable_bind"})

MainSection:addToggle({name = "Rapid Fire", flag = "rage_rapid_fire", callback = function(value)
    getgenv().CONFIG.Ragebot.RapidFire = value
end})

MainSection:addToggle({name = "Auto Reload", flag = "rage_auto_reload", callback = function(value)
    getgenv().CONFIG.Ragebot.AutoReload = value
    autoReload()
end})

MainSection:addSlider({name = "Fire Rate", flag = "rage_fire_rate", min = 1, max = 100, default = 30, callback = function(value)
    getgenv().CONFIG.Ragebot.FireRate = value
end})

TargetSection:addToggle({name = "Team Check", flag = "rage_team_check", callback = function(value)
    getgenv().CONFIG.Ragebot.TeamCheck = value
end})

TargetSection:addToggle({name = "Visibility Check", flag = "rage_visibility_check", callback = function(value)
    getgenv().CONFIG.Ragebot.VisibilityCheck = value
end})

TargetSection:addToggle({name = "Wallbang", flag = "rage_wallbang", callback = function(value)
    getgenv().CONFIG.Ragebot.Wallbang = value
end})

TargetSection:addToggle({name = "Friend Check", flag = "rage_friend_check", callback = function(value)
    getgenv().CONFIG.Ragebot.FriendCheck = value
end})

TargetSection:addToggle({name = "Low Health Check", flag = "rage_low_health_check", callback = function(value)
    getgenv().CONFIG.Ragebot.LowHealthCheck = value
end})

AimSection:addToggle({name = "Prediction", flag = "rage_prediction", callback = function(value)
    getgenv().CONFIG.Ragebot.Prediction = value
end})

AimSection:addSlider({name = "Prediction Amount", flag = "rage_prediction_amount", min = 0.05, max = 0.3, default = 0.12, callback = function(value)
    getgenv().CONFIG.Ragebot.PredictionAmount = value
end})

AimSection:addSlider({name = "Shoot Range", flag = "rage_shoot_range", min = 1, max = 30, default = 15, callback = function(value)
    getgenv().CONFIG.Ragebot.ShootRange = value
end})

AimSection:addSlider({name = "Hit Range", flag = "rage_hit_range", min = 1, max = 30, default = 15, callback = function(value)
    getgenv().CONFIG.Ragebot.HitRange = value
end})

AimSection:addSlider({name = "Max Targets", flag = "rage_max_targets", min = 0, max = 10, default = 0, callback = function(value)
    getgenv().CONFIG.Ragebot.MaxTarget = value
end})

local TracersToggle = VisualSection:addToggle({name = "Tracers", flag = "rage_tracers", callback = function(value)
    getgenv().CONFIG.Ragebot.Tracers = value
end})
TracersToggle:addColorPicker({name = "Tracer Color", flag = "rage_tracer_color", color = Color3.fromRGB(255,0,0), callback = function(color)
    getgenv().CONFIG.Ragebot.TracerColor = color
end})

VisualSection:addSlider({name = "Tracer Width", flag = "rage_tracer_width", min = 0.1, max = 5, default = 1, callback = function(value)
    getgenv().CONFIG.Ragebot.TracerWidth = value
end})

VisualSection:addSlider({name = "Tracer Lifetime", flag = "rage_tracer_lifetime", min = 0.5, max = 10, default = 3, callback = function(value)
    getgenv().CONFIG.Ragebot.TracerLifetime = value
end})

local HitNotifyToggle = VisualSection:addToggle({name = "Hit Notify", flag = "rage_hit_notify", callback = function(value)
    getgenv().CONFIG.Ragebot.HitNotify = value
end})
HitNotifyToggle:addColorPicker({name = "Hit Color", flag = "rage_hit_color", color = Color3.fromRGB(255,182,193), callback = function(color)
    getgenv().CONFIG.Ragebot.HitColor = color
end})

VisualSection:addToggle({name = "Hit Sound", flag = "rage_hit_sound", callback = function(value)
    getgenv().CONFIG.Ragebot.HitSound = value
end})

local hitSoundOptions = {
    "Skeet",
    "Neverlose",
    "Fatality",
    "Bameware",
    "Bell",
    "Bubble",
    "Pick",
    "Pop",
    "Rust",
    "Sans",
    "Fart",
    "Big",
    "Vine",
    "Bruh",
    "Bonk",
    "Minecraft"
}

VisualSection:addDropdown({name = "Hit Sound Select", flag = "rage_hit_sound_select", items = hitSoundOptions, default = "Skeet", callback = function(value)
    getgenv().CONFIG.Ragebot.SelectedHitSound = value
end})

VisualSection:addSlider({name = "Hit Notify Duration", flag = "rage_hit_notify_duration", min = 1, max = 10, default = 5, callback = function(value)
    getgenv().CONFIG.Ragebot.HitNotifyDuration = value
end})

TargetSection:addToggle({name = "Use Target List", flag = "rage_use_target_list", callback = function(value)
    getgenv().CONFIG.Ragebot.UseTargetList = value
end})

TargetSection:addToggle({name = "Use Whitelist", flag = "rage_use_whitelist", callback = function(value)
    getgenv().CONFIG.Ragebot.UseWhitelist = value
end})
--[[
local Misc = window:tab({name = "Misc"})
local leftColumnMisc = Misc:column({fill = true})
local rightColumnMisc = Misc:column({fill = true})

local MiscMainSection = leftColumnMisc:section({name = "Target Lists"})
local MiscToolsSection = rightColumnMisc:section({name = "List Tools"})

local targetListBox = MiscMainSection:addList({name = "Target List", flag = "target_list_box", scale = 250})
local whitelistBox = MiscMainSection:addList({name = "Whitelist", flag = "whitelist_box", scale = 250})

local function refreshTargetList()
    targetListBox.refresh_options(getgenv().Lists.TargetList)
end

local function refreshWhitelist()
    whitelistBox.refresh_options(getgenv().Lists.Whitelist)
end

MiscToolsSection:addButton({name = "Add Selected to Target List", callback = function()
    local selectedPlayer = whitelistBox.flags["whitelist_box"]
    if selectedPlayer and selectedPlayer ~= "" then
        whitelistBox.removeItem(selectedPlayer)
        
        for i, name in ipairs(getgenv().Lists.Whitelist) do
            if name == selectedPlayer then
                table.remove(getgenv().Lists.Whitelist, i)
                break
            end
        end
        
        local found = false
        for _, name in ipairs(getgenv().Lists.TargetList) do
            if name == selectedPlayer then
                found = true
                break
            end
        end
        
        if not found then
            table.insert(getgenv().Lists.TargetList, selectedPlayer)
            targetListBox.addItem(selectedPlayer)
        end
    end
end})

MiscToolsSection:addButton({name = "Add Selected to Whitelist", callback = function()
    local selectedPlayer = targetListBox.flags["target_list_box"]
    if selectedPlayer and selectedPlayer ~= "" then
        targetListBox.removeItem(selectedPlayer)
        
        for i, name in ipairs(getgenv().Lists.TargetList) do
            if name == selectedPlayer then
                table.remove(getgenv().Lists.TargetList, i)
                break
            end
        end
        
        local found = false
        for _, name in ipairs(getgenv().Lists.Whitelist) do
            if name == selectedPlayer then
                found = true
                break
            end
        end
        
        if not found then
            table.insert(getgenv().Lists.Whitelist, selectedPlayer)
            whitelistBox.addItem(selectedPlayer)
        end
    end
end})

MiscToolsSection:addButton({name = "Clear Target List", callback = function()
    getgenv().Lists.TargetList = {}
    targetListBox.refresh_options({})
end})

MiscToolsSection:addButton({name = "Clear Whitelist", callback = function()
    getgenv().Lists.Whitelist = {}
    whitelistBox.refresh_options({})
end})
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        targetListBox.addItem(player.Name)
        whitelistBox.addItem(player.Name)
    end
end
refreshTargetList()
refreshWhitelist()
--]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Misc = window:tab({name = "Misc"})
local left = Misc:column({fill = true})
local right = Misc:column({fill = true})

local playersSection = left:section({name = "Online Players"})
local toolSection = right:section({name = "management"})

local playerItems = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerItems, player.Name)
    end
end

local playersListBox = playersSection:addList({
    name = "Players", 
    flag = "players_list_box", 
    scale = 200,
    items = playerItems
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        playersListBox.addItem(player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player ~= LocalPlayer then
        playersListBox.removeItem(player.Name)
    end
end)

toolSection:addButton({name = "Add to Targetlist", callback = function()
    local selected = playersListBox.flags["players_list_box"]
    if selected and selected ~= "" then
        local inTarget = false
        for _, name in ipairs(getgenv().Lists.TargetList) do
            if name == selected then inTarget = true break end
        end
        
        if not inTarget then
            table.insert(getgenv().Lists.TargetList, selected)
        end
        
        for i, name in ipairs(getgenv().Lists.Whitelist) do
            if name == selected then
                table.remove(getgenv().Lists.Whitelist, i)
                break
            end
        end
    end
end})

toolSection:addButton({name = "Add to Whitelist", callback = function()
    local selected = playersListBox.flags["players_list_box"]
    if selected and selected ~= "" then
        local inWhitelist = false
        for _, name in ipairs(getgenv().Lists.Whitelist) do
            if name == selected then inWhitelist = true break end
        end
        
        if not inWhitelist then
            table.insert(getgenv().Lists.Whitelist, selected)
        end
        
        for i, name in ipairs(getgenv().Lists.TargetList) do
            if name == selected then
                table.remove(getgenv().Lists.TargetList, i)
                break
            end
        end
    end
end})

toolSection:addButton({name = "Clear Target", callback = function()
    getgenv().Lists.TargetList = {}
end})

toolSection:addButton({name = "Clear Whitelist", callback = function()
    getgenv().Lists.Whitelist = {}
end})
--local MiscMainSection = leftColumnMisc:section({name = "Target Lists"})
local MiscToolsSection = right:section({name = "Tools"})
local MiscMovementSection = left:section({name = "Movement"})
local MiscVisualsSection = right:section({name = "Visuals"})


local speedToggle = MiscMovementSection:addToggle({name = "Speed", flag = "misc_speed", callback = function(value)
    speedEnabled = value
    if value then enableSpeed() else disableSpeed() end
end})
speedToggle:addKeyBind({name = "Keybind", flag = "misc_speed_bind"})
MiscMovementSection:addSlider({name = "Value", flag = "misc_speed_value", min = 16, max = 200, default = 50, callback = function(value)
    speedValue = value
end})

local flyToggle = MiscMovementSection:addToggle({name = "Fly", flag = "misc_fly", callback = function(value)
    flyEnabled = value
    if value then startFlying() else disableFlying() end
end})
flyToggle:addKeyBind({name = "Keybind", flag = "misc_fly_bind"})
MiscMovementSection:addSlider({name = "Speed", flag = "misc_fly_speed", min = 10, max = 200, default = 50, callback = function(value)
    flySpeed = value
end})



local jumpToggle = MiscMovementSection:addToggle({name = "Jump Power", flag = "misc_jump_power", callback = function(value)
    jumpPowerEnabled = value
    if value then enableJumpPower() else disableJumpPower() end
end})
MiscMovementSection:addSlider({name = "Value", flag = "misc_jump_power_value", min = 50, max = 300, default = 100, callback = function(value)
    jumpPowerValue = value
end})

local fovToggle = MiscToolsSection:addToggle({name = "Loop FOV", flag = "misc_loop_fov", callback = function(value)
    loopFOVEnabled = value
    if value then enableLoopFOV() else disableLoopFOV() end
end})

local headToggle = MiscToolsSection:addToggle({name = "Hide Head", flag = "misc_hide_head", callback = function(value)
    hideHeadEnabled = value
    if value then hideHead() end
end})

local staminaToggle = MiscToolsSection:addToggle({name = "Inf Stamina", flag = "misc_inf_stamina", callback = function(value)
    infStaminaEnabled = value
    if value then enableInfStamina() else disableInfStamina() end
end})

local fallToggle = MiscToolsSection:addToggle({name = "No Fall Damage", flag = "misc_no_fall", callback = function(value)
    noFallEnabled = value
    if value then enableNoFallDmg() else disableNoFallDmg() end
end})

local lockpickToggle = MiscToolsSection:addToggle({name = "No Fail Lockpick", flag = "misc_lockpick", callback = function(value)
    lockpickEnabled = value
    if value then enableLockpick() else disableLockpick() end
end})

local promptToggle = MiscToolsSection:addToggle({name = "Instant Prompt", flag = "misc_instant_prompt", callback = function(value)
    instantPromptEnabled = value
    if value then enableInstantPrompt() else disableInstantPrompt() end
end})

local doorToggle = MiscToolsSection:addToggle({name = "Auto Door", flag = "misc_auto_door", callback = function(value)
    autoDoorEnabled = value
    if value then enableAutoDoor() else disableAutoDoor() end
end})

local safeESPToggle = MiscVisualsSection:addToggle({name = "Safe ESP", flag = "misc_safe_esp", callback = function(value)
    enableSafeESP(value)
end})
safeESPToggle:addKeyBind({name = "Keybind", flag = "misc_safe_esp_bind"})
safeESPToggle:addColorPicker({name = "Color", flag = "misc_safe_esp_color", color = Color3.fromRGB(255,215,0), callback = function(color)
    updateSafeColor(color)
end})

local tracerToggle = MiscVisualsSection:addToggle({name = "Bullet Tracers", flag = "misc_bullet_tracers", callback = function(value)
    bulletTracersEnabled = value
    if value then trackGlobalBullets() end
end})
tracerToggle:addColorPicker({name = "Color", flag = "misc_tracer_color", color = Color3.fromRGB(255,50,50), callback = function(color)
    tracerColor = color
end})
MiscVisualsSection:addSlider({name = "Width", flag = "misc_tracer_width", min = 1, max = 5, default = 2, callback = function(value)
    tracerWidth = value / 1
end})
MiscVisualsSection:addSlider({name = "Lifetime", flag = "misc_tracer_lifetime", min = 1, max = 100, default = 10, callback = function(value)
    tracerLifetime = value / 5
end})


local Visuals = window:tab({name = "Visuals"})
local leftColumnVisuals = Visuals:column({fill = true})
local rightColumnVisuals = Visuals:column({fill = true})

local VisualShaderSection = leftColumnVisuals:section({name = "Shader"})
local VisualPlayerSection = leftColumnVisuals:section({name = "Player"})
local VisualESPSection = rightColumnVisuals:section({name = "ESP"})

local shaderToggle = VisualShaderSection:addToggle({name = "Rich Shader", flag = "visual_rich_shader", callback = function(value)
    richShaderEnabled = value
    if value then
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
shaderToggle:addColorPicker({name = "Ambient Color", flag = "visual_shader_color", color = Color3.fromRGB(255,200,150), callback = function(color)
    richColor = color
    if richShaderEnabled then 
        local lighting = game:GetService("Lighting") 
        local effect = lighting:FindFirstChild("RichShaderEffect") 
        if effect then effect.TintColor = color end
    end
end})
shaderToggle:addSlider({name = "Brightness", flag = "visual_shader_brightness", min = 0, max = 100, default = 20, callback = function(value)
    richBrightness = value
    if richShaderEnabled then 
        local lighting = game:GetService("Lighting") 
        local effect = lighting:FindFirstChild("RichShaderEffect") 
        if effect then effect.Brightness = value / 100 end
    end
end})
shaderToggle:addSlider({name = "Contrast", flag = "visual_shader_contrast", min = 0, max = 100, default = 50, callback = function(value)
    richContrast = value
    if richShaderEnabled then 
        local lighting = game:GetService("Lighting") 
        local effect = lighting:FindFirstChild("RichShaderEffect") 
        if effect then effect.Contrast = value / 100 end
    end
end})
shaderToggle:addSlider({name = "Saturation", flag = "visual_shader_saturation", min = 0, max = 200, default = 150, callback = function(value)
    richSaturation = value
    if richShaderEnabled then 
        local lighting = game:GetService("Lighting") 
        local effect = lighting:FindFirstChild("RichShaderEffect") 
        if effect then effect.Saturation = value / 100 end
    end
end})

local playerToggle = VisualPlayerSection:addToggle({name = "Rich Player", flag = "visual_rich_player", callback = function(value)
    richPlayerEnabled = value
    if value then 
        if LocalPlayer.Character then applyRichPlayer() end 
    else 
        if LocalPlayer.Character then resetRichPlayer() end 
    end
end})
playerToggle:addColorPicker({name = "Player Color", flag = "visual_player_color", color = Color3.fromRGB(255,255,255), callback = function(color)
    richPlayerColor = color
    if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end
end})
VisualPlayerSection:addSlider({name = "Transparency", flag = "visual_player_transparency", min = 0, max = 100, default = 0, callback = function(value)
    richPlayerTransparency = value
    if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end
end})

local espToggle = VisualESPSection:addToggle({name = "ESP Enabled", flag = "visual_esp_enabled", callback = function(value)
    espEnabled = value
end})
espToggle:addKeyBind({name = "Keybind", flag = "visual_esp_bind"})
espToggle:addColorPicker({name = "ESP Color", flag = "visual_esp_color", color = Color3.fromRGB(255,50,50), callback = function(color)
    espMainColor = color
end})

local teamToggle = VisualESPSection:addToggle({name = "Team Check", flag = "visual_esp_team_check", callback = function(value)
    espTeamCheck = value
end})

local whitelistToggle = VisualESPSection:addToggle({name = "Use Whitelist Color", flag = "visual_esp_whitelist_color", callback = function(value)
    espUseWhitelistColor = value
end})
whitelistToggle:addColorPicker({name = "Whitelist Color", flag = "visual_esp_whitelist_color_picker", color = Color3.fromRGB(50,255,50), callback = function(color)
    espWhitelistColor = color
end})

local targetlistToggle = VisualESPSection:addToggle({name = "Use Targetlist Color", flag = "visual_esp_targetlist_color", callback = function(value)
    espUseTargetlistColor = value
end})
targetlistToggle:addColorPicker({name = "Targetlist Color", flag = "visual_esp_targetlist_color_picker", color = Color3.fromRGB(255,50,255), callback = function(color)
    espTargetlistColor = color
end})

local healthToggle = VisualESPSection:addToggle({name = "Show Health", flag = "visual_esp_show_health", callback = function(value)
    espShowHealth = value
end})

local distanceToggle = VisualESPSection:addToggle({name = "Show Distance", flag = "visual_esp_show_distance", callback = function(value)
    espShowDistance = value
end})

local filledToggle = VisualESPSection:addToggle({name = "Box Filled", flag = "visual_esp_box_filled", callback = function(value)
    espBoxFilled = value
end})

local outlineToggle = VisualESPSection:addToggle({name = "Box Outline", flag = "visual_esp_box_outline", callback = function(value)
    espBoxOutline = value
end})

local alphaSlider = VisualESPSection:addSlider({name = "Box Alpha", flag = "visual_esp_box_alpha", min = 0, max = 10, default = 3, callback = function(value)
    espBoxAlpha = value
end})
--[[
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local LegitAim = {
    enabled = false,
    silent_aim = false,
    aim_assist = false,
    fov = 100,
    smoothness = 0.1,
    silent_target = nil,
    aiming = false,
    aim_method = "mouse",
    silent_aim_is_targetting = false,
    ignore_behind_walls = true,
    ignore_forcefield = true,
    ignore_friendlies = true,
    connections = {}
}

function LegitAim:init()
    self.enabled = true
    
    self.connections.render = RunService.RenderStepped:Connect(function()
        if not self.enabled then return end
        if self.silent_aim then self:update_silent_target() end
        if self.aim_assist and self.aiming then self:update_aim_assist() end
    end)
    
    self:hook_silent_aim()
end

function LegitAim:get_direction(origin, destination)
    return ((destination - origin).Unit * 1000)
end

function LegitAim:world_to_screen(position)
    local viewport_position, on_screen = Camera:WorldToViewportPoint(position)
    return {position = Vector2.new(viewport_position.X, viewport_position.Y), on_screen = on_screen}
end

function LegitAim:has_character(player)
    return player and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and true or false
end

function LegitAim:has_forcefield(player)
    if not player or not player.Character then return false end
    for _, obj in pairs(player.Character:GetChildren()) do
        if obj:IsA("ForceField") then
            return true
        end
    end
    return false
end

function LegitAim:is_behind_wall(player)
    if not self.ignore_behind_walls then return false end
    if not player or not player.Character then return true end
    
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    local targetHead = player.Character:FindFirstChild("Head")
    if not localHead or not targetHead then return true end
    
    local startPos = localHead.Position
    local endPos = targetHead.Position
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local ray = Ray.new(startPos, direction.Unit * distance)
    local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    
    if part then
        local model = part:FindFirstAncestorWhichIsA("Model")
        if model then
            local humanoid = model:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                local targetPlayer = Players:GetPlayerFromCharacter(model)
                if targetPlayer and targetPlayer == player then
                    return false
                end
            end
        end
        return true
    end
    return false
end

function LegitAim:is_friend(player)
    if not self.ignore_friendlies then return false end
    return LocalPlayer:IsFriendsWith(player.UserId)
end

function LegitAim:get_closest_player_by_mouse()
    local mouse_position = UserInputService:GetMouseLocation()
    local radius = math.huge
    local closest_player
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not self:has_character(player) then continue end
        
        if self.ignore_friendlies and self:is_friend(player) then continue end
        if self.ignore_forcefield and self:has_forcefield(player) then continue end
        if self:is_behind_wall(player) then continue end
        
        local screen_position = self:world_to_screen(player.Character.HumanoidRootPart.Position)
        if not screen_position.on_screen then continue end
        
        local distance = (mouse_position - screen_position.position).Magnitude
        if distance < self.fov and distance < radius then 
            radius = distance
            closest_player = player
        end
    end
    
    return closest_player
end

function LegitAim:get_closest_player_by_position()
    local camera_pos = Camera.CFrame.Position
    local radius = math.huge
    local closest_player
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not self:has_character(player) then continue end
        
        if self.ignore_friendlies and self:is_friend(player) then continue end
        if self.ignore_forcefield and self:has_forcefield(player) then continue end
        if self:is_behind_wall(player) then continue end
        
        local char_pos = player.Character.HumanoidRootPart.Position
        local distance = (char_pos - camera_pos).Magnitude
        
        if distance < radius then 
            radius = distance
            closest_player = player
        end
    end
    
    return closest_player
end

function LegitAim:update_silent_target()
    local new_target
    if self.aim_method == "mouse" then
        new_target = self:get_closest_player_by_mouse()
    else
        new_target = self:get_closest_player_by_position()
    end
    
    self.silent_aim_is_targetting = new_target and true or false
    self.silent_target = new_target or nil
end

function LegitAim:update_aim_assist()
    if not self.aiming then return end
    
    local target
    if self.aim_method == "mouse" then
        target = self:get_closest_player_by_mouse()
    else
        target = self:get_closest_player_by_position()
    end
    
    if not target or not target.Character then return end
    
    local current_cf = Camera.CFrame
    local target_pos = target.Character.HumanoidRootPart.Position
    local cam_pos = current_cf.Position
    
    if self.smoothness > 0 then
        local target_dir = (target_pos - cam_pos).Unit
        local current_dir = current_cf.LookVector
        local new_dir = current_dir:Lerp(target_dir, self.smoothness)
        Camera.CFrame = CFrame.new(cam_pos, cam_pos + new_dir)
    else
        Camera.CFrame = CFrame.new(cam_pos, target_pos)
    end
end

function LegitAim:hook_silent_aim()
    local __namecall
    __namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args, method = {...}, getnamecallmethod()
        
        if not checkcaller() and tostring(method) == "Raycast" and self == Workspace then
            if LegitAim.silent_aim and LegitAim.silent_aim_is_targetting and LegitAim.silent_target and LegitAim.silent_target.Character then
                local origin = args[1]
                args[2] = LegitAim:get_direction(origin, LegitAim.silent_target.Character.HumanoidRootPart.Position)
                return __namecall(self, unpack(args))
            end
        end
        
        return __namecall(self, ...)
    end)
end

function LegitAim:set_fov(value) self.fov = value end
function LegitAim:set_smoothness(value) self.smoothness = value end
function LegitAim:set_aim_method(value) self.aim_method = value end
function LegitAim:set_enabled(value) self.enabled = value end
function LegitAim:set_silent_aim(value) self.silent_aim = value end
function LegitAim:set_aim_assist(value) self.aim_assist = value end
function LegitAim:toggle_aiming(value) self.aiming = value end
function LegitAim:set_ignore_behind_walls(value) self.ignore_behind_walls = value end
function LegitAim:set_ignore_forcefield(value) self.ignore_forcefield = value end
function LegitAim:set_ignore_friendlies(value) self.ignore_friendlies = value end
local Legit = window:tab({name = "Legit"})
local leftColumnLegit = Legit:column({fill = true})
local rightColumnLegit = Legit:column({fill = true})

local MainSection = leftColumnLegit:section({name = "Main"})
local SettingsSection = rightColumnLegit:section({name = "Settings"})
--local VisualSection = rightColumnLegit:section({name = "Visuals"})
--local TargetSection = rightColumnLegit:section({name = "Target"})

local EnableToggle = MainSection:addToggle({name = "Enabled", flag = "legit_enabled", callback = function(value)
    LegitAim:set_enabled(value)
    if value then
        LegitAim:init()
    else
        for _, conn in pairs(LegitAim.connections) do
            if conn then conn:Disconnect() end
        end
        LegitAim.connections = {}
    end
end})

MainSection:addToggle({name = "Silent Aim", flag = "legit_silent_aim", callback = function(value)
    LegitAim:set_silent_aim(value)
end})

local a = MainSection:addToggle({name = "Aim Assist", flag = "legit_aim_assist", callback = function(value)
    LegitAim:set_aim_assist(value)
end}):addKeyBind({name = "Aim Key", flag = "legit_aim_key", callback = function(value)
    LegitAim:toggle_aiming(value)
end})

SettingsSection:addDropdown({name = "Aim Method", flag = "legit_aim_method", items = {"Mouse", "Distance"}, default = "Mouse", callback = function(value)
    LegitAim:set_aim_method(value:lower())
end})

SettingsSection:addSlider({name = "FOV", flag = "legit_fov", min = 0, max = 500, default = 100, callback = function(value)
    LegitAim:set_fov(value)
end})

SettingsSection:addSlider({name = "Smoothness", flag = "legit_smoothness", min = 0, max = 1, default = 0.1, callback = function(value)
    LegitAim:set_smoothness(value)
end})

TargetSection:addToggle({name = "Ignore Walls", flag = "legit_ignore_walls", callback = function(value)
    LegitAim:set_ignore_behind_walls(value)
end})

TargetSection:addToggle({name = "Ignore ForceField", flag = "legit_ignore_forcefield", callback = function(value)
    LegitAim:set_ignore_forcefield(value)
end})

TargetSection:addToggle({name = "Ignore Friendlies", flag = "legit_ignore_friendlies", callback = function(value)
    LegitAim:set_ignore_friendlies(value)
end})

--local FOVCircleToggle = VisualSection:addToggle({name = "FOV Circle", flag = "legit_fov_circle", folding = true})

--FOVCircleToggle:addColorPicker({name = "FOV Color", flag = "legit_fov_color", color = Color3.fromRGB(255, 255, 255)})

--FOVCircleToggle:addSlider({name = "FOV Thickness", flag = "legit_fov_thickness", min = 1, max = 5, default = 1})

--local TargetIndicatorToggle = VisualSection:addToggle({name = "Target Indicator", flag = "legit_target_indicator", folding = true})

--TargetIndicatorToggle:addColorPicker({name = "Indicator Color", flag = "legit_indicator_color", color = Color3.fromRGB(255, 0, 0)})

--TargetIndicatorToggle:addDropdown({name = "Indicator Type", flag = "legit_indicator_type", items = {"Dot", "Box", "Arrow"}, default = "Dot"})

--local TracerToggle = VisualSection:addToggle({name = "Show Tracer", flag = "legit_show_tracer", folding = true})

--TracerToggle:addColorPicker({name = "Tracer Color", flag = "legit_tracer_color", color = Color3.fromRGB(255, 0, 0)})

--TracerToggle:addSlider({name = "Tracer Thickness", flag = "legit_tracer_thickness", min = 1, max = 5, default = 1})

local Legit = window:tab({name = "Legit"})
local leftColumnLegit = Legit:column({fill = true})
local rightColumnLegit = Legit:column({fill = true})

local LegitMainSection = leftColumnLegit:section({name = "Main"})
local LegitSettingsSection = leftColumnLegit:section({name = "Settings"})

local legitEnabled = false
local legitSilentAim = false
local legitAimAssist = false
local legitFov = 100
local legitSmoothness = 0.1
local legitAimMethod = "mouse"
local legitIgnoreWalls = true
local legitIgnoreForcefield = true
local legitIgnoreFriendlies = true
local legitAiming = false
local legitSilentTarget = nil
local legitSilentTargeting = false

local legitRenderConnection = nil
local legitSilentHook = nil

local function calculateDirection(origin, destination)
    return ((destination - origin).Unit * 1000)
end

local function getClosestPlayerByMouse()
    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        
        if legitIgnoreFriendlies and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        
        local hasForcefield = false
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("ForceField") then
                hasForcefield = true
                break
            end
        end
        if legitIgnoreForcefield and hasForcefield then continue end
        
        if legitIgnoreWalls then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            local targetHead = player.Character:FindFirstChild("Head")
            if localHead and targetHead then
                local startPos = localHead.Position
                local endPos = targetHead.Position
                local direction = (endPos - startPos)
                local distance = direction.Magnitude
                
                local ray = Ray.new(startPos, direction.Unit * distance)
                local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                
                if part then
                    local model = part:FindFirstAncestorWhichIsA("Model")
                    if model then
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            local targetPlayer = Players:GetPlayerFromCharacter(model)
                            if targetPlayer and targetPlayer == player then
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                end
            end
        end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
        if not onScreen then continue end
        
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if distance < legitFov and distance < closestDist then
            closestDist = distance
            closestPlayer = player
        end
    end
    
    return closestPlayer
end

local function getClosestPlayerByDistance()
    local cameraPos = Camera.CFrame.Position
    local closestPlayer = nil
    local closestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        if player.Character.Humanoid.Health <= 0 then continue end
        
        if legitIgnoreFriendlies and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        
        local hasForcefield = false
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("ForceField") then
                hasForcefield = true
                break
            end
        end
        if legitIgnoreForcefield and hasForcefield then continue end
        
        if legitIgnoreWalls then
            local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            local targetHead = player.Character:FindFirstChild("Head")
            if localHead and targetHead then
                local startPos = localHead.Position
                local endPos = targetHead.Position
                local direction = (endPos - startPos)
                local distance = direction.Magnitude
                
                local ray = Ray.new(startPos, direction.Unit * distance)
                local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                
                if part then
                    local model = part:FindFirstAncestorWhichIsA("Model")
                    if model then
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            local targetPlayer = Players:GetPlayerFromCharacter(model)
                            if targetPlayer and targetPlayer == player then
                            else
                                continue
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                end
            end
        end
        
        local charPos = player.Character.HumanoidRootPart.Position
        local distance = (charPos - cameraPos).Magnitude
        
        if distance < closestDist then
            closestDist = distance
            closestPlayer = player
        end
    end
    
    return closestPlayer
end

LegitMainSection:addToggle({name = "Enabled", flag = "legit_enabled", callback = function(value)
    legitEnabled = value
    if value then
        if legitRenderConnection then
            legitRenderConnection:Disconnect()
        end
        
        legitRenderConnection = RunService.RenderStepped:Connect(function()
            if not legitEnabled then return end
            
            if legitSilentAim then
                local closestPlayer
                if legitAimMethod == "mouse" then
                    closestPlayer = getClosestPlayerByMouse()
                else
                    closestPlayer = getClosestPlayerByDistance()
                end
                
                if closestPlayer then
                    legitSilentTarget = closestPlayer
                    legitSilentTargeting = true
                else
                    legitSilentTarget = nil
                    legitSilentTargeting = false
                end
            end
            
            if legitAimAssist and legitAiming then
                local target
                if legitAimMethod == "mouse" then
                    target = getClosestPlayerByMouse()
                else
                    target = getClosestPlayerByDistance()
                end
                
                if target and target.Character then
                    local currentCF = Camera.CFrame
                    local targetPos = target.Character.Head.Position
                    local camPos = currentCF.Position
                    
                    if legitSmoothness > 0 then
                        local targetDir = (targetPos - camPos).Unit
                        local currentDir = currentCF.LookVector
                        local newDir = currentDir:Lerp(targetDir, legitSmoothness)
                        Camera.CFrame = CFrame.new(camPos, camPos + newDir)
                    else
                        Camera.CFrame = CFrame.new(camPos, targetPos)
                    end
                end
            end
        end)
        
        if not legitSilentHook then
            local __namecall
            __namecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args, method = {...}, getnamecallmethod()
                
                if not checkcaller() and tostring(method) == "Raycast" and self == Workspace then
                    if legitSilentAim and legitSilentTargeting and legitSilentTarget and legitSilentTarget.Character then
                        local origin = args[1]
                        args[2] = calculateDirection(origin, legitSilentTarget.Character.Head.Position)
                        return __namecall(self, unpack(args))
                    end
                end
                
                return __namecall(self, ...)
            end)
            legitSilentHook = true
        end
    else
        if legitRenderConnection then
            legitRenderConnection:Disconnect()
            legitRenderConnection = nil
        end
    end
end})

LegitMainSection:addToggle({name = "Silent Aim", flag = "legit_silent_aim", callback = function(value)
    legitSilentAim = value
end})

LegitMainSection:addToggle({name = "Aim Assist", flag = "legit_aim_assist", callback = function(value)
    legitAimAssist = value
end})

LegitMainSection:addKeyBind({name = "Aim Key", flag = "legit_aim_key", callback = function(value)
    legitAiming = value
end})

LegitSettingsSection:addDropdown({name = "Aim Method", flag = "legit_aim_method", items = {"mouse", "distance"}, default = "mouse", callback = function(value)
    legitAimMethod = value
end})

LegitSettingsSection:addSlider({name = "FOV", flag = "legit_fov", min = 0, max = 500, default = 100, callback = function(value)
    legitFov = value
end})

LegitSettingsSection:addSlider({name = "Smoothness", flag = "legit_smoothness", min = 0, max = 1, default = 0.1, callback = function(value)
    legitSmoothness = value
end})

LegitSettingsSection:addToggle({name = "Ignore Walls", flag = "legit_ignore_walls", callback = function(value)
    legitIgnoreWalls = value
end})

LegitSettingsSection:addToggle({name = "Ignore ForceField", flag = "legit_ignore_forcefield", callback = function(value)
    legitIgnoreForcefield = value
end})

LegitSettingsSection:addToggle({name = "Ignore Friendlies", flag = "legit_ignore_friendlies", callback = function(value)
    legitIgnoreFriendlies = value
end})
--]]
local Settings = window:tab({name = "Settings"})

    -- -- Configs 
        local column = Settings:column({fill = true})
        local general = column:section({name = "Configs"})

        config_holder = general:addList({name = "Configs", flag = "config_name_list", scale = 100})
        
        general:addTextBox({name = "Config Name", default = "", flag = "config_name_text_box"})

        general:addButton({name = "Create", callback = function()
            if flags["config_name_text_box"] == "" then 
                return 
            end 

            writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:getConfig())

            library:configListUpdate()
        end})

        general:addButton({name = "Delete", callback = function()
            delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
            library:configListUpdate()
        end})

        general:addButton({name = "Load", callback = function()
            print(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
            library:loadConfig(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
        end})
        general:addButton({name = "Save", callback = function()
            writefile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg", library:getConfig())
            library:configListUpdate()
        end})

        general:addButton({name = "Refresh configs", callback = function()
            library:configListUpdate()
        end}); library:configListUpdate()

        local column = Settings:column({fill = true})
        local other = column:section({name = "Other"})

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
targetListBox.refresh_options(getgenv().Lists.TargetList)
whitelistBox.refresh_options(getgenv().Lists.Whitelist)
