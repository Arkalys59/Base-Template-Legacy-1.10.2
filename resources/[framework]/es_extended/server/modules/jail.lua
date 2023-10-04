
local TempsJail = {}
local JoueurEstMort = {}

RegisterNetEvent('jail:combiendetemps')
AddEventHandler('jail:combiendetemps', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM `ato_jail` WHERE `identifier` = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            if not TempsJail[xPlayer.source] then
                TempsJail[xPlayer.source] = {}
                TempsJail[xPlayer.source].time = result[1].time
                TempsJail[xPlayer.source].reason = result[1].raison
                TempsJail[xPlayer.source].staffname = result[1].staffname
                TriggerClientEvent('jail:encoredutemps', xPlayer, TempsJail[xPlayer.source].time)
                for k,v in pairs(Config.Position["enter"]) do
                    SetEntityCoords(GetPlayerPed(xPlayer.source), v.x, v.y, v.z)
                end
                TriggerClientEvent('esx:showNotification', xPlayer, "Vous vous êtes déconnecté en étant en jail")
                TriggerClientEvent('jail:openmenu', xPlayer, TempsJail[xPlayer.source].time, TempsJail[xPlayer.source].reason, TempsJail[xPlayer.source].staffname)
            end
        else
            TempsJail[xPlayer.source] = {}
            TempsJail[xPlayer.source].time = 0
        end
    end)
end)

RegisterNetEvent('jail:mettretempsajour')
AddEventHandler('jail:mettretempsajour', function(NewTempsJail)
    local xPlayer = ESX.GetPlayerFromId(source)
    TempsJail[xPlayer.source].time = NewTempsJail
    if tonumber(TempsJail[xPlayer.source].time) == 0 then
        TempsJail[xPlayer.source].time = 0
        TriggerClientEvent("esx:showNotification", source, "Votre sanction est maintenant terminé")
        MySQL.Async.execute('DELETE FROM ato_jail WHERE `identifier` = @identifier', {
            ['@identifier'] = xPlayer.identifier
        })
		for k,v in pairs(Config.Position["exit"]) do
        	SetEntityCoords(GetPlayerPed(xPlayer.source), v.x, v.y, v.z)
		end
    end
end)

RegisterCommand('jail', function(source,args)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() ~= 'user' then
            local JoueurTarget = ESX.GetPlayerFromId(args[1])
            if JoueurTarget then
                Wait(1)
                if tonumber(TempsJail[JoueurTarget.source].time) >= 1 then
                    TriggerClientEvent('esx:showNotification', source, "Le joueur est déjà en jail pendant: "..TempsJail[JoueurTarget.source].time.." minutes")
                else
                    local reason = table.concat(args, ' ', 3)
                    TempsJail[JoueurTarget.source].time = args[2]
                    TempsJail[JoueurTarget.source].reason = reason
                    TempsJail[JoueurTarget.source].staffname = xPlayer.getName()
                    TriggerClientEvent('jail:encoredutemps', JoueurTarget.source, TempsJail[JoueurTarget.source].time)
                    for k,v in pairs(Config.Position["enter"]) do
                        SetEntityCoords(GetPlayerPed(JoueurTarget.source), v.x, v.y, v.z)
                    end
                    if args[2] == tostring("1") then 
                        TriggerClientEvent('esx:showNotification', source, "Vous avez jail "..GetPlayerName(JoueurTarget.source).." pendant "..args[2].." minute")
                        TriggerClientEvent('esx:showNotification', JoueurTarget.source, "Vous avez été mit en jail pendant "..args[2].." minute")
                    else
                        TriggerClientEvent('esx:showNotification', source, "Vous avez jail "..GetPlayerName(JoueurTarget.source).." pendant "..args[2].." minutes")
                        TriggerClientEvent('esx:showNotification', JoueurTarget.source, "Vous avez été mit en jail pendant "..args[2].." minutes")
                    end
                    TriggerClientEvent('jail:openmenu', JoueurTarget.source, nil, TempsJail[JoueurTarget.source].reason, TempsJail[JoueurTarget.source].staffname)


                    MySQL.Async.execute("INSERT INTO ato_jail (identifier, time, raison, staffname) VALUES (@identifier, @time, @raison, @staffname)", {
                        ["@identifier"] = JoueurTarget.identifier, 
                        ["@time"] = args[2],
                        ["@raison"] = reason,
                        ["@staffname"] = TempsJail[JoueurTarget.source].staffname
                    })
                end
            else
                TriggerClientEvent('esx:showNotification', source, "Aucun joueur trouvé avec l'ID que vous avez entré")
            end
        end
    else
        local JoueurTarget = ESX.GetPlayerFromId(args[1])
        if JoueurTarget then
            Wait(1)
            if tonumber(TempsJail[JoueurTarget.source].time) >= 1 then
                print("Le joueur "..JoueurTarget.getName().." est déjà en jail pendant: "..TempsJail[JoueurTarget.source].time.." minutes")
            else
                local reason = table.concat(args, ' ', 3)
                TempsJail[JoueurTarget.source].time = args[2]
                TempsJail[JoueurTarget.source].reason = reason
                TempsJail[JoueurTarget.source].staffname = "Console"
                TriggerClientEvent('jail:encoredutemps', JoueurTarget.source, TempsJail[JoueurTarget.source].time)
                for k,v in pairs(Config.Position["enter"]) do
                    SetEntityCoords(GetPlayerPed(JoueurTarget.source), v.x, v.y, v.z)
                end
                if args[2] == tostring("1") then 
                    print("Vous avez jail "..JoueurTarget.getName().." pendant "..args[2].." minute")
                    TriggerClientEvent('esx:showNotification', JoueurTarget.source, "Vous avez été mit en jail pendant "..args[2].." minute")
                else
                    print("Vous avez jail "..JoueurTarget.getName().." pendant "..args[2].." minute")
                    TriggerClientEvent('esx:showNotification', JoueurTarget.source, "Vous avez été mit en jail pendant "..args[2].." minutes")
                end
                TriggerClientEvent('jail:openmenu', JoueurTarget.source, nil, TempsJail[JoueurTarget.source].reason, TempsJail[JoueurTarget.source].staffname)
                MySQL.Async.execute("INSERT INTO ato_jail (identifier, time, raison, staffname) VALUES (@identifier, @time, @raison, @staffname)", {
                    ["@identifier"] = JoueurTarget.identifier, 
                    ["@time"] = args[2],
                    ["@raison"] = reason,
                    ["@staffname"] = TempsJail[JoueurTarget.source].staffname
                })
            end
        else
            print("Aucun joueur trouvé avec l'ID que vous avez entré")
        end
    end
end)

RegisterCommand('unjail', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        local JoueurTarget = ESX.GetPlayerFromId(args[1])
        if JoueurTarget then
            if tonumber(TempsJail[JoueurTarget.source].time) >= 0 then
                TempsJail[JoueurTarget.source].time = 0
                TriggerClientEvent('esx:showNotification', xPlayer, "Le joueur "..JoueurTarget.getName().." a été unjail")
                TriggerClientEvent("esx:showNotification", JoueurTarget.source, "Votre sanction est maintenant terminé")
                TriggerClientEvent('jail:encoredutemps', JoueurTarget.source, 0)
                MySQL.Async.execute('DELETE FROM ato_jail WHERE `identifier` = @identifier', {
                    ['@identifier'] = JoueurTarget.identifier
                })
                for k,v in pairs(Config.Position["exit"]) do
                    SetEntityCoords(GetPlayerPed(JoueurTarget.source), v.x, v.y, v.z)
                end
            else
                TriggerClientEvent('esx:showNotification', source, "Le joueur "..GetPlayerName(JoueurTarget.source).." n'est pas en jail")
            end
        else
            TriggerClientEvent('esx:showNotification', source, "Aucun joueur trouvé avec l'ID que vous avez entré")
        end
    end
end)


RegisterCommand('jailoffline', function(source, args)
    local staffname = "Console"
    local notuser = false
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        staffname = xPlayer.getName()
        if xPlayer.getGroup() ~= 'user' then
            notuser = true
        end
    end
    local reason = table.concat(args, " ", 3)
    if notuser or source == 0 then
        MySQL.Async.execute("INSERT INTO ato_jail (identifier, time, raison, staffname) VALUES (@identifier, @time, @raison, @staffname)", {
            ["@identifier"] = args[1], 
            ["@time"] = args[2],
            ["@raison"] = reason, 
            ["@staffname"] = staffname
        })
    end
end)

RegisterNetEvent("ato_jail:Connect")
AddEventHandler('ato_jail:Connect', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Jail = MySQL.Sync.fetchAll('SELECT * FROM `ato_jail` WHERE `identifier` = @identifier',{
        ['@identifier'] = xPlayer.identifier
    })
    if (xPlayer) then
        if Jail[1] ~= nil then
            local TimeJail = tonumber(Jail[1].time)
            if tonumber(TimeJail) >= 1 then
                TempsJail[xPlayer.source] = {}
                TempsJail[xPlayer.source].time = TimeJail
                TempsJail[xPlayer.source].reason = Jail[1].raison
                TempsJail[xPlayer.source].staffname = Jail[1].staffname
                TriggerClientEvent('jail:encoredutemps', xPlayer.source, TimeJail)
                Wait(5000)
                TriggerClientEvent('jail:openmenu', xPlayer.source, nil, TempsJail[xPlayer.source].reason, TempsJail[xPlayer.source].staffname)
            end
        end
        if JoueurEstMort[xPlayer.source] then 
            MySQL.Async.execute('INSERT INTO ato_jail (identifier, time, raison, staffname) VALUES (@identifier, @time, @raison, @staffname)', {
                ['@identifier'] = xPlayer.identifier,
                ['@time'] = 10,
                ["@raison"] = "Déco Mort",
                ["@staffname"] = "Anti Déco Mort"
            })
        end
    end
end)
