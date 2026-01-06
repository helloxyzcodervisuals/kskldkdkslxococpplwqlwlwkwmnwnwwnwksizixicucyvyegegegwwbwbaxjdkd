local settings = {
    folder_name = "zephyrus";
    default_accent = Color3.fromRGB(255, 182, 193)
};

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZephyrusUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

library = {}
library.directory = settings.folder_name
library.fonts = library.fonts or {}
library.folders = {"/fonts", "/configs", "/assets"}
library.flags = {}
library.config_flags = {}

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

local flags = library.flags 
local config_flags = library.config_flags

if not isfile(library.directory .. "/fonts/main.ttf") then 
    writefile(library.directory .. "/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
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
    writefile(library.directory .. "/fonts/main_encoded.ttf", HttpService:JSONEncode(tahoma))
end 

library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)

local function tween(object, tweenInfo, properties)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local utility = {}

function utility.createShadowGradient(parent)
    local shadow = Instance.new("UIGradient")
    shadow.Parent = parent
    shadow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    shadow.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0.9)
    }
    shadow.Rotation = 90
    return shadow
end

function utility.createDepthGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = parent
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.3)
    }
    gradient.Rotation = 90
    return gradient
end

function utility.create(class, properties)
    local obj = Instance.new(class)
    
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            obj.Parent = value
        else
            if pcall(function() return obj[prop] end) then
                obj[prop] = value
            end
        end
    end
    
    return obj
end

function utility.outline(parent, color, thickness)
    local outline = Instance.new("UIStroke")
    outline.Parent = parent
    outline.Color = color
    outline.Thickness = thickness or 1
    outline.Transparency = 0
    return outline
end

function utility.getcenter(sizeX, sizeY)
    return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end

function utility.textlength(str, fontSize)
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = str
    textLabel.FontFace = library.font
    textLabel.TextSize = fontSize or 13
    textLabel.Size = UDim2.new(0, 1000, 0, 100)
    
    local textBounds = textLabel.TextBounds
    textLabel:Destroy()
    
    return textBounds
end

function utility.dragify(frame)
    local dragging = false
    local startPos, framePos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            framePos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
            startPos = input.Position
            framePos = frame.Position
        end
    end)
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
    }
}

library.theme = table.clone(themes.Default)
library.open = true
library.connections = {}

function library:CreateWindow(cfg)
    local window = {}
    local pages = {}
    local pageButtons = {}
    local pageAccents = {}
    
    local windowSize = cfg.size or Vector2.new(600, 450)
    local sizeX = windowSize.X
    local sizeY = windowSize.Y
    
    local mainFrame = utility.create("Frame", {
        Name = "MainWindow",
        BackgroundColor3 = library.theme["Window Outline Background"],
        BorderSizePixel = 0,
        Position = utility.getcenter(sizeX, sizeY),
        Size = UDim2.new(0, sizeX, 0, sizeY),
        Parent = screenGui
    })
    
    local mainFrameShadow = utility.create("Frame", {
        Name = "Shadow",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 4, 0, 4),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = mainFrame
    })
    utility.createShadowGradient(mainFrameShadow)
    
    utility.outline(mainFrame, library.theme["Window Border"], 1)
    utility.createDepthGradient(mainFrame)
    
    local inlineFrame = utility.create("Frame", {
        Name = "Inline",
        BackgroundColor3 = library.theme["Window Inline Background"],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        Parent = mainFrame
    })
    utility.createDepthGradient(inlineFrame)
    
    local accentBar = utility.create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = library.theme["Accent"],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 0, 2),
        Parent = inlineFrame
    })
    utility.createDepthGradient(accentBar)
    
    local holderFrame = utility.create("Frame", {
        Name = "Holder",
        BackgroundColor3 = library.theme["Window Holder Background"],
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 1, -30),
        Parent = inlineFrame
    })
    utility.createDepthGradient(holderFrame)
    utility.outline(holderFrame, library.theme["Window Border"], 1)
    
    local holderShadow = utility.create("Frame", {
        Name = "HolderShadow",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(1, 0, 1, 0),
        Parent = holderFrame
    })
    utility.createShadowGradient(holderShadow)
    
    local pagesHolder = utility.create("Frame", {
        Name = "PagesHolder",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 35),
        Parent = holderFrame
    })
    
    local dragFrame = utility.create("Frame", {
        Name = "Drag",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 10),
        Parent = mainFrame
    })
    
    utility.dragify(mainFrame)
    
    function window:NewPage(cfg)
        local page = {}
        local pageName = cfg.name or "New Page"
        local sections = {}
        
        local pageButton = utility.create("TextButton", {
            Name = pageName .. "Button",
            BackgroundColor3 = library.theme["Page Unselected"],
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 100, 1, 0),
            Text = "",
            Parent = pagesHolder
        })
        utility.createDepthGradient(pageButton)
        
        local pageButtonShadow = utility.create("Frame", {
            Name = "ButtonShadow",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, 0, 1, 0),
            Parent = pageButton
        })
        utility.createShadowGradient(pageButtonShadow)
        
        local pageButtonText = utility.create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            FontFace = library.font,
            Text = pageName,
            TextColor3 = library.theme["Text"],
            TextSize = 13,
            TextTransparency = 0,
            Parent = pageButton
        })
        
        local pageAccent = utility.create("Frame", {
            Name = "Accent",
            BackgroundColor3 = library.theme["Accent"],
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            Visible = false,
            Parent = pageButton
        })
        utility.createDepthGradient(pageAccent)
        
        local pageFrame = utility.create("Frame", {
            Name = pageName .. "Page",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 35, 0),
            Size = UDim2.new(1, 0, 1, -35),
            Visible = false,
            Parent = holderFrame
        })
        
        local leftColumn = utility.create("Frame", {
            Name = "Left",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.5, -15, 1, 0),
            Parent = pageFrame
        })
        
        local rightColumn = utility.create("Frame", {
            Name = "Right",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 5, 0, 0),
            Size = UDim2.new(0.5, -15, 1, 0),
            Parent = pageFrame
        })
        
        local leftScrollingFrame = utility.create("ScrollingFrame", {
            Name = "LeftScrolling",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = library.theme["Accent"],
            Parent = leftColumn
        })
        
        local rightScrollingFrame = utility.create("ScrollingFrame", {
            Name = "RightScrolling",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = library.theme["Accent"],
            Parent = rightColumn
        })
        
        local leftListLayout = Instance.new("UIListLayout")
        leftListLayout.Parent = leftScrollingFrame
        leftListLayout.Padding = UDim.new(0, 10)
        leftListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local rightListLayout = Instance.new("UIListLayout")
        rightListLayout.Parent = rightScrollingFrame
        rightListLayout.Padding = UDim.new(0, 10)
        rightListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        leftListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            leftScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, leftListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        rightListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            rightScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, rightListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local function updatePageButtons()
            local buttonCount = #pages + 1
            for i, btn in ipairs(pageButtons) do
                btn.Size = UDim2.new(1/buttonCount, 0, 1, 0)
                btn.Position = UDim2.new((i-1)/buttonCount, 0, 0, 0)
            end
        end
        
        table.insert(pages, pageFrame)
        table.insert(pageButtons, pageButton)
        table.insert(pageAccents, pageAccent)
        
        pageButton.MouseButton1Click:Connect(function()
            for i, v in ipairs(pageButtons) do
                v.BackgroundColor3 = library.theme["Page Unselected"]
                v:FindFirstChild("Accent").Visible = false
            end
            
            for i, v in ipairs(pageAccents) do
                v.Visible = false
            end
            
            for i, v in ipairs(pages) do
                v.Visible = false
            end
            
            pageButton.BackgroundColor3 = library.theme["Page Selected"]
            pageAccent.Visible = true
            pageFrame.Visible = true
        end)
        
        updatePageButtons()
        
        function page:NewSection(cfg)
            local section = {}
            local sectionName = cfg.name or "New Section"
            local sectionSide = (cfg.side == "left" and leftScrollingFrame) or (cfg.side == "right" and rightScrollingFrame) or leftScrollingFrame
            local sectionSize = cfg.size or 200
            
            local sectionFrame = utility.create("Frame", {
                Name = sectionName .. "Section",
                BackgroundColor3 = library.theme["Section Background"],
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, sectionSize),
                LayoutOrder = #sectionSide:GetChildren(),
                Parent = sectionSide
            })
            utility.createDepthGradient(sectionFrame)
            
            local sectionShadow = utility.create("Frame", {
                Name = "SectionShadow",
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(1, 0, 1, 0),
                Parent = sectionFrame
            })
            utility.createShadowGradient(sectionShadow)
            
            local innerBorder = utility.outline(sectionFrame, library.theme["Section Inner Border"], 1)
            local outerBorder = utility.create("Frame", {
                Name = "OuterBorder",
                BackgroundColor3 = library.theme["Section Outer Border"],
                BorderSizePixel = 0,
                Position = UDim2.new(0, -1, 0, -1),
                Size = UDim2.new(1, 2, 1, 2),
                Parent = sectionFrame
            })
            
            local titleCover = utility.create("Frame", {
                Name = "TitleCover",
                BackgroundColor3 = library.theme["Window Holder Background"],
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, -4),
                Size = UDim2.new(0, utility.textlength(sectionName, 13).X + 2, 0, 4),
                Parent = sectionFrame
            })
            utility.createDepthGradient(titleCover)
            
            local titleCoverShadow = utility.create("Frame", {
                Name = "TitleCoverShadow",
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 1, 0, 1),
                Size = UDim2.new(1, 0, 1, 0),
                Parent = titleCover
            })
            utility.createShadowGradient(titleCoverShadow)
            
            local sectionTitle = utility.create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, -8),
                Size = UDim2.new(0, 200, 0, 20),
                FontFace = library.font,
                Text = sectionName,
                TextColor3 = library.theme["Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })
            
            local sectionTitleShadow = utility.create("TextLabel", {
                Name = "TitleShadow",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 11, 0, -7),
                Size = UDim2.new(0, 200, 0, 20),
                FontFace = library.font,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(0, 0, 0),
                TextSize = 13,
                TextTransparency = 0.7,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionFrame
            })
            
            local contentFrame = utility.create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 15),
                Size = UDim2.new(1, -16, 1, -10),
                Parent = sectionFrame
            })
            
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.Parent = contentFrame
            uiListLayout.Padding = UDim.new(0, 8)
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            
            local function updateSectionSize()
                local totalHeight = uiListLayout.AbsoluteContentSize.Y + 25
                if totalHeight > sectionSize then
                    sectionFrame.Size = UDim2.new(1, 0, 0, totalHeight)
                else
                    sectionFrame.Size = UDim2.new(1, 0, 0, sectionSize)
                end
            end
            
            uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSize)
            
            function section:NewToggle(cfg)
                local toggle = {}
                local toggleName = cfg.name or "New Toggle"
                local toggleState = cfg.state or false
                local toggleFlag = cfg.flag or ""
                local callback = cfg.callback or function() end
                
                local toggleHolder = utility.create("Frame", {
                    Name = toggleName .. "Toggle",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local toggleButton = utility.create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 10, 0, 10),
                    Text = "",
                    Parent = toggleHolder
                })
                utility.createDepthGradient(toggleButton)
                
                local toggleButtonShadow = utility.create("Frame", {
                    Name = "ButtonShadow",
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = toggleButton
                })
                utility.createShadowGradient(toggleButtonShadow)
                
                utility.outline(toggleButton, library.theme["Section Inner Border"], 1)
                
                local toggleIndicator = utility.create("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = toggleState and library.theme["Accent"] or library.theme["Object Background"],
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 5, 0, 5),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = toggleButton
                })
                utility.createDepthGradient(toggleIndicator)
                
                local toggleLabel = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -15, 1, 0),
                    FontFace = library.font,
                    Text = toggleName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleHolder
                })
                
                local toggleLabelShadow = utility.create("TextLabel", {
                    Name = "LabelShadow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 16, 0, 1),
                    Size = UDim2.new(1, -15, 1, 0),
                    FontFace = library.font,
                    Text = toggleName,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 13,
                    TextTransparency = 0.7,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleHolder
                })
                
                local function setState(state)
                    toggleState = state
                    toggleIndicator.BackgroundColor3 = state and library.theme["Accent"] or library.theme["Object Background"]
                    
                    if toggleFlag ~= "" then
                        library.flags[toggleFlag] = state
                    end
                    
                    callback(state)
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    setState(not toggleState)
                end)
                
                setState(toggleState)
                
                function toggle:Set(state)
                    setState(state)
                end
                
                return toggle
            end
            
            function section:NewSlider(cfg)
                local slider = {}
                local sliderName = cfg.name or "New Slider"
                local min = cfg.min or 0
                local max = cfg.max or 100
                local default = cfg.default or min
                local flag = cfg.flag or ""
                local callback = cfg.callback or function() end
                
                local sliderHolder = utility.create("Frame", {
                    Name = sliderName .. "Slider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local sliderLabel = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    FontFace = library.font,
                    Text = sliderName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderHolder
                })
                
                local sliderLabelShadow = utility.create("TextLabel", {
                    Name = "LabelShadow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, 0, 0, 20),
                    FontFace = library.font,
                    Text = sliderName,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 13,
                    TextTransparency = 0.7,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderHolder
                })
                
                local sliderBackground = utility.create("Frame", {
                    Name = "Background",
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 5),
                    Parent = sliderHolder
                })
                utility.createDepthGradient(sliderBackground)
                
                local sliderBackgroundShadow = utility.create("Frame", {
                    Name = "BackgroundShadow",
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = sliderBackground
                })
                utility.createShadowGradient(sliderBackgroundShadow)
                
                utility.outline(sliderBackground, library.theme["Section Inner Border"], 1)
                
                local sliderFill = utility.create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = library.theme["Accent"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = sliderBackground
                })
                utility.createDepthGradient(sliderFill)
                
                local sliderValue = utility.create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, -15),
                    Size = UDim2.new(1, 0, 0, 20),
                    FontFace = library.font,
                    Text = tostring(default),
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    Parent = sliderHolder
                })
                
                local sliderValueShadow = utility.create("TextLabel", {
                    Name = "ValueShadow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 1, 0, -14),
                    Size = UDim2.new(1, 0, 0, 20),
                    FontFace = library.font,
                    Text = tostring(default),
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 13,
                    TextTransparency = 0.7,
                    Parent = sliderHolder
                })
                
                local dragging = false
                
                local function setValue(value)
                    value = math.clamp(value, min, max)
                    local percentage = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderValue.Text = tostring(math.floor(value))
                    sliderValueShadow.Text = tostring(math.floor(value))
                    
                    if flag ~= "" then
                        library.flags[flag] = value
                    end
                    
                    callback(value)
                end
                
                sliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local mouse = UserInputService:GetMouseLocation()
                        if input.UserInputType == Enum.UserInputType.Touch then
                            mouse = input.Position
                        end
                        local relativeX = (mouse.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
                        setValue(min + (max - min) * math.clamp(relativeX, 0, 1))
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local mouse = input.Position
                        local relativeX = (mouse.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
                        setValue(min + (max - min) * math.clamp(relativeX, 0, 1))
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                setValue(default)
                
                function slider:Set(value)
                    setValue(value)
                end
                
                return slider
            end
            
            function section:NewButton(cfg)
                local button = {}
                local buttonName = cfg.name or "New Button"
                local callback = cfg.callback or function() end
                
                local buttonHolder = utility.create("Frame", {
                    Name = buttonName .. "Button",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local buttonFrame = utility.create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    FontFace = library.font,
                    Text = buttonName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    Parent = buttonHolder
                })
                utility.createDepthGradient(buttonFrame)
                
                local buttonFrameShadow = utility.create("Frame", {
                    Name = "ButtonShadow",
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    Parent = buttonFrame
                })
                utility.createShadowGradient(buttonFrameShadow)
                
                utility.outline(buttonFrame, library.theme["Section Inner Border"], 1)
                
                local buttonTextShadow = utility.create("TextLabel", {
                    Name = "TextShadow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 1, 0.5, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    FontFace = library.font,
                    Text = buttonName,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 13,
                    TextTransparency = 0.7,
                    Parent = buttonFrame
                })
                
                buttonFrame.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                buttonFrame.MouseButton1Down:Connect(function()
                    buttonFrame.BackgroundColor3 = library.theme["Accent"]
                end)
                
                buttonFrame.MouseButton1Up:Connect(function()
                    buttonFrame.BackgroundColor3 = library.theme["Object Background"]
                end)
                
                return button
            end
            
            function section:NewLabel(cfg)
                local label = {}
                local labelText = cfg.text or "New Label"
                
                local labelHolder = utility.create("Frame", {
                    Name = "LabelHolder",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local labelFrame = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    FontFace = library.font,
                    Text = labelText,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = labelHolder
                })
                
                local labelFrameShadow = utility.create("TextLabel", {
                    Name = "LabelShadow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    FontFace = library.font,
                    Text = labelText,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    TextSize = 13,
                    TextTransparency = 0.7,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = labelHolder
                })
                
                return label
            end
            
            function section:NewColorpicker(cfg)
                local colorpicker = {}
                local colorpickerName = cfg.name or "Colorpicker"
                local default = cfg.default or Color3.fromRGB(255, 255, 255)
                local flag = cfg.flag or ""
                local callback = cfg.callback or function() end
                
                local colorpickerHolder = utility.create("Frame", {
                    Name = colorpickerName .. "Colorpicker",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local colorpickerLabel = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    FontFace = library.font,
                    Text = colorpickerName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = colorpickerHolder
                })
                
                local colorpickerButton = utility.create("TextButton", {
                    Name = "ColorButton",
                    BackgroundColor3 = default,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.7, 0, 0, 5),
                    Size = UDim2.new(0.3, -5, 0, 10),
                    Text = "",
                    Parent = colorpickerHolder
                })
                utility.createDepthGradient(colorpickerButton)
                utility.outline(colorpickerButton, library.theme["Section Inner Border"], 1)
                
                local function setColor(color)
                    colorpickerButton.BackgroundColor3 = color
                    if flag ~= "" then
                        library.flags[flag] = color
                    end
                    callback(color)
                end
                
                setColor(default)
                
                colorpickerButton.MouseButton1Click:Connect(function()
                    local colorpickerWindow = utility.create("Frame", {
                        Name = "ColorpickerWindow",
                        BackgroundColor3 = library.theme["Object Background"],
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, colorpickerButton.AbsolutePosition.X + 20, 0, colorpickerButton.AbsolutePosition.Y + 20),
                        Size = UDim2.new(0, 150, 0, 100),
                        Parent = screenGui
                    })
                    utility.createDepthGradient(colorpickerWindow)
                    utility.outline(colorpickerWindow, library.theme["Section Inner Border"], 1)
                    
                    local closePicker = function()
                        colorpickerWindow:Destroy()
                    end
                    
                    colorpickerWindow.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local color = Color3.fromHSV(math.random(), math.random(), math.random())
                            setColor(color)
                        end
                    end)
                    
                    task.wait(3)
                    closePicker()
                end)
                
                function colorpicker:Set(color)
                    setColor(color)
                end
                
                return colorpicker
            end
            
            function section:NewTextbox(cfg)
                local textbox = {}
                local textboxName = cfg.name or "Textbox"
                local placeholder = cfg.placeholder or "Enter text..."
                local default = cfg.default or ""
                local flag = cfg.flag or ""
                local callback = cfg.callback or function() end
                
                local textboxHolder = utility.create("Frame", {
                    Name = textboxName .. "Textbox",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local textboxLabel = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    FontFace = library.font,
                    Text = textboxName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = textboxHolder
                })
                
                local textboxFrame = utility.create("TextBox", {
                    Name = "TextBox",
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.4, 5, 0, 5),
                    Size = UDim2.new(0.6, -5, 0, 15),
                    FontFace = library.font,
                    Text = default,
                    PlaceholderText = placeholder,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    Parent = textboxHolder
                })
                utility.createDepthGradient(textboxFrame)
                utility.outline(textboxFrame, library.theme["Section Inner Border"], 1)
                
                local function setText(text)
                    textboxFrame.Text = text
                    if flag ~= "" then
                        library.flags[flag] = text
                    end
                    callback(text)
                end
                
                setText(default)
                
                textboxFrame.FocusLost:Connect(function()
                    setText(textboxFrame.Text)
                end)
                
                function textbox:Set(text)
                    setText(text)
                end
                
                return textbox
            end
            
            function section:NewList(cfg)
                local list = {}
                local listName = cfg.name or "List"
                local options = cfg.options or {}
                local default = cfg.default or (cfg.multi and {} or nil)
                local multi = cfg.multi or false
                local flag = cfg.flag or ""
                local callback = cfg.callback or function() end
                
                local listHolder = utility.create("Frame", {
                    Name = listName .. "List",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 100),
                    LayoutOrder = #contentFrame:GetChildren(),
                    Parent = contentFrame
                })
                
                local listLabel = utility.create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    FontFace = library.font,
                    Text = listName,
                    TextColor3 = library.theme["Text"],
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = listHolder
                })
                
                local listFrame = utility.create("Frame", {
                    Name = "ListFrame",
                    BackgroundColor3 = library.theme["Object Background"],
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 75),
                    Parent = listHolder
                })
                utility.createDepthGradient(listFrame)
                utility.outline(listFrame, library.theme["Section Inner Border"], 1)
                
                local scrollingFrame = utility.create("ScrollingFrame", {
                    Name = "ListScrolling",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 5, 0, 5),
                    Size = UDim2.new(1, -10, 1, -10),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = library.theme["Accent"],
                    Parent = listFrame
                })
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = scrollingFrame
                listLayout.Padding = UDim.new(0, 2)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local selectedOptions = multi and {} or nil
                
                local function createOption(optionName)
                    local optionHolder = utility.create("Frame", {
                        Name = optionName .. "Option",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        Parent = scrollingFrame
                    })
                    
                    local optionButton = utility.create("TextButton", {
                        Name = "Button",
                        BackgroundColor3 = library.theme["Object Background"],
                        BorderSizePixel = 0,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(1, 0, 1, 0),
                        FontFace = library.font,
                        Text = optionName,
                        TextColor3 = library.theme["Text"],
                        TextSize = 13,
                        Parent = optionHolder
                    })
                    utility.createDepthGradient(optionButton)
                    utility.outline(optionButton, library.theme["Section Inner Border"], 1)
                    
                    local function setSelected(selected)
                        if multi then
                            if selected then
                                table.insert(selectedOptions, optionName)
                                optionButton.BackgroundColor3 = library.theme["Accent"]
                            else
                                local index = table.find(selectedOptions, optionName)
                                if index then
                                    table.remove(selectedOptions, index)
                                    optionButton.BackgroundColor3 = library.theme["Object Background"]
                                end
                            end
                        else
                            for _, child in ipairs(scrollingFrame:GetChildren()) do
                                if child:IsA("Frame") and child ~= optionHolder then
                                    child.Button.BackgroundColor3 = library.theme["Object Background"]
                                end
                            end
                            
                            if selected then
                                optionButton.BackgroundColor3 = library.theme["Accent"]
                                selectedOptions = optionName
                            else
                                selectedOptions = nil
                            end
                        end
                        
                        if flag ~= "" then
                            library.flags[flag] = selectedOptions
                        end
                        callback(selectedOptions)
                    end
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if multi then
                            local isSelected = table.find(selectedOptions, optionName)
                            setSelected(not isSelected)
                        else
                            local isSelected = selectedOptions == optionName
                            setSelected(not isSelected)
                        end
                    end)
                    
                    if multi and default and table.find(default, optionName) then
                        setSelected(true)
                    elseif not multi and default == optionName then
                        setSelected(true)
                    end
                end
                
                local function addOptions(optionsList)
                    for _, option in ipairs(optionsList) do
                        createOption(option)
                    end
                    
                    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
                    end)
                end
                
                addOptions(options)
                
                function list:AddOptions(newOptions)
                    for _, option in ipairs(newOptions) do
                        createOption(option)
                    end
                end
                
                function list:Set(value)
                    if multi then
                        selectedOptions = {}
                        for _, child in ipairs(scrollingFrame:GetChildren()) do
                            if child:IsA("Frame") then
                                local optionName = child.Name:gsub("Option", "")
                                if table.find(value, optionName) then
                                    child.Button.BackgroundColor3 = library.theme["Accent"]
                                    table.insert(selectedOptions, optionName)
                                else
                                    child.Button.BackgroundColor3 = library.theme["Object Background"]
                                end
                            end
                        end
                    else
                        for _, child in ipairs(scrollingFrame:GetChildren()) do
                            if child:IsA("Frame") then
                                local optionName = child.Name:gsub("Option", "")
                                if value == optionName then
                                    child.Button.BackgroundColor3 = library.theme["Accent"]
                                    selectedOptions = optionName
                                else
                                    child.Button.BackgroundColor3 = library.theme["Object Background"]
                                end
                            end
                        end
                    end
                    
                    if flag ~= "" then
                        library.flags[flag] = selectedOptions
                    end
                    callback(selectedOptions)
                end
                
                function list:Get()
                    return selectedOptions
                end
                
                return list
            end
            
            return section
        end
        
        if #pages == 1 then
            pageButton.BackgroundColor3 = library.theme["Page Selected"]
            pageAccent.Visible = true
            pageFrame.Visible = true
        end
        
        return page
    end
    
    function window:Toggle()
        library.open = not library.open
        mainFrame.Visible = library.open
    end
    
    mainFrame.Visible = library.open
    
    return window
end

return library