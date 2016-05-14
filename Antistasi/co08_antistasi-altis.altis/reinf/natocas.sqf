if (!isServer and hasInterface) exitWith {};

_prestigio = server getVariable "prestigeNATO";
_aeropuertos = aeropuertos - mrkAAF + ["spawnNATO"];

_origen = [_aeropuertos,stavros] call BIS_fnc_nearestPosition;
_orig = getMarkerPos _origen;

[-10,0] remoteExecCall ["prestige",2];

_tiempolim = _prestigio;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombreorig = "the NATO Carrier";
if (_origen!= "spawnNATO") then {_nombreorig = [_origen] call localizar};
[] call playerIsOwner;
_tsk = ["NATOCAS",true,[format ["NATO is providing Air support from %1. They will be under our command until %2:%3.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"NATO CAS",_origen],_orig,"CREATED",5,true,true,"Attack"] call BIS_fnc_setTask;
_tipoVeh = "B_Heli_Light_01_armed_F";
_cuenta = 1;
if (_prestigio > 70) then
	{
	_tipoVeh = "B_Plane_CAS_01_F";
	if (_prestigio > 85) then {_cuenta = 3};
	}
else
	{
	if (_prestigio > 30) then
		{
		_tipoVeh = "B_Heli_Attack_01_F";
		if (_prestigio > 50) then
			{
			_cuenta = 3;
			};
		}
	else
		{
		if (_prestigio > 15) then {_cuenta = 3};
		};
	};

_soldados = [];
_vehiculos = [];

_grupoHeli = createGroup WEST;
_grupoHeli setGroupId ["CAS"];
hint format ["NATO CAS will be available on HC module in %1 seconds.",(_cuenta * 10) + 5];

for "_i" from 1 to (ceil random _cuenta) do
	{
	_helifn = [_orig, 0, _tipoVeh, WEST] call bis_fnc_spawnvehicle;
	_heli = _helifn select 0;
	_vehiculos pushBack _heli;
	_heliCrew = _helifn select 1;
	_grupoheliTmp = _helifn select 2;
	{[_x] spawn NATOinitCA; _soldados pushBack _x; [_x] join _grupoHeli} forEach _heliCrew;
	deleteGroup _grupoheliTmp;
	[_heli] spawn NATOVEHinit;
	_heli setPosATL [getPosATL _heli select 0, getPosATL _heli select 1, 1000];
	//_heli flyInHeight 50;
	//[_heli] spawn unlimitedAmmo;
	//_nul = [_heli,"NATO CAS"] spawn inmuneConvoy;
	sleep 10;
	};
/*
if (_tipoVeh != "B_Plane_CAS_01_F") then
	{
	CAS_heli synchronizeObjectsAdd [leader _grupoheli];
	(leader _grupoheli) synchronizeObjectsAdd [CAS_heli];
	}
else
	{
	CAS_plane synchronizeObjectsAdd [leader _grupoheli];
	(leader _grupoheli) synchronizeObjectsAdd [CAS_plane];
	};
*/
Stavros hcSetGroup [_grupoHeli];

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or ({alive _x} count _vehiculos == 0) or ({canMove _x} count _vehiculos == 0)};

if (dateToNumber date > _fechalimnum) then
	{
	[["TaskSucceeded", ["", "NATO CAS finished"]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
	}
else
	{
	[] call playerIsOwner;
	_tsk = ["NATOCAS",true,[format ["NATO is providing Air support from %1. They will be under our command until %2:%3.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],"NATO CAS",_origen],_orig,"FAILED",5,true,true,"Attack"] call BIS_fnc_setTask;
	[-5,0] remoteExecCall ["prestige",2];
	};

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
_nul = [0,_tsk] spawn borrarTask;
//if (_tipoVeh != "B_Plane_CAS_01_F") then {CAS_heli synchronizeObjectsRemove [leader _grupoheli]} else {CAS_plane synchronizeObjectsRemove [leader _grupoheli]};
{deleteVehicle _x} forEach _soldados;
{deleteVehicle _x} forEach _vehiculos;
deleteGroup _grupoheli;