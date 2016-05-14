removeHeadgear petros;
removeGoggles petros;
petros setSkill 1;
petros setVariable ["inconsciente",false,true];
petros setVariable ["respawning",false];

petros addEventHandler ["HandleDamage",
        {
        private ["_unit","_part","_dam","_injurer"];
        _part = _this select 1;
        _dam = _this select 2;
        _injurer = _this select 3;
        /*
        if (isPlayer _injurer) then
            {
            [_injurer,60] remoteExec ["castigo",_injurer];
            _dam = 0;
            };
        */
        if (_part == "") then
            {
            if (_dam > 0.95) then
                {
                if (!(petros getVariable "inconsciente")) then
                    {
                    _dam = 0.9;
                    [petros] spawn inconsciente;
                    }
                else
                    {
                    petros removeAllEventHandlers "HandleDamage";
                    };
                };
            };
        _dam
        }];

petros addMPEventHandler ["mpkilled",
    {
    removeAllActions petros;
    if ((isPlayer (_this select 1)) or ((_this select 1) == petros)) then
        {
        if (isServer) then
            {
            _viejo = petros;
            grupoPetros = createGroup west;
            publicVariable "grupoPetros";
            petros = grupoPetros createUnit ["B_G_officer_F", position _viejo, [], 0, "NONE"];
            grupoPetros setGroupId ["Petros","GroupColor4"];
            petros setIdentity "amiguete";
            petros setName "Petros";
            petros disableAI "MOVE";
            petros disableAI "AUTOTARGET";
            if (group _viejo == grupoPetros) then {[[Petros,"mission"],"flagaction"] call BIS_fnc_MP;} else {[[Petros,"buildHQ"],"flagaction"] call BIS_fnc_MP;};
            _nul= call compile preprocessFileLineNumbers "initPetros.sqf";
            deleteVehicle _viejo;
            publicVariable "petros";
            };
        }
    else
        {
        //["petrosDead",false,true] call BIS_fnc_endMission;
        if (isServer) then
            {
            _nul = [] spawn
                {
                garrison setVariable ["FIA_HQ",[],true];
                for "_i" from 0 to round random 3 do
                    {
                    if (count unlockedWeapons > 2) then
                        {
                        _cosa = selectRandom unlockedWeapons;
                        unlockedWeapons = unlockedWeapons - [_cosa];
                        lockedWeapons = lockedWeapons + [_cosa];
                        if (_cosa in unlockedRifles) then {unlockedRifles = unlockedRifles - [_cosa]};
                        };
                    };
                publicVariable "unlockedWeapons";
                for "_i" from 0 to round random 8 do
                    {
                    _cosa = selectRandom unlockedMagazines;
                    if (!isNil "_cosa") then {unlockedMagazines = unlockedMagazines - [_cosa]};
                    };
                publicVariable "unlockedMagazines";
                for "_i" from 0 to round random 5 do
                    {
                    _cosa = selectRandom unlockedItems;
                    unlockedItems = unlockedItems - [_cosa];
                    if (_cosa in unlockedOptics) then {unlockedOptics = unlockedOptics - [_cosa]; publicVariable "unlockedOptics"};
                    };
                publicVariable "unlockedItems";
                clearMagazineCargoGlobal caja;
                clearWeaponCargoGlobal caja;
                clearItemCargoGlobal caja;
                clearBackpackCargoGlobal caja;
                waitUntil {sleep 6; isPlayer stavros};
                [] remoteExec ["placementSelection",stavros];
               };
            };
        };
   }];
