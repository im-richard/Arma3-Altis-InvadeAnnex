private ["_display","_childControl"];
_nul = createDialog "buy_vehicle";

sleep 1;
disableSerialization;

_display = findDisplay 100;

if (str (_display) != "no display") then
{
	_ChildControl = _display displayCtrl 104;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_G_Quadbike_01_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 105;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_G_Offroad_01_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 106;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_G_Van_01_transport_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 107;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_G_Offroad_01_armed_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 108;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_HMG_01_high_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 109;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_G_Mortar_01_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 110;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_static_AT_F"] call vehiclePrice];
	_ChildControl = _display displayCtrl 111;
	_ChildControl  ctrlSetTooltip format ["Cost: %1 €",["B_static_AA_F"] call vehiclePrice];
};