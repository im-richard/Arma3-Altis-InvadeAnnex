private ["_unit","_tipo","_texto","_display","_setText"];

_unit = _this select 0;
_tipo = _this select 1;
_texto = _this select 2;

if (_tipo == "sideChat") then
	{
	_unit sideChat format ["%1", _texto];
	};
if (_tipo == "hint") then {hint format ["%1",_texto]};
if (_tipo == "hintCS") then {hintC format ["%1",_texto]};
if (_tipo == "globalChat") then
	{
	_unit globalChat format ["%1", _texto];
	};

if (_tipo == "income") then
	{
	playSound3D ["a3\sounds_f\sfx\beep_target.wss", player];
	//[_texto,1.08,0.9,5,0,0,2] spawn bis_fnc_dynamicText;
	[_texto,0.8,0.5,5,0,0,2] spawn bis_fnc_dynamicText;
	};

if (_tipo == "countdown") then
	{
	_texto = format ["Time Reamining: %1 secs",_texto];
	hint format ["%1",_texto];
	};