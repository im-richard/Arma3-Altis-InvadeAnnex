if (planesAAFcurrent < 1) then
	{
	if (planesAAFcurrent < 0) then {planesAAFcurrent = 0; publicVariable "planesAAFcurrent"};
	planesAAF = planesAAF - ["I_Plane_Fighter_03_CAS_F","I_Plane_Fighter_03_AA_F"]; publicVariable "planesAAF";
	};
if (helisAAFcurrent < 1) then
	{
	if (helisAAFcurrent < 0) then {helisAAFcurrent = 0; publicVariable "helisAAFcurrent"};
	planesAAF = planesAAF - ["I_Heli_light_03_F"]; publicVariable "planesAAF";
	};
if (APCAAFcurrent < 1) then
	{
	if (APCAAFcurrent < 0) then {APCAAFcurrent = 0; publicVariable "APCAAFcurrent"};
	vehAAFAT = vehAAFAT - ["I_APC_Wheeled_03_cannon_F","I_APC_tracked_03_cannon_F"]; publicVariable "vehAAFAT";
	};

if (tanksAAFcurrent < 1) then
	{
	if (tanksAAFcurrent < 0) then {tanksAAFcurrent = 0; publicVariable "tanksAAFcurrent"};
	vehAAFAT = vehAAFAT - ["I_MBT_03_cannon_F"];publicVariable "vehAAFAT";
	};
