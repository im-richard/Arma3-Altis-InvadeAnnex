/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Mission Name 
//ParaDrop Proof of concept 							
//by Beerkan
//version Beta 0.96
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------START MISSION-------------------------------------------------------------------
	enableSaving [false, false];

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------Remove fatigue effects FOR MULTIPLAYER---------------------------------------------
// Remove fatigue effects.
	if (local player) then {
		player enableFatigue false;player setCustomAimCoef 0.35;player setUnitRecoilCoefficient 0.35;player enableStamina false;
		player addMPEventhandler ["MPRespawn", {player enableFatigue false;player setCustomAimCoef 0.35;player setUnitRecoilCoefficient 0.35;player enableStamina false;}];
	};

// Set Viewdistance
	setviewdistance 3200;
	setObjectViewDistance 3200;

//Remove fog	
	0 setfog 0;
	
	setTerrainGrid 3.125;//High
	//setTerrainGrid 50;//Low


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Auto ParaChute Proof of concept 							
//by Beerkan
//version Beta 0.2
/*
// Auto Parachute on mission start
// Proof of concept  script.
// by Beerkan
// version Beta 0.2 
// Addd the following to your init.sqf

AutoParachute =
{
    private ['_paraPlayer','_chute'];
    _paraPlayer = _this select 0;
        while {true} do
            {if ( (getPosATL _paraPlayer select 2 > 100) && (vehicle _paraPlayer IsEqualto _paraPlayer) && (alive _paraPlayer)) then
                  {
                  waitUntil {(position _paraPlayer select 2) <= 200};// 200 is the height to open chute.
                  [_paraPlayer] spawn Bis_Fnc_Halo;
                  };
            };
};

{if (_x IsKindof 'Man')
    then{ [_x] spawn AutoParachute };
        } foreach allunits;


// Then add this to the group leader's init to spawn group at 1000m

{_x setPos [getPos _x select 0, getPos _x select 1,1000]}foreach units group this;



*/