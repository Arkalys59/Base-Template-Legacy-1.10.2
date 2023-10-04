if Config.Maintenance then 
    print("Atoshit Server Maintenance : ^2Activée^0")
    function AutorisationMaintenance(joueur)
        local allowed = false
        for i,id in ipairs(Config.WhitelistMaintenance) do
            for x,pid in ipairs(GetPlayerIdentifiers(joueur)) do
                if string.lower(pid) == string.lower(id) then
                    allowed = true
                end
            end
        end
        return allowed
    end

    local function OnPlayerConnecting(name, setKickReason, deferrals)
        local player = source
        deferrals.defer()
        Wait(0)
    
        deferrals.update(string.format("Vérification des maintenances... ", name))
        Wait(1000)
    
        if AutorisationMaintenance(player) then
            deferrals.done()
        else
            deferrals.done("\n["..ServerName.."] Le serveur est en maintenance, consultez les informations sur notre discord. (" ..Config.DiscordLink..")")
        end
    
    end
    AddEventHandler("playerConnecting", OnPlayerConnecting)
else
    print("Atoshit Server Maintenance : ^1Desactivée^0")
end





