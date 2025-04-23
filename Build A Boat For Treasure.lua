local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Wilson Hub | BABFT",
    Icon = 0,
    LoadingTitle = "Wilson Hub",
    LoadingSubtitle = "by Wilson",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "WilsonHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local HomeTab = Window:CreateTab("Home", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

local autoFarm = false
local goldFarm = false
local cycles = 0
local goldInicio = game:GetService("Players").localPlayer.Data.Gold.Value
local goldActual = goldInicio

local function notify(text)
    Rayfield:Notify({
        Title = "Wilson Hub",
        Content = text,
        Duration = 6.5,
        Image = 4483362458
    })
end

HomeTab:CreateButton({
    Name = "Cerrar GUI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local Section = AutoTab:CreateSection("Auto Farm")

AutoTab:CreateToggle({
    Name = "Auto Farm Gold",
    Default = false,
    Callback = function(state)
        autoFarm = state
        notify("Auto Farm Gold " .. (state and "Activado" or "Desactivado"))

        if not state then
            if isFarming then
                autoFarmStopRequested = true
                Rayfield:Notify({
                    Title = "Anti-Breaker",
                    Content = "¡Has desactivado en medio de un ciclo! Espera hasta que el ciclo actual termine...",
                    Duration = 6,
                    Image = 4483362458,
                })
            end
            return
        end

        task.spawn(function()
            while autoFarm do
                isFarming = true
                autoFarmStopRequested = false

                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                local function getStagePart(stageNum)
                    local path = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage" .. stageNum)
                    return path and path:FindFirstChild("DarknessPart")
                end

                local function flotarEnStage(stageNum)
                    local part = getStagePart(stageNum)
                    if not part then return false end

                    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))

                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "GoldFloat" .. stageNum
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(0, 100000, 0)
                    bv.P = 1250
                    bv.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Gold",
                        Content = "Flotando en CaveStage" .. stageNum .. "...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    task.wait(3)

                    if hrp:FindFirstChild(bv.Name) then
                        hrp[bv.Name]:Destroy()
                    end

                    return true
                end

                -- Recorre del 1 al 10
                for i = 1, 10 do
                    local ok = flotarEnStage(i)
                    if not ok then
                        Rayfield:Notify({
                            Title = "Auto Farm Gold",
                            Content = "No se encontró DarknessPart en CaveStage" .. i,
                            Duration = 5,
                            Image = 4483362458,
                        })
                        break
                    end
                end

                -- Cofre
                local chestPos = Vector3.new(-55.706512, -358.7396, 9492.3564)
                hrp.CFrame = CFrame.new(chestPos)
                Rayfield:Notify({
                    Title = "Auto Farm Gold",
                    Content = "Teletransportado al cofre.",
                    Duration = 4,
                    Image = 4483362458,
                })

                task.wait(20)

                isFarming = false

                -- Si el jugador pidió detener el ciclo, salimos
                if autoFarmStopRequested then
                    autoFarm = false
                    break
                end
            end
        end)
    end,
})

AutoTab:CreateToggle({
    Name = "Gold Block Farm",
    Default = false,
    Callback = function(state)
        goldFarm = state
        notify("Gold Block Farm " .. (state and "Activado" or "Desactivado"))
        local continueCycle = true

        task.spawn(function()
            while goldFarm or continueCycle do
                continueCycle = false -- solo si el ciclo se inicia
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                local function GoldBlockFarm()
                    local stage10Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage10")
                        and workspace.BoatStages.NormalStages.CaveStage10:FindFirstChild("DarknessPart")
                    local stage1Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage1")
                        and workspace.BoatStages.NormalStages.CaveStage1:FindFirstChild("DarknessPart")

                    if not stage10Part or not stage1Part then
                        Rayfield:Notify({
                            Title = "Gold Block Farm",
                            Content = "No se encontró DarknessPart en CaveStage10 o CaveStage1.",
                            Duration = 5,
                            Image = 4483362458,
                        })
                        return
                    end

                    hrp.CFrame = CFrame.new(stage1Part.Position + Vector3.new(0, 5, 0))

                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(0, 100000, 0)
                    bv.P = 1250
                    bv.Name = "GoldFloat"
                    bv.Parent = hrp

                    Rayfield:Notify({
                        Title = "Gold Block Farm",
                        Content = "Flotando en CaveStage1...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    task.wait(3)

                    if hrp:FindFirstChild("GoldFloat") then
                        hrp.GoldFloat:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage10Part.Position + Vector3.new(0, 5, 0))

                    local bv2 = Instance.new("BodyVelocity")
                    bv2.Velocity = Vector3.new(0, 0, 0)
                    bv2.MaxForce = Vector3.new(0, 100000, 0)
                    bv2.P = 1250
                    bv2.Name = "GoldFloat2"
                    bv2.Parent = hrp

                    Rayfield:Notify({
                        Title = "Gold Block Farm",
                        Content = "Flotando en CaveStage10...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    task.wait(3)

                    if hrp:FindFirstChild("GoldFloat2") then
                        hrp.GoldFloat2:Destroy()
                    end

                    local chestPos = Vector3.new(-55.706512, -358.7396, 9492.3564)
                    hrp.CFrame = CFrame.new(chestPos)

                    Rayfield:Notify({
                        Title = "Gold Block Farm",
                        Content = "Teletransportado al cofre.",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    task.wait(20)
                end

                if goldFarm then
                    continueCycle = true
                    GoldBlockFarm()
                else
                    Rayfield:Notify({
                        Title = "Gold Block Farm",
                        Content = "¡Has desactivado en medio de un ciclo! Espera hasta que el ciclo actual termine...",
                        Duration = 6,
                        Image = 4483362458,
                    })
                    GoldBlockFarm()
                end
            end
        end)
    end,
})

local Section = AutoTab:CreateSection("Anti AFK")

AutoTab:CreateToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(state)
        if state then
            -- Activar Anti-AFK
            getgenv().AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)

            Rayfield:Notify({
                Title = "Wilson Hub",
                Content = "Anti-AFK Activado",
                Duration = 4,
            })
        else
            -- Desactivar Anti-AFK
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end

            Rayfield:Notify({
                Title = "Wilson Hub",
                Content = "Anti-AFK Desactivado",
                Duration = 4,
            })
        end
    end
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gold = player:WaitForChild("Data"):WaitForChild("Gold")

local oroInicial = gold.Value

local Section = AutoTab:CreateSection("Oro")
local labelOroInicial = AutoTab:CreateLabel("Oro Inicial: " .. tostring(oroInicial))
local labelOroActual = AutoTab:CreateLabel("Oro Actual: " .. tostring(gold.Value))
local labelOroGanado = AutoTab:CreateLabel("Oro Ganado: 0")

task.spawn(function()
    while true do
        pcall(function()
            local oroActual = gold.Value
            local oroGanado = oroActual - oroInicial

            labelOroActual:Set("Oro Actual: " .. tostring(oroActual))
            labelOroGanado:Set("Oro Ganado: " .. tostring(oroGanado))
        end)
        task.wait(1)
    end
end)

MoveTab:CreateSlider({
    Name = "Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "WalkSpeed",
    CurrentValue = 16,
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

MoveTab:CreateSlider({
    Name = "PowerJump",
    Range = {50, 200},
    Increment = 1,
    Suffix = "salto",  
    CurrentValue = 50,  
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if humanoid then
            humanoid.UseJumpPower = true  
            humanoid.JumpPower = value
        else
            warn("No se pudo encontrar el 'Humanoid'")
        end
    end
})

CreditsTab:CreateLabel("Creado por: Wilson")
CreditsTab:CreateLabel("Colaboradores: nil")
local player = game.Players.LocalPlayer
local ThemeDropdown = HomeTab:CreateDropdown({
    Name = "Seleccionar Tema",
    Options = {
        "Default",
        "AmberGlow",
        "Amethyst",
        "Bloom",
        "DarkBlue",
        "Green",
        "Light",
        "Ocean",
        "Serenity"
    },
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "ThemeSelector",
    Callback = function(selection)
        local theme = selection[1]
        Window.ModifyTheme(theme)
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local goldBlock = LocalPlayer:WaitForChild("Data"):WaitForChild("GoldBlock")


local bloquesIniciales = goldBlock.Value

local Section = AutoTab:CreateSection("Bloques de Oro")
local labelInicial = AutoTab:CreateLabel("Bloques Iniciales: " .. tostring(bloquesIniciales))
local labelActual = AutoTab:CreateLabel("Bloques Actuales: " .. tostring(goldBlock.Value))
local labelGanados = AutoTab:CreateLabel("Bloques Ganados: 0")

task.spawn(function()
    while true do
        pcall(function()
            local actuales = goldBlock.Value
            local ganados = actuales - bloquesIniciales

            labelActual:Set("Bloques Actuales: " .. tostring(actuales))
            labelGanados:Set("Bloques Ganados: " .. tostring(ganados))
        end)
        task.wait(1)
    end
end)

TeleportTab:CreateSection("Zonas Disponibles")

TeleportTab:CreateButton({
    Name = "Team Blanco",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(-49.6, -9.7, -606.6))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Rojo",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(482.4, -9.7, -64.4))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Negro",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(-589.3, -9.7, -69.2))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Azul",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(482.2, 9.7, 300.3))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Camo",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(-589.4, -9.7, 293.6))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Magenta",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(481.9, -9.7, 647.1))
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Team Amarillo",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(Vector3.new(-589.0, -9.7, 640.5))
        end
    end,
})

local infiniteJump = false

local function getHumanoid()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    return character:FindFirstChildWhichIsA("Humanoid")
end

MoveTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        infiniteJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJump then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local noclip = false

local function applyNoclip()
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

MoveTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        noclip = state
    end
})

RunService.Stepped:Connect(function()
    if noclip then
        applyNoclip()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if noclip then
        task.wait(1) 
        applyNoclip()
    end
end)
