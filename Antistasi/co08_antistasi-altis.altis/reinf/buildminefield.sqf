if (!isServer) exitWith {};

private ["_tipo","_cantidad","_tipoMuni","_grupo","_unit","_tam","_roads","_road","_pos","_camion","_texto","_mrk","_ATminesAdd","_APminesAdd","_posicionTel","_tsk","_magazines","_typeMagazines","_cantMagazines","_newCantMagazines","_mina","_tipo","_camion"];

_tipo = _this select 0;
_posicionTel = _this select 1;
_cantidad = _this select 2;

if (_tipo == "destroy") exitWith
	{
	_ATminesAdd = 0;
	_APminesAdd = 0;
	_mrk = [minefieldMrk,_posicionTel] call BIS_fnc_nearestPosition;
	_pos = getMarkerPos _mrk;
	[] call playerIsOwner;
	_tsk = ["Mines",true,["We are deactivating and recovering a minefield. When job is finished, the mines will be ready in our Ammobox.","Minefield Recover",_mrk],_posicionTel,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
	{
	if (_x distance _pos < 101) then
		{
		if (typeOf _x == "ATMine_Range_Ammo") then {_ATminesAdd = _ATminesAdd +1};
		if (typeOf _x == "APERSMine_Range_Ammo") then {_APminesAdd = _APminesAdd + 1};
		deleteVehicle _x;
		sleep 10;
		};
	} forEach allMines;
	[] call playerIsOwner;
	_tsk = ["Mines",true,["We are deactivating and recovering a minefield. When job is finished, the mines will be ready in our Ammobox.","Minefield Recover",_mrk],_posicionTel,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
	caja addMagazineCargoGlobal ["ATMine_Range_Mag",_ATminesAdd];
	caja addMagazineCargoGlobal ["APERSMine_Range_Mag",_APminesAdd];
	deleteMarker _mrk;
	minefieldMrk = minefieldMrk - [_mrk];
	sleep 15;
	//_nul = [_tsk,true] call BIS_fnc_deleteTask;
	_nul = [0,_tsk] spawn borrarTask;
	};

if (_tipo == "ATMine") then
	{
	_tipoMuni = "ATMine_Range_Mag";
	_texto = "AT Minefield";
	};
if (_tipo == "APERSMine") then
	{
	_tipoMuni = "APERSMine_Range_Mag";
	_texto = "AP Minefield";
	};

_magazines = getMagazineCargo caja;
_typeMagazines = _magazines select 0;
_cantMagazines = _magazines select 1;
_newCantMagazines = [];

for "_i" from 0 to (count _typeMagazines) - 1 do
	{
	if ((_typeMagazines select _i) != _tipoMuni) then
		{
		_newCantMagazines pushBack (_cantMagazines select _i);
		}
	else
		{
		_cuantasHay = (_cantMagazines select _i);
		_cuantasHay = _cuantasHay - _cantidad;
		if (_cuantasHay < 0) then {_cuentasHay = 0};
		_newCantMagazines pushBack _cuantasHay;
		};
	};

clearMagazineCargoGlobal caja;

for "_i" from 0 to (count _typeMagazines) - 1 do
	{
	caja addMagazineCargoGlobal [_typeMagazines select _i,_newCantMagazines select _i];
	};

_mrk = createMarker [format ["Minefield%1", random 1000], _posicionTel];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [100,100];
_mrk setMarkerType "hd_warning";
_mrk setMarkerColor "ColorRed";
_mrk setMarkerBrush "DiagGrid";
_mrk setMarkerText _texto;
[] call playerIsOwner;
_tsk = ["Mines",true,[format ["An Engineer Team has been deployed at your command with High Command Option. Once they reach the position, they will start to deploy %1 mines in the area. Cover them in the meantime.",_cantidad],"Minefield Deploy",_mrk],_posicionTel,"CREATED",5,true,true,"Defend"] call BIS_fnc_setTask;
_grupo = createGroup west;

_unit = _grupo createUnit ["B_G_Soldier_exp_F", position petros, [], 0, "NONE"];
sleep 1;
_unit = _grupo createUnit ["B_G_Soldier_exp_F", position petros, [], 0, "NONE"];
_grupo setGroupId ["MineF"];

_tam = 10;
while {true} do
	{
	_roads = getMarkerPos "respawn_west" nearRoads _tam;
	if (count _roads < 1) then {_tam = _tam + 10};
	if (count _roads > 0) exitWith {};
	};
_road = _roads select 0;
_pos = position _road findEmptyPosition [1,30,"B_G_Van_01_transport_F"];

_camion = "B_G_Van_01_transport_F" createVehicle _pos;

_grupo addVehicle _camion;
{[_x] call FIAinit} forEach units _grupo;
_nul = [_camion] spawn VEHinit;
leader _grupo setBehaviour "SAFE";
Stavros hcSetGroup [_grupo];
_camion allowCrewInImmobile true;

waitUntil {sleep 1; (count crew _camion > 0) or (!alive _camion) or ({alive _x} count units _grupo == 0)};

waitUntil {sleep 1; (!alive _camion) or ((_camion distance _posicionTel < 50) and ({alive _x} count units _grupo > 0))};

if ((_camion distance _posicionTel < 50) and ({alive _x} count units _grupo > 0)) then
	{
	if (isPlayer leader _grupo) then
		{
		_owner = player getVariable ["owner",player];
		removeAllActions player;
		selectPlayer _owner;
		(leader _grupo) setVariable ["owner",player,true];
		{[_x] joinsilent group player} forEach units group player;
		group player selectLeader player;
		hint "";
		};
	stavros hcRemoveGroup _grupo;
	[[petros,"hint","Engineer Team deploying mines."],"commsMP"] call BIS_fnc_MP;
	_nul = [leader _grupo, _mrk, "SAFE","SPAWNED", "SHOWMARKER"] execVM "scripts\UPSMON.sqf";
	sleep 30*_cantidad;
	if ((alive _camion) and ({alive _x} count units _grupo > 0)) then
		{
		{deleteVehicle _x} forEach units _grupo;
		deleteGroup _grupo;
		deleteVehicle _camion;
		for "_i" from 1 to _cantidad do
			{
			_mina = createMine [_tipo,_posicionTel,[],100];
			west revealMine _mina;
			};
		minefieldMrk = minefieldMrk + [_mrk];
		[] call playerIsOwner;
		_tsk = ["Mines",true,[format ["An Engineer Team has been deployed at your command with High Command Option. Once they reach the position, they will start to deploy %1 mines in the area. Cover them in the meantime.",_cantidad],"Minefield Deploy",_mrk],_posicionTel,"SUCCEEDED",5,true,true,"Defend"] call BIS_fnc_setTask;
		sleep 15;
		//_nul = [_tsk,true] call BIS_fnc_deleteTask;
		_nul = [0,_tsk] spawn borrarTask;
		}
	else
		{
		[] call playerIsOwner;
		_tsk = ["Mines",true,[format ["An Engineer Team has been deployed at your command with High Command Option. Once they reach the position, they will start to deploy %1 mines in the area. Cover them in the meantime.",_cantidad],"Minefield Deploy",_mrk],_posicionTel,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
		sleep 15;
		stavros hcRemoveGroup _grupo;
		//_nul = [_tsk,true] call BIS_fnc_deleteTask;
		_nul = [0,_tsk] spawn borrarTask;
		{deleteVehicle _x} forEach units _grupo;
		deleteGroup _grupo;
		deleteVehicle _camion;
		deleteMarker _mrk;
		};
	}
else
	{
	[] call playerIsOwner;
	_tsk = ["Mines",true,[format ["An Engineer Team has been deployed at your command with High Command Option. Once they reach the position, they will start to deploy %1 mines in the area. Cover them in the meantime.",_cantidad],"Minefield Deploy",_mrk],_posicionTel,"FAILED",5,true,true,"Defend"] call BIS_fnc_setTask;
	sleep 15;
	stavros hcRemoveGroup _grupo;
	//_nul = [_tsk,true] call BIS_fnc_deleteTask;
	_nul = [0,_tsk] spawn borrarTask;
	{deleteVehicle _x} forEach units _grupo;
	deleteGroup _grupo;
	deleteVehicle _camion;
	deleteMarker _mrk;
	};

