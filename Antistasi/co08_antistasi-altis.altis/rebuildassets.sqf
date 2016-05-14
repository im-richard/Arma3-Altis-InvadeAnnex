
_resourcesFIA = server getVariable "resourcesFIA";

if (_resourcesFIA < 10000) exitWith {hint "You do not have enough money to rebuild any Asset. You need 10.000 €"};

_destroyedCities = destroyedCities - ciudades;

openMap true;
posicionTel = [];
hint "Click on the zone you want to rebuild.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;

_sitio = [marcadores,_posicionTel] call BIS_fnc_nearestPosition;

if (getMarkerPos _sitio distance _posicionTel > 50) exitWith {hint "You must click near a map marker"};

if (not(_sitio in _destroyedCities)) exitWith {hint "You cannot rebuild that"};

_nombre = [_sitio] call localizar;

hint format ["%1 Rebuilt"];

[0,10,_posicionTel] remoteExecCall ["citySupportChange",2];
[5,0] remoteExecCall ["prestige",2];
destroyedCities = destroyedCities - [_sitio];
publicVariable "destroyedCities";
if (_sitio in power) then {[_sitio] call powerReorg};
[0,-10000] remoteExecCall ["resourcesFIA",2];