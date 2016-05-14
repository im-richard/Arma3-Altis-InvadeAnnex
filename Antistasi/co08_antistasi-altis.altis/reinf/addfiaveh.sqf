if (player != player getVariable ["owner",player]) exitWith {hint "You cannot buy vehicles while you are controlling AI"};

_chequeo = false;
{
	if (((side _x == east) or (side _x == independent)) and (_x distance player < 500) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot buy vehicles with enemies nearby"};

private ["_tipoVeh","_coste","_resourcesFIA","_marcador","_pos","_veh","_tipoVeh"];

_tipoveh = _this select 0;

_coste = [_tipoVeh] call vehiclePrice;

if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA";} else {_resourcesFIA = player getVariable "dinero"};

if (_resourcesFIA < _coste) exitWith {hint format ["You do not have enough money for this vehicle: %1 € required",_coste]};
_pos = position player findEmptyPosition [1,50,_tipoveh];
if (count _pos == 0) exitWith {hint "Not enough space to place this type of vehicle"};
_veh = _tipoveh createVehicle _pos;
if (!isMultiplayer) then {_nul = [0,- _coste] remoteExecCall ["resourcesFIA",2];} else {[- _coste] call resourcesPlayer};
[_veh] spawn VEHinit;
if ((_tipoVeh == "B_G_Mortar_01_F") or (_tipoVeh == "B_static_AT_F") or (_tipoVeh == "B_static_AA_F") or (_tipoVeh == "B_HMG_01_high_F")) then {staticsToSave = staticsToSave + [_veh]; publicVariable "staticsToSave"};
hint "Vehicle Purchased";
player reveal _veh;
petros directSay "SentGenBaseUnlockVehicle";