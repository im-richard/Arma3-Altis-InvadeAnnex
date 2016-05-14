private ["_estatica","_cercano","_jugador"];

_estatica = _this select 0;
_jugador = _this select 1;

if (!alive _estatica) exitWith {hint "You cannot steal a destroyed static weapon"};

if (alive gunner _estatica) exitWith {hint "You cannot steal a static weapon when someone is using it"};

if (alive assignedGunner _estatica) exitWith {hint "The gunner of this static weapon is still alive"};

_cercano = [marcadores,_estatica] call BIS_fnc_nearestPosition;

if (_cercano in mrkAAF) exitWith {hint "You have to conquer this zone in order to be able to steal this Static Weapon"};

_estatica setOwner (owner _jugador);

_tipoEst = typeOf _estatica;

_tipoB1 = "I_AT_01_weapon_F";
_tipoB2 = "I_HMG_01_support_high_F";

switch _tipoEst do
	{
	case "I_HMG_01_high_F": {_tipoB1 = "I_HMG_01_high_weapon_F"};
	case "I_static_AA_F": {_tipoB1 = "I_AA_01_weapon_F"};
	case "I_G_Mortar_01_F": {_tipoB1 = "I_Mortar_01_weapon_F"; _tipoB2 = "I_Mortar_01_support_F"};
	};

_posicion1 = [_jugador, 1, (getDir _jugador) - 90] call BIS_fnc_relPos;
_posicion2 = [_jugador, 1, (getDir _jugador) + 90] call BIS_fnc_relPos;

deleteVehicle _estatica;

_bag1 = _tipoB1 createVehicle _posicion1;
_bag2 = _tipoB2 createVehicle _posicion2;

[_bag1] spawn VEHinit;
[_bag2] spawn VEHinit;

hint "Weapon Stolen. It won't despawn when you assemble it again";

/*
if (_cercano in controles) then
	{


	_jugador addEventHandler ["WeaponDisassembled",
		{
		_jugador = _this select 0;
		_bag1 = objectParent (_this select 1);
		_bag2 = objectParent (_this select 2);

		_posicion1 set [2, 0];
		_posicion2 set [2, 0];
		_bag1 setVehiclePosition [_posicion1, [], 2, "NONE"];
		_bag2 setVehiclePosition [_posicion2, [], 2, "NONE"];
		//_bag1 setPos _posicion1;
		//_bag2 setPos _posicion2;
		_jugador removeEventHandler ["WeaponDisassembled", 0];
		}
	];
	};

hint "Static Weapon stolen, it won't despawn when you move it or leave the area";


[[_estatica,"remove"],"flagaction"] call BIS_fnc_MP;

staticsToSave = staticsToSave + [_estatica];
publicVariable "staticsToSave";
_jugador action ["Disassemble", _estatica];