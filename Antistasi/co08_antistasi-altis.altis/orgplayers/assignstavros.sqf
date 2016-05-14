private ["_puntMax","_texto","_multiplicador","_newRank","_selectable","_disconnected","_owner","_puntos","_datos"];
_puntMax = 0;
_texto = "";
_multiplicador = 1;
//_newRank = "CORPORAL";
_disconnected = false;

[] call playerIsOwner;

if ((isPlayer stavros) and (stavros getVariable ["elegible",true])) then
	{
	_datos = [stavros] call numericRank;
	_puntMax = _datos select 0;
	_selectable = stavros;
	}
else
	{
	_disconnected = true;
	_selectable = objNull;
	};
{
waitUntil {_x == _x getVariable ["owner",_x]};
_puntos = _x getVariable ["score",0];
_datos = [_x] call numericRank;
_multiplicador = _datos select 0;
_newRank = _datos select 1;
if (rank _x != "COLONEL") then
	{
	if (_puntos >= 50*_multiplicador) then
		{
		[_x,_newRank] remoteExec ["ranksMP",_x];
		_texto = format ["%1 has been promoted to the rank of %2.\nCongratulations!",name _x,_newRank];
		[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
		[-1*(50*_multiplicador),_x] call playerScoreAdd;
		_multiplicador = _multiplicador + 1;
		sleep 5;
		waitUntil {_x == _x getVariable ["owner",_x]};
		};
	}
else
	{
	_multiplicador = 7;
	};

if ((_multiplicador > _puntMax) and ([_x] call isMember)) then
	{
	if ((_x getVariable ["elegible",true]) or (_disconnected)) then
		{
		_selectable = _x;
		_puntMax = _multiplicador;
		};
	};
} forEach playableUnits;

if (_disconnected) then
	{
	if (!isNull _selectable) then
		{
		_texto = format ["Player Commander disconnected or renounced. %1 is our new leader. Greet him!", name _selectable];
		[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
		[_selectable] call stavrosInit;
		};
	};
if (!_disconnected and switchCom) then
	{
	if ((_selectable != stavros) and (!isNull _selectable)) then
		{
		_texto = format ["%1 is no longer leader of the FIA Forces.\n\n %2 is our new leader. Greet him!", name stavros, name _selectable];
		[[petros,"hint",_texto],"commsMP"] call BIS_fnc_MP;
		[_selectable] call stavrosInit;
		};
	};