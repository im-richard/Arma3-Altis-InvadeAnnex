_jugador = _this select 0;
if ((!isServer) and (player != _jugador)) exitWith {};
_rank = _this select 1;
waitUntil {_jugador == _jugador getVariable ["owner",_jugador]};
_jugador setRank _rank;