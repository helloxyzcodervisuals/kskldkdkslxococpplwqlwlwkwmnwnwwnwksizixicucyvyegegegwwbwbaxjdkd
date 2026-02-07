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
--999939293848283848484838383
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
local instantReloadConnections={}
local characterAddedConnection
local hitNotifications={}
local notificationYOffset=5
local MAX_VISIBLE_NOTIFICATIONS=15
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

local minecraftia={
    name="Minecraftia",
    faces={{name="Regular",weight=400,style="normal",assetId=getcustomasset(library.directory.."/fonts/main.ttf")}}
}

if not isfile(library.directory.."/fonts/main_encoded.ttf") then 
    writefile(library.directory.."/fonts/main_encoded.ttf",HttpService:JSONEncode(minecraftia)) 
end
library.flags.esp_targetlistcolor = Color3.fromRGB(50,255,50)
library.flags.esp_targetlistcolor = Color3.fromRGB(255,50,255)
library.font=Font.new(getcustomasset(library.directory.."/fonts/main_encoded.ttf"),Enum.FontWeight.Regular)

local AFont
if getcustomasset then
    local font_data={name="AFont",faces={{name="Regular",weight=400,style="normal",assetId=getcustomasset("a/fonts/main.ttf")or""}}}
    AFont=Font.new(getcustomasset("a/fonts/main_encoded.ttf")or Enum.Font.Gotham,Enum.FontWeight.Regular)
else
    AFont=Enum.Font.Gotham
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
        if getgenv().CONFIG.Ragebot.FriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then continue end
        if getgenv().CONFIG.Ragebot.UseWhitelist and table.find(getgenv().Lists.Whitelist,player.Name) then continue end
        if getgenv().CONFIG.Ragebot.UseTargetList and not table.find(getgenv().Lists.TargetList,player.Name) then continue end
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
    textLabel.FontFace=Font.new("rbxassetid://12187371840")
    textLabel.TextStrokeTransparency=0.5
    textLabel.Text=model.Name
    local distanceLabel=Instance.new("TextLabel")
    distanceLabel.Size=UDim2.new(1,0,0,20)
    distanceLabel.Position=UDim2.new(0,0,0,20)
    distanceLabel.BackgroundTransparency=1
    distanceLabel.TextColor3=Color3.fromRGB(200,200,200)
    distanceLabel.TextSize=12
    distanceLabel.FontFace=Font.new("rbxassetid://12187371840")
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
--[[
local DEFAULT_ESP_COLOR = Color3.fromRGB(255, 50, 50)
local DEFAULT_WHITELIST_COLOR = Color3.fromRGB(50, 255, 50)
local DEFAULT_TARGETLIST_COLOR = Color3.fromRGB(255, 50, 255)

library.flags.esp_maincolor = library.flags.esp_maincolor or DEFAULT_ESP_COLOR
library.flags.esp_whitelistcolor = library.flags.esp_whitelistcolor or DEFAULT_WHITELIST_COLOR
library.flags.esp_targetlistcolor = library.flags.esp_targetlistcolor or DEFAULT_TARGETLIST_COLOR
local function getPlayerColor(player)
    local targetList = getgenv().Lists.TargetList or {}
    local whitelist = getgenv().Lists.Whitelist or {}
    
    if library.flags.esp_usetargetlistcolor and table.find(targetList, player.Name) then
        return library.flags.esp_targetlistcolor
    end
    
    if library.flags.esp_usewhitelistcolor and table.find(whitelist, player.Name) then
        return library.flags.esp_whitelistcolor
    end
    
    return library.flags.esp_maincolor
end

local function createESPBillboard(player)
    if player==LocalPlayer then return end
    if espBillboards[player] and espBillboards[player].Parent then espBillboards[player]:Destroy() end
    local billboard=Instance.new("BillboardGui")
    billboard.Name=player.Name.."_ESP"
    billboard.AlwaysOnTop=true
    billboard.LightInfluence=0
    billboard.Size=UDim2.new(0,200,0,40)
    billboard.StudsOffset=Vector3.new(0,3,0)
    billboard.Adornee=nil
    billboard.Enabled=false
    billboard.MaxDistance=library.flags.esp_maxdistance or 1000
    local frame=Instance.new("Frame")
    frame.Name="Container"
    frame.BackgroundTransparency=1
    frame.Size=UDim2.new(1,0,1,0)
    frame.Parent=billboard
    if Camera then billboard.Parent=Camera end
    espBillboards[player]=billboard
    characterCache[player]=player.Character
    if playerESPConnections[player] then for _,connection in ipairs(playerESPConnections[player]) do connection:Disconnect() end end
    playerESPConnections[player]={}
    local charAddedConnection=player.CharacterAdded:Connect(function(character)
        characterCache[player]=character
        task.wait(1)
        if espBillboards[player] then 
            local humanoid=character:FindFirstChildOfClass("Humanoid")
            local head=character:FindFirstChild("Head")
            if humanoid and head then
                billboard.Adornee=head
                billboard.Enabled=library.flags.esp_enabled
            end
        end
    end)
    local charRemovingConnection=player.CharacterRemoving:Connect(function()
        characterCache[player]=nil
        if espBillboards[player] then espBillboards[player].Enabled=false espBillboards[player].Adornee=nil end
    end)
    table.insert(playerESPConnections[player],charAddedConnection)
    table.insert(playerESPConnections[player],charRemovingConnection)
end

local function updateESPBillboard(player,character)
    if not library.flags.esp_enabled then return end
    local billboard=espBillboards[player]
    if not billboard or not billboard.Parent or not character then if not billboard or not billboard.Parent then createESPBillboard(player) end return end
    if library.flags.esp_teamcheck and LocalPlayer.Team and player.Team and LocalPlayer.Team==player.Team then billboard.Enabled=false billboard.Adornee=nil return end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    local head=character:FindFirstChild("Head")
    local humanoidRootPart=character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not humanoid or not head then billboard.Enabled=false billboard.Adornee=nil return end
    local localCharacter=LocalPlayer.Character
    local localRoot=localCharacter and(localCharacter:FindFirstChild("HumanoidRootPart") or localCharacter:FindFirstChild("Torso") or localCharacter:FindFirstChild("UpperTorso"))
    if not localRoot then billboard.Enabled=false billboard.Adornee=nil return end
    local distance=(head.Position-localRoot.Position).Magnitude
    local maxDistance=library.flags.esp_maxdistance or 1000
    if distance>maxDistance then billboard.Enabled=false billboard.Adornee=nil return end
    billboard.MaxDistance=maxDistance
    billboard.Adornee=head
    billboard.Enabled=true
    local playerColor=getPlayerColor(player)
    local health=math.floor(humanoid.Health)
    local maxHealth=math.floor(humanoid.MaxHealth)
    local healthPercent=maxHealth>0 and math.floor((health/maxHealth)*100) or 0
    local healthColor=Color3.fromRGB(255,255,255)
    if healthPercent>50 then healthColor=Color3.fromRGB(0,255,0) elseif healthPercent>25 then healthColor=Color3.fromRGB(255,255,0) else healthColor=Color3.fromRGB(255,0,0) end
    local baseSize=13
    local textSize=baseSize
    if library.flags.esp_dynamicscaling then
        local distanceFactor=math.clamp(distance/100,0.5,2.0)
        textSize=baseSize/distanceFactor
        textSize=math.max(8,math.min(20,textSize))
    end
    local container=billboard.Container
    for _,child in ipairs(container:GetChildren()) do child:Destroy() end
    local labels={}
    if library.flags.esp_showdistance then
        local distanceLabel=Instance.new("TextLabel")
        distanceLabel.Name="DistanceLabel"
        distanceLabel.Text=" "..math.floor(distance).." "
        distanceLabel.TextColor3=playerColor
        distanceLabel.TextSize=textSize
        distanceLabel.FontFace=library.font
        distanceLabel.BackgroundTransparency=1
        distanceLabel.Size=UDim2.new(0,0,1,0)
        distanceLabel.AutomaticSize=Enum.AutomaticSize.X
        distanceLabel.TextXAlignment=Enum.TextXAlignment.Left
        table.insert(labels,distanceLabel)
    end
    local usernameLabel=Instance.new("TextLabel")
    usernameLabel.Name="UsernameLabel"
    usernameLabel.Text=" "..player.Name.." "
    usernameLabel.TextColor3=playerColor
    usernameLabel.TextSize=textSize
    usernameLabel.FontFace=library.font
    usernameLabel.BackgroundTransparency=1
    usernameLabel.Size=UDim2.new(0,0,1,0)
    usernameLabel.AutomaticSize=Enum.AutomaticSize.X
    usernameLabel.TextXAlignment=Enum.TextXAlignment.Left
    table.insert(labels,usernameLabel)
    if library.flags.esp_showhealth then
        local healthLabel=Instance.new("TextLabel")
        healthLabel.Name="HealthLabel"
        healthLabel.Text="["..health.."]"
        healthLabel.TextColor3=healthColor
        healthLabel.TextSize=textSize
        healthLabel.FontFace=library.font
        healthLabel.BackgroundTransparency=1
        healthLabel.Size=UDim2.new(0,0,1,0)
        healthLabel.AutomaticSize=Enum.AutomaticSize.X
        healthLabel.TextXAlignment=Enum.TextXAlignment.Left
        table.insert(labels,healthLabel)
    end
    local totalWidth=0
    for i,label in ipairs(labels) do
        label.Parent=container
        label.Position=UDim2.new(0,totalWidth,0,0)
        totalWidth=totalWidth+label.AbsoluteSize.X
    end
    billboard.Size=UDim2.new(0,totalWidth+10,0,40)
end

local function onPlayerAdded(player)
    if player==LocalPlayer then return end
    task.spawn(function() task.wait(1) createESPBillboard(player) end)
    if player.Character then characterCache[player]=player.Character end
end

local function onPlayerRemoving(player)
    local billboard=espBillboards[player]
    if billboard and billboard.Parent then billboard:Destroy() end
    espBillboards[player]=nil
    if playerESPConnections[player] then for _,connection in ipairs(playerESPConnections[player]) do connection:Disconnect() end playerESPConnections[player]=nil end
    characterCache[player]=nil
end

task.spawn(function() 
    task.wait(2) 
    for _,player in ipairs(Players:GetPlayers()) do 
        if player~=LocalPlayer then 
            onPlayerAdded(player) 
        end 
    end 
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

LocalPlayer.CharacterRemoving:Connect(function()
    for player,billboard in pairs(espBillboards) do if billboard and billboard.Parent then billboard:Destroy() end end
    espBillboards={}
    characterCache={}
    playerESPConnections={}
    if library.flags.esp_enabled then
        task.wait(2)
        for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then createESPBillboard(player) end end
    end
end)

RunService.RenderStepped:Connect(function()
    if not library.flags.esp_enabled then for player,billboard in pairs(espBillboards) do if billboard and billboard.Parent then billboard.Enabled=false end end return end
    for player,billboard in pairs(espBillboards) do
        local character=characterCache[player] or player.Character
        if character and billboard and billboard.Parent then updateESPBillboard(player,character) elseif billboard and billboard.Parent then billboard.Enabled=false billboard.Adornee=nil else createESPBillboard(player) end
    end
end)
--]]
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
    local targetList=getgenv().Lists.TargetList or {}
    local whitelist=getgenv().Lists.Whitelist or{}
    if ChamsConfig.PlayerChams.UseTargetlistColor and table.find(targetList,player.Name) then return ChamsConfig.PlayerChams.TargetlistColor end
    if ChamsConfig.PlayerChams.UseWhitelistColor and table.find(whitelist,player.Name) then return ChamsConfig.PlayerChams.WhitelistColor end
    return ChamsConfig.PlayerChams.OuterColor
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
            local bloomEffect=Instance.new("BloomEffect")
            bloomEffect.Name="ESPGlow"
            bloomEffect.Parent=innerBox
            bloomEffect.Intensity=99
            bloomEffect.Size=24
            bloomEffect.Threshold=98
            table.insert(boxes,{outer=outerBox,inner=innerBox,part=originalPart,bloom=bloomEffect,player=player})
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
                    if boxData.inner and boxData.inner.Parent then boxData.inner.Color3=ChamsConfig.PlayerChams.InnerColor end
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
                for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end
                espParts[character]=nil
            end
        else for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end espParts[character]=nil end
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
        if espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end espParts[character]=nil end
    end)
    table.insert(playerConnections[player],conn1)
    table.insert(playerConnections[player],conn2)
    table.insert(connections,conn1)
    table.insert(connections,conn2)
end

local function onPlayerChamsRemoving(player)
    if playerConnections[player] then for _,connection in ipairs(playerConnections[player]) do connection:Disconnect() end playerConnections[player]=nil end
    local character=player.Character
    if character and espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end espParts[character]=nil end
end

local function cleanupPlayerChams()
    for character,boxes in pairs(espParts) do for _,boxData in ipairs(boxes) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end end
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
    if espParts[character] then for _,boxData in ipairs(espParts[character]) do boxData.outer:Destroy() boxData.inner:Destroy() if boxData.bloom then boxData.bloom:Destroy() end end espParts[character]=nil end
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

local CFG_DIR = "gamesense/configs"

if not isfolder("gamesense") then makefolder("gamesense") end
if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end

local function cfgPath(name)
    if type(name) ~= "string" then return nil end
    name = name:gsub("[/\\]", "_")
    return CFG_DIR .. "/" .. name .. ".json"
end

local function randomName()
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local t = {}
    for i = 1, 8 do
        t[i] = charset:sub(math.random(1, #charset), math.random(1, #charset))
    end
    return table.concat(t)
end

local Config = { selected = nil }

local function cfgList()
    local t = {}
    for _, f in ipairs(listfiles(CFG_DIR)) do
        if f:sub(-5) == ".json" then
            local name = f:match("([^/\\]+)%.json$")
            if name then t[#t+1] = name end
        end
    end
    table.sort(t)
    return t
end

function Config:save(name)
    if type(name) ~= "string" or #name == 0 then return end
    local data = {}
    for k,v in pairs(library.flags) do
        if type(v) ~= "function" then data[k] = v end
    end
    local path = cfgPath(name)
    if path then writefile(path, HttpService:JSONEncode(data)) end
end

function Config:load(name)
    if type(name) ~= "string" or #name == 0 then return end
    local path = cfgPath(name)
    if not path or not isfile(path) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return end
    for k,v in pairs(data) do
        local flag = library.flags[k]
        if type(flag) == "function" then
            pcall(flag, v)
        elseif flag ~= nil then
            library.flags[k] = v
        end
    end
end

function Config:delete(name)
    if type(name) ~= "string" or #name == 0 then return end
    local path = cfgPath(name)
    if path and isfile(path) then delfile(path) end
end

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
--[[
local RagebotTab = Window:AddTab("Ragebot")
local LegitTab = Window:AddTab("Legit")
local VisualTab = Window:AddTab("Visual")
local MiscTab = Window:AddTab("Misc")
local PlayersTab = Window:AddTab("Players")
--local ConfigTab = Window:AddTab("Config")

local RagebotMainGroup = RagebotTab:AddGroupbox("left", "Ragebot Main")
local TargetingGroup = RagebotTab:AddGroupbox("right", "Targeting")
local AimGroup = RagebotTab:AddGroupbox("left", "Aim Settings")
local VisualsGroup = RagebotTab:AddGroupbox("right", "Tracers")
local ColorsGroup = RagebotTab:AddGroupbox("left", "Notifications")

RagebotMainGroup:AddToggle("ragebot_enabled", {
    Text = "Enable Ragebot",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.Enabled = value
    end
})

RagebotMainGroup:AddToggle("ragebot_rapidfire", {
    Text = "Rapid Fire",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.RapidFire = value
    end
})

RagebotMainGroup:AddToggle("ragebot_hitsound", {
    Text = "Hit Sound",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.HitSound = value
    end
})

RagebotMainGroup:AddToggle("ragebot_autoreload", {
    Text = "Auto Reload",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.AutoReload = value
    end
})

RagebotMainGroup:AddSlider("ragebot_firerate", {
    Text = "Fire Rate",
    Default = 30,
    Min = 1,
    Max = 1000,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.FireRate = value
    end
})

RagebotMainGroup:AddSlider("ragebot_shootrange", {
    Text = "Shoot Range",
    Default = 15,
    Min = 1,
    Max = 30,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.ShootRange = value
    end
})

RagebotMainGroup:AddSlider("ragebot_hitrange", {
    Text = "Hit Range",
    Default = 15,
    Min = 1,
    Max = 30,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.HitRange = value
    end
})

RagebotMainGroup:AddListBox("ragebot_hitsoundlist", {
    Text = "Hit Sound",
    Values = {"Bameware","Bell","Bubble","Pick","Pop","Rust","Sans","Fart","Big","Vine","Bruh","Skeet","Neverlose","Fatality","Bonk","Minecraft"},
    Default = "Skeet",
    Callback = function(value)
        getgenv().CONFIG.Ragebot.SelectedHitSound = value
    end
})

TargetingGroup:AddToggle("ragebot_teamcheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.TeamCheck = value
    end
})

TargetingGroup:AddToggle("ragebot_visibilitycheck", {
    Text = "Visibility Check",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.VisibilityCheck = value
    end
})

TargetingGroup:AddToggle("ragebot_wallbang", {
    Text = "Wallbang",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.Wallbang = value
    end
})

TargetingGroup:AddToggle("ragebot_downcheck", {
    Text = "Downed Check",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.LowHealthCheck = value
    end
})

TargetingGroup:AddToggle("ragebot_friendcheck", {
    Text = "Friend Check",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.FriendCheck = value
    end
})

AimGroup:AddToggle("ragebot_prediction", {
    Text = "Prediction",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.Prediction = value
    end
})

AimGroup:AddSlider("ragebot_predictionamount", {
    Text = "Prediction Amount",
    Default = 0.12,
    Min = 0.05,
    Max = 0.3,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.PredictionAmount = value
    end
})

VisualsGroup:AddToggle("ragebot_tracers", {
    Text = "Tracers",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.Tracers = value
    end
})

VisualsGroup:AddColorPicker("ragebot_tracercolor", {
    Text = "Tracer Color",
    Default = Color3.fromRGB(255,0,0),
    Callback = function(color)
        getgenv().CONFIG.Ragebot.TracerColor = color
    end
})

VisualsGroup:AddSlider("ragebot_tracerwidth", {
    Text = "Tracer Width",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.TracerWidth = value
    end
})

VisualsGroup:AddSlider("ragebot_tracerlife", {
    Text = "Tracer Lifetime",
    Default = 3,
    Min = 0.5,
    Max = 100,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.TracerLifetime = value
    end
})

ColorsGroup:AddToggle("ragebot_hitnotify", {
    Text = "Hit Notify",
    Default = true,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.HitNotify = value
    end
})

ColorsGroup:AddColorPicker("ragebot_hitcolor", {
    Text = "hit notification color",
    Default = Color3.fromRGB(255,182,193),
    Callback = function(color)
        getgenv().CONFIG.Ragebot.HitColor = color
    end
})

ColorsGroup:AddSlider("ragebot_hitduration", {
    Text = "Hit Notify Duration",
    Default = 5,
    Min = 1,
    Max = 10,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.HitNotifyDuration = value
    end
})

local LegitGroup = LegitTab:AddGroupbox("left", "Legit Settings", 1)

LegitGroup:AddToggle("legit_enable", {
    Text = "Enable",
    Default = false,
    Callback = function(value)
        getgenv().Legit.Enabled = value
    end
})

LegitGroup:AddSlider("legit_headchance", {
    Text = "Head Chance",
    Default = 30,
    Min = 0,
    Max = 100,
    Callback = function(value)
        getgenv().Legit.HeadChance = value
    end
})

LegitGroup:AddListBox("legit_hitpart", {
    Text = "Hit Part",
    Values = {"Head","Torso","Neck","Random"},
    Default = "Torso",
    Callback = function(value)
        getgenv().Legit.HitPart = value
    end
})

LegitGroup:AddToggle("legit_norecoil", {
    Text = "No Recoil",
    Default = true,
    Callback = function(value)
        getgenv().Legit.NoRecoil = value
        apply_no_recoil()
    end
})

LegitGroup:AddToggle("legit_aimassist", {
    Text = "Aim Assist",
    Default = false,
    Callback = function(value)
        getgenv().Legit.AimAssist = value
    end
})

LegitGroup:AddSlider("legit_assiststrength", {
    Text = "Assist Strength",
    Default = 0.3,
    Min = 0.1,
    Max = 1.0,
    Callback = function(value)
        getgenv().Legit.AimAssistStrength = value
    end
})

LegitGroup:AddSlider("legit_smoothing", {
    Text = "Smoothing",
    Default = 0.2,
    Min = 0.1,
    Max = 0.8,
    Callback = function(value)
        getgenv().Legit.Smoothing = value
    end
})

local MovementGroup = MiscTab:AddGroupbox("left", "Movement")
local VisualMiscGroup = MiscTab:AddGroupbox("right", "Visual")
local OtherGroup = MiscTab:AddGroupbox("left", "Other")
local SafeESPMiscGroup = MiscTab:AddGroupbox("right", "Safe ESP")

MovementGroup:AddToggle("misc_speed", {
    Text = "Speed",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        if value then enableSpeed() else disableSpeed() end
    end
})

MovementGroup:AddSlider("misc_speedvalue", {
    Text = "Speed Value",
    Default = 50,
    Min = 10,
    Max = 200,
    Callback = function(value)
        getgenv().CONFIG.Misc.SpeedValue = value
    end
})

MovementGroup:AddToggle("misc_jumppower", {
    Text = "Jump Power",
    Default = false,
    Callback = function(value)
        jumpPowerEnabled = value
        if value then enableJumpPower() else disableJumpPower() end
    end
})

MovementGroup:AddSlider("misc_jumpvalue", {
    Text = "Jump Power Value",
    Default = 100,
    Min = 50,
    Max = 300,
    Callback = function(value)
        getgenv().CONFIG.Misc.JumpPowerValue = value
    end
})

MovementGroup:AddToggle("misc_fly", {
    Text = "Fly",
    Default = false,
    Callback = function(value)
        if value then 
            QuickUIText.Text="FLY ON" 
            QuickUIText.TextColor3=Color3.fromRGB(50,255,50) 
            startFlying()
        else 
            QuickUIText.Text="FLY OFF" 
            QuickUIText.TextColor3=Color3.fromRGB(255,50,50) 
            disableFlying() 
        end
    end
})

MovementGroup:AddSlider("misc_flyspeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Callback = function(value)
        flySpeed = value
    end
})

MovementGroup:AddToggle("noclip_enabled", {
    Text = "Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        if value then startNoclip() else stopNoclip() end
    end
})

VisualMiscGroup:AddToggle("misc_loopfov", {
    Text = "Loop FOV",
    Default = false,
    Callback = function(value)
        loopFOVEnabled = value
        if value then enableLoopFOV() else disableLoopFOV() end
    end
})

VisualMiscGroup:AddToggle("misc_hidehead", {
    Text = "Hide Head",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Misc.HideHeadEnabled = value
        if value then hideHead() end
    end
})

OtherGroup:AddToggle("misc_infstamina", {
    Text = "Inf Stamina",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Misc.InfStaminaEnabled = value
        if value then enableInfStamina() else disableInfStamina() end
    end
})

OtherGroup:AddToggle("misc_nofall", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Misc.NoFallDmgEnabled = value
        if value then enableNoFallDmg() else disableNoFallDmg() end
    end
})

OtherGroup:AddToggle("misc_lockpick", {
    Text = "No Fail Lockpick",
    Default = false,
    Callback = function(value)
        if value then enableLockpick() else disableLockpick() end
    end
})

OtherGroup:AddToggle("misc_instantprompt", {
    Text = "Instant Prompt",
    Default = false,
    Callback = function(value)
        if value then enableInstantPrompt() else disableInstantPrompt() end
    end
})

OtherGroup:AddToggle("misc_autodoor", {
    Text = "Auto Door",
    Default = false,
    Callback = function(value)
        if value then enableAutoDoor() else disableAutoDoor() end
    end
})

SafeESPMiscGroup:AddToggle("misc_safeesp", {
    Text = "Enable Safe ESP",
    Default = false,
    Callback = function(value)
        enableSafeESP(value)
    end
})

SafeESPMiscGroup:AddColorPicker("misc_safecolor", {
    Text = "safe color",
    Default = Color3.fromRGB(255,215,0),
    Callback = function(color)
        updateSafeColor(color)
    end
})
--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local library = {
    flags = {
        esp_enabled = true,
        esp_maincolor = Color3.fromRGB(255, 50, 50),
        esp_usewhitelistcolor = true,
        esp_usetargetlistcolor = true,
        esp_whitelistcolor = Color3.fromRGB(50, 255, 50),
        esp_targetlistcolor = Color3.fromRGB(255, 50, 255),
        esp_teamcheck = false,
        esp_showhealth = true,
        esp_showdistance = true,
        esp_boxfilled = true,
        esp_boxoutline = true,
        esp_boxalpha = 0.3
    }
}

local fonts = {}
do
    local HttpService = game:GetService("HttpService")
    
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
        writefile(Name .. ".font", HttpService:JSONEncode(Data))
        return getcustomasset(Name .. ".font")
    end
    
    local ProggyTiny = Register_Font("adwdawdwadadwadawdawdawdawd", 100, "Normal", {
        Id = "ProggyTinyyyy.ttf",
        Font = game:HttpGet("https://raw.githubusercontent.com/i77lhm/storage/refs/heads/main/fonts/ProggyClean.ttf"),
    })

    fonts.main = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function getPlayerColor(player)
    local targetList = getgenv().Lists.TargetList or {}
    local whitelist = getgenv().Lists.Whitelist or {}
    
    if library.flags.esp_usetargetlistcolor and table.find(targetList, player.Name) then
        return library.flags.esp_targetlistcolor
    end
    
    if library.flags.esp_usewhitelistcolor and table.find(whitelist, player.Name) then
        return library.flags.esp_whitelistcolor
    end
    
    return library.flags.esp_maincolor
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Skeet_2D_ESP"
ScreenGui.IgnoreGuiInset = true

local espDrawings = {}
local espUIs = {}
local playerConnections = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local drawings = {
       -- box_out = Drawing.new("Square"),
        box = Drawing.new("Square"),
        box_fill = Drawing.new("Square")
    }
    
    local uis = {
        health_bg = Instance.new("Frame", ScreenGui),
        health_fill = Instance.new("Frame"),
        name_text = Instance.new("TextLabel", ScreenGui),
        info_text = Instance.new("TextLabel", ScreenGui)
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

--    drawings.box_out.Transparency = 1
--    drawings.box_out.Filled = false
--    drawings.box_out.Thickness = 3
    
    drawings.box.Transparency = 1
    drawings.box.Filled = false
    drawings.box.Thickness = 1
    
    drawings.box_fill.Transparency = 1
    drawings.box_fill.Filled = true
    drawings.box_fill.Thickness = 0

    local function setupText(textLabel)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.FontFace = fonts.main
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
        if not library.flags.esp_enabled then
           -- drawings.box_out.Visible = false
            drawings.box.Visible = false
            drawings.box_fill.Visible = false
            uis.health_bg.Visible = false
            uis.name_text.Visible = false
            uis.info_text.Visible = false
            return
        end
        
        if library.flags.esp_teamcheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
            --drawings.box_out.Visible = false
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

                
                
                
                
                if library.flags.esp_boxfilled then
                    drawings.box_fill.Filled = true
                    drawings.box_fill.Position = Vector2.new(x, y)
                    drawings.box_fill.Size = Vector2.new(size_x, size_y)
                    drawings.box_fill.Color = playerColor
                    drawings.box_fill.Transparency = 1 - boxAlpha
                else
                    drawings.box_fill.Filled = false
                end
                
                drawings.box.Visible = true
                drawings.box.Position = Vector2.new(x, y)
                drawings.box.Size = Vector2.new(size_x, size_y)
                drawings.box.Color = playerColor
                drawings.box.Transparency = 1 - boxAlpha

                if library.flags.esp_showhealth then
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

                if library.flags.esp_showdistance then
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
--                drawings.box_out.Visible = false
                drawings.box.Visible = false
                drawings.box_fill.Visible = false
                uis.health_bg.Visible = false
                uis.name_text.Visible = false
                uis.info_text.Visible = false
            end
        else
  --          drawings.box_out.Visible = false
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
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

LocalPlayer.CharacterRemoving:Connect(function()
    for player in pairs(espDrawings) do
        removeESP(player)
    end
end)

local ESPGroup = VisualTab:AddGroupbox("left", "ESP Settings", 1)
local ESPSettingsGroup = VisualTab:AddGroupbox("right", "ESP Features", 1)

ESPGroup:AddToggle("esp_enabled", {
    Text = "Enable ESP",
    Default = true,
    Callback = function(value)
        library.flags.esp_enabled = value
    end
})

ESPGroup:AddKeybind("esp_keybind", {
    Text = "ESP Key",
    Default = Enum.KeyCode.H,
    Callback = function()
        library.flags.esp_enabled = not library.flags.esp_enabled
        Zenwave.Options.esp_enabled:Set(library.flags.esp_enabled)
    end
})

ESPGroup:AddColorPicker("esp_maincolor", {
    Text = "ESP Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        library.flags.esp_maincolor = color
    end
})

ESPGroup:AddToggle("esp_teamcheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(value)
        library.flags.esp_teamcheck = value
    end
})

ESPGroup:AddToggle("esp_usewhitelistcolor", {
    Text = "Use Whitelist Color",
    Default = true,
    Callback = function(value)
        library.flags.esp_usewhitelistcolor = value
    end
})

ESPGroup:AddColorPicker("esp_whitelistcolor", {
    Text = "Whitelist Color",
    Default = Color3.fromRGB(50, 255, 50),
    Callback = function(color)
        library.flags.esp_whitelistcolor = color
    end
})

ESPGroup:AddToggle("esp_usetargetlistcolor", {
    Text = "Use Targetlist Color",
    Default = true,
    Callback = function(value)
        library.flags.esp_usetargetlistcolor = value
    end
})

ESPGroup:AddColorPicker("esp_targetlistcolor", {
    Text = "Targetlist Color",
    Default = Color3.fromRGB(255, 50, 255),
    Callback = function(color)
        library.flags.esp_targetlistcolor = color
    end
})

ESPSettingsGroup:AddToggle("esp_showhealth", {
    Text = "Show Health",
    Default = true,
    Callback = function(value)
        library.flags.esp_showhealth = value
    end
})

ESPSettingsGroup:AddToggle("esp_showdistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(value)
        library.flags.esp_showdistance = value
    end
})

ESPSettingsGroup:AddToggle("esp_boxfilled", {
    Text = "Box Filled",
    Default = true,
    Callback = function(value)
        library.flags.esp_boxfilled = value
    end
})

ESPSettingsGroup:AddToggle("esp_boxoutline", {
    Text = "Box Outline",
    Default = true,
    Callback = function(value)
        library.flags.esp_boxoutline = value
    end
})

ESPSettingsGroup:AddSlider("esp_boxalpha", {
    Text = "Box Alpha",
    Default = 1,
    Min = 0,
    Max = 10,
    Callback = function(value)
        library.flags.esp_boxalpha = value
    end
})
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local library = {
    flags = {
        esp_enabled = true,
        esp_maincolor = Color3.fromRGB(255, 50, 50),
        esp_usewhitelistcolor = true,
        esp_usetargetlistcolor = true,
        esp_whitelistcolor = Color3.fromRGB(50, 255, 50),
        esp_targetlistcolor = Color3.fromRGB(255, 50, 255),
        esp_teamcheck = false,
        esp_showhealth = true,
        esp_showdistance = true,
        esp_boxfilled = true,
        esp_boxoutline = true,
        esp_boxalpha = 3
    }
}

local fonts = {}
do
    local HttpService = game:GetService("HttpService")
    
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
        writefile(Name .. ".font", HttpService:JSONEncode(Data))
        return getcustomasset(Name .. ".font")
    end
    
    local ProggyTiny = Register_Font("adwdawdwadadwadawdawdawdawd", 100, "Normal", {
        Id = "ProggyTinyyyy.ttf",
        Font = game:HttpGet("https://raw.githubusercontent.com/i77lhm/storage/refs/heads/main/fonts/ProggyClean.ttf"),
    })

    fonts.main = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function getPlayerColor(player)
    local targetList = getgenv().Lists.TargetList or {}
    local whitelist = getgenv().Lists.Whitelist or {}
    
    if library.flags.esp_usetargetlistcolor and table.find(targetList, player.Name) then
        return library.flags.esp_targetlistcolor
    end
    
    if library.flags.esp_usewhitelistcolor and table.find(whitelist, player.Name) then
        return library.flags.esp_whitelistcolor
    end
    
    return library.flags.esp_maincolor
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Skeet_2D_ESP"
ScreenGui.IgnoreGuiInset = true

local espDrawings = {}
local espUIs = {}
local playerConnections = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local drawings = {
        box_out = Drawing.new("Square"),
        box = Drawing.new("Square"),
        box_fill = Drawing.new("Square")
    }
    
    local uis = {
        health_bg = Instance.new("Frame", ScreenGui),
        health_fill = Instance.new("Frame"),
        name_text = Instance.new("TextLabel", ScreenGui),
        info_text = Instance.new("TextLabel", ScreenGui)
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

    drawings.box_out.Transparency = 1
    drawings.box_out.Filled = false
    drawings.box_out.Thickness = 3
    
    drawings.box.Transparency = 1
    drawings.box.Filled = false
    drawings.box.Thickness = 1
    
    drawings.box_fill.Transparency = 1
    drawings.box_fill.Filled = true
    drawings.box_fill.Thickness = 0

    local function setupText(textLabel)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.FontFace = fonts.main
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
        if not library.flags.esp_enabled then
            drawings.box_out.Visible = false
            drawings.box.Visible = false
            drawings.box_fill.Visible = false
            uis.health_bg.Visible = false
            uis.name_text.Visible = false
            uis.info_text.Visible = false
            return
        end
        
        if library.flags.esp_teamcheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
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

                local boxAlpha = (library.flags.esp_boxalpha or 3) / 10
                
                if library.flags.esp_boxoutline then
                    drawings.box_out.Visible = true
                    drawings.box_out.Position = Vector2.new(x, y)
                    drawings.box_out.Size = Vector2.new(size_x, size_y)
                    drawings.box_out.Color = Color3.new(0, 0, 0)
                    drawings.box_out.Transparency = 1 - boxAlpha
                else
                    drawings.box_out.Visible = false
                end
                
                if library.flags.esp_boxfilled then
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

                if library.flags.esp_showhealth then
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

                if library.flags.esp_showdistance then
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
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

LocalPlayer.CharacterRemoving:Connect(function()
    for player in pairs(espDrawings) do
        removeESP(player)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if library.flags.esp_enabled then
        task.wait(1)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not espDrawings[player] then
                createESP(player)
            end
        end
    end
end)
local Library, Notifications, Themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/i77lhm/Libraries/refs/heads/main/Bbot/Library.lua"))()

local Window = Library:Window({name = "skcc.lua"})
local Tabs = {Combat = Window:Tab({Name = "Combat"}), Visuals = Window:Tab({Name = "Visuals"}), Players = Window:Tab({Name = "Players"}), Misc = Window:Tab({Name = "Misc"})}
local RagebotTab,RagebotMainGroup,TargetingGroup,AimGroup,VisualsGroup,ColorsGroup = Tabs.Combat,Tabs.Combat:Section({Name = "Ragebot Main", Side = "Left"}),Tabs.Combat:Section({Name = "Targeting", Side = "Right"}),Tabs.Combat:Section({Name = "Aim Settings", Side = "Left"}),Tabs.Combat:Section({Name = "Tracers", Side = "Right"}),Tabs.Combat:Section({Name = "Notifications", Side = "Left"})
local RagebotToggle = RagebotMainGroup:Toggle({Name = "Enable Ragebot", Flag = "ragebot_enabled", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.Enabled = s end})
RagebotToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.F, Callback = function(k,f) if not f then getgenv().CONFIG.Ragebot.Enabled = not getgenv().CONFIG.Ragebot.Enabled end end, ShowInList = true})
RagebotMainGroup:Toggle({Name = "Rapid Fire", Flag = "ragebot_rapidfire", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.RapidFire = s end})
RagebotMainGroup:Toggle({Name = "Hit Sound", Flag = "ragebot_hitsound", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.HitSound = s end})
RagebotMainGroup:Toggle({Name = "Auto Reload", Flag = "ragebot_autoreload", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.AutoReload = s end})
RagebotMainGroup:Slider({Name = "Fire Rate", Flag = "ragebot_firerate", Min = 1, Max = 1000, Default = 30, Callback = function(v) getgenv().CONFIG.Ragebot.FireRate = v end})
RagebotMainGroup:Slider({Name = "Shoot Range", Flag = "ragebot_shootrange", Min = 1, Max = 30, Default = 15, Callback = function(v) getgenv().CONFIG.Ragebot.ShootRange = v end})
RagebotMainGroup:Slider({Name = "Hit Range", Flag = "ragebot_hitrange", Min = 1, Max = 30, Default = 15, Callback = function(v) getgenv().CONFIG.Ragebot.HitRange = v end})
RagebotMainGroup:Dropdown({Name = "Hit Sound", Flag = "ragebot_hitsoundlist", Options = {"Bameware","Bell","Bubble","Pick","Pop","Rust","Sans","Fart","Big","Vine","Bruh","Skeet","Neverlose","Fatality","Bonk","Minecraft"}, Default = "Skeet", Callback = function(v) getgenv().CONFIG.Ragebot.SelectedHitSound = v end})
TargetingGroup:Toggle({Name = "Team Check", Flag = "ragebot_teamcheck", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.TeamCheck = s end})
TargetingGroup:Toggle({Name = "Visibility Check", Flag = "ragebot_visibilitycheck", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.VisibilityCheck = s end})
TargetingGroup:Toggle({Name = "Wallbang", Flag = "ragebot_wallbang", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.Wallbang = s end})
TargetingGroup:Toggle({Name = "Downed Check", Flag = "ragebot_downcheck", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.LowHealthCheck = s end})
TargetingGroup:Toggle({Name = "Friend Check", Flag = "ragebot_friendcheck", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.FriendCheck = s end})
AimGroup:Toggle({Name = "Prediction", Flag = "ragebot_prediction", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.Prediction = s end})
AimGroup:Slider({Name = "Prediction Amount", Flag = "ragebot_predictionamount", Min = 0.05, Max = 0.3, Default = 0.12, Callback = function(v) getgenv().CONFIG.Ragebot.PredictionAmount = v end})
local TracersToggle = VisualsGroup:Toggle({Name = "Tracers", Flag = "ragebot_tracers", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.Tracers = s end})
TracersToggle:Colorpicker({Name = "Tracer Color", Flag = "ragebot_tracercolor", Default = Color3.fromRGB(255,0,0), Callback = function(c) getgenv().CONFIG.Ragebot.TracerColor = c end})
VisualsGroup:Slider({Name = "Tracer Width", Flag = "ragebot_tracerwidth", Min = 0.1, Max = 5, Default = 1, Callback = function(v) getgenv().CONFIG.Ragebot.TracerWidth = v end})
VisualsGroup:Slider({Name = "Tracer Lifetime", Flag = "ragebot_tracerlife", Min = 0.5, Max = 100, Default = 3, Callback = function(v) getgenv().CONFIG.Ragebot.TracerLifetime = v end})
local HitNotifyToggle = ColorsGroup:Toggle({Name = "Hit Notify", Flag = "ragebot_hitnotify", Default = true, Callback = function(s) getgenv().CONFIG.Ragebot.HitNotify = s end})
HitNotifyToggle:Colorpicker({Name = "hit notification color", Flag = "ragebot_hitcolor", Default = Color3.fromRGB(255,182,193), Callback = function(c) getgenv().CONFIG.Ragebot.HitColor = c end})
ColorsGroup:Slider({Name = "Hit Notify Duration", Flag = "ragebot_hitduration", Min = 1, Max = 10, Default = 5, Callback = function(v) getgenv().CONFIG.Ragebot.HitNotifyDuration = v end})
local LegitTab,LegitGroup = Tabs.Combat,Tabs.Combat:Section({Name = "Legit Settings", Side = "Left"})
local LegitToggle = LegitGroup:Toggle({Name = "Enable", Flag = "legit_enable", Default = false, Callback = function(s) getgenv().Legit.Enabled = s end})
LegitToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.G, Callback = function(k,f) if not f then getgenv().Legit.Enabled = not getgenv().Legit.Enabled end end, ShowInList = true})
LegitGroup:Slider({Name = "Head Chance", Flag = "legit_headchance", Min = 0, Max = 100, Default = 30, Callback = function(v) getgenv().Legit.HeadChance = v end})
LegitGroup:Dropdown({Name = "Hit Part", Flag = "legit_hitpart", Options = {"Head","Torso","Neck","Random"}, Default = "Torso", Callback = function(v) getgenv().Legit.HitPart = v end})
LegitGroup:Toggle({Name = "No Recoil", Flag = "legit_norecoil", Default = true, Callback = function(s) getgenv().Legit.NoRecoil = s apply_no_recoil() end})
LegitGroup:Toggle({Name = "Aim Assist", Flag = "legit_aimassist", Default = false, Callback = function(s) getgenv().Legit.AimAssist = s end})
LegitGroup:Slider({Name = "Assist Strength", Flag = "legit_assiststrength", Min = 0.1, Max = 1.0, Default = 0.3, Callback = function(v) getgenv().Legit.AimAssistStrength = v end})
LegitGroup:Slider({Name = "Smoothing", Flag = "legit_smoothing", Min = 0.1, Max = 0.8, Default = 0.2, Callback = function(v) getgenv().Legit.Smoothing = v end})
local MovementGroup,VisualMiscGroup,OtherGroup,SafeESPMiscGroup = MiscTab:Section({Name = "Movement", Side = "Left"}),MiscTab:Section({Name = "Visual", Side = "Right"}),MiscTab:Section({Name = "Other", Side = "Left"}),MiscTab:Section({Name = "Safe ESP", Side = "Right"})
local SpeedToggle = MovementGroup:Toggle({Name = "Speed", Flag = "misc_speed", Default = false, Callback = function(s) speedEnabled = s if s then enableSpeed() else disableSpeed() end end})
SpeedToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.Z, Callback = function(k,f) if not f then speedEnabled = not speedEnabled if speedEnabled then enableSpeed() else disableSpeed() end end end, ShowInList = true})
MovementGroup:Slider({Name = "Speed Value", Flag = "misc_speedvalue", Min = 10, Max = 200, Default = 50, Callback = function(v) getgenv().CONFIG.Misc.SpeedValue = v end})
local JumpPowerToggle = MovementGroup:Toggle({Name = "Jump Power", Flag = "misc_jumppower", Default = false, Callback = function(s) jumpPowerEnabled = s if s then enableJumpPower() else disableJumpPower() end end})
MovementGroup:Slider({Name = "Jump Power Value", Flag = "misc_jumpvalue", Min = 50, Max = 300, Default = 100, Callback = function(v) getgenv().CONFIG.Misc.JumpPowerValue = v end})
local FlyToggle = MovementGroup:Toggle({Name = "Fly", Flag = "misc_fly", Default = false, Callback = function(s) if s then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying() else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end end})
FlyToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.X, Callback = function(k,f) if not f then local fs = not flyEnabled if fs then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying() else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end end end, ShowInList = true})
MovementGroup:Slider({Name = "Fly Speed", Flag = "misc_flyspeed", Min = 10, Max = 200, Default = 50, Callback = function(v) flySpeed = v end})
local NoclipToggle = MovementGroup:Toggle({Name = "Noclip", Flag = "noclip_enabled", Default = false, Callback = function(s) noclipEnabled = s if s then startNoclip() else stopNoclip() end end})
NoclipToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.V, Callback = function(k,f) if not f then noclipEnabled = not noclipEnabled if noclipEnabled then startNoclip() else stopNoclip() end end end, ShowInList = true})
VisualMiscGroup:Toggle({Name = "Loop FOV", Flag = "misc_loopfov", Default = false, Callback = function(s) loopFOVEnabled = s if s then enableLoopFOV() else disableLoopFOV() end end})
VisualMiscGroup:Toggle({Name = "Hide Head", Flag = "misc_hidehead", Default = false, Callback = function(s) getgenv().CONFIG.Misc.HideHeadEnabled = s if s then hideHead() end end})
OtherGroup:Toggle({Name = "Inf Stamina", Flag = "misc_infstamina", Default = false, Callback = function(s) getgenv().CONFIG.Misc.InfStaminaEnabled = s if s then enableInfStamina() else disableInfStamina() end end})
OtherGroup:Toggle({Name = "No Fall Damage", Flag = "misc_nofall", Default = false, Callback = function(s) getgenv().CONFIG.Misc.NoFallDmgEnabled = s if s then enableNoFallDmg() else disableNoFallDmg() end end})
OtherGroup:Toggle({Name = "No Fail Lockpick", Flag = "misc_lockpick", Default = false, Callback = function(s) if s then enableLockpick() else disableLockpick() end end})
OtherGroup:Toggle({Name = "Instant Prompt", Flag = "misc_instantprompt", Default = false, Callback = function(s) if s then enableInstantPrompt() else disableInstantPrompt() end end})
OtherGroup:Toggle({Name = "Auto Door", Flag = "misc_autodoor", Default = false, Callback = function(s) if s then enableAutoDoor() else disableAutoDoor() end end})
local SafeESPToggle = SafeESPMiscGroup:Toggle({Name = "Enable Safe ESP", Flag = "misc_safeesp", Default = false, Callback = function(s) enableSafeESP(s) end})
SafeESPToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.K, Callback = function(k,f) if not f then local cs = not SafeESP.Enabled enableSafeESP(cs) end end, ShowInList = true})
SafeESPToggle:Colorpicker({Name = "safe color", Flag = "misc_safecolor", Default = Color3.fromRGB(255,215,0), Callback = function(c) updateSafeColor(c) end})
local ESPGroup,ESPSettingsGroup,RichShaderGroup,RichPlayerGroup,PlayerChamsGroup,ArmsChamsGroup,ToolChamsGroup = VisualTab:Section({Name = "ESP Settings", Side = "Left"}),VisualTab:Section({Name = "ESP Features", Side = "Right"}),VisualTab:Section({Name = "Rich Shader", Side = "Left"}),VisualTab:Section({Name = "Rich Player", Side = "Right"}),VisualTab:Section({Name = "Player Chams", Side = "Left"}),VisualTab:Section({Name = "Arms Chams", Side = "Right"}),VisualTab:Section({Name = "Tool Chams", Side = "Left"})
local ESPToggle = ESPGroup:Toggle({Name = "Enable ESP", Flag = "esp_enabled", Default = true, Callback = function(s) library.flags.esp_enabled = s end})
ESPToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.H, Callback = function(k,f) if not f then library.flags.esp_enabled = not library.flags.esp_enabled end end, ShowInList = true})
local MainColorToggle = ESPGroup:Toggle({Name = "ESP Color", Flag = "esp_maincolor", Default = Color3.fromRGB(255, 50, 50), Callback = function(c) library.flags.esp_maincolor = c end})
ESPGroup:Toggle({Name = "Team Check", Flag = "esp_teamcheck", Default = false, Callback = function(s) library.flags.esp_teamcheck = s end})
local UseWhitelistColorToggle = ESPGroup:Toggle({Name = "Use Whitelist Color", Flag = "esp_usewhitelistcolor", Default = true, Callback = function(s) library.flags.esp_usewhitelistcolor = s end})
UseWhitelistColorToggle:Colorpicker({Name = "Whitelist Color", Flag = "esp_whitelistcolor", Default = Color3.fromRGB(50, 255, 50), Callback = function(c) library.flags.esp_whitelistcolor = c end})
local UseTargetlistColorToggle = ESPGroup:Toggle({Name = "Use Targetlist Color", Flag = "esp_usetargetlistcolor", Default = true, Callback = function(s) library.flags.esp_usetargetlistcolor = s end})
UseTargetlistColorToggle:Colorpicker({Name = "Targetlist Color", Flag = "esp_targetlistcolor", Default = Color3.fromRGB(255, 50, 255), Callback = function(c) library.flags.esp_targetlistcolor = c end})
ESPSettingsGroup:Toggle({Name = "Show Health", Flag = "esp_showhealth", Default = true, Callback = function(s) library.flags.esp_showhealth = s end})
ESPSettingsGroup:Toggle({Name = "Show Distance", Flag = "esp_showdistance", Default = true, Callback = function(s) library.flags.esp_showdistance = s end})
ESPSettingsGroup:Toggle({Name = "Box Filled", Flag = "esp_boxfilled", Default = true, Callback = function(s) library.flags.esp_boxfilled = s end})
ESPSettingsGroup:Toggle({Name = "Box Outline", Flag = "esp_boxoutline", Default = true, Callback = function(s) library.flags.esp_boxoutline = s end})
ESPSettingsGroup:Slider({Name = "Box Alpha", Flag = "esp_boxalpha", Min = 0, Max = 10, Default = 3, Callback = function(v) library.flags.esp_boxalpha = v end})
local RichShaderToggle = RichShaderGroup:Toggle({Name = "Rich Shader", Flag = "rich_shader", Default = false, Callback = function(s) richShaderEnabled = s if s then local cc=Instance.new("ColorCorrectionEffect") cc.Name="RichShaderEffect" cc.Parent=game:GetService("Lighting") cc.Brightness=richBrightness/100 cc.Contrast=richContrast/100 cc.Saturation=richSaturation/100 cc.TintColor=richColor else local l=game:GetService("Lighting") local e=l:FindFirstChild("RichShaderEffect") if e then e:Destroy() end end end})
RichShaderToggle:Colorpicker({Name = "Ambient Color", Flag = "rich_shader_color", Default = Color3.fromRGB(255,200,150), Callback = function(c) richColor = c if richShaderEnabled then local l=game:GetService("Lighting") local e=l:FindFirstChild("RichShaderEffect") if e then e.TintColor=c end end end})
RichShaderGroup:Slider({Name = "Brightness", Flag = "rich_brightness", Min = 0, Max = 100, Default = 20, Callback = function(v) richBrightness = v if richShaderEnabled then local l=game:GetService("Lighting") local e=l:FindFirstChild("RichShaderEffect") if e then e.Brightness=v/100 end end end})
RichShaderGroup:Slider({Name = "Contrast", Flag = "rich_contrast", Min = 0, Max = 100, Default = 50, Callback = function(v) richContrast = v if richShaderEnabled then local l=game:GetService("Lighting") local e=l:FindFirstChild("RichShaderEffect") if e then e.Contrast=v/100 end end end})
RichShaderGroup:Slider({Name = "Saturation", Flag = "rich_saturation", Min = 0, Max = 200, Default = 150, Callback = function(v) richSaturation = v if richShaderEnabled then local l=game:GetService("Lighting") local e=l:FindFirstChild("RichShaderEffect") if e then e.Saturation=v/100 end end end})
local RichPlayerToggle = RichPlayerGroup:Toggle({Name = "Rich Player", Flag = "rich_player", Default = false, Callback = function(s) richPlayerEnabled = s if s then if LocalPlayer.Character then applyRichPlayer() end else if LocalPlayer.Character then resetRichPlayer() end end end})
RichPlayerToggle:Colorpicker({Name = "Player Color", Flag = "rich_player_color", Default = Color3.fromRGB(255,255,255), Callback = function(c) richPlayerColor = c if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end end})
local RichTransparencySlider = RichPlayerGroup:Slider({Name = "Transparency", Flag = "rich_transparency", Min = 0, Max = 100, Default = 0, Callback = function(v) richPlayerTransparency = v if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end end})
local PlayerChamsToggle = PlayerChamsGroup:Toggle({Name = "Enable Player Chams", Flag = "player_chams_enable", Default = false, Callback = function(s) ChamsConfig.PlayerChams.Enabled = s if s then enablePlayerChams() else disablePlayerChams() end end})
PlayerChamsToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.C, Callback = function(k,f) if not f then ChamsConfig.PlayerChams.Enabled = not ChamsConfig.PlayerChams.Enabled if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() else disablePlayerChams() end end end, ShowInList = true})
local OuterColorToggle = PlayerChamsGroup:Toggle({Name = "outer Color", Flag = "player_chams_outercolor", Default = false, Callback = function(s) if s then ChamsConfig.PlayerChams.OuterColor = Color3.fromRGB(255,255,255) updatePlayerBoxColors() end end})
OuterColorToggle:Colorpicker({Name = "", Flag = "player_chams_outercolor_picker", Default = Color3.fromRGB(255,255,255), Callback = function(c) ChamsConfig.PlayerChams.OuterColor = c updatePlayerBoxColors() end})
local InnerColorToggle = PlayerChamsGroup:Toggle({Name = "Inner Color", Flag = "player_chams_innercolor", Default = false, Callback = function(s) if s then ChamsConfig.PlayerChams.InnerColor = Color3.fromRGB(0,0,0) updatePlayerBoxColors() end end})
InnerColorToggle:Colorpicker({Name = "", Flag = "player_chams_innercolor_picker", Default = Color3.fromRGB(0,0,0), Callback = function(c) ChamsConfig.PlayerChams.InnerColor = c updatePlayerBoxColors() end})
local TeamCheckToggle = PlayerChamsGroup:Toggle({Name = "Team Check", Flag = "player_chams_teamcheck", Default = false, Callback = function(s) ChamsConfig.PlayerChams.TeamCheck = s if ChamsConfig.PlayerChams.Enabled then disablePlayerChams() enablePlayerChams() end end})
local WhitelistToggle = PlayerChamsGroup:Toggle({Name = "Use Whitelist Color", Flag = "chams_whitelist_toggle", Default = false, Callback = function(s) ChamsConfig.PlayerChams.UseWhitelistColor = s updatePlayerBoxColors() end})
WhitelistToggle:Colorpicker({Name = "whitelist color", Flag = "chams_whitelist_color", Default = Color3.fromRGB(50,255,50), Callback = function(c) ChamsConfig.PlayerChams.WhitelistColor = c updatePlayerBoxColors() end})
local TargetlistToggle = PlayerChamsGroup:Toggle({Name = "Use Targetlist Color", Flag = "chams_targetlist_toggle", Default = false, Callback = function(s) ChamsConfig.PlayerChams.UseTargetlistColor = s updatePlayerBoxColors() end})
TargetlistToggle:Colorpicker({Name = "targetlist Color", Flag = "chams_targetlist_color", Default = Color3.fromRGB(255,50,255), Callback = function(c) ChamsConfig.PlayerChams.TargetlistColor = c updatePlayerBoxColors() end})
local ArmsChamsToggle = ArmsChamsGroup:Toggle({Name = "Enable Arms Chams", Flag = "arms_chams_enable", Default = false, Callback = function(s) ChamsConfig.ArmChams.Enabled = s if s then applyForcefieldToArms() else removeForcefieldFromArms() end end})
ArmsChamsToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.B, Callback = function(k,f) if not f then ChamsConfig.ArmChams.Enabled = not ChamsConfig.ArmChams.Enabled if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() else removeForcefieldFromArms() end end end, ShowInList = true})
local ArmsTransparencySlider = ArmsChamsGroup:Slider({Name = "Arms Transparency", Flag = "arms_chams_transparency", Min = 0, Max = 1, Default = 0.5, Callback = function(v) ChamsConfig.ArmChams.Transparency = v if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end end})
ArmsChamsToggle:Colorpicker({Name = "Arms Color", Flag = "arms_chams_color", Default = Color3.fromRGB(255,255,255), Callback = function(c) ChamsConfig.ArmChams.Color = c if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end end})
local ToolChamsToggle = ToolChamsGroup:Toggle({Name = "Enable Tool Chams", Flag = "tool_chams_enable", Default = false, Callback = function(s) ChamsConfig.ToolChams.Enabled = s if s then applyForcefieldToTool() else removeForcefieldFromTool() end end})
ToolChamsToggle:Keybind({Name = "Keybind", Default = Enum.KeyCode.N, Callback = function(k,f) if not f then ChamsConfig.ToolChams.Enabled = not ChamsConfig.ToolChams.Enabled if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() else removeForcefieldFromTool() end end end, ShowInList = true})
local ToolTransparencySlider = ToolChamsGroup:Slider({Name = "Tool Transparency", Flag = "tool_chams_transparency", Min = 0, Max = 1, Default = 0.5, Callback = function(v) ChamsConfig.ToolChams.Transparency = v if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end end})
ToolChamsToggle:Colorpicker({Name = "tool Color", Flag = "tool_chams_color", Default = Color3.fromRGB(255,255,255), Callback = function(c) ChamsConfig.ToolChams.Color = c if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end end})
local LeftSection,ControlSection,RightSection = PlayersTab:Section({Name = "Players", Side = "Left"}),PlayersTab:Section({Name = "Controls", Side = "Left"}),PlayersTab:Section({Name = "Misc", Side = "Right"})
local UseTargetListToggle = ControlSection:Toggle({Name = "Use Target List", Flag = "use_target_list", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.UseTargetList = s end})
local UseWhitelistToggle = ControlSection:Toggle({Name = "Use Whitelist", Flag = "use_whitelist", Default = false, Callback = function(s) getgenv().CONFIG.Ragebot.UseWhitelist = s end})
local BulletTracersToggle = RightSection:Toggle({Name = "Players bullet Tracers", Flag = "bullet_tracers_enabled", Default = false, Callback = function(s) bulletTracersEnabled = s if s then trackGlobalBullets() end end})
BulletTracersToggle:Colorpicker({Name = "tracer Color", Flag = "tracer_color", Default = Color3.fromRGB(255,50,50), Callback = function(c) tracerColor = c end})
local TracerWidthSlider = RightSection:Slider({Name = "Tracer Width", Flag = "tracer_width", Min = 1, Max = 5, Default = 2, Callback = function(v) tracerWidth = v/1 end})
local TracerLifetimeSlider = RightSection:Slider({Name = "Tracer Lifetime", Flag = "tracer_lifetime", Min = 1, Max = 100, Default = 10, Callback = function(v) tracerLifetime = v/5 end})
PlayersTab:PlayerList({})
Library:Configs(Window) for i,v in Themes.preset do pcall(function() Library:RefreshTheme(i,v) end) end
--[[
local ESPGroup = VisualTab:AddGroupbox("left", "ESP Settings")
local ESPSettingsGroup = VisualTab:AddGroupbox("right", "ESP Features")

ESPGroup:AddToggle("esp_enabled", {
    Text = "Enable ESP",
    Default = true,
    Callback = function(value)
        library.flags.esp_enabled = value
    end
})

ESPGroup:AddKeybind("esp_keybind", {
    Text = "ESP Key",
    Default = Enum.KeyCode.H,
    Callback = function()
        library.flags.esp_enabled = not library.flags.esp_enabled
        Zenwave.Options.esp_enabled:Set(library.flags.esp_enabled)
    end
})

ESPGroup:AddColorPicker("esp_maincolor", {
    Text = "ESP Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        library.flags.esp_maincolor = color
    end
})

ESPGroup:AddToggle("esp_teamcheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(value)
        library.flags.esp_teamcheck = value
    end
})

ESPGroup:AddToggle("esp_usewhitelistcolor", {
    Text = "Use Whitelist Color",
    Default = true,
    Callback = function(value)
        library.flags.esp_usewhitelistcolor = value
    end
})

ESPGroup:AddColorPicker("esp_whitelistcolor", {
    Text = "Whitelist Color",
    Default = Color3.fromRGB(50, 255, 50),
    Callback = function(color)
        library.flags.esp_whitelistcolor = color
    end
})

ESPGroup:AddToggle("esp_usetargetlistcolor", {
    Text = "Use Targetlist Color",
    Default = true,
    Callback = function(value)
        library.flags.esp_usetargetlistcolor = value
    end
})

ESPGroup:AddColorPicker("esp_targetlistcolor", {
    Text = "Targetlist Color",
    Default = Color3.fromRGB(255, 50, 255),
    Callback = function(color)
        library.flags.esp_targetlistcolor = color
    end
})

ESPSettingsGroup:AddToggle("esp_showhealth", {
    Text = "Show Health",
    Default = true,
    Callback = function(value)
        library.flags.esp_showhealth = value
    end
})

ESPSettingsGroup:AddToggle("esp_showdistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(value)
        library.flags.esp_showdistance = value
    end
})

ESPSettingsGroup:AddToggle("esp_boxfilled", {
    Text = "Box Filled",
    Default = true,
    Callback = function(value)
        library.flags.esp_boxfilled = value
    end
})

ESPSettingsGroup:AddToggle("esp_boxoutline", {
    Text = "Box Outline",
    Default = true,
    Callback = function(value)
        library.flags.esp_boxoutline = value
    end
})

ESPSettingsGroup:AddSlider("esp_boxalpha", {
    Text = "Box Alpha",
    Default = 3,
    Min = 0,
    Max = 10,
    Callback = function(value)
        library.flags.esp_boxalpha = value
    end
})
local RichShaderGroup = VisualTab:AddGroupbox("left", "Rich Shader")
local RichPlayerGroup = VisualTab:AddGroupbox("right", "Rich Player")
local PlayerChamsGroup = VisualTab:AddGroupbox("left", "Player Chams")
local ArmsChamsGroup = VisualTab:AddGroupbox("right", "Arms Chams")
local ToolChamsGroup = VisualTab:AddGroupbox("left", "Tool Chams")

RichShaderGroup:AddToggle("rich_shader", {
    Text = "Rich Shader",
    Default = false,
    Callback = function(value)
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
    end
})

RichShaderGroup:AddColorPicker("rich_shader_color", {
    Text = "Ambient Color",
    Default = Color3.fromRGB(255,200,150),
    Callback = function(color)
        richColor = color
        if richShaderEnabled then 
            local lighting=game:GetService("Lighting") 
            local effect=lighting:FindFirstChild("RichShaderEffect") 
            if effect then 
                effect.TintColor=color 
            end 
        end
    end
})

RichShaderGroup:AddSlider("rich_brightness", {
    Text = "Brightness",
    Default = 20,
    Min = 0,
    Max = 100,
    Callback = function(value)
        richBrightness = value
        if richShaderEnabled then 
            local lighting=game:GetService("Lighting") 
            local effect=lighting:FindFirstChild("RichShaderEffect") 
            if effect then 
                effect.Brightness=value/100 
            end 
        end
    end
})

RichShaderGroup:AddSlider("rich_contrast", {
    Text = "Contrast",
    Default = 50,
    Min = 0,
    Max = 100,
    Callback = function(value)
        richContrast = value
        if richShaderEnabled then 
            local lighting=game:GetService("Lighting") 
            local effect=lighting:FindFirstChild("RichShaderEffect") 
            if effect then 
                effect.Contrast=value/100 
            end 
        end
    end
})

RichShaderGroup:AddSlider("rich_saturation", {
    Text = "Saturation",
    Default = 150,
    Min = 0,
    Max = 200,
    Callback = function(value)
        richSaturation = value
        if richShaderEnabled then 
            local lighting=game:GetService("Lighting") 
            local effect=lighting:FindFirstChild("RichShaderEffect") 
            if effect then 
                effect.Saturation=value/100 
            end 
        end
    end
})

RichPlayerGroup:AddToggle("rich_player", {
    Text = "Rich Player",
    Default = false,
    Callback = function(value)
        richPlayerEnabled = value
        if value then 
            if LocalPlayer.Character then 
                applyRichPlayer() 
            end 
        else 
            if LocalPlayer.Character then 
                resetRichPlayer() 
            end 
        end
    end
})

RichPlayerGroup:AddColorPicker("rich_player_color", {
    Text = "Player Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(color)
        richPlayerColor = color
        if richPlayerEnabled and LocalPlayer.Character then 
            applyRichPlayer() 
        end
    end
})

RichPlayerGroup:AddSlider("rich_transparency", {
    Text = "Transparency",
    Default = 0,
    Min = 0,
    Max = 100,
    Callback = function(value)
        richPlayerTransparency = value
        if richPlayerEnabled and LocalPlayer.Character then 
            applyRichPlayer() 
        end
    end
})

PlayerChamsGroup:AddToggle("player_chams_enable", {
    Text = "Enable Player Chams",
    Default = false,
    Callback = function(value)
        ChamsConfig.PlayerChams.Enabled = value
        if value then enablePlayerChams() else disablePlayerChams() end
    end
})

PlayerChamsGroup:AddColorPicker("player_chams_outercolor", {
    Text = "outer Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(color)
        ChamsConfig.PlayerChams.OuterColor = color
        updatePlayerBoxColors()
    end
})

PlayerChamsGroup:AddColorPicker("player_chams_innercolor", {
    Text = "Inner Color",
    Default = Color3.fromRGB(0,0,0),
    Callback = function(color)
        ChamsConfig.PlayerChams.InnerColor = color
        updatePlayerBoxColors()
    end
})

PlayerChamsGroup:AddToggle("player_chams_teamcheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(value)
        ChamsConfig.PlayerChams.TeamCheck = value
        if ChamsConfig.PlayerChams.Enabled then disablePlayerChams() enablePlayerChams() end
    end
})

PlayerChamsGroup:AddToggle("chams_whitelist_toggle", {
    Text = "Use Whitelist Color",
    Default = false,
    Callback = function(value)
        ChamsConfig.PlayerChams.UseWhitelistColor = value
        updatePlayerBoxColors()
    end
})

PlayerChamsGroup:AddColorPicker("chams_whitelist_color", {
    Text = "whitelist color",
    Default = Color3.fromRGB(50,255,50),
    Callback = function(color)
        ChamsConfig.PlayerChams.WhitelistColor = color
        updatePlayerBoxColors()
    end
})

PlayerChamsGroup:AddToggle("chams_targetlist_toggle", {
    Text = "Use Targetlist Color",
    Default = false,
    Callback = function(value)
        ChamsConfig.PlayerChams.UseTargetlistColor = value
        updatePlayerBoxColors()
    end
})

PlayerChamsGroup:AddColorPicker("chams_targetlist_color", {
    Text = "targetlist Color",
    Default = Color3.fromRGB(255,50,255),
    Callback = function(color)
        ChamsConfig.PlayerChams.TargetlistColor = color
        updatePlayerBoxColors()
    end
})

ArmsChamsGroup:AddToggle("arms_chams_enable", {
    Text = "Enable Arms Chams",
    Default = false,
    Callback = function(value)
        ChamsConfig.ArmChams.Enabled = value
        if value then applyForcefieldToArms() else removeForcefieldFromArms() end
    end
})

ArmsChamsGroup:AddSlider("arms_chams_transparency", {
    Text = "Arms Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Callback = function(value)
        ChamsConfig.ArmChams.Transparency = value
        if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
    end
})

ArmsChamsGroup:AddColorPicker("arms_chams_color", {
    Text = "Arms Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(color)
        ChamsConfig.ArmChams.Color = color
        if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
    end
})

ToolChamsGroup:AddToggle("tool_chams_enable", {
    Text = "Enable Tool Chams",
    Default = false,
    Callback = function(value)
        ChamsConfig.ToolChams.Enabled = value
        if value then applyForcefieldToTool() else removeForcefieldFromTool() end
    end
})

ToolChamsGroup:AddSlider("tool_chams_transparency", {
    Text = "Tool Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Callback = function(value)
        ChamsConfig.ToolChams.Transparency = value
        if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
    end
})

ArmsChamsGroup:AddColorPicker("tool_chams_color", {
    Text = "tool Color",
    Default = Color3.fromRGB(255,255,255),
    Callback = function(color)
        ChamsConfig.ToolChams.Color = color
        if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
    end
})

local LeftSection = PlayersTab:AddGroupbox("left", "Players")
local ControlSection = PlayersTab:AddGroupbox("left", "Controls")
local RightSection = PlayersTab:AddGroupbox("right", "Misc")

local playersList = {}
for _,player in ipairs(Players:GetPlayers()) do 
    if player~=LocalPlayer then 
        table.insert(playersList, player.Name) 
    end 
end

local playersBox = LeftSection:AddListBox("players_box", {
    Text = "Online Players",
    Values = playersList,
    Height = 200,
    Default = nil,
    Callback = function(value)
        getgenv().selectedPlayersTable = {value}
    end
})

Players.PlayerAdded:Connect(function(player)
    if player~=LocalPlayer then
        playersBox:Add(player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    playersBox:Remove(player.Name)
end)

LeftSection:AddButton({
    Text = "Add to Target",
    Func = function()
        local selected = getgenv().selectedPlayersTable or {}
        for _,name in ipairs(selected) do
            local found=false
            for _,target in ipairs(getgenv().Lists.TargetList) do if target==name then found=true break end end
            if not found then table.insert(getgenv().Lists.TargetList,name) end
        end
    end
})

LeftSection:AddButton({
    Text = "Add to Whitelist",
    Func = function()
        local selected = getgenv().selectedPlayersTable or {}
        for _,name in ipairs(selected) do
            local found=false
            for _,wl in ipairs(getgenv().Lists.Whitelist) do if wl==name then found=true break end end
            if not found then table.insert(getgenv().Lists.Whitelist,name) end
        end
    end
})

LeftSection:AddButton({
    Text = "Remove Target",
    Func = function()
        local selected = getgenv().selectedPlayersTable or {}
        for _,name in ipairs(selected) do
            for i=#getgenv().Lists.TargetList,1,-1 do if getgenv().Lists.TargetList[i]==name then table.remove(getgenv().Lists.TargetList,i) end end
        end
    end
})

LeftSection:AddButton({
    Text = "Remove Whitelist",
    Func = function()
        local selected = getgenv().selectedPlayersTable or {}
        for _,name in ipairs(selected) do
            for i=#getgenv().Lists.Whitelist,1,-1 do if getgenv().Lists.Whitelist[i]==name then table.remove(getgenv().Lists.Whitelist,i) end end
        end
    end
})

LeftSection:AddButton({
    Text = "Clear Targets",
    Func = function() 
        getgenv().Lists.TargetList={} 
    end
})

LeftSection:AddButton({
    Text = "Clear Whitelist",
    Func = function() 
        getgenv().Lists.Whitelist={} 
    end
})

local targetCountLabel = LeftSection:AddLabel("Targets: 0")
local whitelistCountLabel = LeftSection:AddLabel("Whitelist: 0")

task.spawn(function() 
    while task.wait(1) do 
        targetCountLabel:Set("Targets: "..#getgenv().Lists.TargetList) 
        whitelistCountLabel:Set("Whitelist: "..#getgenv().Lists.Whitelist) 
    end 
end)

ControlSection:AddToggle("use_target_list", {
    Text = "Use Target List",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.UseTargetList = value
    end
})

ControlSection:AddToggle("use_whitelist", {
    Text = "Use Whitelist",
    Default = false,
    Callback = function(value)
        getgenv().CONFIG.Ragebot.UseWhitelist = value
    end
})

local selectedNameLabel = RightSection:AddLabel("Selected: None")
local playerTeamLabel = RightSection:AddLabel("Team: -")
local playerHealthLabel = RightSection:AddLabel("Health: -")
local playerDistanceLabel = RightSection:AddLabel("Distance: -")
local playerStatusLabel = RightSection:AddLabel("Status: -")

RunService.RenderStepped:Connect(function()
    local selected = getgenv().selectedPlayersTable or {}
    local name = selected[1]
    if not name then 
        selectedNameLabel:Set("Selected: None") 
        playerTeamLabel:Set("Team: -") 
        playerHealthLabel:Set("Health: -") 
        playerDistanceLabel:Set("Distance: -") 
        playerStatusLabel:Set("Status: -") 
        return 
    end
    
    local player = Players:FindFirstChild(name)
    if not player then 
        selectedNameLabel:Set("Selected: "..name.." (Off)") 
        playerTeamLabel:Set("Team: -") 
        playerHealthLabel:Set("Health: -") 
        playerDistanceLabel:Set("Distance: -") 
        playerStatusLabel:Set("Status: Offline") 
        return 
    end
    
    selectedNameLabel:Set("Selected: "..player.Name)
    
    if player.Team then 
        playerTeamLabel:Set("Team: "..tostring(player.Team)) 
    else 
        playerTeamLabel:Set("Team: None") 
    end
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then 
            playerHealthLabel:Set(string.format("Health: %d/%d",math.floor(hum.Health),math.floor(hum.MaxHealth))) 
        else 
            playerHealthLabel:Set("Health: -") 
        end
        
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local theirRoot = char:FindFirstChild("HumanoidRootPart")
        if myRoot and theirRoot then 
            local dist = (myRoot.Position-theirRoot.Position).Magnitude 
            playerDistanceLabel:Set(string.format("Distance: %d",math.floor(dist))) 
        else 
            playerDistanceLabel:Set("Distance: -") 
        end
        
        playerStatusLabel:Set("Status: Alive")
    else 
        playerHealthLabel:Set("Health: -") 
        playerDistanceLabel:Set("Distance: -") 
        playerStatusLabel:Set("Status: Dead") 
    end
end)

RightSection:AddToggle("bullet_tracers_enabled", {
    Text = "Players bullet Tracers",
    Default = false,
    Callback = function(value)
        bulletTracersEnabled = value
        if value then 
            trackGlobalBullets() 
        end
    end
})

RightSection:AddColorPicker("tracer_color", {
    Text = "tracer Color",
    Default = Color3.fromRGB(255,50,50),
    Callback = function(color)
        tracerColor = color
    end
})

RightSection:AddSlider("tracer_width", {
    Text = "Tracer Width",
    Default = 2,
    Min = 1,
    Max = 5,
    Callback = function(value)
        tracerWidth = value/1
    end
})

RightSection:AddSlider("tracer_lifetime", {
    Text = "Tracer Lifetime",
    Default = 10,
    Min = 1,
    Max = 100,
    Callback = function(value)
        tracerLifetime = value/5
    end
})

local ConfigSection = ConfigTab:AddGroupbox("left", "Configuration", 1)

local cfgListValues = cfgList()
local cfgListBox = ConfigSection:AddListBox("cfg_list", {
    Text = "Configs",
    Values = cfgListValues,
    Height = 300,
    Default = nil,
    Callback = function(value)
        if type(value) == "string" then
            Config.selected = value
        end
    end
})

ConfigSection:AddButton({
    Text = "Save Configuration",
    Func = function()
        local name = randomName()
        Config:save(name)
        Config.selected = name
        local opts = cfgList()
        cfgListBox:set_options(opts)
        cfgListBox:set_selected(name)
    end
})

ConfigSection:AddButton({
    Text = "Load Configuration",
    Func = function()
        if type(Config.selected) == "string" and #Config.selected > 0 then
            Config:load(Config.selected)
        end
    end
})

ConfigSection:AddButton({
    Text = "Delete Configuration",
    Func = function()
        if type(Config.selected) == "string" and #Config.selected > 0 then
            Config:delete(Config.selected)
            Config.selected = nil
            cfgListBox:set_options(cfgList())
        end
    end
})
--]]
RagebotMainGroup:AddKeybind("ragebot_keybind", {
    Text = "Ragebot Key", 
    Default = Enum.KeyCode.F,
    Callback = function()
        getgenv().CONFIG.Ragebot.Enabled = not getgenv().CONFIG.Ragebot.Enabled
        Zenwave.Options.ragebot_enabled:Set(getgenv().CONFIG.Ragebot.Enabled)
    end
})

LegitGroup:AddKeybind("legit_keybind", {
    Text = "Legit Key", 
    Default = Enum.KeyCode.G,
    Callback = function()
        getgenv().Legit.Enabled = not getgenv().Legit.Enabled
        Zenwave.Options.legit_enable:Set(getgenv().Legit.Enabled)
    end
})

ESPGroup:AddKeybind("esp_keybind", {
    Text = "ESP Key", 
    Default = Enum.KeyCode.H,
    Callback = function()
        library.flags.esp_enabled = not library.flags.esp_enabled
        Zenwave.Options.esp_enabled:Set(library.flags.esp_enabled)
    end
})

MovementGroup:AddKeybind("fly_keybind", {
    Text = "Fly Key", 
    Default = Enum.KeyCode.X,
    Callback = function()
        local flyState = not flyEnabled
        if flyState then 
            QuickUIText.Text="FLY ON" 
            QuickUIText.TextColor3=Color3.fromRGB(50,255,50) 
            startFlying()
        else 
            QuickUIText.Text="FLY OFF" 
            QuickUIText.TextColor3=Color3.fromRGB(255,50,50) 
            disableFlying() 
        end
        Zenwave.Options.misc_fly:Set(flyState)
    end
})

MovementGroup:AddKeybind("noclip_keybind", {
    Text = "Noclip Key", 
    Default = Enum.KeyCode.V,
    Callback = function()
        noclipEnabled = not noclipEnabled
        if noclipEnabled then startNoclip() else stopNoclip() end
        Zenwave.Options.noclip_enabled:Set(noclipEnabled)
    end
})

MovementGroup:AddKeybind("speed_keybind", {
    Text = "Speed Key", 
    Default = Enum.KeyCode.Z,
    Callback = function()
        speedEnabled = not speedEnabled
        if speedEnabled then enableSpeed() else disableSpeed() end
        Zenwave.Options.misc_speed:Set(speedEnabled)
    end
})

SafeESPMiscGroup:AddKeybind("safeesp_keybind", {
    Text = "SafeESP Key", 
    Default = Enum.KeyCode.K,
    Callback = function()
        local currentState = not SafeESP.Enabled
        enableSafeESP(currentState)
        Zenwave.Options.misc_safeesp:Set(currentState)
    end
})

PlayerChamsGroup:AddKeybind("playerchams_keybind", {
    Text = "PlayerChams Key", 
    Default = Enum.KeyCode.C,
    Callback = function()
        ChamsConfig.PlayerChams.Enabled = not ChamsConfig.PlayerChams.Enabled
        if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() else disablePlayerChams() end
        Zenwave.Options.player_chams_enable:Set(ChamsConfig.PlayerChams.Enabled)
    end
})

ArmsChamsGroup:AddKeybind("armschams_keybind", {
    Text = "ArmsChams Key", 
    Default = Enum.KeyCode.B,
    Callback = function()
        ChamsConfig.ArmChams.Enabled = not ChamsConfig.ArmChams.Enabled
        if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() else removeForcefieldFromArms() end
        Zenwave.Options.arms_chams_enable:Set(ChamsConfig.ArmChams.Enabled)
    end
})

ToolChamsGroup:AddKeybind("toolchams_keybind", {
    Text = "ToolChams Key", 
    Default = Enum.KeyCode.N,
    Callback = function()
        ChamsConfig.ToolChams.Enabled = not ChamsConfig.ToolChams.Enabled
        if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() else removeForcefieldFromTool() end
        Zenwave.Options.tool_chams_enable:Set(ChamsConfig.ToolChams.Enabled)
    end
})
Window:UpdateKeybindList()
--]]
