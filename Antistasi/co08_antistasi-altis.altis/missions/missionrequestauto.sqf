if (!isServer) exitWith {};

if (leader group Petros != Petros) exitWith {};

_tipos = ["AS","CON","DES","LOG","RES","CONVOY"];
_tipo = "";

if (!isPlayer stavros) then {_tipos = _tipos - ["AS"]};

{
_exists = [_x] call BIS_fnc_taskExists;
if (_exists) then {_tipos = _tipos - [_x]};
} forEach _tipos;
if (count _tipos == 0) exitWith {};

_tipo = _tipos call BIS_fnc_selectRandom;

_nul = [_tipo,true] call missionRequest;