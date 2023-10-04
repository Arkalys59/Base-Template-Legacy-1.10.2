RegisterCommand("coordsmenu", function()
    showMenu()
end, false)

RegisterNUICallback("exit", function(data)
    hideMenu()
end)

RegisterNUICallback("request-copy", function(data)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local pedHeading = GetEntityHeading(ped)
    local format = nil
    if data.type == "c-vec3" then
        format = string.format("vec3(%s, %s, %s)", pedCoords.x, pedCoords.y, pedCoords.z)
    elseif data.type == "c-table" then
        format = string.format("{ %s, %s, %s }", pedCoords.x, pedCoords.y, pedCoords.z)
    elseif data.type == "c-tablei" then
        format = string.format("{ x = %s, y = %s, z = %s }", pedCoords.x, pedCoords.y, pedCoords.z)
    elseif data.type == "c-X" then
        format = pedCoords.x
    elseif data.type == "c-Y" then
        format = pedCoords.y
    elseif data.type == "c-Z" then
        format = pedCoords.z
    elseif data.type == "h-W" then
        format = pedHeading
    elseif data.type == "ch-vec4" then
        format = string.format("vec4(%s, %s, %s, %s)", pedCoords.x, pedCoords.y, pedCoords.z, pedHeading)
    elseif data.type == "ch-table" then
        format = string.format("{ %s, %s, %s, %s }", pedCoords.x, pedCoords.y, pedCoords.z, pedHeading)
    elseif data.type == "ch-tablei" then
        format = string.format("{ x = %s, y = %s, z = %s, w = %s }", pedCoords.x, pedCoords.y, pedCoords.z, pedHeading)
    end
    if not format then
        showNotification("Une erreur est survenue")
        return
    end
    updateClipboard(format)
    showNotification(string.format("Coordonnées copiées au format : %s", format))
end)

function showMenu()
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        type = 'showui',
    })
end

function hideMenu()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({
        type = 'hideui',
    })
end

function showNotification(msg)
    SendNUIMessage({
        type = 'showNotification',
        message = msg,
    })
end

function updateClipboard(content)
    SendNUIMessage({
        type = 'copy',
        content = content,
    })
end