private ["_nato","_csat"];

waitUntil {!prestigeIsChanging};
prestigeIsChanging = true;
_nato = _this select 0;
_csat = _this select 1;

_natoT = server getVariable "prestigeNATO";
_csatT = server getVariable "prestigeCSAT";

_natoT = _natoT + _nato;
_csatT = _csatT + _csat;

if (_natoT < 0) then {_natoT = 0};
if (_natoT > 100) then {_natoT = 100};
if (_csatT < 0) then {_csatT = 0};
if (_csatT > 100) then {_csatT = 100};


if (_nato != 0) then {server setVariable ["prestigeNATO",_natoT,true]};
if (_csat != 0) then {server setVariable ["prestigeCSAT",_csatT,true]};
prestigeIsChanging = false;