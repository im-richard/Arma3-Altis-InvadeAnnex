if (player != stavros) exitWith {hint "Only Player Commander is allowed to move HQ assets"};

_cosa = _this select 0;
_jugador = _this select 1;
_id = _this select 2;

_cosa removeAction _id;
_cosa attachTo [_jugador,[0,2,1]];
_jugador addAction ["Drop Here", {{detach _x} forEach attachedObjects player},nil,0,false,true,"",""];

waitUntil {sleep 1; (count attachedObjects _jugador == 0) or (vehicle _jugador != _jugador) or (_jugador distance petros > 30) or (!alive _jugador) or (!isPlayer _jugador)};

{detach _x} forEach attachedObjects _jugador;
for "_i" from 0 to (_jugador addAction ["",""]) do
	{
	_jugador removeAction _i;
	};

_cosa addAction ["Move this asset", "moveHQObject.sqf",nil,0,false,true,"","(_this == stavros)"];

if (vehicle _jugador != _jugador) exitWith {hint "You cannot move HQ assets while in a vehicle"};

if  (_jugador distance petros > 30) exitWith {hint "You cannot move HQ assets far from 30mts distance to Petros position"};