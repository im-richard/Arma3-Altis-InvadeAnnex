if (!isServer and hasInterface) exitWith {};
_destino = _this select 0;
_base = _this select 1;

_posbase = getMarkerPos _base;
_posdestino = getMarkerPos _destino;

_soldados = [];
_grupos = [];
_vehiculos = [];
_POWS = [];

_tipoVehEsc = "";
_tipoVehObj = "";
_tipogrupo = "";
_tiposConvoy = [];
_posHQ = getMarkerPos "respawn_west";

_tiempofin = 120;
_fechafin = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempofin];
_fechafinNum = dateToNumber _fechafin;

private ["_tsk","_grpPOW","_pos"];

if ((_destino in bases) or (_destino in aeropuertos)) then {_tiposConvoy = ["Municion","Armor","Prisoners"];};
if (_destino in ciudades) then
	{
	if (_destino in mrkAAF) then {_tiposConvoy = ["Money","Supplies"]} else {_tiposConvoy = ["Supplies"]}
	};

_tipoConvoy = _tiposConvoy call BIS_Fnc_selectRandom;

_tiempolim = round random 15;// tiempo para que salga el convoy, deberíamos poner un round random 15
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_nombredest = [_destino] call localizar;
_nombreOrig = [_base] call localizar;
[] call playerIsOwner;
if (_tipoConvoy == "Municion") then
	{
	_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will provide ammunition to %4. Try to intercept it. Steal or destroy that truck before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Ammo Convoy",_destino],_posdestino,"CREATED",5,true,true,"Interact"] call BIS_fnc_setTask;
	_tipoVehObj = "I_Truck_02_ammo_F";
	};

if (_tipoConvoy == "Armor") then
	{
	_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will reinforce %4 with armored vehicles. Try to intercept it. Steal or destroy that thing before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Armored Convoy",_destino],_posdestino,"CREATED",5,true,true,"Destroy"] call BIS_fnc_setTask;
	if ("I_MBT_03_cannon_F" in vehAAFAT) then {_tipoVehObj = "I_MBT_03_cannon_F";} else { _tipoVehObj = "O_MBT_02_arty_F";};
	};

if (_tipoConvoy == "Prisoners") then
	{
	_tsk = ["CONVOY",true,[format ["A group os POW's is being transported from %1 to %4, and it's about to depart at %2:%3. They are awaiting for execution. Try to intercept it. Kill or capture the truck driver to make them join you and bring them to HQ. Alive if possible.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Prisoner Convoy",_destino],_posdestino,"CREATED",5,true,true,"Support"] call BIS_fnc_setTask;
	_tipoVehObj = "I_Truck_02_covered_F";
	};

if (_tipoConvoy == "Money") then
	{
	_tsk = ["CONVOY",true,[format ["A truck plenty of money is being moved from %1 to %4, and it's about to depart at %2:%3. Steal that truck and bring it to HQ. Those funds will be very welcome.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Money Convoy",_destino],_posdestino,"CREATED",5,true,true,"Interact"] call BIS_fnc_setTask;
	_tipoVehObj = "C_Van_01_box_F";
	};

if (_tipoConvoy == "Supplies") then
	{
	_tsk = ["CONVOY",true,[format ["A truck with medical supplies destination %4 it's about to depart at %2:%3 from %1. Steal that truck bring it to %4 and let people in there know it is FIA who's giving those supplies.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Supply Convoy",_destino],_posdestino,"CREATED",5,true,true,"Interact"] call BIS_fnc_setTask;
	_tipoVehObj = "C_Van_01_box_F";
	};
sleep (_tiempolim * 60);

_tam = 10;
_roads = [];

while {true} do
	{
	_roads = _posbase nearRoads _tam;
	if (count _roads > 0) exitWith {};
	_tam = _tam + 10;
	};

_road = _roads select 0;

_grupo = createGroup independent;
_grupos = _grupos + [_grupo];

_vehicle=[position _road, 0,"I_MRAP_03_hmg_F", _grupo] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] spawn AAFVEHinit;
[_veh,"AAF Convoy Lead"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] spawn AAFinit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_veh];

_wp0 = _grupo addWaypoint [_posdestino, 0];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointBehaviour "SAFE";
_wp0 setWaypointSpeed "LIMITED";
_wp0 setWaypointFormation "COLUMN";

_cuenta = 1;
if (([_destino] call isFrontline) or (_destino in mrkFIA)) then {_cuenta = (round random 2) + 1};

for "_i" from 1 to _cuenta do
	{
	sleep 15;
	if (count vehAAFAT > 1) then
		{
		_vehAAFAT = vehAAFAT - ["I_Truck_02_covered_F"];
		_tipoVehEsc = _vehAAFAT call BIS_fnc_selectRandom;
		}
	else
		{
		_tipoVehEsc = "I_Truck_02_covered_F";
		};

	//_pos = position _road findEmptyPosition [1,30,_tipoVehEsc];
	_vehicle=[position _road, 0,_tipoVehEsc, _grupo] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	[_veh] spawn AAFVEHinit;
	[_veh,"AAF Convoy Escort"] spawn inmuneConvoy;
	_vehCrew = _vehicle select 1;
	{[_x] spawn AAFinit} forEach _vehCrew;
	_grupoVeh = _vehicle select 2;
	_soldados = _soldados + _vehCrew;
	_grupos = _grupos + [_grupoVeh];
	_vehiculos = _vehiculos + [_veh];

	if (_tipoVehEsc != "I_MBT_03_cannon_F") then
		{
		if (_tipoVehEsc == "I_APC_tracked_03_cannon_F") then {_tipogrupo = gruposAAFmid call BIS_fnc_selectRandom} else {_tipogrupo = "HAF_InfSquad"};
		_grupoEsc = [_posbase,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> _tipogrupo)] call BIS_Fnc_spawnGroup;
		{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x];[_x] join _grupo} forEach units _grupoEsc;
		deleteGroup _grupoEsc;
		if (_tipoVehEsc != "I_Truck_02_covered_F") then
			{
			[_veh] spawn smokeCover;
			};
		};
	};

sleep 15;

//_pos = position _road findEmptyPosition [1,30,_tipoVehObj];
_vehicle=[position _road, 0,_tipoVehObj, _grupo] call bis_fnc_spawnvehicle;
_vehObj = _vehicle select 0;
[_vehObj] spawn AAFVEHinit;
[_vehObj,"AAF Convoy Objective"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] spawn AAFinit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_vehObj];

if (_tipoConvoy == "Armor") then {_vehObj lock 3;};
if (_tipoConvoy == "Prisoners") then
	{
	_grpPOW = createGroup west;
	_grupos = _grupos + [_grpPOW];
	for "_i" from 1 to (1+ round (random 11)) do
		{
		_unit = _grpPOW createUnit ["b_g_survivor_F", _posbase, [], 0, "NONE"];
		_unit setCaptive true;
		_unit disableAI "MOVE";
		_unit setBehaviour "CARELESS";
		_unit allowFleeing 0;
		_unit assignAsCargo _vehObj;
		_unit moveInCargo [_vehObj, _i + 3];
		removeAllWeapons _unit;
		removeAllAssignedItems _unit;
		[[_unit,"refugiado"],"flagaction"] call BIS_fnc_MP;
		sleep 1;
		_POWS = _POWS + [_unit];
		};
	};
if ((_tipoConvoy == "Money") or (_tipoConvoy == "Supplies")) then {reportedVehs pushBack _vehObj; publicVariable "reportedVehs"};

sleep 15;

if (count vehAAFAT > 1) then
	{
	_vehAAFAT = vehAAFAT - ["I_Truck_02_covered_F"];
	_tipoVehEsc = _vehAAFAT call BIS_fnc_selectRandom;
	}
else
	{
	_tipoVehEsc = "I_Truck_02_covered_F";
	};

//_pos = position _road findEmptyPosition [1,30,_tipoVehEsc];
_vehicle=[position _road, 0,_tipoVehEsc, _grupo] call bis_fnc_spawnvehicle;
_veh = _vehicle select 0;
[_veh] spawn AAFVEHinit;
[_veh,"AAF Convoy Escort"] spawn inmuneConvoy;
_vehCrew = _vehicle select 1;
{[_x] spawn AAFinit} forEach _vehCrew;
_grupoVeh = _vehicle select 2;
_soldados = _soldados + _vehCrew;
_grupos = _grupos + [_grupoVeh];
_vehiculos = _vehiculos + [_veh];

if (_tipoVehEsc != "I_MBT_03_cannon_F") then
	{
	if (_tipoVehEsc == "I_APC_tracked_03_cannon_F") then {_tipogrupo = gruposAAFmid call BIS_fnc_selectRandom} else {_tipogrupo = "HAF_InfSquad"};
	_grupoEsc = [_posbase,independent, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> _tipogrupo)] call BIS_Fnc_spawnGroup;
	{[_x] spawn AAFinit;_x assignAsCargo _veh;_x moveInCargo _veh; _soldados = _soldados + [_x];[_x] join _grupo} forEach units _grupoEsc;
	deleteGroup _grupoEsc;
	if (_tipoVehEsc != "I_Truck_02_covered_F") then
		{
		[_veh] spawn smokeCover;
		};
	};


if (_tipoConvoy == "Municion") then
	{
	waitUntil {sleep 1; (dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};
	if ((_vehObj distance _posdestino < 100) or (dateToNumber date >_fechafinNum)) then
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will provide ammunition to %4. Try to intercept it. Steal or destroy that truck before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Ammo Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
		[-1200] remoteExec ["timingCA",2];
		[-10,stavros] call playerScoreAdd;
		clearMagazineCargoGlobal _vehObj;
		clearWeaponCargoGlobal _vehObj;
		clearItemCargoGlobal _vehObj;
		clearBackpackCargoGlobal _vehObj;
		}
	else
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will provide ammunition to %4. Try to intercept it. Steal or destroy that truck before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Ammo Convoy",_destino],_posdestino,"SUCCEEDED",5,true,true,"Interact"] call BIS_fnc_setTask;
		[0,300] remoteExecCall ["resourcesFIA",2];
		[1800] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_vehObj,"BLUFORSpawn"] call distanceUnits);
		[5,stavros] call playerScoreAdd;
		[position _vehObj] spawn patrolCA;
		};
	};

if (_tipoConvoy == "Armor") then
	{
	waitUntil {sleep 1; (dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};
	if ((_vehObj distance _posdestino < 100) or (dateToNumber date > _fechafinNum)) then
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will reinforce %4 with armored vehicles. Try to intercept it. Steal or destroy that thing before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Armored Convoy",_destino],_posdestino,"FAILED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		tanksAAFcurrent = tanksAAFcurrent + 1;
		server setVariable [_destino,false,true];
		[-1200] remoteExec ["timingCA",2];
		[-10,stavros] call playerScoreAdd;
		}
	else
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A convoy from %1 is about to depart at %2:%3. It will reinforce %4 with armored vehicles. Try to intercept it. Steal or destroy that thing before it reaches it's destination.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Armored Convoy",_destino],_posdestino,"SUCCEEDED",5,true,true,"Destroy"] call BIS_fnc_setTask;
		[5,0] remoteExecCall ["prestige",2];
		[-5,5,_destino] remoteExecCall ["citySupportChange",2];
		[1800] remoteExec ["timingCA",2];
		{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_vehObj,"BLUFORSpawn"] call distanceUnits);
		[5,stavros] call playerScoreAdd;
		[position _vehObj] spawn patrolCA;
		};
	};

if (_tipoConvoy == "Prisoners") then
	{
	waitUntil {sleep 1; (dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive driver _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false]) or ({alive _x} count _POWs == 0)};
	if ((_vehObj distance _posdestino < 100) or ({alive _x} count _POWs == 0) or (dateToNumber date > _fechafinNum)) then
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A group os POW's is being transported from %1 to %4, and it's about to depart at %2:%3. They are awaiting for execution. Try to intercept it. Kill or capture the truck driver to make them join you and bring them to HQ. Alive if possible.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Prisoner Convoy",_destino],_posdestino,"FAILED",5,true,true,"Support"] call BIS_fnc_setTask;
		{_x setCaptive false} forEach _POWs;
		_cuenta = 2 * (count _POWs);
		[_cuenta,0] remoteExecCall ["prestige",2];
		[-10,stavros] call playerScoreAdd;
		};
	if ((not alive driver _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])) then
		{
		[position _vehObj] spawn patrolCA;
		{_x setCaptive false; _x enableAI "MOVE"; [_x] orderGetin false;} forEach _POWs;
		waitUntil {sleep 2; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance _posHQ < 50)} count _POWs > 0) or (dateToNumber date > _fechafinNum)};
		if (({alive _x} count _POWs == 0) or (dateToNumber date > _fechafinNum)) then
			{
			[] call playerIsOwner;
			_tsk = ["CONVOY",true,[format ["A group os POW's is being transported from %1 to %4, and it's about to depart at %2:%3. They are awaiting for execution. Try to intercept it. Kill or capture the truck driver to make them join you and bring them to HQ. Alive if possible.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Prisoner Convoy",_destino],_posdestino,"FAILED",5,true,true,"Support"] call BIS_fnc_setTask;
			_cuenta = 2 * (count _POWs);
			[_cuenta,0] remoteExecCall ["prestige",2];
			[0,- _cuenta, _destino] remoteExecCall ["citySupportChange",2];
			[-10,stavros] call playerScoreAdd;
			}
		else
			{
			[] call playerIsOwner;
			_tsk = ["CONVOY",true,[format ["A group os POW's is being transported from %1 to %4, and it's about to depart at %2:%3. They are awaiting for execution. Try to intercept it. Kill or capture the truck driver to make them join you and bring them to HQ. Alive if possible.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Prisoner Convoy",_destino],_posdestino,"SUCCEEDED",5,true,true,"Support"] call BIS_fnc_setTask;
			_cuenta = {(alive _x) and (_x distance _posHQ < 150)} count _POWs;
			_hr = _cuenta;
			_resourcesFIA = 300 * _cuenta;
			[_hr,_resourcesFIA] remoteExecCall ["resourcesFIA",2];
			[-5,10,_destino] remoteExecCall ["citySupportChange",2];
			[2*_cuenta,0] remoteExecCall ["prestige",2];
			{[_x] join _grppow; [_x] orderGetin false} forEach _POWs;
			{[_cuenta,_x] call playerScoreAdd} forEach (allPlayers - hcArray);
			[round (_cuenta/2),stavros] call playerScoreAdd;
			};
		};
	};

if (_tipoConvoy == "Money") then
	{
	waitUntil {sleep 1; (dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};
	if ((dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive _vehObj)) then
		{
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A truck plenty of money is being moved from %1 to %4, and it's about to depart at %2:%3. Steal that truck and bring it to HQ. Those funds will be very welcome.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Money Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
		if ((dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100)) then
			{
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF + 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[-1200] remoteExec ["timingCA",2];
			[-10,stavros] call playerScoreAdd;
			}
		else
			{
			[position _vehObj] spawn patrolCA;
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[1200] remoteExec ["timingCA",2];
			};
		};
	if (driver _vehObj getVariable ["BLUFORSpawn",false]) then
		{
		[position _vehObj] spawn patrolCA;
		waitUntil {sleep 2; (_vehObj distance _posHQ < 50) or (not alive _vehObj) or (dateToNumber date > _fechafinNum)};
		if ((not alive _vehObj) or (dateToNumber date > _fechafinNum)) then
			{
			[] call playerIsOwner;
			_tsk = ["CONVOY",true,[format ["A truck plenty of money is being moved from %1 to %4, and it's about to depart at %2:%3. Steal that truck and bring it to HQ. Those funds will be very welcome.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Money Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[1200] remoteExec ["timingCA",2];
			};
		if (_vehObj distance _posHQ < 50) then
			{
			[] call playerIsOwner;
			_tsk = ["CONVOY",true,[format ["A truck plenty of money is being moved from %1 to %4, and it's about to depart at %2:%3. Steal that truck and bring it to HQ. Those funds will be very welcome.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Money Convoy",_destino],_posdestino,"SUCCEEDED",5,true,true,"Interact"] call BIS_fnc_setTask;
			_resourcesAAF = server getVariable "resourcesAAF";
			_resourcesAAF = _resourcesAAF - 5000;
			server setVariable ["resourcesAAF",_resourcesAAF,true];
			[10,-20,_destino] remoteExecCall ["citySupportChange",2];
			[-20,0] remoteExecCall ["prestige",2];
			[0,5000] remoteExecCall ["resourcesFIA",2];
			[-5,5,_destino] remoteExecCall ["citySupportChange",2];
			[-1200] remoteExec ["timingCA",2];
			{if (_x distance _vehObj < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
			[5,stavros] call playerScoreAdd;
			waitUntil {sleep 1; speed _vehObj < 1};
			[_vehObj] call vaciar;
			deleteVehicle _vehObj;
			};
		};
	reportedVehs = reportedVehs - [_vehObj];
	publicVariable "reportedVehs";
	};

if (_tipoConvoy == "Supplies") then
	{
	waitUntil {sleep 1; (dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (not alive _vehObj) or (driver _vehObj getVariable ["BLUFORSpawn",false])};
	if (not alive _vehObj) then
		{
		[position _vehObj] spawn patrolCA;
		[] call playerIsOwner;
		_tsk = ["CONVOY",true,[format ["A truck with medical supplies destination %4 it's about to depart at %2:%3 from %1. Steal that truck bring it to %4 and let people in there know it is FIA who's giving those supplies.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Supply Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
		[-5,0] remoteExecCall ["prestige",2];
		[-10,stavros] call playerScoreAdd;
		};
	if ((dateToNumber date > _fechafinNum) or (_vehObj distance _posdestino < 100) or (driver _vehObj getVariable ["BLUFORSpawn",false])) then
		{
		if (driver _vehObj getVariable ["BLUFORSpawn",false]) then
			{
			[position _vehObj] spawn patrolCA;
			waitUntil {sleep 1; (_vehObj distance _posdestino < 100) or (not alive _vehObj) or (dateToNumber date > _fechafinNum)};
			if (_vehObj distance _posdestino < 100) then
				{
				[] call playerIsOwner;
				_tsk = ["CONVOY",true,[format ["A truck with medical supplies destination %4 it's about to depart at %2:%3 from %1. Steal that truck bring it to %4 and let people in there know it is FIA who's giving those supplies.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Supply Convoy",_destino],_posdestino,"SUCCEEDED",5,true,true,"Interact"] call BIS_fnc_setTask;
				[5,0] remoteExecCall ["prestige",2];
				[0,15,_destino] remoteExecCall ["citySupportChange",2];
				{if (_x distance _vehObj < 500) then {[10,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
				[5,stavros] call playerScoreAdd;
				}
			else
				{
				[] call playerIsOwner;
				_tsk = ["CONVOY",true,[format ["A truck with medical supplies destination %4 it's about to depart at %2:%3 from %1. Steal that truck bring it to %4 and let people in there know it is FIA who's giving those supplies.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Supply Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
				[-10,-10,_destino] remoteExecCall ["citySupportChange",2];
				[-5,0] remoteExecCall ["prestige",2];
				[-10,stavros] call playerScoreAdd;
				};
			}
		else
			{
			[] call playerIsOwner;
			_tsk = ["CONVOY",true,[format ["A truck with medical supplies destination %4 it's about to depart at %2:%3 from %1. Steal that truck bring it to %4 and let people in there know it is FIA who's giving those supplies.",_nombreorig,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4,_nombredest],"AAF Supply Convoy",_destino],_posdestino,"FAILED",5,true,true,"Interact"] call BIS_fnc_setTask;
			[2,0] remoteExecCall ["prestige",2];
			[15,0,_destino] remoteExecCall ["citySupportChange",2];
			[-10,stavros] call playerScoreAdd;
			};
		};
	reportedVehs = reportedVehs - [_vehObj];
	publicVariable "reportedVehs";
	};

_wp0 = _grupo addWaypoint [_posbase, 0];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointBehaviour "SAFE";
_wp0 setWaypointSpeed "LIMITED";
_wp0 setWaypointFormation "COLUMN";

if (_tipoConvoy == "Prisoners") then
	{
	{
	deleteVehicle _x;
	} forEach _POWs;
	};

_nul = [1200,_tsk] spawn borrarTask;
{
waitUntil {sleep 1; (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits))};
deleteVehicle _x;
} forEach _soldados;
{
if (!([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)) then {deleteVehicle _x}
} forEach _vehiculos;

{deleteGroup _x} forEach _grupos;




