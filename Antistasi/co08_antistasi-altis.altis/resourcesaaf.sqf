private ["_resourcesAAF","_coste"];

waitUntil {!resourcesIsChanging};
resourcesIsChanging = true;
_coste = _this select 0;

if (isNil "_coste") exitWith {};

if (_coste == 0) exitWith {};

_resourcesAAF = server getVariable "resourcesAAF";
_resourcesAAF = _resourcesAAF + _coste;
server setVariable ["resourcesAAF",_resourcesAAF,true];
resourcesIsChanging = false;