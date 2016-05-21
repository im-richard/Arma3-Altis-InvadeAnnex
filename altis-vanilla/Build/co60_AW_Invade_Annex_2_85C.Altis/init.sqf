/*
@filename: init.sqf
Author:
	
	Quiksilver

Last modified:

	12/05/2014
	
Description:

	Things that may run on both server and client.
	Deprecated initialization file, still using until the below is correctly partitioned between server and client.
______________________________________________________*/

["Initialize"] call BIS_fnc_dynamicGroups;

for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do {
	call compile format
	[
		"PARAMS_%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};



execVM "scripts\grenadestop.sqf"												//Safezones
call compile preprocessfile "scripts\=BTC=_revive\=BTC=_revive_init.sqf";		// revive