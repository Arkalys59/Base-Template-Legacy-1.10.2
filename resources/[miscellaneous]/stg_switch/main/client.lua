RegisterNetEvent('stg_switch:use')
AddEventHandler('stg_switch:use', function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "open"
	})
	nintendoAnim()
end)

RegisterNUICallback('exit', function()
    SetNuiFocus(false, false)
	SendNUIMessage({
		type = "false"
	})
	nintendoAnim()
	DeleteObject(attachProps)
	ClearPedTasksImmediately(PlayerPedId())
end)

function nintendoAnim()
	ClearPedTasksImmediately(PlayerPedId())
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	local dict = "amb@world_human_stand_fire@male@idle_a"
	local name = "idle_a"

	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
		RequestAnimDict(dict)
	end

	RequestModel(prop)
	while not HasModelLoaded(prop) do
		Citizen.Wait(100)
	end
	attachProps = CreateObject(prop, coords,  1,  1,  1)
	TaskPlayAnim(ped, dict, name, 3.0, 3.0, -1, 50, 0, false, false, false)
end

RegisterCommand('switch', function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "open"
	})
	nintendoAnim()end, false)