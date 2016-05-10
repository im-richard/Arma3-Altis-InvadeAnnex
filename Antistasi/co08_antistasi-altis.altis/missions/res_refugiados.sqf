if (!isServer and hasInterface) exitWith{};

_marcador = _this select 0;
_posicion = getMarkerPos _marcador;

_POWs = [];

_tam = [_marcador] call sizeMarker;
_casas = nearestObjects [_posicion, ["house"], _tam];
_poscasa = [];
_casa = _casas select 0;
while {count _poscasa < 3} do
	{
	_casa = _casas call BIS_Fnc_selectRandom;
	_poscasa = [_casa] call BIS_fnc_buildingPositions;
	if (count _poscasa < 3) then {_casas = _casas - [_casa]};
	};

//_mrkfin = createMarker [format ["RES%1", random 100], getPos _casa];
//_mrkfin setMarkerShape "ICON";
//_mrkfin setMarkerType "hd_destroy";
//_mrkfin setMarkerColor "ColorBlue";
//_mrkfin setMarkerText "Evac Refugees";
_nombredest = [_marcador] call localizar;
[] call playerIsOwner;
_tsk = ["RES",true,[format ["A group of FIA supportes are hidden in %1 awaiting for evacuation. We have to find them before AAF does it. If not, there will be a certain death for them. Bring them back to HQ",_nombredest],"Refugees Evac",_marcador],getPos _casa,"CREATED",5,true,true,"Support"] call BIS_fnc_setTask;
_grupo = createGroup WEST;

for "_i" from 1 to (count _poscasa) - 1 do
	{
	_unit = _grupo createUnit ["b_g_survivor_F", _poscasa select _i, [], 0, "NONE"];
	_unit allowdamage false;
	_unit disableAI "MOVE";
	_unit disableAI "AUTOTARGET";
	_unit disableAI "TARGET";
	_unit setBehaviour "CARELESS";
	_unit allowFleeing 0;
	_unit setSkill 0;
	_POWs = _POWs + [_unit];
	[[_unit,"refugiado"],"flagaction"] call BIS_fnc_MP;
	};

sleep 5;

{_x allowDamage true} forEach _POWs;

waitUntil {sleep 1; ({alive _x} count _POWs == 0) or ({(alive _x) and (_x distance getMarkerPos "respawn_west" < 50)} count _POWs > 0)};

if ({alive _x} count _POWs == 0) then
	{
	[] call playerIsOwner;
	_tsk = ["RES",true,[format ["A group of FIA supportes are hidden in %1 awaiting for evacuation. We have to find them before AAF does it. If not, there will be a certain death for them. Bring them back to HQ",_marcador],"Refugees Evac",_nombredest],getPos _casa,"FAILED",5,true,true,"Support"] call BIS_fnc_setTask;
	_cuenta = count _POWs;
	[_cuenta,0] remoteExecCall ["prestige",2];
	[0,-15,_posicion] remoteExecCall ["citySupportChange",2];
	[-10,stavros] call playerScoreAdd;
	}
else
	{
	[] call playerIsOwner;
	_tsk = ["RES",true,[format ["A group of FIA supportes are hidden in %1 awaiting for evacuation. We have to find them before AAF does it. If not, there will be a certain death for them. Bring them back to HQ",_marcador],"Refugees Evac",_nombredest],getPos _casa,"SUCCEEDED",5,true,true,"Support"] call BIS_fnc_setTask;
	_cuenta = {(alive _x) and (_x distance getMarkerPos "respawn_west" < 150)} count _POWs;
	_hr = _cuenta;
	_resourcesFIA = 100 * _cuenta;
	[_hr,_resourcesFIA] remoteExecCall ["resourcesFIA",2];
	[-5,10,_marcador] remoteExecCall ["citySupportChange",2];
	[_cuenta,0] remoteExecCall ["prestige",2];
	{if (_x distance getMarkerPos "respawn_west" < 500) then {[_cuenta,_x] call playerScoreAdd}} forEach (allPlayers - hcArray);
	[round (_cuenta/2),stavros] call playerScoreAdd;
	{[_x] join _grupo; [_x] orderGetin false} forEach _POWs;
	};

sleep 60;
{deleteVehicle _x} forEach _POWs;
deleteGroup _grupo;

//sleep (540 + random 1200);

//_nul = [_tsk,true] call BIS_fnc_deleteTask;
//deleteMarker _mrkfin;

_nul = [1200,_tsk] spawn borrarTask;


