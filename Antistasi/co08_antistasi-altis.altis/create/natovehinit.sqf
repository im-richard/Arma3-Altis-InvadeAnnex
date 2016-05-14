private ["_veh"];

_veh = _this select 0;

if ((_veh isKindOf "FlagCarrier") or (_veh isKindOf "Building")) exitWith {};

clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;
clearItemCargoGlobal _veh;
clearBackpackCargoGlobal _veh;
_veh lock 3;
_veh addEventHandler ["GetIn",
	{
	_unit = _this select 2;
	if ({isPlayer _x} count units group _unit > 0) then {moveOut _unit;};
	}];
_veh addEventHandler ["killed",{[-2,0] remoteExecCall ["prestige",2]; [2,-2,position (_this select 0)] remoteExecCall ["citySupportChange",2]; [_this select 0] spawn postmortem}];

[_veh] spawn cleanserVeh;

if ((count crew _veh) > 0) then
	{
	[_veh] spawn VEHdespawner
	};



