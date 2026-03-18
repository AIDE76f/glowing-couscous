local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- التأكد من عدم تكرار الواجهة إذا قمت بتشغيل السكربت أكثر من مرة
if guiParent:FindFirstChild("CarScannerGUI") then
    guiParent.CarScannerGUI:Destroy()
end

--------------------------------------------------
-- 1. تصميم واجهة المستخدم (GUI)
--------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarScannerGUI"
screenGui.Parent = guiParent

-- الإطار الرئيسي (النافذة)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125) -- توسيط في الشاشة
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- عنوان الواجهة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔍 معلومات أغلى سيارة"
title.TextColor3 = Color3.fromRGB(255, 215, 0) -- لون ذهبي
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- معلومات السيارة (سيتم تحديث النص لاحقاً)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -100)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "جاري البحث..."
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 16
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 100, 0, 35)
closeBtn.Position = UDim2.new(0.5, -50, 1, -45)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "إغلاق"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--------------------------------------------------
-- 2. منطق البحث العميق (Deep Search)
--------------------------------------------------
local mostExpensiveCar = nil
local highestPrice = 0

for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("Model") then
        local priceValue = object:FindFirstChild("Price") or object:FindFirstChild("Cost")
        local isVehicle = object:FindFirstChildWhichIsA("VehicleSeat", true) or object:FindFirstChild("DriveSeat", true)

        if priceValue and priceValue:IsA("IntValue") and isVehicle then
            if priceValue.Value > highestPrice then
                highestPrice = priceValue.Value
                mostExpensiveCar = object
            end
        end
    end
end

--------------------------------------------------
-- 3. تحديث الواجهة بالنتائج
--------------------------------------------------
if mostExpensiveCar then
    local carName = mostExpensiveCar.Name
    local pos = mostExpensiveCar:GetPivot().Position
    
    -- تقريب الإحداثيات لتكون أسهل في القراءة
    local formattedPosition = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
    
    infoLabel.Text = 
        "🚗 الاسم: " .. carName .. "\n\n" ..
        "💰 السعر: " .. tostring(highestPrice) .. "\n\n" ..
        "📍 المكان:\n" .. formattedPosition
else
    infoLabel.Text = "❌ لم يتم العثور على أي سيارات بأسعار.\nقد يعتمد الماب على نظام مختلف (مثل Attributes)."
end
