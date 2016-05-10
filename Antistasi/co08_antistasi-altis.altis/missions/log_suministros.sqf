if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;
_nombredest = [_marcador] call localizar;
[] call playerIsOwner;
_tsk = ["LOG",true,[format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserved a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"City Supplies",_marcador],_posicion,"CREATED",5,true,true,"Support"] call BIS_fnc_setTask;
_pos = position Petros findEmptyPosition [1,50,"C_Van_01_box_F"];

_camion = "C_Van_01_box_F" createVehicle _pos;
[_camion] spawn VEHinit;
{_x reveal _camion} forEach (allPlayers - hcArray);

waitUntil {sleep 1; (not alive _camion) or (dateToNumber date > _fechalimnum) or (_camion distance _posicion < 40)};

if ((not alive _camion) or (dateToNumber date > _fechalimnum)) then
	{
	[] call playerIsOwner;
	_tsk = ["LOG",true,[format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserven a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"City Supplies",_marcador],_posicion,"FAILED",5,true,true,"Support"] call BIS_fnc_setTask;
	[5,-5,_posicion] remoteExecCall ["citySupportChange",2];
	[-10,stavros] call playerScoreAdd;
	}
else
	{
	_cuenta = 120;//120
	[_posicion] remoteExec ["patrolCA",HCattack];
	{_amigo = _x;
	if (captive _amigo) then
		{
		[_amigo,false] remoteExec ["setCaptive",_amigo];
		};
	{
	if ((side _x == independent) and (_x distance _posicion < distanciaSPWN)) then
		{
		if (_x distance _posicion < 300) then {_x doMove _posicion} else {_x reveal [_amigo,4]};
		};
	if ((side _x == civilian) and (_x distance _posicion < 300)) then {_x doMove position _camion};
	} forEach allUnits;
	} forEach ([300,0,_camion,"BLUFORSpawn"] call distanceUnits);
	while {(_cuenta > 0)/* or (_camion distance _posicion < 40)*/ and (alive _camion) and (dateToNumber date < _fechalimnum)} do
		{
		while {(_cuenta > 0) and (_camion distance _posicion < 40) and (alive _camion) and !({_x getVariable ["inconsciente",false]} count ([80,0,_camion,"BLUFORSpawn"] call distanceUnits) == count ([80,0,_camion,"BLUFORSpawn"] call distanceUnits))} do
			{
			_formato = format ["%1", _cuenta];
			///[[petros,"countdown",_formato],"commsMP"] call BIS_fnc_MP;
			{if (isPlayer _x) then {[petros,"countdown",_formato] remoteExec ["commsMP",_x]}} forEach ([80,0,_camion,"BLUFORSpawn"] call distanceUnits);
			sleep 1;
			_cuenta = _cuenta - 1;
			};
		if (_cuenta > 0) then
			{
			_cuenta = 120;//120
			if (((_camion distance _posicion > 40) or (not([80,1,_camion,"BLUFORSpawn"] call distanceUnits))) and (alive _camion)) then {[[petros,"hint","Don't get the truck far from the city center, and stay close to it, or count will restart"],"commsMP"] call BIS_fnc_MP};
			waitUntil {sleep 1; (!alive _camion) or ((_camion distance _posicion < 40) and ([80,1,_camion,"BLUFORSpawn"] call distanceUnits))};
			};
		if ((alive _camion) and (_cuenta < 1)) exitWith {};
		};
		if ((alive _camion) and (dateToNumber date < _fechalimnum)) then
			{
			[[petros,"hint","Supplies Delivered"],"commsMP"] call BIS_fnc_MP;
			[] call playerIsOwner;
			_tsk = ["LOG",true,[format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserved a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"City Supplies",_marcador],_posicion,"SUCCEEDED",5,true,true,"Support"] call BIS_fnc_setTask;
			[0,15,_marcador] remoteExecCall ["citySupportChange",2];
			[5,0] remoteExecCall ["prestige",2];
			{if (_x distance _posicion < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
			[5,stavros] call playerScoreAdd;
			}
		else
			{
			[] call playerIsOwner;
			_tsk = ["LOG",true,[format ["%1 population is in need of supplies. We may improve our relationship with that city if we are the ones who provide them. I reserven a transport truck with supplies near our HQ. Drive the transport truck to %1 city center. Hold it there for 2 minutes and it's done. Do this before %2:%3.",_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"City Supplies",_marcador],_posicion,"FAILED",5,true,true,"Support"] call BIS_fnc_setTask;
			[5,-5,_posicion] remoteExecCall ["citySupportChange",2];
			[-10,stavros] call playerScoreAdd;
			};
	};

_camion setFuel 0;

//sleep (600 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [1200,_tsk] spawn borrarTask;
waitUntil {sleep 1; (not([distanciaSPWN,1,_camion,"BLUFORSpawn"] call distanceUnits)) or (_camion distance position petros < 60)};
deleteVehicle _camion;
