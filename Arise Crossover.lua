local repo         = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library      = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Wilson Hub",
    Footer = "v: 0.1a | UI: Obsidian UI",
    Center = true,
    AutoShow = true,
    Resizable = false,
    ShowCustomCursor = false,
    Size = UDim2.fromOffset(540, 420),
    CornerRadius = 14,
})

local Tabs = {
    Main      = Window:AddTab("Main",       "house"),
    Teleports = Window:AddTab("Islands",  "tree-palm"),
    Misc      = Window:AddTab("Misc",  "waypoints"),
    Settings  = Window:AddTab("Configuraciones", "settings"),
}
local AutoFarmSection = Tabs.Main:AddLeftGroupbox("Auto Farmear Enemigos")
local SpecialSection = Tabs.Main:AddRightGroupbox("Special Enemies")
local AutoNearestSection = Tabs.Main:AddRightGroupbox("Auto Farm Nearest")
local Mounts = Tabs.Teleports:AddLeftGroupbox("Ubicación de Monturas")
local CloseGUI = Tabs.Settings:AddLeftGroupbox("Cerrar GUI")
local Spawns = Tabs.Teleports:AddRightGroupbox("Puntos de Spawn")
local Webhook = Tabs.Misc:AddRightGroupbox("Webhook")
local UIScale = Tabs.Settings:AddRightGroupbox("Escala de la UI")
local UIToggle = Tabs.Settings:AddLeftGroupbox("UI Toggle Keybind")
local Autos = Tabs.Main:AddRightGroupbox("Activar Autos")
local RaidIslands = Tabs.Teleports:AddRightGroupbox("Raid Islands")
local AutoDungeonSection = Tabs.Main:AddLeftGroupbox("Auto Dungeon")
local LocalPlayer = Tabs.Misc:AddLeftGroupbox("Local Player")

local enemyMapping = {
    SL1  = "Soondoo";      SLB1 = "Brute Soondoo";
    SL2  = "Gonshee";      SLB2 = "Brute Gonshee";
    SL3  = "Daek";         SLB3 = "Brute Daek";
    SL4  = "Longin";       SLB4 = "Brute Longin";
    SL5  = "Anders";       SLB5 = "Brute Anders";
    SL6  = "Largalgan";    SLB6 = "Brute Largalgan";
    NR1  = "Snake Man";    NRB1 = "Brute Snake Man"; NRB2 = "Brute Blossom"; NR2 = "Blossom"; NR3 = "Black Crow"; NRB3 = "Brute Black Crow";
    OP1  = "Shark Man";    OPB1 = "Brute Shark Man"; OP2 = "Eminel"; OPB2 = "Brute Eminel"; OP3 = "Light Admiral"; OPM3 = "Brute Light Admiral";
    BL1  = "Luryu";        BLB1 = "Brute Luryu"; BL2 = "Fyakuya"; BLB2 = "Brute Fyakuya"; BL3 = "Genji"; BLB3 = "Brute Genji";
    BC1  = "Sortudo";      BCB1 = "Brute Sortudo"; BC2 = "Michille"; BCB2 = "Brute Michille"; BC3 = "Wind"; BC3 = "Brute Wind";
    CH1  = "Heaven";       CHB1 = "Brute Heaven"; CH2 = "Zere"; CHB2 = "Brute Zere"; CH3 = "Ika"; CHB3 = "Brute Ika";
    JB1  = "Diablo";       JBB1 = "Brute Diablo"; JB2 = "Golyne"; JBB2 = "Brute Golyne"; JB3 = "Gosuke"; JBB3 = "Brute Gosuke";
    DB1  = "Turtle";       DBB1 = "Brute Turtle"; DB2 = "Green"; DBB2 = "Brute Green"; DB3 = "Sky"; DBB3 = "Brute Sky";
    OPM1 = "Rider";        OPMB1 = "Brute Rider"; OPM2 = "Hurricane"; OPMB2= "Brute Hurricane"; OPM3 = "Cyborg"; OPMB3= "Brute Cyborg";
    DAM1 = "Shrimp";       DAMB1 = "Brute Shrimp"; DAM2 = "Baira"; DAMB2 = "Brute Baira"; DAM3 = "Lomo"; DAMB3 = "Brute Lomo";
}
local ServerRoot        = workspace:WaitForChild("__Main"):WaitForChild("__Enemies"):WaitForChild("Server")
local selectedEnemyId   = nil
local displayToId       = {}
AutoFarmSection:AddLabel({
    Text = "Si te mueves no salgas del Circulo Rojo del enemigo o el jugador no atacará.",
    DoesWrap = true
})
local sendWebhookKilled = false  
local sendWebhookAutoFarm = false
local function guiClosedWebhook(title, description, color)
    local webhookURL = getgenv().UserWebhook
    if not webhookURL then return end

    local HttpService = game:GetService("HttpService")
    local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not request then return end

    local data = {
        embeds = {{
            title = title,
            description = description,
            color = color or 5814783, 
            footer = {
                text = "Wilson Hub | Roblox",
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") 
        }},
        username = "Wilson Hub",
        avatar_url = "https://i.imgur.com/v9C3h5S.png" 
    }

    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end
Webhook:AddLabel({
    Text = "Mandar Webhook si:",
    DoesWrap = true
})
Webhook:AddToggle("Enemigo Asesinado", { 
    Default = false,  
    Text = "Matas un Enemigo",  
    Callback = function(v)
        sendWebhookKilled = v  
    end
})
Webhook:AddToggle("Cambiar Cosas", { 
    Default = false,  
    Text = "Activas/Desactivas \nun toggle",  
    Callback = function(v)
        sendWebhookAutoFarm = v  
    end
})

local selectedEnemy = nil  
local killCount = 0  

local function enemyKilled()
    local webhookURL = getgenv().UserWebhook
    if not webhookURL or webhookURL == "" then return end  
    if not sendWebhookKilled then return end  

    local username = game.Players.LocalPlayer.Name  
    local currentTime = os.date("%H:%M:%S")  

    local autoAriseStatus = autoAriseEnabled and ":white_check_mark:" or ":x:"
    local autoDestroyStatus = autoDestroyEnabled and ":white_check_mark:" or ":x:"
    local autoSendPetsStatus = autoSendPetsEnabled and ":white_check_mark:" or ":x:"

    killCount = killCount + 1

    local data = {
        username = "Wilson Hub",
        avatar_url = "https://i.imgur.com/6sgt1tC.png",
        embeds = {{
            title = "⚰️ ¡Has eliminado un enemigo!",
            description = table.concat({
                "👤  **Usuario -->** ||" .. username .. "||",
                "🕒  **Hora -->** `" .. currentTime .. "`",
                "🎯  **Enemigo Eliminado -->** " .. (selectedEnemy or "Ningún enemigo"),
                "📊  **Total Eliminados -->** `" .. killCount .. "`",
                "⚙️  **Toggles Activos:**",
                "Auto Arise: " .. autoAriseStatus, 
                "Auto Destroy: " .. autoDestroyStatus,
                "Auto Send Pets: " .. autoSendPetsStatus
            }, "\n"),
            color = 0xE74C3C,  
            footer = { text = "Wilson Hub | Arise Crossover" },  
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")  
        }}
    }

    local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    local webhookURL = getgenv().UserWebhook
    if not webhookURL or webhookURL == "" then return end
    if not sendWebhookAutoFarm then return end

    local username = Players.LocalPlayer.Name
    local currentTime = os.date("%H:%M:%S")

    local autoFarmStatus = autoFarmEnabled and ":white_check_mark:" or ":x:"
    local autoAriseStatus = autoAriseEnabled and ":white_check_mark:" or ":x:"
    local autoDestroyStatus = autoDestroyEnabled and ":white_check_mark:" or ":x:"
    local autoSendPetsStatus = autoSendPetsEnabled and ":white_check_mark:" or ":x:"

    local data = {
        username = "Wilson Hub",
        avatar_url = "https://i.imgur.com/6sgt1tC.png",
        embeds = { {
            title = "🔧 ¡Cambiaron opciones en el Auto Farm!",
            description = table.concat({
                "👤  **Usuario --> ** ||" .. username .. "||",
                "       ",
                "🕒  **Momento del cambio --> ** `" .. currentTime .. "`",
                "       ",
                "⚙️  **Extras**:",
                "       ",
                "🚀  **Auto Farm --> ** " .. autoFarmStatus,
                "🚀  **Auto Arise --> ** " .. autoAriseStatus,
                "💥  **Auto Destruy --> ** " .. autoDestroyStatus,
                "🐾  **Auto Send Pets --> ** " .. autoSendPetsStatus,
                "🎯  **Enemigo Seleccionado --> ** " .. (selectedEnemy or "Ningún Enemigo")
            }, "\n"),
            color = 0xf39c12,
            footer = {
                text = "Wilson Hub | Arise Crossover"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        } }
    }

    local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end
end


local autoFarmEnabled = false
local autoAriseEnabled = false
local autoDestroyEnabled = false
local autoSendPetsEnabled = false

local enemyDropdown = AutoFarmSection:AddDropdown("EnemyDropdown", {
    Values  = {"Cargando..."},
    Default = "Cargando...",
    Multi   = false,
    Text    = "Seleccionar enemigo",
    Tooltip = "Se actualiza cada 0.5s según islas activas",
    Callback = function(option)
        selectedEnemyId = displayToId[option] 
        selectedEnemy = (option)
        sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    end,
})

AutoFarmSection:AddToggle("AutoFarmToggle", {
    Text    = "Auto Farm",
    Default = false,
    Callback = function(v)
        autoFarmEnabled = v
        sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    end,
})

AutoFarmSection:AddToggle("AutoAriseToggle", {
    Text    = "Auto Arise",
    Default = false,
    Callback = function(v)
        autoAriseEnabled = v
        sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    end,
})

AutoFarmSection:AddToggle("AutoDestroyToggle", {
    Text    = "Auto Destroy",
    Default = false,
    Callback = function(v)
        autoDestroyEnabled = v
        sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    end,
})

AutoFarmSection:AddToggle("AutoSendPetsToggle", {
    Text    = "Auto Send Pets",
    Default = false,
    Callback = function(v)
        autoSendPetsEnabled = v
        sendFeatureWebhook(autoFarmEnabled, autoAriseEnabled, autoDestroyEnabled, autoSendPetsEnabled)
    end,
})

local function getActiveEnemyIds()
    local active, seen = {}, {}
    for i = 1, 10 do
        local folder = ServerRoot:FindFirstChild(tostring(i))
        if folder then
            for _, e in ipairs(folder:GetChildren()) do
                local id = e:GetAttribute("Id")
                if id and not e:GetAttribute("Dead") and enemyMapping[id] and not seen[id] then
                    table.insert(active, {id = id, island = i})
                    seen[id] = true
                end
            end
        end
    end
    return active
end

task.spawn(function()
    while true do
        local active = getActiveEnemyIds()
        local names = {}
        displayToId = {}
        for _, rec in ipairs(active) do
            local label = string.format("%s (Isla %d)", enemyMapping[rec.id], rec.island)
            table.insert(names, label)
            displayToId[label] = rec.id
        end
        table.sort(names)
        enemyDropdown:SetValues(#names > 0 and names or {"Ningún enemigo activo"})
        task.wait(0.5)
    end
end)

local function tweenToPositionWithFixedSpeed(targetPart, speed)
    local TweenService = game:GetService("TweenService")
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local hrp = character:WaitForChild("HumanoidRootPart")
    local startPos = hrp.Position
    local targetPos = targetPart.Position + Vector3.new(5, 2, 0)  

    -- Calculamos la distancia
    local distance = (targetPos - startPos).Magnitude
    local travelTime = distance / speed  

    local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goalCFrame = CFrame.new(targetPos)

    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = goalCFrame})
    tween:Play()
    tween.Completed:Wait()
end

autolocalPetsSent = false

task.spawn(function()
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local dataRemote = ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

    while task.wait(0) do
        if autoFarmEnabled and selectedEnemyId then
            local foundEnemy = nil
            for i = 1, 10 do
                local folder = ServerRoot:FindFirstChild(tostring(i))
                if folder then
                    for _, e in ipairs(folder:GetChildren()) do
                        if e:GetAttribute("Id") == selectedEnemyId and not e:GetAttribute("Dead") then
                            foundEnemy = e
                            break
                        end
                    end
                end
                if foundEnemy then break end
            end

            if foundEnemy then
                autolocalPetsSent = false

                local success, err = pcall(function()
                    local player = Players.LocalPlayer
                    local char = player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                    local hrp = char.HumanoidRootPart
                    local part = foundEnemy:IsA("BasePart") and foundEnemy or foundEnemy:FindFirstChildWhichIsA("BasePart")
                    if not part then return end

                    local enemyName = foundEnemy.Name
                    local distance = (hrp.Position - part.Position).Magnitude

                    -- Moverse si está lejos
                    if distance > 5 then
                        tweenToPositionWithFixedSpeed(part, 200)
                    end

                    -- Bucle de ataque
                    local attackTimeout = 120
                    local elapsed = 0
                    while autoFarmEnabled and foundEnemy and not foundEnemy:GetAttribute("Dead") and elapsed < attackTimeout do
                        -- Atacar
                        local punchArgs = {{ { Event = "PunchAttack", Enemy = enemyName }, "\005" }}
                        dataRemote:FireServer(unpack(punchArgs))

                        -- Enviar mascotas una vez
                        if autoSendPetsEnabled and not autolocalPetsSent then
                            local petsFolder = player:FindFirstChild("leaderstats")
                                and player.leaderstats:FindFirstChild("Equips")
                                and player.leaderstats.Equips:FindFirstChild("Pets")

                            if petsFolder then
                                local petTable = {}
                                local count = 0
                                for petName in pairs(petsFolder:GetAttributes()) do
                                    if count < 4 then
                                        petTable[petName] = part.Position
                                        count += 1
                                    else
                                        break
                                    end
                                end

                                if next(petTable) then
                                    for _, suf in ipairs({"\006", "\009", "\008"}) do
                                        local args = {{
                                            {
                                                PetPos = petTable,
                                                AttackType = "All",
                                                Event = "Attack",
                                                Enemy = enemyName
                                            }, suf
                                        }}
                                        dataRemote:FireServer(unpack(args))
                                    end
                                    autolocalPetsSent = true
                                end
                            end
                        end

                        task.wait(0.01)
                        elapsed += 0.01
                    end

                    -- Al morir
                    if foundEnemy and foundEnemy:GetAttribute("Dead") then
                        -- Auto Arise
                        if autoAriseEnabled then
                            for i = 1, 3 do
                                local args = {{ { Event = "EnemyCapture", Enemy = enemyName }, "\005" }}
                                dataRemote:FireServer(unpack(args))
                                task.wait(0.5)
                            end
                        end

                        -- Auto Destroy
                        if autoDestroyEnabled then
                            for i = 1, 3 do
                                local args = {{ { Event = "EnemyDestroy", Enemy = enemyName }, "\005" }}
                                dataRemote:FireServer(unpack(args))
                                task.wait(0.5)
                            end
                        end

                        if enemyKilled then enemyKilled() end
                        task.wait(0.3)
                    end
                    autolocalPetsSent = false
                end)

                if not success then
                    warn("Error en Auto Farm:", err)
                    autolocalPetsSent = false
                end
            else
                task.wait(0.3)
            end
        end
    end
end)

local TeleportSection = Tabs.Teleports:AddLeftGroupbox("TP a Isla")

local worldMapping = {
    ["Lucky Kingdom"] = "BCWorld",
    ["Faceheal Town"] = "BleachWorld",
    ["Nipon City"] = "ChainsawWorld",
    ["Dragon City"] = "DBWorld",
    ["Mori Town"] = "JojoWorld",
    ["Grass Village"] = "NarutoWorld",
    ["XZ City"] = "OPMWorld",
    ["Brum Island"] = "OPWorld",
    ["Leveling City"] = "SoloWorld",
    ["Kindama City"] = "DanWorld",
}

local selectedWorld = "Leveling City"
local tpFolder = workspace:WaitForChild("__Extra"):WaitForChild("__Spawns")

local function teleportToPosition(targetPart)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    if not hrp or not targetPart then return end

    local maxAttempts = 20
    for i = 1, maxAttempts do
        hrp.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 0))
        task.wait(0.1)
        if (hrp.Position - targetPart.Position).Magnitude < 10 then
            break
        end
    end
    Library:Notify({
        Title = "Teletransporte",
        Description = "Has llegado a " .. selectedWorld,
        Time = 3
    })
end

-- Dropdown para seleccionar la isla
TeleportSection:AddDropdown("CFrame TP a Isla", {
    Values = {
        "None","Leveling City", "Grass Village", "Brum Island", "Faceheal Town",
        "Lucky Kingdom", "Nipon City", "Mori Town", "Dragon City", "XZ City", "Kindama City",
    },
    Default = selectedWorld,
    Callback = function(option)
        if type(option) == "string" then
            selectedWorld = option
            print("Isla seleccionada:", selectedWorld)
        else
            warn("No se seleccionó una isla válida.")
        end
    end
})

TeleportSection:AddButton("TP a la Isla", function()
    if type(selectedWorld) ~= "string" then return end
    local internalName = worldMapping[selectedWorld]
    
    if internalName then
        local target = tpFolder:FindFirstChild(internalName)
        if target and target:IsA("Part") then
            teleportToPosition(target)
        else
            Library:Notify({
                Title = "Error",
                Description = "No se pudo encontrar el spawn para " .. selectedWorld,
                Time = 3
            })
        end
    else
        Library:Notify({
            Title = "Error",
            Description = "No se encontró el mapeo para la isla seleccionada.",
            Time = 3
        })
    end
end)


Library:SetDPIScale(90)

local Button = CloseGUI:AddButton({
    Text = "Cerrar Gui",
    Func = function()
        Library:Unload()
        guiClosedWebhook("✅ ¡Wilson Hub Cerrado!", "**" .. game.Players.LocalPlayer.Name .. "** cerró el Hub exitosamente!", 65280)
    end,
    DoubleClick = false 
})
local spawnLocations = {
    { Name = "Leveling City", SpawnId = "SoloWorld" },
    { Name = "Grass Village", SpawnId = "NarutoWorld" },
    { Name = "Brum Island", SpawnId = "OPWorld" },
    { Name = "Faceheal Town", SpawnId = "BleachWorld" },
    { Name = "Lucky Kingdom", SpawnId = "BCWorld" },
    { Name = "Nipon City", SpawnId = "ChainsawWorld" },
    { Name = "Mori Town", SpawnId = "JojoWorld" },
    { Name = "Dragon City", SpawnId = "DBWorld" },
    { Name = "XZ City", SpawnId = "OPMWorld" },
    { Name = "Kindama City", SpawnId = "DanWorld" },
}

for _, location in ipairs(spawnLocations) do
    Spawns:AddButton({
        Text = location.Name,
        Func = function()
            local args = {
                {
                    {
                        Event = "ChangeSpawn",
                        Spawn = location.SpawnId
                    },
                    "\011"
                }
            }
            local rs = game:GetService("ReplicatedStorage")
            rs:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))

            local character = game.Players.LocalPlayer.Character
            if character then
                character:BreakJoints()
            end
        end,
        DoubleClick = false
    })
end


local Dropdown = UIScale:AddDropdown("Estableces Escala", {
    Values = {"50%", "75%", "85", "90% (Default)", "100%", "125%", "150%", "175%", "200%"},
    Default = "90% (Default)", 
    Multi = false,
    Text = "Establecer escala de UI",
    Tooltip = "Escala la UI dependiendo del valor.",
    Callback = function(Value)
        local scaleMap = {
            ["50%"] = 50,
            ["75%"] = 75,
            ["85%"] = 85,
            ["90% (Default)"] = 90,
            ["100%"] = 100,
            ["125%"] = 125,
            ["150%"] = 150,
            ["175%"] = 175,
            ["200%"] = 200
        }

        local scale = scaleMap[Value]
        if scale then
            Library:SetDPIScale(scale)
        end
    end
})
TeleportSection:AddLabel({
    Text = "¡Advertencia! Espera 15 segundos antes de hacer otro TP, ó sólo usa los Puntos de Spawn.",
    DoesWrap = true
})
Mounts:AddLabel({
    Text = "¡Advertencia! ¡Espera 15 segundos antes de realizar otro TP; o sino serás expulsado del juego!",
    DoesWrap = true
})
local orderedLocations = {
    { Name = "Ubicación de Montura 1", Position = Vector3.new(-665.16, 76.70, -3580.92) },
    { Name = "Ubicación de Montura 2", Position = Vector3.new(-5902.75, 95.28, 419.43) },
    { Name = "Ubicación de Montura 3", Position = Vector3.new(418.63, 54.08, 3371.15) },
    { Name = "Ubicación de Montura 4", Position = Vector3.new(4295.75, 55.51, -4734.79) },
    { Name = "Ubicación de Montura 5", Position = Vector3.new(-6160.19, 87.61, 5455.17) },
    { Name = "Ubicación de Montura 6", Position = Vector3.new(-5409.86, 47.02, -5470.46) },
    { Name = "Ubicación de Montura 7", Position = Vector3.new(3316.70, 63.43, 30.80) },
}

for _, loc in ipairs(orderedLocations) do
    Mounts:AddButton({
        Text = loc.Name,
        Func = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")

            local maxAttempts = 10
            for i = 1, maxAttempts do
                rootPart.CFrame = CFrame.new(loc.Position)
                task.wait(0.1)
                if (rootPart.Position - loc.Position).Magnitude < 10 then
                    break
                end
            end
        end,
        DoubleClick = false
    })
end

local UserInputService = game:GetService("UserInputService")

local MenuKeybind = UIToggle:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", {
        Default = "P",
        SyncToggleState = true,
        Mode = "Toggle",
        Text = "Menu keybind",
        NoUI = false,
        Callback = function(Value)
            Library:Toggle(Value)
        end,
        ChangedCallback = function(New)
        end,
    })

Autos:AddToggle("AutoAttackToggle", {
    Default = false,  
    Text = "Activar AutoAttack",  
    Callback = function(Value)
        local playerSettings = game:GetService("Players").LocalPlayer.Settings
        if playerSettings:GetAttribute("AutoAttack") == nil then
            playerSettings:SetAttribute("AutoAttack", false) 
        end
        playerSettings:SetAttribute("AutoAttack", Value)  
    end
})

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer.Name
getgenv().UserWebhook = nil

Webhook:AddInput("Crear Webhook", {
    Default = "",
    Numeric = false,
    Finished = true,
    Text = "Dicord Webhook",
    Tooltip = "Presiona Enter al finalizar.",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(Value)
        getgenv().UserWebhook = Value
    end,
})

local function SendWebhook()
    local webhookURL = getgenv().UserWebhook
    if not webhookURL or webhookURL == "" then return end

    local requestFunction = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
    if not requestFunction then return end

    local data = {
        username = "Wilson Hub",
        avatar_url = "https://i.imgur.com/6sgt1tC.png",
        embeds = {{
            title = "✅ ¡Conexión Completada!",
            description = ">>> Tu usuario: **||" .. player .. "||**\nDesde ahora recibirás notificaciónes desde nuestro Hub",
            color = 0x00ffcc,
            footer = {
                text = "Wilson Hub | Arise Crossover"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    requestFunction({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end

Webhook:AddButton("Webhook Test", {
    Text = "Attach (Test)",
    Func = SendWebhook
})
local JJ1ScaleMapping = { 
    ["1"]   = "Rank E Ant",
    ["1.1"] = "Rank D Ant",
    ["1.2"] = "Rank C Ant",
    ["1.3"] = "Rank B Ant",
    ["1.4"] = "Rank A Ant",
    ["1.5"] = "Rank S Ant",
}

local specialIdMapping = {
    JJ2 = "Royal Red Ant",
    JJ3 = "Ant Queen",
    WElf1 = "Elf Soldier",
    WElf2 = "High Elf",
    WIron = "Metal",
    WBear = "Snow Bear Soldier",
    WBoss = "Laruda",
    WBoss2 = "Snow",
}

local displayToSpecial = {}
local specialAutoFarmEnabled = false
local specialAutoAriseEnabled = false
local specialAutoDestroyEnabled = false
local specialAutoSendPetsEnabled = false

local selectedSpecialEnemy = nil
local selectedSpecialEnemyId = nil
local selectedSpecialScale = nil

-- Dropdown dinámico
local specialDropdown = SpecialSection:AddDropdown("SpecialEnemyDropdown", {
    Values  = {"Cargando..."},
    Default = "Cargando...",
    Multi   = false,
    Text    = "Seleccionar enemigo especial",
    Tooltip = "Incluye hormigas de rango y jefes especiales",
    Callback = function(option)
        local data = displayToSpecial[option]
        if data then
            selectedSpecialEnemy = option
            selectedSpecialEnemyId = data.Id
            selectedSpecialScale = data.Scale
        end
    end,
})

local function getSpecialEnemies()
    local out = {}
    displayToSpecial = {}
    local seenEnemies = {}  
    local server = workspace.__Main.__Enemies.Server

    for _, child in ipairs(server:GetChildren()) do
        if child:IsA("BasePart") then
            local id = child:GetAttribute("Id")
            if id == "JJ1" then
                local scale = tostring(child:GetAttribute("Scale") or "")
                local name = JJ1ScaleMapping[scale]
                if name and not seenEnemies[name] then  
                    table.insert(out, name)
                    displayToSpecial[name] = { Id = id, Scale = scale, Part = child }
                    seenEnemies[name] = true  
                end
            elseif specialIdMapping[id] then
                local name = specialIdMapping[id]
                if not seenEnemies[name] then  
                    table.insert(out, name)
                    displayToSpecial[name] = { Id = id, Part = child }
                    seenEnemies[name] = true  
                end
            end
        end
    end

    table.sort(out)
    return out
end

task.spawn(function()
    while true do
        local list = getSpecialEnemies()
        specialDropdown:SetValues(#list > 0 and list or {"Ningún especial"})
        task.wait(1)
    end
end)

-- Toggles
SpecialSection:AddToggle("SpecialAutoFarmToggle", {
    Text    = "Auto Farm",
    Default = false,
    Callback = function(v)
        specialAutoFarmEnabled = v
    end,
})
SpecialSection:AddToggle("SpecialAutoAriseToggle", {
    Text    = "Auto Arise",
    Default = false,
    Callback = function(v)
        specialAutoAriseEnabled = v
    end,
})
SpecialSection:AddToggle("SpecialAutoDestroyToggle", {
    Text    = "Auto Destroy",
    Default = false,
    Callback = function(v)
        specialAutoDestroyEnabled = v
    end,
})
SpecialSection:AddToggle("SpecialAutoSendPetsToggle", {
    Text    = "Auto Send Pets",
    Default = false,
    Callback = function(v)
        specialAutoSendPetsEnabled = v
    end,
})

task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local dataRemote = ReplicatedStorage:WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent")

    while task.wait(0) do
        if specialAutoFarmEnabled and selectedSpecialEnemyId then
            local data = displayToSpecial[selectedSpecialEnemy]
            if not data or not data.Part or not data.Part.Parent then continue end

            local foundEnemy = data.Part
            local specialPetsSent = false

            local success, err = pcall(function()
                local player = Players.LocalPlayer
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local hrp = char.HumanoidRootPart
                local part = foundEnemy
                local enemyName = foundEnemy.Name
                local distance = (hrp.Position - part.Position).Magnitude

                if distance > 5 then
                    tweenToPositionWithFixedSpeed(part, 200)
                end

                local attackTimeout = 120
                local elapsed = 0
                while specialAutoFarmEnabled and foundEnemy and not foundEnemy:GetAttribute("Dead") and elapsed < attackTimeout do
                    -- Atacar
                    local punchArgs = {{ { Event = "PunchAttack", Enemy = enemyName }, "\005" }}
                    dataRemote:FireServer(unpack(punchArgs))

                    -- Enviar mascotas una sola vez
                    if specialAutoSendPetsEnabled and not specialPetsSent then
                        local petsFolder = player:FindFirstChild("leaderstats")
                            and player.leaderstats:FindFirstChild("Equips")
                            and player.leaderstats.Equips:FindFirstChild("Pets")

                        if petsFolder then
                            local petTable = {}
                            local count = 0
                            for petName in pairs(petsFolder:GetAttributes()) do
                                if count < 4 then
                                    petTable[petName] = part.Position
                                    count += 1
                                else
                                    break
                                end
                            end

                            if next(petTable) then
                                for _, suf in ipairs({"\006", "\009", "\008"}) do
                                    local args = {{{
                                        PetPos = petTable,
                                        AttackType = "All",
                                        Event = "Attack",
                                        Enemy = enemyName
                                    }, suf}}
                                    dataRemote:FireServer(unpack(args))
                                end
                                specialPetsSent = true
                            end
                        end
                    end

                    task.wait(0.01)
                    elapsed += 0.01
                end

                -- Post-muerte
                if foundEnemy and foundEnemy:GetAttribute("Dead") then
                    if specialAutoAriseEnabled then
                        for i = 1, 3 do
                            local args = {{ { Event = "EnemyCapture", Enemy = enemyName }, "\005" }}
                            dataRemote:FireServer(unpack(args))
                            task.wait(0.5)
                        end
                    end

                    if specialAutoDestroyEnabled then
                        for i = 1, 3 do
                            local args = {{ { Event = "EnemyDestroy", Enemy = enemyName }, "\005" }}
                            dataRemote:FireServer(unpack(args))
                            task.wait(0.5)
                        end
                    end
                end
            end)

            if not success then
                warn("Error en Auto Farm Especial:", err)
            end
        end
    end
end)
local function teleportToPosition2(position)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    if not hrp or not position then return end

    local maxAttempts = 10
    for i = 1, maxAttempts do
        hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0)) 
        task.wait(0.1)
        if (hrp.Position - position).Magnitude < 10 then
            break
        end
    end

    Library:Notify({
        Title = "Teletransporte",
        Description = "Has llegado a " .. selectedWorld,
        Time = 3
    })
end

RaidIslands:AddButton({
    Text = "TP to Dedu Raid",
    Func = function()
        selectedWorld = "Dedu Island"
        teleportToPosition2(Vector3.new(3844.386474609375, 67.61009979248047, 3062.103271484375))
    end,
    Tooltip = "Teletranspórtate a Dedu Raid",
})
RaidIslands:AddButton({
    Text = "TP To Winter Raid",
    Func = function()
        selectedWorld = "Winter Raid"
        teleportToPosition2(Vector3.new(4931.25928, 35.7264633, -2154.27783, -0.644148529))
    end,
    Tooltip = "Teletranspórtate a Winter Raid",
})
local autoDungeonEnabled = false
local autoDungeonAriseEnabled = false
local autoDungeonDestroyEnabled = false
local dungeonPetsSent = false

AutoDungeonSection:AddToggle("AutoDungeon", {
    Text = "Auto Dungeon \nor Auto Castle",
    Default = false,
    Callback = function(Value)
        autoDungeonEnabled = Value

        if Value then
            task.spawn(function()
                while autoDungeonEnabled do
                    local enemies = workspace.__Main.__Enemies.Server:GetChildren()
                    local targetEnemy

                    for _, enemy in ipairs(enemies) do
                        if not enemy:GetAttribute("Dead") then
                            targetEnemy = enemy
                            break
                        end
                    end

                    if targetEnemy then
                        dungeonPetsSent = false

                        pcall(function()
                            local player = game.Players.LocalPlayer
                            local char = player.Character
                            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                            local hrp = char.HumanoidRootPart
                            local part = targetEnemy:IsA("BasePart") and targetEnemy or targetEnemy:FindFirstChildWhichIsA("BasePart")
                            if not part then return end

                            local enemyName = targetEnemy.Name
                            local distance = (hrp.Position - part.Position).Magnitude

                            if distance > 5 then
                                local speed = 1250
                                local travelTime = distance / speed
                                local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
                                local tween = game.TweenService:Create(hrp, tweenInfo, {
                                    CFrame = CFrame.new(part.Position + Vector3.new(5, 2, 0))
                                })
                                tween:Play()
                                tween.Completed:Wait()
                            end

                            local elapsed = 0
                            local attackTimeout = 120

                            while autoDungeonEnabled
                                  and targetEnemy
                                  and not targetEnemy:GetAttribute("Dead")
                                  and elapsed < attackTimeout do

                                local punchArgs = {{ { Event = "PunchAttack", Enemy = enemyName }, "\005" }}
                                game.ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(punchArgs))

                                if not dungeonPetsSent then
                                    local dungeonPetsFolder = player:FindFirstChild("leaderstats")
                                                              and player.leaderstats:FindFirstChild("Equips")
                                                              and player.leaderstats.Equips:FindFirstChild("Pets")
                                    if dungeonPetsFolder then
                                        local petTable = {}
                                        local count = 0

                                        for petName in pairs(dungeonPetsFolder:GetAttributes()) do
                                            if count < 4 then
                                                petTable[petName] = part.Position
                                                count += 1
                                            end
                                        end

                                        if next(petTable) then
                                            for _, suf in ipairs({"\006", "\009", "\008"}) do
                                                local args = {{
                                                    {
                                                        PetPos     = petTable,
                                                        AttackType = "All",
                                                        Event      = "Attack",
                                                        Enemy      = enemyName
                                                    },
                                                    suf
                                                }}
                                                game.ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(args))
                                            end
                                            dungeonPetsSent = true
                                        end
                                    end
                                end

                                task.wait(0.01)
                                elapsed += 0.01
                            end

                            if targetEnemy:GetAttribute("Dead") then
                                if autoDungeonAriseEnabled then
                                    for _ = 1, 3 do
                                        local ariseArgs = {{ { Event = "EnemyCapture", Enemy = enemyName }, "\005" }}
                                        game.ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(ariseArgs))
                                        task.wait(0.5)
                                    end
                                end

                                if autoDungeonDestroyEnabled then
                                    for _ = 1, 3 do
                                        local destroyArgs = {{ { Event = "EnemyDestroy", Enemy = enemyName }, "\005" }}
                                        game.ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer(unpack(destroyArgs))
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end)
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

AutoDungeonSection:AddToggle("AutoDungeonArise", {
    Text = "Auto Arise (Dungeon)",
    Default = false,
    Callback = function(Value)
        autoDungeonAriseEnabled = Value
    end
})

AutoDungeonSection:AddToggle("AutoDungeonDestroy", {
    Text = "Auto Destroy (Dungeon)",
    Default = false,
    Callback = function(Value)
        autoDungeonDestroyEnabled = Value
    end
})
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
end

local autoFarmNearestEnabled = false
local attackTimeout = 10

task.spawn(function()
    while true do
        if autoFarmNearestEnabled then
            local hrp = getHRP()
            if not hrp then task.wait(1) continue end

            local enemiesRoot = workspace.__Main.__Enemies.Server
            local nearestEnemy, minDistance = nil, math.huge

            for _, enemy in ipairs(enemiesRoot:GetChildren()) do
                if enemy:IsA("BasePart") and not enemy:GetAttribute("Dead") then
                    local dist = (hrp.Position - enemy.Position).Magnitude
                    if dist < minDistance then
                        nearestEnemy = enemy
                        minDistance = dist
                    end
                end
            end

            for i = 1, 10 do
                local island = enemiesRoot:FindFirstChild(tostring(i))
                if island then
                    for _, enemy in ipairs(island:GetChildren()) do
                        if enemy:IsA("BasePart") and not enemy:GetAttribute("Dead") then
                            local dist = (hrp.Position - enemy.Position).Magnitude
                            if dist < minDistance then
                                nearestEnemy = enemy
                                minDistance = dist
                            end
                        end
                    end
                end
            end

            if nearestEnemy and minDistance < 1000 then
                local enemyName = nearestEnemy.Name
                local targetCFrame = nearestEnemy.CFrame + Vector3.new(2, 2, 2)

                local tween = TweenService:Create(hrp, TweenInfo.new(0.4), { CFrame = targetCFrame })
                tween:Play()
                tween.Completed:Wait()

                local startTime = tick()
                while autoFarmNearestEnabled and nearestEnemy and nearestEnemy:IsDescendantOf(workspace)
                    and not nearestEnemy:GetAttribute("Dead")
                    and tick() - startTime < attackTimeout do

                    ReplicatedStorage.BridgeNet2.dataRemoteEvent:FireServer({
                        { Event = "PunchAttack", Enemy = enemyName }, "\005"
                    })

                    RunService.Heartbeat:Wait()
                end
            end
        end
        task.wait(0.1)
    end
end)

AutoNearestSection:AddToggle("AutoFarmNearest", {
    Text = "Auto Farm Nearest",
    Default = false,
    Tooltip = "This does not send pets.",
    Callback = function(Value)
        autoFarmNearestEnabled = Value
    end
})
local dwalkspeed = 28
local wsEnabled = false
LocalPlayer:AddInput("WalkSpeedInput", { 
    Text = "Set WalkSpeed",
    Default = "28",   
    Numeric = true,  
    Finished = false,
    EmptyReset = "28", 
    Tooltip = "Changes the Walkspeed of Player.",
    Placeholder = "Enter WalkSpeed...",
    Callback = function(Value)
        local numberValue = tonumber(Value)
        if numberValue then
            dwalkspeed = numberValue
            print("Nuevo valor de WalkSpeed:", dwalkspeed)
        else
            Library:Notify({
                Title = "Número Inválido",
                Description = "Ingrese un número válido por favor.",
                Time = 5
            })
        end
    end
})
LocalPlayer:AddToggle("dWalkspeed", { 
    Text = "Enable Walkspeed", 
    Default = false,
    Tooltip = "This enables WalkSpeed", 
    Callback = function(Value)
        wsEnabled = Value
    end
})
task.spawn(function()
    while true do
        if wsEnabled then
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= dwalkspeed then
                    humanoid.WalkSpeed = dwalkspeed
                end
            end
        end
        task.wait(0.01)
    end
end)
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.1)
    if wsEnabled then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = dwalkspeed
        end
    end
end)
local djumppower = 50 
local jpEnabled = false
LocalPlayer:AddInput("JumpPowerInput", { 
    Text = "Set JumpPower",
    Default = "50",   
    Numeric = true,  
    Finished = false,
    EmptyReset = true, 
    Tooltip = "Changes the JumpPower of Player.",
    Placeholder = "Enter JumpPower...",
    Callback = function(Value)
        local numberValue = tonumber(Value)
        if numberValue then
            djumppower = numberValue
            print("Nuevo valor de JumpPower:", djumppower)
        else
            Library:Notify({
                Title = "Número Inválido",
                Description = "Ingrese un número válido por favor.",
                Time = 5
            })
        end
    end
})
LocalPlayer:AddToggle("EnableJumpPower", { 
    Text = "Enable JumpPower", 
    Default = false,
    Tooltip = "Do a Double Jump for it to work.", 
    Callback = function(Value)
        jpEnabled = Value
    end
})
task.spawn(function()
    local notified = false
    while true do
        if jpEnabled then
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.JumpPower ~= djumppower then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = djumppower
                end
            end

            if not notified then
                Library:Notify({
                    Title = "Activado",
                    Description = "Haz un Double Jump para que sirva.",
                    Time = 5
                })
                notified = true
            end
        else
            notified = false 
        end
        task.wait(0.1)
    end
end)

-- Reaplicar tras respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.1)
    if jpEnabled then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = djumppower
        end
    end
end)
local dgravity = 196.2 
local gravityEnabled = false
LocalPlayer:AddInput("GravityInput", {
    Text = "Set Gravity",
    Default = tostring(dgravity),
    Numeric = true,
    Finished = false,
    EmptyReset = "196.2",
    Tooltip = "Modifica la gravedad global del juego.",
    Placeholder = "Ingresa gravedad...",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            dgravity = num
        else
            Library:Notify({
                Title = "Número inválido",
                Description = "Ingresa un número válido para gravedad.",
                Time = 5
            })
        end
    end
})
LocalPlayer:AddToggle("EnableGravity", {
    Text = "Enable Gravity",
    Default = false,
    Tooltip = "Activa la modificación de gravedad.",
    Callback = function(Value)
        gravityEnabled = Value
    end
})
task.spawn(function()
    while true do
        if gravityEnabled then
            if workspace.Gravity ~= dgravity then
                workspace.Gravity = dgravity
            end
        end
        task.wait(0.1)
    end
end)

Autos:AddToggle("AutoClickToggle", {
    Default = false,
    Text = "Activar AutoClick \n(Rápido)",
    Callback = function(Value)
        local player = game:GetService("Players").LocalPlayer
        local passes = player:WaitForChild("leaderstats"):WaitForChild("Passes")

        if player:GetAttribute("AutoClick") == nil then
            player:SetAttribute("AutoClick", false)
        end

        if passes:GetAttribute("AutoClicker") == nil then
            passes:SetAttribute("AutoClicker", false)
        end

        player:SetAttribute("AutoClick", Value)
        passes:SetAttribute("AutoClicker", Value)
    end
})
local noclipEnabled = false

LocalPlayer:AddToggle("NoclipToggle", {
    Default = false,
    Text = "Activar Noclip",
    Callback = function(Value)
        noclipEnabled = Value

        task.spawn(function()
            while noclipEnabled do
                local character = game.Players.LocalPlayer.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    local head = character:FindFirstChild("Head")

                    if hrp then hrp.CanCollide = false end
                    if torso then torso.CanCollide = false end
                    if head then head.CanCollide = false end
                end
                task.wait(0.01)
            end
        end)
    end
})
