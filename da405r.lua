local settings = {
    folder_name = "zephyrus";
    default_accent = Color3.fromRGB(61, 100, 227);
};

local function tween(obj, info, props)
    local tweenInfo = TweenInfo.new(
        info.Time or 1,
        info.EasingStyle or Enum.EasingStyle.Linear,
        info.EasingDirection or Enum.EasingDirection.Out,
        info.RepeatCount or 0,
        info.Reverses or false,
        info.DelayTime or 0
    )
    
    local tween = game:GetService("TweenService"):Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function loadCustomFont()
    local fontName = "Font_"..tostring(math.random(10000,99999))
    local folderName = "Folder_"..tostring(math.random(10000,99999))
    
    if isfolder("UI_Fonts") then
        delfolder("UI_Fonts")
    end
    
    makefolder(folderName)
    local fontPath = folderName.."/"..fontName..".ttf"
    
    if not isfile(fontPath) then
        local success, result = pcall(function()
            local response = request({
                Url = "https://raw.githubusercontent.com/bluescan/proggyfonts/refs/heads/master/ProggyOriginal/ProggyClean.ttf",
                Method = "GET"
            })
            if response and response.Success then
                writefile(fontPath, response.Body)
                return true
            end
            return false
        end)
        
        if not success then
            return Enum.Font.Code
        end
    end
    
    local fontSuccess, font = pcall(function()
        local fontData = readfile(fontPath)
        return game:GetService("TextService"):RegisterFontFaceAsync(fontData, fontName)
    end)
    
    if fontSuccess then
        return font
    end
    
    local fontFileSuccess = pcall(function()
        return Font.fromFilename(fontPath)
    end)
    
    if fontFileSuccess then
        return font
    end
    
    local fontConfig = {
        name = fontName,
        faces = {{
            name = "Regular",
            weight = 400,
            style = "Normal",
            assetId = getcustomasset(fontPath)
        }}
    }
    
    local configPath = folderName.."/"..fontName..".json"
    writefile(configPath, game:GetService("HttpService"):JSONEncode(fontConfig))
    
    local fontNewSuccess, newFont = pcall(function()
        return Font.new(getcustomasset(configPath))
    end)
    
    if fontNewSuccess then
        return newFont
    end
    
    return Enum.Font.Code
end

local customFont = loadCustomFont()

if not isfolder(settings.folder_name) then
    makefolder(settings.folder_name)
    makefolder(settings.folder_name.."/configs")
    makefolder(settings.folder_name.."/assets")
end

local services = setmetatable({}, {
    __index = function(_, k)
        k = (k == "InputService" and "UserInputService") or k
        return game:GetService(k)
    end
})

local client = services.Players.LocalPlayer

local utility = {}
local totalunnamedflags = 0

function utility.dragify(main, object)
    local start, objectPosition, dragging
    
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            objectPosition = object.Position
        end
    end)
    
    utility.connect(services.InputService.InputChanged, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - start
            object.Position = UDim2.new(
                objectPosition.X.Scale, 
                objectPosition.X.Offset + delta.X,
                objectPosition.Y.Scale, 
                objectPosition.Y.Offset + delta.Y
            )
        end
    end)
    
    utility.connect(services.InputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function utility.textlength(str, font, fontsize)
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = str
    textLabel.FontFace = font
    textLabel.TextSize = fontsize
    textLabel.Size = UDim2.new(0, 1000, 0, 100)
    textLabel.Parent = game:GetService("CoreGui")
    
    local textBounds = textLabel.TextBounds
    textLabel:Destroy()
    
    return textBounds
end

function utility.getcenter(sizeX, sizeY)
    return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end

function utility.table(tbl, usemt)
    tbl = tbl or {}
    local oldtbl = table.clone(tbl)
    table.clear(tbl)
    
    for i, v in next, oldtbl do
        if type(i) == "string" then
            tbl[i:lower()] = v
        else
            tbl[i] = v
        end
    end
    
    if usemt == true then
        setmetatable(tbl, {
            __index = function(t, k)
                return rawget(t, k:lower()) or rawget(t, k)
            end,
            __newindex = function(t, k, v)
                if type(k) == "string" then
                    rawset(t, k:lower(), v)
                else
                    rawset(t, k, v)
                end
            end
        })
    end
    
    return tbl
end

function utility.colortotable(color)
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
    return {r, g, b}
end

function utility.tabletocolor(tbl)
    return Color3.fromRGB(unpack(tbl))
end

function utility.round(number, float)
    return float * math.floor(number / float)
end

function utility.getrgb(color)
    local r = color.R * 255
    local g = color.G * 255
    local b = color.B * 255
    return r, g, b
end

function utility.changecolor(color, number)
    local r, g, b = utility.getrgb(color)
    r, g, b = math.clamp(r + number, 0, 255), math.clamp(g + number, 0, 255), math.clamp(b + number, 0, 255)
    return Color3.fromRGB(r, g, b)
end

function utility.nextflag()
    totalunnamedflags = totalunnamedflags + 1
    return string.format("%.14g", totalunnamedflags)
end

function utility.rgba(r, g, b, alpha)
    return Color3.fromRGB(r, g, b)
end

local themes = {
    ["Default"] = {
        ["Accent"] = settings.default_accent,
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(245, 245, 245),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    };
}

local themeobjects = {}
local library = {
    theme = table.clone(themes.Default),
    currentcolor = nil, 
    folder = "zephyrus", 
    flags = {}, 
    open = true, 
    mousestate = services.InputService.MouseIconEnabled, 
    cursor = nil, 
    holder = nil, 
    connections = {}, 
    notifications = {}
};

library.utility = utility

function utility.create(class, properties)
    local obj = Instance.new(class)
    
    for prop, v in next, properties do
        if prop == "Parent" then
            obj.Parent = v
        elseif prop == "Theme" then
            themeobjects[obj] = v
            if obj:IsA("GuiObject") then
                obj.BackgroundColor3 = library.theme[v]
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.TextColor3 = library.theme[v]
            end
        else
            if obj[prop] ~= nil then
                if prop == "FontFace" then
                    obj.FontFace = customFont
                else
                    obj[prop] = v
                end
            end
        end
    end
    
    return obj
end

function utility.outline(parent, color, thickness)
    thickness = thickness or 1
    
    local outline = utility.create("Frame", {
        Name = "Outline",
        Parent = parent,
        BackgroundColor3 = typeof(color) == "Color3" and color or library.theme[color],
        BorderSizePixel = 0,
        Position = UDim2.new(0, -thickness, 0, -thickness),
        Size = UDim2.new(1, thickness * 2, 1, thickness * 2),
        ZIndex = parent.ZIndex - 1
    })
    
    if typeof(color) == "string" then
        themeobjects[outline] = color
    end
    
    return outline
end

function utility.changeobjecttheme(object, color)
    themeobjects[object] = color
    if object:IsA("GuiObject") then
        object.BackgroundColor3 = library.theme[color]
    elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        object.TextColor3 = library.theme[color]
    end
end

function utility.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(library.connections, connection)
    return connection
end

function utility.disconnect(connection)
    local index = table.find(library.connections, connection)
    connection:Disconnect()
    
    if index then
        table.remove(library.connections, index)
    end
end

function utility.hextorgb(hex)
    return Color3.fromRGB(
        tonumber("0x" .. hex:sub(1, 2)), 
        tonumber("0x" .. hex:sub(3, 4)), 
        tonumber("0x"..hex:sub(5, 6))
    )
end

local accentobjs = {}
local flags = {}
local configignores = {}

function library:ConfigIgnore(flag)
    table.insert(configignores, flag)
end

function library:Close()
    self.open = not self.open
    
    if self.holder then
        self.holder.Visible = self.open
    end
end

function library:ChangeThemeOption(option, color)
    self.theme[option] = color
    
    for obj, theme in next, themeobjects do
        if obj and obj.Parent and theme == option then
            if obj:IsA("GuiObject") then
                obj.BackgroundColor3 = color
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.TextColor3 = color
            end
        end
    end
end

function library:SetTheme(theme)
    self.currenttheme = theme
    self.theme = table.clone(theme)
    
    for object, color in next, themeobjects do
        if object and object.Parent then
            if object:IsA("GuiObject") then
                object.BackgroundColor3 = self.theme[color]
            elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                object.TextColor3 = self.theme[color]
            end
        end
    end
end

local pickers = {}
--[[
function library.createcolorpicker(default, parent, count, flag, callback, offset)
    local icon = utility.create("TextButton", {
        Name = "ColorPickerIcon",
        Parent = parent,
        BackgroundColor3 = default,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8,
        Text = "",
        AutoButtonColor = false
    })
    
    local outline = utility.outline(icon, "Section Inner Border")
    utility.outline(outline, "Section Outer Border")
    
    local window = utility.create("Frame", {
        Name = "ColorPickerWindow",
        Parent = icon,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 185, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })
    
    table.insert(pickers, window)
    
    local outline1 = utility.outline(window, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    
    local saturation = utility.create("Frame", {
        Name = "Saturation",
        Parent = window,
        BackgroundColor3 = default,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })
    
    utility.outline(saturation, "Section Inner Border")
    
    local hueframe = utility.create("Frame", {
        Name = "HueFrame",
        Parent = window,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })
    
    utility.outline(hueframe, "Section Inner Border")
    
    local hueColors = {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new(hueColors)
    hueGradient.Rotation = 90
    hueGradient.Parent = hueframe
    
    local saturationpicker = utility.create("Frame", {
        Name = "SaturationPicker",
        Parent = saturation,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 0, 4),
        Position = UDim2.new(0.5, -2, 0.5, -2),
        ZIndex = 26
    })
    
    local huepicker = utility.create("Frame", {
        Name = "HuePicker",
        Parent = hueframe,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 26
    })
    
    local rgbinput = utility.create("Frame", {
        Name = "RGBInput",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24
    })
    
    local outline2 = utility.outline(rgbinput, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    
    local text = utility.create("TextLabel", {
        Name = "RGBText",
        Parent = rgbinput,
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        FontFace = customFont,
        TextSize = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 26
    })
    
    local copy = utility.create("TextButton", {
        Name = "CopyButton",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Text = "copy",
        FontFace = customFont,
        TextSize = 13,
        TextColor3 = library.theme["Text"]
    })
    
    local outline3 = utility.outline(copy, "Section Inner Border")
    utility.outline(outline3, "Section Outer Border")
    
    local paste = utility.create("TextButton", {
        Name = "PasteButton",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Text = "paste",
        FontFace = customFont,
        TextSize = 13,
        TextColor3 = library.theme["Text"]
    })
    
    local outline4 = utility.outline(paste, "Section Inner Border")
    utility.outline(outline4, "Section Outer Border")
    
    local mouseover = false
    local hue, sat, val = default:ToHSV()
    local hsv = Color3.fromHSV(hue, sat, val)
    local current_val = default
    
    copy.MouseButton1Click:Connect(function()
        library.currentcolor = current_val
    end)
    
    paste.MouseButton1Click:Connect(function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end
    end)
    
    local function set(color, nopos, setcolor)
        if type(color) == "table" then
            color = Color3.fromHex(color.color)
        end
        
        if type(color) == "string" then
            color = Color3.fromHex(color)
        end
        
        local oldcolor = hsv
        hue, sat, val = color:ToHSV()
        hsv = Color3.fromHSV(hue, sat, val)
        
        if hsv ~= oldcolor then
            icon.BackgroundColor3 = hsv
            
            if not nopos then
                saturationpicker.Position = UDim2.new(sat, -2, 1 - val, -2)
                huepicker.Position = UDim2.new(0, 0, hue, -1)
                if setcolor then
                    saturation.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end
            
            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))
            
            if flag then
                library.flags[flag] = utility.rgba(hsv.R * 255, hsv.G * 255, hsv.B * 255)
            end
            
            callback(Color3.fromRGB(hsv.R * 255, hsv.G * 255, hsv.B * 255))
            current_val = Color3.fromRGB(hsv.R * 255, hsv.G * 255, hsv.B * 255)
        end
    end
    
    flags[flag] = set
    set(default)
    
    local curhuesizey = hue
    local slidingsaturation = false
    local slidinghue = false
    
    local function updatesatval(input)
        local sizeX = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = math.clamp((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
        local posX = math.clamp((input.Position.X - saturation.AbsolutePosition.X), 0, saturation.AbsoluteSize.X)
        local posY = math.clamp((input.Position.Y - saturation.AbsolutePosition.Y), 0, saturation.AbsoluteSize.Y)
        
        saturationpicker.Position = UDim2.new(0, posX - 2, 0, posY - 2)
        sat = sizeX
        val = 1 - sizeY
        
        set(Color3.fromHSV(curhuesizey or hue, sat, val), true, false)
    end
    
    local function updatehue(input)
        local sizeY = math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y), 0, hueframe.AbsoluteSize.Y)
        
        huepicker.Position = UDim2.new(0, 0, 0, posY - 1)
        saturation.BackgroundColor3 = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY
        hue = sizeY
        
        set(Color3.fromHSV(sizeY, sat, val), true, true)
    end
    
    local saturationButton = utility.create("TextButton", {
        Name = "SaturationButton",
        Parent = saturation,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 27
    })
    
    local hueButton = utility.create("TextButton", {
        Name = "HueButton",
        Parent = hueframe,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 27
    })
    
    saturationButton.MouseButton1Down:Connect(function()
        slidingsaturation = true
    end)
    
    saturationButton.MouseButton1Up:Connect(function()
        slidingsaturation = false
    end)
    
    hueButton.MouseButton1Down:Connect(function()
        slidinghue = true
    end)
    
    hueButton.MouseButton1Up:Connect(function()
        slidinghue = false
    end)
    
    saturationButton.MouseMoved:Connect(function(x, y)
        if slidingsaturation then
            local input = {Position = Vector2.new(x, y)}
            updatesatval(input)
        end
    end)
    
    hueButton.MouseMoved:Connect(function(x, y)
        if slidinghue then
            local input = {Position = Vector2.new(x, y)}
            updatehue(input)
        end
    end)
    
    saturationButton.TouchLongPress:Connect(function()
        slidingsaturation = true
    end)
    
    saturationButton.TouchEnded:Connect(function()
        slidingsaturation = false
    end)
    
    hueButton.TouchLongPress:Connect(function()
        slidinghue = true
    end)
    
    hueButton.TouchEnded:Connect(function()
        slidinghue = false
    end)
    
    saturationButton.TouchMoved:Connect(function(touchPositions)
        if slidingsaturation then
            local input = {Position = touchPositions[1].Position}
            updatesatval(input)
        end
    end)
    
    hueButton.TouchMoved:Connect(function(touchPositions)
        if slidinghue then
            local input = {Position = touchPositions[1].Position}
            updatehue(input)
        end
    end)
    
    icon.MouseButton1Click:Connect(function()
        for _, picker in next, pickers do
            if picker ~= window then
                picker.Visible = false
            end
        end
        
        window.Visible = not window.Visible
        
        if slidinghue then
            slidinghue = false
        end
        
        if slidingsaturation then
            slidingsaturation = false
        end
    end)
    

    
    local colorpickertypes = {}
    
    function colorpickertypes:set(color)
        set(color)
    end
    
    return colorpickertypes, window
end
--]]
function library.createcolorpicker(default, parent, count, flag, callback, offset)
    local icon = utility.create("TextButton", {
        Name = "ColorPickerIcon",
        Parent = parent,
        BackgroundColor3 = default,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8,
        Text = "",
        AutoButtonColor = false
    })
    
    local outline = utility.outline(icon, "Section Inner Border")
    utility.outline(outline, "Section Outer Border")
    
    local window = utility.create("Frame", {
        Name = "ColorPickerWindow",
        Parent = icon,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 185, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })
    
    table.insert(pickers, window)
    
    local outline1 = utility.outline(window, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    
    local saturation = utility.create("Frame", {
        Name = "Saturation",
        Parent = window,
        BackgroundColor3 = default,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })
    
    utility.outline(saturation, "Section Inner Border")
    
    local hueframe = utility.create("Frame", {
        Name = "HueFrame",
        Parent = window,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })
    
    utility.outline(hueframe, "Section Inner Border")
    
    local hueColors = {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    
    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new(hueColors)
    hueGradient.Rotation = 90
    hueGradient.Parent = hueframe
    
    local saturationpicker = utility.create("Frame", {
        Name = "SaturationPicker",
        Parent = saturation,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 0, 4),
        Position = UDim2.new(0.5, -2, 0.5, -2),
        ZIndex = 26
    })
    
    local huepicker = utility.create("Frame", {
        Name = "HuePicker",
        Parent = hueframe,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 26
    })
    
    local rgbinput = utility.create("Frame", {
        Name = "RGBInput",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24
    })
    
    local outline2 = utility.outline(rgbinput, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    
    local text = utility.create("TextLabel", {
        Name = "RGBText",
        Parent = rgbinput,
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        FontFace = customFont,
        TextSize = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 26
    })
    
    local copy = utility.create("TextButton", {
        Name = "CopyButton",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Text = "copy",
        FontFace = customFont,
        TextSize = 13,
        TextColor3 = library.theme["Text"]
    })
    
    local outline3 = utility.outline(copy, "Section Inner Border")
    utility.outline(outline3, "Section Outer Border")
    
    local paste = utility.create("TextButton", {
        Name = "PasteButton",
        Parent = window,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Text = "paste",
        FontFace = customFont,
        TextSize = 13,
        TextColor3 = library.theme["Text"]
    })
    
    local outline4 = utility.outline(paste, "Section Inner Border")
    utility.outline(outline4, "Section Outer Border")
    
    local hue, sat, val = default:ToHSV()
    local hsv = Color3.fromHSV(hue, sat, val)
    local current_val = default
    
    copy.MouseButton1Click:Connect(function()
        library.currentcolor = current_val
    end)
    
    paste.MouseButton1Click:Connect(function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end
    end)
    

    
    local function set(color, nopos, setcolor)
        if type(color) == "table" then
            color = Color3.fromHex(color.color)
        end
        
        if type(color) == "string" then
            color = Color3.fromHex(color)
        end
        
        local oldcolor = hsv
        hue, sat, val = color:ToHSV()
        hsv = Color3.fromHSV(hue, sat, val)
        
        if hsv ~= oldcolor then
            icon.BackgroundColor3 = hsv
            
            if not nopos then
                saturationpicker.Position = UDim2.new(sat, -2, 1 - val, -2)
                huepicker.Position = UDim2.new(0, 0, hue, -1)
                if setcolor then
                    saturation.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end
            
            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))
            
            if flag then
                library.flags[flag] = utility.rgba(hsv.R * 255, hsv.G * 255, hsv.B * 255)
            end
            
            callback(Color3.fromRGB(hsv.R * 255, hsv.G * 255, hsv.B * 255))
            current_val = Color3.fromRGB(hsv.R * 255, hsv.G * 255, hsv.B * 255)
        end
    end
    
    flags[flag] = set
    set(default)
    
    local curhuesizey = hue
    
    local function updatesatval(posX, posY)
        local sizeX = math.clamp((posX - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = math.clamp((posY - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y, 0, 1)
        
        saturationpicker.Position = UDim2.new(sizeX, -2, sizeY, -2)
        sat = sizeX
        val = sizeY
        
        set(Color3.fromHSV(curhuesizey or hue, sat, val), true, false)
    end
    
    local function updatehue(posY)
        local sizeY = math.clamp((posY - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
        
        huepicker.Position = UDim2.new(0, 0, sizeY, -1)
        saturation.BackgroundColor3 = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY
        hue = sizeY
        
        set(Color3.fromHSV(sizeY, sat, val), true, true)
    end
    
    local saturationDrag = utility.create("TextButton", {
        Name = "SaturationDrag",
        Parent = saturation,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 27,
        Text = "",
        AutoButtonColor = false
    })
    
    local hueDrag = utility.create("TextButton", {
        Name = "HueDrag",
        Parent = hueframe,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 27,
        Text = "",
        AutoButtonColor = false
    })
    
    local function createDragSystem(dragButton, areaFrame, isHue)
        local dragging = false
        
        dragButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                if isHue then
                    local posY = math.clamp(input.Position.Y - areaFrame.AbsolutePosition.Y, 0, areaFrame.AbsoluteSize.Y)
                    updatehue(posY + areaFrame.AbsolutePosition.Y)
                else
                    local posX = math.clamp(input.Position.X - areaFrame.AbsolutePosition.X, 0, areaFrame.AbsoluteSize.X)
                    local posY = math.clamp(input.Position.Y - areaFrame.AbsolutePosition.Y, 0, areaFrame.AbsoluteSize.Y)
                    updatesatval(posX + areaFrame.AbsolutePosition.X, posY + areaFrame.AbsolutePosition.Y)
                end
            end
        end)
        
        dragButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        utility.connect(services.InputService.InputChanged, function(input)
            if dragging then
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local inBounds = false
                    
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        inBounds = 
                            input.Position.X >= areaFrame.AbsolutePosition.X and 
                            input.Position.X <= areaFrame.AbsolutePosition.X + areaFrame.AbsoluteSize.X and
                            input.Position.Y >= areaFrame.AbsolutePosition.Y and 
                            input.Position.Y <= areaFrame.AbsolutePosition.Y + areaFrame.AbsoluteSize.Y
                    else
                        inBounds = true
                    end
                    
                    if inBounds then
                        if isHue then
                            local posY = math.clamp(input.Position.Y - areaFrame.AbsolutePosition.Y, 0, areaFrame.AbsoluteSize.Y)
                            updatehue(posY + areaFrame.AbsolutePosition.Y)
                        else
                            local posX = math.clamp(input.Position.X - areaFrame.AbsolutePosition.X, 0, areaFrame.AbsoluteSize.X)
                            local posY = math.clamp(input.Position.Y - areaFrame.AbsolutePosition.Y, 0, areaFrame.AbsoluteSize.Y)
                            updatesatval(posX + areaFrame.AbsolutePosition.X, posY + areaFrame.AbsolutePosition.Y)
                        end
                    end
                end
            end
        end)
    end
    
    createDragSystem(saturationDrag, saturation, false)
    createDragSystem(hueDrag, hueframe, true)
    
    icon.MouseButton1Click:Connect(function()
        for _, picker in next, pickers do
            if picker ~= window then
                picker.Visible = false
            end
        end
        
        window.Visible = not window.Visible
    end)
    

    local colorpickertypes = {}
    
    function colorpickertypes:set(color)
        set(color)
    end
    
    return colorpickertypes, window
end
--[[
function library.createlistbox(holder, content, flag, callback, default, max, size, islist)
    local listbox = utility.create("Frame", {
        Name = "ListBox",
        Parent = holder,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = islist and size == "Fill" and UDim2.new(1, 0, 1, -30) or islist and size ~= "Fill" and UDim2.new(1, 0, 0, size) or UDim2.new(1, 0, 0, 15),
        Position = islist and UDim2.new(0, 0, 0, 14) or UDim2.new(0, 0, 1, -15),
        ZIndex = 7,
        ClipsDescendants = true
    })
    
    local outline1 = utility.outline(listbox, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    
    local title = utility.create("TextLabel", {
        Name = "Title",
        Parent = listbox,
        Text = "Select...",
        FontFace = customFont,
        TextSize = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9
    })
    
    local icon = utility.create("TextLabel", {
        Name = "Icon",
        Parent = listbox,
        Text = "▼",
        FontFace = customFont,
        TextSize = 10,
        Size = UDim2.new(0, 9, 0, 6),
        Position = UDim2.new(1, -13, 0, 4),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 9
    })
    
    local contentframe = utility.create("Frame", {
        Name = "ContentFrame",
        Parent = listbox,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        ZIndex = 12,
        Visible = false,
        ClipsDescendants = true
    })
    
    local outline2 = utility.outline(contentframe, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    
    local scrollframe = utility.create("ScrollingFrame", {
        Name = "ScrollFrame",
        Parent = contentframe,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = library.theme["Section Inner Border"],
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local contentholder = utility.create("Frame", {
        Name = "ContentHolder",
        Parent = scrollframe,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0)
    })
    
    local uilistlayout = Instance.new("UIListLayout")
    uilistlayout.Parent = contentholder
    uilistlayout.Padding = UDim.new(0, 2)
    uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local optioninstances = {}
    local count = 0
    local countindex = {}
    local chosen = max and {}
    local opened = false
    
    local function createoption(name)
        optioninstances[name] = {}
        countindex[name] = count + 1
        
        local button = utility.create("TextButton", {
            Name = "Option_"..name,
            Parent = contentholder,
            BackgroundColor3 = library.theme["Object Background"],
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, 16),
            ZIndex = 14,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = count + 1
        })
        
        optioninstances[name].button = button
        
        local optionText = utility.create("TextLabel", {
            Name = "Text",
            Parent = button,
            Text = name,
            FontFace = customFont,
            TextSize = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Size = UDim2.new(1, -8, 1, 0),
            TextColor3 = library.theme["Text"],
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        
        optioninstances[name].text = optionText
        
        count = count + 1
        
        contentholder.Size = UDim2.new(1, 0, 0, count * 18)
        scrollframe.CanvasSize = UDim2.new(0, 0, 0, count * 18)
        
        if not islist then
            contentframe.Size = UDim2.new(1, 0, 0, math.min(count * 18 + 4, 150))
        end
        
        return button, optionText
    end
    
    local function handleoptionclick(option, button, text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    utility.changeobjecttheme(text, "Text")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                else
                    if #chosen == max then
                        utility.changeobjecttheme(optioninstances[chosen[1]text, "Text")
                        table.remove(chosen, 1)
                    end
                    
                    table.insert(chosen, option)
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    utility.changeobjecttheme(text, "Accent")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end
                
                chosen = option
                title.Text = option
                utility.changeobjecttheme(text, "Accent")
                
                library.flags[flag] = option
                callback(option)
                
                if not islist then
                    contentframe.Visible = false
                    opened = false
                    icon.Text = "▼"
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end
                
                chosen = option
                title.Text = option
                utility.changeobjecttheme(text, "Accent")
                
                library.flags[flag] = option
                callback(option)
                
                if not islist then
                    contentframe.Visible = false
                    opened = false
                    icon.Text = "▼"
                end
            end
        end)
    end
    
    local function createoptions(tbl)
        for _, option in next, tbl do
            local button, text = createoption(option)
            handleoptionclick(option, button, text)
        end
    end
    
    createoptions(content)
    
    local toggleButton = utility.create("TextButton", {
        Name = "ToggleButton",
        Parent = listbox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 10
    })
    
    toggleButton.MouseButton1Click:Connect(function()
        if not islist then
            opened = not opened
            contentframe.Visible = opened
            icon.Text = opened and "▲" or "▼"
        end
    end)
    
    toggleButton.TouchTap:Connect(function()
        if not islist then
            opened = not opened
            contentframe.Visible = opened
            icon.Text = opened and "▲" or "▼"
        end
    end)
    
    local set
    set = function(option)
        if max then
            option = type(option) == "table" and option or {}
            table.clear(chosen)
            
            for opt, tbl in next, optioninstances do
                if not table.find(option, opt) then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end
            
            for i, opt in next, option do
                if table.find(content, opt) and #chosen < max then
                    table.insert(chosen, opt)
                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                end
            end
            
            local textchosen = {}
            local cutobject = false
            
            for _, opt in next, chosen do
                table.insert(textchosen, opt)
                
                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end
            
            title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
            
            library.flags[flag] = chosen
            callback(chosen)
        end
        
        if not max then
            for opt, tbl in next, optioninstances do
                if opt ~= option then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end
            
            if table.find(content, option) then
                chosen = option
                title.Text = option
                utility.changeobjecttheme(optioninstances[option].text, "Accent")
                
                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil
                title.Text = "Select..."
                
                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end
    
    flags[flag] = set
    set(default)
    
    local listboxtypes = utility.table({}, true)
    
    function listboxtypes:set(option)
        set(option)
    end
    
    function listboxtypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0
        
        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Destroy()
            end)()
        end
        
        table.clear(optioninstances)
        
        createoptions(tbl)
        
        title.Text = ""
        
        if max then
            table.clear(chosen)
        else
            chosen = nil
        end
        
        library.flags[flag] = chosen
        callback(chosen)
    end
    
    function listboxtypes:addoption(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end
    
    function listboxtypes:deleteoption(option)
        if optioninstances[option] then
            count = count - 1
            
            optioninstances[option].button:Destroy()
            
            contentholder.Size = UDim2.new(1, 0, 0, count * 18)
            scrollframe.CanvasSize = UDim2.new(0, 0, 0, count * 18)
            
            if not islist then
                contentframe.Size = UDim2.new(1, 0, 0, math.min(count * 18 + 4, 150))
            end
            
            optioninstances[option] = nil
            
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end
    
    function listboxtypes:setoption(option)
        set(option)
    end
    
    return listboxtypes
end
--]]
function library.createlistbox(holder, content, flag, callback, default, max, size, islist)
    local listbox = utility.create("Frame", {
        Name = "ListBox",
        Parent = holder,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = islist and size == "Fill" and UDim2.new(1, 0, 1, -30) or islist and size ~= "Fill" and UDim2.new(1, 0, 0, size) or UDim2.new(1, 0, 0, 15),
        Position = islist and UDim2.new(0, 0, 0, 14) or UDim2.new(0, 0, 1, -15),
        ZIndex = 7,
        ClipsDescendants = true
    })
    
    local outline1 = utility.outline(listbox, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    
    local title = utility.create("TextLabel", {
        Name = "Title",
        Parent = listbox,
        Text = "Select...",
        FontFace = customFont,
        TextSize = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 9
    })
    
    local icon = utility.create("TextLabel", {
        Name = "Icon",
        Parent = listbox,
        Text = "▼",
        FontFace = customFont,
        TextSize = 10,
        Size = UDim2.new(0, 9, 0, 6),
        Position = UDim2.new(1, -13, 0, 4),
        TextColor3 = library.theme["Text"],
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 9
    })
    
    local contentframe = utility.create("Frame", {
        Name = "ContentFrame",
        Parent = listbox,
        BackgroundColor3 = library.theme["Object Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        ZIndex = 12,
        Visible = false,
        ClipsDescendants = true
    })
    
    local outline2 = utility.outline(contentframe, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    
    local scrollframe = utility.create("ScrollingFrame", {
        Name = "ScrollFrame",
        Parent = contentframe,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = library.theme["Section Inner Border"],
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local contentholder = utility.create("Frame", {
        Name = "ContentHolder",
        Parent = scrollframe,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0)
    })
    
    local uilistlayout = Instance.new("UIListLayout")
    uilistlayout.Parent = contentholder
    uilistlayout.Padding = UDim.new(0, 2)
    uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local optioninstances = {}
    local count = 0
    local countindex = {}
    local chosen = max and {}
    local opened = false
    
    local function createoption(name)
        optioninstances[name] = {}
        countindex[name] = count + 1
        
        local button = utility.create("TextButton", {
            Name = "Option_"..name,
            Parent = contentholder,
            BackgroundColor3 = library.theme["Object Background"],
            BorderSizePixel = 0,
            Size = UDim2.new(1, -4, 0, 16),
            ZIndex = 14,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = count + 1
        })
        
        optioninstances[name].button = button
        
        local optionText = utility.create("TextLabel", {
            Name = "Text",
            Parent = button,
            Text = name,
            FontFace = customFont,
            TextSize = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Size = UDim2.new(1, -8, 1, 0),
            TextColor3 = library.theme["Text"],
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15
        })
        
        optioninstances[name].text = optionText
        
        count = count + 1
        
        contentholder.Size = UDim2.new(1, 0, 0, count * 18)
        scrollframe.CanvasSize = UDim2.new(0, 0, 0, count * 18)
        
        if not islist then
            contentframe.Size = UDim2.new(1, 0, 0, math.min(count * 18 + 4, 150))
        end
        
        return button, optionText
    end
    
    local function handleoptionclick(option, button, text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    utility.changeobjecttheme(text, "Text")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                else
                    if #chosen == max then
                        utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")
                        table.remove(chosen, 1)
                    end
                    
                    table.insert(chosen, option)
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    utility.changeobjecttheme(text, "Accent")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end
                
                chosen = option
                title.Text = option
                utility.changeobjecttheme(text, "Accent")
                
                library.flags[flag] = option
                callback(option)
                
                if not islist then
                    contentframe.Visible = false
                    opened = false
                    icon.Text = "▼"
                end
            end
        end)
    end
    
    local function createoptions(tbl)
        for _, option in next, tbl do
            local button, text = createoption(option)
            handleoptionclick(option, button, text)
        end
    end
    
    createoptions(content)
    
    local toggleButton = utility.create("TextButton", {
        Name = "ToggleButton",
        Parent = listbox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 10
    })
    
    toggleButton.MouseButton1Click:Connect(function()
        if not islist then
            opened = not opened
            contentframe.Visible = opened
            icon.Text = opened and "▲" or "▼"
        end
    end)
    
    local set
    set = function(option)
        if max then
            option = type(option) == "table" and option or {}
            table.clear(chosen)
            
            for opt, tbl in next, optioninstances do
                if not table.find(option, opt) then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end
            
            for i, opt in next, option do
                if table.find(content, opt) and #chosen < max then
                    table.insert(chosen, opt)
                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                end
            end
            
            local textchosen = {}
            local cutobject = false
            
            for _, opt in next, chosen do
                table.insert(textchosen, opt)
                
                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end
            
            title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
            
            library.flags[flag] = chosen
            callback(chosen)
        end
        
        if not max then
            for opt, tbl in next, optioninstances do
                if opt ~= option then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end
            
            if table.find(content, option) then
                chosen = option
                title.Text = option
                utility.changeobjecttheme(optioninstances[option].text, "Accent")
                
                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil
                title.Text = "Select..."
                
                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end
    
    flags[flag] = set
    set(default)
    
    local listboxtypes = utility.table({}, true)
    
    function listboxtypes:set(option)
        set(option)
    end
    
    function listboxtypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0
        
        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Destroy()
            end)()
        end
        
        table.clear(optioninstances)
        
        createoptions(tbl)
        
        title.Text = ""
        
        if max then
            table.clear(chosen)
        else
            chosen = nil
        end
        
        library.flags[flag] = chosen
        callback(chosen)
    end
    
    function listboxtypes:addoption(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end
    
    function listboxtypes:deleteoption(option)
        if optioninstances[option] then
            count = count - 1
            
            optioninstances[option].button:Destroy()
            
            contentholder.Size = UDim2.new(1, 0, 0, count * 18)
            scrollframe.CanvasSize = UDim2.new(0, 0, 0, count * 18)
            
            if not islist then
                contentframe.Size = UDim2.new(1, 0, 0, math.min(count * 18 + 4, 150))
            end
            
            optioninstances[option] = nil
            
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))
                    
                    local textchosen = {}
                    local cutobject = false
                    
                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)
                        
                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", customFont, 13).X > (listbox.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end
                    
                    title.Text = #chosen == 0 and "Select..." or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end
    
    function listboxtypes:setoption(option)
        set(option)
    end
    
    return listboxtypes
end
local allowedcharacters = {}
local shiftcharacters = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~"
}

for i = 32, 126 do
    table.insert(allowedcharacters, utf8.char(i))
end

function library.createbox(box, text, callback, finishedcallback)
    box.MouseButton1Click:Connect(function()
        services.ContextActionService:BindActionAtPriority("disablekeyboard", function() return Enum.ContextActionResult.Sink end, false, 3000, Enum.UserInputType.Keyboard)
        
        local connection
        local backspaceconnection
        
        local keyqueue = 0
        
        if not connection then
            connection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Backspace then
                        local str = services.InputService:GetStringForKeyCode(input.KeyCode)
                        
                        if table.find(allowedcharacters, str) then
                            keyqueue = keyqueue + 1
                            local currentqueue = keyqueue
                            
                            if not services.InputService:IsKeyDown(Enum.KeyCode.RightShift) and not services.InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                text.Text = text.Text .. str:lower()
                                callback(text.Text)
                                
                                local ended = false
                                
                                coroutine.wrap(function()
                                    task.wait(0.5)
                                    
                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. str:lower()
                                        callback(text.Text)
                                        
                                        task.wait(0.02)
                                    end
                                end)()
                            else
                                text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                callback(text.Text)
                                
                                coroutine.wrap(function()
                                    task.wait(0.5)
                                    
                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                        callback(text.Text)
                                        
                                        task.wait(0.02)
                                    end
                                end)()
                            end
                        end
                    end
                    
                    if input.KeyCode == Enum.KeyCode.Return then
                        services.ContextActionService:UnbindAction("disablekeyboard")
                        utility.disconnect(backspaceconnection)
                        utility.disconnect(connection)
                        finishedcallback(text.Text)
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    services.ContextActionService:UnbindAction("disablekeyboard")
                    utility.disconnect(backspaceconnection)
                    utility.disconnect(connection)
                    finishedcallback(text.Text)
                end
            end)
            
            local backspacequeue = 0
            
            backspaceconnection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Backspace then
                    backspacequeue = backspacequeue + 1
                    
                    text.Text = text.Text:sub(1, -2)
                    callback(text.Text)
                    
                    local currentqueue = backspacequeue
                    
                    coroutine.wrap(function()
                        task.wait(0.5)
                        
                        if backspacequeue == currentqueue then
                            while services.InputService:IsKeyDown(Enum.KeyCode.Backspace) do
                                text.Text = text.Text:sub(1, -2)
                                callback(text.Text)
                                
                                task.wait(0.02)
                            end
                        end
                    end)()
                end
            end)
        end
    end)
end

local keys = {
    [Enum.KeyCode.LeftShift] = "LeftShift",
    [Enum.KeyCode.RightShift] = "RightShift",
    [Enum.KeyCode.LeftControl] = "LeftControl",
    [Enum.KeyCode.RightControl] = "RightControl",
    [Enum.KeyCode.LeftAlt] = "LeftAlt",
    [Enum.KeyCode.RightAlt] = "RightAlt",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Numpad1",
    [Enum.KeyCode.KeypadTwo] = "Numpad2",
    [Enum.KeyCode.KeypadThree] = "Numpad3",
    [Enum.KeyCode.KeypadFour] = "Numpad4",
    [Enum.KeyCode.KeypadFive] = "Numpad5",
    [Enum.KeyCode.KeypadSix] = "Numpad6",
    [Enum.KeyCode.KeypadSeven] = "Numpad7",
    [Enum.KeyCode.KeypadEight] = "Numpad8",
    [Enum.KeyCode.KeypadNine] = "Numpad9",
    [Enum.KeyCode.KeypadZero] = "Numpad0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MouseButton1",
    [Enum.UserInputType.MouseButton2] = "MouseButton2",
    [Enum.UserInputType.MouseButton3] = "MouseButton3"
}

function library:load_config(cfg_name)
    if isfile(cfg_name) then
        local file = readfile(cfg_name)
        local config = game:GetService("HttpService"):JSONDecode(file)
        
        for flag, v in next, config do
            local func = flags[flag]
            if func then
                func(v)
            end
        end
    end
end

function library:new_window(cfg)
    local window_tbl = {pages = {}, page_buttons = {}, page_accents = {}}
    local window_size = cfg.size or cfg.Size or Vector2.new(600,400)
    local size_x = window_size.X
    local size_y = window_size.Y
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LibraryUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false
    
    local window_outline = utility.create("Frame", {
        Name = "WindowOutline",
        Parent = screenGui,
        BackgroundColor3 = library.theme["Window Outline Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(0, size_x, 0, size_y),
        Position = utility.getcenter(size_x, size_y),
        ZIndex = 1
    })
    
    library.holder = window_outline
    
    local outline = utility.outline(window_outline, "Window Border")
    utility.outline(outline, Color3.new(0,0,0))
    
    local window_inline = utility.create("Frame", {
        Name = "WindowInline",
        Parent = window_outline,
        BackgroundColor3 = library.theme["Window Inline Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        ZIndex = 2
    })
    
    utility.outline(window_inline, "Window Border")
    
    local window_accent = utility.create("Frame", {
        Name = "WindowAccent",
        Parent = window_inline,
        BackgroundColor3 = library.theme["Accent"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, -2, 0, 2),
        Position = UDim2.new(0, 1, 0, 1),
        ZIndex = 2
    })
    
    local window_holder = utility.create("Frame", {
        Name = "WindowHolder",
        Parent = window_inline,
        BackgroundColor3 = library.theme["Window Holder Background"],
        BorderSizePixel = 0,
        Size = UDim2.new(1, -30, 1, -30),
        Position = UDim2.new(0, 15, 0, 15),
        ZIndex = 3
    })
    
    utility.outline(window_holder, "Window Border")
    
    local window_pages_holder = utility.create("Frame", {
        Name = "PagesHolder",
        Parent = window_holder,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 3
    })
    
    local window_drag = utility.create("TextButton", {
        Name = "DragButton",
        Parent = window_outline,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 10,
        Text = "",
        AutoButtonColor = false
    })
    
    utility.dragify(window_drag, window_outline)
    
    function window_tbl:new_page(cfg)
        local page_tbl = {sections = {}}
        local page_name = cfg.name or cfg.Name or "new page"
        
        local page_button = utility.create("TextButton", {
            Name = "PageButton_"..page_name,
            Parent = window_pages_holder,
            BackgroundColor3 = library.theme["Page Unselected"],
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            ZIndex = 4,
            Text = "",
            AutoButtonColor = false
        })
        
        table.insert(self.page_buttons, page_button)
        
        local page_title = utility.create("TextLabel", {
            Name = "PageTitle",
            Parent = page_button,
            Text = page_name,
            FontFace = customFont,
            TextSize = 13,
            Position = UDim2.new(0, 0, 0, 6),
            Size = UDim2.new(1, 0, 1, 0),
            TextColor3 = library.theme["Text"],
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 4
        })
        
        local page_button_accent = utility.create("Frame", {
            Name = "PageAccent",
            Parent = page_button,
            BackgroundColor3 = library.theme["Accent"],
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0, 1),
            ZIndex = 4,
            Visible = false
        })
        
        table.insert(self.page_accents, page_button_accent)
        
        local page = utility.create("Frame", {
            Name = "Page_"..page_name,
            Parent = window_holder,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, -45),
            Position = UDim2.new(0, 20, 0, 40),
            ZIndex = 4,
            Visible = false
        })
        
        table.insert(self.pages, page)
        
        local left = utility.create("Frame", {
            Name = "LeftSection",
            Parent = page,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -14, 1, -10),
            Position = UDim2.new(0, 0, 0, 0)
        })
        
        local leftList = Instance.new("UIListLayout")
        leftList.Parent = left
        leftList.Padding = UDim.new(0, 15)
        leftList.SortOrder = Enum.SortOrder.LayoutOrder
        
        local right = utility.create("Frame", {
            Name = "RightSection",
            Parent = page,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -14, 1, -10),
            Position = UDim2.new(0.5, 14, 0, 0)
        })
        
        local rightList = Instance.new("UIListLayout")
        rightList.Parent = right
        rightList.Padding = UDim.new(0, 15)
        rightList.SortOrder = Enum.SortOrder.LayoutOrder
        
        page_button.MouseButton1Click:Connect(function()
            for i, v in next, self.page_buttons do
                if v ~= page_button then
                    v.BackgroundColor3 = library.theme["Page Unselected"]
                end
            end
            
            for i, v in next, self.page_accents do
                if v ~= page_button_accent then
                    v.Visible = false
                end
            end
            
            for i, v in next, self.pages do
                if v ~= page then
                    v.Visible = false
                end
            end
            
            page_button.BackgroundColor3 = library.theme["Page Selected"]
            page_button_accent.Visible = true
            page.Visible = true
        end)
        
        page_button.TouchTap:Connect(function()
            for i, v in next, self.page_buttons do
                if v ~= page_button then
                    v.BackgroundColor3 = library.theme["Page Unselected"]
                end
            end
            
            for i, v in next, self.page_accents do
                if v ~= page_button_accent then
                    v.Visible = false
                end
            end
            
            for i, v in next, self.pages do
                if v ~= page then
                    v.Visible = false
                end
            end
            
            page_button.BackgroundColor3 = library.theme["Page Selected"]
            page_button_accent.Visible = true
            page.Visible = true
        end)
        
        for _, v in next, self.page_buttons do
            v.Size = UDim2.new(1 / #self.page_buttons, _ == 1 and 1 or _ == #self.page_buttons and -2 or -1, 1, 0)
            v.Position = UDim2.new(1 / (#self.page_buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 0)
        end
        
        function page_tbl:open()
            page_button.BackgroundColor3 = library.theme["Page Selected"]
            page_button_accent.Visible = true
            page.Visible = true
        end
        
        function page_tbl:new_section(cfg)
            local section_tbl = {}
            local section_name = cfg.name or cfg.Name or "new section"
            local section_side = cfg.side == "left" and left or cfg.Side == "left" and left or cfg.side == "right" and right or cfg.Side == "right" and right or left
            local section_size = cfg.size or cfg.Size or 200
            
            local section = utility.create("Frame", {
                Name = "Section_"..section_name,
                Parent = section_side,
                BackgroundColor3 = library.theme["Section Background"],
                BorderSizePixel = 0,
                Size = section_size ~= "Fill" and UDim2.new(1, 0, 0, section_size) or UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 5
            })
            
            local outline = utility.outline(section, "Section Inner Border")
            utility.outline(outline, "Section Outer Border")
            
            local section_title_cover = utility.create("Frame", {
                Name = "TitleCover",
                Parent = section,
                BackgroundColor3 = library.theme["Window Holder Background"],
                BorderSizePixel = 0,
                Size = UDim2.new(0, utility.textlength(section_name, customFont, 13).X + 2, 0, 4),
                Position = UDim2.new(0, 10, 0, -4),
                ZIndex = 5
            })
            
            local section_title = utility.create("TextLabel", {
                Name = "SectionTitle",
                Parent = section,
                Text = section_name,
                FontFace = customFont,
                TextSize = 13,
                Position = UDim2.new(0, 10, 0, -8),
                Size = UDim2.new(0, utility.textlength(section_name, customFont, 13).X, 0, 13),
                TextColor3 = library.theme["Text"],
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5
            })
            
            local section_content = utility.create("Frame", {
                Name = "SectionContent",
                Parent = section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -32, 1, -10),
                Position = UDim2.new(0, 16, 0, 15),
                ZIndex = 6
            })
            
            local contentList = Instance.new("UIListLayout")
            contentList.Parent = section_content
            contentList.Padding = UDim.new(0, 8)
            contentList.SortOrder = Enum.SortOrder.LayoutOrder
            
            function section_tbl:new_toggle(cfg)
                local toggle_tbl = {colorpickers = 0}
                local toggle_name = cfg.name or cfg.Name or "new toggle"
                local toggle_risky = cfg.risky or cfg.Risky or false
                local toggle_state = cfg.state or cfg.State or false
                local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or cfg.Callback or function() end
                local toggled = false
                
                local holder = utility.create("Frame", {
                    Name = "ToggleHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 8),
                    ZIndex = 8
                })
                
                local toggle_frame = utility.create("TextButton", {
                    Name = "ToggleFrame",
                    Parent = holder,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 8, 0, 8),
                    ZIndex = 7,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local outline = utility.outline(toggle_frame, "Section Inner Border")
                utility.outline(outline, "Section Outer Border")
                
                local toggle_title = utility.create("TextLabel", {
                    Name = "ToggleTitle",
                    Parent = holder,
                    Text = toggle_name,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0, 13, 0, -3),
                    Size = UDim2.new(1, -13, 1, 0),
                    TextColor3 = toggle_risky and library.theme["Risky Text"] or library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6
                })
                
                local function setstate()
                    toggled = not toggled
                    if toggled then
                        toggle_frame.BackgroundColor3 = library.theme["Accent"]
                    else
                        toggle_frame.BackgroundColor3 = library.theme["Object Background"]
                    end
                    library.flags[toggle_flag] = toggled
                    callback(toggled)
                end
                
                toggle_frame.MouseButton1Click:Connect(setstate)
            
                
                local function set(bool)
                    bool = type(bool) == "boolean" and bool or false
                    if toggled ~= bool then
                        setstate()
                    end
                end
                
                set(toggle_state)
                flags[toggle_flag] = set
                
                local toggletypes = {}
                
                function toggletypes:set(bool)
                    set(bool)
                end
                
                function toggletypes:new_colorpicker(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0)
                    local flag = cfg.flag or cfg.Flag or utility.nextflag()
                    local callback = cfg.callback or function() end
                    local colorpicker_tbl = {}
                    
                    toggle_tbl.colorpickers += 1
                    
                    local cp = library.createcolorpicker(default, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                    
                    function colorpicker_tbl:set(color)
                        cp:set(color)
                    end
                    
                    return colorpicker_tbl
                end
                
                return toggletypes
            end
            
            function section_tbl:new_slider(cfg)
                    local slider_tbl = {}
                    local name = cfg.name or cfg.Name or "new slider"
                    local min = cfg.min or cfg.minimum or 0
                    local max = cfg.max or cfg.maximum or 100
                    local text = cfg.text or ("[value]/"..max)
                    local float = cfg.float or 1
                    local default = cfg.default and math.clamp(cfg.default, min, max) or min
                    local flag = cfg.flag or utility.nextflag()
                    local callback = cfg.callback or function() end
                    
                    local UserInputService = game:GetService("UserInputService")
                    
                    local holder = utility.create("Frame", {
                        Name = "SliderHolder",
                        Parent = section_content,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        ZIndex = 6
                    })
                    
                    local slider_frame = utility.create("Frame", {
                        Name = "SliderFrame",
                        Parent = holder,
                        BackgroundColor3 = library.theme["Object Background"],
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 5),
                        Position = UDim2.new(0, 0, 0, 15),
                        ZIndex = 7
                    })
                    
                    local outline = utility.outline(slider_frame, "Section Inner Border")
                    utility.outline(outline, "Section Outer Border")
                    
                    local slider_title = utility.create("TextLabel", {
                        Name = "SliderTitle",
                        Parent = holder,
                        Text = name,
                        FontFace = customFont,
                        TextSize = 13,
                        Position = UDim2.new(0, -2, 0, -2),
                        Size = UDim2.new(1, 0, 0, 13),
                        TextColor3 = library.theme["Text"],
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 6
                    })
                    
                    local slider_value = utility.create("TextLabel", {
                        Name = "SliderValue",
                        Parent = slider_frame,
                        Text = text:gsub("%[value%]", string.format("%.14g", default)),
                        FontFace = customFont,
                        TextSize = 11,
                        Position = UDim2.new(0.5, 0, 0.5, -5),
                        Size = UDim2.new(1, 0, 1, 0),
                        TextColor3 = library.theme["Text"],
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        ZIndex = 8
                    })
                    
                    local slider_fill = utility.create("Frame", {
                        Name = "SliderFill",
                        Parent = slider_frame,
                        BackgroundColor3 = library.theme["Accent"],
                        BorderSizePixel = 0,
                        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                        ZIndex = 7
                    })
                    
                    local slider_drag = utility.create("TextButton", {
                        Name = "SliderDrag",
                        Parent = slider_frame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        ZIndex = 8,
                        Text = "",
                        AutoButtonColor = false
                    })
                    
                    local function set(value)
                        value = math.clamp(utility.round(value, float), min, max)
                        slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                        local sizeX = ((value - min) / (max - min))
                        slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                        library.flags[flag] = value
                        callback(value)
                    end
                    
                    set(default)
                    
                    local sliding = false
                    
                    local function slide(input)
                        local sizeX = math.clamp((input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X, 0, 1)
                        local value = ((max - min) * sizeX) + min
                        set(value)
                    end
                    
                    slider_drag.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = true
                            slide(input)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = false
                        end
                    end)
                    
                    slider_drag.InputChanged:Connect(function(input)
                        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            slide(input)
                        end
                    end)
                    
                    flags[flag] = set
                    
                    function slider_tbl:set(value)
                        set(value)
                    end
                    
                    return slider_tbl
            end
            
            function section_tbl:new_button(cfg)
                local button_tbl = {}
                local button_name = cfg.name or cfg.Name or "new button"
                local button_confirm = cfg.confirm or cfg.Confirm or false
                local callback = cfg.callback or cfg.Callback or function() end
                
                local holder = utility.create("Frame", {
                    Name = "ButtonHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    ZIndex = 6
                })
                
                local button_frame = utility.create("TextButton", {
                    Name = "ButtonFrame",
                    Parent = holder,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 7,
                    Text = button_name,
                    FontFace = customFont,
                    TextSize = 13,
                    TextColor3 = library.theme["Text"],
                    AutoButtonColor = false
                })
                
                local outline = utility.outline(button_frame, "Section Inner Border")
                utility.outline(outline, "Section Outer Border")
                
                local clicked, counting = false, false
                
                button_frame.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        if button_confirm then
                            if clicked then
                                clicked = false
                                counting = false
                                button_frame.TextColor3 = library.theme["Text"]
                                button_frame.Text = button_name
                                callback()
                            else
                                clicked = true
                                counting = true
                                for i = 3, 1, -1 do
                                    if not counting then
                                        break
                                    end
                                    button_frame.Text = 'confirm '..button_name..'? '..tostring(i)
                                    button_frame.TextColor3 = library.theme["Accent"]
                                    wait(1)
                                end
                                clicked = false
                                counting = false
                                button_frame.TextColor3 = library.theme["Text"]
                                button_frame.Text = button_name
                            end
                        else
                            callback()
                        end
                    end)
                end)
                
            
                
                button_frame.MouseButton1Down:Connect(function()
                    button_frame.BackgroundColor3 = library.theme["Accent"]
                end)
                
                button_frame.MouseButton1Up:Connect(function()
                    button_frame.BackgroundColor3 = library.theme["Object Background"]
                end)
            end
            
            function section_tbl:new_listbox(cfg)
                local listbox_tbl = {}
                local name = cfg.name or cfg.Name or "new listbox"
                local default = cfg.default or cfg.Default or nil
                local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {}
                local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil
                local size = cfg.size or 100
                local islist = cfg.list or false
                local flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or function() end
                
                if not max and type(default) == "table" then
                    default = nil
                end
                
                if max and default == nil then
                    default = {}
                end
                
                if type(default) == "table" then
                    if max then
                        for i, opt in next, default do
                            if not table.find(content, opt) then
                                table.remove(default, i)
                            elseif i > max then
                                table.remove(default, i)
                            end
                        end
                    else
                        default = nil
                    end
                elseif default ~= nil then
                    if not table.find(content, default) then
                        default = nil
                    end
                end
                
                local holder = utility.create("Frame", {
                    Name = "ListboxHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = islist and size == "Fill" and UDim2.new(1, 0, 1, 0) or islist and UDim2.new(1, 0, 0, size + 15) or UDim2.new(1, 0, 0, 29),
                    ZIndex = 7
                })
                
                local title = utility.create("TextLabel", {
                    Name = "ListboxTitle",
                    Parent = holder,
                    Text = name,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Size = UDim2.new(1, 0, 0, 13),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 7
                })
                
                return library.createlistbox(holder, content, flag, callback, default, max, size, islist)
            end
            
            function section_tbl:new_keybind(cfg)
                local keybind_tbl = {}
                local name = cfg.name or cfg.Name or "new keybind"
                local key_name = cfg.keybind_name or cfg.KeyBind_Name or name
                local default = cfg.default or cfg.Default or nil
                local mode = cfg.mode or cfg.Mode or "Hold"
                local blacklist = cfg.blacklist or cfg.Blacklist or {}
                local flag = cfg.flag or utility.nextflag()
                local callback = cfg.callback or function() end
                local ignore_list = cfg.ignore or cfg.Ignore or false
                local key_mode = mode
                
                local holder = utility.create("Frame", {
                    Name = "KeybindHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 29),
                    ZIndex = 7
                })
                
                local title = utility.create("TextLabel", {
                    Name = "KeybindTitle",
                    Parent = holder,
                    Text = name,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Size = UDim2.new(1, 0, 0, 13),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 7
                })
                
                local frame = utility.create("TextButton", {
                    Name = "KeybindFrame",
                    Parent = holder,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    ZIndex = 8,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local outline1 = utility.outline(frame, "Section Inner Border")
                utility.outline(outline1, "Section Outer Border")
                
                local mode_frame = utility.create("Frame", {
                    Name = "ModeFrame",
                    Parent = frame,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 44, 0, 35),
                    Position = UDim2.new(1, 10, 0, -10),
                    ZIndex = 8,
                    Visible = false
                })
                
                local mode_outline1 = utility.outline(mode_frame, "Section Inner Border")
                utility.outline(mode_outline1, "Section Outer Border")
                
                local holdtext = utility.create("TextLabel", {
                    Name = "HoldText",
                    Parent = mode_frame,
                    Text = "Hold",
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0.5, 0, 0, 2),
                    Size = UDim2.new(1, 0, 0, 12),
                    TextColor3 = key_mode == "Hold" and library.theme["Accent"] or library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 8
                })
                
                local toggletext = utility.create("TextLabel", {
                    Name = "ToggleText",
                    Parent = mode_frame,
                    Text = "Toggle",
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0.5, 0, 0, 18),
                    Size = UDim2.new(1, 0, 0, 12),
                    TextColor3 = key_mode == "Toggle" and library.theme["Accent"] or library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 8
                })
                
                local holdbutton = utility.create("TextButton", {
                    Name = "HoldButton",
                    Parent = mode_frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    Position = UDim2.new(0, 0, 0, 2),
                    ZIndex = 8,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local togglebutton = utility.create("TextButton", {
                    Name = "ToggleButton",
                    Parent = mode_frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    Position = UDim2.new(0, 0, 0, 20),
                    ZIndex = 8,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local keytext = utility.create("TextLabel", {
                    Name = "KeyText",
                    Parent = frame,
                    Text = "",
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0, 2, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                holdbutton.MouseButton1Click:Connect(function()
                    key_mode = "Hold"
                    holdtext.TextColor3 = library.theme["Accent"]
                    toggletext.TextColor3 = library.theme["Text"]
                    mode_frame.Visible = false
                end)
                
                togglebutton.MouseButton1Click:Connect(function()
                    key_mode = "Toggle"
                    holdtext.TextColor3 = library.theme["Text"]
                    toggletext.TextColor3 = library.theme["Accent"]
                    mode_frame.Visible = false
                end)
                
                holdbutton.TouchTap:Connect(function()
                    key_mode = "Hold"
                    holdtext.TextColor3 = library.theme["Accent"]
                    toggletext.TextColor3 = library.theme["Text"]
                    mode_frame.Visible = false
                end)
                
                togglebutton.TouchTap:Connect(function()
                    key_mode = "Toggle"
                    holdtext.TextColor3 = library.theme["Text"]
                    toggletext.TextColor3 = library.theme["Accent"]
                    mode_frame.Visible = false
                end)
                
                local list_obj = nil
                
                local removetext = utility.create("TextLabel", {
                    Name = "RemoveText",
                    Parent = frame,
                    Text = "...",
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(1, -20, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 8
                })
                
                local remove = utility.create("TextButton", {
                    Name = "RemoveButton",
                    Parent = frame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    ZIndex = 13,
                    Text = "",
                    AutoButtonColor = false
                })
                
                remove.MouseButton1Click:Connect(function()
                    mode_frame.Visible = true
                end)
                
                remove.TouchTap:Connect(function()
                    mode_frame.Visible = true
                end)
                
                local key
                local state = false
                local binding
                
                local function set(newkey)
                    if c then
                        c:Disconnect()
                        if flag then
                            library.flags[flag] = false
                        end
                        callback(false)
                    end
                    
                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    end
                    
                    if newkey ~= nil and not table.find(blacklist, newkey) then
                        key = newkey
                        local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                        keytext.Text = text
                    else
                        key = nil
                        keytext.Text = ""
                    end
                    
                    if key ~= '' and key ~= nil then
                        state = false
                        if flag then
                            library.flags[flag] = state
                        end
                        callback(state)
                    end
                end
                
                utility.connect(services.InputService.InputBegan, function(inp)
                    if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                        if key_mode == "Hold" then
                            if flag then
                                library.flags[flag] = true
                            end
                            c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                callback(true)
                            end)
                        else
                            state = not state
                            if flag then
                                library.flags[flag] = state
                            end
                            callback(state)
                        end
                    end
                end)
                
                set(default)
                
                frame.MouseButton1Click:Connect(function()
                    if not binding then
                        keytext.Text = "..."
                        binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                            set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                            utility.disconnect(binding)
                            task.wait()
                            binding = nil
                        end)
                    end
                end)
                
            
                
                utility.connect(services.InputService.InputEnded, function(inp)
                    if key_mode == "Hold" then
                        if key ~= '' and key ~= nil then
                            if inp.KeyCode == key or inp.UserInputType == key then
                                if c then
                                    c:Disconnect()
                                    if flag then
                                        library.flags[flag] = false
                                    end
                                    if callback then
                                        callback(false)
                                    end
                                end
                            end
                        end
                    end
                end)
                
                function keybind_tbl:set(newkey)
                    set(newkey)
                end
                
                return keybind_tbl
            end
            
            function section_tbl:new_seperator(cfg)
                local seperator_text = cfg.name or cfg.Name or "new seperator"
                
                local separator = utility.create("Frame", {
                    Name = "Separator",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    ZIndex = 7
                })
                
                local separatorline = utility.create("Frame", {
                    Name = "SeparatorLine",
                    Parent = separator,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ZIndex = 7
                })
                
                local outline = utility.outline(separatorline, "Section Inner Border")
                utility.outline(outline, "Section Outer Border")
                
                local sizeX = utility.textlength(seperator_text, customFont, 13).X
                
                local separatorborder1 = utility.create("Frame", {
                    Name = "SeparatorBorder1",
                    Parent = separatorline,
                    BackgroundColor3 = library.theme["Section Outer Border"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 1, 1, 2),
                    Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -1),
                    ZIndex = 9
                })
                
                local separatorborder2 = utility.create("Frame", {
                    Name = "SeparatorBorder2",
                    Parent = separatorline,
                    BackgroundColor3 = library.theme["Section Outer Border"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 1, 1, 2),
                    Position = UDim2.new(0.5, sizeX / 2 + 5, 0, -1),
                    ZIndex = 9
                })
                
                local separatorcutoff = utility.create("Frame", {
                    Name = "SeparatorCutoff",
                    Parent = separator,
                    BackgroundColor3 = library.theme["Section Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, sizeX + 12, 0, 5),
                    Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -2),
                    ZIndex = 8
                })
                
                local text = utility.create("TextLabel", {
                    Name = "SeparatorText",
                    Parent = separator,
                    Text = seperator_text,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0.5, 0, 0, -1),
                    Size = UDim2.new(0, sizeX, 0, 13),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 9
                })
            end
            
            function section_tbl:new_colorpicker(cfg)
                local colorpicker_tbl = {}
                local name = cfg.name or cfg.Name or "new colorpicker"
                local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0)
                local flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or function() end
                
                local holder = utility.create("Frame", {
                    Name = "ColorpickerHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 10),
                    ZIndex = 7
                })
                
                local title = utility.create("TextLabel", {
                    Name = "ColorpickerTitle",
                    Parent = holder,
                    Text = name,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = UDim2.new(0, -1, 0, -1),
                    Size = UDim2.new(1, 0, 0, 13),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 7
                })
                
                local colorpickers = 0
                
                local colorpickertypes = library.createcolorpicker(default, holder, colorpickers, flag, callback, -2)
                
                function colorpicker_tbl:set(color)
                    colorpickertypes:set(color)
                end
                
                return colorpicker_tbl
            end
            
            function section_tbl:new_textbox(cfg)
                local textbox_tbl = {}
                local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox"
                local default = cfg.Default or cfg.default or ""
                local middle = cfg.middle or cfg.Middle or false
                local flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or function() end
                
                local holder = utility.create("Frame", {
                    Name = "TextboxHolder",
                    Parent = section_content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 19),
                    ZIndex = 7
                })
                
                local textbox = utility.create("TextButton", {
                    Name = "Textbox",
                    Parent = holder,
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    ZIndex = 7,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local outline1 = utility.outline(textbox, "Section Inner Border")
                utility.outline(outline1, "Section Outer Border")
                
                local text = utility.create("TextLabel", {
                    Name = "TextboxText",
                    Parent = textbox,
                    Text = default,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = middle and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 2, 0, 0),
                    Size = middle and UDim2.new(1, 0, 1, 0) or UDim2.new(1, -2, 1, 0),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = middle and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
                    ZIndex = 9
                })
                
                local placeholderText = utility.create("TextLabel", {
                    Name = "Placeholder",
                    Parent = textbox,
                    Text = placeholder,
                    FontFace = customFont,
                    TextSize = 13,
                    Position = middle and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 2, 0, 0),
                    Size = middle and UDim2.new(1, 0, 1, 0) or UDim2.new(1, -2, 1, 0),
                    TextColor3 = library.theme["Text"],
                    BackgroundTransparency = 1,
                    TextXAlignment = middle and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
                    TextTransparency = 0.5,
                    ZIndex = 9,
                    Visible = default == ""
                })
                
                library.createbox(textbox, text, function(str)
                    if str == "" then
                        placeholderText.Visible = true
                        text.Visible = false
                    else
                        placeholderText.Visible = false
                        text.Visible = true
                    end
                end, function(str)
                    library.flags[flag] = str
                    callback(str)
                end)
                
                local function set(str)
                    text.Visible = str ~= ""
                    placeholderText.Visible = str == ""
                    text.Text = str
                    library.flags[flag] = str
                    callback(str)
                end
                
                set(default)
                flags[flag] = set
                
                function textbox_tbl:Set(str)
                    set(str)
                end
                
                return textbox_tbl
            end
            
            return section_tbl
        end
        
        return page_tbl
    end
    
    function window_tbl:get_config()
        local configtbl = {}
        
        for flag, _ in next, flags do
            if not table.find(configignores, flag) then
                local value = library.flags[flag]
                
                if typeof(value) == "EnumItem" then
                    configtbl[flag] = tostring(value)
                elseif typeof(value) == "Color3" then
                    configtbl[flag] = value:ToHex()
                else
                    configtbl[flag] = value
                end
            end
        end
        
        local config = game:GetService("HttpService"):JSONEncode(configtbl)
        return config
    end
    
    return window_tbl
end

return library
