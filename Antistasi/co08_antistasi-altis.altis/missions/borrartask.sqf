_tiempo = _this select 0;
_tsk = _this select 1;

if (_tiempo > 0) then {sleep ((_tiempo/2) + random _tiempo)};

_nul = [_tsk,true] call BIS_fnc_deleteTask;

