repeat task.wait() until game:IsLoaded()

local function isAdonisAC(tab) 
    return rawget(tab,"Detected") and typeof(rawget(tab,"Detected"))=="function" and rawget(tab,"RLocked") 
end
for _,v in next,getgc(true) do 
    if typeof(v)=="table" and isAdonisAC(v) then 
        for i,f in next,v do 
            if rawequal(i,"Detected") then 
                local old 
                old=hookfunction(f,function(action,info,crash)
                    if rawequal(action,"_") and rawequal(info,"_") and rawequal(crash,false) then 
                        return old(action,info,crash) 
                    end 
                    return task.wait(9e9) 
                end) 
                warn("bypassed") 
                break 
            end 
        end 
    end 
end

for _,v in pairs(getgc(true)) do 
    if type(v)=="table" then 
        local func=rawget(v,"DTXC1") 
        if type(func)=="function" then 
            hookfunction(func,function() return end) 
            break 
        end 
    end 
end

getgenv().CONFIG={
    Ragebot={
        Enabled=false,RapidFire=false,FireRate=30,Prediction=true,
        PredictionAmount=0.12,TeamCheck=false,VisibilityCheck=true,
        FOV=9e9,ShowFOV=false,Wallbang=true,Tracers=true,
        TracerColor=Color3.fromRGB(255,0,0),TracerWidth=1,
        TracerLifetime=3,ShootRange=15,HitRange=15,
        HitNotify=true,AutoReload=true,HitSound=true,
        HitColor=Color3.fromRGB(255,182,193),UseTargetList=false,
        UseWhitelist=false,HitNotifyDuration=5,LowHealthCheck=false,
        SelectedHitSound="skeet",FriendCheck=false,MaxTarget=0
    },
    Misc={
        SpeedEnabled=false,SpeedValue=50,JumpPowerEnabled=false,
        JumpPowerValue=100,LoopFOVEnabled=false,HideHeadEnabled=false,
        InfStaminaEnabled=false,NoFallDmgEnabled=false,
        SpeedConnection=nil,FOVConnection=nil,JumpPowerConnection=nil,
        NoFallHook=nil,InfStaminaHook=nil
    }
}

getgenv().Lists={
    TargetList={},
    Whitelist={}
}

getgenv().Legit={
    Enabled=false,HeadChance=30,HitPart="Torso",
    NoRecoil=true,AimAssist=false,AimAssistStrength=0.3,Smoothing=0.2
}

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local TweenService=game:GetService("TweenService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local HttpService=game:GetService("HttpService")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera

local Library, Notifications, Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/bbotv3mobile/refs/heads/main/library.lua"))()

local Window = Library:Window({name = "skcc"})

local Tabs = {
    Combat = Window:Tab({Name = "Combat"}),
    Visuals = Window:Tab({Name = "Visuals"}),
    Players = Window:Tab({Name = "Players"})
}

local PlayerList = Tabs.Players:PlayerList({})

local instantReloadConnections={}
local characterAddedConnection
local hitNotifications={}
local cachedBestPositions={history={},target=nil}
local lastShotTime=0
local silent_aim_active=false
local aim_target=nil
local aim_position=Vector3.new()
local fovCircle=Drawing.new("Circle")
local bulletTracersEnabled=false
local tracerColor=Color3.fromRGB(255,50,50)
local tracerWidth=0.2
local tracerLifetime=1
local noclipEnabled=false
local noclipConnection
local richShaderEnabled=false
local richColor=Color3.fromRGB(255,200,150)
local richBrightness=20
local richContrast=50
local richSaturation=150
local richPlayerEnabled=false
local richPlayerColor=Color3.fromRGB(255,255,255)
local richPlayerTransparency=0
local originalPlayerProperties={}
local originalPlayerMaterials={}
local espFolder=Instance.new("Folder")
espFolder.Name="ChamsESPFolder"
espFolder.Parent=Workspace
local espParts={}
local connections={}
local playerConnections={}
local viewModel=Workspace.CurrentCamera:FindFirstChild("ViewModel")
local ChamsConfig={
    PlayerChams={
        Enabled=false,OuterColor=Color3.fromRGB(255,255,255),
        InnerColor=Color3.fromRGB(0,0,0),TeamCheck=false,
        UseWhitelistColor=false,WhitelistColor=Color3.fromRGB(50,255,50),
        UseTargetlistColor=false,TargetlistColor=Color3.fromRGB(255,50,255)
    },
    ArmChams={
        Enabled=false,Transparency=0.5,Color=Color3.fromRGB(255,255,255),
        OriginalTransparency={},OriginalColor={},OriginalMaterial={}
    },
    ToolChams={
        Enabled=false,Transparency=0.5,Color=Color3.fromRGB(255,255,255),
        OriginalTransparency={},OriginalColor={},OriginalMaterial={}
    }
}

local espBillboards={}
local characterCache={}
local playerESPConnections={}
local library={
    directory="Nebula/",
    folders={"fonts","configs","logs"},
    flags={},
    config_flags={},
    notifications={}
}
library.__index=library
setmetatable(library,library)

for _,path in next,library.folders do 
    makefolder(library.directory..path) 
end

if isfile(library.directory.."/fonts/main.ttf") then 
    delfile(library.directory.."/fonts/main.ttf") 
end

writefile(library.directory.."/fonts/main.ttf",game:HttpGet("https://github.com/f1nobe7650/Nebula/raw/refs/heads/main/Minecraftia-Regular.ttf"))

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
        label.Font = Enum.Font.GothamBold
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
    local soundIds={
        ["Bameware"]="rbxassetid://3124331820",
        ["Bell"]="rbxassetid://6534947240",
        ["Bubble"]="rbxassetid://6534947588",
        ["Pick"]="rbxassetid://1347140027",
        ["Pop"]="rbxassetid://198598793",
        ["Rust"]="rbxassetid://1255040462",
        ["Sans"]="rbxassetid://3188795283",
        ["Fart"]="rbxassetid://130833677",
        ["Big"]="rbxassetid://5332005053",
        ["Vine"]="rbxassetid://5332680810",
        ["Bruh"]="rbxassetid://4578740568",
        ["Skeet"]="rbxassetid://5633695679",
        ["Neverlose"]="rbxassetid://6534948092",
        ["Fatality"]="rbxassetid://6534947869",
        ["Bonk"]="rbxassetid://5766898159",
        ["Minecraft"]="rbxassetid://4018616850"
    }
    local soundId=soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound]or soundIds["Skeet"]
    local sound=Instance.new("Sound")
    sound.SoundId=soundId
    sound.Volume=0.75
    sound.Parent=Workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound,0.75)
end

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
        instantReloadConnections={}
        if characterAddedConnection then characterAddedConnection:Disconnect() characterAddedConnection=nil end
        return
    end
    local tool=getCurrentTool()
    if not tool then return end
    local values=tool:FindFirstChild("Values")
    if not values then return end
    local ammo=values:FindFirstChild("SERVER_Ammo")
    local storedAmmo=values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    for _,conn in pairs(instantReloadConnections) do if conn then conn:Disconnect() end end
    instantReloadConnections={}
    if characterAddedConnection then characterAddedConnection:Disconnect() characterAddedConnection=nil end
    local gunR_remote=ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
    local me=Players.LocalPlayer
    local function setupToolListeners(toolObj)
        if not toolObj or not toolObj:FindFirstChild("IsGun") then return end
        local values=toolObj:FindFirstChild("Values")
        if not values then return end
        local ammo=values:FindFirstChild("SERVER_Ammo")
        local storedAmmo=values:FindFirstChild("SERVER_StoredAmmo")
        if not ammo or not storedAmmo then return end
        local conn1=storedAmmo:GetPropertyChangedSignal("Value"):Connect(function()
            local currentRagebot=getgenv().CONFIG.Ragebot.AutoReload
            if currentRagebot then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        end)
        if storedAmmo.Value~=0 then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        local conn2=ammo:GetPropertyChangedSignal("Value"):Connect(function()
            local currentRagebot=getgenv().CONFIG.Ragebot.AutoReload
            if currentRagebot and storedAmmo.Value~=0 then gunR_remote:FireServer(tick(),"KLWE89U0",toolObj) end
        end)
        table.insert(instantReloadConnections,conn1)
        table.insert(instantReloadConnections,conn2)
    end
    local char=me.Character
    if char then
        local tool=char:FindFirstChildOfClass("Tool")
        if tool then setupToolListeners(tool) end
        local conn3=char.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then setupToolListeners(obj) end end)
        table.insert(instantReloadConnections,conn3)
    end
    characterAddedConnection=me.CharacterAdded:Connect(function(charr)
        repeat task.wait() until charr and charr.Parent
        local conn4=charr.ChildAdded:Connect(function(obj) if obj:IsA("Tool") then setupToolListeners(obj) end end)
        table.insert(instantReloadConnections,conn4)
    end)
end

local function canSeeTarget(targetPart)
    if not getgenv().CONFIG.Ragebot.VisibilityCheck then return true end
    local localHead=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local raycastParams=RaycastParams.new()
    raycastParams.FilterType=Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances={LocalPlayer.Character}
    local startPos=localHead.Position
    local endPos=targetPart.Position
    local direction=(endPos-startPos)
    local distance=direction.Magnitude
    local raycastResult=Workspace:Raycast(startPos,direction.Unit*distance,raycastParams)
    if raycastResult then
        local hitPart=raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model=hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid=model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer=Players:GetPlayerFromCharacter(model)
                    if targetPlayer then return true end
                end
            end
            return false
        end
    end
    local secondRaycast=Workspace:Raycast(startPos+direction.Unit*0.5,direction.Unit*(distance-0.5),raycastParams)
    if secondRaycast then
        local hitPart=secondRaycast.Instance
        if hitPart and hitPart.CanCollide then
            local model=hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid=model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer=Players:GetPlayerFromCharacter(model)
                    if targetPlayer then return true end
                end
            end
            return false
        end
    end
    return true
end

local function getClosestTarget()
    local closest=nil
    local shortestDistance=math.huge
    local targetCount=0
    for _,player in pairs(Players:GetPlayers()) do
        if player==LocalPlayer then continue end
        
        local priority = Tabs.Players.GetPriority(player.Name)
        if priority == "Whitelist" then continue end
        
        if getgenv().CONFIG.Ragebot.FriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        if getgenv().CONFIG.Ragebot.UseWhitelist and priority == "Whitelist" then continue end
        if getgenv().CONFIG.Ragebot.UseTargetList and priority ~= "Target" then continue end
        if getgenv().CONFIG.Ragebot.TeamCheck and player.Team==LocalPlayer.Team then continue end
        local character=player.Character
        if character then
            local humanoid=character:FindFirstChild("Humanoid")
            local head=character:FindFirstChild("Head")
            if humanoid and humanoid.Health>0 and head then
                local hasForcefield=false
                for _,child in pairs(character:GetChildren()) do if child:IsA("ForceField") then hasForcefield=true break end end
                if hasForcefield then continue end
                if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health<15 then continue end
                local distance=(head.Position-LocalPlayer.Character.Head.Position).Magnitude
                if getgenv().CONFIG.Ragebot.MaxTarget>0 then targetCount=targetCount+1 if targetCount>getgenv().CONFIG.Ragebot.MaxTarget then break end end
                if distance<shortestDistance then if canSeeTarget(head) then closest=head shortestDistance=distance end end
            end
        end
    end
    return closest
end

local function checkClearPath(startPos,endPos)
    local raycastParams=RaycastParams.new()
    raycastParams.FilterType=Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances={LocalPlayer.Character}
    local direction=(endPos-startPos)
    local distance=direction.Magnitude
    local raycastResult=Workspace:Raycast(startPos,direction.Unit*distance,raycastParams)
    if raycastResult then
        local hitPart=raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model=hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid=model:FindFirstChild("Humanoid")
                if not humanoid then return false end
            else return false end
        end
    end
    return true
end

local function wallbang()
    local localHead=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    local target=getClosestTarget()
    if not target then cachedBestPositions.history={} cachedBestPositions.target=nil return nil,nil end
    local startPos=localHead.Position
    local targetPos=target.Position
    if not getgenv().CONFIG.Ragebot.Wallbang then return startPos,targetPos end
    local raycastParams=RaycastParams.new()
    raycastParams.FilterType=Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances={LocalPlayer.Character}
    local direction=targetPos-startPos
    local distance=direction.Magnitude
    local directRay=Workspace:Raycast(startPos,direction.Unit*distance,raycastParams)
    if not directRay then return startPos,targetPos end
    if cachedBestPositions.target~=target then cachedBestPositions.history={} cachedBestPositions.target=target end
    if#cachedBestPositions.history>0 then
        local stillValid={}
        for i=1,#cachedBestPositions.history do
            local cache=cachedBestPositions.history[i]
            local cachedShootDistance=(cache.shootPos-startPos).Magnitude
            local cachedHitDistance=(cache.hitPos-targetPos).Magnitude
            if cachedShootDistance<=getgenv().CONFIG.Ragebot.ShootRange and cachedHitDistance<=getgenv().CONFIG.Ragebot.HitRange then
                if checkClearPath(startPos,cache.shootPos) and checkClearPath(cache.shootPos,cache.hitPos) then
                    local shootToHitRay=Workspace:Raycast(cache.shootPos,(cache.hitPos-cache.shootPos).Unit*(cache.hitPos-cache.shootPos).Magnitude,raycastParams)
                    if not shootToHitRay then table.insert(stillValid,cache) end
                end
            end
        end
        cachedBestPositions.history=stillValid
        if#cachedBestPositions.history>0 then local selected=cachedBestPositions.history[math.random(1,#cachedBestPositions.history)] return selected.shootPos,selected.hitPos end
    end
    local validPoints={}
    for i=1,100 do
        local shootOffset=Vector3.new(math.random(-getgenv().CONFIG.Ragebot.ShootRange,getgenv().CONFIG.Ragebot.ShootRange),math.random(-getgenv().CONFIG.Ragebot.ShootRange,getgenv().CONFIG.Ragebot.ShootRange),math.random(-getgenv().CONFIG.Ragebot.ShootRange,getgenv().CONFIG.Ragebot.ShootRange))
        local shootPos=startPos+shootOffset
        local hitOffset=Vector3.new(math.random(-getgenv().CONFIG.Ragebot.HitRange,getgenv().CONFIG.Ragebot.HitRange),math.random(-getgenv().CONFIG.Ragebot.HitRange,getgenv().CONFIG.Ragebot.HitRange),math.random(-getgenv().CONFIG.Ragebot.HitRange,getgenv().CONFIG.Ragebot.HitRange))
        local hitPos=targetPos+hitOffset
        if(shootPos-startPos).Magnitude<=getgenv().CONFIG.Ragebot.ShootRange and(hitPos-targetPos).Magnitude<=getgenv().CONFIG.Ragebot.HitRange then
            if checkClearPath(startPos,shootPos) and checkClearPath(shootPos,hitPos) then
                local shootToHitRay=Workspace:Raycast(shootPos,(hitPos-shootPos).Unit*(hitPos-shootPos).Magnitude,raycastParams)
                if not shootToHitRay then table.insert(validPoints,{shootPos=shootPos,hitPos=hitPos,score=(shootPos-startPos).Magnitude+(hitPos-targetPos).Magnitude}) end
            end
        end
    end
    if#validPoints>0 then
        table.sort(validPoints,function(a,b) return a.score<b.score end)
        local maxCache=math.random(90,100)
        for i=1,math.min(#validPoints,maxCache) do table.insert(cachedBestPositions.history,validPoints[i]) end
        return validPoints[1].shootPos,validPoints[1].hitPos
    end
    local randomY=math.random(-16,-14)
    local fallbackShootPos=Vector3.new(startPos.X,randomY,startPos.Z)
    local fallbackHitPos=Vector3.new(targetPos.X,randomY,targetPos.Z)
    return fallbackShootPos,fallbackHitPos
end

local function createTracer(startPos,endPos)
    if not getgenv().CONFIG.Ragebot.Tracers then return end
    local tracerModel=Instance.new("Model")
    tracerModel.Name="TracerBeam"
    local beam=Instance.new("Beam")
    beam.Color=ColorSequence.new(getgenv().CONFIG.Ragebot.TracerColor)
    beam.Width0=getgenv().CONFIG.Ragebot.TracerWidth
    beam.Width1=getgenv().CONFIG.Ragebot.TracerWidth
    beam.Texture="rbxassetid://7136858729"
    beam.TextureSpeed=1
    beam.Brightness=2
    beam.LightEmission=2
    beam.FaceCamera=true
    local a0=Instance.new("Attachment")
    local a1=Instance.new("Attachment")
    a0.WorldPosition=startPos
    a1.WorldPosition=endPos
    beam.Attachment0=a0
    beam.Attachment1=a1
    beam.Parent=tracerModel
    a0.Parent=tracerModel
    a1.Parent=tracerModel
    tracerModel.Parent=Workspace
    local tweenInfo=TweenInfo.new(getgenv().CONFIG.Ragebot.TracerLifetime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
    local tween=TweenService:Create(beam,tweenInfo,{Brightness=0})
    tween:Play()
    tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
end

local function RandomString(length)
    local charset="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result=""
    for i=1,length do result=result..charset:sub(math.random(1,#charset),math.random(1,#charset)) end
    return result
end

local function shootAtTarget(targetHead)
    if not targetHead then return false end
    local localHead=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local tool=getCurrentTool()
    if not tool then return false end
    local values=tool:FindFirstChild("Values")
    local hitMarker=tool:FindFirstChild("Hitmarker")
    if not values or not hitMarker then return false end
    local ammo=values:FindFirstChild("SERVER_Ammo")
    local storedAmmo=values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return false end
    if ammo.Value<=0 then autoReload() return false end
    local bestShootPos,bestHitPos=wallbang()
    if not bestShootPos or not bestHitPos then return false end
    local hitPosition=bestHitPos
    if getgenv().CONFIG.Ragebot.Prediction then local velocity=targetHead.Velocity or Vector3.zero hitPosition=hitPosition+velocity*getgenv().CONFIG.Ragebot.PredictionAmount end
    local hitDirection=(hitPosition-bestShootPos).Unit
    local randomKey=RandomString(30).."0"
    local args1={tick(),randomKey,tool,"FDS9I83",bestShootPos,{hitDirection},false}
    local args2={"🧈",tool,randomKey,1,targetHead,hitPosition,hitDirection}
    local events=ReplicatedStorage:WaitForChild("Events")
    local GNX_S=events:WaitForChild("GNX_S")
    local ZFKLF__H=events:WaitForChild("ZFKLF__H")
    local targetPlayer=Players:GetPlayerFromCharacter(targetHead.Parent)
    if targetPlayer then createHitNotification(tool.Name,(bestShootPos-localHead.Position).Magnitude,targetPlayer.Name) playHitSound() end
    GNX_S:FireServer(unpack(args1))
    ZFKLF__H:FireServer(unpack(args2))
    hitMarker:Fire(targetHead)
    storedAmmo.Value=storedAmmo.Value
    createTracer(bestShootPos,hitPosition)
    return true
end

coroutine.wrap(function()
    while true do
        if not getgenv().CONFIG.Ragebot.Enabled then task.wait(0.001) else
            if not LocalPlayer.Character then task.wait(0.001) else
                if not LocalPlayer.Character:FindFirstChild("Head") then task.wait(0.001) else
                    local target=getClosestTarget()
                    local waitTimeValue=0.01
                    if target then
                        local currentTime=tick()
                        local WaitTime=1/(getgenv().CONFIG.Ragebot.FireRate*1)
                        if getgenv().CONFIG.Ragebot.RapidFire then
                            local rapidWaitTime=0
                            if currentTime-lastShotTime>=rapidWaitTime then shootAtTarget(target) lastShotTime=currentTime end
                            waitTimeValue=0
                        else
                            if currentTime-lastShotTime>=WaitTime then shootAtTarget(target) lastShotTime=currentTime end
                            waitTimeValue=WaitTime/2
                        end
                    end
                    task.wait(waitTimeValue)
                end
            end
        end
    end
end)()

fovCircle.Visible=getgenv().CONFIG.Ragebot.ShowFOV
fovCircle.Radius=getgenv().CONFIG.Ragebot.FOV
fovCircle.Color=Color3.fromRGB(255,255,255)
fovCircle.Thickness=1
fovCircle.Filled=false

RunService.RenderStepped:Connect(function()
    fovCircle.Visible=getgenv().CONFIG.Ragebot.ShowFOV and getgenv().CONFIG.Ragebot.Enabled
    fovCircle.Radius=getgenv().CONFIG.Ragebot.FOV
    fovCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
end)

local QuickUIFrame=Instance.new("Frame")
QuickUIFrame.Name="QuickUIFrame"
QuickUIFrame.Size=UDim2.new(0,80,0,30)
QuickUIFrame.Position=UDim2.new(0,10,0,50)
QuickUIFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
QuickUIFrame.BackgroundTransparency=0.5
QuickUIFrame.BorderSizePixel=0
local QuickUIText=Instance.new("TextButton")
QuickUIText.Name="QuickUIText"
QuickUIText.Size=UDim2.new(1,0,1,0)
QuickUIText.BackgroundTransparency=1
QuickUIText.Text="FLY OFF"
QuickUIText.TextColor3=Color3.fromRGB(255,50,50)
QuickUIText.Font=Enum.Font.GothamBold
QuickUIText.TextSize=12
QuickUIText.Parent=QuickUIFrame
local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="QuickUIScreen"
ScreenGui.Parent=game:GetService("CoreGui")
QuickUIFrame.Parent=ScreenGui

local speedEnabled=false
local speedConnection=nil
local function enableSpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection=nil end
    speedConnection=RunService.RenderStepped:Connect(function()
        local character=LocalPlayer.Character
        if not character then return end
        local humanoid=character:FindFirstChild("Humanoid")
        if not humanoid then return end
        humanoid.WalkSpeed=getgenv().CONFIG.Misc.SpeedValue
    end)
end

local function disableSpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection=nil end
    local character=LocalPlayer.Character
    if character then local humanoid=character:FindFirstChild("Humanoid") if humanoid then humanoid.WalkSpeed=16 end end
end

local jumpPowerEnabled=false
local jumpPowerConnection=nil
local function enableJumpPower()
    if jumpPowerConnection then jumpPowerConnection:Disconnect() jumpPowerConnection=nil end
    jumpPowerConnection=RunService.Heartbeat:Connect(function()
        if not jumpPowerEnabled then return end
        if not LocalPlayer.Character then return end
        local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if humanoid:GetState()==Enum.HumanoidStateType.Jumping then hrp.Velocity=Vector3.new(hrp.Velocity.X,getgenv().CONFIG.Misc.JumpPowerValue,hrp.Velocity.Z) end
    end)
end

local function disableJumpPower()
    if jumpPowerConnection then jumpPowerConnection:Disconnect() jumpPowerConnection=nil end
end

local loopFOVEnabled=false
local fovConnection=nil
local function enableLoopFOV()
    if fovConnection then fovConnection:Disconnect() fovConnection=nil end
    fovConnection=RunService.RenderStepped:Connect(function() workspace.CurrentCamera.FieldOfView=120 end)
end

local function disableLoopFOV()
    if fovConnection then fovConnection:Disconnect() fovConnection=nil end
end

local hideHeadEnabled=false
local char=nil
local torso=nil
local originalMotor6Ds={}
local renderConnection=nil
local originalHook=nil
local function hideHead()
    if not LocalPlayer.Character then return end
    char=LocalPlayer.Character
    torso=char:FindFirstChild("Torso")
    if not torso then return end
    originalMotor6Ds={}
    for _,motor in pairs(char:GetDescendants()) do if motor:IsA("Motor6D") then originalMotor6Ds[motor]={Part0=motor.Part0,Part1=motor.Part1,C0=motor.C0,C1=motor.C1} end end
    hideHeadEnabled=true
    if not originalHook then
        originalHook=hookmetamethod(game,"__namecall",function(self,...)
            local methodName=getnamecallmethod()
            if tostring(methodName)=="FireServer" then
                if self.Name=="MOVZREP" then local fixedArguments={{{Vector3.new(-5721.2001953125,-5,971.5162353515625),Vector3.new(-4181.38818359375,-6,11.123311996459961),Vector3.new(0.006237113382667303,-6,-0.18136750161647797),true,true,true,false},false,false,15.8}} return originalHook(self,table.unpack(fixedArguments)) end
            end
            return originalHook(self,...)
        end)
    end
    if renderConnection then renderConnection:Disconnect() end
    renderConnection=RunService.RenderStepped:Connect(function()
        if torso and torso.Parent then
            for motor,originalData in pairs(originalMotor6Ds) do if motor and motor.Parent then motor.C0=originalData.C0 motor.C1=originalData.C1 end end
            local neck=torso:FindFirstChild("Neck")
            if neck and neck:IsA("Motor6D") then neck.C0=CFrame.new(0,0,0.75)*CFrame.Angles(math.rad(90),0,0) neck.C1=CFrame.new(0,0.25,0)*CFrame.Angles(0,0,0) end
        else if renderConnection then renderConnection:Disconnect() renderConnection=nil end end
    end)
end

local noFallHook=nil
local function enableNoFallDmg()
    if noFallHook then return end
    noFallHook=hookmetamethod(game,"__namecall",function(self,...)
        local args={...}
        if getnamecallmethod()=="FireServer" and not checkcaller() and args[1]=="FlllD" and args[4]==false then args[2]=0 args[3]=0 end
        return noFallHook(self,unpack(args))
    end)
end

local function disableNoFallDmg()
    if noFallHook then hookmetamethod(game,"__namecall",noFallHook) noFallHook=nil end
end

local infStaminaHook=nil
local function enableInfStamina()
    if infStaminaHook then return end
    local module
    for i,v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do if v:IsA("ModuleScript") and v.Name=="XIIX" then module=v break end end
    if module then
        module=require(module)
        local ac=module["XIIX"]
        local glob=getfenv(ac)["_G"]
        local stamina=getupvalues((getupvalues(glob["S_Check"]))[2])[1]
        if stamina~=nil then infStaminaHook=hookfunction(stamina,function() return 100,100 end) end
    end
end

local function disableInfStamina()
    if infStaminaHook then hookfunction(stamina,infStaminaHook) infStaminaHook=nil end
end

local lockpickEnabled=false
local lockpickAddedConnection=nil
local function enableLockpick()
    lockpickEnabled=true
    local PlayerGui=LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    local function lockpick(gui)
        for _,a in pairs(gui:GetDescendants()) do
            if a:IsA("ImageLabel") and a.Name=="Bar" and a.Parent.Name~="Attempts" then
                local oldsize=a.Size
                RunService.RenderStepped:Connect(function()
                    if lockpickEnabled then a.Size=UDim2.new(0,280,0,280) else a.Size=oldsize end
                end)
            end
        end
    end
    if lockpickAddedConnection then lockpickAddedConnection:Disconnect() end
    lockpickAddedConnection=PlayerGui.ChildAdded:Connect(function(child) if child:IsA("ScreenGui") and child.Name=="LockpickGUI" then lockpick(child) end end)
    for _,child in pairs(PlayerGui:GetChildren()) do if child:IsA("ScreenGui") and child.Name=="LockpickGUI" then lockpick(child) end end
end

local function disableLockpick()
    lockpickEnabled=false
    if lockpickAddedConnection then lockpickAddedConnection:Disconnect() lockpickAddedConnection=nil end
end

local SafeESP={Enabled=false,Safes={},Visuals={}}
local function addSafeESP(model)
    if not model or not model.Parent then return end
    local highlight=Instance.new("Highlight")
    highlight.FillColor=Color3.fromRGB(255,215,0)
    highlight.FillTransparency=0.7
    highlight.OutlineColor=Color3.fromRGB(255,140,0)
    highlight.OutlineTransparency=0
    highlight.Adornee=model
    highlight.Parent=model
    local billboard=Instance.new("BillboardGui")
    billboard.Name="SafeESP"
    billboard.Adornee=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    billboard.Size=UDim2.new(0,200,0,50)
    billboard.StudsOffset=Vector3.new(0,3,0)
    billboard.AlwaysOnTop=true
    billboard.MaxDistance=100
    local textLabel=Instance.new("TextLabel")
    textLabel.Size=UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency=1
    textLabel.TextColor3=Color3.fromRGB(255,215,0)
    textLabel.TextSize=14
    textLabel.Font=Enum.Font.GothamBold
    textLabel.TextStrokeTransparency=0.5
    textLabel.Text=model.Name
    local distanceLabel=Instance.new("TextLabel")
    distanceLabel.Size=UDim2.new(1,0,0,20)
    distanceLabel.Position=UDim2.new(0,0,0,20)
    distanceLabel.BackgroundTransparency=1
    distanceLabel.TextColor3=Color3.fromRGB(200,200,200)
    distanceLabel.TextSize=12
    distanceLabel.Font=Enum.Font.GothamBold
    distanceLabel.TextStrokeTransparency=0.5
    textLabel.Parent=billboard
    distanceLabel.Parent=billboard
    billboard.Parent=model
    SafeESP.Safes[model]=true
    SafeESP.Visuals[model]={highlight=highlight,billboard=billboard,textLabel=textLabel,distanceLabel=distanceLabel}
    RunService.Heartbeat:Connect(function()
        if not SafeESP.Enabled or not model.Parent then highlight:Destroy() billboard:Destroy() SafeESP.Safes[model]=nil SafeESP.Visuals[model]=nil return end
        if LocalPlayer and LocalPlayer.Character then
            local humanoidRootPart=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and billboard.Adornee then local distance=(humanoidRootPart.Position-billboard.Adornee.Position).Magnitude distanceLabel.Text=string.format("%d studs",math.floor(distance)) billboard.Enabled=distance<=100 end
        end
    end)
end

local function scanWorkspace()
    for _,item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Model") then
            local itemName=item.Name:lower()
            if itemName:find("mediumsafe") or itemName:find("smallsafe") then if not SafeESP.Safes[item] then addSafeESP(item) end end
        end
    end
end

local safeColor=Color3.fromRGB(255,215,0)
local function enableSafeESP(value)
    SafeESP.Enabled=value
    if value then
        scanWorkspace()
        Workspace.DescendantAdded:Connect(function(item)
            if item:IsA("Model") then
                local itemName=item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then task.wait(0.1) addSafeESP(item) end
            end
        end)
    else
        for model,visuals in pairs(SafeESP.Visuals) do if visuals.highlight then visuals.highlight:Destroy() end if visuals.billboard then visuals.billboard:Destroy() end end
        SafeESP.Safes={}
        SafeESP.Visuals={}
    end
end

local function updateSafeColor(color)
    safeColor=color
    for model,visuals in pairs(SafeESP.Visuals) do
        if visuals.highlight then visuals.highlight.FillColor=color end
        if visuals.textLabel then visuals.textLabel.TextColor3=color end
    end
end

local instantPromptEnabled=false
local instantPromptConnection=nil
local function enableInstantPrompt()
    instantPromptEnabled=true
    for _,obj in pairs(game:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration=0 end end
    if instantPromptConnection then instantPromptConnection:Disconnect() end
    instantPromptConnection=game.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") then task.wait() obj.HoldDuration=0 end end)
end

local function disableInstantPrompt()
    instantPromptEnabled=false
    if instantPromptConnection then instantPromptConnection:Disconnect() instantPromptConnection=nil end
    for _,obj in pairs(game:GetDescendants()) do if obj:IsA("ProximityPrompt") then obj.HoldDuration=1 end end
end

local autoDoorEnabled=false
local doorConnection=nil
local function enableAutoDoor()
    autoDoorEnabled=true
    if doorConnection then doorConnection:Disconnect() end
    doorConnection=RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character then return end
        local charRoot=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not charRoot then return end
        local Map=Workspace:FindFirstChild("Map")
        if not Map then return end
        local Doors=Map:FindFirstChild("Doors")
        if not Doors then return end
        local closestDoor=nil
        local closestDistance=15
        for _,door in pairs(Doors:GetChildren()) do
            local knob=door:FindFirstChild("Knob1") or door:FindFirstChild("Knob2")
            if knob then
                local distance=(knob.Position-charRoot.Position).Magnitude
                if distance<closestDistance then closestDistance=distance closestDoor=door end
            end
        end
        if closestDoor then
            local knob=closestDoor:FindFirstChild("Knob1") or closestDoor:FindFirstChild("Knob2")
            local events=closestDoor:FindFirstChild("Events")
            local toggleEvent=events and events:FindFirstChild("Toggle")
            if knob and toggleEvent then local args={"Open",knob} toggleEvent:FireServer(unpack(args)) end
        end
    end)
end

local function disableAutoDoor()
    autoDoorEnabled=false
    if doorConnection then doorConnection:Disconnect() doorConnection=nil end
end

local flyEnabled=false
local flySpeed=50
local flyConnection=nil
local function startFlying()
    local Char=LocalPlayer.Character
    if not Char then return end
    local Hum=Char:FindFirstChildOfClass("Humanoid")
    local Root=Char:FindFirstChild("HumanoidRootPart")
    if not Hum or not Root then return end
    local RagdollEvent=ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL")
    RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),false)
    for _,child in ipairs(Char:GetDescendants()) do if child:IsA("Motor6D") then child.Enabled=false end end
    Hum.PlatformStand=true
    Hum:ChangeState(Enum.HumanoidStateType.Freefall)
    local flyMotors={}
    for _,part in ipairs(Char:GetDescendants()) do
        if part:IsA("BasePart") and part~=Root then
            local motor=Instance.new("Motor6D")
            motor.Name="FlyMotor"
            motor.Part0=Root
            motor.Part1=part
            motor.C1=CFrame.new()
            motor.C0=Root.CFrame:ToObjectSpace(part.CFrame)
            motor.Parent=part
            table.insert(flyMotors,motor)
        end
    end
    flyConnection=RunService.Heartbeat:Connect(function()
        if not flyEnabled then
            if flyConnection then flyConnection:Disconnect() flyConnection=nil end
            Hum.PlatformStand=false
            Root.Velocity=Vector3.new(0,0,0)
            Hum:ChangeState(Enum.HumanoidStateType.Running)
            RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),true)
            for _,motor in ipairs(flyMotors) do motor:Destroy() end
            for _,child in ipairs(Char:GetDescendants()) do if child:IsA("Motor6D") and child.Name~="FlyMotor" then child.Enabled=true end end
            return
        end
        local Cam=Workspace.CurrentCamera
        if not Cam then return end
        local cameraLook=Cam.CFrame.LookVector
        local IsMoving=Hum.MoveDirection.Magnitude>0
        local targetLook=Vector3.new(cameraLook.X,cameraLook.Y,cameraLook.Z)
        if targetLook.Magnitude>0 then targetLook=targetLook.Unit Root.CFrame=CFrame.new(Root.Position,Root.Position+targetLook) end
        if IsMoving then
            local moveVector=Vector3.new(cameraLook.X,cameraLook.Y,cameraLook.Z).Unit
            Root.Velocity=moveVector*flySpeed
            RagdollEvent:FireServer("__---r",Vector3.zero,CFrame.new(-4574,3,-443,0,0,1,0,1,0,-1,0,0),false)
        else Root.Velocity=Vector3.new(0,0,0) end
    end)
end

local function disableFlying() 
    flyEnabled=false 
end

QuickUIText.MouseButton1Click:Connect(function()
    flyEnabled=not flyEnabled
    if flyEnabled then 
        QuickUIText.Text="FLY ON" 
        QuickUIText.TextColor3=Color3.fromRGB(50,255,50) 
        startFlying()
    else 
        QuickUIText.Text="FLY OFF" 
        QuickUIText.TextColor3=Color3.fromRGB(255,50,50) 
        disableFlying() 
    end
end)

local function get_closest_target()
    local closest=nil
    local closest_dist=math.huge
    for _,player in pairs(Players:GetPlayers()) do
        if player==LocalPlayer then continue end
        
        local priority = Tabs.Players.GetPriority(player.Name)
        if priority == "Whitelist" then continue end
        
        local character=player.Character
        if not character then continue end
        local humanoid=character:FindFirstChild("Humanoid")
        local head=character:FindFirstChild("Head")
        if humanoid and humanoid.Health>0 and head then
            local dist=(head.Position-LocalPlayer.Character.Head.Position).Magnitude
            if dist<closest_dist then closest_dist=dist closest=player end
        end
    end
    return closest
end

local function get_target_part(character)
    local should_head=math.random(1,100)<=getgenv().Legit.HeadChance
    local part_name=should_head and "Head" or getgenv().Legit.HitPart
    local target_part=character:FindFirstChild(part_name)
    if not target_part and part_name=="Head" then target_part=character:FindFirstChild("Torso") end
    if not target_part then target_part=character:FindFirstChild("HumanoidRootPart") end
    return target_part
end

RunService.RenderStepped:Connect(function()
    if not getgenv().Legit.Enabled then silent_aim_active=false aim_target=nil return end
    local target=get_closest_target()
    silent_aim_active=target and true or false
    aim_target=target or nil
    if aim_target and aim_target.Character then
        local character=aim_target.Character
        local target_part=get_target_part(character)
        if target_part then aim_position=target_part.Position end
    end
end)

RunService.Heartbeat:Connect(function()
    if not getgenv().Legit.AimAssist or not getgenv().Legit.Enabled or not aim_target or not aim_target.Character then return end
    local character=aim_target.Character
    local target_part=get_target_part(character)
    if not target_part then return end
    local screen_pos,on_screen=Camera:WorldToViewportPoint(target_part.Position)
    if on_screen then
        local screen_center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
        local target_screen_pos=Vector2.new(screen_pos.X,screen_pos.Y)
        local distance_to_center=(target_screen_pos-screen_center).Magnitude
        local max_screen_distance=100
        if distance_to_center<max_screen_distance then
            local strength=getgenv().Legit.AimAssistStrength*(1-(distance_to_center/max_screen_distance))
            local smoothing=getgenv().Legit.Smoothing
            local cam_pos=Camera.CFrame.Position
            local target_look=CFrame.lookAt(cam_pos,aim_position)
            local current_look=Camera.CFrame
            local lerped=current_look:Lerp(target_look,strength*(1-smoothing))
            Camera.CFrame=CFrame.new(lerped.Position,aim_position)
        end
    end
end)

local __namecall
__namecall=hookmetamethod(game,"__namecall",function(self,...)
    local args={...}
    local method=getnamecallmethod()
    if not checkcaller() and silent_aim_active and aim_target and self==Workspace and tostring(method)=="Raycast" then
        local origin=args[1]
        local direction=(aim_position-origin).Unit*1000
        args[2]=direction
        return __namecall(self,unpack(args))
    end
    return __namecall(self,...)
end)

local function apply_no_recoil()
    if not getgenv().Legit.NoRecoil then return end
    for _,config in pairs(getgc(true)) do
        if type(config)=="table" and rawget(config,"Recoil") then
            rawset(config,"Recoil",0)
            rawset(config,"RecoilSpeed",0)
            rawset(config,"AngleX_Min",0)
            rawset(config,"AngleX_Max",0)
            rawset(config,"AngleY_Min",0)
            rawset(config,"AngleY_Max",0)
        end
    end
    for _,container in ipairs({LocalPlayer.Backpack,LocalPlayer.Character}) do
        for _,tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local config=tool:FindFirstChild("Config")
                if config and config:IsA("ModuleScript") then
                    local success,data=pcall(require,config)
                    if success and type(data)=="table" then
                        rawset(data,"Recoil",0)
                        rawset(data,"RecoilSpeed",0)
                        rawset(data,"AngleX_Min",0)
                        rawset(data,"AngleX_Max",0)
                        rawset(data,"AngleY_Min",0)
                        rawset(data,"AngleY_Max",0)
                    end
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function() 
    task.wait(1) 
    if getgenv().Legit.NoRecoil then 
        apply_no_recoil() 
    end 
end)

LocalPlayer.Backpack.ChildAdded:Connect(function(tool) 
    task.wait(0.1) 
    if getgenv().Legit.NoRecoil then 
        apply_no_recoil() 
    end 
end)

local function create(startPos,endPos)
    if not bulletTracersEnabled then return end
    local tracerModel=Instance.new("Model")
    tracerModel.Name="Tracer"
    local beam=Instance.new("Beam")
    beam.Color=ColorSequence.new(tracerColor)
    beam.Width0=tracerWidth
    beam.Width1=tracerWidth
    beam.Texture="rbxassetid://7136858729"
    beam.TextureSpeed=1
    beam.Brightness=2
    beam.LightEmission=1
    beam.FaceCamera=true
    local a0=Instance.new("Attachment")
    local a1=Instance.new("Attachment")
    a0.WorldPosition=startPos
    a1.WorldPosition=endPos
    beam.Attachment0=a0
    beam.Attachment1=a1
    beam.Parent=tracerModel
    a0.Parent=tracerModel
    a1.Parent=tracerModel
    tracerModel.Parent=Workspace
    local tweenInfo=TweenInfo.new(tracerLifetime,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
    local tween=TweenService:Create(beam,tweenInfo,{Brightness=0,Width0=0,Width1=0})
    tween:Play()
    tween.Completed:Connect(function() if tracerModel then tracerModel:Destroy() end end)
    task.delay(tracerLifetime+0.1,function() if tracerModel and tracerModel.Parent then tracerModel:Destroy() end end)
end

local function trackGlobalBullets()
    if _G.TracersRunning then return end
    _G.TracersRunning=true
    local bfr=Camera:FindFirstChild("Bullets")
    if not bfr then bfr=Instance.new("Folder") bfr.Name="Bullets" bfr.Parent=Camera end
    local function tblt(blt)
        if not blt:IsA("BasePart") then return end
        local stp=blt.Position
        local lsp=stp
        local stc=0
        local con
        con=RunService.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if(lsp-stp).Magnitude>1 then create(stp,lsp) end
                return
            end
            local cp=blt.Position
            if(cp-lsp).Magnitude<0.1 then
                stc=stc+1
                if stc>3 then con:Disconnect() if(cp-stp).Magnitude>1 then create(stp,cp) end end
            else stc=0 lsp=cp end
        end)
    end
    bfr.ChildAdded:Connect(tblt)
    for _,v in ipairs(bfr:GetChildren()) do tblt(v) end
end

local function getPlayerPriorityColor(playerName)
    local priority = Tabs.Players.GetPriority(playerName)
    if priority == "Target" then
        return Color3.fromRGB(255, 50, 255)
    elseif priority == "Whitelist" then
        return Color3.fromRGB(50, 255, 50)
    end
    return Color3.fromRGB(255, 50, 50)
end

local function applyRichPlayer()
    local char=LocalPlayer.Character
    if not char then return end
    if not next(originalPlayerProperties) then
        for _,partName in ipairs({"Torso","Right Leg","Right Arm","Left Leg","Left Arm","Head"}) do
            local part=char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                originalPlayerProperties[partName]={Color=part.Color,Transparency=part.Transparency}
                originalPlayerMaterials[partName]=part.Material
            end
        end
    end
    for _,partName in ipairs({"Torso","Right Leg","Right Arm","Left Leg","Left Arm","Head"}) do
        local part=char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Color=richPlayerColor
            part.Transparency=richPlayerTransparency/100
            part.Material=Enum.Material.ForceField
        end
    end
end

local function resetRichPlayer()
    local char=LocalPlayer.Character
    if not char then return end
    for partName,properties in pairs(originalPlayerProperties) do
        local part=char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Color=properties.Color part.Transparency=properties.Transparency end
    end
    for partName,material in pairs(originalPlayerMaterials) do
        local part=char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Material=material end
    end
    originalPlayerProperties={}
    originalPlayerMaterials={}
end

LocalPlayer.CharacterAdded:Connect(function() 
    if richPlayerEnabled then 
        applyRichPlayer() 
    end 
end)

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection=nil end
    local character=LocalPlayer.Character
    if not character then return end
    for _,part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=true end end
end

local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    local character=LocalPlayer.Character
    if not character then return end
    for _,part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
    noclipConnection=RunService.Stepped:Connect(function()
        if not noclipEnabled or not character or not character.Parent then stopNoclip() return end
        for _,part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
    end)
end

local function getPlayerChamsColor(player)
    local priority = Tabs.Players.GetPriority(player.Name)
    if priority == "Target" then return Color3.fromRGB(255, 50, 255) end
    if priority == "Whitelist" then return Color3.fromRGB(50, 255, 50) end
    return Color3.fromRGB(255, 255, 255)
end

local function createPlayerBox(character,player)
    if not ChamsConfig.PlayerChams.Enabled then return end
    if ChamsConfig.PlayerChams.TeamCheck and LocalPlayer.Team and player.Team and LocalPlayer.Team==player.Team then return end
    local boxes={}
    local playerColor=getPlayerChamsColor(player)
    local bodyParts={"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
    for _,partName in ipairs(bodyParts) do
        local originalPart=character:FindFirstChild(partName)
        if originalPart then
            local outerBox=Instance.new("BoxHandleAdornment")
            outerBox.Name="ESPBoxOuter"
            outerBox.Adornee=originalPart
            outerBox.Size=originalPart.Size+Vector3.new(0.1,0.1,0.1)
            outerBox.Color3=playerColor
            outerBox.Transparency=0
            outerBox.AlwaysOnTop=true
            outerBox.ZIndex=0
            outerBox.Parent=espFolder
            local innerBox=Instance.new("BoxHandleAdornment")
            innerBox.Name="ESPBoxInner"
            innerBox.Adornee=originalPart
            innerBox.Size=originalPart.Size
            innerBox.Color3=ChamsConfig.PlayerChams.InnerColor
            innerBox.Transparency=0
            innerBox.AlwaysOnTop=true
            innerBox.ZIndex=1
            innerBox.Parent=espFolder
            table.insert(boxes,{outer=outerBox,inner=innerBox,part=originalPart,player=player})
        end
    end
    espParts[character]=boxes
end

local function updatePlayerBoxColors()
    for character,boxes in pairs(espParts) do
        if character and character:IsDescendantOf(Workspace) then
            local player=Players:GetPlayerFromCharacter(character)
            if player then
                local playerColor=getPlayerChamsColor(player)
                for _,boxData in ipairs(boxes) do
                    if boxData.outer and boxData.outer.Parent then boxData.outer.Color3=playerColor end
                end
            end
        end
    end
end

local function updatePlayerBoxes()
    for character,boxes in pairs(espParts) do
        if character and character:IsDescendantOf(Workspace) then
            local humanoid=character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health>0 then
                for _,boxData in ipairs(boxes) do
                    if boxData.part and boxData.part:IsDescendantOf(Workspace) then
                        boxData.outer.Adornee=boxData.part
                        boxData.inner.Adornee=boxData.part
                        if boxData.part.Name=="Head" then boxData.outer.Size=boxData.part.Size+Vector3.new(0.1,0.1,0.1) boxData.inner.Size=boxData.part.Size else boxData.outer.Size=boxData.part.Size+Vector3.new(0.1,0.1,0.1) boxData.inner.Size=boxData.part.Size end
                    end
                end
            else
                for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() end
                espParts[character]=nil
            end
        else for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() end espParts[character]=nil end
    end
end

local function onCharacterAdded(character,player) 
    wait(1) 
    if ChamsConfig.PlayerChams.Enabled then 
        createPlayerBox(character,player) 
    end 
end

local function onPlayerChamsAdded(player)
    if player==LocalPlayer then return end
    if playerConnections[player] then for _,connection in ipairs(playerConnections[player]) do connection:Disconnect() end end
    playerConnections[player]={}
    local function characterAdded(character) onCharacterAdded(character,player) end
    if player.Character then characterAdded(player.Character) end
    local conn1=player.CharacterAdded:Connect(characterAdded)
    local conn2=player.CharacterRemoving:Connect(function(character)
        if espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() end espParts[character]=nil end
    end)
    table.insert(playerConnections[player],conn1)
    table.insert(playerConnections[player],conn2)
    table.insert(connections,conn1)
    table.insert(connections,conn2)
end

local function onPlayerChamsRemoving(player)
    if playerConnections[player] then for _,connection in ipairs(playerConnections[player]) do connection:Disconnect() end playerConnections[player]=nil end
    local character=player.Character
    if character and espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() end espParts[character]=nil end
end

local function cleanupPlayerChams()
    for character,boxes in pairs(espParts) do for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() end end
    espParts={}
    for _,connection in ipairs(connections) do connection:Disconnect() end connections={}
    for player,playerCons in pairs(playerConnections) do for _,connection in ipairs(playerCons) do connection:Disconnect() end end playerConnections={}
end

local function enablePlayerChams()
    if not ChamsConfig.PlayerChams.Enabled then return end
    cleanupPlayerChams()
    for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then onPlayerChamsAdded(player) end end
end

local function disablePlayerChams() cleanupPlayerChams() end

local function saveOriginalArmProperties(arm)
    if not arm then return end
    if arm:IsA("BasePart") then
        ChamsConfig.ArmChams.OriginalTransparency[arm]=arm.Transparency
        ChamsConfig.ArmChams.OriginalColor[arm]=arm.Color
        ChamsConfig.ArmChams.OriginalMaterial[arm]=arm.Material
    elseif arm:IsA("Model") then
        for _,part in pairs(arm:GetDescendants()) do
            if part:IsA("BasePart") then
                ChamsConfig.ArmChams.OriginalTransparency[part]=part.Transparency
                ChamsConfig.ArmChams.OriginalColor[part]=part.Color
                ChamsConfig.ArmChams.OriginalMaterial[part]=part.Material
            end
        end
    end
end

local function saveOriginalToolProperties(tool)
    if not tool then return end
    for _,part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            ChamsConfig.ToolChams.OriginalTransparency[part]=part.Transparency
            ChamsConfig.ToolChams.OriginalColor[part]=part.Color
            ChamsConfig.ToolChams.OriginalMaterial[part]=part.Material
        end
    end
end

local function restoreOriginalArmProperties(arm)
    if not arm then return end
    if arm:IsA("BasePart") then
        local origTransparency=ChamsConfig.ArmChams.OriginalTransparency[arm]
        local origColor=ChamsConfig.ArmChams.OriginalColor[arm]
        local origMaterial=ChamsConfig.ArmChams.OriginalMaterial[arm]
        if origTransparency then arm.Transparency=origTransparency end
        if origColor then arm.Color=origColor end
        if origMaterial then arm.Material=origMaterial end
        ChamsConfig.ArmChams.OriginalTransparency[arm]=nil
        ChamsConfig.ArmChams.OriginalColor[arm]=nil
        ChamsConfig.ArmChams.OriginalMaterial[arm]=nil
    elseif arm:IsA("Model") then
        for _,part in pairs(arm:GetDescendants()) do
            if part:IsA("BasePart") then
                local origTransparency=ChamsConfig.ArmChams.OriginalTransparency[part]
                local origColor=ChamsConfig.ArmChams.OriginalColor[part]
                local origMaterial=ChamsConfig.ArmChams.OriginalMaterial[part]
                if origTransparency then part.Transparency=origTransparency end
                if origColor then part.Color=origColor end
                if origMaterial then part.Material=origMaterial end
                ChamsConfig.ArmChams.OriginalTransparency[part]=nil
                ChamsConfig.ArmChams.OriginalColor[part]=nil
                ChamsConfig.ArmChams.OriginalMaterial[part]=nil
            end
        end
    end
end

local function restoreOriginalToolProperties(tool)
    if not tool then return end
    for _,part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            local origTransparency=ChamsConfig.ToolChams.OriginalTransparency[part]
            local origColor=ChamsConfig.ToolChams.OriginalColor[part]
            local origMaterial=ChamsConfig.ToolChams.OriginalMaterial[part]
            if origTransparency then part.Transparency=origTransparency end
            if origColor then part.Color=origColor end
            if origMaterial then part.Material=origMaterial end
            ChamsConfig.ToolChams.OriginalTransparency[part]=nil
            ChamsConfig.ToolChams.OriginalColor[part]=nil
            ChamsConfig.ToolChams.OriginalMaterial[part]=nil
        end
    end
end

local function applyForcefieldToArms()
    if not ChamsConfig.ArmChams.Enabled then return end
    if not viewModel then return end
    local rightArm=viewModel:FindFirstChild("Right Arm")
    local leftArm=viewModel:FindFirstChild("Left Arm")
    if rightArm then saveOriginalArmProperties(rightArm) end
    if leftArm then saveOriginalArmProperties(leftArm) end
    local function applyToArm(arm)
        if arm:IsA("BasePart") then
            arm.Material=Enum.Material.ForceField
            arm.Transparency=ChamsConfig.ArmChams.Transparency
            arm.Color=ChamsConfig.ArmChams.Color
        elseif arm:IsA("Model") then
            for _,part in pairs(arm:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material=Enum.Material.ForceField
                    part.Transparency=ChamsConfig.ArmChams.Transparency
                    part.Color=ChamsConfig.ArmChams.Color
                end
            end
        end
    end
    if rightArm then applyToArm(rightArm) end
    if leftArm then applyToArm(leftArm) end
end

local function applyForcefieldToTool()
    if not ChamsConfig.ToolChams.Enabled then return end
    local currentTool=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if currentTool then
        saveOriginalToolProperties(currentTool)
        for _,part in pairs(currentTool:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material=Enum.Material.ForceField
                part.Transparency=ChamsConfig.ToolChams.Transparency
                part.Color=ChamsConfig.ToolChams.Color
            end
        end
    end
end

local function removeForcefieldFromArms()
    if not viewModel then return end
    local rightArm=viewModel:FindFirstChild("Right Arm")
    local leftArm=viewModel:FindFirstChild("Left Arm")
    if rightArm then restoreOriginalArmProperties(rightArm) end
    if leftArm then restoreOriginalArmProperties(leftArm) end
end

local function removeForcefieldFromTool()
    local currentTool=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if currentTool then restoreOriginalToolProperties(currentTool) end
end

local function onLocalPlayerCharacterAdded()
    task.wait(1)
    if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() end
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
end

local function onLocalPlayerCharacterRemoving(character)
    if espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() end espParts[character]=nil end
end

RunService.RenderStepped:Connect(function()
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() else removeForcefieldFromArms() end
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() else removeForcefieldFromTool() end
end)

LocalPlayer.CharacterAdded:Connect(onLocalPlayerCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onLocalPlayerCharacterRemoving)
LocalPlayer.Backpack.ChildAdded:Connect(function() 
    task.wait(0.1) 
    if ChamsConfig.ToolChams.Enabled then 
        applyForcefieldToTool() 
    end 
end)

local updateConnection=RunService.RenderStepped:Connect(function() 
    if ChamsConfig.PlayerChams.Enabled then 
        updatePlayerBoxes() 
    end 
end)

Players.PlayerAdded:Connect(function(player) 
    if player~=LocalPlayer and ChamsConfig.PlayerChams.Enabled then 
        onPlayerChamsAdded(player) 
    end 
end)

Players.PlayerRemoving:Connect(onPlayerChamsRemoving)

game:GetService("UserInputService").InputBegan:Connect(function(input,gameProcessed)
    if not gameProcessed and input.KeyCode==Enum.KeyCode.RightControl then
        ChamsConfig.PlayerChams.Enabled=not ChamsConfig.PlayerChams.Enabled
        if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() else disablePlayerChams() end
    end
end)

task.spawn(function()
    wait(1)
    if LocalPlayer.Character and ChamsConfig.PlayerChams.Enabled then enablePlayerChams() end
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
end)

local CurrentCharacter = LocalPlayer.Character
local Head = CurrentCharacter and CurrentCharacter:FindFirstChild("Head")
local SoundConnection = RunService.Heartbeat:Connect(function()
    if Head then
        for _, SoundObject in pairs(Head:GetChildren()) do
            if SoundObject:IsA("Sound") then
                SoundObject:Destroy()
            end
        end
    end
end)

local function OnCharacterAdded(NewCharacter)
    Head = nil
    SoundConnection:Disconnect()
    task.wait(0.5)
    Head = NewCharacter:WaitForChild("Head")
    SoundConnection = RunService.Heartbeat:Connect(function()
        for _, SoundObject in pairs(Head:GetChildren()) do
            if SoundObject:IsA("Sound") then
                SoundObject:Destroy()
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if CurrentCharacter then
    OnCharacterAdded(CurrentCharacter)
end

local RagebotTab1, RagebotTab2, RagebotTab3 = Tabs.Combat:MultiSection({Tabs = {"Ragebot Main", "Targeting", "Aim Settings"}, Side = "Left", Size = 1})
local VisualsTab1, VisualsTab2 = Tabs.Combat:MultiSection({Tabs = {"Tracers", "Notifications"}, Side = "Right", Size = 1})

RagebotTab1:Toggle({Name = "Enable Ragebot", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.Enabled = value end})
RagebotTab1:Toggle({Name = "Rapid Fire", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.RapidFire = value end})
RagebotTab1:Toggle({Name = "Hit Sound", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.HitSound = value end})
RagebotTab1:Toggle({Name = "Auto Reload", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.AutoReload = value end})
RagebotTab1:Slider({Name = "Fire Rate", Default = 30, Min = 1, Max = 1000, Callback = function(value) getgenv().CONFIG.Ragebot.FireRate = value end})
RagebotTab1:Slider({Name = "Shoot Range", Default = 15, Min = 1, Max = 30, Callback = function(value) getgenv().CONFIG.Ragebot.ShootRange = value end})
RagebotTab1:Slider({Name = "Hit Range", Default = 15, Min = 1, Max = 30, Callback = function(value) getgenv().CONFIG.Ragebot.HitRange = value end})
RagebotTab1:Dropdown({Name = "Hit Sound", Options = {"Bameware","Bell","Bubble","Pick","Pop","Rust","Sans","Fart","Big","Vine","Bruh","Skeet","Neverlose","Fatality","Bonk","Minecraft"}, Default = "Skeet", Callback = function(value) getgenv().CONFIG.Ragebot.SelectedHitSound = value end})

RagebotTab2:Toggle({Name = "Team Check", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.TeamCheck = value end})
RagebotTab2:Toggle({Name = "Visibility Check", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.VisibilityCheck = value end})
RagebotTab2:Toggle({Name = "Wallbang", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Wallbang = value end})
RagebotTab2:Toggle({Name = "Downed Check", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.LowHealthCheck = value end})
RagebotTab2:Toggle({Name = "Friend Check", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.FriendCheck = value end})
RagebotTab2:Toggle({Name = "Use Target List", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.UseTargetList = value end})
RagebotTab2:Toggle({Name = "Use Whitelist", Default = false, Callback = function(value) getgenv().CONFIG.Ragebot.UseWhitelist = value end})

RagebotTab3:Toggle({Name = "Prediction", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Prediction = value end})
RagebotTab3:Slider({Name = "Prediction Amount", Default = 0.12, Min = 0.05, Max = 0.3, Callback = function(value) getgenv().CONFIG.Ragebot.PredictionAmount = value end})

VisualsTab1:Toggle({Name = "Tracers", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.Tracers = value end})
VisualsTab1:Colorpicker({Name = "Tracer Color", Default = Color3.fromRGB(255,0,0), Callback = function(color) getgenv().CONFIG.Ragebot.TracerColor = color end})
VisualsTab1:Slider({Name = "Tracer Width", Default = 1, Min = 0.1, Max = 5, Callback = function(value) getgenv().CONFIG.Ragebot.TracerWidth = value end})
VisualsTab1:Slider({Name = "Tracer Lifetime", Default = 3, Min = 0.5, Max = 100, Callback = function(value) getgenv().CONFIG.Ragebot.TracerLifetime = value end})

VisualsTab2:Toggle({Name = "Hit Notify", Default = true, Callback = function(value) getgenv().CONFIG.Ragebot.HitNotify = value end})
VisualsTab2:Colorpicker({Name = "hit notification color", Default = Color3.fromRGB(255,182,193), Callback = function(color) getgenv().CONFIG.Ragebot.HitColor = color end})
VisualsTab2:Slider({Name = "Hit Notify Duration", Default = 5, Min = 1, Max = 10, Callback = function(value) getgenv().CONFIG.Ragebot.HitNotifyDuration = value end})

RagebotTab1:Keybind({Name = "Ragebot Key", Default = Enum.KeyCode.F, Callback = function() getgenv().CONFIG.Ragebot.Enabled = not getgenv().CONFIG.Ragebot.Enabled end})

local LegitSection = Tabs.Combat:Section({Name = "Legit Settings", Side = "Left"})

LegitSection:Toggle({Name = "Enable", Default = false, Callback = function(value) getgenv().Legit.Enabled = value end})
LegitSection:Slider({Name = "Head Chance", Default = 30, Min = 0, Max = 100, Callback = function(value) getgenv().Legit.HeadChance = value end})
LegitSection:Dropdown({Name = "Hit Part", Options = {"Head","Torso","Neck","Random"}, Default = "Torso", Callback = function(value) getgenv().Legit.HitPart = value end})
LegitSection:Toggle({Name = "No Recoil", Default = true, Callback = function(value) getgenv().Legit.NoRecoil = value apply_no_recoil() end})
LegitSection:Toggle({Name = "Aim Assist", Default = false, Callback = function(value) getgenv().Legit.AimAssist = value end})
LegitSection:Slider({Name = "Assist Strength", Default = 0.3, Min = 0.1, Max = 1.0, Callback = function(value) getgenv().Legit.AimAssistStrength = value end})
LegitSection:Slider({Name = "Smoothing", Default = 0.2, Min = 0.1, Max = 0.8, Callback = function(value) getgenv().Legit.Smoothing = value end})

LegitSection:Keybind({Name = "Legit Key", Default = Enum.KeyCode.G, Callback = function() getgenv().Legit.Enabled = not getgenv().Legit.Enabled end})

local MovementTab1, MovementTab2 = Tabs.Combat:MultiSection({Tabs = {"Movement", "Visual"}, Side = "Right", Size = 1})
local OtherTab1, OtherTab2 = Tabs.Combat:MultiSection({Tabs = {"Other", "Safe ESP"}, Side = "Left", Size = 1})

MovementTab1:Toggle({Name = "Speed", Default = false, Callback = function(value) speedEnabled = value if value then enableSpeed() else disableSpeed() end end})
MovementTab1:Slider({Name = "Speed Value", Default = 50, Min = 10, Max = 200, Callback = function(value) getgenv().CONFIG.Misc.SpeedValue = value end})
MovementTab1:Toggle({Name = "Jump Power", Default = false, Callback = function(value) jumpPowerEnabled = value if value then enableJumpPower() else disableJumpPower() end end})
MovementTab1:Slider({Name = "Jump Power Value", Default = 100, Min = 50, Max = 300, Callback = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end})
MovementTab1:Toggle({Name = "Fly", Default = false, Callback = function(value) if value then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying() else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end end})
MovementTab1:Slider({Name = "Fly Speed", Default = 50, Min = 10, Max = 200, Callback = function(value) flySpeed = value end})
MovementTab1:Toggle({Name = "Noclip", Default = false, Callback = function(value) noclipEnabled = value if value then startNoclip() else stopNoclip() end end})

MovementTab1:Keybind({Name = "Fly Key", Default = Enum.KeyCode.X, Callback = function() local flyState = not flyEnabled if flyState then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying() else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end end})
MovementTab1:Keybind({Name = "Noclip Key", Default = Enum.KeyCode.V, Callback = function() noclipEnabled = not noclipEnabled if noclipEnabled then startNoclip() else stopNoclip() end end})
MovementTab1:Keybind({Name = "Speed Key", Default = Enum.KeyCode.Z, Callback = function() speedEnabled = not speedEnabled if speedEnabled then enableSpeed() else disableSpeed() end end})

MovementTab2:Toggle({Name = "Loop FOV", Default = false, Callback = function(value) loopFOVEnabled = value if value then enableLoopFOV() else disableLoopFOV() end end})
MovementTab2:Toggle({Name = "Hide Head", Default = false, Callback = function(value) getgenv().CONFIG.Misc.HideHeadEnabled = value if value then hideHead() end end})

OtherTab1:Toggle({Name = "Inf Stamina", Default = false, Callback = function(value) getgenv().CONFIG.Misc.InfStaminaEnabled = value if value then enableInfStamina() else disableInfStamina() end end})
OtherTab1:Toggle({Name = "No Fall Damage", Default = false, Callback = function(value) getgenv().CONFIG.Misc.NoFallDmgEnabled = value if value then enableNoFallDmg() else disableNoFallDmg() end end})
OtherTab1:Toggle({Name = "No Fail Lockpick", Default = false, Callback = function(value) if value then enableLockpick() else disableLockpick() end end})
OtherTab1:Toggle({Name = "Instant Prompt", Default = false, Callback = function(value) if value then enableInstantPrompt() else disableInstantPrompt() end end})
OtherTab1:Toggle({Name = "Auto Door", Default = false, Callback = function(value) if value then enableAutoDoor() else disableAutoDoor() end end})

OtherTab2:Toggle({Name = "Enable Safe ESP", Default = false, Callback = function(value) enableSafeESP(value) end})
OtherTab2:Colorpicker({Name = "safe color", Default = Color3.fromRGB(255,215,0), Callback = function(color) updateSafeColor(color) end})

OtherTab2:Keybind({Name = "SafeESP Key", Default = Enum.KeyCode.K, Callback = function() local currentState = not SafeESP.Enabled enableSafeESP(currentState) end})

local VisualTab1, VisualTab2, VisualTab3 = Tabs.Visuals:MultiSection({Tabs = {"ESP Settings", "ESP Features", "Colors"}, Side = "Left", Size = 1})
local VisualTab4, VisualTab5 = Tabs.Visuals:MultiSection({Tabs = {"Rich Shader", "Rich Player"}, Side = "Right", Size = 1})
local VisualTab6, VisualTab7, VisualTab8 = Tabs.Visuals:MultiSection({Tabs = {"Player Chams", "Arms Chams", "Tool Chams"}, Side = "Right", Size = 1})

VisualTab1:Toggle({Name = "Enable ESP", Default = false, Callback = function(value) library.flags.esp_enabled = value end})
VisualTab1:Keybind({Name = "ESP Key", Default = Enum.KeyCode.H, Callback = function() library.flags.esp_enabled = not library.flags.esp_enabled end})
VisualTab1:Toggle({Name = "Team Check", Default = false, Callback = function(value) library.flags.esp_teamcheck = value end})

VisualTab2:Toggle({Name = "Show Health", Default = true, Callback = function(value) library.flags.esp_showhealth = value end})
VisualTab2:Toggle({Name = "Show Distance", Default = true, Callback = function(value) library.flags.esp_showdistance = value end})
VisualTab2:Toggle({Name = "Box Filled", Default = true, Callback = function(value) library.flags.esp_boxfilled = value end})
VisualTab2:Toggle({Name = "Box Outline", Default = true, Callback = function(value) library.flags.esp_boxoutline = value end})
VisualTab2:Slider({Name = "Box Alpha", Default = 3, Min = 0, Max = 10, Callback = function(value) library.flags.esp_boxalpha = value end})

VisualTab3:Colorpicker({Name = "ESP Color", Default = Color3.fromRGB(255, 50, 50), Callback = function(color) library.flags.esp_maincolor = color end})
VisualTab3:Toggle({Name = "Use Whitelist Color", Default = true, Callback = function(value) library.flags.esp_usewhitelistcolor = value end})
VisualTab3:Colorpicker({Name = "Whitelist Color", Default = Color3.fromRGB(50, 255, 50), Callback = function(color) library.flags.esp_whitelistcolor = color end})
VisualTab3:Toggle({Name = "Use Targetlist Color", Default = true, Callback = function(value) library.flags.esp_usetargetlistcolor = value end})
VisualTab3:Colorpicker({Name = "Targetlist Color", Default = Color3.fromRGB(255, 50, 255), Callback = function(color) library.flags.esp_targetlistcolor = color end})

VisualTab4:Toggle({Name = "Rich Shader", Default = false, Callback = function(value)
    richShaderEnabled = value
    if value then
        local colorCorrection=Instance.new("ColorCorrectionEffect")
        colorCorrection.Name="RichShaderEffect"
        colorCorrection.Parent=game:GetService("Lighting")
        colorCorrection.Brightness=richBrightness/100
        colorCorrection.Contrast=richContrast/100
        colorCorrection.Saturation=richSaturation/100
        colorCorrection.TintColor=richColor
    else
        local lighting=game:GetService("Lighting")
        local effect=lighting:FindFirstChild("RichShaderEffect")
        if effect then effect:Destroy() end
    end
end})
VisualTab4:Colorpicker({Name = "Ambient Color", Default = Color3.fromRGB(255,200,150), Callback = function(color) richColor = color end})
VisualTab4:Slider({Name = "Brightness", Default = 20, Min = 0, Max = 100, Callback = function(value) richBrightness = value end})
VisualTab4:Slider({Name = "Contrast", Default = 50, Min = 0, Max = 100, Callback = function(value) richContrast = value end})
VisualTab4:Slider({Name = "Saturation", Default = 150, Min = 0, Max = 200, Callback = function(value) richSaturation = value end})

VisualTab5:Toggle({Name = "Rich Player", Default = false, Callback = function(value) richPlayerEnabled = value if value and LocalPlayer.Character then applyRichPlayer() elseif LocalPlayer.Character then resetRichPlayer() end end})
VisualTab5:Colorpicker({Name = "Player Color", Default = Color3.fromRGB(255,255,255), Callback = function(color) richPlayerColor = color end})
VisualTab5:Slider({Name = "Transparency", Default = 0, Min = 0, Max = 100, Callback = function(value) richPlayerTransparency = value end})

VisualTab6:Toggle({Name = "Enable Player Chams", Default = false, Callback = function(value) ChamsConfig.PlayerChams.Enabled = value if value then enablePlayerChams() else disablePlayerChams() end end})
VisualTab6:Colorpicker({Name = "outer Color", Default = Color3.fromRGB(255,255,255), Callback = function(color) ChamsConfig.PlayerChams.OuterColor = color end})
VisualTab6:Colorpicker({Name = "Inner Color", Default = Color3.fromRGB(0,0,0), Callback = function(color) ChamsConfig.PlayerChams.InnerColor = color end})
VisualTab6:Toggle({Name = "Team Check", Default = false, Callback = function(value) ChamsConfig.PlayerChams.TeamCheck = value end})

VisualTab6:Keybind({Name = "PlayerChams Key", Default = Enum.KeyCode.C, Callback = function() ChamsConfig.PlayerChams.Enabled = not ChamsConfig.PlayerChams.Enabled if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() else disablePlayerChams() end end})

VisualTab7:Toggle({Name = "Enable Arms Chams", Default = false, Callback = function(value) ChamsConfig.ArmChams.Enabled = value if value then applyForcefieldToArms() else removeForcefieldFromArms() end end})
VisualTab7:Slider({Name = "Arms Transparency", Default = 0.5, Min = 0, Max = 1, Callback = function(value) ChamsConfig.ArmChams.Transparency = value end})
VisualTab7:Colorpicker({Name = "Arms Color", Default = Color3.fromRGB(255,255,255), Callback = function(color) ChamsConfig.ArmChams.Color = color end})

VisualTab7:Keybind({Name = "ArmsChams Key", Default = Enum.KeyCode.B, Callback = function() ChamsConfig.ArmChams.Enabled = not ChamsConfig.ArmChams.Enabled if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() else removeForcefieldFromArms() end end})

VisualTab8:Toggle({Name = "Enable Tool Chams", Default = false, Callback = function(value) ChamsConfig.ToolChams.Enabled = value if value then applyForcefieldToTool() else removeForcefieldFromTool() end end})
VisualTab8:Slider({Name = "Tool Transparency", Default = 0.5, Min = 0, Max = 1, Callback = function(value) ChamsConfig.ToolChams.Transparency = value end})
VisualTab8:Colorpicker({Name = "tool Color", Default = Color3.fromRGB(255,255,255), Callback = function(color) ChamsConfig.ToolChams.Color = color end})

VisualTab8:Keybind({Name = "ToolChams Key", Default = Enum.KeyCode.N, Callback = function() ChamsConfig.ToolChams.Enabled = not ChamsConfig.ToolChams.Enabled if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() else removeForcefieldFromTool() end end})

local TracerSection = Tabs.Players:Section({Name = "Bullet Tracers", Side = "Right"})

TracerSection:Toggle({Name = "Players bullet Tracers", Default = false, Callback = function(value) bulletTracersEnabled = value if value then trackGlobalBullets() end end})
TracerSection:Colorpicker({Name = "tracer Color", Default = Color3.fromRGB(255,50,50), Callback = function(color) tracerColor = color end})
TracerSection:Slider({Name = "Tracer Width", Default = 2, Min = 1, Max = 5, Callback = function(value) tracerWidth = value/1 end})
TracerSection:Slider({Name = "Tracer Lifetime", Default = 10, Min = 1, Max = 100, Callback = function(value) tracerLifetime = value/5 end})

Library:Configs(Window)

for index, value in Themes.preset do 
    pcall(function()
        Library:RefreshTheme(index, value)
    end)
end