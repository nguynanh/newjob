local avion, avioneta, piloto, ruiner, myJob, z, blip
local remover = false
local guardias = {}
local soldados = {}
local npc = { 
	{modelo = 's_m_y_blackops_01', coords = {-988.99719238281, -3151.1645507812, 16.402097702026, 239.11}, bone = 17, x = 1.4, y = 1.1, z = 3.3},
	{modelo = 's_m_y_blackops_01', coords = {-993.32354736328, -3144.7431640625, 16.339637756348, 239.59}, bone = 43, x = 1.5, y = 1.1, z = -2.84},
	{modelo = 's_m_y_blackops_01', coords = {-1014.5862426758, -3135.6560058594, 16.403480529785, 244.73}, bone = 10, x = -2.0, y = -0.50, z = -2.84},
}

Citizen.CreateThread(function()
	SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
	AddRelationshipGroup('Guardias')
	if Config.Framework == 'ESX' then
		ESX = nil
		while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) 
		ESX = obj end) Wait(0) end
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end
		myJob = ESX.GetPlayerData().job.name
	elseif Config.Framework == 'VRP' then
		vRPsb = Proxy.getInterface("vrp_extended")
	end
	z = TriggerServerCallback {
        eventName = 'av_turbulence:info',
        args = {}
    }
	while true do
		w = 500
		if #(GetEntityCoords(PlayerPedId()) - vector3(Config.StartCoords.x, Config.StartCoords.y, Config.StartCoords.z)) < 2 then
			w = 3
			DrawText3D(Config.StartCoords.x, Config.StartCoords.y, Config.StartCoords.z, Config.Lang['start'])
			if IsControlJustPressed(0,38) then
				loadAnimDict("timetable@jimmy@doorknock@")
				TaskPlayAnim(PlayerPedId(), "timetable@jimmy@doorknock@", 'knockdoor_idle', 2.0, 2.0, 3000, 1, 0, true, true, true)
				Citizen.Wait(3500)
				result = TriggerServerCallback {
					eventName = 'av_turbulence:cooldown',
					args = {}
				}
				if result then
					TriggerServerEvent('av_turbulence:start',z)
					Distancia()
				end
			end
		end
		Citizen.Wait(w)
	end
end)

function Distancia()
	TriggerEvent('av_turbulence:notification',Config.Lang['mission'])
	blip = AddBlipForCoord(-991.28100585938, -3147.8483886719, 13.944444656372)
	SetBlipRoute(blip, true)
	local enArea = false
	while not enArea do
		if #(GetEntityCoords(PlayerPedId()) - vector3(-991.28100585938, -3147.8483886719, 13.944444656372)) < 350 then
			RemoveBlip(blip)
			blip = nil
			enArea = true
			TriggerEvent('av_turbulence:notification',Config.Lang['vehicle'])
			TriggerEvent('av_turbulence:avionspawn')
		end
		Wait(500)
	end
end

RegisterNetEvent('av_turbulence:avionspawn')
AddEventHandler('av_turbulence:avionspawn', function()
	AddTextEntry("entrar", Config.Lang['enter'])
	AddTextEntry("robar", Config.Lang['enter'])
	local entrega = true
	local aleatorio = math.random(1,#Config.DeliveryLocations)
	local destino = Config.DeliveryLocations[aleatorio]
	local cerca = false
	local ped = PlayerPedId()
	local montado = false
	Modelo(GetHashKey('cargoplane'))
	Modelo(GetHashKey('duster'))
	Modelo(GetHashKey('s_m_m_pilot_01'))
	Modelo(GetHashKey('ruiner2'))
	ClearAreaOfEverything(-991.28100585938, -3147.8483886719, 13.944444656372, 1500, false, false, false, false, false)	
	avion = CreateVehicle(GetHashKey('cargoplane'), -991.28100585938, -3147.8483886719, 13.944444656372, 57.50, true, true)
	avioneta = CreateVehicle(GetHashKey('duster'), -929.69323730469, -3174.7514648438, 13.944438934326, 57.50, true, true)
	if Config.Framework == 'QBCORE' then
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(avioneta))
	end
	SetVehicleColours(avioneta,88,88)
	piloto = CreatePedInsideVehicle(avion, 6, 's_m_m_pilot_01', -1, true, true)
	SetVehicleOnGroundProperly(avion)
	SetEntityAsMissionEntity(avion, true, true)
	SetEntityAsMissionEntity(piloto, true, true)
	SetEntityAsMissionEntity(avioneta, true, true)
	SetVehicleEngineOn(avion, true, true, true)
	SetVehicleEngineOn(avioneta, true, true, true)
	SetEntityProofs(avion, true, true, true, true, true, true, true, false)
	SetEntityProofs(avioneta, true, true, true, true, true, true, true, false)
	local rotacion = GetEntityRotation(avion)
	SetBlockingOfNonTemporaryEvents(piloto, true)
	SetPlaneTurbulenceMultiplier(avion, 0.0)
	SetPlaneTurbulenceMultiplier(avioneta, 0.0)
	SetTaskVehicleGotoPlaneMinHeightAboveTerrain(avion,450)
	SetModelAsNoLongerNeeded(GetHashKey('cargoplane'))
	SetModelAsNoLongerNeeded(GetHashKey('s_m_m_pilot_01'))
	SetModelAsNoLongerNeeded(GetHashKey('duster'))
	for i = 1, #Config.Guards do
		Modelo(GetHashKey(Config.Guards[i].model))
		soldados[i] = CreatePed(4,GetHashKey(Config.Guards[i].model),Config.Guards[i].x, Config.Guards[i].y, Config.Guards[i].z,Config.Guards[i].h,true,true)
		SetPedAccuracy(soldados[i], math.random(70,100))
		SetEntityInvincible(soldados[i], false)
		SetEntityVisible(soldados[i], true)
		GiveWeaponToPed(soldados[i], GetHashKey(Config.Guards[i].weapon), 255, false, false)
		SetPedDropsWeaponsWhenDead(soldados[i], false)
		SetPedRelationshipGroupHash(soldados[i], GetHashKey("Guardias"))
		SetPedAlertness(soldados[i],3)
		SetRelationshipBetweenGroups(0, GetHashKey("Guardias"), GetHashKey("Guardias"))
		SetRelationshipBetweenGroups(5, GetHashKey("Guardias"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("Guardias"))
		TaskCombatPed(soldados[i],ped,0,16)
		SetPedFleeAttributes(soldados[i], 0, false)
		SetModelAsNoLongerNeeded(GetHashKey(Config.Guards[i].model))
	end
	while not cerca do
		if #(GetEntityCoords(ped) - vector3(-929.69, -3174.75, 13.94)) < 50 then
			cerca = true
		end
		if IsEntityDead(ped) then
			Cancelar()
			TriggerEvent('av_turbulence:notification',Config.Lang['failed'])
			return
		end
		Wait(300)
	end
	TriggerEvent('av_turbulence:notification',Config.Lang['jump'])
	TaskPlaneMission(piloto, avion, 0, 0, -3207.5554, -1877.2661, 323.4590, 4, GetVehicleModelMaxSpeed(GetHashKey('cargoplane'))/1.8, 1.0, 0.0, 1500.0, 1000.0)
	Wait(20000)
	TaskPlaneMission(piloto, avion, 0, 0, 487.54788208008, 5589.84765625, 822.91778564453, 4, GetVehicleModelMaxSpeed(GetHashKey('duster'))/2, 1.0, 0.0, 1500.0, 1000.0)
	Wait(65000)
	SetVehicleDoorOpen(avion,2, false,false)
	for i = 1, #npc do
		Modelo(GetHashKey(npc[i].modelo))
		local bone = GetWorldPositionOfEntityBone(avion,npc[i].bone)
		local x, y, z = table.unpack(bone)
		guardias[i] = CreatePed(4,GetHashKey(npc[i].modelo),x, y, z,npc[i].coords[4],true,true)
		AttachEntityToEntity(guardias[i], avion, npc[i].bone, npc[i].x, npc[i].y, npc[i].z, 0.0, 0.0, 230.0, true, true, true, i, true)
		SetPedCanSwitchWeapon(guardias[i], true)
		SetPedAccuracy(guardias[i], math.random(10,30))
		SetEntityInvincible(guardias[i], false)
		SetEntityVisible(guardias[i], true)
		GiveWeaponToPed(guardias[i], GetHashKey('WEAPON_MICROSMG'), 255, false, false)
		SetPedDropsWeaponsWhenDead(guardias[i], false)
		SetPedFleeAttributes(guardias[i], 0, false)
		SetPedRelationshipGroupHash(guardias[i], GetHashKey("Guardias"))
		SetPedAlertness(guardias[i],3)
		SetRelationshipBetweenGroups(0, GetHashKey("Guardias"), GetHashKey("Guardias"))
		SetRelationshipBetweenGroups(5, GetHashKey("Guardias"), GetHashKey("PLAYER"))
		SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("Guardias"))
		SetModelAsNoLongerNeeded(GetHashKey(npc[i].modelo))
	end
	Citizen.Wait(500)
	ruiner = CreateVehicle(GetHashKey('ruiner2'), -998.78509521484, -3141.0432128906, 16.402004241943, 57.50, true, true)
	if Config.Framework == 'QBCORE' then
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(ruiner))
	end
	rotacion = GetEntityRotation(avion)
	AttachEntityToEntity(ruiner, avion, 62, 0.0, 0.0, -3.34, rotacion.x, rotacion.y, rotacion.z, false, true, false, 0, false)
	SetModelAsNoLongerNeeded(GetHashKey('ruiner2'))
	while not montado do
		if #(GetEntityCoords(avion) - GetEntityCoords(avioneta)) < 100 then
			DisplayHelpTextThisFrame('entrar',true)
			if IsControlJustPressed(0,38) then
				montado = Animacion()
			end
		end
		Citizen.Wait(3)
	end
	for i = 1, #guardias do
		SetPedCombatMovement(guardias[i],0)
		DetachEntity(guardias[i],true,true)
	end
	while montado do
		if #(GetEntityCoords(ped) - GetEntityCoords(ruiner)) < 5 then
			DisplayHelpTextThisFrame('robar',true)
			if IsControlJustPressed(0,38) then
				SetVehicleDoorOpen(ruiner,0, false,true)
				Citizen.Wait(400)
				TaskWarpPedIntoVehicle(ped, ruiner, -1)
				Citizen.Wait(1000)
				SetVehicleDoorShut(ruiner, 0, true)
				DetachEntity(ruiner,true,true)
				montado = false
				SetVehicleEngineOn(ruiner,true,true,false)
			end
		end
		Citizen.Wait(3)
	end
	local lejos = false
	while not lejos do
		if #(GetEntityCoords(ped) - GetEntityCoords(avion)) > 350 then
			TriggerEvent('av_turbulence:notification', Config.Lang['bring'])
			despawn = true
			SetPlayerInvincible(PlayerId(),false)
			Cancelar()
			blip = AddBlipForCoord(destino.x, destino.y, destino.z)
			SetBlipRoute(blip, true)
			TriggerEvent('av_turbulence:gps',destino)
			lejos = true
		end
		Citizen.Wait(5000)
	end
	while entrega do
		local w = 50
		local vehiculo = GetVehiclePedIsUsing(ped)
		if GetEntityModel(vehiculo) ~= GetHashKey('ruiner2') then
			TriggerEvent('av_turbulence:notification',Config.Lang['failed'])
			entrega = false
			RemoveBlip(blip)
			blip = nil
			remover = true
		end
		if #(GetEntityCoords(ped) - vector3(destino.x, destino.y, destino.z)) < 5 then
			w = 3
			DrawText3D(destino.x, destino.y, destino.z, Config.Lang['deliver'])
			if IsControlJustPressed(0,74) and entrega then
				if GetEntityModel(vehiculo) == GetHashKey('ruiner2') then
					entrega = false
					TaskLeaveVehicle(ped, vehiculo, 0)
					while IsPedInVehicle(ped, vehiculo, true) do
						Citizen.Wait(0)
					end			
					Citizen.Wait(1000)
					SetEntityAsMissionEntity(vehiculo,true,true)
					DeleteVehicle(vehiculo)
					ruiner = nil
					RemoveBlip(blip)
					blip = nil
					TriggerServerEvent('av_turbulence:MakeItRain',z)
					final()
				end
			end
		end
		Citizen.Wait(w)
	end
end)

RegisterNetEvent('av_turbulence:gps')
AddEventHandler('av_turbulence:gps', function(d)
	local destino = d
	remover = false
	while not remover do
		local coords = GetEntityCoords(PlayerPedId())
		TriggerServerEvent('av_turbulence:policeGPS',coords)
		Citizen.Wait(2300)
		if #(coords - vector3(destino.x, destino.y, destino.z)) < 1000 then
			TriggerEvent('av_turbulence:notification',Config.Lang['gps'])
			remover = true
		end
	end
end)

RegisterNetEvent('av_turbulence:policenotify')
AddEventHandler('av_turbulence:policenotify', function()
	if myJob == Config.PoliceJob then
		TriggerEvent('av_turbulence:notification',Config.Lang['rob_progress'])
	end
end)

RegisterNetEvent('av_turbulence:ruinerblip')
AddEventHandler('av_turbulence:ruinerblip', function(targetCoords)
	if myJob == Config.PoliceJob then
		local alpha = 250
		local ruinerblip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)
		SetBlipHighDetail(ruinerblip, true)
		SetBlipColour(ruinerblip, 1)
		SetBlipAlpha(ruinerblip, alpha)
		SetBlipAsShortRange(ruinerblip, true)
		while alpha ~= 0 do
			Citizen.Wait(4 * 4)
			alpha = alpha - 1
			SetBlipAlpha(ruinerblip, alpha)
			if alpha == 0 then
				RemoveBlip(ruinerblip)
				return
			end
		end		
	end
end)

-- Other Job checks based on Framework:

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	myJob = job.name
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local player = QBCore.Functions.GetPlayerData()
    myJob = player.job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    myJob = JobInfo.name
end)

if Config.Framework == 'VRP' then
	function tvRP.setCop(flag)
		if flag == true then
			myJob = 'police'
		else
			myJob = ''
		end
	end
end

--- Death Checks based on Framework:

AddEventHandler('esx:onPlayerDeath', function(data)
	if robando then
		TriggerEvent('av_stores:notification',Config.Lang['failed'])
		robando = false
		Cancelar()
	end
end)

-- Functions, animations, other stuff don't edit anything

function Animacion()
	Modelo('cropduster1_skin')
	Modelo('cropduster2_skin')
	Modelo('cropduster3_skin')
	Modelo('cropduster4_skin')
	local p = PlayerPedId()
	SetPlayerInvincible(PlayerId(),true)
	local rot, pos = GetEntityRotation(avion), GetEntityCoords(avion)
	local plypos = GetEntityCoords(p)
	local entrada = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 2, 0, 0, 1065353216, 0, 1.3)
	local dict = "exl_1_mcs_1_p3_b-0"
	loadAnimDict(dict)
	DeleteEntity(avioneta)
	avioneta = nil
	local obj1 = CreateObject(GetHashKey("cropduster1_skin"), plypos.x, plypos.y, plypos.z,  true,  true, false)
	local obj2 = CreateObject(GetHashKey("cropduster2_skin"), plypos.x, plypos.y, plypos.z,  true,  true, false)
	local obj3 = CreateObject(GetHashKey("cropduster3_skin"), plypos.x, plypos.y, plypos.z,  true,  true, false)
	local obj4 = CreateObject(GetHashKey("cropduster4_skin"), plypos.x, plypos.y, plypos.z,  true,  true, false)
	local cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, 0, 3000, 1, 0)
	NetworkAddPedToSynchronisedScene(p, entrada, dict, "player_two_dual-0", 4.0, -4.0, 1033, 0, 1000.0, 0)
	NetworkAddEntityToSynchronisedScene(avion, entrada, dict, "cargoplane-0", 1.0, -1.0, 0, 0)
	NetworkAddEntityToSynchronisedScene(obj1, entrada, dict, "cropduster1_skin-0", 1.0, -1.0, 0, 0)
	NetworkAddEntityToSynchronisedScene(obj2, entrada, dict, "cropduster2_skin-0", 1.0, -1.0, 0, 0)
	NetworkAddEntityToSynchronisedScene(obj3, entrada, dict, "cropduster3_skin-0", 1.0, -1.0, 0, 0)
	NetworkAddEntityToSynchronisedScene(obj4, entrada, dict, "cropduster4_skin-0", 1.0, -1.0, 0, 0)
	ForceEntityAiAndAnimationUpdate(avion)
	ForceEntityAiAndAnimationUpdate(obj1)
	ForceEntityAiAndAnimationUpdate(obj2)
	ForceEntityAiAndAnimationUpdate(obj3)
	ForceEntityAiAndAnimationUpdate(obj4)
	NetworkStartSynchronisedScene(entrada)
	PlayCamAnim(cam, 'exportcamera-0', dict, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 0, 2)
	Citizen.Wait(5800)
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
	DeleteEntity(obj1)
	DeleteEntity(obj2)
	DeleteEntity(obj3)
	DeleteEntity(obj4)
	SetModelAsNoLongerNeeded('cropduster1_skin')
	SetModelAsNoLongerNeeded('cropduster2_skin')
	SetModelAsNoLongerNeeded('cropduster3_skin')
	SetModelAsNoLongerNeeded('cropduster4_skin')
	return true
end

function Modelo(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

function loadAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Cancelar()
    end
end)

function final()
	avion, avioneta, piloto, ruiner = nil, nil, nil, nil
end

function Cancelar()
	if DoesEntityExist(piloto) then
		SetEntityAsNoLongerNeeded(piloto)
		DeleteEntity(piloto)
	end
	if #guardias > 0 then
		for i = 1, #guardias do
			if DoesEntityExist(guardias[i]) then
				SetEntityAsNoLongerNeeded(guardias[i])
				DeleteEntity(guardias[i])
			end
		end
	end
	if avion then
		SetEntityAsMissionEntity(avion)
		DeleteVehicle(avion)
	end
	if avioneta then
		SetEntityAsMissionEntity(avioneta)
		DeleteVehicle(avioneta)
	end
	if #soldados > 0 then
		for i = 1, #soldados do
			if DoesEntityExist(soldados[i]) then
				SetEntityAsNoLongerNeeded(soldados[i])
				DeleteEntity(soldados[i])
			end
		end
	end
	final()
end