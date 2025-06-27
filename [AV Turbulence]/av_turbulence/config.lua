--[[
	* If you are using VRP or QBCORE uncomment your Framework dependencies from fxmanifest.lua
	* Discord config is inside server/main.lua
	* Join my Discord and open a Ticket if you need support: https://discord.com/invite/SXSZT6q
]]--

Config = {}
Config.Framework = 'ESX' -- Framework: 'ESX', 'QBCORE', 'VRP' or 'Standalone'.
Config.rewardMoney = math.random(30000,50000) -- Money reward the player receives when delivering the vehicle.
Config.PoliceJob = 'police' -- Your Police Job Name.
Config.MinCops = 0 -- Min cops online to start the robbery.
Config.StartCoords = {x = 720.9846, y = -965.6559, z = 30.3953} -- Where the robbery starts.
Config.CooldownTime = 60 -- Cooldown in minutes (1 hour by default).
Config.Guards = {
	[1] = {model = 's_m_y_blackops_01', x = -949.8674, y = -3110.1658, z = 13.9444, h = 10.9685, weapon = 'WEAPON_COMBATPISTOL'},
	[2] = {model = 's_m_y_blackops_01', x = -963.2929, y = -3113.5161, z = 13.9444, h = 42.3006, weapon = 'WEAPON_COMBATPISTOL'},
	[3] = {model = 's_m_y_blackops_01', x = -963.5256, y = -3105.7263, z = 13.9444, h = 41.4308, weapon = 'WEAPON_COMBATPISTOL'},
	[4] = {model = 's_m_y_blackops_01', x = -992.9733, y = -3068.6292, z = 13.9444, h = 41.1591, weapon = 'WEAPON_COMBATPISTOL'},
	[5] = {model = 's_m_y_blackops_01', x = -1008.7501, y = -3094.3560, z = 13.9444, h = 20.3427, weapon = 'WEAPON_COMBATPISTOL'},
}

Config.DeliveryLocations = { -- It will pick a random location from the list to prevent Metagaming
	{x = 2209.21, y = 5613.21, z = 53.85},
	{x = 872.08, y = 2867.57, z = 56.88},
	{x = 710.55, y = 4178.78, z = 40.70},
	{x = 906.48, y = -1518.11, z = 30.41},
}
Config.Lang = {
	['cooldown'] = 'Cooldown activo',
	['start'] = '[~r~E~w~] para llamar a la puerta',
	['mission'] = 'Ve al aeropuerto y tráeme el vehículo',
	['bring'] = 'Sigue el GPS y tráeme el vehículo',
	['vehicle'] = 'El vehículo está dentro del avión de carga',
	['jump'] = 'Coge el plumero y persigue el avión de carga',
	['enter'] = '[~b~E~w~] para entrar',
	['deliver'] = '[~y~H~w~] para entregar el vehículo',
	['gps'] = 'GPS removido, pierde a los policías',
	['failed'] = 'Misión fallida',
	['no_cops'] = 'Misión fallida',
	['received'] = 'Ha recibido $',
	['rob_progress'] = 'SecuroServ ha denunciado el robo de su prototipo de vehículo, compruebe su ubicación en el GPS'
}

RegisterNetEvent('av_turbulence:notification')
AddEventHandler('av_turbulence:notification', function(msg)
--	Example for Mythic Notify:
-- exports['mythic_notify']:SendAlert('inform',msg)

--	Example for QBCore:
--  QBCore.Functions.Notify(msg)

--	Example for ESX:
	ESX.ShowNotification(msg)
end)