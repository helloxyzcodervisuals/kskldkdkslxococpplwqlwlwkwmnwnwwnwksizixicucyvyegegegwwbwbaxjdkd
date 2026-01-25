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
--xcwhy
--why i
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
--[[
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
--]]
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
--[[
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
--]]
local function loadMisc()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CoreGui = game:GetService("CoreGui")

    local QuickUIFrame = Instance.new("Frame")
    QuickUIFrame.Name = "QuickUIFrame"
    QuickUIFrame.Size = UDim2.new(0, 80, 0, 30)
    QuickUIFrame.Position = UDim2.new(0, 10, 0, 50)
    QuickUIFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    QuickUIFrame.BackgroundTransparency = 0.5
    QuickUIFrame.BorderSizePixel = 0

    local QuickUIText = Instance.new("TextButton")
    QuickUIText.Name = "QuickUIText"
    QuickUIText.Size = UDim2.new(1, 0, 1, 0)
    QuickUIText.BackgroundTransparency = 1
    QuickUIText.Text = "FLY OFF"
    QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
    QuickUIText.Font = Enum.Font.GothamBold
    QuickUIText.TextSize = 12
    QuickUIText.Parent = QuickUIFrame

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QuickUIScreen"
    ScreenGui.Parent = CoreGui
    QuickUIFrame.Parent = ScreenGui

    local speedEnabled = false
    local speedConnection = nil

    local function enableSpeed()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end

        speedConnection = RunService.RenderStepped:Connect(function()
            local character = LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end
            humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
        end)
    end

    local function disableSpeed()
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end

        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = 16 end
        end
    end

    local jumpPowerEnabled = false
    local jumpPowerConnection = nil

    local function enableJumpPower()
        if jumpPowerConnection then
            jumpPowerConnection:Disconnect()
            jumpPowerConnection = nil
        end
        
        jumpPowerConnection = RunService.Heartbeat:Connect(function()
            if not jumpPowerEnabled then return end
            if not LocalPlayer.Character then return end
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
            end
        end)
    end

    local function disableJumpPower()
        if jumpPowerConnection then
            jumpPowerConnection:Disconnect()
            jumpPowerConnection = nil
        end
    end

    local loopFOVEnabled = false
    local fovConnection = nil

    local function enableLoopFOV()
        if fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
        
        fovConnection = RunService.RenderStepped:Connect(function()
            workspace.CurrentCamera.FieldOfView = 120
        end)
    end

    local function disableLoopFOV()
        if fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
    end

    local hideHeadEnabled = false
    local char = nil
    local torso = nil
    local originalMotor6Ds = {}
    local renderConnection = nil
    local originalHook = nil

    local function hideHead()
        if not LocalPlayer.Character then return end
        
        char = LocalPlayer.Character
        torso = char:FindFirstChild("Torso")
        
        if not torso then return end
        
        originalMotor6Ds = {}
        for _, motor in pairs(char:GetDescendants()) do
            if motor:IsA("Motor6D") then
                originalMotor6Ds[motor] = {
                    Part0 = motor.Part0,
                    Part1 = motor.Part1,
                    C0 = motor.C0,
                    C1 = motor.C1
                }
            end
        end
        
        hideHeadEnabled = true
        
        if not originalHook then
            originalHook = hookmetamethod(game, "__namecall", function(self, ...)
                local methodName = getnamecallmethod()
                
                if tostring(methodName) == "FireServer" then
                    if self.Name == "MOVZREP" then
                        local fixedArguments = {
                            {
                                {
                                    Vector3.new(-5721.2001953125, -5, 971.5162353515625),
                                    Vector3.new(-4181.38818359375, -6, 11.123311996459961),
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
                
                return originalHook(self, ...)
            end)
        end
        
        if renderConnection then
            renderConnection:Disconnect()
        end
        
        renderConnection = RunService.RenderStepped:Connect(function()
            if torso and torso.Parent then
                for motor, originalData in pairs(originalMotor6Ds) do
                    if motor and motor.Parent then
                        motor.C0 = originalData.C0
                        motor.C1 = originalData.C1
                    end
                end

                local neck = torso:FindFirstChild("Neck")
                if neck and neck:IsA("Motor6D") then
                    neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    neck.C1 = CFrame.new(0, 0.5, 0)
                end
            else
                if renderConnection then
                    renderConnection:Disconnect()
                    renderConnection = nil
                end
            end
        end)
    end

    local noFallHook = nil

    local function enableNoFallDmg()
        if noFallHook then return end
        noFallHook = hookmetamethod(game, "__namecall", function(self, ...)
            local args = { ... }
            if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
                args[2] = 0
                args[3] = 0
            end
            return noFallHook(self, unpack(args))
        end)
    end

    local function disableNoFallDmg()
        if noFallHook then
            hookmetamethod(game, "__namecall", noFallHook)
            noFallHook = nil
        end
    end

    local infStaminaHook = nil

    local function enableInfStamina()
        if infStaminaHook then return end
        
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
                infStaminaHook = hookfunction(stamina, function() return 100, 100 end)
            end
        end
    end

    local function disableInfStamina()
        if infStaminaHook then
            hookfunction(stamina, infStaminaHook)
            infStaminaHook = nil
        end
    end

    local lockpickEnabled = false
    local lockpickAddedConnection = nil

    local function enableLockpick()
        lockpickEnabled = true
        
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return end
        
        local function lockpick(gui)
            for _, a in pairs(gui:GetDescendants()) do
                if a:IsA("ImageLabel") and a.Name == "Bar" and a.Parent.Name ~= "Attempts" then
                    local oldsize = a.Size
                    RunService.RenderStepped:Connect(function()
                        if lockpickEnabled then
                            a.Size = UDim2.new(0, 280, 0, 280)
                        else
                            a.Size = oldsize
                        end
                    end)
                end
            end
        end
        
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
        end
        
        lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end)
        
        for _, child in pairs(PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end
    end

    local function disableLockpick()
        lockpickEnabled = false
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
            lockpickAddedConnection = nil
        end
    end

    local SafeESP = {
        Enabled = false,
        Safes = {},
        Visuals = {}
    }

    local function addSafeESP(model)
        if not model or not model.Parent then return end
        
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
        highlight.OutlineTransparency = 0
        highlight.Adornee = model
        highlight.Parent = model
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "SafeESP"
        billboard.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 100
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        textLabel.TextSize = 14
        textLabel.FontFace = Font.new("rbxassetid://12187371840")
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = model.Name
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0, 20)
        distanceLabel.Position = UDim2.new(0, 0, 0, 20)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distanceLabel.TextSize = 12
        distanceLabel.FontFace = Font.new("rbxassetid://12187371840")
        distanceLabel.TextStrokeTransparency = 0.5
        
        textLabel.Parent = billboard
        distanceLabel.Parent = billboard
        billboard.Parent = model
        
        SafeESP.Safes[model] = true
        SafeESP.Visuals[model] = {highlight = highlight, billboard = billboard, textLabel = textLabel, distanceLabel = distanceLabel}
        
        RunService.Heartbeat:Connect(function()
            if not SafeESP.Enabled or not model.Parent then
                highlight:Destroy()
                billboard:Destroy()
                SafeESP.Safes[model] = nil
                SafeESP.Visuals[model] = nil
                return
            end
            
            if LocalPlayer and LocalPlayer.Character then
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and billboard.Adornee then
                    local distance = (humanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                    distanceLabel.Text = string.format("%d studs", math.floor(distance))
                    billboard.Enabled = distance <= 100
                end
            end
        end)
    end

    local function scanWorkspace()
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                    if not SafeESP.Safes[item] then
                        addSafeESP(item)
                    end
                end
            end
        end
    end

    local safeColor = Color3.fromRGB(255, 215, 0)

    local function enableSafeESP(value)
        SafeESP.Enabled = value
        
        if value then
            scanWorkspace()
            
            Workspace.DescendantAdded:Connect(function(item)
                if item:IsA("Model") then
                    local itemName = item.Name:lower()
                    if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                        task.wait(0.1)
                        addSafeESP(item)
                    end
                end
            end)
        else
            for model, visuals in pairs(SafeESP.Visuals) do
                if visuals.highlight then visuals.highlight:Destroy() end
                if visuals.billboard then visuals.billboard:Destroy() end
            end
            SafeESP.Safes = {}
            SafeESP.Visuals = {}
        end
    end

    local function updateSafeColor(color)
        safeColor = color
        for model, visuals in pairs(SafeESP.Visuals) do
            if visuals.highlight then
                visuals.highlight.FillColor = color
            end
            if visuals.textLabel then
                visuals.textLabel.TextColor3 = color
            end
        end
    end

    local instantPromptEnabled = false
    local instantPromptConnection = nil

    local function enableInstantPrompt()
        instantPromptEnabled = true
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        
        if instantPromptConnection then
            instantPromptConnection:Disconnect()
        end
        
        instantPromptConnection = game.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                task.wait()
                obj.HoldDuration = 0
            end
        end)
    end

    local function disableInstantPrompt()
        instantPromptEnabled = false
        
        if instantPromptConnection then
            instantPromptConnection:Disconnect()
            instantPromptConnection = nil
        end
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 1
            end
        end
    end

    local autoDoorEnabled = false
    local doorConnection = nil

    local function enableAutoDoor()
        autoDoorEnabled = true
        
        if doorConnection then
            doorConnection:Disconnect()
        end
        
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
            
            for _, door in pairs(Doors:GetChildren()) do
                local knob = door:FindFirstChild("Knob1") or door:FindFirstChild("Knob2")
                if knob then
                    local distance = (knob.Position - charRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestDoor = door
                    end
                end
            end
            
            if closestDoor then
                local knob = closestDoor:FindFirstChild("Knob1") or closestDoor:FindFirstChild("Knob2")
                local events = closestDoor:FindFirstChild("Events")
                local toggleEvent = events and events:FindFirstChild("Toggle")
                
                if knob and toggleEvent then
                    local args = {"Open", knob}
                    toggleEvent:FireServer(unpack(args))
                end
            end
        end)
    end

    local function disableAutoDoor()
        autoDoorEnabled = false
        if doorConnection then
            doorConnection:Disconnect()
            doorConnection = nil
        end
    end

    local flyEnabled = false
    local flySpeed = 50
    local flyConnection = nil

    local function startFlying()
        local Char = LocalPlayer.Character
        if not Char then return end
        
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        local Root = Char:FindFirstChild("HumanoidRootPart")
        if not Hum or not Root then return end
        
        local RagdollEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL")
        RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
        
        for _, child in ipairs(Char:GetDescendants()) do
            if child:IsA("Motor6D") then
                child.Enabled = false
            end
        end
        
        Hum.PlatformStand = true
        Hum:ChangeState(Enum.HumanoidStateType.Freefall)
        
        local flyMotors = {}
        for _, part in ipairs(Char:GetDescendants()) do
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
                if flyConnection then
                    flyConnection:Disconnect()
                    flyConnection = nil
                end
                Hum.PlatformStand = false
                Root.Velocity = Vector3.new(0, 0, 0)
                Hum:ChangeState(Enum.HumanoidStateType.Running)
                RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), true)
                
                for _, motor in ipairs(flyMotors) do
                    motor:Destroy()
                end
                
                for _, child in ipairs(Char:GetDescendants()) do
                    if child:IsA("Motor6D") and child.Name ~= "FlyMotor" then
                        child.Enabled = true
                    end
                end
                
                return
            end
            
            local Cam = Workspace.CurrentCamera
            if not Cam then return end
            
            local cameraLook = Cam.CFrame.LookVector
            local IsMoving = Hum.MoveDirection.Magnitude > 0
            
            local targetLook = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z)
            if targetLook.Magnitude > 0 then
                targetLook = targetLook.Unit
                Root.CFrame = CFrame.new(Root.Position, Root.Position + targetLook)
            end
            
            if IsMoving then
                local moveVector = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z).Unit
                Root.Velocity = moveVector * flySpeed
                RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
            else
                Root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    local function disableFlying()
        flyEnabled = false
    end

    QuickUIText.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            QuickUIText.Text = "FLY ON"
            QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
            startFlying()
        else
            QuickUIText.Text = "FLY OFF"
            QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
            disableFlying()
        end
    end)

    return {
        toggleSpeed = function(state)
            speedEnabled = state
            if state then
                enableSpeed()
            else
                disableSpeed()
            end
        end,
        toggleJumpPower = function(state)
            jumpPowerEnabled = state
            if state then
                enableJumpPower()
            else
                disableJumpPower()
            end
        end,
        toggleLoopFOV = function(state)
            loopFOVEnabled = state
            if state then
                enableLoopFOV()
            else
                disableLoopFOV()
            end
        end,
        toggleHideHead = function(state)
            getgenv().CONFIG.Misc.HideHeadEnabled = state
            if state then
                hideHead()
            else
                showHead()
            end
        end,
        toggleInfStamina = function(state)
            getgenv().CONFIG.Misc.InfStaminaEnabled = state
            if state then
                enableInfStamina()
            else
                disableInfStamina()
            end
        end,
        toggleNoFall = function(state)
            getgenv().CONFIG.Misc.NoFallDmgEnabled = state
            if state then
                enableNoFallDmg()
            else
                disableNoFallDmg()
            end
        end,
        toggleLockpick = function(state)
            if state then
                enableLockpick()
            else
                disableLockpick()
            end
        end,
        toggleSafeESP = function(state)
            enableSafeESP(state)
        end,
        updateSafeColor = updateSafeColor,
        toggleInstantPrompt = function(state)
            if state then
                enableInstantPrompt()
            else
                disableInstantPrompt()
            end
        end,
        toggleAutoDoor = function(state)
            if state then
                enableAutoDoor()
            else
                disableAutoDoor()
            end
        end,
        toggleFly = function(state)
            flyEnabled = state
            if state then
                QuickUIText.Text = "FLY ON"
                QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
                startFlying()
            else
                QuickUIText.Text = "FLY OFF"
                QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
                disableFlying()
            end
        end,
        setFlySpeed = function(value) flySpeed = value end,
        setSpeedValue = function(value) getgenv().CONFIG.Misc.SpeedValue = value end,
        setJumpValue = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end
    }
end

local misc = loadMisc()
loadRagebot()


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

--local maxTargetSlider = targetingSection:new_slider({
--    name = "Max Target",
--    min = 0,
--    max = 20,
--    default = 1,
--    text = "[value] players",
--    flag = "ragebot_maxtarget",
--    callback = function(value)
        getgenv().CONFIG.Ragebot.MaxTarget = 0
--})

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
--[[
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
--]]
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
        misc.toggleSpeed(state)
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
        misc.setSpeedValue(value)
    end
})

local jumpPowerToggle = movementSection:new_toggle({
    name = "Jump Power",
    state = false,
    flag = "misc_jumppower",
    callback = function(state)
        misc.toggleJumpPower(state)
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
        misc.setJumpValue(value)
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
        misc.toggleLoopFOV(state)
    end
})

local hideHeadToggle = visualSection:new_toggle({
    name = "Hide Head",
    state = false,
    flag = "misc_hidehead",
    callback = function(state)
        misc.toggleHideHead(state)
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
        misc.toggleInfStamina(state)
    end
})

local noFallToggle = otherSection:new_toggle({
    name = "No Fall Damage",
    state = false,
    flag = "misc_nofall",
    callback = function(state)
        misc.toggleNoFall(state)
    end
})

local lockpickToggle = otherSection:new_toggle({
    name = "No Fail Lockpick",
    state = false,
    flag = "misc_lockpick",
    callback = function(state)
        misc.toggleLockpick(state)
    end
})

local instantPromptToggle = otherSection:new_toggle({
    name = "Instant Prompt",
    state = false,
    flag = "misc_instantprompt",
    callback = function(state)
        misc.toggleInstantPrompt(state)
    end
})

local autoDoorToggle = otherSection:new_toggle({
    name = "Auto Door",
    state = false,
    flag = "misc_autodoor",
    callback = function(state)
        misc.toggleAutoDoor(state)
    end
})

local flyToggle = movementSection:new_toggle({
    name = "Fly",
    state = false,
    flag = "misc_fly",
    callback = function(state)
        misc.toggleFly(state)
    end
})

local flySpeedSlider = movementSection:new_slider({
    name = "Fly Speed",
    min = 10,
    max = 200,
    default = 50,
    text = "[value]",
    flag = "misc_flyspeed",
    callback = function(value)
        misc.setFlySpeed(value)
    end
})

local safeESPSection = miscPage:new_section({
    name = "Safe ESP",
    side = "right",
    size = 200
})

local safeESPToggle = safeESPSection:new_toggle({
    name = "Enable Safe ESP",
    state = false,
    flag = "misc_safeesp",
    callback = function(state)
        misc.toggleSafeESP(state)
    end
})

local safeColorPicker = safeESPToggle:new_colorpicker({
    default = Color3.fromRGB(255, 215, 0),
    flag = "misc_safecolor",
    callback = function(color)
        misc.updateSafeColor(color)
    end
})
--[[
local playersPage = window:new_page({
    name = "Players"
})

local listsSection = playersPage:new_section({
    name = "Lists",
    side = "left",
    size = 500
})

local targetListBox = listsSection:new_listbox({
    name = "Target List",
    options = {},
    default = {},
    multiple = true,
    size = 200,
    flag = "targetlist_list",
    callback = function(selected)
    end
})

local addTargetButton = listsSection:new_button({
    name = "Add to Target",
    callback = function()
        local playerName = library.flags.targetlist_input or ""
        if playerName ~= "" then
            table.insert(getgenv().Lists.TargetList, playerName)
            if not table.find(targetListBox.options, playerName) then
                targetListBox:add_option(playerName)
            end
        end
    end
})

local removeTargetButton = listsSection:new_button({
    name = "Remove Selected",
    callback = function()
        for _, playerName in ipairs(library.flags.targetlist_list or {}) do
            local index = table.find(getgenv().Lists.TargetList, playerName)
            if index then
                table.remove(getgenv().Lists.TargetList, index)
            end
            targetListBox:remove_option(playerName)
        end
    end
})

local whitelistBox = listsSection:new_listbox({
    name = "Whitelist",
    options = {},
    default = {},
    multiple = true,
    size = 200,
    flag = "whitelist_list",
    callback = function(selected)
    end
})

local addWhitelistButton = listsSection:new_button({
    name = "Add to Whitelist",
    callback = function()
        local playerName = library.flags.whitelist_input or ""
        if playerName ~= "" then
            table.insert(getgenv().Lists.Whitelist, playerName)
            if not table.find(whitelistBox.options, playerName) then
                whitelistBox:add_option(playerName)
            end
        end
    end
})

local removeWhitelistButton = listsSection:new_button({
    name = "Remove Selected",
    callback = function()
        for _, playerName in ipairs(library.flags.whitelist_list or {}) do
            local index = table.find(getgenv().Lists.Whitelist, playerName)
            if index then
                table.remove(getgenv().Lists.Whitelist, index)
            end
            whitelistBox:remove_option(playerName)
        end
    end
})

local infoSection = playersPage:new_section({
    name = "Player Information",
    side = "right",
    size = 200
})

local selectedPlayerName = infoSection:new_label({
    name = "Selected: None"
})

local playerTeamLabel = infoSection:new_label({
    name = "Team: -"
})

local playerHealthLabel = infoSection:new_label({
    name = "Health: -"
})

local playerDistanceLabel = infoSection:new_label({
    name = "Distance: -"
})

local playerStatusLabel = infoSection:new_label({
    name = "Status: -"
})

local controlSection = playersPage:new_section({
    name = "Setting",
    side = "left",
    size = 150
})

local useTargetListToggle = controlSection:new_toggle({
    name = "Use Target List",
    state = false,
    flag = "players_usetargetlist",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseTargetList = state
    end
})

local useWhitelistToggle = controlSection:new_toggle({
    name = "Use Whitelist",
    state = false,
    flag = "players_usewhitelist",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseWhitelist = state
    end
})

local function updatePlayerLists()
    local players = Players:GetPlayers()
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            local playerName = player.Name
            
            if not table.find(targetListBox.options, playerName) then
                targetListBox:add_option(playerName)
            end
            
            if not table.find(whitelistBox.options, playerName) then
                whitelistBox:add_option(playerName)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        local playerName = player.Name
        if not table.find(targetListBox.options, playerName) then
            targetListBox:add_option(playerName)
        end
        if not table.find(whitelistBox.options, playerName) then
            whitelistBox:add_option(playerName)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    local playerName = player.Name
    targetListBox:remove_option(playerName)
    whitelistBox:remove_option(playerName)
end)

local function updatePlayerInfo()
    local selectedTarget = library.flags.targetlist_list and library.flags.targetlist_list[1]
    local selectedWhitelist = library.flags.whitelist_list and library.flags.whitelist_list[1]
    
    local selectedName = selectedTarget or selectedWhitelist
    if not selectedName then
        selectedPlayerName:set("Selected: None")
        playerTeamLabel:set("Team: -")
        playerHealthLabel:set("Health: -")
        playerDistanceLabel:set("Distance: -")
        playerStatusLabel:set("Status: -")
        return
    end
    
    local player = Players:FindFirstChild(selectedName)
    if not player then
        selectedPlayerName:set("Selected: " .. selectedName .. " (Offline)")
        playerTeamLabel:set("Team: -")
        playerHealthLabel:set("Health: -")
        playerDistanceLabel:set("Distance: -")
        playerStatusLabel:set("Status: Offline")
        return
    end
    
    selectedPlayerName:set("Selected: " .. player.Name)
    
    if player.Team then
        playerTeamLabel:set("Team: " .. tostring(player.Team))
    else
        playerTeamLabel:set("Team: None")
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            playerHealthLabel:set(string.format("Health: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth)))
        else
            playerHealthLabel:set("Health: -")
        end
        
        local localChar = LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
        local playerRoot = character:FindFirstChild("HumanoidRootPart")
        
        if localRoot and playerRoot then
            local distance = (localRoot.Position - playerRoot.Position).Magnitude
            playerDistanceLabel:set(string.format("Distance: %d studs", math.floor(distance)))
        else
            playerDistanceLabel:set("Distance: -")
        end
        
        playerStatusLabel:set("Status: Alive")
    else
        playerHealthLabel:set("Health: -")
        playerDistanceLabel:set("Distance: -")
        playerStatusLabel:set("Status: Dead/Respawning")
    end
end

RunService.RenderStepped:Connect(function()
    updatePlayerInfo()
end)

task.spawn(function()
    task.wait(2)
    updatePlayerLists()
end)
--]]
local playersPage = window:new_page({
    name = "Players"
})

local leftSection = playersPage:new_section({
    name = "Players",
    side = "left",
    size = 450
})
local targetCount = leftSection:new_label({
    name = "Selected Targets: 0"
})

local whitelistCount = leftSection:new_label({
    name = "Selected Whitelist: 0"
})

local totalTargetCount = leftSection:new_label({
    name = "Total Targets: 0"
})

local totalWhitelistCount = leftSection:new_label({
    name = "Total Whitelist: 0"
})

local playersBox = leftSection:new_listbox({
    name = "Players",
    options = {},
    default = {},
    multiple = true,
    size = 120,
    flag = "players_box",
    callback = function(selected)
        local targets = {}
        local whitelist = {}
        
        for _, name in ipairs(selected or {}) do
            local isTarget = false
            for _, target in ipairs(getgenv().Lists.TargetList) do
                if target == name then
                    isTarget = true
                    break
                end
            end
            
            local isWhitelist = false
            for _, wl in ipairs(getgenv().Lists.Whitelist) do
                if wl == name then
                    isWhitelist = true
                    break
                end
            end
            
            if isTarget then
                table.insert(targets, name)
            end
            
            if isWhitelist then
                table.insert(whitelist, name)
            end
        end
        
        targetCount:set("Selected Targets: " .. #targets)
        whitelistCount:set("Selected Whitelist: " .. #whitelist)
    end
})



local addTargetBtn = leftSection:new_button({
    name = "Add to Target",
    callback = function()
        local selected = playersBox.default or {}
        for _, name in ipairs(selected) do
            local found = false
            for _, target in ipairs(getgenv().Lists.TargetList) do
                if target == name then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(getgenv().Lists.TargetList, name)
            end
        end
        totalTargetCount:set("Total Targets: " .. #getgenv().Lists.TargetList)
    end
})

local addWhitelistBtn = leftSection:new_button({
    name = "Add to Whitelist",
    callback = function()
        local selected = playersBox.default or {}
        for _, name in ipairs(selected) do
            local found = false
            for _, wl in ipairs(getgenv().Lists.Whitelist) do
                if wl == name then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(getgenv().Lists.Whitelist, name)
            end
        end
        totalWhitelistCount:set("Total Whitelist: " .. #getgenv().Lists.Whitelist)
    end
})

local removeTargetBtn = leftSection:new_button({
    name = "Remove Target",
    callback = function()
        local selected = playersBox.default or {}
        for _, name in ipairs(selected) do
            for i, target in ipairs(getgenv().Lists.TargetList) do
                if target == name then
                    table.remove(getgenv().Lists.TargetList, i)
                    break
                end
            end
        end
        totalTargetCount:set("Total Targets: " .. #getgenv().Lists.TargetList)
    end
})

local removeWhitelistBtn = leftSection:new_button({
    name = "Remove Whitelist",
    callback = function()
        local selected = playersBox.default or {}
        for _, name in ipairs(selected) do
            for i, wl in ipairs(getgenv().Lists.Whitelist) do
                if wl == name then
                    table.remove(getgenv().Lists.Whitelist, i)
                    break
                end
            end
        end
        totalWhitelistCount:set("Total Whitelist: " .. #getgenv().Lists.Whitelist)
    end
})

local clearAllTargetsBtn = leftSection:new_button({
    name = "Clear All Targets",
    callback = function()
        getgenv().Lists.TargetList = {}
        totalTargetCount:set("Total Targets: 0")
    end
})

local clearAllWhitelistBtn = leftSection:new_button({
    name = "Clear All Whitelist",
    callback = function()
        getgenv().Lists.Whitelist = {}
        totalWhitelistCount:set("Total Whitelist: 0")
    end
})

task.spawn(function()
    while task.wait(1) do
        totalTargetCount:set("Total Targets: " .. #getgenv().Lists.TargetList)
        totalWhitelistCount:set("Total Whitelist: " .. #getgenv().Lists.Whitelist)
    end
end)



local rightSection = playersPage:new_section({
    name = "Info",
    side = "right",
    size = 200
})

local selectedName = rightSection:new_label({
    name = "Selected: None"
})

local playerTeam = rightSection:new_label({
    name = "Team: -"
})

local playerHealth = rightSection:new_label({
    name = "Health: -"
})

local playerDistance = rightSection:new_label({
    name = "Distance: -"
})

local playerStatus = rightSection:new_label({
    name = "Status: -"
})

local controlSection = playersPage:new_section({
    name = "Controls",
    side = "left",
    size = 150
})

local useTargetToggle = controlSection:new_toggle({
    name = "Use Target",
    state = false,
    flag = "players_usetarget",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseTargetList = state
    end
})

local useWhitelistToggle = controlSection:new_toggle({
    name = "Use Whitelist",
    state = false,
    flag = "players_usewhitelist",
    callback = function(state)
        getgenv().CONFIG.Ragebot.UseWhitelist = state
    end
})

local function updatePlayerList()
    local players = Players:GetPlayers()
    
    for _, child in ipairs(playersBox.options) do
        playersBox:remove_option(child)
    end
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            playersBox:add_option(player.Name)
        end
    end
    
    targetCount:set("Targets: " .. #getgenv().Lists.TargetList)
    whitelistCount:set("Whitelist: " .. #getgenv().Lists.Whitelist)
end
local function updateCounts()
    targetCount:set("Targets: " .. #getgenv().Lists.TargetList)
    whitelistCount:set("Whitelist: " .. #getgenv().Lists.Whitelist)
end

task.spawn(function()
    while task.wait(1) do
        updateCounts()
    end
end)
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        playersBox:add_option(player.Name)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        playersBox:add_option(player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    playersBox:remove_option(player.Name)
end)

local function updatePlayerInfo()
    local selected = library.flags.players_online or {}
    local name = selected[1]
    
    if not name then
        selectedName:set("Selected: None")
        playerTeam:set("Team: -")
        playerHealth:set("Health: -")
        playerDistance:set("Distance: -")
        playerStatus:set("Status: -")
        return
    end
    
    local player = Players:FindFirstChild(name)
    if not player then
        selectedName:set("Selected: " .. name .. " (Off)")
        playerTeam:set("Team: -")
        playerHealth:set("Health: -")
        playerDistance:set("Distance: -")
        playerStatus:set("Status: Offline")
        return
    end
    
    selectedName:set("Selected: " .. player.Name)
    
    if player.Team then
        playerTeam:set("Team: " .. tostring(player.Team))
    else
        playerTeam:set("Team: None")
    end
    
    local char = player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            playerHealth:set(string.format("Health: %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth)))
        else
            playerHealth:set("Health: -")
        end
        
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local theirRoot = char:FindFirstChild("HumanoidRootPart")
        
        if myRoot and theirRoot then
            local dist = (myRoot.Position - theirRoot.Position).Magnitude
            playerDistance:set(string.format("Distance: %d", math.floor(dist)))
        else
            playerDistance:set("Distance: -")
        end
        
        playerStatus:set("Status: Alive")
    else
        playerHealth:set("Health: -")
        playerDistance:set("Distance: -")
        playerStatus:set("Status: Dead")
    end
end

RunService.RenderStepped:Connect(function()
    updatePlayerInfo()
end)

task.spawn(function()
    task.wait(2)
    updatePlayerList()
    while task.wait(5) do
        updatePlayerList()
    end
end)

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
local library = {
    directory = "Nebula/",
    folders = {"fonts", "configs", "logs"},
    flags = {},
    config_flags = {},
    notifications = {}
}

library.__index = library
setmetatable(library, library)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

local flags = library.flags 
local config_flags = library.config_flags
local notifications = library.notifications 

if isfile(library.directory .. "/fonts/main.ttf") then 
    delfile(library.directory .. "/fonts/main.ttf")
end

writefile(library.directory .. "/fonts/main.ttf", game:HttpGet("https://github.com/f1nobe7650/Nebula/raw/refs/heads/main/Minecraftia-Regular.ttf"))

local minecraftia = {
    name = "Minecraftia",
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
    writefile(library.directory .. "/fonts/main_encoded.ttf", HttpService:JSONEncode(minecraftia))
end

library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)

local MAX_DISTANCE = 1000
local BILLBOARD_OFFSET = Vector3.new(0, 3, 0)

local espBillboards = {}
local characterCache = {}

local visualPage = window:new_page({
    name = "Visual"
})

local espSection = visualPage:new_section({
    name = "ESP Settings",
    side = "left",
    size = 250
})

local espToggle = espSection:new_toggle({
    name = "Enable ESP",
    state = true,
    flag = "esp_enabled",
    callback = function(state)
        library.flags.esp_enabled = state
    end
})

local espColor = espToggle:new_colorpicker({
    default = Color3.fromRGB(255, 50, 50),
    flag = "esp_maincolor",
    callback = function(color)
        library.flags.esp_maincolor = color
    end
})

local maxDistanceSlider = espSection:new_slider({
    name = "Max Distance",
    min = 100,
    max = 5000,
    default = 1000,
    text = "[value] studs",
    flag = "esp_maxdistance",
    callback = function(value)
        library.flags.esp_maxdistance = value
    end
})

local teamCheckToggle = espSection:new_toggle({
    name = "Team Check",
    state = false,
    flag = "esp_teamcheck",
    callback = function(state)
        library.flags.esp_teamcheck = state
    end
})

local whitelistColorToggle = espSection:new_toggle({
    name = "Whitelist Color",
    state = true,
    flag = "esp_usewhitelistcolor",
    callback = function(state)
        library.flags.esp_usewhitelistcolor = state
    end
})

local whitelistColor = whitelistColorToggle:new_colorpicker({
    default = Color3.fromRGB(50, 255, 50),
    flag = "esp_whitelistcolor",
    callback = function(color)
        library.flags.esp_whitelistcolor = color
    end
})

local targetlistColorToggle = espSection:new_toggle({
    name = "Targetlist Color",
    state = true,
    flag = "esp_usetargetlistcolor",
    callback = function(state)
        library.flags.esp_usetargetlistcolor = state
    end
})

local targetlistColor = targetlistColorToggle:new_colorpicker({
    default = Color3.fromRGB(255, 50, 255),
    flag = "esp_targetlistcolor",
    callback = function(color)
        library.flags.esp_targetlistcolor = color
    end
})

local espSettingsSection = visualPage:new_section({
    name = "ESP Features",
    side = "right",
    size = 200
})

local showDistanceToggle = espSettingsSection:new_toggle({
    name = "Show Distance",
    state = true,
    flag = "esp_showdistance",
    callback = function(state)
        library.flags.esp_showdistance = state
    end
})

local showHealthToggle = espSettingsSection:new_toggle({
    name = "Show Health",
    state = true,
    flag = "esp_showhealth",
    callback = function(state)
        library.flags.esp_showhealth = state
    end
})

local dynamicScalingToggle = espSettingsSection:new_toggle({
    name = "Dynamic Scaling",
    state = true,
    flag = "esp_dynamicscaling",
    callback = function(state)
        library.flags.esp_dynamicscaling = state
    end
})

local function getPlayerColor(player)
    local targetList = getgenv().Lists.TargetList or {}
    local whitelist = getgenv().Lists.Whitelist or {}
    
    if table.find(targetList, player.Name) and library.flags.esp_usetargetlistcolor then
        return library.flags.esp_targetlistcolor
    end
    
    if table.find(whitelist, player.Name) and library.flags.esp_usewhitelistcolor then
        return library.flags.esp_whitelistcolor
    end
    
    return library.flags.esp_maincolor
end

local function createESPBillboard(player)
    if player == LocalPlayer then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_ESP"
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = BILLBOARD_OFFSET
    billboard.Adornee = nil
    billboard.Enabled = false
    billboard.MaxDistance = library.flags.esp_maxdistance or MAX_DISTANCE
    
    local frame = Instance.new("Frame")
    frame.Name = "Container"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Parent = billboard
    
    billboard.Parent = Camera
    
    espBillboards[player] = billboard
    characterCache[player] = nil
end

local function updateESPBillboard(player, character)
    if not library.flags.esp_enabled then return end
    
    local billboard = espBillboards[player]
    if not billboard or not character then return end
    
    if library.flags.esp_teamcheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        billboard.Enabled = false
        billboard.Adornee = nil
        return
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not head or not humanoidRootPart then
        billboard.Enabled = false
        billboard.Adornee = nil
        return
    end
    
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    
    if not localRoot then
        billboard.Enabled = false
        billboard.Adornee = nil
        return
    end
    
    local distance = (head.Position - localRoot.Position).Magnitude
    local maxDistance = library.flags.esp_maxdistance or MAX_DISTANCE
    
    if distance > maxDistance then
        billboard.Enabled = false
        billboard.Adornee = nil
        return
    end
    
    billboard.MaxDistance = maxDistance
    billboard.Adornee = head
    billboard.Enabled = true
    
    local playerColor = getPlayerColor(player)
    local health = math.floor(humanoid.Health)
    local maxHealth = math.floor(humanoid.MaxHealth)
    local healthPercent = math.floor((health / maxHealth) * 100)
    
    local healthColor = Color3.fromRGB(255, 255, 255)
    if healthPercent > 50 then
        healthColor = Color3.fromRGB(0, 255, 0)
    elseif healthPercent > 25 then
        healthColor = Color3.fromRGB(255, 255, 0)
    else
        healthColor = Color3.fromRGB(255, 0, 0)
    end
    
    local baseSize = 13
    local textSize = baseSize
    
    if library.flags.esp_dynamicscaling then
        local distanceFactor = math.clamp(distance / 100, 0.5, 2.0)
        textSize = baseSize / distanceFactor
        textSize = math.max(8, math.min(20, textSize))
    end
    
    local container = billboard.Container
    
    for _, child in ipairs(container:GetChildren()) do
        child:Destroy()
    end
    
    local labels = {}
    
    if library.flags.esp_showdistance then
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "DistanceLabel"
        distanceLabel.Text = "(" .. math.floor(distance) .. ")"
        distanceLabel.TextColor3 = playerColor
        distanceLabel.TextSize = textSize
        distanceLabel.FontFace = library.font
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Size = UDim2.new(0, 0, 1, 0)
        distanceLabel.AutomaticSize = Enum.AutomaticSize.X
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(labels, distanceLabel)
    end
    
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "UsernameLabel"
    usernameLabel.Text = " " .. player.Name .. " "
    usernameLabel.TextColor3 = playerColor
    usernameLabel.TextSize = textSize
    usernameLabel.FontFace = library.font
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Size = UDim2.new(0, 0, 1, 0)
    usernameLabel.AutomaticSize = Enum.AutomaticSize.X
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(labels, usernameLabel)
    
    if library.flags.esp_showhealth then
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "HealthLabel"
        healthLabel.Text = "[" .. health .. "]"
        healthLabel.TextColor3 = healthColor
        healthLabel.TextSize = textSize
        healthLabel.FontFace = library.font
        healthLabel.BackgroundTransparency = 1
        healthLabel.Size = UDim2.new(0, 0, 1, 0)
        healthLabel.AutomaticSize = Enum.AutomaticSize.X
        healthLabel.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(labels, healthLabel)
    end
    
    local totalWidth = 0
    for i, label in ipairs(labels) do
        label.Parent = container
        label.Position = UDim2.new(0, totalWidth, 0, 0)
        totalWidth = totalWidth + label.AbsoluteSize.X
    end
    
    billboard.Size = UDim2.new(0, totalWidth + 10, 0, 40)
end

local function onPlayerAdded(player)
    createESPBillboard(player)
    
    player.CharacterAdded:Connect(function(character)
        characterCache[player] = character
        character:WaitForChild("Humanoid")
        character:WaitForChild("Head")
    end)
    
    if player.Character then
        characterCache[player] = player.Character
    end
end

local function onPlayerRemoving(player)
    local billboard = espBillboards[player]
    if billboard then
        billboard:Destroy()
        espBillboards[player] = nil
    end
    characterCache[player] = nil
end

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

RunService.RenderStepped:Connect(function()
    if not library.flags.esp_enabled then
        for player, billboard in pairs(espBillboards) do
            billboard.Enabled = false
        end
        return
    end
    
    for player, billboard in pairs(espBillboards) do
        local character = characterCache[player] or player.Character
        if character then
            updateESPBillboard(player, character)
        else
            billboard.Enabled = false
            billboard.Adornee = nil
        end
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    for _, billboard in pairs(espBillboards) do
        billboard:Destroy()
    end
    espBillboards = {}
    characterCache = {}
end)

print("Nebula Nametag ESP Loaded")
