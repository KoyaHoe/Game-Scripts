-- Cargar Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Crear ventana
local Window = Rayfield:CreateWindow({
    Name = "Wilson Hub | BABFT",
    Icon = 0,  -- Usa 0 para no usar íconos o pon el id de un ícono de Roblox
    LoadingTitle = "Wilson Hub",
    LoadingSubtitle = "by WsXN",
    Theme = "Default", -- Configuración del tema
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Carpeta personalizada para tu juego
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

-- Crear Tabs
local HomeTab = Window:CreateTab("Home", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local ExtrasTab = Window:CreateTab("Extras", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

-- Variables globales
local autoFarm = false
local goldFarm = false
local cycles = 0
local goldInicio = game:GetService("Players").localPlayer.Data.Gold.Value
local goldActual = goldInicio

-- Notificación
local function notify(text)
    Rayfield:Notify({
        Title = "Wilson Hub",
        Content = text,
        Duration = 6.5,
        Image = 4483362458
    })
end

-- Home
HomeTab:CreateButton({
    Name = "Cerrar GUI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- AutoFarm
AutoTab:CreateToggle({
    Name = "Auto Farm - Etapas",
    Default = false,
    Callback = function(state)
        autoFarm = state
        notify("Auto Farm Etapas "..(state and "Activado" or "Desactivado"))
        task.spawn(function()
            while autoFarm do
                local function AutoFarmEtapas()
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")

                    -- Obtener el DarknessPart de CaveStage10
                    local stage1Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage1")
                        and workspace.BoatStages.NormalStages.CaveStage1:FindFirstChild("DarknessPart")
                    local stage2Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage2")
                        and workspace.BoatStages.NormalStages.CaveStage2:FindFirstChild("DarknessPart")
                    local stage3Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage3")
                        and workspace.BoatStages.NormalStages.CaveStage3:FindFirstChild("DarknessPart")
                    local stage3Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage3")
                        and workspace.BoatStages.NormalStages.CaveStage3:FindFirstChild("DarknessPart")
                    local stage4Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage4")
                        and workspace.BoatStages.NormalStages.CaveStage4:FindFirstChild("DarknessPart")
                    local stage5Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage5")
                        and workspace.BoatStages.NormalStages.CaveStage5:FindFirstChild("DarknessPart")
                    local stage6Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage6")
                        and workspace.BoatStages.NormalStages.CaveStage6:FindFirstChild("DarknessPart")
                    local stage7Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage7")
                        and workspace.BoatStages.NormalStages.CaveStage7:FindFirstChild("DarknessPart")
                    local stage8Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage8")
                        and workspace.BoatStages.NormalStages.CaveStage8:FindFirstChild("DarknessPart")
                    local stage9Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage9")
                        and workspace.BoatStages.NormalStages.CaveStage9:FindFirstChild("DarknessPart")
                    local stage10Part = workspace:FindFirstChild("BoatStages")
                        and workspace.BoatStages:FindFirstChild("NormalStages")
                        and workspace.BoatStages.NormalStages:FindFirstChild("CaveStage10")
                        and workspace.BoatStages.NormalStages.CaveStage10:FindFirstChild("DarknessPart")

                    if not stage1Part or not stage2Part or not stage3Part or not stage4Part or not stage5Part or not stage6Part or not stage7Part or not stage8Part or not stage9Part or not stage10Part then
                        Rayfield:Notify({
                            Title = "Auto Farm Etapas",
                            Content = "No se encontró DarknessPart en una de las CaveStages(1 - 10)",
                            Duration = 5,
                            Image = 4483362458,
                        })
                        return
                    end

                    hrp.CFrame = CFrame.new(stage1Part.Position + Vector3.new(0, 5, 0)) -- Teletransportarse a CaveStage10

                    -- Agregar BodyVelocity para que flote
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv.P = 1250
                    bv.Name = "GoldFloat"
                    bv.Parent = hrp

                    Rayfield:Notify({
                        Title = "GoldBlockFarm",
                        Content = "Flotando en CaveStage1...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat") then
                        hrp.GoldFloat:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage2Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv2 = Instance.new("BodyVelocity")
                    bv2.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv2.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv2.P = 1250
                    bv2.Name = "GoldFloat2"
                    bv2.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage2...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat2") then
                        hrp.GoldFloat2:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage3Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv3 = Instance.new("BodyVelocity")
                    bv3.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv3.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv3.P = 1250
                    bv3.Name = "GoldFloat3"
                    bv3.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage3...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat3") then
                        hrp.GoldFloat3:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage4Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv4 = Instance.new("BodyVelocity")
                    bv4.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv4.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv4.P = 1250
                    bv4.Name = "GoldFloat4"
                    bv4.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage4...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat4") then
                        hrp.GoldFloat4:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage5Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv5 = Instance.new("BodyVelocity")
                    bv5.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv5.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv5.P = 1250
                    bv5.Name = "GoldFloat5"
                    bv5.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage5...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat5") then
                        hrp.GoldFloat5:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage6Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv6 = Instance.new("BodyVelocity")
                    bv6.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv6.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv6.P = 1250
                    bv6.Name = "GoldFloat6"
                    bv6.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage6...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat6") then
                        hrp.GoldFloat6:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage7Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv7 = Instance.new("BodyVelocity")
                    bv7.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv7.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv7.P = 1250
                    bv7.Name = "GoldFloat7"
                    bv7.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage7...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat7") then
                        hrp.GoldFloat7:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage8Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv8 = Instance.new("BodyVelocity")
                    bv8.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv8.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv8.P = 1250
                    bv8.Name = "GoldFloat8"
                    bv8.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage8...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat8") then
                        hrp.GoldFloat8:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage9Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv9 = Instance.new("BodyVelocity")
                    bv9.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv9.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv9.P = 1250
                    bv9.Name = "GoldFloat9"
                    bv9.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage9...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat9") then
                        hrp.GoldFloat9:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage10Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv10 = Instance.new("BodyVelocity")
                    bv10.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv10.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv10.P = 1250
                    bv10.Name = "GoldFloat10"
                    bv10.Parent = hrp

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Flotando en CaveStage10...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat10") then
                        hrp.GoldFloat10:Destroy()
                    end

                    -- Teletransporte al cofre
                    local chestPos = Vector3.new(-55.706512, -358.7396, 9492.3564)
                    hrp.CFrame = CFrame.new(chestPos)

                    Rayfield:Notify({
                        Title = "Auto Farm Etapas",
                        Content = "Teletransportado al cofre.",
                        Duration = 4,
                        Image = 4483362458,
                    })
                    task.wait(20)
                end

                -- Ejecutar la función GoldBlockFarm
                AutoFarmEtapas()
            end
        end)
    end,
})

-- Reemplazar con el nuevo GoldBlockFarm
AutoTab:CreateToggle({
    Name = "Gold Block Farm",
    Default = false,
    Callback = function(state)
        goldFarm = state
        notify("Gold Block Farm "..(state and "Activado" or "Desactivado"))
        task.spawn(function()
            while goldFarm do
                -- Llamar a la nueva función GoldBlockFarm
                local function GoldBlockFarm()
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")

                    -- Obtener el DarknessPart de CaveStage10
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
                            Title = "GoldBlockFarm",
                            Content = "No se encontró DarknessPart en CaveStage10 o CaveStage1.",
                            Duration = 5,
                            Image = 4483362458,
                        })
                        return
                    end

                    hrp.CFrame = CFrame.new(stage1Part.Position + Vector3.new(0, 5, 0)) -- Teletransportarse a CaveStage10

                    -- Agregar BodyVelocity para que flote
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv.P = 1250
                    bv.Name = "GoldFloat"
                    bv.Parent = hrp

                    Rayfield:Notify({
                        Title = "GoldBlockFarm",
                        Content = "Flotando en CaveStage1...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat") then
                        hrp.GoldFloat:Destroy()
                    end

                    hrp.CFrame = CFrame.new(stage10Part.Position + Vector3.new(0, 5, 0))

                    -- Agregar BodyVelocity para que flote
                    local bv2 = Instance.new("BodyVelocity")
                    bv2.Velocity = Vector3.new(0, 0, 0) -- velocidad hacia arriba
                    bv2.MaxForce = Vector3.new(0, 100000, 0) -- solo eje Y
                    bv2.P = 1250
                    bv2.Name = "GoldFloat2"
                    bv2.Parent = hrp

                    Rayfield:Notify({
                        Title = "GoldBlockFarm",
                        Content = "Flotando en CaveStage10...",
                        Duration = 4,
                        Image = 4483362458,
                    })

                    -- Esperar 5 segundos
                    task.wait(5)

                    -- Eliminar el BodyVelocity para detener la flotación
                    if hrp:FindFirstChild("GoldFloat2") then
                        hrp.GoldFloat2:Destroy()
                    end

                    -- Teletransporte al cofre
                    local chestPos = Vector3.new(-55.706512, -358.7396, 9492.3564)
                    hrp.CFrame = CFrame.new(chestPos)

                    Rayfield:Notify({
                        Title = "GoldBlockFarm",
                        Content = "Teletransportado al cofre.",
                        Duration = 4,
                        Image = 4483362458,
                    })
                    task.wait(20)
                end

                -- Ejecutar la función GoldBlockFarm
                GoldBlockFarm()
            end
        end)
    end,
})

-- Movimiento
MoveTab:CreateButton({
    Name = "Speed Walk",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local hrp = character:WaitForChild("HumanoidRootPart")
        -- Hacer algo con el speed walk
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)  -- Simple cambio de posición
    end,
})

-- Resto del código de Extras y Créditos
ExtrasTab:CreateButton({
    Name = "Extra Function",
    Callback = function()
        -- Función extra
        notify("Función extra activada.")
    end,
})

CreditsTab:CreateLabel({
    Name = "Creditos",
    Text = "Desarrollado por WsXn"
})
