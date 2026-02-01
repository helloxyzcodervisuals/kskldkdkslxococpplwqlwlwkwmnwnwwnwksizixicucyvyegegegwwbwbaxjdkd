repeat task.wait() until game:IsLoaded()

do
    local function isAdonisAC(tab) return rawget(tab,"Detected") and typeof(rawget(tab,"Detected"))=="function" and rawget(tab,"RLocked") end
    for _,v in next,getgc(true) do if typeof(v)=="table" and isAdonisAC(v) then for i,f in next,v do if rawequal(i,"Detected") then local old old=hookfunction(f,function(action,info,crash)if rawequal(action,"_") and rawequal(info,"_") and rawequal(crash,false) then return old(action,info,crash) end return task.wait(9e9) end) warn("bypassed") break end end end end
end
for _,v in pairs(getgc(true)) do if type(v)=="table" then local func=rawget(v,"DTXC1") if type(func)=="function" then hookfunction(func,function() return end) break end end end

getgenv().CONFIG={Ragebot={Enabled=false,RapidFire=false,FireRate=30,Prediction=true,PredictionAmount=0.12,TeamCheck=false,VisibilityCheck=true,FOV=9e9,ShowFOV=false,Wallbang=true,Tracers=true,TracerColor=Color3.fromRGB(255,0,0),TracerWidth=1,TracerLifetime=3,ShootRange=15,HitRange=15,HitNotify=true,AutoReload=true,HitSound=true,HitColor=Color3.fromRGB(255,182,193),UseTargetList=false,UseWhitelist=false,HitNotifyDuration=5,LowHealthCheck=false,SelectedHitSound="skeet",FriendCheck=false,MaxTarget=0},Misc={SpeedEnabled=false,SpeedValue=50,JumpPowerEnabled=false,JumpPowerValue=100,LoopFOVEnabled=false,HideHeadEnabled=false,InfStaminaEnabled=false,NoFallDmgEnabled=false,SpeedConnection=nil,FOVConnection=nil,JumpPowerConnection=nil,NoFallHook=nil,InfStaminaHook=nil}}
getgenv().Lists={TargetList={},Whitelist={}}
--ixc
local Players,RunService,Workspace,TweenService=game:GetService("Players"),game:GetService("RunService"),game:GetService("Workspace"),game:GetService("TweenService")
local LocalPlayer,Camera,ReplicatedStorage=Players.LocalPlayer,Workspace.CurrentCamera,game:GetService("ReplicatedStorage")
local library=loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/deadCell.lua"))()
local screenY=Workspace.CurrentCamera.ViewportSize.Y
local windowHeight=screenY<400 and 350 or 550
local window=library:new_window({size=Vector2.new(700,windowHeight)})

local instantReloadConnections={}
local characterAddedConnection
local function loadRagebot()
    if makefolder then makefolder("a") makefolder("a/fonts") end
    if not isfile or (isfile and not isfile("a/fonts/main.ttf")) then if writefile then writefile("a/fonts/main.ttf",game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf")) end end
    local font_data={name="AFont",faces={{name="Regular",weight=400,style="normal",assetId=getcustomasset and getcustomasset("a/fonts/main.ttf")or""}}}
    if writefile and not isfile("a/fonts/main_encoded.ttf") then writefile("a/fonts/main_encoded.ttf",game:GetService("HttpService"):JSONEncode(font_data)) end
    local AFont=Font.new(getcustomasset and getcustomasset("a/fonts/main_encoded.ttf")or Enum.Font.Gotham,Enum.FontWeight.Regular)
    local hitNotifications={}
    local notificationYOffset=5
    local MAX_VISIBLE_NOTIFICATIONS=15
    local function createHitNotification(toolName,offsetValue,playerName)
        if not getgenv().CONFIG.Ragebot.HitNotify then return end
        local ScreenGui=game:GetService("CoreGui"):FindFirstChild("HitNotifications")or Instance.new("ScreenGui")
        ScreenGui.Name="HitNotifications"
        ScreenGui.Parent=game:GetService("CoreGui")
        local scrollFrame=ScreenGui:FindFirstChild("NotificationScroll")or Instance.new("ScrollingFrame")
        scrollFrame.Name="NotificationScroll"
        scrollFrame.Parent=ScreenGui
        scrollFrame.BackgroundTransparency=1
        scrollFrame.Size=UDim2.new(0,600,0,400)
        scrollFrame.Position=UDim2.new(0,30,0,10)
        scrollFrame.ScrollingEnabled=false
        scrollFrame.CanvasSize=UDim2.new(0,400,0,0)
        scrollFrame.ScrollBarThickness=0
        scrollFrame.ClipsDescendants=false
        local THEME_COLOR=Color3.fromRGB(40,40,40)
        local THEME_TRANSPARENCY=0.5
        local box=Instance.new("Frame")
        box.Parent=scrollFrame
        box.BackgroundColor3=THEME_COLOR
        box.BackgroundTransparency=THEME_TRANSPARENCY
        box.BorderSizePixel=0
        box.AnchorPoint=Vector2.new(0,0)
        box.ClipsDescendants=false
        local function createGlow(side)
            local glow=Instance.new("Frame")
            glow.Size=UDim2.new(0,80,1,0)
            glow.Position=(side=="Left")and UDim2.new(0,-80,0,0)or UDim2.new(1,0,0,0)
            glow.BackgroundColor3=THEME_COLOR
            glow.BackgroundTransparency=THEME_TRANSPARENCY
            glow.BorderSizePixel=0
            glow.Parent=box
            local grad=Instance.new("UIGradient")
            grad.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,(side=="Left"and 1 or 0)),NumberSequenceKeypoint.new(1,(side=="Left"and 0 or 1))})
            grad.Parent=glow
        end
        createGlow("Left")
        createGlow("Right")
        local parts={{"Using ",Color3.fromRGB(255,255,255)},{toolName.." ",getgenv().CONFIG.Ragebot.HitColor},{"On ",Color3.fromRGB(255,255,255)},{string.format("%.2f",offsetValue).." ",getgenv().CONFIG.Ragebot.HitColor},{"in the ",Color3.fromRGB(255,255,255)},{"head ",getgenv().CONFIG.Ragebot.HitColor},{"to hit ",Color3.fromRGB(255,255,255)},{playerName,getgenv().CONFIG.Ragebot.HitColor},{"on via cache",Color3.fromRGB(255,255,255)},}
        local offsetX=8
        local totalW,maxH=0,0
        for _,seg in ipairs(parts) do
            local txt,col=seg[1],seg[2]
            local label=Instance.new("TextLabel")
            label.Parent=box
            label.BackgroundTransparency=1
            label.BorderSizePixel=0
            label.TextColor3=col
            label.FontFace=AFont
            label.TextSize=10
            label.Text=txt
            label.AutomaticSize=Enum.AutomaticSize.XY
            label.Position=UDim2.new(0,offsetX,0,0)
            offsetX=offsetX+label.TextBounds.X
            totalW=offsetX
            maxH=math.max(maxH,label.TextBounds.Y)
        end
        box.Size=UDim2.new(0,totalW+16,0,maxH+8)
        table.insert(hitNotifications,{box=box,createTime=tick()})
        local function updateScrollFrame()
            local allFrames={}
            for _,notif in ipairs(hitNotifications) do if notif.box and notif.box.Parent then table.insert(allFrames,notif) end end
            hitNotifications=allFrames
            local currentY=0
            for i,notif in ipairs(hitNotifications) do
                notif.box.Position=UDim2.new(0,80,0,currentY)
                if i<=MAX_VISIBLE_NOTIFICATIONS then notif.box.Visible=true currentY=currentY+notif.box.AbsoluteSize.Y+notificationYOffset else notif.box.Visible=false end
            end
            scrollFrame.CanvasSize=UDim2.new(0,600,0,currentY)
        end
        updateScrollFrame()
        task.delay(getgenv().CONFIG.Ragebot.HitNotifyDuration,function()
            for i,notif in ipairs(hitNotifications) do if notif.box==box then table.remove(hitNotifications,i) box:Destroy() break end end
            updateScrollFrame()
        end)
    end
    local function playHitSound()
        if not getgenv().CONFIG.Ragebot.HitSound then return end
        local soundIds={["Bameware"]="rbxassetid://3124331820",["Bell"]="rbxassetid://6534947240",["Bubble"]="rbxassetid://6534947588",["Pick"]="rbxassetid://1347140027",["Pop"]="rbxassetid://198598793",["Rust"]="rbxassetid://1255040462",["Sans"]="rbxassetid://3188795283",["Fart"]="rbxassetid://130833677",["Big"]="rbxassetid://5332005053",["Vine"]="rbxassetid://5332680810",["Bruh"]="rbxassetid://4578740568",["Skeet"]="rbxassetid://5633695679",["Neverlose"]="rbxassetid://6534948092",["Fatality"]="rbxassetid://6534947869",["Bonk"]="rbxassetid://5766898159",["Minecraft"]="rbxassetid://4018616850"}
        local soundId=soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound]or soundIds["Skeet"]
        local sound=Instance.new("Sound")
        sound.SoundId=soundId
        sound.Volume=0.75
        sound.Parent=Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound,0.75)
    end
    local function getCurrentTool()
        if LocalPlayer.Character then for _,tool in pairs(LocalPlayer.Character:GetChildren()) do if tool:IsA("Tool") then return tool end end end
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
    local cachedBestPositions={history={},target=nil}
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
            local maxCache=math.random(10,15)
            for i=1,math.min(#validPoints,maxCache) do table.insert(cachedBestPositions.history,validPoints[i]) end
            return validPoints[1].shootPos,validPoints[1].hitPos
        end
        for i=1,10 do
            local depthY=-math.random(15,16)
            local offX,offZ=math.random(-5,4),math.random(-5,4)
            local fbShoot=Vector3.new(startPos.X+offX,depthY,startPos.Z+offZ)
            local fbHit=Vector3.new(targetPos.X+offX,depthY,targetPos.Z+offZ)
            if checkClearPath(startPos,fbShoot) and checkClearPath(fbShoot,fbHit) then
                return fbShoot,fbHit
            end
        end
        for i=1,10 do
            local skyY=math.random(17,19)
            local offX,offZ=math.random(-5,5),math.random(-5,5)
            local fbShoot=Vector3.new(startPos.X+offX,skyY,startPos.Z+offZ)
            local fbHit=Vector3.new(targetPos.X+offX,skyY,targetPos.Z+offZ)
            if checkClearPath(startPos,fbShoot) and checkClearPath(fbShoot,fbHit) then
                return fbShoot,fbHit
            end
        end
        return nil,nil
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
    local lastShotTime=0
    task.spawn(function()
        while true do
            if not getgenv().CONFIG.Ragebot.Enabled then task.wait(0.001) else
                if not LocalPlayer.Character then task.wait(0.001) else
                    if not LocalPlayer.Character:FindFirstChild("Head") then task.wait(0.001) else
                        local target=getClosestTarget()
                        local waitTimeValue=0.01
                        if target then
                            local currentTime=tick()
                            local baseWaitTime=1/(getgenv().CONFIG.Ragebot.FireRate*9999999999999999999999999)
                            local WaitTime=1/(getgenv().CONFIG.Ragebot.FireRate*1)
                            if getgenv().CONFIG.Ragebot.RapidFire then
                                local rapidWaitTime=baseWaitTime*0.000000001
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
    end)
    local fovCircle=Drawing.new("Circle")
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
end

local function loadMisc()
    local Players=game:GetService("Players")
    local RunService=game:GetService("RunService")
    local LocalPlayer=Players.LocalPlayer
    local Workspace=game:GetService("Workspace")
    local ReplicatedStorage=game:GetService("ReplicatedStorage")
    local CoreGui=game:GetService("CoreGui")
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
    ScreenGui.Parent=CoreGui
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
    local function disableFlying() flyEnabled=false end
    QuickUIText.MouseButton1Click:Connect(function()
        flyEnabled=not flyEnabled
        if flyEnabled then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying()
        else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end
    end)
    return {
        toggleSpeed=function(state) speedEnabled=state if state then enableSpeed() else disableSpeed() end end,
        setSpeedValue=function(value) getgenv().CONFIG.Misc.SpeedValue=value end,
        toggleJumpPower=function(state) jumpPowerEnabled=state if state then enableJumpPower() else disableJumpPower() end end,
        setJumpValue=function(value) getgenv().CONFIG.Misc.JumpPowerValue=value end,
        toggleLoopFOV=function(state) loopFOVEnabled=state if state then enableLoopFOV() else disableLoopFOV() end end,
        toggleHideHead=function(state) getgenv().CONFIG.Misc.HideHeadEnabled=state if state then hideHead() end end,
        toggleInfStamina=function(state) getgenv().CONFIG.Misc.InfStaminaEnabled=state if state then enableInfStamina() else disableInfStamina() end end,
        toggleNoFall=function(state) getgenv().CONFIG.Misc.NoFallDmgEnabled=state if state then enableNoFallDmg() else disableNoFallDmg() end end,
        toggleLockpick=function(state) if state then enableLockpick() else disableLockpick() end end,
        toggleSafeESP=function(state) enableSafeESP(state) end,
        updateSafeColor=updateSafeColor,
        toggleInstantPrompt=function(state) if state then enableInstantPrompt() else disableInstantPrompt() end end,
        toggleAutoDoor=function(state) if state then enableAutoDoor() else disableAutoDoor() end end,
        toggleFly=function(state) flyEnabled=state if state then QuickUIText.Text="FLY ON" QuickUIText.TextColor3=Color3.fromRGB(50,255,50) startFlying() else QuickUIText.Text="FLY OFF" QuickUIText.TextColor3=Color3.fromRGB(255,50,50) disableFlying() end end,
        setFlySpeed=function(value) flySpeed=value end
    }
end
local misc=loadMisc()
loadRagebot()
getgenv().Legit={Enabled=false,HeadChance=30,HitPart="Torso",NoRecoil=true,AimAssist=false,AimAssistStrength=0.3,Smoothing=0.2}
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
local silent_aim_active=false
local aim_target=nil
local aim_position=Vector3.new()
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
local ragebotPage = window:new_page({name="Ragebot"})
local ragebotMainSection = ragebotPage:new_section({name="Ragebot Main",side="left",size=450})
ragebotMainSection:new_toggle({name="Enable Ragebot",state=false,flag="ragebot_enabled",callback=function(state) getgenv().CONFIG.Ragebot.Enabled=state end})
ragebotMainSection:new_toggle({name="Rapid Fire",state=false,flag="ragebot_rapidfire",callback=function(state) getgenv().CONFIG.Ragebot.RapidFire=state end})
ragebotMainSection:new_toggle({name="Hit Sound",state=true,flag="ragebot_hitsound",callback=function(state) getgenv().CONFIG.Ragebot.HitSound=state end})
ragebotMainSection:new_toggle({name="Auto Reload",state=true,flag="ragebot_autoreload",callback=function(state) getgenv().CONFIG.Ragebot.AutoReload=state end})
ragebotMainSection:new_slider({name="Fire Rate",min=1,max=1000,default=30,text="[value] RPS",flag="ragebot_firerate",callback=function(value) getgenv().CONFIG.Ragebot.FireRate=value end})
ragebotMainSection:new_slider({name="Shoot Range",min=1,max=30,default=15,text="[value]",flag="ragebot_shootrange",callback=function(value) getgenv().CONFIG.Ragebot.ShootRange=value end})
ragebotMainSection:new_slider({name="Hit Range",min=1,max=30,default=15,text="[value]",flag="ragebot_hitrange",callback=function(value) getgenv().CONFIG.Ragebot.HitRange=value end})
ragebotMainSection:new_listbox({name="Hit Sound",options={"Bameware","Bell","Bubble","Pick","Pop","Rust","Sans","Fart","Big","Vine","Bruh","Skeet","Neverlose","Fatality","Bonk","Minecraft"},default="Skeet",multiple=false,flag="ragebot_hitsoundlist",callback=function(value) getgenv().CONFIG.Ragebot.SelectedHitSound=value end})

local targetingSection = ragebotPage:new_section({name="Targeting",side="right",size=250})
targetingSection:new_toggle({name="Team Check",state=false,flag="ragebot_teamcheck",callback=function(state) getgenv().CONFIG.Ragebot.TeamCheck=state end})
targetingSection:new_toggle({name="Visibility Check",state=true,flag="ragebot_visibilitycheck",callback=function(state) getgenv().CONFIG.Ragebot.VisibilityCheck=state end})
targetingSection:new_toggle({name="Wallbang",state=true,flag="ragebot_wallbang",callback=function(state) getgenv().CONFIG.Ragebot.Wallbang=state end})
targetingSection:new_toggle({name="Downed Check",state=false,flag="ragebot_downcheck",callback=function(state) getgenv().CONFIG.Ragebot.LowHealthCheck=state end})
targetingSection:new_toggle({name="Friend Check",state=false,flag="ragebot_friendcheck",callback=function(state) getgenv().CONFIG.Ragebot.FriendCheck=state end})
--targetingSection:new_slider({name="Max Target",min=0,max=20,default=0,text="[value] players",flag="ragebot_maxtarget",callback=function(value) getgenv().CONFIG.Ragebot.MaxTarget=value end})

local aimSection = ragebotPage:new_section({name="Aim Settings",side="left",size=200})
aimSection:new_toggle({name="Prediction",state=true,flag="ragebot_prediction",callback=function(state) getgenv().CONFIG.Ragebot.Prediction=state end})
aimSection:new_slider({name="Prediction Amount",min=0.05,max=0.3,default=0.12,text="[value]",flag="ragebot_predictionamount",callback=function(value) getgenv().CONFIG.Ragebot.PredictionAmount=value end})

local visualsSection = ragebotPage:new_section({name="Tracers",side="right",size=200})
local tracersToggle = visualsSection:new_toggle({name="Tracers",state=true,flag="ragebot_tracers",callback=function(state) getgenv().CONFIG.Ragebot.Tracers=state end})
tracersToggle:new_colorpicker({default=Color3.fromRGB(255,0,0),flag="ragebot_tracercolor",callback=function(color) getgenv().CONFIG.Ragebot.TracerColor=color end})
visualsSection:new_slider({name="Tracer Width",min=0.1,max=5,default=1,text="[value] width",flag="ragebot_tracerwidth",callback=function(value) getgenv().CONFIG.Ragebot.TracerWidth=value end})
visualsSection:new_slider({name="Tracer Lifetime",min=0.5,max=100,default=3,text="[value] time",flag="ragebot_tracerlife",callback=function(value) getgenv().CONFIG.Ragebot.TracerLifetime=value end})

local colorsSection = ragebotPage:new_section({name="Notifications",side="left",size=200})
local hitNotifyToggle = colorsSection:new_toggle({name="Hit Notify",state=true,flag="ragebot_hitnotify",callback=function(state) getgenv().CONFIG.Ragebot.HitNotify=state end})
hitNotifyToggle:new_colorpicker({default=Color3.fromRGB(255,182,193),flag="ragebot_hitcolor",callback=function(color) getgenv().CONFIG.Ragebot.HitColor=color end})
colorsSection:new_slider({name="Hit Notify Duration",min=1,max=10,default=5,text="[value]s",flag="ragebot_hitduration",callback=function(value) getgenv().CONFIG.Ragebot.HitNotifyDuration=value end})

--local fovSection = ragebotPage:new_section({name="FOV Settings",side="right",size=150})
--fovSection:new_toggle({name="Show FOV",state=false,flag="ragebot_showfov",callback=function(state) getgenv().CONFIG.Ragebot.ShowFOV=state end})
--fovSection:new_slider({name="FOV Size",min=10,max=,default=9e9,text="[value]",flag="ragebot_fovsize",callback=function(value) getgenv().CONFIG.Ragebot.FOV=value end})
local legitPage=window:new_page({name="Legit"})
local legitSection=legitPage:new_section({name="Legit Settings",side="left",size=350})
legitSection:new_toggle({name="Enable",state=false,flag="legit_enable",callback=function(state)getgenv().Legit.Enabled=state end})
legitSection:new_slider({name="Head Chance",min=0,max=100,default=30,text="[value]%",flag="legit_headchance",callback=function(value)getgenv().Legit.HeadChance=value end})
legitSection:new_listbox({name="Hit Part",options={"Head","Torso","Neck","Random"},default="Torso",multiple=false,flag="legit_hitpart",callback=function(selection)getgenv().Legit.HitPart=selection end})
legitSection:new_toggle({name="No Recoil",state=true,flag="legit_norecoil",callback=function(state)getgenv().Legit.NoRecoil=state apply_no_recoil() end})
legitSection:new_toggle({name="Aim Assist",state=false,flag="legit_aimassist",callback=function(state)getgenv().Legit.AimAssist=state end})
legitSection:new_slider({name="Assist Strength",min=0.1,max=1.0,default=0.3,float=0.1,text="[value]",flag="legit_assiststrength",callback=function(value)getgenv().Legit.AimAssistStrength=value end})
legitSection:new_slider({name="Smoothing",min=0.1,max=0.8,default=0.2,float=0.05,text="[value]",flag="legit_smoothing",callback=function(value)getgenv().Legit.Smoothing=value end})
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) if getgenv().Legit.NoRecoil then apply_no_recoil() end end)
LocalPlayer.Backpack.ChildAdded:Connect(function(tool) task.wait(0.1) if getgenv().Legit.NoRecoil then apply_no_recoil() end end)

local miscPage=window:new_page({name="Miscellaneous"})
local movementSection=miscPage:new_section({name="Movement",side="left",size=250})
local visualSection=miscPage:new_section({name="Visual",side="right",size=250})
local otherSection=miscPage:new_section({name="Other",side="left",size=200})
local safeESPSection=miscPage:new_section({name="Safe ESP",side="right",size=200})

movementSection:new_toggle({name="Speed",state=false,flag="misc_speed",callback=function(state)misc.toggleSpeed(state) end})
movementSection:new_slider({name="Speed Value",min=10,max=200,default=50,text="[value]",flag="misc_speedvalue",callback=function(value)misc.setSpeedValue(value) end})
movementSection:new_toggle({name="Jump Power",state=false,flag="misc_jumppower",callback=function(state)misc.toggleJumpPower(state) end})
movementSection:new_slider({name="Jump Power Value",min=50,max=300,default=100,text="[value]",flag="misc_jumpvalue",callback=function(value)misc.setJumpValue(value) end})
movementSection:new_toggle({name="Fly",state=false,flag="misc_fly",callback=function(state)misc.toggleFly(state) end})
movementSection:new_slider({name="Fly Speed",min=10,max=200,default=50,text="[value]",flag="misc_flyspeed",callback=function(value)misc.setFlySpeed(value) end})

visualSection:new_toggle({name="Loop FOV",state=false,flag="misc_loopfov",callback=function(state)misc.toggleLoopFOV(state) end})
visualSection:new_toggle({name="Hide Head",state=false,flag="misc_hidehead",callback=function(state)misc.toggleHideHead(state) end})

otherSection:new_toggle({name="Inf Stamina",state=false,flag="misc_infstamina",callback=function(state)misc.toggleInfStamina(state) end})
otherSection:new_toggle({name="No Fall Damage",state=false,flag="misc_nofall",callback=function(state)misc.toggleNoFall(state) end})
otherSection:new_toggle({name="No Fail Lockpick",state=false,flag="misc_lockpick",callback=function(state)misc.toggleLockpick(state) end})
otherSection:new_toggle({name="Instant Prompt",state=false,flag="misc_instantprompt",callback=function(state)misc.toggleInstantPrompt(state) end})
otherSection:new_toggle({name="Auto Door",state=false,flag="misc_autodoor",callback=function(state)misc.toggleAutoDoor(state) end})

local safeESPToggle=safeESPSection:new_toggle({name="Enable Safe ESP",state=false,flag="misc_safeesp",callback=function(state)misc.toggleSafeESP(state) end})
safeESPToggle:new_colorpicker({default=Color3.fromRGB(255,215,0),flag="misc_safecolor",callback=function(color)misc.updateSafeColor(color) end})

local playersPage=window:new_page({name="Players"})
local leftSection=playersPage:new_section({name="Players",side="left",size=500})
local playersBox=leftSection:new_listbox({name="Online Players",options={},default={},multiple=true,size=200,flag="players_box",callback=function(selected) getgenv().selectedPlayersTable=selected or {} end})
for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then playersBox:add_option(player.Name) end end
Players.PlayerAdded:Connect(function(player) if player~=LocalPlayer then playersBox:add_option(player.Name) end end)
Players.PlayerRemoving:Connect(function(player) playersBox:remove_option(player.Name) end)
leftSection:new_button({name="Add to Target",callback=function()
    local selected=getgenv().selectedPlayersTable or {}
    for _,name in ipairs(selected) do
        local found=false
        for _,target in ipairs(getgenv().Lists.TargetList) do if target==name then found=true break end end
        if not found then table.insert(getgenv().Lists.TargetList,name) end
    end
end})
leftSection:new_button({name="Add to Whitelist",callback=function()
    local selected=getgenv().selectedPlayersTable or {}
    for _,name in ipairs(selected) do
        local found=false
        for _,wl in ipairs(getgenv().Lists.Whitelist) do if wl==name then found=true break end end
        if not found then table.insert(getgenv().Lists.Whitelist,name) end
    end
end})
leftSection:new_button({name="Remove Target",callback=function()
    local selected=getgenv().selectedPlayersTable or {}
    for _,name in ipairs(selected) do
        for i=#getgenv().Lists.TargetList,1,-1 do if getgenv().Lists.TargetList[i]==name then table.remove(getgenv().Lists.TargetList,i) end end
    end
end})
leftSection:new_button({name="Remove Whitelist",callback=function()
    local selected=getgenv().selectedPlayersTable or {}
    for _,name in ipairs(selected) do
        for i=#getgenv().Lists.Whitelist,1,-1 do if getgenv().Lists.Whitelist[i]==name then table.remove(getgenv().Lists.Whitelist,i) end end
    end
end})
leftSection:new_button({name="Clear Targets",callback=function() getgenv().Lists.TargetList={} end})
leftSection:new_button({name="Clear Whitelist",callback=function() getgenv().Lists.Whitelist={} end})
local targetCount=leftSection:new_label({name="Targets: 0"})
local whitelistCount=leftSection:new_label({name="Whitelist: 0"})
task.spawn(function() while task.wait(1) do targetCount:set("Targets: "..#getgenv().Lists.TargetList) whitelistCount:set("Whitelist: "..#getgenv().Lists.Whitelist) end end)

local controlSection=playersPage:new_section({name="Controls",side="left",size=150})
controlSection:new_toggle({name="Use Target List",state=false,flag="use_target_list",callback=function(state)getgenv().CONFIG.Ragebot.UseTargetList=state end})
controlSection:new_toggle({name="Use Whitelist",state=false,flag="use_whitelist",callback=function(state)getgenv().CONFIG.Ragebot.UseWhitelist=state end})

local rightSection=playersPage:new_section({name="Misc",side="right",size=325})
local selectedName=rightSection:new_label({name="Selected: None"})
local playerTeam=rightSection:new_label({name="Team: -"})
local playerHealth=rightSection:new_label({name="Health: -"})
local playerDistance=rightSection:new_label({name="Distance: -"})
local playerStatus=rightSection:new_label({name="Status: -"})
RunService.RenderStepped:Connect(function()
    local selected=getgenv().selectedPlayersTable or {}
    local name=selected[1]
    if not name then selectedName:set("Selected: None") playerTeam:set("Team: -") playerHealth:set("Health: -") playerDistance:set("Distance: -") playerStatus:set("Status: -") return end
    local player=Players:FindFirstChild(name)
    if not player then selectedName:set("Selected: "..name.." (Off)") playerTeam:set("Team: -") playerHealth:set("Health: -") playerDistance:set("Distance: -") playerStatus:set("Status: Offline") return end
    selectedName:set("Selected: "..player.Name)
    if player.Team then playerTeam:set("Team: "..tostring(player.Team)) else playerTeam:set("Team: None") end
    local char=player.Character
    if char then
        local hum=char:FindFirstChild("Humanoid")
        if hum then playerHealth:set(string.format("Health: %d/%d",math.floor(hum.Health),math.floor(hum.MaxHealth))) else playerHealth:set("Health: -") end
        local myChar=LocalPlayer.Character
        local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
        local theirRoot=char:FindFirstChild("HumanoidRootPart")
        if myRoot and theirRoot then local dist=(myRoot.Position-theirRoot.Position).Magnitude playerDistance:set(string.format("Distance: %d",math.floor(dist))) else playerDistance:set("Distance: -") end
        playerStatus:set("Status: Alive")
    else playerHealth:set("Health: -") playerDistance:set("Distance: -") playerStatus:set("Status: Dead") end
end)

local bulletTracersEnabled=false
local tracerColor=Color3.fromRGB(255,50,50)
local tracerWidth=0.2
local tracerLifetime=1
local camera=Workspace.CurrentCamera
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
    local bfr=camera:FindFirstChild("Bullets")
    if not bfr then bfr=Instance.new("Folder") bfr.Name="Bullets" bfr.Parent=camera end
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
local bulletTracerToggle=rightSection:new_toggle({name="Players bullet Tracers",state=false,flag="bullet_tracers_enabled",callback=function(state) bulletTracersEnabled=state if state then trackGlobalBullets() end end})
bulletTracerToggle:new_colorpicker({default=Color3.fromRGB(255,50,50),flag="tracer_color",callback=function(color) tracerColor=color end})
rightSection:new_slider({name="Tracer Width",min=1,max=5,default=2,text="[value]",flag="tracer_width",callback=function(value) tracerWidth=value/1 end})
rightSection:new_slider({name="Tracer Lifetime",min=1,max=100,default=10,text="[value]",flag="tracer_lifetime",callback=function(value) tracerLifetime=value/5 end})

local library={directory="Nebula/",folders={"fonts","configs","logs"},flags={},config_flags={},notifications={}}
library.__index=library
setmetatable(library,library)
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
for _,path in next,library.folders do makefolder(library.directory..path) end
local flags=library.flags
local config_flags=library.config_flags
local notifications=library.notifications
if isfile(library.directory.."/fonts/main.ttf") then delfile(library.directory.."/fonts/main.ttf") end
writefile(library.directory.."/fonts/main.ttf",game:HttpGet("https://github.com/f1nobe7650/Nebula/raw/refs/heads/main/Minecraftia-Regular.ttf"))
local minecraftia={name="Minecraftia",faces={{name="Regular",weight=400,style="normal",assetId=getcustomasset(library.directory.."/fonts/main.ttf")}}}
if not isfile(library.directory.."/fonts/main_encoded.ttf") then writefile(library.directory.."/fonts/main_encoded.ttf",HttpService:JSONEncode(minecraftia)) end
library.font=Font.new(getcustomasset(library.directory.."/fonts/main_encoded.ttf"),Enum.FontWeight.Regular)
local MAX_DISTANCE=1000
local BILLBOARD_OFFSET=Vector3.new(0,3,0)
local espBillboards={}
local characterCache={}
local playerConnections={}
local visualPage=window:new_page({name="Visual"})
local espSection=visualPage:new_section({name="ESP Settings",side="left",size=250})
local espToggle=espSection:new_toggle({name="Enable ESP",state=true,flag="esp_enabled",callback=function(state) library.flags.esp_enabled=state end})
local espColor=espToggle:new_colorpicker({default=Color3.fromRGB(255,50,50),flag="esp_maincolor",callback=function(color) library.flags.esp_maincolor=color end})
local maxDistanceSlider=espSection:new_slider({name="Max Distance",min=100,max=5000,default=1000,text="[value] studs",flag="esp_maxdistance",callback=function(value) library.flags.esp_maxdistance=value end})
local teamCheckToggle=espSection:new_toggle({name="Team Check",state=false,flag="esp_teamcheck",callback=function(state) library.flags.esp_teamcheck=state end})
local whitelistColorToggle=espSection:new_toggle({name="Whitelist Color",state=true,flag="esp_usewhitelistcolor",callback=function(state) library.flags.esp_usewhitelistcolor=state end})
local whitelistColor=whitelistColorToggle:new_colorpicker({default=Color3.fromRGB(50,255,50),flag="esp_whitelistcolor",callback=function(color) library.flags.esp_whitelistcolor=color end})
local targetlistColorToggle=espSection:new_toggle({name="Targetlist Color",state=true,flag="esp_usetargetlistcolor",callback=function(state) library.flags.esp_usetargetlistcolor=state end})
local targetlistColor=targetlistColorToggle:new_colorpicker({default=Color3.fromRGB(255,50,255),flag="esp_targetlistcolor",callback=function(color) library.flags.esp_targetlistcolor=color end})
local espSettingsSection=visualPage:new_section({name="ESP Features",side="right",size=200})
espSettingsSection:new_toggle({name="Show Distance",state=true,flag="esp_showdistance",callback=function(state) library.flags.esp_showdistance=state end})
espSettingsSection:new_toggle({name="Show Health",state=true,flag="esp_showhealth",callback=function(state) library.flags.esp_showhealth=state end})
espSettingsSection:new_toggle({name="Dynamic Scaling",state=true,flag="esp_dynamicscaling",callback=function(state) library.flags.esp_dynamicscaling=state end})
local function getPlayerColor(player)
    local targetList=getgenv().Lists.TargetList or {}
    local whitelist=getgenv().Lists.Whitelist or {}
    if table.find(targetList,player.Name) and library.flags.esp_usetargetlistcolor then return library.flags.esp_targetlistcolor end
    if table.find(whitelist,player.Name) and library.flags.esp_usewhitelistcolor then return library.flags.esp_whitelistcolor end
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
    billboard.StudsOffset=BILLBOARD_OFFSET
    billboard.Adornee=nil
    billboard.Enabled=false
    billboard.MaxDistance=library.flags.esp_maxdistance or MAX_DISTANCE
    local frame=Instance.new("Frame")
    frame.Name="Container"
    frame.BackgroundTransparency=1
    frame.Size=UDim2.new(1,0,1,0)
    frame.Parent=billboard
    if Camera then billboard.Parent=Camera end
    espBillboards[player]=billboard
    characterCache[player]=player.Character
    if playerConnections[player] then for _,connection in ipairs(playerConnections[player]) do connection:Disconnect() end end
    playerConnections[player]={}
    local charAddedConnection=player.CharacterAdded:Connect(function(character)
        characterCache[player]=character
        task.wait(1)
        if espBillboards[player] then updateESPBillboard(player,character) end
    end)
    local charRemovingConnection=player.CharacterRemoving:Connect(function()
        characterCache[player]=nil
        if espBillboards[player] then espBillboards[player].Enabled=false espBillboards[player].Adornee=nil end
    end)
    table.insert(playerConnections[player],charAddedConnection)
    table.insert(playerConnections[player],charRemovingConnection)
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
    local maxDistance=library.flags.esp_maxdistance or MAX_DISTANCE
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
        distanceLabel.Text="("..math.floor(distance)..")"
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
    if playerConnections[player] then for _,connection in ipairs(playerConnections[player]) do connection:Disconnect() end playerConnections[player]=nil end
    characterCache[player]=nil
end
task.spawn(function() task.wait(2) for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then onPlayerAdded(player) end end end)
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
LocalPlayer.CharacterRemoving:Connect(function()
    for player,billboard in pairs(espBillboards) do if billboard and billboard.Parent then billboard:Destroy() end end
    espBillboards={}
    characterCache={}
    playerConnections={}
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

local richSection=visualPage:new_section({name="Rich Shader",side="left",size=250})
local richShaderEnabled=false
local richColor=Color3.fromRGB(255,200,150)
local richBrightness=20
local richContrast=50
local richSaturation=150
local richShaderToggle=richSection:new_toggle({name="Rich Shader",state=false,flag="rich_shader",callback=function(state)
    richShaderEnabled=state
    if state then
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
local richColorPicker=richShaderToggle:new_colorpicker({default=Color3.fromRGB(255,200,150),flag="rich_shader_color",callback=function(color)
    richColor=color
    if richShaderEnabled then local lighting=game:GetService("Lighting") local effect=lighting:FindFirstChild("RichShaderEffect") if effect then effect.TintColor=color end end
end})
richSection:new_slider({name="Brightness",min=0,max=100,default=20,text="[value]%",flag="rich_brightness",callback=function(value)
    richBrightness=value
    if richShaderEnabled then local lighting=game:GetService("Lighting") local effect=lighting:FindFirstChild("RichShaderEffect") if effect then effect.Brightness=value/100 end end
end})
richSection:new_slider({name="Contrast",min=0,max=100,default=50,text="[value]%",flag="rich_contrast",callback=function(value)
    richContrast=value
    if richShaderEnabled then local lighting=game:GetService("Lighting") local effect=lighting:FindFirstChild("RichShaderEffect") if effect then effect.Contrast=value/100 end end
end})
richSection:new_slider({name="Saturation",min=0,max=200,default=150,text="[value]%",flag="rich_saturation",callback=function(value)
    richSaturation=value
    if richShaderEnabled then local lighting=game:GetService("Lighting") local effect=lighting:FindFirstChild("RichShaderEffect") if effect then effect.Saturation=value/100 end end
end})

local richPlayerSection=visualPage:new_section({name="Rich Player",side="right",size=250})
local richPlayerEnabled=false
local richPlayerColor=Color3.fromRGB(255,255,255)
local richPlayerTransparency=0
local originalPlayerProperties={}
local originalPlayerMaterials={}
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
local richPlayerToggle=richPlayerSection:new_toggle({name="Rich Player",state=false,flag="rich_player",callback=function(state)
    richPlayerEnabled=state
    if state then if LocalPlayer.Character then applyRichPlayer() end else if LocalPlayer.Character then resetRichPlayer() end end
end})
local richPlayerColorPicker=richPlayerToggle:new_colorpicker({default=Color3.fromRGB(255,255,255),flag="rich_player_color",callback=function(color)
    richPlayerColor=color
    if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end
end})
richPlayerSection:new_slider({name="Transparency",min=0,max=100,default=0,text="[value]%",flag="rich_transparency",callback=function(value)
    richPlayerTransparency=value
    if richPlayerEnabled and LocalPlayer.Character then applyRichPlayer() end
end})
LocalPlayer.CharacterAdded:Connect(function() if richPlayerEnabled then applyRichPlayer() end end)

local runService=game:GetService("RunService")
local noclipEnabled=false
local noclipConnection
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
    noclipConnection=runService.Stepped:Connect(function()
        if not noclipEnabled or not character or not character.Parent then stopNoclip() return end
        for _,part in pairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end
    end)
end
movementSection:new_toggle({name="Noclip",state=false,flag="noclip_enabled",callback=function(state)
    noclipEnabled=state
    if state then startNoclip() else stopNoclip() end
end})

getgenv().Lists={TargetList={},Whitelist={}}
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local localPlayer=Players.LocalPlayer
local espFolder=Instance.new("Folder")
espFolder.Name="ChamsESPFolder"
espFolder.Parent=Workspace
local espParts={}
local connections={}
local playerConnections={}
local viewModel=Workspace.CurrentCamera:FindFirstChild("ViewModel")
local ChamsConfig={PlayerChams={Enabled=false,OuterColor=Color3.fromRGB(255,255,255),InnerColor=Color3.fromRGB(0,0,0),TeamCheck=false,UseWhitelistColor=false,WhitelistColor=Color3.fromRGB(50,255,50),UseTargetlistColor=false,TargetlistColor=Color3.fromRGB(255,50,255)},ArmChams={Enabled=false,Transparency=0.5,Color=Color3.fromRGB(255,255,255),OriginalTransparency={},OriginalColor={},OriginalMaterial={}},ToolChams={Enabled=false,Transparency=0.5,Color=Color3.fromRGB(255,255,255),OriginalTransparency={},OriginalColor={},OriginalMaterial={}}}
local function getPlayerColor(player)
    local targetList=getgenv().Lists.TargetList or {}
    local whitelist=getgenv().Lists.Whitelist or{}
    if ChamsConfig.PlayerChams.UseTargetlistColor and table.find(targetList,player.Name) then return ChamsConfig.PlayerChams.TargetlistColor end
    if ChamsConfig.PlayerChams.UseWhitelistColor and table.find(whitelist,player.Name) then return ChamsConfig.PlayerChams.WhitelistColor end
    return ChamsConfig.PlayerChams.OuterColor
end
local function createPlayerBox(character,player)
    if not ChamsConfig.PlayerChams.Enabled then return end
    if ChamsConfig.PlayerChams.TeamCheck and localPlayer.Team and player.Team and localPlayer.Team==player.Team then return end
    local boxes={}
    local playerColor=getPlayerColor(player)
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
                local playerColor=getPlayerColor(player)
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
local function onCharacterAdded(character,player) wait(1) if ChamsConfig.PlayerChams.Enabled then createPlayerBox(character,player) end end
local function onPlayerAdded(player)
    if player==localPlayer then return end
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
local function onPlayerRemoving(player)
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
    for _,player in ipairs(Players:GetPlayers()) do if player~=localPlayer then onPlayerAdded(player) end end
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
    local currentTool=localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
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
    local currentTool=localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
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

local playerSection=visualPage:new_section({name="Player Chams",side="left",size=300})
local playerChamsToggle=playerSection:new_toggle({name="Enable Player Chams",state=false,flag="player_chams_enable",callback=function(state)
    ChamsConfig.PlayerChams.Enabled=state
    if state then enablePlayerChams() else disablePlayerChams() end
end})
local outerColor=playerChamsToggle:new_colorpicker({default=Color3.fromRGB(255,255,255),flag="player_chams_outercolor",callback=function(color)
    ChamsConfig.PlayerChams.OuterColor=color
    updatePlayerBoxColors()
end})
local innerColor=playerChamsToggle:new_colorpicker({default=Color3.fromRGB(0,0,0),flag="player_chams_innercolor",callback=function(color)
    ChamsConfig.PlayerChams.InnerColor=color
    updatePlayerBoxColors()
end})
playerSection:new_toggle({name="Team Check",state=false,flag="player_chams_teamcheck",callback=function(state)
    ChamsConfig.PlayerChams.TeamCheck=state
    if ChamsConfig.PlayerChams.Enabled then disablePlayerChams() enablePlayerChams() end
end})
local whitelistToggle=playerSection:new_toggle({name="Use Whitelist Color",state=false,flag="chams_whitelist_toggle",callback=function(state)
    ChamsConfig.PlayerChams.UseWhitelistColor=state
    updatePlayerBoxColors()
end})
local whitelistColor=whitelistToggle:new_colorpicker({name="Whitelist Color",default=Color3.fromRGB(50,255,50),flag="chams_whitelist_color",callback=function(color)
    ChamsConfig.PlayerChams.WhitelistColor=color
    updatePlayerBoxColors()
end})
local targetlistToggle=playerSection:new_toggle({name="Use Targetlist Color",state=false,flag="chams_targetlist_toggle",callback=function(state)
    ChamsConfig.PlayerChams.UseTargetlistColor=state
    updatePlayerBoxColors()
end})
local targetlistColor=targetlistToggle:new_colorpicker({name="Targetlist Color",default=Color3.fromRGB(255,50,255),flag="chams_targetlist_color",callback=function(color)
    ChamsConfig.PlayerChams.TargetlistColor=color
    updatePlayerBoxColors()
end})

local armsSection=visualPage:new_section({name="Arms Chams",side="right",size=300})
local armsToggle=armsSection:new_toggle({name="Enable Arms Chams",state=false,flag="arms_chams_enable",callback=function(state)
    ChamsConfig.ArmChams.Enabled=state
    if state then applyForcefieldToArms() else removeForcefieldFromArms() end
end})
armsSection:new_slider({name="Arms Transparency",min=0,max=1,default=0.5,float=0.1,text="[value]",flag="arms_chams_transparency",callback=function(value)
    ChamsConfig.ArmChams.Transparency=value
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
end})
local armsColor=armsToggle:new_colorpicker({default=Color3.fromRGB(255,255,255),flag="arms_chams_color",callback=function(color)
    ChamsConfig.ArmChams.Color=color
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
end})

local toolSection=visualPage:new_section({name="Tool Chams",side="left",size=300})
local toolToggle=toolSection:new_toggle({name="Enable Tool Chams",state=false,flag="tool_chams_enable",callback=function(state)
    ChamsConfig.ToolChams.Enabled=state
    if state then applyForcefieldToTool() else removeForcefieldFromTool() end
end})
toolSection:new_slider({name="Tool Transparency",min=0,max=1,default=0.5,float=0.1,text="[value]",flag="tool_chams_transparency",callback=function(value)
    ChamsConfig.ToolChams.Transparency=value
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
end})
local toolColor=toolToggle:new_colorpicker({default=Color3.fromRGB(255,255,255),flag="tool_chams_color",callback=function(color)
    ChamsConfig.ToolChams.Color=color
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
end})

RunService.RenderStepped:Connect(function()
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() else removeForcefieldFromArms() end
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() else removeForcefieldFromTool() end
end)
localPlayer.CharacterAdded:Connect(onLocalPlayerCharacterAdded)
localPlayer.CharacterRemoving:Connect(onLocalPlayerCharacterRemoving)
localPlayer.Backpack.ChildAdded:Connect(function() task.wait(0.1) if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end end)
local updateConnection=RunService.RenderStepped:Connect(function() if ChamsConfig.PlayerChams.Enabled then updatePlayerBoxes() end end)
Players.PlayerAdded:Connect(function(player) if player~=localPlayer and ChamsConfig.PlayerChams.Enabled then onPlayerAdded(player) end end)
Players.PlayerRemoving:Connect(onPlayerRemoving)
game:GetService("UserInputService").InputBegan:Connect(function(input,gameProcessed)
    if not gameProcessed and input.KeyCode==Enum.KeyCode.RightControl then
        ChamsConfig.PlayerChams.Enabled=not ChamsConfig.PlayerChams.Enabled
        if ChamsConfig.PlayerChams.Enabled then enablePlayerChams() else disablePlayerChams() end
    end
end)
task.spawn(function()
    wait(1)
    if localPlayer.Character and ChamsConfig.PlayerChams.Enabled then enablePlayerChams() end
    if ChamsConfig.ArmChams.Enabled then applyForcefieldToArms() end
    if ChamsConfig.ToolChams.Enabled then applyForcefieldToTool() end
end)

local configPage=window:new_page({name="Configuration"})
local saveSection=configPage:new_section({name="config",side="left",size=450})
local Section=configPage:new_section({name="setting",side="right",size=500})
local configNameTextbox=saveSection:new_textbox({name="Config Name",placeholder="enter config name",default="",flag="config_name",callback=function(text) getgenv().currentConfigName=text end})
saveSection:new_button({name="Save Config",callback=function()
    if writefile then
        local configData={}
        for flag,value in pairs(library.flags) do if type(value)~="function" then configData[flag]=value end end
        writefile("aui_config.json",game:GetService("HttpService"):JSONEncode(configData))
        warn("Configuration saved!")
    else warn("Writefile not supported") end
end})
saveSection:new_button({name="Load Config",callback=function()
    if isfile("aui_config.json") then
        local file=readfile("aui_config.json")
        local config=game:GetService("HttpService"):JSONDecode(file)
        for flag,value in pairs(config) do
            if library.flags[flag] then
                if type(library.flags[flag])=="function" then library.flags[flag](value) else library.flags[flag]=value end
            end
        end
        warn("Configuration loaded!")
    else warn("Config file not found") end
end})
saveSection:new_button({name="Reset to Default",callback=function()
    local defaultValues={Enabled=false,State=false,Value=0,Amount=0,Range=0,Color=Color3.fromRGB(255,0,0),Text="",Selected=nil}
    for flag,value in pairs(library.flags) do
        if type(value)=="function" then
            for key,defaultValue in pairs(defaultValues) do
                if flag:find(key) then value(defaultValue) break end
            end
        end
    end
    warn("Configuration reset to default!")
end})
saveSection:new_button({name="Save as Preset",callback=function()
    if writefile and getgenv().currentConfigName then
        local name=getgenv().currentConfigName
        if name~="" then
            local configData={}
            for flag,value in pairs(library.flags) do if type(value)~="function" then configData[flag]=value end end
            writefile("aui_preset_"..name..".json",game:GetService("HttpService"):JSONEncode(configData))
            warn("Preset saved as: "..name)
        end
    end
end})
saveSection:new_button({name="Delete Preset",callback=function()
    if delfile and getgenv().currentConfigName then
        local name=getgenv().currentConfigName
        if name~="" then
            local filename="aui_preset_"..name..".json"
            if isfile(filename) then delfile(filename) warn("Preset deleted: "..name) end
        end
    end
end})
saveSection:new_button({name="Refresh Presets",callback=function()
    local children={}
    for _,child in pairs(listSection.section_content:GetChildren()) do if child.Name:find("PresetButton_") then table.insert(children,child) end end
    for _,child in ipairs(children) do child:Destroy() end
    for _,file in pairs(listfiles("")) do
        if file:find("aui_preset_") and file:find("%.json$") then
            local name=file:match("aui_preset_(.+)%.json")
            local presetButton=listSection:new_button({name="Load: "..name,callback=function()
                local file=readfile(file)
                local config=game:GetService("HttpService"):JSONDecode(file)
                for flag,value in pairs(config) do
                    if library.flags[flag] then
                        if type(library.flags[flag])=="function" then library.flags[flag](value) else library.flags[flag]=value end
                    end
                end
                warn("Preset loaded: "..name)
            end})
            presetButton.Name="PresetButton_"..name
        end
    end
end})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CurrentCharacter = LocalPlayer.Character
local Head = CurrentCharacter and CurrentPlayer.Character:FindFirstChild("Head")
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
