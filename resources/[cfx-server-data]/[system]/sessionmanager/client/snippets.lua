-- Garder son chapeau en véhicule

CreateThread(function()
    local hat = 0
    local texture = 0
    local timer = 0
    local ped = PlayerPedId()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, true) then
            hat = GetPedPropIndex(ped, 0)
            texture = GetPedPropTextureIndex(me, 0)
        else
            timer = GetGameTimer()
            while not IsPedInAnyVehicle(ped, false) or timer + 2000 < GetGameTimer() do
                Wait(0)
            end
            if IsPedInAnyVehicle(ped, false) then
                SetPedPropIndex(ped, 0, hat, texture, 0)
                while IsPedInAnyVehicle(ped, false) do
                    Wait(1000)
                end
            end
        end
    end
end)

-- Croiser les bras

local crossarms = false

RegisterCommand('crossarms', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local dict = "anim@amb@nightclub@peds@"
        if not crossarms then
                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    Wait(500)
                end
                TaskPlayAnim(PlayerPedId(), dict, "rcmme_amanda1_stand_loop_cop", 2.5, 2.5, -1, 50, 0, false, false, false)
                crossarms = true
        else
            crossarms = false
            StopAnimTask(PlayerPedId(), dict, "rcmme_amanda1_stand_loop_cop", -2.5)
            RemoveAnimDict(dict)
        end
    end
end)

RegisterKeyMapping('crossarms', "Croiser les bras", 'keyboard', "G")

-- Pointer du doigt

local mp_pointing = false
local keyPressed = false
local function startPointing()
    local playerPed = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do Wait(0) end
    SetPedCurrentWeaponVisible(playerPed, 0, 1, 1, 1)
    SetPedConfigFlag(playerPed, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, playerPed, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end
local function stopPointing()
    local playerPed = PlayerPedId()
    Citizen.InvokeNative(0xD01015C7316AE176, playerPed, "Stop")
    if not IsPedInjured(playerPed) then ClearPedSecondaryTask(playerPed) end
    if not IsPedInAnyVehicle(playerPed, 1) then
        SetPedCurrentWeaponVisible(playerPed, 1, 1, 1, 1)
    end
    SetPedConfigFlag(playerPed, 36, 0)
    ClearPedSecondaryTask(playerPed)
end

RegisterCommand('point', function()
    local playerPed = PlayerPedId()
    if not mp_pointing and IsPedOnFoot(playerPed) then
        Wait(200)
        keyPressed = true
        startPointing()
        mp_pointing = true
        CreateThread(function()
            while mp_pointing do
                Wait(0)
                if Citizen.InvokeNative(0x921CE12C489C4C41, playerPed) then
                    if not IsPedOnFoot(playerPed) then
                        stopPointing()
                    else
                        local camPitch = GetGameplayCamRelativePitch()
                        if camPitch < -70.0 then
                            camPitch = -70.0
                        elseif camPitch > 42.0 then
                            camPitch = 42.0
                        end
                        camPitch = (camPitch + 70.0) / 112.0
                        local camHeading = GetGameplayCamRelativeHeading()
                        local cosCamHeading = Cos(camHeading)
                        local sinCamHeading = Sin(camHeading)
                        if camHeading < -180.0 then
                            camHeading = -180.0
                        elseif camHeading > 180.0 then
                            camHeading = 180.0
                        end
                        camHeading = (camHeading + 180.0) / 360.0
                        local blocked = 0
                        local nn = 0
                        local coords = GetOffsetFromEntityInWorldCoords(playerPed, (cosCamHeading *     -0.2) -     (sinCamHeading *         (0.4 *             camHeading +             0.3)), (sinCamHeading *     -0.2) +     (cosCamHeading *         (0.4 *             camHeading +             0.3)), 0.6)
                        local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, playerPed, 7); nn, blocked, coords, coords = GetRaycastResult(ray)
                        Citizen.InvokeNative(0xD5BB4025AE449A4E, playerPed, "Pitch", camPitch)
                        Citizen.InvokeNative(0xD5BB4025AE449A4E, playerPed,  "Heading", camHeading * -1.0 + 1.0)
                        Citizen.InvokeNative(0xB0A6CFD2C69C1088, playerPed, "isBlocked", blocked)
                        Citizen.InvokeNative(0xB0A6CFD2C69C1088, playerPed, "isFirstPerson", Citizen.InvokeNative( 0xEE778F8C7E1142E2, Citizen.InvokeNative( 0x19CAFA3C87F7C2FF)) == 4)
                    end
                end
            end
        end)        
    elseif mp_pointing or (not IsPedOnFoot(playerPed) and mp_pointing) then
        keyPressed = true
        mp_pointing = false
        stopPointing()
    end

end, false)

RegisterKeyMapping('point', "Pointer du doigt", 'keyboard', "B")

-- Ragdoll

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ragdoll then
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            if IsControlJustPressed(2, 102) and not IsPedInAnyVehicle(PlayerPedId(), false) then
                ragdoll = not ragdoll
            end
        end
    end
end)

RegisterNetEvent('dh_ragdoll:toggle')
AddEventHandler('dh_ragdoll:toggle', function()
    ragdoll = not ragdoll
    if not ragdoll then
        shownHelp = false
    end
end)

RegisterCommand('ragdoll', function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerEvent("dh_ragdoll:toggle")
    else
        ESX.ShowNotification("Vous ne pouvez pas ~r~tomber par terre ~s~quand vous êtes ~r~dans un véhicule~s~")
    end
end, false)

RegisterKeyMapping('ragdoll', "Tomber par terre/se relever", 'keyboard', "H")