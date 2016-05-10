//if (!isMultiplayer) exitWith {};

private ["_puntos","_jugador","_puntosJ","_dineroJ"];
_puntos = _this select 0;
_jugador = _this select 1;

if (!isPlayer _jugador) exitWith {};

//if (rank _jugador == "COLONEL") exitWith {};
_jugador = _jugador getVariable ["owner",_jugador];
if (isMultiplayer) exitWith
	{
	_puntosJ = _jugador getVariable "score";
	_dineroJ = _jugador getVariable "dinero";
	if (_puntos > 0) then
		{
		_dineroJ = _dineroJ + (_puntos * 10);
		_jugador setVariable ["dinero",_dineroJ,true];
		};
	_puntos = _puntos + _puntosJ;
	_jugador setVariable ["score",_puntos,true];
	};

if (_puntos > 0) then
	{
	[0,(_puntos * 5)] remoteExecCall ["resourcesFIA",2];
	};

