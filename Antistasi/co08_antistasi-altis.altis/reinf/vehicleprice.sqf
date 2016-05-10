private ["_tipo","_coste"];

_tipo = _this select 0;

_coste = server getVariable _tipo;

if (isNil "_coste") then
	{
	_coste = 0;
	diag_log format ["Antistasi: Error en vehicle prize con este: %1",_tipo];
	}
else
	{
	//_coste = _coste + (_coste * ({_x in mrkAAF} count puertos));
	_coste = round (_coste - (_coste * (0.1 * ({_x in mrkFIA} count puertos))));
	};

_coste