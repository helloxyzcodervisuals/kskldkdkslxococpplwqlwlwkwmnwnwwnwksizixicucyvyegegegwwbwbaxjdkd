local uis = game:GetService("UserInputService") 
local players = game:GetService("Players") 
local ws = game:GetService("Workspace")
local rs = game:GetService("ReplicatedStorage")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")
local sound_service = game:GetService("SoundService")

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

local camera = ws.CurrentCamera
local lp = players.LocalPlayer 
local mouse = lp:GetMouse() 
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max 
local floor = math.floor 
local min = math.min 
local abs = math.abs 
local noise = math.noise
local rad = math.rad 
local random = math.random 
local pow = math.pow 
local sin = math.sin 
local pi = math.pi 
local tan = math.tan 
local atan2 = math.atan2 
local clamp = math.clamp 

local insert = table.insert 
local find = table.find 
local remove = table.remove
local concat = table.concat

if getgenv().library then 
    library:unloadMenu()
end 

getgenv().library = {
    directory = "obels",
    folders = {
        "/fonts",
        "/configs",
    },
    flags = {},
    config_flags = {},

    connections = {},   
    notifications = {notifs = {}, offset = 0},
    playerlist_data = {
        players = {},
        player = {}, 
    },
    colorpicker_open = false, 
    gui = nil, 
}

local themes = {
    preset = {
        ["accent"] = hex("#AA55EB"),
    }, 	

    utility = {
        ["accent"] = {
            ["BackgroundColor3"] = {}, 	
            ["TextColor3"] = {}, 
            ["ImageColor3"] = {}, 
            ["ScrollBarImageColor3"] = {} 
        },
    }, 
}

local keys = {
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Insert] = "INS",
    [Enum.KeyCode.Backspace] = "BS",
    [Enum.KeyCode.Return] = "Ent",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.RightAlt] = "RA",
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
    [Enum.KeyCode.KeypadOne] = "Num1",
    [Enum.KeyCode.KeypadTwo] = "Num2",
    [Enum.KeyCode.KeypadThree] = "Num3",
    [Enum.KeyCode.KeypadFour] = "Num4",
    [Enum.KeyCode.KeypadFive] = "Num5",
    [Enum.KeyCode.KeypadSix] = "Num6",
    [Enum.KeyCode.KeypadSeven] = "Num7",
    [Enum.KeyCode.KeypadEight] = "Num8",
    [Enum.KeyCode.KeypadNine] = "Num9",
    [Enum.KeyCode.KeypadZero] = "Num0",
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
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
    [Enum.KeyCode.Escape] = "ESC",
    [Enum.KeyCode.Space] = "SPC",
}

library.__index = library

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

local flags = library.flags 
local config_flags = library.config_flags

if not LPH_OBFUSCATED then
    getfenv().LPH_NO_VIRTUALIZE = function(...) return (...) end
end

if not isfile(library.directory .. "/fonts/main.ttf") then 
    writefile(library.directory .. "/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"))
end

local tahoma = {
    name = "SmallestPixel7",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset(library.directory .. "/fonts/main.ttf")
        }
    }
}

if not isfile(library.directory .. "/fonts/main_encoded.ttf") then 
    writefile(library.directory .. "/fonts/main_encoded.ttf", http_service:JSONEncode(tahoma))
end 

library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)

local function isTouch()
    return uis.TouchEnabled
end

local function getInputPosition(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        return input.Position
    elseif input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.MouseButton1 then
        return input.Position
    end
    return Vector2.new(0, 0)
end

function library:create(instance, options)
    local ins = Instance.new(instance) 
    
    for prop, value in next, options do 
        ins[prop] = value
    end
    
    return ins 
end

function library:tween(obj, properties) 
    local tween = tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
        
    return tween
end 

function library:closeCurrentElement(cfg) 
    local path = library.current_element_open 

    if path and path ~= cfg then 
        path.setVisible(false)
        path.open = false 
    end
end 

function library:mouseInFrame(uiobject)
    local mousePos
    if isTouch() then
        local touches = uis:GetTouches()
        if #touches > 0 then
            mousePos = touches[1].Position
        else
            return false
        end
    else
        mousePos = uis:GetMouseLocation()
    end
    
    local y_cond = uiobject.AbsolutePosition.Y <= mousePos.Y and mousePos.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
    local x_cond = uiobject.AbsolutePosition.X <= mousePos.X and mousePos.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

    return (y_cond and x_cond)
end

function library:draggify(frame, handle)
    local dragging = false 
    local start_size = frame.Position
    local start 
    
    handle = handle or frame
    
    local function beginDrag(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            start_size = frame.Position
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            start_size = frame.Position
        end
    end
    
    local function endDrag(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end
    
    handle.InputBegan:Connect(beginDrag)
    
    uis.InputEnded:Connect(endDrag)

    self:connection(uis.InputChanged, function(input, game_event) 
        if dragging then
            local inputType = isTouch() and Enum.UserInputType.Touch or Enum.UserInputType.MouseMovement
            if input.UserInputType == inputType then
                local viewport_x = camera.ViewportSize.X
                local viewport_y = camera.ViewportSize.Y

                local current_position = dim2(
                    0,
                    clamp(
                        start_size.X.Offset + (input.Position.X - start.X),
                        0,
                        viewport_x - frame.Size.X.Offset
                    ),
                    0,
                    math.clamp(
                        start_size.Y.Offset + (input.Position.Y - start.Y),
                        0,
                        viewport_y - frame.Size.Y.Offset
                    )
                )

                frame.Position = current_position
            end
        end
    end)
end 

function library:makeResizable(frame) 
    local Frame = self:create("TextButton", {
        Parent = frame,
        Position = dim2(1, -10, 1, -10),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 10, 0, 10),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        BackgroundTransparency = 1,
        Text = ""
    })

    local resizing = false 
    local start_size 
    local start 
    local og_size = frame.Size  

    local function beginResize(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            start = input.Position
            start_size = frame.Size
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            start = input.Position
            start_size = frame.Size
        end
    end
    
    local function endResize(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end

    Frame.InputBegan:Connect(beginResize)
    Frame.InputEnded:Connect(endResize)

    self:connection(uis.InputChanged, function(input, game_event) 
        if resizing then
            local inputType = isTouch() and Enum.UserInputType.Touch or Enum.UserInputType.MouseMovement
            if input.UserInputType == inputType then
                local viewport_x = camera.ViewportSize.X
                local viewport_y = camera.ViewportSize.Y

                local current_size = dim2(
                    start_size.X.Scale,
                    math.clamp(
                        start_size.X.Offset + (input.Position.X - start.X),
                        og_size.X.Offset,
                        viewport_x
                    ),
                    start_size.Y.Scale,
                    math.clamp(
                        start_size.Y.Offset + (input.Position.Y - start.Y),
                        og_size.Y.Offset,
                        viewport_y
                    )
                )
                frame.Size = current_size
            end
        end
    end)
end

function library:round(number, float) 
    local multiplier = 1 / (float or 1)

    return floor(number * multiplier + 0.5) / multiplier
end 

function library:applyTheme(instance, theme, property) 
    insert(themes.utility[theme][property], instance)
end

function library:updateTheme(theme, color)
    for _, property in next, themes.utility[theme] do 
        for m, object in next, property do 
            if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then 
                object[_] = color 
            end 
        end 
    end 

    themes.preset[theme] = color 
end 

function library:connection(signal, callback)
    local connection = signal:Connect(callback)
    
    insert(library.connections, connection)

    return connection 
end

function library:unloadMenu() 
    if library.gui then 
        library.gui:Destroy()
    end
    
    for index, connection in next, library.connections do 
        connection:Disconnect() 
        connection = nil 
    end     
    
    getgenv().library = nil 
end 

library.lerp = LPH_NO_VIRTUALIZE(function(start, finish, t)
    t = t or 1 / 8
    return start * (1 - t) + finish * t
end)

function library:window(properties)
    local cfg = {
        name = properties.name or properties.Name or os.date('<font color="rgb(170,85,235)">obelus</font> | %b %d %Y | %H:%M'),
        size = properties.size or properties.Size or dim2(0, 516, 0, 563),
        selected_tab, 
        is_closing_menu = false,
    }

    library.gui = self:create("ScreenGui", {
        Parent = coregui,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })

    local outline = self:create("Frame", {
        Parent = library.gui,
        Position = dim2(0.5, 0 - (cfg.size.X.Offset / 2), 0.5, 0 - (cfg.size.X.Offset / 2)),
        BorderColor3 = rgb(0, 0, 0),
        Size = cfg.size,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0)
    }); outline.Position = dim_offset(outline.AbsolutePosition.X, outline.AbsolutePosition.Y)

    self:draggify(outline)
    self:makeResizable(outline)
    
    local inline = self:create("Frame", {
        Parent = outline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(48, 48, 48)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(12, 12, 12)
    })
    
    local title_holder = self:create("Frame", {
        Parent = background,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 29),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local ui_title = self:create("TextLabel", {
        Parent = title_holder,
        FontFace = library.font,
        TextColor3 = rgb(135, 135, 135),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Size = dim2(1, 0, 0, 24),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        RichText = true,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local accent_line = self:create("Frame", {
        Parent = title_holder,
        Position = dim2(0, 0, 1, -6),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }); self:applyTheme(accent_line, "accent", "BackgroundColor3")
    
    self:create("UIGradient", {
        Parent = accent_line,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(109, 109, 109))}
    })
    
    cfg["tab_holder"] = self:create("Frame", {
        Parent = background,
        BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, 30),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 30),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["tab_holder"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = dim(0, -1),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = background,
        PaddingBottom = dim(0, 11),
        PaddingRight = dim(0, 9),
        PaddingLeft = dim(0, 9)
    })
    
    local page_holder = self:create("Frame", {
        Parent = background,
        Position = dim2(0, 0, 0, 66),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, -66),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0)
    })
    
    local inline = self:create("Frame", {
        Parent = page_holder,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(51, 51, 51)
    })
    
    cfg["page_holder"] = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(13, 13, 13)
    }) 
    
    function cfg.toggle_menu(bool)
        if not cfg.is_closing_menu then
            cfg.is_closing_menu = true
    
            if bool == true then
                for element, original_transparency in next, old_data do
                    self:tween(element, {
                        BackgroundTransparency = original_transparency,
                    })
                end
    
                for element, original_transparency in next, text_data do
                    self:tween(element, {
                        TextTransparency = original_transparency,
                    })
                end
    
                for element, original_transparency in next, image_data do
                    self:tween(element, {
                        ImageTransparency = original_transparency,
                    })
                end

                for element, original_transparency in next, scroll_data do
                    self:tween(element, {
                        ScrollBarImageTransparency = original_transparency,
                    })
                end
                
            else
                for _, element in next, library.gui:GetDescendants() do
                    if not element:IsA("GuiObject") then
                        continue
                    end
    
                    old_data[element] = element.BackgroundTransparency
                    self:tween(element, {
                        BackgroundTransparency = 1,
                    })
    
                    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                        text_data[element] = element.TextTransparency
                        self:tween(element, {
                            TextTransparency = 1,
                        })
                    end
    
                    if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                        image_data[element] = element.ImageTransparency
                        self:tween(element, {
                            ImageTransparency = 1,
                        })
                    end

                    if element:IsA("ScrollingFrame") then 
                        scroll_data[element] = element.ScrollBarImageTransparency
                        self:tween(element, {
                            ScrollBarImageTransparency = 1,
                        })
                    end 
                end
            end
            
            task.delay(0.5, function()
                cfg.is_closing_menu = false 
            end)
        end
    end

    return setmetatable(cfg, library)
end
--[[
function library:tab(properties)
    local cfg = {
        name = properties.name or "visuals", 
    } 

    local outline = self:create("TextButton", {
        Parent = self.tab_holder,
        FontFace = library.font,
        TextColor3 = rgb(0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Size = dim2(0, 0, 0, 30),
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = rgb(0, 0, 0)
    })
    
    local inline = self:create("Frame", {
        Parent = outline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(41, 41, 41)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local gradient = self:create("UIGradient", {
        Parent = background,
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(41, 41, 41)), 
            rgbkey(1, rgb(16, 16, 16))
        }
    })
    
    local text = self:create("TextLabel", {
        Parent = background,
        FontFace = library.font,
        TextColor3 = rgb(140, 140, 140),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, -1),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    }); self:applyTheme(text, "accent", "TextColor3")

    cfg["page"] = self:create("Frame", {
        Parent = self.page_holder,
        Visible = false, 
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(13, 13, 13)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["page"],
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = dim(0, 11),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalFlex = Enum.UIFlexAlignment.Fill
    })
    
    self:create("UIPadding", {
        Parent = cfg["page"],
        PaddingTop = dim(0, 11),
        PaddingBottom = dim(0, 11),
        PaddingRight = dim(0, 11),
        PaddingLeft = dim(0, 11)
    })

    function cfg.open_tab() 
        self:closeCurrentElement() 

        if self.selected_tab then 
            self.selected_tab[1].TextColor3 = rgb(160,160,160)
            self.selected_tab[2].Visible = false 
            self.selected_tab[3].Color = rgbseq{
                rgbkey(0, rgb(41, 41, 41)),
                rgbkey(1, rgb(16, 16, 16))
            }

            self.selected_tab = nil 
        end 

        text.TextColor3 = themes.preset.accent
        cfg["page"].Visible = true 
        gradient.Color = rgbseq{
            rgbkey(0, rgb(41, 41, 41)),
            rgbkey(1, rgb(25, 25, 25))
        }
        self.selected_tab = {text, cfg["page"], gradient}
    end 

    local function onTabClick()
        if isTouch() then
            cfg.open_tab()
        end
    end

    outline.MouseButton1Click:Connect(function()
        cfg.open_tab()
    end)
    
    if isTouch() then
        outline.TouchTap:Connect(onTabClick)
    end

    if not self.selected_tab then 
        cfg.open_tab(true) 
    end 

    return setmetatable(cfg, library)    
end
--]]
function library:tab(properties)
    local cfg = {
        name = properties.name or "visuals", 
    } 

    local outline = self:create("TextButton", {
        Parent = self.tab_holder,
        FontFace = library.font,
        TextColor3 = rgb(0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Size = dim2(0, 0, 0, 30),
        BorderSizePixel = 0,
        TextSize = 14,
        BackgroundColor3 = rgb(0, 0, 0)
    })
    
    local inline = self:create("Frame", {
        Parent = outline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(41, 41, 41)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local gradient = self:create("UIGradient", {
        Parent = background,
        Rotation = 90,
        Color = rgbseq{
            rgbkey(0, rgb(41, 41, 41)), 
            rgbkey(1, rgb(16, 16, 16))
        }
    })
    
    local text = self:create("TextLabel", {
        Parent = background,
        FontFace = library.font,
        TextColor3 = rgb(140, 140, 140),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, -1),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    }); self:applyTheme(text, "accent", "TextColor3")

    cfg["page"] = self:create("ScrollingFrame", {
        Parent = self.page_holder,
        Visible = false, 
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(13, 13, 13),
        BackgroundTransparency = 1,
        ScrollBarImageColor3 = rgb(65, 65, 65),
        ScrollBarThickness = 4,
        ScrollBarImageTransparency = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = dim2(0, 0, 0, 0),
        ClipsDescendants = true
    })
    
    local page_content = self:create("Frame", {
        Parent = cfg["page"],
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(13, 13, 13),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    self:create("UIListLayout", {
        Parent = page_content,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = dim(0, 11),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalFlex = Enum.UIFlexAlignment.Fill
    })
    
    self:create("UIPadding", {
        Parent = page_content,
        PaddingTop = dim(0, 11),
        PaddingBottom = dim(0, 11),
        PaddingRight = dim(0, 11),
        PaddingLeft = dim(0, 11)
    })

    cfg["page_content"] = page_content

    function cfg.open_tab() 
        self:closeCurrentElement() 

        if self.selected_tab then 
            self.selected_tab[1].TextColor3 = rgb(160,160,160)
            self.selected_tab[2].Visible = false 
            self.selected_tab[3].Color = rgbseq{
                rgbkey(0, rgb(41, 41, 41)),
                rgbkey(1, rgb(16, 16, 16))
            }

            self.selected_tab = nil 
        end 

        text.TextColor3 = themes.preset.accent
        cfg["page"].Visible = true 
        gradient.Color = rgbseq{
            rgbkey(0, rgb(41, 41, 41)),
            rgbkey(1, rgb(25, 25, 25))
        }
        self.selected_tab = {text, cfg["page"], gradient}
    end 

    local function onTabClick()
        if isTouch() then
            cfg.open_tab()
        end
    end

    outline.MouseButton1Click:Connect(function()
        cfg.open_tab()
    end)
    
    if isTouch() then
        outline.TouchTap:Connect(onTabClick)
    end

    if not self.selected_tab then 
        cfg.open_tab(true) 
    end 

    return setmetatable(cfg, library)    
end
function library:column(properties)
    local cfg = {
        fill = properties.fill or properties.Fill or false, 
    }

    cfg["column"] = self:create("Frame", {
        Parent = self.page,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 100, 0, 100),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(12, 12, 12)
    })
    
    local column_scroll = self:create("ScrollingFrame", {
        Parent = cfg["column"],
        ScrollBarImageColor3 = rgb(65, 65, 65),
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BackgroundColor3 = rgb(255, 255, 255),
        ZIndex = 5,
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
        ScrollingEnabled = true
    })
    
    local content_frame = self:create("Frame", {
        Parent = column_scroll,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    self:create("UIListLayout", {
        Parent = content_frame,
        Padding = dim(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder, 
        VerticalFlex = cfg.fill and Enum.UIFlexAlignment.Fill or Enum.UIFlexAlignment.None
    })

    cfg["content_frame"] = content_frame

    run.RenderStepped:Connect(function()
        if column_scroll then
            local maxScroll = column_scroll.CanvasSize.Y.Offset - column_scroll.AbsoluteWindowSize.Y
            if maxScroll > 0 then
                local currentScroll = column_scroll.CanvasPosition.Y
                local newScroll = currentScroll + 1
                
                --if newScroll > maxScroll then
                --    newScroll = 0
                --end
                
                column_scroll.CanvasPosition = Vector2.new(0, newScroll)
            end
        end
    end)

    return setmetatable(cfg, library)
end


function library:section(properties)
    local cfg = {
        name = properties.name or properties.Name or "section", 
        size = properties.size or properties.Size or dim2(1, 0, 1, -12)
    }   

    local outline = self:create("Frame", {
        Parent = self.content_frame,
        BorderColor3 = rgb(0, 0, 0),
        Size = self.fill and dim2(1, 0, 0, 0) or cfg.size,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(12, 12, 12)
    })
    
    local inline = self:create("Frame", {
        Parent = outline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(19, 19, 19)
    })

    local scrollbar_fill = self:create("Frame", {
        Parent = background,
        Visible = false, 
        Size = dim2(0, 5, 1, 0),
        Position = dim2(1, -5, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local shadow = self:create("Frame", {
        Parent = background,
        Size = dim2(1, -5, 0, 21),
        Position = dim2(0, 0, 1, -21),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 999,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(19, 19, 19)
    })
    
    local UIGradient = self:create("UIGradient", {
        Parent = shadow,
        Rotation = -90,
        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
    })
    
    local elements_scroll = self:create("ScrollingFrame", {
        Parent = background,
        ScrollBarImageColor3 = rgb(65, 65, 65),
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BackgroundColor3 = rgb(255, 255, 255),
        ZIndex = 5,
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
        ScrollingEnabled = true
    })
    
    cfg["elements"] = self:create("Frame", {
        Parent = elements_scroll,
        Position = dim2(0, 8, 0, 16),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -16, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["elements"],
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = dim(0, 3)
    })
    
    local empty_space = self:create("Frame", {
        Parent = cfg["elements"],
        LayoutOrder = 9999999,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 50),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local section_title = self:create("TextLabel", {
        Parent = outline,
        FontFace = library.font,
        TextColor3 = rgb(205, 205, 205),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        AutomaticSize = Enum.AutomaticSize.XY,
        AnchorPoint = vec2(0, 0.5),
        Position = dim2(0, 14, 0, 3),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        ZIndex = 2,
        TextSize = 12,
        BackgroundColor3 = rgb(19, 19, 19)
    })

    local section_filler = self:create("Frame", {
        Parent = outline,
        AnchorPoint = vec2(0, 0.5),
        Position = dim2(0, 13, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, section_title.TextBounds.X, 0, 3),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(19, 19, 19)
    })

    local function updateScrollbarVisibility()
        if elements_scroll and background then
            local needsScroll = elements_scroll.CanvasSize.Y.Offset > elements_scroll.AbsoluteWindowSize.Y
            scrollbar_fill.Visible = needsScroll
        end
    end

    elements_scroll:GetPropertyChangedSignal("CanvasSize"):Connect(updateScrollbarVisibility)
    elements_scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateScrollbarVisibility)

    run.RenderStepped:Connect(function()
        if elements_scroll then
            local maxScroll = elements_scroll.CanvasSize.Y.Offset - elements_scroll.AbsoluteWindowSize.Y
            if maxScroll > 0 then
                local currentScroll = elements_scroll.CanvasPosition.Y
                local newScroll = currentScroll + 1
                
                if newScroll > maxScroll then
                    newScroll = 0
                end
                
                elements_scroll.CanvasPosition = Vector2.new(0, newScroll)
            end
        end
    end)

    return setmetatable(cfg, library)
end
--[[
function library:addToggle(options) 
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or "Toggle",
        flag = options.flag or tostring(random(1,9999999)),
        
        default = options.default or false,
        folding = options.folding or false, 
        callback = options.callback or function() end,
    }

    local toggle = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(151, 151, 151),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    cfg["right_components"] = self:create("Frame", {
        Parent = toggle,
        Position = dim2(1, 0, 0, -1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["right_components"],
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = toggle
    })
    
    local left_components = self:create("Frame", {
        Parent = toggle,
        BackgroundTransparency = 1,
        Position = dim2(0, 3, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = left_components,
        Padding = dim(0, 5),
        FillDirection = Enum.FillDirection.Horizontal
    })
    
    self:create("UIPadding", {
        Parent = left_components,
        PaddingBottom = dim(0, 5)
    })
    
    local toggle_button = self:create("TextButton", {
        Parent = left_components,
        Text = "",
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 8, 0, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(2, 2, 2),
        LayoutOrder = -1,
        AutoButtonColor = false
    })
    
    local inline = self:create("Frame", {
        Parent = toggle_button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(63, 63, 63)
    })
    
    self:create("UIGradient", {
        Parent = inline,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(232, 232, 232)), rgbkey(1, rgb(162, 162, 162))}
    })
    
    local accent = self:create("Frame", {
        Parent = inline,
        Visible = false,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }); self:applyTheme(accent, "accent", "BackgroundColor3")
    
    self:create("UIGradient", {
        Parent = accent,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(109, 109, 109))}
    })
    
    local text = self:create("TextButton", {
        Parent = left_components,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Size = dim2(0, 0, 1, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    cfg.background = self:create("Frame", {
        Parent = toggle,
        Visible = false,
        BorderColor3 = rgb(0, 0, 0),
        LayoutOrder = 99,
        Position = dim2(0, 0, 0, 15),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    self:create("UIListLayout", {
        Parent = cfg.background,
        Padding = dim(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    })

    function cfg.set(bool) 
        accent.Visible = bool 
        cfg.callback(bool)

        flags[cfg.flag] = bool

        if cfg.folding then 
            cfg.background.Visible = bool
        end 
    end 

    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    local function onToggleClick()
        cfg.enabled = not cfg.enabled 
        cfg.set(cfg.enabled)
    end

    toggle_button.MouseButton1Click:Connect(onToggleClick)
    text.MouseButton1Click:Connect(onToggleClick)
    
    if isTouch() then
        toggle_button.TouchTap:Connect(onToggleClick)
        text.TouchTap:Connect(onToggleClick)
    end

    return setmetatable(cfg, library)
end
--]]
function library:addSlider(options) 
    local cfg = {
        name = options.name or nil,
        suffix = options.suffix or "",
        flag = options.flag or tostring(2^789),
        callback = options.callback or function() end, 

        min = options.min or options.minimum or 0,
        max = options.max or options.maximum or 100,
        intervals = options.interval or options.decimal or 1,
        default = options.default or 10,
        value = options.default or 10, 

        ignore = options.ignore or false, 
        dragging = false,
    } 

    local slider = self:create("TextLabel", {
        Parent = self.elements or self.background,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local bottom_components = self:create("Frame", {
        Parent = slider,
        Position = dim2(0, 15, 0, cfg.name and 13 or 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local slider_dragger = self:create("TextButton", {
        Parent = bottom_components,
        AutoButtonColor = false, 
        Text = "", 
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -27, 1, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(1, 1, 1)
    })
    
    local background = self:create("Frame", {
        Parent = slider_dragger,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local fill = self:create("Frame", {
        Parent = background,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }); self:applyTheme(fill, "accent", "BackgroundColor3")
    
    self:create("UIGradient", {
        Parent = fill,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(232, 232, 232)), rgbkey(1, rgb(162, 162, 162))}
    })
    
    local text_slider = self:create("TextLabel", {
        Parent = fill,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "0%",
        AnchorPoint = vec2(0.5, 0),
        BackgroundTransparency = 1,
        Position = dim2(1, 0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIGradient", {
        Parent = background,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(63, 63, 63)), rgbkey(1, rgb(42, 42, 42))}
    })
    
    self:create("UIListLayout", {
        Parent = bottom_components,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = dim(0, 3),
        FillDirection = Enum.FillDirection.Vertical
    })

    self:create("UIPadding", {
        Parent = slider,
        PaddingLeft = dim(0, 1)
    })
    
    if cfg.name then 
        local left_components = self:create("Frame", {
            Parent = slider,
            BackgroundTransparency = 1,
            Position = dim2(0, 16, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local text = self:create("TextLabel", {
            Parent = left_components,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = cfg.name,
            BackgroundTransparency = 1,
            Size = dim2(0, 0, 1, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        self:create("UIListLayout", {
            Parent = left_components,
            Padding = dim(0, 5),
            FillDirection = Enum.FillDirection.Horizontal
        })
        
        self:create("UIPadding", {
            Parent = left_components,
            PaddingBottom = dim(0, 6)
        })
    end 

    if not self.background then 
        local seperator = self:create("Frame", {
            Parent = slider,
            Position = dim2(0, 0, 1, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 5),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
    end 

    function cfg.set(value) 
        cfg.value = clamp(self:round(value, cfg.intervals), cfg.min, cfg.max)

        fill.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
        text_slider.Text = tostring(cfg.value) .. cfg.suffix

        flags[cfg.flag] = cfg.value
        cfg.callback(flags[cfg.flag])
    end 

    cfg.set(cfg.default)

    local function beginDrag(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            cfg.dragging = true
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            cfg.dragging = true
        end
    end
    
    local function updateDrag(input)
        if cfg.dragging then
            local inputType = isTouch() and Enum.UserInputType.Touch or Enum.UserInputType.MouseMovement
            if input.UserInputType == inputType then
                local size_x = (input.Position.X - slider_dragger.AbsolutePosition.X) / slider_dragger.AbsoluteSize.X
                local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                cfg.set(value)
            end
        end
    end
    
    local function endDrag(input)
        if isTouch() and input.UserInputType == Enum.UserInputType.Touch then
            cfg.dragging = false
        elseif not isTouch() and input.UserInputType == Enum.UserInputType.MouseButton1 then
            cfg.dragging = false
        end
    end

    slider_dragger.InputBegan:Connect(beginDrag)
    uis.InputChanged:Connect(updateDrag)
    uis.InputEnded:Connect(endDrag)

    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end
--[[
function library:addToggle(options) 
    local cfg = {
        enabled = options.enabled or false,
        name = options.name or "Toggle",
        flag = options.flag or tostring(random(1,9999999)),
        
        default = options.default or false,
        folding = options.folding or false, 
        callback = options.callback or function() end,
    }

    local toggle = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(151, 151, 151),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    cfg["right_components"] = self:create("Frame", {
        Parent = toggle,
        Position = dim2(1, 0, 0, -1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["right_components"],
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = toggle
    })
    
    local left_components = self:create("Frame", {
        Parent = toggle,
        BackgroundTransparency = 1,
        Position = dim2(0, 3, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = left_components,
        Padding = dim(0, 5),
        FillDirection = Enum.FillDirection.Horizontal
    })
    
    self:create("UIPadding", {
        Parent = left_components,
        PaddingBottom = dim(0, 5)
    })
    
    local toggle_button = self:create("TextButton", {
        Parent = left_components,
        Text = "",
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 8, 0, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(2, 2, 2),
        LayoutOrder = -1,
        AutoButtonColor = false
    })
    
    local inline = self:create("Frame", {
        Parent = toggle_button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(63, 63, 63)
    })
    
    self:create("UIGradient", {
        Parent = inline,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(232, 232, 232)), rgbkey(1, rgb(162, 162, 162))}
    })
    
    local accent = self:create("Frame", {
        Parent = inline,
        Visible = cfg.default,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.accent
    }); self:applyTheme(accent, "accent", "BackgroundColor3")
    
    self:create("UIGradient", {
        Parent = accent,
        Rotation = 90,
        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(109, 109, 109))}
    })
    
    local text = self:create("TextButton", {
        Parent = left_components,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Size = dim2(0, 0, 1, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    cfg.background = self:create("Frame", {
        Parent = toggle,
        Visible = cfg.folding and cfg.default,
        BorderColor3 = rgb(0, 0, 0),
        LayoutOrder = 99,
        Position = dim2(0, 0, 0, 15),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = rgb(13, 13, 13)
    })

    self:create("UIListLayout", {
        Parent = cfg.background,
        Padding = dim(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    })

    function cfg.set(bool) 
        cfg.enabled = bool
        accent.Visible = bool 
        cfg.callback(bool)

        flags[cfg.flag] = bool

        if cfg.folding then 
            cfg.background.Visible = bool
        end 
    end 

    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    local function onToggleClick()
        cfg.set(not cfg.enabled)
    end

    toggle_button.MouseButton1Click:Connect(onToggleClick)
    text.MouseButton1Click:Connect(onToggleClick)
    
    if isTouch() then
        toggle_button.TouchTap:Connect(onToggleClick)
        text.TouchTap:Connect(onToggleClick)
    end

    return setmetatable(cfg, library)
end
--]]
function library:addToggle(options) 
    local cfg = {
        enabled = options.enabled or false,
        name = options.name or "Toggle",
        flag = options.flag or tostring(random(1,9999999)),
        default = options.default or false,
        folding = options.folding or false, 
        callback = options.callback or function() end,
    }

    local toggle = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(151, 151, 151),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local left_components = self:create("Frame", {
        Parent = toggle,
        BackgroundTransparency = 1,
        Position = dim2(0, 3, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = left_components,
        Padding = dim(0, 5),
        FillDirection = Enum.FillDirection.Horizontal
    })
    
    local toggle_box = self:create("TextButton", {
        Parent = left_components,
        Text = "",
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 8, 0, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(25, 25, 25),
        LayoutOrder = -1,
        AutoButtonColor = false
    })
    
    local toggle_inner = self:create("Frame", {
        Parent = toggle_box,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local toggle_bg = self:create("Frame", {
        Parent = toggle_inner,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = cfg.default and themes.preset.accent or rgb(15, 15, 15)
    }); self:applyTheme(toggle_bg, "accent", "BackgroundColor3")
    
    local text = self:create("TextButton", {
        Parent = left_components,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Size = dim2(0, 0, 1, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    cfg.background = self:create("Frame", {
        Parent = toggle,
        Visible = cfg.folding and cfg.default,
        BorderColor3 = rgb(0, 0, 0),
        LayoutOrder = 99,
        Position = dim2(0, 0, 0, 15),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = rgb(13, 13, 13)
    })

    self:create("UIListLayout", {
        Parent = cfg.background,
        Padding = dim(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    })

    function cfg.set(bool) 
        cfg.enabled = bool
        toggle_bg.BackgroundColor3 = bool and themes.preset.accent or rgb(15, 15, 15)
        cfg.callback(bool)

        flags[cfg.flag] = bool

        if cfg.folding then 
            cfg.background.Visible = bool
        end 
    end 

    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    local function onToggleClick()
        cfg.set(not cfg.enabled)
    end

    toggle_box.MouseButton1Click:Connect(onToggleClick)
    text.MouseButton1Click:Connect(onToggleClick)

    return setmetatable(cfg, library)
end
--[[
function library:addDropdown(options) 
    local cfg = {
        name = options.name or nil,
        flag = options.flag or tostring(random(1,9999999)),

        items = options.items or {"1", "2", "3"},
        callback = options.callback or function() end,
        multi = options.multi or false, 
        scrolling = options.scrolling or false, 
        max_height = options.max_height or 150,

        open = false, 
        option_instances = {}, 
        multi_items = {}, 
        ignore = options.ignore or false, 
    }   

    if cfg.multi then
        cfg.default = options.default or {}
    else
        cfg.default = options.default or cfg.items[1]
    end

    flags[cfg.flag] = cfg.multi and {} or ""

    local dropdown_path = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    cfg["right_components"] = self:create("Frame", {
        Parent = dropdown_path,
        Position = dim2(1, 0, 0, -1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["right_components"],
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local bottom_components = self:create("Frame", {
        Parent = dropdown_path,
        Position = dim2(0, 15, 0, cfg.name and 11 or 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local dropdown = self:create("TextButton", {
        Parent = bottom_components,
        AutoButtonColor = false, 
        Text = "",
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -27, 1, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(1, 1, 1)
    })
    
    local inline = self:create("Frame", {
        Parent = dropdown,
        Position = dim2(0, 0, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -1, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(25, 25, 25)
    })
    
    local arrow = self:create("ImageLabel", {
        Parent = background,
        Image = "rbxassetid://116204929609664",
        Position = dim2(1, -13, 0, 7),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 5, 0, 3),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })  

    local text = self:create("TextLabel", {
        Parent = background,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        Size = dim2(1, -25, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, 7, 0, -1),
        BorderSizePixel = 0,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, 
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundColor3 = rgb(255, 255, 255)
    })                    
    
    if cfg.name then 
        local left_components = self:create("Frame", {
            Parent = dropdown_path,
            BackgroundTransparency = 1,
            Position = dim2(0, 16, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local text = self:create("TextLabel", {
            Parent = left_components,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = cfg.name,
            BackgroundTransparency = 1,
            Size = dim2(0, 0, 1, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        self:create("UIListLayout", {
            Parent = left_components,
            Padding = dim(0, 5),
            FillDirection = Enum.FillDirection.Horizontal
        })
        
        self:create("UIPadding", {
            Parent = left_components,
            PaddingBottom = dim(0, 6)
        })
    end 

    local dropdown_holder = self:create("Frame", {
        Parent = library.gui,
        Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.max_height),
        Position = dim2(0, dropdown.AbsolutePosition.X, 0, dropdown.AbsolutePosition.Y + 25),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(1, 1, 1),
        Visible = false, 
        ZIndex = 999,
        ClipsDescendants = true
    })
    
    local inline = self:create("Frame", {
        Parent = dropdown_holder,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local text_holder = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(25, 25, 25)
    })
    
    local options_scroll = self:create("ScrollingFrame", {
        Parent = text_holder,
        ScrollBarImageColor3 = rgb(65, 65, 65),
        ScrollBarThickness = 4,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BackgroundColor3 = rgb(255, 255, 255),
        ZIndex = 5,
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true
    })
    
    local options_list = self:create("Frame", {
        Parent = options_scroll,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    self:create("UIListLayout", {
        Parent = options_list,
        Padding = dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = options_list,
        PaddingTop = dim(0, 5),
        PaddingBottom = dim(0, 5),
        PaddingLeft = dim(0, 5),
        PaddingRight = dim(0, 5)
    })

    function cfg.renderOption(text_value) 
        local OPTION = self:create("TextButton", {
            Parent = options_list,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = text_value,
            Size = dim2(1, 0, 0, 16),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }); self:applyTheme(OPTION, "accent", "TextColor3")

        return OPTION
    end 
    
    function cfg.setVisible(bool) 
        dropdown_holder.Visible = bool
        arrow.Rotation = bool and 180 or 0 

        if bool then 
            self:closeCurrentElement(cfg)
            library.current_element_open = cfg 
            
            dropdown_holder.Position = dim2(0, dropdown.AbsolutePosition.X, 0, dropdown.AbsolutePosition.Y + 25)
            dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.max_height)
        end
    end
    
    function cfg.set(value) 
        local selected = {}
        local isTable = type(value) == "table"

        for _, option in next, cfg.option_instances do 
            if option.Text == value or (isTable and find(value, option.Text)) then 
                insert(selected, option.Text)
                option.TextColor3 = themes.preset.accent
            else 
                option.TextColor3 = rgb(160, 160, 160)
            end
        end

        cfg.multi_items = selected

        if isTable then
            if #selected > 0 then
                text.Text = concat(selected, ", ")
            else
                text.Text = ""
            end
            flags[cfg.flag] = selected
        else
            if #selected > 0 then
                text.Text = selected[1]
                flags[cfg.flag] = selected[1]
            else
                text.Text = ""
                flags[cfg.flag] = ""
            end
        end
            
        cfg.callback(flags[cfg.flag]) 
    end
    
    function cfg.refreshOptions(list) 
        for _, option in next, cfg.option_instances do 
            option:Destroy() 
        end
        
        cfg.option_instances = {} 
        cfg.items = list

        for _, option in next, list do 
            local OPTION_INSTANCE = cfg.renderOption(option)
            insert(cfg.option_instances, OPTION_INSTANCE)
            
            local function onOptionClick()
                if cfg.multi then 
                    local selected_index = find(cfg.multi_items, OPTION_INSTANCE.Text)

                    if selected_index then 
                        remove(cfg.multi_items, selected_index)
                    else
                        insert(cfg.multi_items, OPTION_INSTANCE.Text)
                    end

                    cfg.set(cfg.multi_items) 				
                else 
                    cfg.setVisible(false)
                    cfg.open = false 
                    
                    cfg.set(OPTION_INSTANCE.Text)
                end
            end
            
            OPTION_INSTANCE.MouseButton1Click:Connect(onOptionClick)
            
            if isTouch() then
                OPTION_INSTANCE.TouchTap:Connect(onOptionClick)
            end
        end
    end

    cfg.refreshOptions(cfg.items)
    
    if cfg.multi then
        cfg.set(cfg.default or {})
    else
        if cfg.default and find(cfg.items, cfg.default) then
            cfg.set(cfg.default)
        elseif #cfg.items > 0 then
            cfg.set(cfg.items[1])
        end
    end

    local function onDropdownClick()
        cfg.open = not cfg.open 
        cfg.setVisible(cfg.open)
    end

    dropdown.MouseButton1Click:Connect(onDropdownClick)
    
    if isTouch() then
        dropdown.TouchTap:Connect(onDropdownClick)
    end

    dropdown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if not cfg.open then return end
        dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.max_height)
    end)

    dropdown:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if not cfg.open then return end
        dropdown_holder.Position = dim2(0, dropdown.AbsolutePosition.X, 0, dropdown.AbsolutePosition.Y + 25)
    end)

    self:connection(uis.InputBegan, function(input, gameProcessed)
        if not cfg.open or gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            local mousePos = uis:GetMouseLocation()
            local isInDropdown = self:mouseInFrame(dropdown_holder)
            local isInButton = self:mouseInFrame(dropdown)
            
            if not isInDropdown and not isInButton then
                cfg.setVisible(false)
                cfg.open = false
            end
        end
    end)

    return setmetatable(cfg, library)
end
--]]
function library:addList(options) 
    local cfg = {
        name = options.name or nil,
        flag = options.flag or tostring(random(1,9999999)),
        items = options.items or {"1", "2", "3"},
        callback = options.callback or function() end,
        multi = options.multi or false, 
        height = options.height or 100,
        default = options.default or (cfg.multi and {}) or "",
        selected_items = {},
    }   

    flags[cfg.flag] = cfg.multi and {} or ""

    local list_container = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local bottom_components = self:create("Frame", {
        Parent = list_container,
        Position = dim2(0, 15, 0, cfg.name and 11 or 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local list_frame = self:create("Frame", {
        Parent = bottom_components,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -27, 0, cfg.height),
        BorderSizePixel = 1,
        BackgroundColor3 = rgb(25, 25, 25),
        Position = dim2(0, 0, 0, 2),
        ClipsDescendants = true
    })
    
    local list_inline = self:create("Frame", {
        Parent = list_frame,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local list_bg = self:create("Frame", {
        Parent = list_inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(15, 15, 15)
    })
    
    local list_scroll = self:create("ScrollingFrame", {
        Parent = list_bg,
        ScrollBarImageColor3 = rgb(65, 65, 65),
        ScrollBarThickness = 4,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BackgroundColor3 = rgb(255, 255, 255),
        ZIndex = 5,
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true
    })
    
    local items_container = self:create("Frame", {
        Parent = list_scroll,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    self:create("UIListLayout", {
        Parent = items_container,
        Padding = dim(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = items_container,
        PaddingTop = dim(0, 2),
        PaddingBottom = dim(0, 2),
        PaddingLeft = dim(0, 2),
        PaddingRight = dim(0, 2)
    })

    if cfg.name then 
        local left_components = self:create("Frame", {
            Parent = list_container,
            BackgroundTransparency = 1,
            Position = dim2(0, 16, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local name_text = self:create("TextLabel", {
            Parent = left_components,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = cfg.name,
            BackgroundTransparency = 1,
            Size = dim2(0, 0, 1, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        self:create("UIListLayout", {
            Parent = left_components,
            Padding = dim(0, 5),
            FillDirection = Enum.FillDirection.Horizontal
        })
        
        self:create("UIPadding", {
            Parent = left_components,
            PaddingBottom = dim(0, 6)
        })
    end 

    self:create("UIPadding", {
        Parent = list_container,
        PaddingLeft = dim(0, 1)
    })

    self:create("UIListLayout", {
        Parent = bottom_components,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = dim(0, 3),
        FillDirection = Enum.FillDirection.Vertical
    })

    cfg.option_instances = {}

    function cfg.createItem(text_value)
        local item = self:create("TextButton", {
            Parent = items_container,
            FontFace = library.font,
            TextColor3 = rgb(160, 160, 160),
            BorderColor3 = rgb(0, 0, 0),
            Text = text_value,
            Size = dim2(1, 0, 0, 16),
            BackgroundColor3 = rgb(20, 20, 20),
            BorderSizePixel = 0,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        
        self:create("UIPadding", {
            Parent = item,
            PaddingLeft = dim(0, 5)
        })
        
        insert(cfg.option_instances, item)
        
        return item
    end
    
    function cfg.set(value)
        local selected = {}
        local isTable = type(value) == "table"
        
        for _, item in next, cfg.option_instances do
            if item.Text == value or (isTable and find(value, item.Text)) then
                insert(selected, item.Text)
                item.BackgroundColor3 = themes.preset.accent
                item.TextColor3 = rgb(255, 255, 255)
            else
                item.BackgroundColor3 = rgb(20, 20, 20)
                item.TextColor3 = rgb(160, 160, 160)
            end
        end
        
        cfg.selected_items = selected
        
        if isTable then
            flags[cfg.flag] = selected
        else
            flags[cfg.flag] = #selected > 0 and selected[1] or ""
        end
        
        cfg.callback(flags[cfg.flag])
    end
    
    function cfg.refreshItems(new_items)
        for _, item in next, cfg.option_instances do
            item:Destroy()
        end
        
        cfg.option_instances = {}
        cfg.items = new_items
        
        for _, item_text in next, new_items do
            local item_instance = cfg.createItem(item_text)
            
            item_instance.MouseButton1Click:Connect(function()
                if cfg.multi then
                    local selected_index = find(cfg.selected_items, item_text)
                    
                    if selected_index then
                        remove(cfg.selected_items, selected_index)
                    else
                        insert(cfg.selected_items, item_text)
                    end
                    
                    cfg.set(cfg.selected_items)
                else
                    cfg.set(item_text)
                end
            end)
        end
    end
    
    cfg.refreshItems(cfg.items)
    
    if cfg.multi then
        if type(cfg.default) == "table" and #cfg.default > 0 then
            cfg.set(cfg.default)
        end
    else
        if cfg.default and find(cfg.items, cfg.default) then
            cfg.set(cfg.default)
        elseif #cfg.items > 0 then
            cfg.set(cfg.items[1])
        end
    end

    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end

--[[
function library:addDropdown(options) 
    local cfg = {
        name = options.name or nil,
        flag = options.flag or tostring(random(1,9999999)),

        items = options.items or {"1", "2", "3"},
        callback = options.callback or function() end,
        multi = options.multi or false, 
        scrolling = options.scrolling or false, 

        open = false, 
        option_instances = {}, 
        multi_items = {}, 
        ignore = options.ignore or false, 
    }   

    cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1]

    flags[cfg.flag] = {} 

    local dropdown_path = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    cfg["right_components"] = self:create("Frame", {
        Parent = dropdown_path,
        Position = dim2(1, 0, 0, -1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = cfg["right_components"],
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local bottom_components = self:create("Frame", {
        Parent = dropdown_path,
        Position = dim2(0, 15, 0, cfg.name and 11 or 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, self.background and 2 or -6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local dropdown = self:create("TextButton", {
        Parent = bottom_components,
        AutoButtonColor = false, 
        Text = "",
        Position = dim2(0, 0, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -27, 1, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(1, 1, 1)
    })
    
    local inline = self:create("Frame", {
        Parent = dropdown,
        Position = dim2(0, 0, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -1, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(25, 25, 25)
    })
    
    local arrow = self:create("ImageLabel", {
        Parent = background,
        Image = "rbxassetid://116204929609664",
        Position = dim2(1, -13, 0, 7),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 5, 0, 3),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })  

    local text = self:create("TextLabel", {
        Parent = background,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "players",
        Size = dim2(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, 7, 0, -1),
        BorderSizePixel = 0,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, 
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundColor3 = rgb(255, 255, 255)
    })                    
    
    if cfg.name then 
        local left_components = self:create("Frame", {
            Parent = dropdown_path,
            BackgroundTransparency = 1,
            Position = dim2(0, 16, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        local text = self:create("TextLabel", {
            Parent = left_components,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = cfg.name,
            BackgroundTransparency = 1,
            Size = dim2(0, 0, 1, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })
        
        self:create("UIListLayout", {
            Parent = left_components,
            Padding = dim(0, 5),
            FillDirection = Enum.FillDirection.Horizontal
        })
        
        self:create("UIPadding", {
            Parent = left_components,
            PaddingBottom = dim(0, 6)
        })
    end 

    local UIPadding = self:create("UIPadding", {
        Parent = dropdown,
        PaddingLeft = dim(0, 1)
    })

    local dropdown_holder = self:create("Frame", {
        Parent = library.gui,
        Size = dim2(0, 161, 0, 0),
        Position = dim2(0, 100, 0, 200),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = rgb(1, 1, 1),
        Visible = false, 
        ZIndex = 999
    })
    
    local inline = self:create("Frame", {
        Parent = dropdown_holder,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local text_holder = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(25, 25, 25)
    })
    
    self:create("UIPadding", {
        Parent = text_holder,
        PaddingTop = dim(0, 2),
        PaddingBottom = dim(0, 7),
        PaddingLeft = dim(0, 7)
    })
    
    self:create("UIListLayout", {
        Parent = text_holder,
        Padding = dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function cfg.renderOption(text) 
        local OPTION = self:create("TextButton", {
            Parent = text_holder,
            FontFace = library.font,
            TextColor3 = rgb(180, 180, 180),
            BorderColor3 = rgb(0, 0, 0),
            Text = text,
            Size = dim2(0, 0, 0, -1),
            BackgroundTransparency = 1,
            Position = dim2(0, 6, 0, -1),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        }); self:applyTheme(OPTION, "accent", "TextColor3")

        return OPTION
    end 
    
    function cfg.setVisible(bool) 
        dropdown_holder.Visible = bool
        arrow.Rotation = bool and 180 or 0 

        if bool then 
            self:closeCurrentElement(cfg)
            library.current_element_open = cfg 
        end
    end
    
    function cfg.set(value) 
        local selected = {}
        local isTable = type(value) == "table"

        for _, option in next, cfg.option_instances do 
            if option.Text == value or (isTable and find(value, option.Text)) then 
                insert(selected, option.Text)
                cfg.multi_items = selected
                option.TextColor3 = themes.preset.accent
            else 
                option.TextColor3 = rgb(160, 160, 160)
            end
        end

        text.Text = isTable and concat(selected, ", ") or selected[1]
        flags[cfg.flag] = isTable and selected or selected[1]
            
        cfg.callback(flags[cfg.flag]) 
    end
    
    function cfg.refreshOptions(list) 
        for _, option in next, cfg.option_instances do 
            option:Destroy() 
        end
        
        cfg.option_instances = {} 

        for _, option in next, list do 
            local OPTION_INSTANCE = cfg.renderOption(option)
            insert(cfg.option_instances, OPTION_INSTANCE)
            
            local function onOptionClick()
                if cfg.multi then 
                    local selected_index = find(cfg.multi_items, OPTION_INSTANCE.Text)

                    if selected_index then 
                        remove(cfg.multi_items, selected_index)
                    else
                        insert(cfg.multi_items, OPTION_INSTANCE.Text)
                    end

                    cfg.set(cfg.multi_items) 				
                else 
                    cfg.setVisible(false)
                    cfg.open = false 
                    
                    cfg.set(OPTION_INSTANCE.Text)
                end
            end
            
            OPTION_INSTANCE.MouseButton1Click:Connect(onOptionClick)
            
            if isTouch() then
                OPTION_INSTANCE.TouchTap:Connect(onOptionClick)
            end
        end
    end

    cfg.refreshOptions(cfg.items)
    cfg.set(cfg.default)

    local function onDropdownClick()
        cfg.open = not cfg.open 
        cfg.setVisible(cfg.open)
    end

    dropdown.MouseButton1Click:Connect(onDropdownClick)
    
    if isTouch() then
        dropdown.TouchTap:Connect(onDropdownClick)
    end

    dropdown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, dropdown_holder.Size.Y.Offset)
    end)

    dropdown:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        dropdown_holder.Position = dim2(0, dropdown.AbsolutePosition.X, 0, dropdown.AbsolutePosition.Y + 80)
    end)

    return setmetatable(cfg, library)
end
--]]
function library:addButton(options)
    local cfg = {
        callback = options.callback or function() end, 
        name = options.text or options.name or "Button",
    }

    local button_holder = self:create("TextLabel", {
        Parent = self.background or self.elements,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = "",
        ZIndex = 2,
        Size = dim2(1, -8, 0, 12),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextSize = 11,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local bottom_components = self:create("Frame", {
        Parent = button_holder, 
        Position = dim2(0, 14, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local button = self:create("Frame", {
        Parent = bottom_components,
        Position = dim2(0, -1, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -27, 1, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(1, 1, 1)
    })
    
    local inline = self:create("Frame", {
        Parent = button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(45, 45, 45)
    })
    
    local background = self:create("Frame", {
        Parent = inline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(19, 19, 19)
    })
    
    local button = self:create("TextButton", {
        Parent = background,
        FontFace = library.font,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextSize = 12,
        Size = dim2(1, -6, 1, 0),
        RichText = true,
        TextColor3 = rgb(178, 178, 178),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = dim2(0, 6, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })

    local function onButtonClick()
        cfg.callback() 
    end

    button.MouseButton1Click:Connect(onButtonClick)
    
    if isTouch() then
        button.TouchTap:Connect(onButtonClick)
    end
    
    self:create("UIListLayout", {
        Parent = bottom_components,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self:create("UIPadding", {
        Parent = button_holder,
        PaddingLeft = dim(0, 1)
    })
    
    local left_components = self:create("Frame", {
        Parent = button_holder,
        BackgroundTransparency = 1,
        Position = dim2(0, 16, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    local text = self:create("TextLabel", {
        Parent = left_components,
        FontFace = library.font,
        TextColor3 = rgb(180, 180, 180),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        BackgroundTransparency = 1,
        Size = dim2(0, 0, 1, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255)
    })
    
    self:create("UIListLayout", {
        Parent = left_components,
        Padding = dim(0, 5),
        FillDirection = Enum.FillDirection.Horizontal
    })
    
    self:create("UIPadding", {
        Parent = left_components,
        PaddingBottom = dim(0, 6)
    })
end

return library
