private ["_tipo","_coste","_grupo","_unit","_tam","_roads","_road","_pos","_camion","_texto","_mrk"];

_exists = ["Mines"] call BIS_fnc_taskExists;
if (_exists) exitWith {hint "We can only deploy / destroy one minefield at a time."};

_tipo = _this select 0;

openMap true;
posicionTel = [];
hint "Click on the position you wish to build the minefield.\nClick near an already existing one to delete it.";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_posicionTel = posicionTel;
_demasiadoCerca = false;

if (count minefieldMrk > 0) then
	{
	_mrk = [minefieldMrk,_posicionTel] call BIS_fnc_nearestPosition;
	_pos = getMarkerPos _mrk;
	if (_pos distance _posiciontel < 200) then
		{
		if (_pos distance _posiciontel < 101) then
			{
			_tipo = "destroy";
			}
		else
			{
			_demasiadoCerca = true;
			};
		};
	};

if (_demasiadoCerca) exitWith {hint "You cannot deploy minefields at less distance than 200mts from each other"};

_cantidadMax = 40;
_cantidad = 0;

if (_tipo == "ATMine") then
	{
	_cantidadMax = 20;
	_cantidad = {_x == "ATMine_Range_Mag"} count (magazineCargo caja);
	};
if (_tipo == "APERSMine") then
	{
	_cantidad = {_x == "APERSMine_Range_Mag"} count (magazineCargo caja);
	};

if ((_cantidad < 5) and (_tipo!="destroy")) exitWith {hint "You need at least 5 mines of this type to build a Minefield"};

if (_cantidad > _cantidadMax) then
	{
	_cantidad = _cantidadMax;
	};

[[_tipo,_posicionTel,_cantidad],"buildMinefield"] call BIS_fnc_MP;