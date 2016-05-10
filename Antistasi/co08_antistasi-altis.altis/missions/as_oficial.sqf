if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;

_posicion = getMarkerPos _marcador;

_tiempolim = 30;//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_marcador] call localizar;
[] call playerIsOwner;
_tsk = ["AS",true,[format ["A CSAT officer is inspecting %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Officer",_marcador],_posicion,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
_grp = createGroup EAST;

_oficial = _grp createUnit ["O_officer_F", _posicion, [], 0, "NONE"];
_piloto = _grp createUnit ["O_helipilot_F", _posicion, [], 0, "NONE"];

_grp selectLeader _oficial;
sleep 1;
_nul = [leader _grp, _marcador, "SAFE", "SPAWNED", "NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";

{_nul = [_x] spawn CSATinit; _x allowFleeing 0} forEach units _grp;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _oficial)};

if (not alive _oficial) then
	{
	[] call playerIsOwner;
	_tsk = ["AS",true,[format ["A CSAT officer is inspecting a %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Officer",_marcador],_posicion,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	[3,0] remoteExecCall ["prestige",2];
	[0,300] remoteExecCall ["resourcesFIA",2];
	[-5,10,_posicion] remoteExecCall ["citySupportChange",2];
	//AAFcourage= AAFcourage -0.1;
	//AAFcommanding= AAFcommanding - 0.1;
	[1800] remoteExec ["timingCA",2];
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"BLUFORSpawn"] call distanceUnits);
	[5,stavros] call playerScoreAdd;
	}
else
	{
	[] call playerIsOwner;
	_tsk = ["AS",true,[format ["A CSAT officer is inspecting a %1. Go there and kill him before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"Kill the Officer",_marcador],_posicion,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	//AAFcourage= AAFcourage + 0.1;
	//AAFcommanding= AAFcommanding + 0.1;
	[-600] remoteExec ["timingCA",2];
	[-10,stavros] call playerScoreAdd;
	};

{deleteVehicle _x} forEach units _grp;
deleteGroup _grp;

//sleep (600 + random 1200);
//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,_tsk] spawn borrarTask;


