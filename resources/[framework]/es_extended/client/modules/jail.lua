local mainMenu = RageUI.CreateMenu("Atoshit Jail", "Vous avez été mis en jail")
local TempsJail = 0
local open = false

mainMenu.Closable = false
mainMenu.Closed = function() open = false end

RegisterNetEvent('jail:openmenu')
AddEventHandler('jail:openmenu', function(time, raison, staffname)
    if not open then open = true RageUI.Visible(mainMenu, true) 
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu, function()
                    if TempsJail == tostring("1") then
                        RageUI.Button("Temps restant: ~y~"..ESX.Math.Round(TempsJail).." minute", nil, {}, true, {})
                    else
                        RageUI.Button("Temps restant: ~y~"..ESX.Math.Round(TempsJail).." minutes", nil, {}, true, {})
                    end
                    if raison ~= nil then 
                        RageUI.Button("Raison: ~o~"..raison.."", nil, {}, true, {})
                    else
                        RageUI.Button("Raison: ~o~Indéfinie", nil, {}, true, {})
                    end
                    if staffname ~= nil then 
                        RageUI.Button("Staff: ~g~"..staffname, nil, {}, true, {})
                    else
                        RageUI.Button("→ CONSOLE", nil, {}, true, {})
                    end
                end)
            Wait(0)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    Wait(2500)
    TriggerServerEvent('jail:combiendetemps')
    while true do
        if tonumber(TempsJail) >= 1 then
            Wait(60000)
            TempsJail = TempsJail - 1
            TriggerServerEvent('jail:mettretempsajour', TempsJail)
        end
        if tonumber(TempsJail) == 0 then
            RageUI.CloseAll()
            open = false
        end
        Wait(2500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if tonumber(TempsJail) >= 1 then
            for k,v in pairs(Config.Position["enter"]) do
                if #(GetEntityCoords(GetPlayerPed(-1)) - vector3(v.x, v.y, v.z)) > 50 then
                    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z)
                    ESX.ShowNotification("~r~Vous ne pouvez pas vous échapper !")
                end
            end
            Wait(0)
        else
            Wait(2500)
        end
    end
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/jail', 'id, temps, raison')
    TriggerEvent('chat:addSuggestion', '/jailoffline', 'license, temps, raison')
    TriggerEvent('chat:addSuggestion', '/unjail', 'id')
end)

AddEventHandler("playerSpawned",function()
    TriggerServerEvent("ato_jail:Connect")
end)

RegisterNetEvent('jail:encoredutemps')
AddEventHandler('jail:encoredutemps', function(result)
    TempsJail = result
    if TempsJail == 0 then
        RageUI.CloseAll()
        open = false
    end 
end)
