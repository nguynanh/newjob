fx_version 'cerulean'
game 'gta5'
description 'AV Turbulence'
version '1.0.0'

files {
	'weaponvehicleruiner.meta',
	'vehicles.meta',
}

shared_scripts {
    'config.lua',
	'@pmc-callbacks/import.lua',
--	'@qb-core/import.lua', -- UNCOMMENT THIS IF YOU ARE USING QBCORE
}

client_scripts {
--	'lib/Proxy.lua', --UNCOMMENT THIS IF YOU USE VRP
--	'lib/Tunnel.lua', --UNCOMMENT THIS IF YOU USE VRP
	'client/*.lua',
}

server_scripts {
--	'@vrp/lib/utils.lua', --UNCOMMENT THIS IF YOU USE VRP
	'server/main.lua'
}

dependencies {
	'pmc-callbacks',
--	'vrp' --UNCOMMENT THIS IF YOU USE VRP
}

data_file 'WEAPONINFO_FILE_PATCH' 'weaponvehicleruiner.meta'
data_file 'WEAPONINFO_FILE' 'weaponvehicleruiner.meta'