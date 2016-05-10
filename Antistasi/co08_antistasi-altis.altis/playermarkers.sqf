private ["_jugadores","_jugador","_mrk","_aborrar","_veh"];
_jugadores = [];

while {true} do
	{
	{
	_jugador = _x;
	if ((not(_jugador in _jugadores)) and (player != _jugador)) then
		{
		if (_jugador == _jugador getVariable ["owner",_jugador]) then
			{
			_jugadores pushBack _jugador;
			_mrk = createMarkerLocal [format ["%1",_jugador],position _jugador];
			_mrk setMarkerTypeLocal "mil_triangle";
			_mrk setMarkerColorLocal "ColorBlue";
			};
		};
	} forEach playableUnits;

	_aborrar = [];
	{
	_jugador = _x;
	_mrk = format ["%1",_jugador];
	if ((not(isPlayer _jugador)) or (isNull _jugador)) then
		{
		_aborrar pushBack _jugador;
		_mrk setMarkerAlphaLocal 0;
		}
	else
		{
		if (vehicle _jugador == _jugador) then
			{
			if (_x getVariable ["inconsciente",false]) then
				{
				//_mrk setMarkerAlphaLocal 0;
				//_mrk = createMarker [format ["%1", name _unit], getPos _unit];
				//_mrk setMarkerShape "ICON";
				//_mrk setMarkerType "mil_dot";
				//_mrk setMarkerColor "ColorBlue";
				_mrk setMarkerText format ["%1 Injured",name _jugador];
				}
			else
				{
				if (alive _jugador) then
					{
					_mrk setMarkerAlphaLocal 1;
					_mrk setMarkerPosLocal position _jugador;
					_mrk setMarkerDirLocal getDir _jugador;
					_mrk setMarkerTextLocal format ["%1",name _jugador];
					}
				else
					{
					_mrk setMarkerAlphaLocal 0;
					};
				};
			}
		else
			{
			_veh = vehicle _jugador;
			if ((isNull driver _veh) or (driver _veh == _jugador)) then
				{
				if (alive _jugador) then
					{
					_mrk setMarkerAlphaLocal 1;
					_mrk setMarkerPosLocal position _jugador;
					_mrk setMarkerDirLocal getDir _jugador;
					_mrk setMarkerTextLocal format ["%1",name _jugador];
					}
				else
					{
					_mrk setMarkerAlphaLocal 0;
					};
				}
			else
				{
				_mrk setMarkerAlphaLocal 0;
				};
			};
		};
	sleep 5;
	} forEach _jugadores;
	_jugadores = _jugadores - _aborrar;
	};