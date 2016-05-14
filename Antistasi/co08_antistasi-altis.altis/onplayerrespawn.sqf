if (isDedicated) exitWith {};

_nuevo = _this select 0;
_viejo = _this select 1;

if (isNull _viejo) exitWith {};

waitUntil {alive player};

_nul = [_viejo] spawn postmortem;

_owner = _viejo getVariable ["owner",_viejo];

if (_owner != _viejo) exitWith {hint "Died while AI Remote Control"; selectPlayer _owner; disableUserInput false; deleteVehicle _nuevo};

_nul = [0,-1,getPos _viejo] remoteExecCall ["citySupportChange",2];

_score = _viejo getVariable ["score",0];
_punish = _viejo getVariable ["punish",0];
_dinero = _viejo getVariable ["dinero",0];
_dinero = round (_dinero - (_dinero * 0.1));
_elegible = _viejo getVariable ["elegible",true];

_dinero = round (_dinero - (_dinero * 0.1));
if (_dinero < 0) then {_dinero = 0};

_nuevo setVariable ["score",_score -1,true];
_nuevo setVariable ["owner",_nuevo,true];
_nuevo setVariable ["punish",_punish,true];
_nuevo setVariable ["respawning",false];
_nuevo setVariable ["dinero",_dinero,true];
_nuevo setUnitRank (rank _viejo);
_nuevo setVariable ["compromised",0];
_nuevo setVariable ["elegible",_elegible,true];
_nuevo setVariable ["BLUFORSpawn",true,true];
_viejo setVariable ["BLUFORSpawn",nil,true];
_nuevo setCaptive false;
_nuevo setRank (rank _viejo);
if (!hayACE) then {[_nuevo] call initRevive};
disableUserInput false;
_nuevo enableSimulation true;
if (_viejo == stavros) then
	{
	[_nuevo] call stavrosInit;
	};


removeAllItemsWithMagazines _nuevo;
{_nuevo removeWeaponGlobal _x} forEach weapons _nuevo;
if (!isPlayer (leader group player)) then {(group player) selectLeader player};
player addEventHandler ["FIRED",
	{
	_player = _this select 0;
	if (captive _player) then
		{
		if ({((side _x== EAST) or (side _x== independent)) and (_x knowsAbout player > 1.4)} count allUnits > 0) then
			{
			_player setCaptive false;
			if (vehicle _player != _player) then
				{
				{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive",_x];}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
				};
			}
		else
			{
			_ciudad = [ciudades,_player] call BIS_fnc_nearestPosition;
			_size = [_ciudad] call sizeMarker;
			_datos = server getVariable _ciudad;
			if (random 100 < _datos select 2) then
				{
				if (_player distance getMarkerPos _ciudad < _size * 1.5) then
					{
					_player setCaptive false;
					if (vehicle _player != _player) then
						{
						{if (isPlayer _x) then {[_x,false] remoteExec ["setCaptive",_x];}} forEach ((assignedCargo (vehicle _player)) + (crew (vehicle _player)));
						};
					};
				};
			};
		}
	}
	];
player addEventHandler ["WeaponAssembled", {if (not((_this select 1) in staticsToSave)) then {staticsToSave pushBack (_this select 1);publicVariable "staticsToSave"}}];
/*
player addEventHandler ["InventoryOpened",
	{
	_control = false;
	if !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])) then
		{
		_control = true;
		hint "You cannot access the Arsenal while opening another inventory";
		};
	inventario = true;
	_control
	}];
player addEventHandler ["InventoryClosed",
	{
	inventario = false;
	}];
*/
sleep 10;
[true] execVM "reinitY.sqf";
statistics= [] execVM "statistics.sqf";
