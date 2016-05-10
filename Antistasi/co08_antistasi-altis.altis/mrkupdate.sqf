private ["_marcador","_tipo","_array","_mrkD"];

_marcador = _this select 0;
_tipo = _this select 1;
//_array = [];
//if (count _this > 2) then {_array = _this select 2};
_mrkD = format ["Dum%1",_marcador];
_mrkD setMarkerColor "colorBLUFOR";

if (_marcador in aeropuertos) then {_mrkD setMarkerText "FIA Airport";_mrkD setMarkerType "flag_FIA";};
if (_marcador in puestos) then {_mrkD setMarkerText "FIA Outpost"};
if (_marcador in bases) then {_mrkD setMarkerText "FIA Base";_mrkD setMarkerType "flag_FIA";};
