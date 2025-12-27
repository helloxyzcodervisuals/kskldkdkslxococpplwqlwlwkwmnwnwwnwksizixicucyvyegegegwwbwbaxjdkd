local settings = {
    folder_name = "zephyrus";
    default_accent = Color3.fromRGB(61, 100, 227);
};

local is_mobile = game:GetService("UserInputService").TouchEnabled

local http_service = game:GetService("HttpService")
local tween_service = game:GetService("TweenService")

local isfile = isfile or function(path) return pcall(function() readfile(path) end) end
local writefile = writefile or function(path, content) makefile(path, content) end
local getcustomasset = getcustomasset or function(path) return path end

if not isfile(settings.folder_name .. "/fonts/main.ttf") then 
    writefile(settings.folder_name .. "/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
end

local tahoma = {
    name = "SmallestPixel7",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset(settings.folder_name .. "/fonts/main.ttf")
        }
    }
}

if not isfile(settings.folder_name .. "/fonts/main_encoded.ttf") then 
    writefile(settings.folder_name .. "/fonts/main_encoded.ttf", http_service:JSONEncode(tahoma))
end 

local custom_font = Font.new(getcustomasset(settings.folder_name .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)

local function create_tween(object, tween_info, properties)
    local tween = tween_service:Create(object, tween_info, properties)
    tween:Play()
    return tween
end

local function base64_decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

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

function utility.dragify(main, dragoutline, object)
    local start, objectposition, dragging, currentpos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            start = input.Position
            dragoutline.Visible = true
            objectposition = object.Position
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or (is_mobile and input.UserInputType == Enum.UserInputType.Touch)) and dragging then
            currentpos = UDim2.new(objectposition.X.Scale, objectposition.X.Offset + (input.Position - start).X, objectposition.Y.Scale, objectposition.Y.Offset + (input.Position - start).Y)
            dragoutline.Position = currentpos
        end
    end)

    utility.connect(services.InputService.InputEnded, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch)) and dragging then 
            dragging = false
            dragoutline.Visible = false
            object.Position = currentpos
        end
    end)
end

function utility.textlength(str, font, fontsize)
    local text = Instance.new("TextLabel")
    text.Text = str
    text.Font = font
    text.TextSize = fontsize
    text.Size = UDim2.new(0, 10000, 0, 10000)
    
    local textbounds = text.TextBounds
    text:Destroy()
    
    return textbounds
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
    local rgb = Color3.fromRGB(r, g, b)
    local mt = table.clone(getrawmetatable(rgb))
    
    setreadonly(mt, false)
    local old = mt.__index
    
    mt.__index = newcclosure(function(self, key)
        if key:lower() == "a" then
            return alpha
        end
        
        return old(self, key)
    end)
    
    setrawmetatable(rgb, mt)
    
    return rgb
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
}

function utility.create_uigradient(angle)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = angle
    
    if angle == 90 then
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }
    else
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
        }
    end
    
    return gradient
end

library.gradient = utility.create_uigradient(90)

local decode = base64_decode

library.utility = utility

function utility.outline(obj, color)
    local outline = Instance.new("Frame")
    outline.Name = "Outline"
    outline.BackgroundColor3 = library.theme[color] or color or Color3.fromRGB(0, 0, 0)
    outline.BorderSizePixel = 0
    outline.Size = UDim2.new(1, 2, 1, 2)
    outline.Position = UDim2.new(0, -1, 0, -1)
    outline.ZIndex = obj.ZIndex - 1
    outline.Parent = obj
    
    if typeof(color) == "Color3" then
        outline.BackgroundColor3 = color
    else
        outline.BackgroundColor3 = library.theme[color]
        themeobjects[outline] = color
    end
    
    return outline
end

function utility.create(class, properties)
    local obj
    
    if class == "Text" then
        obj = Instance.new("TextLabel")
    elseif class == "Square" then
        obj = Instance.new("Frame")
    elseif class == "Image" then
        obj = Instance.new("ImageLabel")
    end
    
    for prop, v in next, properties do
        if prop == "Theme" then
            themeobjects[obj] = v
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                obj.BackgroundColor3 = library.theme[v]
            end
        elseif prop == "Color" then
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                obj.BackgroundColor3 = v
            elseif obj:IsA("TextLabel") then
                obj.TextColor3 = v
            end
        elseif prop == "Text" and obj:IsA("TextLabel") then
            obj.Text = v
        elseif prop == "Font" and obj:IsA("TextLabel") then
            if v == Drawing.Fonts.Plex or v == 2 then
                obj.FontFace = custom_font
            else
                obj.Font = Enum.Font[v] or Enum.Font.SourceSans
            end
        elseif prop == "Size" then
            if obj:IsA("TextLabel") then
                obj.TextSize = v
            else
                if typeof(v) == "UDim2" then
                    obj.Size = v
                elseif typeof(v) == "number" then
                    obj.TextSize = v
                end
            end
        elseif prop == "Position" then
            obj.Position = v
        elseif prop == "Transparency" then
            obj.BackgroundTransparency = v
        elseif prop == "Thickness" then
            obj.BorderSizePixel = v
        elseif prop == "Filled" then
            if v then
                obj.BackgroundTransparency = 0
            else
                obj.BackgroundTransparency = 1
            end
        elseif prop == "ZIndex" then
            obj.ZIndex = v
        elseif prop == "Parent" then
            obj.Parent = v
        elseif prop == "Center" and obj:IsA("TextLabel") then
            obj.TextXAlignment = v and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
        elseif prop == "Outline" and obj:IsA("TextLabel") then
            if v then
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(0, 0, 0)
                stroke.Thickness = 1
                stroke.Parent = obj
            end
        elseif prop == "Data" then
            if class == "Image" then
                obj.Image = v
            else
                local gradient = utility.create_uigradient(90)
                gradient.Parent = obj
            end
        elseif prop == "Rotation" and obj:IsA("UIGradient") then
            obj.Rotation = v
        end
    end
    
    return obj
end

function utility.changeobjecttheme(object, color)
    themeobjects[object] = color
    if object:IsA("Frame") or object:IsA("TextLabel") or object:IsA("ImageLabel") then
        object.BackgroundColor3 = library.theme[color]
    elseif object:IsA("TextLabel") then
        object.TextColor3 = library.theme[color]
    end
end

function utility.connect(signal, callback)
    local connection
    if typeof(signal) == "RBXScriptSignal" then
        connection = signal:Connect(callback)
    else
        connection = signal:GetPropertyChangedSignal("Parent"):Connect(function()
            callback()
        end)
    end
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
    return Color3.fromRGB(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x"..hex:sub(5, 6)))
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
    
    if self.cursor then
        self.cursor.Visible = self.open
    end
end

function library:ChangeThemeOption(option, color)
    self.theme[option] = color
    
    for obj, theme in next, themeobjects do
        if obj and obj.Parent and theme == option then
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                obj.BackgroundColor3 = color
            elseif obj:IsA("TextLabel") then
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
            if object:IsA("Frame") or object:IsA("TextLabel") or object:IsA("ImageLabel") then
                object.BackgroundColor3 = self.theme[color]
            elseif object:IsA("TextLabel") then
                object.TextColor3 = self.theme[color]
            end
        end
    end
end

function utility.create_uigradient(angle)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = angle
    
    if angle == 90 then
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }
    else
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
        }
    end
    
    return gradient
end

function library.createkeybindlist()
    local keybind_list_tbl = {keybinds = {}}
    
    local list_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0, 180, 0, 30), Position = UDim2.new(0, 10, 0.4, 0), Thickness = 1, Filled = true, ZIndex = 100}) 
    
    local outline1 = utility.outline(list_outline, "Window Border")
    utility.outline(outline1, Color3.new(0,0,0))
    
    local list_inline = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), Thickness = 1, Filled = true, ZIndex = 101}) 
    
    local outline2 = utility.outline(list_inline, "Window Border")
    
    local list_accent = utility.create("Square", {Parent = list_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 101})
    
    local list_title = utility.create("Text", {Text = "Keybinds", Parent = list_inline, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = custom_font, Position = UDim2.new(0.5,0,0,5), ZIndex = 101})
    
    local list_content = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,33), Thickness = 1, Filled = true, ZIndex = 101})
    
    function keybind_list_tbl:add_keybind(name, key)
        local key_settings = {}
        
        local key_holder = utility.create("Square", {Parent = list_content, Size = UDim2.new(1,0,0,22), ZIndex = 100, Transparency = 1, Visible = true, Filled = true, Thickness = 1, Theme = "Window Outline Background"}) 
        
        local outline3 = utility.outline(key_holder, "Window Border")
        utility.outline(outline3, Color3.new(0,0,0))
        
        local list_title = utility.create("Text", {Text = tostring(name .." ["..key.."]"), Parent = key_holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = true, Font = custom_font, Position = UDim2.new(0,2,0,4), ZIndex = 101})
        
        function key_settings:is_active(state)
            if state then
                utility.changeobjecttheme(list_title, "Accent")
            else
                utility.changeobjecttheme(list_title, "Text")
            end
        end
        
        function key_settings:update_text(text)
            list_title.Text = text
        end
        
        function key_settings:Remove()
            key_holder:Destroy()
            keybind_list_tbl.keybinds[name] = nil
            key_settings = nil
        end
        
        keybind_list_tbl.keybinds[name] = key_settings
        
        return key_settings
    end
    
    function keybind_list_tbl:remove_keybind(name)
        if name and keybind_list_tbl.keybinds[name] then
            keybind_list_tbl.keybinds[name]:Remove()
            keybind_list_tbl.keybinds[name] = nil
        end
    end
    
    function keybind_list_tbl:set_visible(state)
        list_outline.Visible = state
    end
    
    utility.connect(game:GetService("Workspace").CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()
        list_outline.Position = UDim2.new(0, 10, 0.4, 0)
    end)
    
    return keybind_list_tbl
end

local pickers = {}

function library.createcolorpicker(default, parent, count, flag, callback, offset)
    local icon = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Color = default,
        Parent = parent,
        Transparency = 1,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8
    })

    local outline = utility.outline(icon, "Section Inner Border")
    utility.outline(outline, "Section Outer Border")

    local gradient = utility.create_uigradient(90)
    gradient.Transparency = NumberSequence.new(0.5)
    gradient.Parent = icon

    local window = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = icon,
        Theme = "Object Background",
        Size = UDim2.new(0, 185, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })

    table.insert(pickers, window)

    local outline1 = utility.outline(window, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")

    local saturation = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Color = default,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })

    utility.outline(saturation, "Section Inner Border")

    local saturation_frame = Instance.new("Frame")
    saturation_frame.Size = UDim2.new(1, 0, 1, 0)
    saturation_frame.BackgroundTransparency = 1
    saturation_frame.ZIndex = 25
    saturation_frame.Parent = saturation
    
    local saturation_gradient = utility.create_uigradient(0)
    saturation_gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    saturation_gradient.Parent = saturation_frame
    
    local saturation_gradient2 = utility.create_uigradient(90)
    saturation_gradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    saturation_gradient2.Transparency = NumberSequence.new(0.5)
    saturation_gradient2.Parent = saturation_frame

    local saturationpicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = saturation,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 2, 0, 2),
        ZIndex = 26
    })

    utility.outline(saturationpicker, Color3.fromRGB(0, 0, 0))

    local hueframe = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Size = UDim2.new(0,15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })

    utility.outline(hueframe, "Section Inner Border")

    local hue_gradient = Instance.new("Frame")
    hue_gradient.Size = UDim2.new(1, 0, 1, 0)
    hue_gradient.BackgroundTransparency = 1
    hue_gradient.ZIndex = 25
    hue_gradient.Parent = hueframe
    
    local hue_sequence = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    
    local hue_uigradient = Instance.new("UIGradient")
    hue_uigradient.Color = hue_sequence
    hue_uigradient.Rotation = 90
    hue_uigradient.Parent = hue_gradient

    local huepicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = hueframe,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1,0,0,1),
        ZIndex = 26
    })

    utility.outline(huepicker, Color3.fromRGB(0, 0, 0))

    local rgbinput = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24,
        Parent = window
    })

    local rgb_gradient = utility.create_uigradient(90)
    rgb_gradient.Transparency = NumberSequence.new(0.5)
    rgb_gradient.Parent = rgbinput

    local outline2 = utility.outline(rgbinput, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")

    local text = utility.create("Text", {
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        Font = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = rgbinput
    })

    local copy = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    local copy_gradient = utility.create_uigradient(90)
    copy_gradient.Transparency = NumberSequence.new(0.5)
    copy_gradient.Parent = copy

    local outline3 = utility.outline(copy, "Section Inner Border")
    utility.outline(outline3, "Section Outer Border")

    utility.create("Text", {
        Text = "copy",
        Font = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = copy
    })

    local paste = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    local paste_gradient = utility.create_uigradient(90)
    paste_gradient.Transparency = NumberSequence.new(0.5)
    paste_gradient.Parent = paste

    utility.create("Text", {
        Text = "paste",
        Font = custom_font,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = paste
    })

    local outline4 = utility.outline(paste, "Section Inner Border")
    utility.outline(outline4, "Section Outer Border")

    utility.connect(copy.MouseButton1Click, function()
        library.currentcolor = current_val
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
                saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)), 0, (math.clamp((1 - val) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 2)))
                huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 4))
                if setcolor then
                    saturation.BackgroundColor3 = hsv
                end
            end

            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))

            if flag then
                library.flags[flag] = utility.rgba(hsv.r * 255, hsv.g * 255, hsv.b * 255)
            end

            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))

            current_val = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
        end
    end

    utility.connect(paste.MouseButton1Click, function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end
    end)

    flags[flag] = set

    set(default)

    local defhue, _, _ = default:ToHSV()

    local curhuesizey = defhue

    local function updatesatval(input)
        local sizeX = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = 1 - math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) + 36) / saturation.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y) * saturation.AbsoluteSize.Y + 36, 0, saturation.AbsoluteSize.Y - 2)
        local posX = math.clamp(((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X) * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)

        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

        set(Color3.fromHSV(curhuesizey or hue, sizeX, sizeY), true, false)
    end

    local slidingsaturation = false

    saturation.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            slidingsaturation = true
            updatesatval(input)
        end
    end)

    saturation.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            slidingsaturation = false
        end
    end)

    local slidinghue = false

    local function updatehue(input)
        local sizeY = 1 - math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) + 36) / hueframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y + 36, 0, hueframe.AbsoluteSize.Y - 2)

        huepicker.Position = UDim2.new(0, 0, 0, posY)
        saturation.BackgroundColor3 = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY

        set(Color3.fromHSV(sizeY, sat, val), true, true)
    end

    hueframe.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            slidinghue = true
            updatehue(input)
        end
    end)

    hueframe.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            slidinghue = false
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
            if slidinghue then
                updatehue(input)
            end

            if slidingsaturation then
                updatesatval(input)
            end
        end
    end)

    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
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
        end
    end)

    local colorpickertypes = {}

    function colorpickertypes:set(color)
        set(color)
    end

    return colorpickertypes, window
end

function library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size, section, sectioncontent)
    local dropdown = utility.create("Square", {
        Filled = true,
        Visible = not islist,
        Thickness = 0,
        Theme = "Object Background",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        ZIndex = 7,
        Parent = holder
    })

    local outline1 = utility.outline(dropdown, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    
    local dropdown_gradient = utility.create_uigradient(90)
    dropdown_gradient.Transparency = NumberSequence.new(0.5)
    dropdown_gradient.Parent = dropdown

    local value = utility.create("Text", {
        Text = "",
        Font = custom_font,
        Size = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Theme = "Text",
        ZIndex = 9,
        Outline = false,
        Parent = dropdown
    })

    local icon = Instance.new("TextLabel")
    icon.Text = "▼"
    icon.Font = custom_font
    icon.TextSize = 13
    icon.TextColor3 = library.theme["Text"]
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 9, 0, 6)
    icon.Position = UDim2.new(1, -13, 0, 4)
    icon.ZIndex = 9
    icon.Parent = dropdown

    local contentframe = utility.create("Square", {
        Filled = true,
        Visible = islist or false,
        Thickness = 0,
        Theme = "Object Background",
        Size = islist and size == "Fill" and UDim2.new(1, 0, 1, -30) or islist and size ~= "Fill" and UDim2.new(1,0,0,size) or UDim2.new(1,0,0,0),
        Position = islist and UDim2.new(0, 0, 0, 14) or UDim2.new(0, 0, 1, 6),
        ZIndex = 12,
        Parent = islist and holder or dropdown
    })

    local outline2 = utility.outline(contentframe, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    
    local content_gradient = utility.create_uigradient(90)
    content_gradient.Transparency = NumberSequence.new(0.5)
    content_gradient.Parent = contentframe

    local contentholder = utility.create("Square", {
        Transparency = 0,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        Parent = contentframe
    })

    if not islist then
        dropdown.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                local opened = contentframe.Visible
                opened = not opened
                contentframe.Visible = opened
                icon.Text = opened and "▲" or "▼"
            end
        end)
    end

    local optioninstances = {}
    local count = 0
    local countindex = {}

    local function createoption(name)
        optioninstances[name] = {}

        countindex[name] = count + 1

        local button = utility.create("Square", {
            Filled = true,
            Transparency = 0,
            Thickness = 1,
            Theme = "Object Background",
            Size = UDim2.new(1, 0, 0, 16),
            ZIndex = 14,
            Parent = contentholder
        })

        optioninstances[name].button = button

        local title = utility.create("Text", {
            Text = name,
            Font = custom_font,
            Size = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Theme = "Text",
            ZIndex = 15,
            Outline = true,
            Parent = button
        })

        optioninstances[name].text = title

        count = count + 1

        return button, title
    end

    local chosen = max and {}

    local function handleoptionclick(option, button, text)
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                if max then
                    if table.find(chosen, option) then
                        table.remove(chosen, table.find(chosen, option))

                        local textchosen = {}
                        local cutobject = false

                        for _, opt in next, chosen do
                            table.insert(textchosen, opt)

                            if utility.textlength(table.concat(textchosen, ", ") .. ", ...", custom_font, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                cutobject = true
                                table.remove(textchosen, #textchosen)
                            end
                        end

                        value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

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

                            if utility.textlength(table.concat(textchosen, ", ") .. ", ...", custom_font, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                cutobject = true
                                table.remove(textchosen, #textchosen)
                            end
                        end

                        value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

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

                    value.Text = option

                    utility.changeobjecttheme(text, "Accent")

                    library.flags[flag] = option
                    callback(option)
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

                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", custom_font, 13).X > (dropdown.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end

            value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

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

                value.Text = option

                utility.changeobjecttheme(optioninstances[option].text, "Accent")

                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil

                value.Text = ""

                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end

    flags[flag] = set

    set(default)

    local dropdowntypes = utility.table({}, true)

    function dropdowntypes:set(option)
        set(option)
    end

    function dropdowntypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0

        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Destroy()
            end)()
        end

        table.clear(optioninstances)

        createoptions(tbl)

        value.Text = ""

        if max then
            table.clear(chosen)
        else
            chosen = nil
        end

        library.flags[flag] = chosen
        callback(chosen)
    end

    function dropdowntypes:add(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end

    function dropdowntypes:remove(option)
        if optioninstances[option] then
            count = count - 1

            optioninstances[option].button:Destroy()

            optioninstances[option] = nil

            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", custom_font, 13).X > (dropdown.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end

    return dropdowntypes
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
    box.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
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
    
    local window_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0,size_x,0,size_y), Position = UDim2.new(0.5, -(size_x / 2), 0.5, -(size_y / 2)), Thickness = 1, Filled = true, ZIndex = 1}) 
    
    local outline = utility.outline(window_outline, "Window Border")
    utility.outline(outline, Color3.new(0,0,0))
    
    library.holder = window_outline
    
    local window_inline = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-10,1,-10), Position = UDim2.new(0,5,0,5), Thickness = 1, Filled = true, ZIndex = 2}) 
    
    local outline2 = utility.outline(window_inline, "Window Border")
    
    local window_accent = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 2})
    
    local window_holder = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(1,-30,1,-30), Position = UDim2.new(0,15,0,15), Thickness = 1, Filled = true, ZIndex = 3}) 
    
    local outline3 = utility.outline(window_holder, "Window Border")
    
    local window_pages_holder = utility.create("Square", {Parent = window_holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 3})
    
    local window_drag = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 10})
    
    local dragoutline = utility.create("Square", {
        Size = UDim2.new(0, size_x, 0, size_y),
        Position = utility.getcenter(size_x, size_y),
        Filled = false,
        Thickness = 1,
        Theme = "Accent",
        ZIndex = 1,
        Visible = false,
    })
    
    utility.dragify(window_drag, dragoutline, window_outline)
    
    local window_key_list = library.createkeybindlist()
    window_key_list:set_visible(false)
    
    function window_tbl:new_page(cfg)
        local page_tbl = {sections = {}}
        local page_name = cfg.name or cfg.Name or "new page"
        
        local page_button = utility.create("Square", {Parent = window_pages_holder, Visible = true, Transparency = 1, Theme = "Page Unselected", Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 4}) 
        
        local outline4 = utility.outline(page_button, "Window Border")
        table.insert(self.page_buttons, page_button)
        
        local button_gradient = utility.create_uigradient(90)
        button_gradient.Transparency = NumberSequence.new(0.5)
        button_gradient.Parent = page_button
        
        local page_title = utility.create("Text", {Text = page_name, Parent = page_button, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = custom_font, Position = UDim2.new(0.5,0,0,6), ZIndex = 4})
        
        local page_button_accent = utility.create("Square", {Parent = page_button, Visible = false, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,1), Thickness = 1, Filled = true, ZIndex = 4}) 
        
        table.insert(self.page_accents, page_button_accent)
        
        local page = utility.create("Square", {Parent = window_holder, Visible = false, Transparency = 0, Size = UDim2.new(1,-40,1,-45), Position = UDim2.new(0,20,0,40), Thickness = 1, Filled = false, ZIndex = 4}) 
        
        table.insert(self.pages, page)
        
        local left = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,ZIndex = 4,Parent = page,Size = UDim2.new(0.5, -14, 1, -10)})
        local right = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,Parent = page,ZIndex = 3,Size = UDim2.new(0.5, -14, 1, -10),Position = UDim2.new(0.5, 14, 0, 0)})
        
        utility.connect(page_button.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                for i,v in next, self.page_buttons do
                    if v ~= page_button then
                        utility.changeobjecttheme(v, "Page Unselected")
                    end
                end
                
                for i,v in next, self.page_accents do
                    if v ~= page_button_accent then
                        v.Visible = false
                    end
                end
                
                for i,v in next, self.pages do
                    if v ~= page then
                        v.Visible = false
                    end
                end
                
                utility.changeobjecttheme(page_button, "Page Selected")
                page_button_accent.Visible = true
                page.Visible = true
            end
        end)
        
        for _,v in next, self.page_buttons do
            v.Size = UDim2.new(1 / #self.page_buttons, _ == 1 and 1 or _ == #self.page_buttons and -2 or -1, 1, 0)
            v.Position = UDim2.new(1 / (#self.page_buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 0)
        end
        
        function page_tbl:open()
            utility.changeobjecttheme(page_button, "Page Selected")
            page_button_accent.Visible = true
            page.Visible = true
        end
        
        function page_tbl:new_section(cfg)
            local section_tbl = {}
            local section_name = cfg.name or cfg.Name or "new section"
            local section_side = cfg.side == "left" and left or cfg.Side == "left" and left or cfg.side == "right" and right or cfg.Side == "right" and right or left
            local section_size = cfg.size or cfg.Size or 200
            
            local section = utility.create("Square", {Parent = section_side, Visible = true, Transparency = 1, Theme = "Section Background", Size = section_size ~= "Fill" and UDim2.new(1,0,0,section_size) or UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 5}) 
            
            local outline5 = utility.outline(section, "Section Inner Border")
            utility.outline(outline5, "Section Outer Border")
            
            local section_title_cover = utility.create("Square", {Parent = section, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(0,utility.textlength(section_name, custom_font, 13).X + 2,0,4), Position = UDim2.new(0,10,0,-4), Thickness = 1, Filled = true, ZIndex = 5})
            local section_title = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = custom_font, Position = UDim2.new(0,10,0,-8), ZIndex = 5})
            local section_title_bold = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = custom_font, Position = UDim2.new(0,11,0,-8), ZIndex = 5})
            
            local section_content = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, -32, 1, -10),Position = UDim2.new(0, 16, 0, 15),Parent = section,ZIndex = 6})
            
            function section_tbl:new_toggle(cfg)
                local toggle_tbl = {colorpickers = 0}
                local toggle_name = cfg.name or cfg.Name or "new toggle"
                local toggle_risky = cfg.risky or cfg.Risky or false
                local toggle_state = cfg.state or cfg.State or false
                local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or cfg.Callback or function() end
                local toggled = false
                
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 8})
                
                local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) 
                
                local outline6 = utility.outline(toggle_frame, "Section Inner Border")
                utility.outline(outline6, "Section Outer Border")
                
                local toggle_gradient = utility.create_uigradient(90)
                toggle_gradient.Transparency = NumberSequence.new(0.5)
                toggle_gradient.Visible = false
                toggle_gradient.Parent = toggle_frame
                
                local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Theme = toggle_risky and "Risky Text" or "Text", Size = 13, Center = false, Outline = false, Font = custom_font, Position = UDim2.new(0,13,0,-3), ZIndex = 6})
                
                local function setstate()
                    toggled = not toggled
                    if toggled then
                        utility.changeobjecttheme(toggle_frame, "Accent")
                        toggle_gradient.Visible = true
                    else
                        utility.changeobjecttheme(toggle_frame, "Object Background")
                        toggle_gradient.Visible = false
                    end
                    library.flags[toggle_flag] = toggled
                    callback(toggled)
                end
                
                holder.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        setstate()
                    end
                end)
                
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
                        cp:set(color, false, true)
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
                
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,20), Thickness = 1, Filled = true, ZIndex = 6})
                
                local slider_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,0,5), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,15)}) 
                
                local outline7 = utility.outline(slider_frame, "Section Inner Border")
                utility.outline(outline7, "Section Outer Border")
                
                local slider_gradient = utility.create_uigradient(90)
                slider_gradient.Transparency = NumberSequence.new(0.5)
                slider_gradient.Parent = slider_frame
                
                local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = custom_font, Position = UDim2.new(0,-2,0,-2), ZIndex = 6})
                
                local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = true, Font = custom_font, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8})
                
                local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)})
                
                local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)})
                
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
                    local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                    local value = ((max - min) * sizeX) + min
            
                    set(value)
                end
            
                utility.connect(slider_drag.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_drag.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        sliding = false
                    end
                end)
            
                utility.connect(slider_fill.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_fill.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        sliding = false
                    end
                end)
            
                utility.connect(services.InputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        if sliding then
                            slide(input)
                        end
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
                
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 6})
                
                local button_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7}) 
                
                local outline8 = utility.outline(button_frame, "Section Inner Border")
                utility.outline(outline8, "Section Outer Border")
                
                local button_gradient = utility.create_uigradient(90)
                button_gradient.Transparency = NumberSequence.new(0.5)
                button_gradient.Parent = button_frame
                
                local button_title = utility.create("Text", {Text = button_name, Parent = button_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = custom_font, Position = UDim2.new(0.5,0,0,0), ZIndex = 8})
                
                local clicked, counting = false, false
                utility.connect(button_frame.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        task.spawn(function()
                            if button_confirm then
                                if clicked then
                                    clicked = false
                                    counting = false
                                    utility.changeobjecttheme(button_title, "Text")
                                    button_title.Text = button_name
                                    callback()
                                else
                                    clicked = true
                                    counting = true
                                    for i = 3,1,-1 do
                                        if not counting then
                                            break
                                        end
                                        button_title.Text = 'confirm '..button_name..'? '..tostring(i)
                                        utility.changeobjecttheme(button_title, "Accent")
                                        wait(1)
                                    end
                                    clicked = false
                                    counting = false
                                    utility.changeobjecttheme(button_title, "Text")
                                    button_title.Text = button_name
                                end
                            else
                                callback()
                            end
                        end)
                    end
                end)
                utility.connect(button_frame.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        utility.changeobjecttheme(button_frame, "Accent")
                    end
                end)
                utility.connect(button_frame.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        utility.changeobjecttheme(button_frame, "Object Background")
                    end
                end)
            end
            
            function section_tbl:new_dropdown(cfg)
                local dropdown_tbl = {}
                local name = cfg.name or cfg.Name or "new dropdown"
                local default = cfg.default or cfg.Default or nil
                local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {}
                local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil
                local scrollable = cfg.scrollable or false
                local scrollingmax = cfg.scrollingmax or 10
                local flag = cfg.flag or utility.nextflag()
                local islist = cfg.list or false
                local size = cfg.size or 100
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
                
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = islist and size == "Fill" and UDim2.new(1,0,1,0) or islist and UDim2.new(1,0,0,size+15) or UDim2.new(1, 0, 0, 29),Parent = section_content})
                
                local title = utility.create("Text", {
                    Text = name,
                    Font = custom_font,
                    Size = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                })
                
                return library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size)
            end
            
            function section_tbl:new_keybind(cfg)
                local name = cfg.name or cfg.Name or "new keybind"
                local key_name = cfg.keybind_name or cfg.KeyBind_Name or name
                local default = cfg.default or cfg.Default or nil
                local mode = cfg.mode or cfg.Mode or "Hold"
                local blacklist = cfg.blacklist or cfg.Blacklist or {}
                local flag = cfg.flag or utility.nextflag()
                local callback = cfg.callback or function() end
                local ignore_list = cfg.ignore or cfg.Ignore or false
                local key_mode = mode
                
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 29),Parent = section_content})
                
                local title = utility.create("Text", {
                    Text = name,
                    Font = custom_font,
                    Size = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                })
                
                local offset = -1
            
                local keybindname = key_name or ""
            
                local frame = utility.create("Square",{
                    Theme = "Object Background",
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    Filled = true,
                    Parent = holder,
                    Thickness = 1,
                    ZIndex = 8
                })
            
                local outline9 = utility.outline(frame, "Section Inner Border")
                utility.outline(outline9, "Section Outer Border")
                
                local frame_gradient = utility.create_uigradient(90)
                frame_gradient.Transparency = NumberSequence.new(0.5)
                frame_gradient.Parent = frame

                local mode_frame = utility.create("Square",{
                    Theme = "Object Background",
                    Size = UDim2.new(0,44,0,35),
                    Position = UDim2.new(1,10,0,-10),
                    Filled = true,
                    Parent = frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Visible = false
                })
            
                local mode_outline1 = utility.outline(mode_frame, "Section Inner Border")
                utility.outline(mode_outline1, "Section Outer Border")
                
                local mode_gradient = utility.create_uigradient(90)
                mode_gradient.Transparency = NumberSequence.new(0.5)
                mode_gradient.Parent = mode_frame

                local holdtext = utility.create("Text", {
                    Text = "Hold",
                    Font = custom_font,
                    Size = 13,
                    Theme = key_mode == "Hold" and "Accent" or "Text",
                    Position = UDim2.new(0.5,0,0,2),
                    ZIndex = 8,
                    Parent = mode_frame,
                    Outline = false,
                    Center = true
                })
                
                local toggletext = utility.create("Text", {
                    Text = "Toggle",
                    Font = custom_font,
                    Size = 13,
                    Theme = key_mode == "Toggle" and "Accent" or "Text",
                    Position = UDim2.new(0.5,0,0,18),
                    ZIndex = 8,
                    Parent = mode_frame,
                    Outline = false,
                    Center = true
                })

                local holdbutton = utility.create("Square",{
                    Color = Color3.new(0,0,0),
                    Size = UDim2.new(0,44,0,12),
                    Position = UDim2.new(0,0,0,2),
                    Filled = false,
                    Parent = mode_frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Transparency = 0
                })

                local togglebutton = utility.create("Square",{
                    Color = Color3.new(0,0,0),
                    Size = UDim2.new(0,44,0,12),
                    Position = UDim2.new(0,0,0,20),
                    Filled = false,
                    Parent = mode_frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Transparency = 0
                })
            
                local keytext = utility.create("Text", {
                    Font = custom_font,
                    Size = 13,
                    Theme = "Text",
                    Position = UDim2.new(0,2,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false
                })
                
                holdbutton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        key_mode = "Hold"
                        utility.changeobjecttheme(holdtext, "Accent")
                        utility.changeobjecttheme(toggletext, "Text")
                        mode_frame.Visible = false
                    end
                end)
                
                togglebutton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        key_mode = "Toggle"
                        utility.changeobjecttheme(holdtext, "Text")
                        utility.changeobjecttheme(toggletext, "Accent")
                        mode_frame.Visible = false
                    end
                end)
                
                local list_obj = nil
                if ignore_list == false then
                    list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                end
                
                local removetext = utility.create("Text", {
                    Font = custom_font,
                    Size = 13,
                    Color = Color3.fromRGB(245,245,245),
                    Position = UDim2.new(1,-20,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false,
                    Text = "...",
                    Transparency = 0.5
                })
                
                local removetext_bold = utility.create("Text", {
                    Font = custom_font,
                    Size = 13,
                    Color = Color3.fromRGB(245,245,245),
                    Position = UDim2.new(1,-21,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false,
                    Text = "...",
                    Transparency = 0.5
                })
                
                local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", custom_font, 13).X + 10, 0, 10), ZIndex = 13})
                
                remove.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        mode_frame.Visible = true
                    end
                end)
                
                local key
                local state = false
                local binding
                local c
            
                local function set(newkey)
                    if c then
                        c:Disconnect()
                        if flag then
                            library.flags[flag] = false
                        end
                        callback(false)
                        if ignore_list == false then
                           list_obj:is_active(false)
                        end
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
                        if ignore_list == false then
                            list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    else
                        key = nil
            
                        local text = ""
            
                        keytext.Text = text
                        if ignore_list == false then
                            list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    end
            
                    state = false
                    if flag then
                        library.flags[flag] = state
                    end
                    callback(false)
                    if ignore_list == false then
                       list_obj:is_active(state)
                    end
                end
            
                utility.connect(services.InputService.InputBegan, function(inp)
                    if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                        if key_mode == "Hold" then
                            if flag then
                                library.flags[flag] = true
                            end
                            if ignore_list == false then
                               list_obj:is_active(true)
                            end
                            c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                if callback then
                                    callback(true)
                                end
                            end)
                        else
                            state = not state
                            if flag then
                                library.flags[flag] = state
                            end
                            callback(state)
                            if ignore_list == false then
                               list_obj:is_active(state)
                            end
                        end
                    end
                end)
            
                set(default)
            
                frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or (is_mobile and input.UserInputType == Enum.UserInputType.Touch) then
                        if not binding then
                            keytext.Text = "..."
                            
                            binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                                set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                                utility.disconnect(binding)
                                task.wait()
                                binding = nil
                            end)
                        end
                    end
                end)
            
                utility.connect(services.InputService.InputEnded, function(inp)
                    if key_mode == "Hold" then
                        if key ~= '' or key ~= nil then
                            if inp.KeyCode == key or inp.UserInputType == key then
                                if c then
                                    c:Disconnect()
                                    if ignore_list == false then
                                       list_obj:is_active(false)
                                    end
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
            
                local keybindtypes = {}
            
                function keybindtypes:set(newkey)
                    set(newkey)
                end
            
                return keybindtypes
            end
            
            function section_tbl:new_seperator(cfg)
                local seperator_text = cfg.name or cfg.Name or "new seperator"
                
                local separator = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, 0, 0, 12),Parent = section_content})
                
                local separatorline = utility.create("Square", {Size = UDim2.new(1, 0, 0, 1),Position = UDim2.new(0, 0, 0.5, 0),Thickness = 0,Filled = true,ZIndex = 7,Theme = "Object Background",Parent = separator})
                
                local outline10 = utility.outline(separatorline, "Section Inner Border")
                utility.outline(outline10, "Section Outer Border")
                
                local sizeX = utility.textlength(seperator_text, custom_font, 13).X
                
                local separatorborder1 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                
                local separatorborder2 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, sizeX / 2 + 5, 0, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                
                local separatorcutoff = utility.create("Square", {Size = UDim2.new(0, sizeX + 12, 0, 5),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -2),ZIndex = 8,Filled = true,Theme = "Section Background",Parent = separator})
                
                local text = utility.create("Text", {Text = seperator_text,Font = custom_font,Size = 13,Position = UDim2.new(0.5, 0, 0, -1),Theme = "Text",ZIndex = 9,Outline = false,Center = true,Parent = separator})
            end
            
            function section_tbl:new_colorpicker(cfg)
                local colorpicker_tbl = {}
                local name = cfg.name or cfg.Name or "new colorpicker"
                local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0)
                local flag = cfg.flag or cfg.Flag or utility.nextflag()
                local callback = cfg.callback or function() end

                local holder = utility.create("Square", {
                    Transparency = 0,
                    Filled = true,
                    Thickness = 1,
                    Size = UDim2.new(1, 0, 0, 10),
                    ZIndex = 7,
                    Parent = section_content
                })

                local title = utility.create("Text", {
                    Text = name,
                    Font = custom_font,
                    Size = 13,
                    Position = UDim2.new(0, -1, 0, -1),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                })

                local colorpickers = 0

                local colorpickertypes = library.createcolorpicker(default, holder, colorpickers, flag, callback, -2)

                function colorpickertypes:new_colorpicker(cfg)
                    colorpickers = colorpickers + 1
                    local cp_tbl = {}

                    utility.table(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0)
                    local flag = cfg.flag or cfg.Flag or utility.nextflag()
                    local callback = cfg.callback or function() end
                    local defaultalpha = cfg.alpha or cfg.Alpha or 1

                    local cp = library.createcolorpicker(default, holder, colorpickers, flag, callback, -2)
                    function cp_tbl:set(color)
                        cp:set(color, false, true)
                    end
                    return cp_tbl
                end

                function colorpicker_tbl:set(color)
                    colorpickertypes:set(color, false, true)
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
                
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 19),Parent = section_content})
                
                local textbox = utility.create("Square", {
                    Filled = true,
                    Visible = true,
                    Thickness = 0,
                    Theme = "Object Background",
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    ZIndex = 7,
                    Parent = holder
                })
                
                local outline11 = utility.outline(textbox, "Section Inner Border")
                utility.outline(outline11, "Section Outer Border")
                
                local textbox_gradient = utility.create_uigradient(90)
                textbox_gradient.Transparency = NumberSequence.new(0.5)
                textbox_gradient.Parent = textbox
                
                local text = utility.create("Text", {
                    Text = default,
                    Font = custom_font,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                    Theme = "Text",
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                
                local placeholder_text = utility.create("Text", {
                    Text = placeholder,
                    Font = custom_font,
                    Transparency = 0.5,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                    Theme = "Text",
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                
                library.createbox(textbox, text,  function(str) 
                    if str == "" then
                        placeholder_text.Visible = true
                        text.Visible = false
                    else
                        placeholder_text.Visible = false
                        text.Visible = true
                    end
                end, function(str)
                    library.flags[flag] = str
                    callback(str)
                end)

                local function set(str)
                    text.Visible = str ~= ""
                    placeholder_text.Visible = str == ""
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
    
    function window_tbl:set_keybind_list_visibility(state)
        window_key_list:set_visible(state)
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
