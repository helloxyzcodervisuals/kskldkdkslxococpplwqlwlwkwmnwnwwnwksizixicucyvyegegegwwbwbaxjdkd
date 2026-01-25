local function vc()
    local v2="Font_"..tostring(math.random(10000,99999))
    local v24="Folder_"..tostring(math.random(10000,99999))
    if isfolder("UI_Fonts")then delfolder("UI_Fonts")end
    makefolder(v24)
    local v3=v24.."/"..v2..".ttf"
    local v4=v24.."/"..v2..".json"
    local v5=v24.."/"..v2..".rbxmx"
    if not isfile(v3)then
        local v8=pcall(function()
            local v9=request({Url="https://raw.githubusercontent.com/bluescan/proggyfonts/refs/heads/master/ProggyOriginal/ProggyClean.ttf",Method="GET"})
            if v9 and v9.Success then writefile(v3,v9.Body)return true end
            return false
        end)
        if not v8 then return Font.fromEnum(Enum.Font.Code)end
    end
    local v12=pcall(function()
        local v13=readfile(v3)
        local v14=game:GetService("TextService"):RegisterFontFaceAsync(v13,v2)
        return v14
    end)
    if v12 then return v12 end
    local v15=pcall(function()return Font.fromFilename(v3)end)
    if v15 then return v15 end
    local v16={name=v2,faces={{name="Regular",weight=400,style="Normal",assetId=getcustomasset(v3)}}}
    writefile(v4,game:GetService("HttpService"):JSONEncode(v16))
    local v17,v18=pcall(function()return Font.new(getcustomasset(v4))end)
    if v17 then return v18 end
    local v19=[[
<?xml version="1.0" encoding="utf-8"?>
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
<External>null</External>
<External>nil</External>
<Item class="FontFace" referent="RBX0">
<Properties>
<Content name="FontData">
<url>rbxasset://]]..v3..[[</url>
</Content>
<string name="Family">]]..v2..[[</string>
<token name="Style">0</token>
<token name="Weight">400</token>
</Properties>
</Item>
</roblox>]]
    writefile(v5,v19)
    return Font.fromEnum(Enum.Font.Code)
end
local UI_FONT=vc()
local HttpService=game:GetService("HttpService")

local settings={
    folder_name="zephyrus",
    default_accent=Color3.fromRGB(255, 182, 193)  -- why
}

if not isfolder(settings.folder_name)then
    makefolder(settings.folder_name)
    makefolder(settings.folder_name.."/configs")
    makefolder(settings.folder_name.."/assets")
end

local services={
    Players=game:GetService("Players"),
    RunService=game:GetService("RunService"),
    UserInputService=game:GetService("UserInputService"),
    TweenService=game:GetService("TweenService"),
    CoreGui=game:GetService("CoreGui"),
    ContextActionService=game:GetService("ContextActionService")
}

local client=services.Players.LocalPlayer
local utility={}
local totalunnamedflags=0

function utility.create(class,properties)
    local obj=Instance.new(class)
    for prop,v in next,properties do
        if type(v)=="function"then
            if obj:IsA("TextButton") and prop=="MouseButton1Click" then
                obj.MouseButton1Click:Connect(v)
            elseif obj:IsA("TextButton") and prop=="MouseButton1Down" then
                obj.MouseButton1Down:Connect(v)
            elseif obj:IsA("TextButton") and prop=="MouseButton1Up" then
                obj.MouseButton1Up:Connect(v)
            else
                obj[prop]:Connect(v)
            end
        else
            pcall(function()
                if prop=="Font"then
                    obj.FontFace=v
                else
                    obj[prop]=v
                end
            end)
        end
    end
    return obj
end

function utility.createTextButton(properties)
    local button=utility.create("TextButton",properties)
    return button
end

function utility.createFrame(properties)
    local frame=utility.create("Frame",properties)
    return frame
end

function utility.textlength(str,font,fontsize)
    local text=Instance.new("TextLabel")
    text.Text=str
    text.FontFace=font
    text.TextSize=fontsize
    text.Size=UDim2.new(0,1000,0,100)
    text.Parent=services.CoreGui
    
    local textbounds=text.TextBounds
    text:Destroy()
    
    return textbounds
end

function utility.dragify(frame,dragPart)
    local dragging=false
    local dragStart
    local startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=input.Position
            startPos=dragPart.Position
            
            local connection
            connection=services.UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                    local delta=input.Position-dragStart
                    dragPart.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
                end
            end)
            
            local endConnection
            endConnection=services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    dragging=false
                    if connection then connection:Disconnect() end
                    if endConnection then endConnection:Disconnect() end
                end
            end)
        end
    end)
end

function utility.getcenter(sizeX,sizeY)
    local screenSize=services.CoreGui.AbsoluteSize
    return UDim2.new(0.5,-sizeX/2,0.5,-sizeY/2)
end

function utility.table(tbl,usemt)
    tbl=tbl or{}
    local oldtbl=table.clone(tbl)
    table.clear(tbl)
    for i,v in next,oldtbl do
        if type(i)=="string"then
            tbl[i:lower()]=v
        else
            tbl[i]=v
        end
    end
    if usemt==true then
        setmetatable(tbl,{
            __index=function(t,k)
                return rawget(t,k:lower())or rawget(t,k)
            end,
            __newindex=function(t,k,v)
                if type(k)=="string"then
                    rawset(t,k:lower(),v)
                else
                    rawset(t,k,v)
                end
            end
        })
    end
    return tbl
end

function utility.round(number,float)
    return float*math.floor(number/float)
end

function utility.getrgb(color)
    local r=color.R*255
    local g=color.G*255
    local b=color.B*255
    return r,g,b
end

function utility.changecolor(color,number)
    local r,g,b=utility.getrgb(color)
    r,g,b=math.clamp(r+number,0,255),math.clamp(g+number,0,255),math.clamp(b+number,0,255)
    return Color3.fromRGB(r,g,b)
end

function utility.nextflag()
    totalunnamedflags=totalunnamedflags+1
    return string.format("%.14g",totalunnamedflags)
end

function utility.rgba(r,g,b,alpha)
    local rgb=Color3.fromRGB(r,g,b)
    return rgb
end

function utility.outline(obj,color)
    local outline=utility.createFrame({
        Name="Outline",
        Parent=obj.Parent,
        BackgroundColor3=color,
        BorderSizePixel=0,
        Size=UDim2.new(1,2,1,2),
        Position=UDim2.new(0,-1,0,-1),
        ZIndex=obj.ZIndex-1
    })
    return outline
end

function utility.connect(signal,callback)
    local connection=signal:Connect(callback)
    return connection
end

local themes={
    ["Default"]={
        ["Accent"]=settings.default_accent,
        ["Window Outline Background"]=Color3.fromRGB(39,39,47),
        ["Window Inline Background"]=Color3.fromRGB(23,23,30),
        ["Window Holder Background"]=Color3.fromRGB(32,32,38),
        ["Page Unselected"]=Color3.fromRGB(32,32,38),
        ["Page Selected"]=Color3.fromRGB(55,55,64),
        ["Section Background"]=Color3.fromRGB(27,27,34),
        ["Section Inner Border"]=Color3.fromRGB(50,50,58),
        ["Section Outer Border"]=Color3.fromRGB(19,19,27),
        ["Window Border"]=Color3.fromRGB(58,58,67),
        ["Text"]=Color3.fromRGB(245,245,245),
        ["Risky Text"]=Color3.fromRGB(245,239,120),
        ["Object Background"]=Color3.fromRGB(41,41,50)
    }
}

local themeobjects={}
local library={theme=table.clone(themes.Default),currentcolor=nil,folder="zephyrus",flags={},open=true,mousestate=services.UserInputService.MouseIconEnabled,cursor=nil,holder=nil,connections={},notifications={}}
library.utility=utility

function utility.changeobjecttheme(object,color)
    themeobjects[object]=color
    if object:IsA("TextLabel")or object:IsA("TextButton")or object:IsA("TextBox")then
        object.TextColor3=library.theme[color]or object.TextColor3
    else
        object.BackgroundColor3=library.theme[color]or object.BackgroundColor3
    end
end

function utility.createGradient(color1,color2,rotation)
    local gradient=Instance.new("UIGradient")
    gradient.Color=ColorSequence.new(color1,color2)
    gradient.Rotation=rotation or 0
    return gradient
end
--[[
function library.createcolorpicker(default,parent,count,flag,callback,offset)
    local icon=utility.createFrame({
        Name="ColorPickerIcon",
        Parent=parent,
        BackgroundColor3=default,
        Size=UDim2.new(0,17,0,9),
        Position=UDim2.new(1,-17-(count*17)-(count*6),0,4+offset),
        BorderSizePixel=0
    })
    
    local outline1=utility.outline(icon,library.theme["Section Inner Border"])
    utility.outline(outline1,library.theme["Section Outer Border"])
    
    local window=utility.createFrame({
        Name="ColorPickerWindow",
        Parent=icon,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0,185,0,200),
        Visible=false,
        Position=UDim2.new(1,-185+(count*20)+(count*6),1,6),
        BorderSizePixel=0
    })
    
    local outline2=utility.outline(window,library.theme["Section Inner Border"])
    utility.outline(outline2,library.theme["Section Outer Border"])
    
    local saturation=utility.createFrame({
        Name="Saturation",
        Parent=window,
        BackgroundColor3=default,
        Size=UDim2.new(0,154,0,150),
        Position=UDim2.new(0,6,0,6),
        BorderSizePixel=0
    })
    
    utility.outline(saturation,library.theme["Section Inner Border"])
    
    local hueframe=utility.createFrame({
        Name="HueFrame",
        Parent=window,
        BackgroundColor3=Color3.new(1,0,0),
        Size=UDim2.new(0,15,0,150),
        Position=UDim2.new(0,165,0,6),
        BorderSizePixel=0
    })
    
    utility.outline(hueframe,library.theme["Section Inner Border"])
    
    local hueColors={}
    for i=0,10 do
        table.insert(hueColors,ColorSequenceKeypoint.new(i/10,Color3.fromHSV(i/10,1,1)))
    end
    
    local hueGradient=Instance.new("UIGradient")
    hueGradient.Color=ColorSequence.new(hueColors)
    hueGradient.Rotation=0
    hueGradient.Parent=hueframe
    
    local saturationpicker=utility.createFrame({
        Name="SaturationPicker",
        Parent=saturation,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,4,0,4),
        Position=UDim2.new(0,0,0,0),
        BorderColor3=Color3.new(0,0,0),
        BorderSizePixel=1
    })
    
    local huepicker=utility.createFrame({
        Name="HuePicker",
        Parent=hueframe,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(1,0,0,2),
        Position=UDim2.new(0,0,0,0),
        BorderColor3=Color3.new(0,0,0),
        BorderSizePixel=1
    })
    
    local rgbinput=utility.create("TextBox",{
        Name="RGBInput",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(1,-12,0,14),
        Position=UDim2.new(0,6,0,160),
        Text=string.format("%s, %s, %s",math.floor(default.R*255),math.floor(default.G*255),math.floor(default.B*255)),
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        TextXAlignment=Enum.TextXAlignment.Center,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"]
    })
    
    local copyButton=utility.createTextButton({
        Name="CopyButton",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0.5,-20,0,12),
        Position=UDim2.new(0,6,0,180),
        Text="copy",
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"],
        AutoButtonColor=false
    })
    
    local pasteButton=utility.createTextButton({
        Name="PasteButton",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0.5,-20,0,12),
        Position=UDim2.new(0.5,15,0,180),
        Text="paste",
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"],
        AutoButtonColor=false
    })
    
    local hue,sat,val
    hue,sat,val=default:ToHSV()
    local hsv=Color3.fromHSV(hue,sat,val)
    local current_val=default
    
    copyButton.MouseButton1Click:Connect(function()
        library.currentcolor=current_val
    end)
    
    pasteButton.MouseButton1Click:Connect(function()
        if library.currentcolor~=nil then
            local color=library.currentcolor
            if type(color)=="string"then
                color=Color3.fromHex(color)
            end
            hue,sat,val=color:ToHSV()
            hsv=Color3.fromHSV(hue,sat,val)
            icon.BackgroundColor3=hsv
            saturation.BackgroundColor3=Color3.fromHSV(hue,1,1)
            
            local satX=math.clamp(sat*154,0,154-2)
            local satY=math.clamp((1-val)*150,0,150-2)
            local hueY=math.clamp((1-hue)*150,0,150-2)
            
            saturationpicker.Position=UDim2.new(0,satX,0,satY)
            huepicker.Position=UDim2.new(0,0,0,hueY)
            
            rgbinput.Text=string.format("%s, %s, %s",math.round(hsv.R*255),math.round(hsv.G*255),math.round(hsv.B*255))
            
            if flag then
                library.flags[flag]=utility.rgba(hsv.R*255,hsv.G*255,hsv.B*255)
            end
            
            callback(Color3.fromRGB(hsv.R*255,hsv.G*255,hsv.B*255))
            current_val=Color3.fromRGB(hsv.R*255,hsv.G*255,hsv.B*255)
        end
    end)
    
    local function set(color,nopos,setcolor)
        if type(color)=="string"then
            color=Color3.fromHex(color)
        end
        
        local oldcolor=hsv
        hue,sat,val=color:ToHSV()
        hsv=Color3.fromHSV(hue,sat,val)
        
        if hsv~=oldcolor then
            icon.BackgroundColor3=hsv
            
            if not nopos then
                local satX=math.clamp(sat*154,0,154-2)
                local satY=math.clamp((1-val)*150,0,150-2)
                local hueY=math.clamp((1-hue)*150,0,150-2)
                
                saturationpicker.Position=UDim2.new(0,satX,0,satY)
                huepicker.Position=UDim2.new(0,0,0,hueY)
                
                if setcolor then
                    saturation.BackgroundColor3=Color3.fromHSV(hue,1,1)
                end
            end
            
            rgbinput.Text=string.format("%s, %s, %s",math.round(hsv.R*255),math.round(hsv.G*255),math.round(hsv.B*255))
            
            if flag then
                library.flags[flag]=utility.rgba(hsv.R*255,hsv.G*255,hsv.B*255)
            end
            
            callback(Color3.fromRGB(hsv.R*255,hsv.G*255,hsv.B*255))
            current_val=Color3.fromRGB(hsv.R*255,hsv.G*255,hsv.B*255)
        end
    end
    
    local slidingsaturation=false
    local slidinghue=false
    
    saturation.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidingsaturation=true
            
            local sizeX=math.clamp((input.Position.X-saturation.AbsolutePosition.X)/saturation.AbsoluteSize.X,0,1)
            local sizeY=1-math.clamp((input.Position.Y-saturation.AbsolutePosition.Y)/saturation.AbsoluteSize.Y,0,1)
            
            local posX=sizeX*154
            local posY=(1-sizeY)*150
            
            saturationpicker.Position=UDim2.new(0,posX,0,posY)
            
            set(Color3.fromHSV(hue,sizeX,sizeY),true,false)
        end
    end)
    
    saturation.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidingsaturation=false
        end
    end)
    
    hueframe.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidinghue=true
            
            local sizeY=1-math.clamp((input.Position.Y-hueframe.AbsolutePosition.Y)/hueframe.AbsoluteSize.Y,0,1)
            local posY=sizeY*150
            
            huepicker.Position=UDim2.new(0,0,0,posY)
            saturation.BackgroundColor3=Color3.fromHSV(sizeY,1,1)
            hue=sizeY
            
            set(Color3.fromHSV(hue,sat,val),true,true)
        end
    end)
    
    hueframe.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidinghue=false
        end
    end)
    
    services.UserInputService.InputChanged:Connect(function(input)
        if slidingsaturation then
            local sizeX=math.clamp((input.Position.X-saturation.AbsolutePosition.X)/saturation.AbsoluteSize.X,0,1)
            local sizeY=1-math.clamp((input.Position.Y-saturation.AbsolutePosition.Y)/saturation.AbsoluteSize.Y,0,1)
            
            local posX=sizeX*154
            local posY=(1-sizeY)*150
            
            saturationpicker.Position=UDim2.new(0,posX,0,posY)
            set(Color3.fromHSV(hue,sizeX,sizeY),true,false)
        end
        
        if slidinghue then
            local sizeY=1-math.clamp((input.Position.Y-hueframe.AbsolutePosition.Y)/hueframe.AbsoluteSize.Y,0,1)
            local posY=sizeY*150
            
            huepicker.Position=UDim2.new(0,0,0,posY)
            saturation.BackgroundColor3=Color3.fromHSV(sizeY,1,1)
            hue=sizeY
            
            set(Color3.fromHSV(hue,sat,val),true,true)
        end
    end)
    
    icon.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            window.Visible=not window.Visible
            slidinghue=false
            slidingsaturation=false
        end
    end)
    
    set(default)
    
    local colorpickertypes={}
    
    function colorpickertypes:set(color)
        set(color)
    end
    
    return colorpickertypes,window
end
--]]
function library.createcolorpicker(default,parent,count,flag,callback,offset)
    if type(default) == "string" then
        default = Color3.fromHex(default)
    end
    
    local icon=utility.createTextButton({
        Name="ColorPickerIcon",
        Parent=parent,
        BackgroundColor3=default,
        Size=UDim2.new(0,17,0,9),
        Position=UDim2.new(1,-17-(count*17)-(count*6),0,4+offset),
        BorderSizePixel=0,
        Text="",
        ZIndex = 9e9
    })
    
    local window=utility.createFrame({
        Name="ColorPickerWindow",
        Parent=icon,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0,185,0,200),
        Visible=false,
        Position=UDim2.new(1,-185+(count*20)+(count*6),1,6),
        BorderSizePixel=0,
        ZIndex = 9e9
    })
    
    local saturation=utility.createFrame({
        Name="Saturation",
        Parent=window,
        BackgroundColor3=Color3.new(1,0,0),
        Size=UDim2.new(0,154,0,150),
        Position=UDim2.new(0,6,0,6),
        BorderSizePixel=0,
        ZIndex = 9e9,
        BackgroundTransparency=0   
    })
    
    local whiteGradient = Instance.new("UIGradient")
    whiteGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
    }
    whiteGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    whiteGradient.Rotation = 0
    whiteGradient.Parent = saturation
    
    local blackGradient = Instance.new("UIGradient")
    blackGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
    }
    blackGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    }
    blackGradient.Rotation = 90
    blackGradient.Parent = saturation
    
    local hueframe=utility.createFrame({
        Name="HueFrame",
        Parent=window,
        BackgroundColor3=Color3.new(1,0,0),
        Size=UDim2.new(0,15,0,150),
        Position=UDim2.new(0,165,0,6),
        BorderSizePixel=0,
        ZIndex = 9e9
    })
    
    local hueGradient=Instance.new("UIGradient")
    local hueColors = {}
    table.insert(hueColors, ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6, 1, 1)))
    table.insert(hueColors, ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)))
    hueGradient.Color=ColorSequence.new(hueColors)
    hueGradient.Rotation=90
    hueGradient.Parent=hueframe
    
    local saturationpicker=utility.createFrame({
        Name="SaturationPicker",
        Parent=saturation,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(0,4,0,4),
        Position=UDim2.new(0,0,0,0),
        BorderColor3=Color3.new(0,0,0),
        BorderSizePixel=1,
        ZIndex = 9e9
    })
    
    local huepicker=utility.createFrame({
        Name="HuePicker",
        Parent=hueframe,
        BackgroundColor3=Color3.new(1,1,1),
        Size=UDim2.new(1,0,0,2),
        Position=UDim2.new(0,0,0,0),
        BorderColor3=Color3.new(0,0,0),
        BorderSizePixel=1,
        ZIndex = 9e9
    })
    
    local rgbinput=utility.create("TextBox",{
        Name="RGBInput",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(1,-12,0,14),
        Position=UDim2.new(0,6,0,160),
        Text=string.format("%s, %s, %s",math.floor(default.R*255),math.floor(default.G*255),math.floor(default.B*255)),
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        TextXAlignment=Enum.TextXAlignment.Center,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"],
        ZIndex = 9e9
    })
    
    local copyButton=utility.createTextButton({
        Name="CopyButton",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0.5,-20,0,12),
        Position=UDim2.new(0,6,0,180),
        Text="copy",
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"],
        AutoButtonColor=false,
        ZIndex = 9e9
    })
    
    local pasteButton=utility.createTextButton({
        Name="PasteButton",
        Parent=window,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(0.5,-20,0,12),
        Position=UDim2.new(0.5,15,0,180),
        Text="paste",
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        BorderSizePixel=1,
        BorderColor3=library.theme["Section Inner Border"],
        AutoButtonColor=false,
        ZIndex = 9e9
    })
    
    local hue,sat,val = default:ToHSV()
    local current_val=default
    
    copyButton.MouseButton1Click:Connect(function()
        local r = math.round(current_val.R * 255)
        local g = math.round(current_val.G * 255)
        local b = math.round(current_val.B * 255)
        local hex = string.format("%02X%02X%02X", r, g, b)
        
        if setclipboard then
            setclipboard(hex)
        else
            pcall(function()
                local Clipboard = game:GetService("ClipboardService")
                Clipboard:Set(hex)
            end)
        end
    end)
    
    pasteButton.MouseButton1Click:Connect(function()
        local text = ""
        
        if getclipboard then
            text = getclipboard()
        else
            pcall(function()
                local Clipboard = game:GetService("ClipboardService")
                text = Clipboard:Get()
            end)
        end
        
        if text then
            local function parseColorFromString(str)
                str = tostring(str):gsub("%s+", "")
                
                if str:match("^#%x%x%x%x%x%x$") then
                    return Color3.fromHex(str)
                end
                
                if str:match("^%d+,%d+,%d+$") then
                    local r, g, b = str:match("(%d+),(%d+),(%d+)")
                    r = math.clamp(tonumber(r) or 0, 0, 255)
                    g = math.clamp(tonumber(g) or 0, 0, 255)
                    b = math.clamp(tonumber(b) or 0, 0, 255)
                    return Color3.fromRGB(r, g, b)
                end
                
                if str:match("^%d+%s+%d+%s+%d+$") then
                    local parts = {}
                    for num in str:gmatch("%d+") do
                        table.insert(parts, math.clamp(tonumber(num) or 0, 0, 255))
                    end
                    if #parts == 3 then
                        return Color3.fromRGB(parts[1], parts[2], parts[3])
                    end
                end
                
                return nil
            end
            
            local color = parseColorFromString(text)
            if color then
                hue, sat, val = color:ToHSV()
                saturation.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                
                local satX = math.clamp(sat * 154, 0, 154 - 4)
                local satY = math.clamp((1 - val) * 150, 0, 150 - 4)
                local hueY = math.clamp((1 - hue) * 150, 0, 150 - 2)
                
                saturationpicker.Position = UDim2.new(0, satX, 0, satY)
                huepicker.Position = UDim2.new(0, 0, 0, hueY)
                
                icon.BackgroundColor3 = color
                current_val = color
                
                rgbinput.Text = string.format("%s, %s, %s", 
                    math.round(color.R * 255), 
                    math.round(color.G * 255), 
                    math.round(color.B * 255))
                
                if flag then
                    library.flags[flag] = utility.rgba(color.R * 255, color.G * 255, color.B * 255)
                end
                
                callback(color)
            end
        end
    end)
    
    local function parseColorFromString(str)
        str = tostring(str):gsub("%s+", "")
        
        if str:match("^#%x%x%x%x%x%x$") then
            return Color3.fromHex(str)
        end
        
        if str:match("^%d+,%d+,%d+$") then
            local r, g, b = str:match("(%d+),(%d+),(%d+)")
            r = math.clamp(tonumber(r) or 0, 0, 255)
            g = math.clamp(tonumber(g) or 0, 0, 255)
            b = math.clamp(tonumber(b) or 0, 0, 255)
            return Color3.fromRGB(r, g, b)
        end
        
        if str:match("^%d+%s+%d+%s+%d+$") then
            local parts = {}
            for num in str:gmatch("%d+") do
                table.insert(parts, math.clamp(tonumber(num) or 0, 0, 255))
            end
            if #parts == 3 then
                return Color3.fromRGB(parts[1], parts[2], parts[3])
            end
        end
        
        return nil
    end
    
    local function set(color,nopos,setcolor)
        if type(color) == "string" then
            color = parseColorFromString(color)
            if not color then return end
        end
        
        local oldHue, oldSat, oldVal = hue, sat, val
        hue, sat, val = color:ToHSV()
        
        icon.BackgroundColor3 = color
        
        if not nopos then
            local satX = math.clamp(sat * 154, 0, 154 - 4)
            local satY = math.clamp((1 - val) * 150, 0, 150 - 4)
            local hueY = math.clamp((1 - hue) * 150, 0, 150 - 2)
            
            saturationpicker.Position = UDim2.new(0, satX, 0, satY)
            huepicker.Position = UDim2.new(0, 0, 0, hueY)
            
            if setcolor then
                saturation.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
        end
        
        rgbinput.Text = string.format("%s, %s, %s", 
            math.round(color.R * 255), 
            math.round(color.G * 255), 
            math.round(color.B * 255))
        
        if flag then
            library.flags[flag] = utility.rgba(color.R * 255, color.G * 255, color.B * 255)
        end
        
        callback(color)
        current_val = color
    end
    
    rgbinput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local color = parseColorFromString(rgbinput.Text)
            if color then
                set(color)
            else
                rgbinput.Text = string.format("%s, %s, %s", 
                    math.round(current_val.R * 255), 
                    math.round(current_val.G * 255), 
                    math.round(current_val.B * 255))
            end
        end
    end)
    
    local slidingsaturation=false
    local slidinghue=false
    
    saturation.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidingsaturation=true
            
            local x = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
            
            local posX = x * 154 - 2
            local posY = y * 150 - 2
            
            saturationpicker.Position = UDim2.new(0, posX, 0, posY)
            set(Color3.fromHSV(hue, x, 1 - y), true, false)
        end
    end)
    
    saturation.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidingsaturation=false
        end
    end)
    
    hueframe.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidinghue=true
            
            local y = math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
            local posY = y * 150 - 1
            
            huepicker.Position = UDim2.new(0, 0, 0, posY)
            saturation.BackgroundColor3 = Color3.fromHSV(y, 1, 1)
            hue = y
            
            set(Color3.fromHSV(hue, sat, val), true, true)
        end
    end)
    
    hueframe.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            slidinghue=false
        end
    end)
    
    services.UserInputService.InputChanged:Connect(function(input)
        if slidingsaturation and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local x = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
            
            local posX = x * 154 - 2
            local posY = y * 150 - 2
            
            saturationpicker.Position = UDim2.new(0, posX, 0, posY)
            set(Color3.fromHSV(hue, x, 1 - y), true, false)
        end
        
        if slidinghue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local y = math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
            local posY = y * 150 - 1
            
            huepicker.Position = UDim2.new(0, 0, 0, posY)
            saturation.BackgroundColor3 = Color3.fromHSV(y, 1, 1)
            hue = y
            
            set(Color3.fromHSV(hue, sat, val), true, true)
        end
    end)
    
    icon.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
        slidinghue=false
        slidingsaturation=false
        
        for _, v in pairs(parent.Parent:GetChildren()) do
            if v.Name == "ColorPickerWindow" and v ~= window then
                v.Visible = false
            end
        end
    end)
    
    services.UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if window.Visible then
                local mousePos = input.Position
                local iconPos = icon.AbsolutePosition
                local iconSize = icon.AbsoluteSize
                local windowPos = window.AbsolutePosition
                local windowSize = window.AbsoluteSize
                
                local isMouseOverIcon = 
                    mousePos.X >= iconPos.X and mousePos.X <= iconPos.X + iconSize.X and
                    mousePos.Y >= iconPos.Y and mousePos.Y <= iconPos.Y + iconSize.Y
                    
                local isMouseOverWindow = 
                    mousePos.X >= windowPos.X and mousePos.X <= windowPos.X + windowSize.X and
                    mousePos.Y >= windowPos.Y and mousePos.Y <= windowPos.Y + windowSize.Y
                
                if not isMouseOverIcon and not isMouseOverWindow then
                    window.Visible = false
                end
            end
        end
    end)
    
    set(default)
    
    local colorpickertypes={}
    
    function colorpickertypes:set(color)
        set(color)
    end
    
    return colorpickertypes,window
end
function library.createdropdown(holder,content,flag,callback,default,max,scrollable,scrollingmax,islist,size,section,sectioncontent)
    local dropdown=utility.createFrame({
        Name="Dropdown",
        Parent=holder,
        BackgroundColor3=library.theme["Object Background"],
        Size=UDim2.new(1,0,0,15),
        Position=UDim2.new(0,0,1,-15),
        BorderSizePixel=0
    })
    
    local outline1=utility.outline(dropdown,library.theme["Section Inner Border"])
    utility.outline(outline1,library.theme["Section Outer Border"])
    
    local value=utility.create("TextLabel",{
        Name="Value",
        Parent=dropdown,
        Text="",
        BackgroundTransparency=1,
        TextColor3=library.theme["Text"],
        TextSize=13,
        FontFace=UI_FONT,
        Position=UDim2.new(0,2,0,0),
        Size=UDim2.new(1,-20,1,0),
        TextXAlignment=Enum.TextXAlignment.Left
    })
    
    local icon=utility.create("TextLabel",{
        Name="Icon",
        Parent=dropdown,
        Text="▼",
        BackgroundTransparency=1,
        TextColor3=library.theme["Text"],
        TextSize=10,
        FontFace=UI_FONT,
        Position=UDim2.new(1,-15,0,2),
        Size=UDim2.new(0,10,1,-4),
        TextXAlignment=Enum.TextXAlignment.Center
    })
    
    local contentframe=utility.createFrame({
        Name="ContentFrame",
        Parent=islist and holder or dropdown,
        BackgroundColor3=library.theme["Object Background"],
        Size=islist and size=="Fill"and UDim2.new(1,0,1,-30)or islist and size~="Fill"and UDim2.new(1,0,0,size)or UDim2.new(1,0,0,0),
        Position=islist and UDim2.new(0,0,0,14)or UDim2.new(0,0,1,6),
        Visible=islist or false,
        BorderSizePixel=0
    })
    
    local outline2=utility.outline(contentframe,library.theme["Section Inner Border"])
    utility.outline(outline2,library.theme["Section Outer Border"])
    
    local contentholder=utility.createFrame({
        Name="ContentHolder",
        Parent=contentframe,
        BackgroundTransparency=1,
        Size=UDim2.new(1,-6,1,-6),
        Position=UDim2.new(0,3,0,3),
        BorderSizePixel=0
    })
    
    local uiListLayout=Instance.new("UIListLayout")
    uiListLayout.Parent=contentholder
    uiListLayout.Padding=UDim.new(0,2)
    uiListLayout.SortOrder=Enum.SortOrder.LayoutOrder
    
    if scrollable then
        local scrollingFrame=utility.create("ScrollingFrame",{
            Name="ScrollingFrame",
            Parent=contentframe,
            BackgroundTransparency=1,
            Size=UDim2.new(1,-6,1,-6),
            Position=UDim2.new(0,3,0,3),
            BorderSizePixel=0,
            ScrollBarThickness=5,
            CanvasSize=UDim2.new(0,0,0,0)
        })
        contentholder=scrollingFrame
    end
    
    if not islist then
        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                contentframe.Visible=not contentframe.Visible
                icon.Text=contentframe.Visible and"▲"or"▼"
            end
        end)
    end
    
    local optioninstances={}
    local count=0
    local countindex={}
    
    local function createoption(name)
        optioninstances[name]={}
        countindex[name]=count+1
        
        local button=utility.createTextButton({
            Name="Option_"..name,
            Parent=contentholder,
            BackgroundColor3=library.theme["Object Background"],
            Size=UDim2.new(1,0,0,16),
            Text="",
            AutoButtonColor=false,
            BorderSizePixel=1,
            BorderColor3=library.theme["Section Inner Border"]
        })
        
        optioninstances[name].button=button
        
        local title=utility.create("TextLabel",{
            Name="Title",
            Parent=button,
            Text=name,
            BackgroundTransparency=1,
            TextColor3=library.theme["Text"],
            TextSize=13,
            FontFace=UI_FONT,
            Position=UDim2.new(0,8,0,1),
            Size=UDim2.new(1,-10,1,0),
            TextXAlignment=Enum.TextXAlignment.Left
        })
        
        optioninstances[name].text=title
        
        count=count+1
        
        return button,title
    end
    
    local chosen=max and{}
    
    local function handleoptionclick(option,button,text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen,option)then
                    table.remove(chosen,table.find(chosen,option))
                    
                    local textchosen={}
                    local cutobject=false
                    
                    for _,opt in next,chosen do
                        table.insert(textchosen,opt)
                        
                        if utility.textlength(table.concat(textchosen,", ")..", ...",UI_FONT,13).X>(dropdown.AbsoluteSize.X-18)then
                            cutobject=true
                            table.remove(textchosen,#textchosen)
                        end
                    end
                    
                    value.Text=#chosen==0 and""or table.concat(textchosen,", ")..(cutobject and", ..."or"")
                    
                    text.TextColor3=library.theme["Text"]
                    
                    library.flags[flag]=chosen
                    callback(chosen)
                else
                    if#chosen==max then
                        optioninstances[chosen[1]].text.TextColor3=library.theme["Text"]
                        table.remove(chosen,1)
                    end
                    
                    table.insert(chosen,option)
                    
                    local textchosen={}
                    local cutobject=false
                    
                    for _,opt in next,chosen do
                        table.insert(textchosen,opt)
                        
                        if utility.textlength(table.concat(textchosen,", ")..", ...",UI_FONT,13).X>(dropdown.AbsoluteSize.X-18)then
                            cutobject=true
                            table.remove(textchosen,#textchosen)
                        end
                    end
                    
                    value.Text=#chosen==0 and""or table.concat(textchosen,", ")..(cutobject and", ..."or"")
                    
                    text.TextColor3=library.theme["Accent"]
                    
                    library.flags[flag]=chosen
                    callback(chosen)
                end
            else
                for opt,tbl in next,optioninstances do
                    if opt~=option then
                        tbl.text.TextColor3=library.theme["Text"]
                    end
                end
                
                chosen=option
                value.Text=option
                text.TextColor3=library.theme["Accent"]
                
                library.flags[flag]=option
                callback(option)
            end
        end)
    end
    
    local function createoptions(tbl)
        for _,option in next,tbl do
            local button,text=createoption(option)
            handleoptionclick(option,button,text)
        end
    end
    
    createoptions(content)
    
    local function set(option)
        if max then
            option=type(option)=="table"and option or{}
            table.clear(chosen)
            
            for opt,tbl in next,optioninstances do
                if not table.find(option,opt)then
                    tbl.text.TextColor3=library.theme["Text"]
                end
            end
            
            for i,opt in next,option do
                if table.find(content,opt)and#chosen<max then
                    table.insert(chosen,opt)
                    optioninstances[opt].text.TextColor3=library.theme["Accent"]
                end
            end
            
            local textchosen={}
            local cutobject=false
            
            for _,opt in next,chosen do
                table.insert(textchosen,opt)
                
                if utility.textlength(table.concat(textchosen,", ")..", ...",UI_FONT,13).X>(dropdown.AbsoluteSize.X-6)then
                    cutobject=true
                    table.remove(textchosen,#textchosen)
                end
            end
            
            value.Text=#chosen==0 and""or table.concat(textchosen,", ")..(cutobject and", ..."or"")
            
            library.flags[flag]=chosen
            callback(chosen)
        end
        
        if not max then
            for opt,tbl in next,optioninstances do
                if opt~=option then
                    tbl.text.TextColor3=library.theme["Text"]
                end
            end
            
            if table.find(content,option)then
                chosen=option
                value.Text=option
                optioninstances[option].text.TextColor3=library.theme["Accent"]
                library.flags[flag]=chosen
                callback(chosen)
            else
                chosen=nil
                value.Text=""
                library.flags[flag]=chosen
                callback(chosen)
            end
        end
    end
    
    library.flags[flag]=set
    
    set(default)
    
    local dropdowntypes=utility.table({},true)
    
    function dropdowntypes:set(option)
        set(option)
    end
    
    function dropdowntypes:refresh(tbl)
        content=table.clone(tbl)
        count=0
        
        for _,opt in next,optioninstances do
            opt.button:Destroy()
        end
        
        table.clear(optioninstances)
        createoptions(tbl)
        value.Text=""
        
        if max then
            table.clear(chosen)
        else
            chosen=nil
        end
        
        library.flags[flag]=chosen
        callback(chosen)
    end
    
    function dropdowntypes:add(option)
        table.insert(content,option)
        local button,text=createoption(option)
        handleoptionclick(option,button,text)
    end
    
    function dropdowntypes:remove(option)
        if optioninstances[option]then
            count=count-1
            optioninstances[option].button:Destroy()
            optioninstances[option]=nil
            
            if max then
                if table.find(chosen,option)then
                    table.remove(chosen,table.find(chosen,option))
                    
                    local textchosen={}
                    local cutobject=false
                    
                    for _,opt in next,chosen do
                        table.insert(textchosen,opt)
                        
                        if utility.textlength(table.concat(textchosen,", ")..", ...",UI_FONT,13).X>(dropdown.AbsoluteSize.X-6)then
                            cutobject=true
                            table.remove(textchosen,#textchosen)
                        end
                    end
                    
                    value.Text=#chosen==0 and""or table.concat(textchosen,", ")..(cutobject and", ..."or"")
                    
                    library.flags[flag]=chosen
                    callback(chosen)
                end
            end
        end
    end
    
    return dropdowntypes
end

function library:load_config(cfg_name)
    if isfile(cfg_name)then
        local file=readfile(cfg_name)
        local config=HttpService:JSONDecode(file)
        
        for flag,v in next,config do
            local func=library.flags[flag]
            if func then
                func(v)
            end
        end
    end
end

function library:new_window(cfg)
    local window_tbl={pages={},page_buttons={},page_accents={}}
    local window_size=cfg.size or cfg.Size or Vector2.new(600,400)
    local size_x=window_size.X
    local size_y=window_size.Y
    
    local screenGui=utility.create("ScreenGui",{
        Name="DeadCellUI",
        Parent=services.CoreGui,
        ResetOnSpawn=false
    })
    
    local window_outline=utility.createFrame({
        Name="WindowOutline",
        Parent=screenGui,
        BackgroundColor3=library.theme["Window Outline Background"],
        Size=UDim2.new(0,size_x,0,size_y),
        Position = UDim2.new(0.5,0,0.5,0),
        BorderSizePixel=0
    })
    
    library.holder=window_outline
    
    local window_inline=utility.createFrame({
        Name="WindowInline",
        Parent=window_outline,
        BackgroundColor3=library.theme["Window Inline Background"],
        Size=UDim2.new(1,-10,1,-10),
        Position=UDim2.new(0,5,0,5),
        BorderSizePixel=0
    })
    
    utility.outline(window_inline,library.theme["Window Border"])
    
    local window_accent=utility.createFrame({
        Name="WindowAccent",
        Parent=window_inline,
        BackgroundColor3=library.theme["Accent"],
        Size=UDim2.new(1,-2,0,2),
        Position=UDim2.new(0,1,0,1),
        BorderSizePixel=0
    })
    
    local window_holder=utility.createFrame({
        Name="WindowHolder",
        Parent=window_inline,
        BackgroundColor3=library.theme["Window Holder Background"],
        Size=UDim2.new(1,-30,1,-30),
        Position=UDim2.new(0,15,0,15),
        BorderSizePixel=0
    })
    
    local window_pages_holder=utility.createFrame({
        Name="PagesHolder",
        Parent=window_holder,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,25),
        Position=UDim2.new(0,0,0,0),
        BorderSizePixel=0
    })
    local wxn=utility.createFrame({
        Name="WindowDrag",
        Parent=window_outline,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),
        Position=UDim2.new(0,0,0,0),
        BorderSizePixel=0
    })
    local window_drag=utility.createFrame({
        Name="WindowDrag",
        Parent=window_outline,
        BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,10),
        Position=UDim2.new(0,0,0,0),
        BorderSizePixel=0
    })
    
    
    utility.dragify(wxn,window_outline)
    
    function window_tbl:new_page(cfg)
        local page_tbl={sections={}}
        local page_name=cfg.name or cfg.Name or"new page"
        
        local page_button=utility.createTextButton({
            Name="PageButton",
            Parent=window_pages_holder,
            BackgroundColor3=library.theme["Page Unselected"],
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0,0,0,0),
            Text="",
            AutoButtonColor=false,
            BorderSizePixel=1,
            BorderColor3=library.theme["Window Border"]
        })
        
        table.insert(self.page_buttons,page_button)
        
        local page_title=utility.create("TextLabel",{
            Name="PageTitle",
            Parent=page_button,
            Text=page_name,
            BackgroundTransparency=1,
            TextColor3=library.theme["Text"],
            TextSize=13,
            FontFace=UI_FONT,
            Position=UDim2.new(0,0,0,1),
            Size=UDim2.new(1,0,1,0),
            TextXAlignment=Enum.TextXAlignment.Center
        })
        
        local page_button_accent=utility.createFrame({
            Name="PageAccent",
            Parent=page_button,
            BackgroundColor3=library.theme["Accent"],
            Size=UDim2.new(1,0,0,1),
            Position=UDim2.new(0,0,0,1),
            Visible=false,
            BorderSizePixel=0
        })
        
        table.insert(self.page_accents,page_button_accent)
        
       local page=utility.createFrame({
            Name="Page",
            Parent=window_holder,
            BackgroundTransparency=1,
            Size=UDim2.new(1,-40,1,-45),
            Position=UDim2.new(0,15,0,40),
            Visible=false,
            BorderSizePixel=0
        })
        
        table.insert(self.pages,page)
        
        local left = utility.create("ScrollingFrame", {
            Name = "Left",
            Parent = page,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -14, 1, -10),
            Position = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })

        local leftLayout = Instance.new("UIListLayout")
        leftLayout.Parent = left
        leftLayout.Padding = UDim.new(0, 15)
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

        leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            left.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local right = utility.create("ScrollingFrame", {
            Name = "Right",
            Parent = page,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -14, 1, -10),
            Position = UDim2.new(0.5, 14, 0, 0),
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            ScrollBarImageTransparency = 0.3,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })

        local rightLayout = Instance.new("UIListLayout")
        rightLayout.Parent = right
        rightLayout.Padding = UDim.new(0, 15)
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder

        rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            right.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
        end)
        
        page_button.MouseButton1Click:Connect(function()
            for i,v in next,self.page_buttons do
                if v~=page_button then
                    v.BackgroundColor3=library.theme["Page Unselected"]
                end
            end
            
            for i,v in next,self.page_accents do
                if v~=page_button_accent then
                    v.Visible=false
                end
            end
            
            for i,v in next,self.pages do
                if v~=page then
                    v.Visible=false
                end
            end
            
            page_button.BackgroundColor3=library.theme["Page Selected"]
            page_button_accent.Visible=true
            page.Visible=true
        end)
        
        for _,v in next,self.page_buttons do
               v.Size=UDim2.new(1/#self.page_buttons,_==1 and 1 or _==#self.page_buttons and-2 or-1,0,35)
               v.Position=UDim2.new(1/(#self.page_buttons/(_-1)),_==1 and 0 or 2,0,0)
      end
        
        function page_tbl:open()
            page_button.BackgroundColor3=library.theme["Page Selected"]
            page_button_accent.Visible=true
            page.Visible=true
        end
        
        function page_tbl:new_section(cfg)
            local section_tbl={}
            local section_name=cfg.name or cfg.Name or"new section"
            local section_side=cfg.side=="left"and left or cfg.Side=="left"and left or cfg.side=="right"and right or cfg.Side=="right"and right or left
            local section_size=cfg.size or cfg.Size or 200
            
            local section=utility.createFrame({
                Name="Section",
                Parent=section_side,
                BackgroundColor3=library.theme["Section Background"],
                Size=section_size~="Fill"and UDim2.new(1,0,0,section_size)or UDim2.new(1,0,1,0),
                Position=UDim2.new(0,0,0,0),
                BorderSizePixel=0
            })
            
            local section_title_cover=utility.createFrame({
                Name="TitleCover",
                Parent=section,
                BackgroundColor3=library.theme["Window Holder Background"],
                Size=UDim2.new(0,utility.textlength(section_name,UI_FONT,13).X+2,0,4),
                Position=UDim2.new(0,10,0,-4),
                BorderSizePixel=0
            })
            
            local section_title=utility.create("TextLabel",{
                Name="Title",
                Parent=section,
                Text=section_name,
                BackgroundTransparency=1,
                TextColor3=library.theme["Text"],
                TextSize=13,
                FontFace=UI_FONT,
                Position=UDim2.new(0,10,0,-8),
                Size=UDim2.new(0,200,0,20),
                TextXAlignment=Enum.TextXAlignment.Left
            })
            
            local section_content=utility.createFrame({
                Name="Content",
                Parent=section,
                BackgroundTransparency=1,
                Size=UDim2.new(1,-32,1,-10),
                Position=UDim2.new(0,16,0,15),
                BorderSizePixel=0
            })
            
            local contentLayout=Instance.new("UIListLayout")
            contentLayout.Parent=section_content
            contentLayout.Padding=UDim.new(0,8)
            contentLayout.SortOrder=Enum.SortOrder.LayoutOrder
            
            function section_tbl:new_toggle(cfg)
                local toggle_tbl={colorpickers=0}
                local toggle_name=cfg.name or cfg.Name or"new toggle"
                local toggle_risky=cfg.risky or cfg.Risky or false
                local toggle_state=cfg.state or cfg.State or false
                local toggle_flag=cfg.flag or cfg.Flag or utility.nextflag()
                local callback=cfg.callback or cfg.Callback or function()end
                local toggled=false
                
                local holder=utility.create("TextButton", {
                    Name="ToggleHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,8),
                    BorderSizePixel=0,
                    Text="",
                    AutoButtonColor=false
                })
                
                local toggle_frame=utility.createFrame({
                    Name="ToggleFrame",
                    Parent=holder,
                    BackgroundColor3=library.theme["Object Background"],
                    Size=UDim2.new(0,8,0,8),
                    BorderSizePixel=1,
                    BorderColor3=library.theme["Section Inner Border"],
                    Position=UDim2.new(0,0,0,3)
                })
                
                local toggle_title=utility.create("TextLabel",{
                    Name="ToggleTitle",
                    Parent=holder,
                    Text=toggle_name,
                    BackgroundTransparency=1,
                    TextColor3=toggle_risky and library.theme["Risky Text"]or library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    Position=UDim2.new(0,13,0,0),
                    Size=UDim2.new(1,-13,1,0),
                    TextXAlignment=Enum.TextXAlignment.Left
                })
                
                local function setstate()
                    toggled=not toggled
                    if toggled then
                        toggle_frame.BackgroundColor3=library.theme["Accent"]
                    else
                        toggle_frame.BackgroundColor3=library.theme["Object Background"]
                    end
                    library.flags[toggle_flag]=toggled
                    callback(toggled)
                end
                
                holder.MouseButton1Click:Connect(function()
                    setstate()
                end)
                
                local function set(bool)
                    bool=type(bool)=="boolean"and bool or false
                    if toggled~=bool then
                        setstate()
                    end
                end
                
                set(toggle_state)
                library.flags[toggle_flag]=set
                
                local toggletypes={}
                
                function toggletypes:set(bool)
                    set(bool)
                end
                
                function toggletypes:new_colorpicker(cfg)
                    local default=cfg.default or cfg.Default or Color3.fromRGB(255,0,0)
                    local flag=cfg.flag or cfg.Flag or utility.nextflag()
                    local callback=cfg.callback or function()end
                    local colorpicker_tbl={}
                    
                    toggle_tbl.colorpickers=toggle_tbl.colorpickers+1
                    
                    local cp=library.createcolorpicker(default,holder,toggle_tbl.colorpickers-1,flag,callback,-4)
                    
                    function colorpicker_tbl:set(color)
                        cp:set(color,false,true)
                    end
                    
                    return colorpicker_tbl
                end
                
                return toggletypes
            end
            
            function section_tbl:new_slider(cfg)
                local slider_tbl={}
                local name=cfg.name or cfg.Name or"new slider"
                local min=cfg.min or cfg.minimum or 0
                local max=cfg.max or cfg.maximum or 100
                local text=cfg.text or("[value]/"..max)
                local float=cfg.float or 1
                local default=cfg.default and math.clamp(cfg.default,min,max)or min
                local flag=cfg.flag or utility.nextflag()
                local callback=cfg.callback or function()end
                
                local holder=utility.createFrame({
                    Name="SliderHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,20),
                    BorderSizePixel=0
                })
                
                local slider_frame=utility.createFrame({
                    Name="SliderFrame",
                    Parent=holder,
                    BackgroundColor3=library.theme["Object Background"],
                    Size=UDim2.new(1,0,0,5),
                    Position=UDim2.new(0,0,0,15),
                    BorderSizePixel=1,
                    BorderColor3=library.theme["Section Inner Border"]
                })
                
                utility.outline(slider_frame,library.theme["Section Outer Border"])
                
                local slider_title=utility.create("TextLabel",{
                    Name="SliderTitle",
                    Parent=holder,
                    Text=name,
                    BackgroundTransparency=1,
                    TextColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    Position=UDim2.new(0,-2,0,-2),
                    Size=UDim2.new(1,0,0,15),
                    TextXAlignment=Enum.TextXAlignment.Left
                })
                
                local slider_value=utility.create("TextLabel",{
                    Name="SliderValue",
                    Parent=slider_frame,
                    Text=text:gsub("%[value%]",string.format("%.14g",default)),
                    BackgroundTransparency=1,
                    TextColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    Position=UDim2.new(0.5,0,0,-4),
                    Size=UDim2.new(1,0,1,0),
                    TextXAlignment=Enum.TextXAlignment.Center
                })
                
                local slider_fill=utility.createFrame({
                    Name="SliderFill",
                    Parent=slider_frame,
                    BackgroundColor3=library.theme["Accent"],
                    Size=UDim2.new((default-min)/(max-min),0,1,0),
                    BorderSizePixel=0
                })
                
                local function set(value)
                    value=math.clamp(utility.round(value,float),min,max)
                    local sizeX=(value-min)/(max-min)
                    
                    slider_fill.Size=UDim2.new(sizeX,0,1,0)
                    slider_value.Text=text:gsub("%[value%]",string.format("%.14g",value))
                    
                    library.flags[flag]=value
                    callback(value)
                end
                
                set(default)
                
                local sliding=false
                
                holder.InputBegan:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                        sliding=true
                        local sizeX=math.clamp((input.Position.X-slider_frame.AbsolutePosition.X)/slider_frame.AbsoluteSize.X,0,1)
                        local value=((max-min)*sizeX)+min
                        set(value)
                    end
                end)
                
                holder.InputEnded:Connect(function(input)
                    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                        sliding=false
                    end
                end)
                
                services.UserInputService.InputChanged:Connect(function(input)
                    if sliding and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then
                        local sizeX=math.clamp((input.Position.X-slider_frame.AbsolutePosition.X)/slider_frame.AbsoluteSize.X,0,1)
                        local value=((max-min)*sizeX)+min
                        set(value)
                    end
                end)
                
                library.flags[flag]=set
                
                function slider_tbl:set(value)
                    set(value)
                end
                
                return slider_tbl
            end
            
            function section_tbl:new_label(cfg)
                local name=cfg.name or cfg.Name or"new label"
                local holder=utility.createFrame({
                    Name="LabelHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,15),
                    BorderSizePixel=0
                })
                
                local label=utility.create("TextLabel",{
                    Name="Label",
                    Parent=holder,
                    Text=name,
                    BackgroundTransparency=1,
                    TextColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    Position=UDim2.new(0,0,0,0),
                    Size=UDim2.new(1,0,1,0),
                    TextXAlignment=Enum.TextXAlignment.Left
                })
                
                return{
                    set=function(self,text)
                        label.Text=text
                    end
                }
            end
            
            function section_tbl:new_listbox(cfg)
                local name=cfg.name or cfg.Name or"new listbox"
                local default=cfg.default or cfg.Default or{}
                local max=cfg.max or cfg.Max or nil
                local scrollable=cfg.scrollable or true
                local scrollingmax=cfg.scrollingmax or 10
                local flag=cfg.flag or utility.nextflag()
                local callback=cfg.callback or function()end
                local allow_multiple=cfg.multiple or cfg.multiple or false
                local size=cfg.size or 100
                
                local holder=utility.createFrame({
                    Name="ListboxHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,size+15),
                    BorderSizePixel=0
                })
                
                local title=utility.create("TextLabel",{
                    Name="Title",
                    Parent=holder,
                    Text=name,
                    BackgroundTransparency=1,
                    TextColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    Position=UDim2.new(0,-2,0,-2),
                    Size=UDim2.new(1,0,0,15),
                    TextXAlignment=Enum.TextXAlignment.Left
                })
                
                local listframe=utility.createFrame({
                    Name="ListFrame",
                    Parent=holder,
                    BackgroundColor3=library.theme["Object Background"],
                    Size=UDim2.new(1,0,1,-15),
                    Position=UDim2.new(0,0,0,15),
                    BorderSizePixel=1,
                    BorderColor3=library.theme["Section Inner Border"]
                })
                
                utility.outline(listframe,library.theme["Section Outer Border"])
                
                local scrollingFrame
                if scrollable then
                    scrollingFrame=utility.create("ScrollingFrame",{
                        Name="ScrollingFrame",
                        Parent=listframe,
                        BackgroundTransparency=1,
                        Size=UDim2.new(1,-6,1,-6),
                        Position=UDim2.new(0,3,0,3),
                        BorderSizePixel=0,
                        ScrollBarThickness=5,
                        CanvasSize=UDim2.new(0,0,0,0)
                    })
                else
                    scrollingFrame=utility.createFrame({
                        Name="ContentHolder",
                        Parent=listframe,
                        BackgroundTransparency=1,
                        Size=UDim2.new(1,-6,1,-6),
                        Position=UDim2.new(0,3,0,3),
                        BorderSizePixel=0
                    })
                end
                
                local uiListLayout=Instance.new("UIListLayout")
                uiListLayout.Parent=scrollingFrame
                uiListLayout.Padding=UDim.new(0,2)
                uiListLayout.SortOrder=Enum.SortOrder.LayoutOrder
                
                local optioninstances={}
                local count=0
                local chosen=allow_multiple and{}or nil
                
                local function createoption(option)
                    optioninstances[option]={}
                    count=count+1
                    
                    local button=utility.createTextButton({
                        Name="Option_"..option,
                        Parent=scrollingFrame,
                        BackgroundColor3=library.theme["Object Background"],
                        Size=UDim2.new(1,0,0,16),
                        Text="",
                        AutoButtonColor=false,
                        BorderSizePixel=1,
                        BorderColor3=library.theme["Section Inner Border"]
                    })
                    
                    optioninstances[option].button=button
                    
                    local title=utility.create("TextLabel",{
                        Name="Title",
                        Parent=button,
                        Text=option,
                        BackgroundTransparency=1,
                        TextColor3=library.theme["Text"],
                        TextSize=13,
                        FontFace=UI_FONT,
                        Position=UDim2.new(0,8,0,1),
                        Size=UDim2.new(1,-10,1,0),
                        TextXAlignment=Enum.TextXAlignment.Left
                    })
                    
                    optioninstances[option].text=title
                    
                    return button,title
                end
                
                local function handleoptionclick(option,button,text)
                    button.MouseButton1Click:Connect(function()
                        if allow_multiple then
                            if table.find(chosen,option)then
                                table.remove(chosen,table.find(chosen,option))
                                text.TextColor3=library.theme["Text"]
                            else
                                if max and#chosen>=max then
                                    local first=chosen[1]
                                    table.remove(chosen,1)
                                    optioninstances[first].text.TextColor3=library.theme["Text"]
                                end
                                table.insert(chosen,option)
                                text.TextColor3=library.theme["Accent"]
                            end
                            library.flags[flag]=chosen
                            callback(chosen)
                        else
                            if chosen==option then
                                chosen=nil
                                text.TextColor3=library.theme["Text"]
                            else
                                if chosen and optioninstances[chosen]then
                                    optioninstances[chosen].text.TextColor3=library.theme["Text"]
                                end
                                chosen=option
                                text.TextColor3=library.theme["Accent"]
                            end
                            library.flags[flag]=chosen
                            callback(chosen)
                        end
                    end)
                end
                
                local listboxtypes={}
                
                function listboxtypes:add_option(option)
                    local button,text=createoption(option)
                    handleoptionclick(option,button,text)
                    
                    if scrollable then
                        scrollingFrame.CanvasSize=UDim2.new(0,0,0,count*18)
                    end
                end
                
                function listboxtypes:remove_option(option)
                    if optioninstances[option]then
                        optioninstances[option].button:Destroy()
                        optioninstances[option]=nil
                        count=count-1
                        
                        if allow_multiple then
                            if table.find(chosen,option)then
                                table.remove(chosen,table.find(chosen,option))
                            end
                        else
                            if chosen==option then
                                chosen=nil
                            end
                        end
                        
                        if scrollable then
                            scrollingFrame.CanvasSize=UDim2.new(0,0,0,count*18)
                        end
                        
                        library.flags[flag]=chosen
                        callback(chosen)
                    end
                end
                
                function listboxtypes:set_options(options)
                    for _,option in next,optioninstances do
                        option.button:Destroy()
                    end
                    
                    table.clear(optioninstances)
                    count=0
                    chosen=allow_multiple and{}or nil
                    
                    for _,option in next,options do
                        self:add_option(option)
                    end
                    
                    library.flags[flag]=chosen
                    callback(chosen)
                end
                
                function listboxtypes:set_selected(selected)
                    if allow_multiple then
                        chosen=type(selected)=="table"and selected or{}
                        for opt,tbl in next,optioninstances do
                            if table.find(chosen,opt)then
                                tbl.text.TextColor3=library.theme["Accent"]
                            else
                                tbl.text.TextColor3=library.theme["Text"]
                            end
                        end
                    else
                        chosen=selected
                        for opt,tbl in next,optioninstances do
                            if opt==chosen then
                                tbl.text.TextColor3=library.theme["Accent"]
                            else
                                tbl.text.TextColor3=library.theme["Text"]
                            end
                        end
                    end
                    library.flags[flag]=chosen
                    callback(chosen)
                end
                
                if cfg.options then
                    for _,option in next,cfg.options do
                        listboxtypes:add_option(option)
                    end
                end
                
                if default then
                    listboxtypes:set_selected(default)
                end
                
                return listboxtypes
            end
            
            function section_tbl:new_textbox(cfg)
                local placeholder=cfg.placeholder or cfg.Placeholder or"new textbox"
                local default=cfg.default or cfg.Default or""
                local middle=cfg.middle or cfg.Middle or false
                local flag=cfg.flag or cfg.Flag or utility.nextflag()
                local callback=cfg.callback or function()end
                
                local holder=utility.createFrame({
                    Name="TextboxHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,19),
                    BorderSizePixel=0
                })
                
                local textbox=utility.create("TextBox",{
                    Name="Textbox",
                    Parent=holder,
                    BackgroundColor3=library.theme["Object Background"],
                    Size=UDim2.new(1,0,0,15),
                    Position=UDim2.new(0,0,1,-15),
                    Text=default,
                    PlaceholderText=placeholder,
                    TextColor3=library.theme["Text"],
                    PlaceholderColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    BorderSizePixel=1,
                    BorderColor3=library.theme["Section Inner Border"]
                })
                
                utility.outline(textbox,library.theme["Section Outer Border"])
                
                textbox:GetPropertyChangedSignal("Text"):Connect(function()
                    library.flags[flag]=textbox.Text
                    callback(textbox.Text)
                end)
                
                local function set(str)
                    textbox.Text=str
                    library.flags[flag]=str
                    callback(str)
                end
                
                set(default)
                library.flags[flag]=set
                
                return{
                    set=set
                }
            end
            function section_tbl:new_button(cfg)
                local name=cfg.name or cfg.Name or "new button"
                local flag=cfg.flag or cfg.Flag or utility.nextflag()
                local callback=cfg.callback or function()end
                
                local holder=utility.createFrame({
                    Name="ButtonHolder",
                    Parent=section_content,
                    BackgroundTransparency=1,
                    Size=UDim2.new(1,0,0,19),
                    BorderSizePixel=0
                })
                
                local button=utility.create("TextButton",{
                    Name="Button",
                    Parent=holder,
                    BackgroundColor3=library.theme["Object Background"],
                    Size=UDim2.new(1,0,0,15),
                    Position=UDim2.new(0,0,1,-15),
                    Text=name,
                    TextColor3=library.theme["Text"],
                    TextSize=13,
                    FontFace=UI_FONT,
                    BorderSizePixel=1,
                    BorderColor3=library.theme["Section Inner Border"],
                    AutoButtonColor=false
                })
                
                utility.outline(button,library.theme["Section Outer Border"])
                
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                local function set(text)
                    button.Text=text
                end
                
                library.flags[flag]=set
                
                return{
                    set=set
                }
            end
            return section_tbl
        end
        
        return page_tbl
    end
    
    return window_tbl
end



return library
