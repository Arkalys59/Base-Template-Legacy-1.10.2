local Debug = ESX.GetConfig().EnableDebug

---@param type string the notification type
---@param length number the length of the notification
---@param message any the message :D
local function Notify(notificatonType, length, message)

    if Debug then
        print("1 ".. tostring(notificatonType))
        print("2 "..tostring(length))
        print("3 "..message)
    end

    if type(notificatonType) ~= "string" then
        notificatonType = "info"
    end

    if type(length) ~= "number" then
        length = 3000
    end

    if Debug then
        print("4 ".. tostring(notificatonType))
        print("5 "..tostring(length))
        print("6 "..message)
    end

    SendNuiMessage(json.encode({
        type = notificatonType or "info",
        length = length or 3000,
        message = message or "ESX-Notify"
    }))
end


exports('Notify', Notify)
RegisterNetEvent("ESX:Notify", Notify)


RegisterCommand("success", function()
    ESX.ShowNotification("Notification Test", "success", 3000)
end)

RegisterCommand("info", function()
    ESX.ShowNotification("Notification Test", "info", 3000)
end)

RegisterCommand("error", function()
    ESX.ShowNotification("Notification Test", "error", 3000)
end)
