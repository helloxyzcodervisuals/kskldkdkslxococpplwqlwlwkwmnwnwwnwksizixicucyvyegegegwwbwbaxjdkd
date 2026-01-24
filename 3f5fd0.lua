repeat
    task.wait()
until game:IsLoaded()

do
    local function isAdonisAC(tab)
        return rawget(tab, "Detected")
            and typeof(rawget(tab, "Detected")) == "function"
            and rawget(tab, "RLocked")
    end

    for _, v in next, getgc(true) do
        if typeof(v) == "table" and isAdonisAC(v) then
            for i, f in next, v do
                if rawequal(i, "Detected") then
                    local old
                    old = hookfunction(f, function(action, info, crash)
                        if rawequal(action, "_") and rawequal(info, "_") and rawequal(crash, false) then
                            return old(action, info, crash)
                        end
                        return task.wait(9e9)
                    end)
                    warn("bypassed")
                    break
                end
            end
        end
    end
end

for _, v in pairs(getgc(true)) do
if type(v) == "table" then
local func = rawget(v, "DTXC1")
if type(func) == "function" then
hookfunction(func, function() return end)
break
end
end
end

getgenv().CONFIG = {
    Ragebot = {
        Enabled = false,
        RapidFire = false,
        FireRate = 30,
        Prediction = true,
        PredictionAmount = 0.12,
        TeamCheck = false,
        VisibilityCheck = true,
        FOV = 120,
        ShowFOV = true,
        Wallbang = true,
        Tracers = true,
        TracerColor = Color3.fromRGB(255, 0, 0),
        TracerWidth = 1,
        TracerLifetime = 3,
        ShootRange = 15,
        HitRange = 15,
        HitNotify = true,
        AutoReload = true,
        HitSound = true,
        HitColor = Color3.fromRGB(255, 182, 193),
        UseTargetList = false,
        UseWhitelist = false,
        HitNotifyDuration = 5,
        LowHealthCheck = false,
        SelectedHitSound = "skeet",
        FriendCheck = false,
        MaxTarget = 0
    },
    Misc = {
        SpeedEnabled = false,
        SpeedValue = 50,
        JumpPowerEnabled = false,
        JumpPowerValue = 100,
        LoopFOVEnabled = false,
        HideHeadEnabled = false,
        InfStaminaEnabled = false,
        NoFallDmgEnabled = false,
        SpeedConnection = nil,
        FOVConnection = nil,
        JumpPowerConnection = nil,
        NoFallHook = nil,
        InfStaminaHook = nil
    }
}

getgenv().Lists = {
    TargetList = {},
    Whitelist = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/deadCell.lua"))()
local window = library:new_window({
    size = Vector2.new(700, 550)
})

local ragebotPage = window:new_page({
    name = "Ragebot"
})

local ragebotMainSection = ragebotPage:new_section({
    name = "Ragebot Main",
    side = "left",
    size = 250
})

local ragebotToggle = ragebotMainSection:new_toggle({
    name = "Enable Ragebot",
    state = false,
    flag = "ragebot_enabled",
    callback = function(state)
        getgenv().CONFIG.Ragebot.Enabled = state
    end
})

local rapidFireToggle = ragebotMainSection:new_toggle({
    name = "Rapid Fire",
    state = false,
    flag = "ragebot_rapidfire",
    callback = function(state)
        getgenv().CONFIG.Ragebot.RapidFire = state
    end
})

local hitSoundToggle = ragebotMainSection:new_toggle({
    name = "Hit Sound",
    state = true,
    flag = "ragebot_hitsound",
    callback = function(state)
        getgenv().CONFIG.Ragebot.HitSound = state
    end
})

local autoReloadToggle = ragebotMainSection:new_toggle({
    name = "Auto Reload",
    state = true,
    flag = "ragebot_autoreload",
    callback = function(state)
        getgenv().CONFIG.Ragebot.AutoReload = state
    end
})

local fireRateSlider = ragebotMainSection:new_slider({
    name = "Fire Rate",
    min = 1,
    max = 1000,
    default = 30,
    text = "[value] RPS",
    flag = "ragebot_firerate",
    callback = function(value)
        getgenv().CONFIG.Ragebot.FireRate = value
    end
})

local shootRangeSlider = ragebotMainSection:new_slider({
    name = "Shoot Range",
    min = 1,
    max = 30,
    default = 15,
    text = "[value]",
    flag = "ragebot_shootrange",
    callback = function(value)
        getgenv().CONFIG.Ragebot.ShootRange = value
    end
})

local hitRangeSlider = ragebotMainSection:new_slider({
    name = "Hit Range",
    min = 1,
    max = 30,
    default = 15,
    text = "[value]",
    flag = "ragebot_hitrange",
    callback = function(value)
        getgenv().CONFIG.Ragebot.HitRange = value
    end
})

local hitSoundList = ragebotMainSection:new_listbox({
    name = "Hit Sound",
    options = {"skeet", "xp level", "bell"},
    default = "skeet",
    multiple = false,
    flag = "ragebot_hitsoundlist",
    callback = function(value)
        getgenv().CONFIG.Ragebot.SelectedHitSound = value
    end
})

local targetingSection = ragebotPage:new_section({
    name = "Targeting",
    side = "right",
    size = 250
})

local teamCheckToggle = targetingSection:new_toggle({
    name = "Team Check",
    state = false,
    flag = "ragebot_teamcheck",
    callback = function(state)
        getgenv().CONFIG.Ragebot.TeamCheck = state
    end
})

local visibilityCheckToggle = targetingSection:new_toggle({
    name = "Visibility Check",
    state = true,
    flag = "ragebot_visibilitycheck",
    callback = function(state)
        getgenv().CONFIG.Ragebot.VisibilityCheck = state
    end
})

local wallbangToggle = targetingSection:new_toggle({
    name = "Wallbang",
    state = true,
    flag = "ragebot_wallbang",
    callback = function(state)
        getgenv().CONFIG.Ragebot.Wallbang = state
    end
})

local fovSlider = targetingSection:new_slider({
    name = "FOV",
    min = 10,
    max = 360,
    default = 120,
    text = "[value]",
    flag = "ragebot_fov",
    callback = function(value)
        getgenv().CONFIG.Ragebot.FOV = value
    end
})

local showFovToggle = targetingSection:new_toggle({
    name = "Show FOV",
    state = true,
    flag = "ragebot_showfov",
    callback = function(state)
        getgenv().CONFIG.Ragebot.ShowFOV = state
    end
})

local downedCheckToggle = targetingSection:new_toggle({
    name = "Downed Check",
    state = false,
    flag = "ragebot_downcheck",
    callback = function(state)
        getgenv().CONFIG.Ragebot.LowHealthCheck = state
    end
})

local friendCheckToggle = targetingSection:new_toggle({
    name = "Friend Check",
    state = false,
    flag = "ragebot_friendcheck",
    callback = function(state)
        getgenv().CONFIG.Ragebot.FriendCheck = state
    end
})

local maxTargetSlider = targetingSection:new_slider({
    name = "Max Target",
    min = 0,
    max = 20,
    default = 1,
    text = "[value] players",
    flag = "ragebot_maxtarget",
    callback = function(value)
        getgenv().CONFIG.Ragebot.MaxTarget = value
    end
})

local aimSection = ragebotPage:new_section({
    name = "Aim Settings",
    side = "left",
    size = 200
})

local predictionToggle = aimSection:new_toggle({
    name = "Prediction",
    state = true,
    flag = "ragebot_prediction",
    callback = function(state)
        getgenv().CONFIG.Ragebot.Prediction = state
    end
})

local predictionAmountSlider = aimSection:new_slider({
    name = "Prediction Amount",
    min = 0.05,
    max = 0.3,
    default = 0.12,
    text = "[value]",
    flag = "ragebot_predictionamount",
    callback = function(value)
        getgenv().CONFIG.Ragebot.PredictionAmount = value
    end
})

local visualsSection = ragebotPage:new_section({
    name = "Tracers",
    side = "right",
    size = 200
})

local tracersToggle = visualsSection:new_toggle({
    name = "Tracers",
    state = true,
    flag = "ragebot_tracers",
    callback = function(state)
        getgenv().CONFIG.Ragebot.Tracers = state
    end
})

local tracerColor = tracersToggle:new_colorpicker({
    default = Color3.fromRGB(255, 0, 0),
    flag = "ragebot_tracercolor",
    callback = function(color)
        getgenv().CONFIG.Ragebot.TracerColor = color
    end
})

local tracerWidthSlider = visualsSection:new_slider({
    name = "Tracer Width",
    min = 0.1,
    max = 5,
    default = 1,
    text = "[value] width",
    flag = "ragebot_tracerwidth",
    callback = function(value)
        getgenv().CONFIG.Ragebot.TracerWidth = value
    end
})

local tracerLifeSlider = visualsSection:new_slider({
    name = "Tracer Lifetime",
    min = 0.5,
    max = 100,
    default = 3,
    text = "[value] time",
    flag = "ragebot_tracerlife",
    callback = function(value)
        getgenv().CONFIG.Ragebot.TracerLifetime = value
    end
})

local colorsSection = ragebotPage:new_section({
    name = "Notifications",
    side = "left",
    size = 200
})

local hitNotifyToggle = colorsSection:new_toggle({
    name = "Hit Notify",
    state = true,
    flag = "ragebot_hitnotify",
    callback = function(state)
        getgenv().CONFIG.Ragebot.HitNotify = state
    end
})

local hitColor = hitNotifyToggle:new_colorpicker({
    default = Color3.fromRGB(255, 182, 193),
    flag = "ragebot_hitcolor",
    callback = function(color)
        getgenv().CONFIG.Ragebot.HitColor = color
    end
})

local hitDurationSlider = colorsSection:new_slider({
    name = "Hit Notify Duration",
    min = 1,
    max = 10,
    default = 5,
    text = "[value]s",
    flag = "ragebot_hitduration",
    callback = function(value)
        getgenv().CONFIG.Ragebot.HitNotifyDuration = value
    end
})

local miscPage = window:new_page({
    name = "Miscellaneous"
})

local movementSection = miscPage:new_section({
    name = "Movement",
    side = "left",
    size = 250
})

local speedToggle = movementSection:new_toggle({
    name = "Speed",
    state = false,
    flag = "misc_speed",
    callback = function(state)
        getgenv().CONFIG.Misc.SpeedEnabled = state
        if state then
            if getgenv().CONFIG.Misc.SpeedConnection then
                getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
                getgenv().CONFIG.Misc.SpeedConnection = nil
            end
            getgenv().CONFIG.Misc.SpeedConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if not character then return end
                local humanoid = character:FindFirstChild("Humanoid")
                if not humanoid then return end
                humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
            end)
        else
            if getgenv().CONFIG.Misc.SpeedConnection then
                getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
                getgenv().CONFIG.Misc.SpeedConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then humanoid.WalkSpeed = 16 end
            end
        end
    end
})

local speedValueSlider = movementSection:new_slider({
    name = "Speed Value",
    min = 10,
    max = 200,
    default = 50,
    text = "[value]",
    flag = "misc_speedvalue",
    callback = function(value)
        getgenv().CONFIG.Misc.SpeedValue = value
    end
})

local jumpPowerToggle = movementSection:new_toggle({
    name = "Jump Power",
    state = false,
    flag = "misc_jumppower",
    callback = function(state)
        getgenv().CONFIG.Misc.JumpPowerEnabled = state
        if state then
            if getgenv().CONFIG.Misc.JumpPowerConnection then
                getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
                getgenv().CONFIG.Misc.JumpPowerConnection = nil
            end
            getgenv().CONFIG.Misc.JumpPowerConnection = RunService.Heartbeat:Connect(function()
                if not getgenv().CONFIG.Misc.JumpPowerEnabled then return end
                if not LocalPlayer.Character then return end
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then return end
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
                end
            end)
        else
            if getgenv().CONFIG.Misc.JumpPowerConnection then
                getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
                getgenv().CONFIG.Misc.JumpPowerConnection = nil
            end
        end
    end
})

local jumpPowerSlider = movementSection:new_slider({
    name = "Jump Power Value",
    min = 50,
    max = 300,
    default = 100,
    text = "[value]",
    flag = "misc_jumpvalue",
    callback = function(value)
        getgenv().CONFIG.Misc.JumpPowerValue = value
    end
})

local visualSection = miscPage:new_section({
    name = "Visual",
    side = "right",
    size = 250
})

local loopFovToggle = visualSection:new_toggle({
    name = "Loop FOV",
    state = false,
    flag = "misc_loopfov",
    callback = function(state)
        getgenv().CONFIG.Misc.LoopFOVEnabled = state
        if state then
            if getgenv().CONFIG.Misc.FOVConnection then
                getgenv().CONFIG.Misc.FOVConnection:Disconnect()
                getgenv().CONFIG.Misc.FOVConnection = nil
            end
            getgenv().CONFIG.Misc.FOVConnection = RunService.RenderStepped:Connect(function()
                workspace.CurrentCamera.FieldOfView = 120
            end)
        else
            if getgenv().CONFIG.Misc.FOVConnection then
                getgenv().CONFIG.Misc.FOVConnection:Disconnect()
                getgenv().CONFIG.Misc.FOVConnection = nil
            end
        end
    end
})

local hideHeadToggle = visualSection:new_toggle({
    name = "Hide Head",
    state = false,
    flag = "misc_hidehead",
    callback = function(state)
        getgenv().CONFIG.Misc.HideHeadEnabled = state
        if state then
            hideHead()
        else
            showHead()
        end
    end
})

local otherSection = miscPage:new_section({
    name = "Other",
    side = "left",
    size = 200
})

local infStaminaToggle = otherSection:new_toggle({
    name = "Inf Stamina",
    state = false,
    flag = "misc_infstamina",
    callback = function(state)
        getgenv().CONFIG.Misc.InfStaminaEnabled = state
        if state then
            enableInfStamina()
        else
            disableInfStamina()
        end
    end
})

local noFallToggle = otherSection:new_toggle({
    name = "No Fall Damage",
    state = false,
    flag = "misc_nofall",
    callback = function(state)
        getgenv().CONFIG.Misc.NoFallDmgEnabled = state
        if state then
            enableNoFallDmg()
        else
            disableNoFallDmg()
        end
    end
})

local listsPage = window:new_page({
    name = "Lists"
})

local targetListSection = listsPage:new_section({
    name = "Target List",
    side = "left",
    size = 250
})

local targetListTextbox = targetListSection:new_textbox({
    name = "Add to Target List",
    placeholder = "player name",
    default = "",
    flag = "targetlist_add",
    callback = function(text)
        if text and text ~= "" then 
            table.insert(getgenv().Lists.TargetList, text)
        end
    end
})

local clearTargetListButton = targetListSection:new_button({
    name = "Clear Target List",
    callback = function()
        getgenv().Lists.TargetList = {}
    end
})

local whitelistSection = listsPage:new_section({
    name = "Whitelist",
    side = "right",
    size = 250
})

local whitelistTextbox = whitelistSection:new_textbox({
    name = "Add to Whitelist",
    placeholder = "player name",
    default = "",
    flag = "whitelist_add",
    callback = function(text)
        if text and text ~= "" then 
            table.insert(getgenv().Lists.Whitelist, text)
        end
    end
})

local clearWhitelistButton = whitelistSection:new_button({
    name = "Clear Whitelist",
    callback = function()
        getgenv().Lists.Whitelist = {}
    end
})

local controlsSection = listsPage:new_section({
    name = "Controls",
    side = "left",
    size = 200
})

local useTargetListToggle = controlsSection:new_toggle({
    name = "Use Target List",
    state = false,
    flag = "lists_usetargetlist",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseTargetList = state
    end
})

local useWhitelistToggle = controlsSection:new_toggle({
    name = "Use Whitelist",
    state = false,
    flag = "lists_usewhitelist",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseWhitelist = state
    end
})

local configPage = window:new_page({
    name = "Configuration"
})

local saveSection = configPage:new_section({
    name = "Save/Load",
    side = "left",
    size = 250
})

local saveConfigButton = saveSection:new_button({
    name = "Save Config",
    callback = function()
        if writefile then
            local allConfigs = {}
            
            local genv = getgenv()
            for key, value in pairs(genv) do
                if type(value) == "table" then
                    allConfigs[key] = value
                elseif type(value) == "Color3" then
                    allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
                else
                    allConfigs[key] = value
                end
            end
            
            writefile("aui_config.json", game:GetService("HttpService"):JSONEncode(allConfigs))
            warn("Configuration saved!")
        else
            warn("Writefile not supported")
        end
    end
})

local loadConfigButton = saveSection:new_button({
    name = "Load Config",
    callback = function()
        if readfile and isfile and isfile("aui_config.json") then
            local success, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(readfile("aui_config.json"))
            end)
            
            if success and data then
                for key, value in pairs(data) do
                    if type(value) == "table" and value.__type == "Color3" then
                        getgenv()[key] = Color3.fromRGB(value.R, value.G, value.B)
                    else
                        getgenv()[key] = value
                    end
                end
                warn("Configuration loaded!")
            else
                warn("Failed to load config")
            end
        else
            warn("Config file not found")
        end
    end
})

local resetConfigButton = saveSection:new_button({
    name = "Reset to Default",
    callback = function()
        getgenv().CONFIG = {
            Ragebot = {
                Enabled = false,
                RapidFire = false,
                FireRate = 30,
                Prediction = true,
                PredictionAmount = 0.12,
                TeamCheck = false,
                VisibilityCheck = true,
                FOV = 120,
                ShowFOV = true,
                Wallbang = true,
                Tracers = true,
                TracerColor = Color3.fromRGB(255, 0, 0),
                TracerWidth = 1,
                TracerLifetime = 3,
                ShootRange = 15,
                HitRange = 15,
                HitNotify = true,
                AutoReload = true,
                HitSound = true,
                HitColor = Color3.fromRGB(255, 182, 193),
                UseTargetList = false,
                UseWhitelist = false,
                HitNotifyDuration = 5,
                LowHealthCheck = false,
                SelectedHitSound = "skeet",
                FriendCheck = false,
                MaxTarget = 0
            },
            Misc = {
                SpeedEnabled = false,
                SpeedValue = 50,
                JumpPowerEnabled = false,
                JumpPowerValue = 100,
                LoopFOVEnabled = false,
                HideHeadEnabled = false,
                InfStaminaEnabled = false,
                NoFallDmgEnabled = false,
                SpeedConnection = nil,
                FOVConnection = nil,
                JumpPowerConnection = nil,
                NoFallHook = nil,
                InfStaminaHook = nil
            }
        }
        
        getgenv().Lists = {
            TargetList = {},
            Whitelist = {}
        }
        
        warn("Configuration reset to default!")
    end
})

local manageSection = configPage:new_section({
    name = "Manage",
    side = "right",
    size = 250
})

local configNameTextbox = manageSection:new_textbox({
    name = "Config Name",
    placeholder = "enter config name",
    default = "",
    flag = "config_name",
    callback = function(text)
        getgenv().currentConfigName = text
    end
})

local savePresetButton = manageSection:new_button({
    name = "Save as Preset",
    callback = function()
        if writefile and getgenv().currentConfigName then
            local name = getgenv().currentConfigName
            if name ~= "" then
                local allConfigs = {}
                
                local genv = getgenv()
                for key, value in pairs(genv) do
                    if type(value) == "table" then
                        allConfigs[key] = value
                    elseif type(value) == "Color3" then
                        allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
                    else
                        allConfigs[key] = value
                    end
                end
                
                writefile("aui_preset_" .. name .. ".json", game:GetService("HttpService"):JSONEncode(allConfigs))
                warn("Preset saved as: " .. name)
            end
        end
    end
})

local deletePresetButton = manageSection:new_button({
    name = "Delete Preset",
    callback = function()
        if delfile and getgenv().currentConfigName then
            local name = getgenv().currentConfigName
            if name ~= "" then
                local filename = "aui_preset_" .. name .. ".json"
                if isfile(filename) then
                    delfile(filename)
                    warn("Preset deleted: " .. name)
                end
            end
        end
    end
})

local listSection = configPage:new_section({
    name = "Presets List",
    side = "left",
    size = 200
})

local refreshPresetsButton = listSection:new_button({
    name = "Refresh Presets",
    callback = function()
        if isfile then
            for _, file in pairs(listfiles("")) do
                if file:find("aui_preset_") and file:find("%.json$") then
                    local name = file:match("aui_preset_(.+)%.json")
                    local loadPresetButton = listSection:new_button({
                        name = name,
                        callback = function()
                            if readfile then
                                local success, data = pcall(function()
                                    return game:GetService("HttpService"):JSONDecode(readfile(file))
                                end)
                                
                                if success and data then
                                    for key, value in pairs(data) do
                                        if type(value) == "table" and value.__type == "Color3" then
                                            getgenv()[key] = Color3.fromRGB(value.R, value.G, value.B)
                                        else
                                            getgenv()[key] = value
                                        end
                                    end
                                    warn("Preset loaded: " .. name)
                                end
                            end
                        end
                    })
                end
            end
        end
    end
})

local keybindsPage = window:new_page({
    name = "Keybinds"
})

local keybindsSection = keybindsPage:new_section({
    name = "Keybinds",
    side = "left",
    size = 250
})

local menuKeyList = keybindsSection:new_listbox({
    name = "Menu Key",
    options = {"RightShift", "Insert", "Delete", "End", "F5", "F6"},
    default = "RightShift",
    multiple = false,
    flag = "menu_key",
    callback = function(key)
    end
})

local panicKeyList = keybindsSection:new_listbox({
    name = "Panic Key",
    options = {"F9", "F10", "F11", "F12", "P"},
    default = "F9",
    multiple = false,
    flag = "panic_key",
    callback = function(key)
    end
})

local mainPage = window:new_page({
    name = "Main Settings"
})

local combatSection = mainPage:new_section({
    name = "Combat Settings",
    side = "left",
    size = 250
})

local aimbotToggle = combatSection:new_toggle({
    name = "Aimbot",
    state = true,
    flag = "aimbot_enabled",
    callback = function(state)
    end
})

local aimbotColor = aimbotToggle:new_colorpicker({
    default = Color3.fromRGB(255, 100, 100),
    flag = "aimbot_color",
    callback = function(color)
    end
})

local aimbotFOVSlider = combatSection:new_slider({
    name = "Aimbot FOV",
    min = 1,
    max = 360,
    default = 120,
    text = "[value]°",
    flag = "aimbot_fov",
    callback = function(value)
    end
})

local hitboxSelection = combatSection:new_listbox({
    name = "Hitbox Priority",
    options = {"Head", "Torso", "Neck", "Random"},
    default = "Head",
    multiple = false,
    flag = "hitbox_priority",
    callback = function(selection)
    end
})

local aimbotKeybind = combatSection:new_listbox({
    name = "Aimbot Keybind",
    options = {"LeftMouse", "RightMouse", "LeftControl", "LeftAlt", "Q", "E"},
    default = "RightMouse",
    multiple = false,
    flag = "aimbot_keybind",
    callback = function(key)
    end
})

local smoothingSlider = combatSection:new_slider({
    name = "Smoothing",
    min = 0,
    max = 100,
    default = 30,
    float = 0.1,
    text = "[value]%",
    flag = "aimbot_smoothing",
    callback = function(value)
    end
})

local visualSection = mainPage:new_section({
    name = "Visual Settings",
    side = "right",
    size = 250
})

local espToggle = visualSection:new_toggle({
    name = "ESP",
    state = true,
    flag = "esp_enabled",
    callback = function(state)
    end
})

local espColor = espToggle:new_colorpicker({
    default = Color3.fromRGB(61, 100, 227),
    flag = "esp_color",
    callback = function(color)
    end
})

local espBoxType = visualSection:new_listbox({
    name = "ESP Box Type",
    options = {"2D Box", "3D Box", "Corner Box", "Skeleton", "None"},
    default = "2D Box",
    multiple = false,
    flag = "esp_box_type",
    callback = function(selection)
    end
})

local espFeatures = visualSection:new_listbox({
    name = "ESP Features",
    options = {"Name", "Distance", "Health", "Weapon", "Team", "Chams", "Tracers", "Outlines"},
    default = {"Name", "Distance", "Health"},
    multiple = true,
    max = 8,
    size = 120,
    flag = "esp_features",
    callback = function(features)
    end
})

local maxDistanceSlider = visualSection:new_slider({
    name = "Max Distance",
    min = 0,
    max = 1000,
    default = 500,
    text = "[value] studs",
    flag = "max_distance",
    callback = function(value)
    end
})

local secondPage = window:new_page({
    name = "Player Settings"
})

local playerSection = secondPage:new_section({
    name = "Player Modifications",
    side = "left",
    size = 220
})

local walkSpeedSlider = playerSection:new_slider({
    name = "Walk Speed",
    min = 16,
    max = 200,
    default = 16,
    flag = "walk_speed",
    callback = function(value)
    end
})

local jumpPowerSlider = playerSection:new_slider({
    name = "Jump Power",
    min = 50,
    max = 200,
    default = 50,
    flag = "jump_power",
    callback = function(value)
    end
})

local gravitySlider = playerSection:new_slider({
    name = "Gravity",
    min = 0,
    max = 200,
    default = 196,
    flag = "gravity",
    callback = function(value)
    end
})

local infJumpToggle = playerSection:new_toggle({
    name = "Infinite Jump",
    state = false,
    flag = "infinite_jump",
    callback = function(state)
    end
})

local noclipToggle = playerSection:new_toggle({
    name = "Noclip",
    state = false,
    flag = "noclip",
    callback = function(state)
    end
})

local miscSection = secondPage:new_section({
    name = "Miscellaneous",
    side = "right",
    size = 220
})

local fpsCapSlider = miscSection:new_slider({
    name = "FPS Cap",
    min = 30,
    max = 240,
    default = 60,
    flag = "fps_cap",
    callback = function(value)
    end
})

local autoFarmToggle = miscSection:new_toggle({
    name = "Auto Farm",
    state = false,
    flag = "auto_farm",
    callback = function(state)
    end
})

local serverHopList = miscSection:new_listbox({
    name = "Server Hop Mode",
    options = {"Low Ping", "High Player", "Random", "Friends Only"},
    default = "Low Ping",
    multiple = false,
    flag = "server_hop_mode",
    callback = function(mode)
    end
})

local notificationToggle = miscSection:new_toggle({
    name = "Notifications",
    state = true,
    flag = "notifications",
    callback = function(state)
    end
})

local notificationColor = notificationToggle:new_colorpicker({
    default = Color3.fromRGB(100, 200, 100),
    flag = "notification_color",
    callback = function(color)
    end
})

local thirdPage = window:new_page({
    name = "Configurations"
})

local configSection = thirdPage:new_section({
    name = "Config Manager",
    side = "left",
    size = 200
})

local configNameBox = configSection:new_textbox({
    name = "Config Name",
    placeholder = "Enter config name",
    default = "default",
    flag = "config_name",
    callback = function(name)
    end
})

local configList = configSection:new_listbox({
    name = "Saved Configs",
    options = {"default", "legit", "rage", "test1", "test2"},
    default = "default",
    multiple = false,
    size = 100,
    flag = "config_list",
    callback = function(config)
    end
})

local saveButton = configSection:new_button({
    name = "Press to Save Config",
    callback = function()
    end
})

local loadButton = configSection:new_button({
    name = "Press to Load Config",
    callback = function()
    end
})

local watermarkToggle = configSection:new_toggle({
    name = "Watermark",
    state = true,
    flag = "watermark",
    callback = function(state)
    end
})

local uiSection = thirdPage:new_section({
    name = "UI Settings",
    side = "right",
    size = 200
})

local uiScaleSlider = uiSection:new_slider({
    name = "UI Scale",
    min = 50,
    max = 150,
    default = 100,
    text = "[value]%",
    flag = "ui_scale",
    callback = function(value)
    end
})

local themeList = uiSection:new_listbox({
    name = "UI Theme",
    options = {"Default", "Dark", "Light", "Purple", "Green", "Red"},
    default = "Default",
    multiple = false,
    flag = "ui_theme",
    callback = function(theme)
    end
})

local rainbowToggle = uiSection:new_toggle({
    name = "Rainbow UI",
    state = false,
    flag = "rainbow_ui",
    callback = function(state)
    end
})

local rainbowSpeedSlider = rainbowToggle:new_slider({
    name = "Rainbow Speed",
    min = 1,
    max = 100,
    default = 20,
    flag = "rainbow_speed",
    callback = function(value)
    end
})

local keybindsSection = mainPage:new_section({
    name = "Keybinds",
    side = "left",
    size = 150
})

local menuKey = keybindsSection:new_listbox({
    name = "Menu Key",
    options = {"RightShift", "Insert", "Delete", "End", "F5", "F6"},
    default = "RightShift",
    multiple = false,
    flag = "menu_key",
    callback = function(key)
    end
})

local panicKey = keybindsSection:new_listbox({
    name = "Panic Key",
    options = {"F9", "F10", "F11", "F12", "P"},
    default = "F9",
    multiple = false,
    flag = "panic_key",
    callback = function(key)
    end
})

-- 加载Ragebot功能
local function loadRagebot()
    if makefolder then
        makefolder("a")
        makefolder("a/fonts")
    end

    if not isfile or (isfile and not isfile("a/fonts/main.ttf")) then
        if writefile then
            writefile("a/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
        end
    end

    local font_data = {
        name = "AFont",
        faces = {
            {
                name = "Regular",
                weight = 400,
                style = "normal",
                assetId = getcustomasset and getcustomasset("a/fonts/main.ttf") or ""
            }
        }
    }

    if writefile and not isfile("a/fonts/main_encoded.ttf") then
        writefile("a/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
    end

    local AFont = Font.new(getcustomasset and getcustomasset("a/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

    local hitNotifications = {}
    local notificationYOffset = 5
    local MAX_VISIBLE_NOTIFICATIONS = 15

    local function createHitNotification(toolName, offsetValue, playerName)
        if not getgenv().CONFIG.Ragebot.HitNotify then return end
        
        local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
        ScreenGui.Name = "HitNotifications"
        ScreenGui.Parent = game:GetService("CoreGui")
        
        local scrollFrame = ScreenGui:FindFirstChild("NotificationScroll") or Instance.new("ScrollingFrame")
        scrollFrame.Name = "NotificationScroll"
        scrollFrame.Parent = ScreenGui
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.Size = UDim2.new(0, 400, 0, 200)
        scrollFrame.Position = UDim2.new(0, 30, 0, 10)  
        scrollFrame.ScrollingEnabled = false
        scrollFrame.CanvasSize = UDim2.new(0, 400, 0, 0)
        scrollFrame.ScrollBarThickness = 0
        
        local box = Instance.new("Frame")
        box.Parent = scrollFrame
        box.BackgroundColor3 = Color3.new(0, 0, 0)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.AnchorPoint = Vector2.new(0, 0)
        
        local parts = {
            {"Using ", Color3.fromRGB(255, 255, 255)},
            {toolName.." ", getgenv().CONFIG.Ragebot.HitColor},
            {"On ", Color3.fromRGB(255, 255, 255)},
            {string.format("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},
            {"in the ", Color3.fromRGB(255, 255, 255)},
            {"head ", getgenv().CONFIG.Ragebot.HitColor},
            {"to hit ", Color3.fromRGB(255, 255, 255)},
            {playerName, getgenv().CONFIG.Ragebot.HitColor},
            {"on via cache", Color3.fromRGB(255, 255, 255)},
        }
        
        local offsetX = 8 
        local totalW, maxH = 0, 0
        
        for _, seg in ipairs(parts) do
            local txt, col = seg[1], seg[2]
            local label = Instance.new("TextLabel")
            label.Parent = box
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 0
            label.TextColor3 = col
            label.FontFace = AFont
            label.TextSize = 10
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.Text = txt
            label.AutomaticSize = Enum.AutomaticSize.XY
            label.Position = UDim2.new(0, offsetX, 0, 0)
            offsetX = offsetX + label.TextBounds.X
            totalW = offsetX
            maxH = math.max(maxH, label.TextBounds.Y)
        end
        
        box.Size = UDim2.new(0, totalW + 16, 0, maxH + 8) 
        
        table.insert(hitNotifications, {box = box, createTime = tick()})
        
        local totalHeight = 0
        for i, notif in ipairs(hitNotifications) do
            local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
            notif.box.Position = UDim2.new(0, 0, 0, yPos)  
            totalHeight = totalHeight + notif.box.AbsoluteSize.Y + 5
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 400, 0, totalHeight)
        
        local function updateScrollFrame()
            local allFrames = {}
            for _, notif in ipairs(hitNotifications) do
                if notif.box and notif.box.Parent then
                    table.insert(allFrames, notif)
                end
            end
            
            hitNotifications = allFrames
            
            local visibleCount = math.min(#hitNotifications, MAX_VISIBLE_NOTIFICATIONS)
            scrollFrame.CanvasSize = UDim2.new(0, 400, 0, visibleCount * (box.AbsoluteSize.Y + 5))
            
            for i, notif in ipairs(hitNotifications) do
                local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
                notif.box.Position = UDim2.new(0, 0, 0, yPos)
                
                if i <= MAX_VISIBLE_NOTIFICATIONS then
                    notif.box.Visible = true
                else
                    notif.box.Visible = false
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
            ["skeet"] = "rbxassetid://4817809188",
            ["xp level"] = "rbxassetid://17148249625",
            ["bell"] = "rbxassetid://6534948092"
        }
        
        local soundId = soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound] or soundIds["skeet"]
        
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 0.75
        sound.Parent = Workspace
        sound:Play()
        
        game:GetService("Debris"):AddItem(sound, 0.75)
    end

    local function getCurrentTool()
        if LocalPlayer.Character then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    return tool
                end
            end
        end
        return nil
    end

    local function autoReload()
        if not getgenv().CONFIG.Ragebot.AutoReload then return end
        
        local tool = getCurrentTool()
        if not tool then return end
        
        local values = tool:FindFirstChild("Values")
        if not values then return end
        
        local ammo = values:FindFirstChild("SERVER_Ammo")
        local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
        if not ammo or not storedAmmo then return end
        
        if ammo.Value <= 0 and storedAmmo.Value > 0 then
            local args = {
                tick(),
                "KLWE89U0",
                tool
            }
            local GNX_R = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
            GNX_R:FireServer(unpack(args))
        end
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
                        if targetPlayer then
                            return true
                        end
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
                        if targetPlayer then
                            return true
                        end
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
        local targetCount = 0
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            
            if getgenv().CONFIG.Ragebot.FriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then
                continue
            end
            
            if getgenv().CONFIG.Ragebot.UseWhitelist and table.find(getgenv().Lists.Whitelist, player.Name) then
                continue
            end
            
            if getgenv().CONFIG.Ragebot.UseTargetList and not table.find(getgenv().Lists.TargetList, player.Name) then
                continue
            end
            
            if getgenv().CONFIG.Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                local head = character:FindFirstChild("Head")
                
                if humanoid and humanoid.Health > 0 and head then
                    local hasForcefield = false
                    for _, child in pairs(character:GetChildren()) do
                        if child:IsA("ForceField") then
                            hasForcefield = true
                            break
                        end
                    end
                    
                    if hasForcefield then continue end
            
                    if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                    
                    local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                    
                    if getgenv().CONFIG.Ragebot.MaxTarget > 0 then
                        targetCount = targetCount + 1
                        if targetCount > getgenv().CONFIG.Ragebot.MaxTarget then
                            break
                        end
                    end
                    
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
                    if not humanoid then
                        return false
                    end
                else
                    return false
                end
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
        
        for i = 1, 100 do
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
            
            if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
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
        
        local tweenInfo = TweenInfo.new(
            getgenv().CONFIG.Ragebot.TracerLifetime,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        
        local tween = TweenService:Create(beam, tweenInfo, {
            Brightness = 0
        })
        
        tween:Play()
        tween.Completed:Connect(function()
            if tracerModel then 
                tracerModel:Destroy() 
            end
        end)
    end

    local function RandomString(length)
        local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        local result = ""
        for i = 1, length do
            result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset))
        end
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
        if ammo.Value <= 0 then
            autoReload()
            return false
        end

        local bestShootPos, bestHitPos = wallbang()
        
        if not bestShootPos or not bestHitPos then
            return false
        end
        local hitPosition = bestHitPos
      
        if getgenv().CONFIG.Ragebot.Prediction then
            local velocity = targetHead.Velocity or Vector3.zero
            hitPosition = hitPosition + velocity * getgenv().CONFIG.Ragebot.PredictionAmount
        end

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
        

        --ammo.Value = math.max(ammo.Value - 1, 0)
        hitMarker:Fire(targetHead)
        storedAmmo.Value = storedAmmo.Value
        createTracer(bestShootPos, hitPosition)
        return true
    end
    local lastShotTime = 0

    RunService.Heartbeat:Connect(function()
        if not getgenv().CONFIG.Ragebot.Enabled then return end
        if not LocalPlayer.Character then return end
        if not LocalPlayer.Character:FindFirstChild("Head") then return end
        
        local target = getClosestTarget()
        if not target then return end
        
        local currentTime = tick()
        local baseWaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 0.05)
        local WaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
        if getgenv().CONFIG.Ragebot.RapidFire then
            local rapidWaitTime = baseWaitTime * 0.01
            
            if currentTime - lastShotTime >= rapidWaitTime then
                shootAtTarget(target)
                lastShotTime = currentTime
            end
        else
            if currentTime - lastShotTime >= WaitTime then
                shootAtTarget(target)
                lastShotTime = currentTime
            end
        end
    end)
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV
    fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Filled = false

    RunService.RenderStepped:Connect(function()
        fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV and getgenv().CONFIG.Ragebot.Enabled
        fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
end

local function loadMisc()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local hideHeadEnabled = false
    local handsUpEnabled = false
    local char = nil
    local torso = nil
    local originalNeckData = nil
    local renderConnection = nil
    local originalMotor6DData = {}
    local originalHook = nil
    local hasTool = false
    local toolConnection = nil
    local fixMotor6DConnection = nil
    local firstRecordedData = {}
    local isFirstTimeRecorded = false

    local function createHook()
        if originalHook then
            hookmetamethod(game, "__namecall", originalHook)
        end
        
        originalHook = hookmetamethod(game, "__namecall", function(self, ...)
            local methodName = getnamecallmethod()
            
            if tostring(methodName) == "FireServer" then
                if self.Name == "MOVZREP" then
                    local arg1, arg2
                    
                    if hideHeadEnabled and handsUpEnabled then
                        arg1 = vector.create(-5754.19873046875, 9848.3056640625, 1096.6358642578125)
                        arg2 = vector.create(-4778.53564453125, 0.33680424094200134, -339.89031982421875)
                    elseif hideHeadEnabled then
                        arg1 = Vector3.new(-5721.2001953125, -5, 971.5162353515625)
                        arg2 = Vector3.new(-4181.38818359375, -6, 11.123311996459961)
                    elseif handsUpEnabled then
                        arg1 = vector.create(-5754.19873046875, 9848.3056640625, 1096.6358642578125)
                        arg2 = vector.create(-4778.53564453125, 0.33680424094200134, -339.89031982421875)
                    end
                    
                    if arg1 and arg2 then
                        local fixedArguments = {
                            {
                                {
                                    arg1,
                                    arg2,
                                    Vector3.new(0.006237113382667303, -6, -0.18136750161647797),
                                    true,
                                    true,
                                    true,
                                    false
                                },
                                false,
                                false,
                                15.8
                            }
                        }
                        
                        return originalHook(self, table.unpack(fixedArguments))
                    end
                end
            end
            
            return originalHook(self, ...)
        end)
    end

    local function hideHead()
        if not Players.LocalPlayer.Character then return end
        
        local player = Players.LocalPlayer
        char = player.Character
        local head = char:WaitForChild("Head")
        torso = char:FindFirstChild("Torso")
        
        if not torso then return end
        
        local neck = torso:FindFirstChild("Neck")
        if neck then
            originalNeckData = {
                Part0 = neck.Part0,
                Part1 = neck.Part1,
                C0 = neck.C0,
                C1 = neck.C1
            }
            
            neck.Part0 = torso
            neck.Part1 = head
            neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            neck.C1 = CFrame.new(0, 0.5, 0)
        end
        
        hideHeadEnabled = true
        createHook()
        
        if renderConnection then
            renderConnection:Disconnect()
        end
        
        renderConnection = RunService.RenderStepped:Connect(function()
            if torso and torso.Parent then
                if neck and neck.Parent then
                    neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                end
            else
                if renderConnection then
                    renderConnection:Disconnect()
                    renderConnection = nil
                end
            end
        end)
    end

    local function showHead()
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
        
        hideHeadEnabled = false
        
        if handsUpEnabled then
            createHook()
        else
            if originalHook then
                hookmetamethod(game, "__namecall", originalHook)
                originalHook = nil
            end
        end
        
        if char and torso then
            local neck = torso:FindFirstChild("Neck")
            if neck and originalNeckData then
                neck.Part0 = originalNeckData.Part0
                neck.Part1 = originalNeckData.Part1
                neck.C0 = originalNeckData.C0
                neck.C1 = originalNeckData.C1
            end
        end
        
        originalNeckData = nil
        char = nil
        torso = nil
    end

    local function enableNoFallDmg()
        if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
        getgenv().CONFIG.Misc.NoFallHook = hookmetamethod(game, "__namecall", function(self, ...)
            local args = { ... }
            if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
                args[2] = 0
                args[3] = 0
            end
            return getgenv().CONFIG.Misc.NoFallHook(self, unpack(args))
        end)
    end

    local function disableNoFallDmg()
        if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
    end

    local function enableInfStamina()
        local module
        for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
            if v:IsA("ModuleScript") and v.Name == "XIIX" then module = v break end
        end
        if module then
            module = require(module)
            local ac = module["XIIX"]
            local glob = getfenv(ac)["_G"]
            local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
            if stamina ~= nil then
                getgenv().CONFIG.Misc.InfStaminaHook = hookfunction(stamina, function() return 100, 100 end)
            end
        end
    end

    local function disableInfStamina()
        if getgenv().CONFIG.Misc.InfStaminaHook then getgenv().CONFIG.Misc.InfStaminaHook = nil end
    end
end

loadRagebot()
loadMisc()