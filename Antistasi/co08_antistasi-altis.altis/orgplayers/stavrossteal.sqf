_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < 100) exitWith {hint "FIA has not enough resources to grab"};
[100] call resourcesPlayer;
server setvariable ["resourcesFIA",_resourcesFIA - 100, true];
[-2,stavros] call playerScoreAdd;
hint "You grabbed 100 € from the FIA Money Pool.\n\nThis will affect your prestige and status among FIA forces";