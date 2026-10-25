-- ============================================
-- WEBSHUB LAUNCHER (Loader) by Webs_My
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "WebsHub Launcher",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by Webs_My",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Скрипты", 4483362458)

-- Функция загрузки
local function loadScript(url, name)
    Rayfield:Notify({Title = "Загрузка...", Content = "Запускаю " .. name, Duration = 3})
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            Rayfield:Notify({Title = "Ошибка", Content = "Не удалось загрузить " .. name, Duration = 4})
        end
    end)
end

-- ============================================
-- ССЫЛКИ НА ТВОИ СКРИПТЫ (ЗАМЕНИ, КОГДА ЗАЛЬЕШЬ)
-- ============================================
local LINKS = {
    -- Пока тут стоят ссылки-заглушки, ты заменишь их на свои
    Universal = "ССЫЛКА_НА_УНИВЕРСАЛ",
    Drone = "ССЫЛКА_НА_ДРОНА",
    Chaos = "ССЫЛКА_НА_ХАОС",
    Flight = "ССЫЛКА_НА_FLIGHT"
}

MainTab:CreateSection("Запуск скриптов")

MainTab:CreateButton({Name = "🚀 Универсал", Callback = function() 
    if LINKS.Universal ~= "ССЫЛКА_НА_УНИВЕРСАЛ" then loadScript(LINKS.Universal, "Универсал") 
    else Rayfield:Notify({Title="Ошибка", Content="Ссылка не добавлена", Duration=3}) end 
end})

MainTab:CreateButton({Name = "🚁 Дрон", Callback = function() 
    if LINKS.Drone ~= "ССЫЛКА_НА_ДРОНА" then loadScript(LINKS.Drone, "Дрон") 
    else Rayfield:Notify({Title="Ошибка", Content="Ссылка не добавлена", Duration=3}) end 
end})

MainTab:CreateButton({Name = "💥 Хаос", Callback = function() 
    if LINKS.Chaos ~= "ССЫЛКА_НА_ХАОС" then loadScript(LINKS.Chaos, "Хаос") 
    else Rayfield:Notify({Title="Ошибка", Content="Ссылка не добавлена", Duration=3}) end 
end})

MainTab:CreateButton({Name = "✈️ A Long Flight", Callback = function() 
    if LINKS.Flight ~= "ССЫЛКА_НА_FLIGHT" then loadScript(LINKS.Flight, "A Long Flight") 
    else Rayfield:Notify({Title="Ошибка", Content="Ссылка не добавлена", Duration=3}) end 
end})

MainTab:CreateSection("Система")
MainTab:CreateButton({Name = "🛑 Закрыть Хаб", Callback = function() Window:Destroy() end})

Rayfield:Notify({Title="WebsHub", Content="Хаб загружен! Выбирай скрипт.", Duration=4})