
params ["_Chopper"];
Private _ChopperWeapons = [_Chopper] call Tally_Fnc_GetVehicleWeapons;
private _Unidentified_W = [];
private _ChopperType 	= "Unarmed Chopper";
private _LightWeapons 	= 0;
Private _HeavyWeapons 	= 0;
Private _AAcapability 	= 0;



Private _AllCfgWeapons = [	"CUP_Vacannon_Yakb_veh",
							"CUP_Vmlauncher_AT9_veh",
							"CUP_Vhmg_PKT_veh_Noeject",
							"CUP_Vhmg_PKT_veh2",
							"CUP_Vhmg_PKT_veh3",
							"CUP_weapon_mastersafe",
							"CUP_Laserdesignator_mounted",
							"CUP_Vacannon_M230_veh",
							"CUP_Vmlauncher_AGM114L_veh",
							"CUP_Vmlauncher_AIM9L_veh_1Rnd",
							"CUP_M134",
							"CUP_M134_2",
							"CUP_Vlmg_L7A2_veh",
							"Laserdesignator_mounted",
							"gatling_20mm",
							"missiles_ASRAAM",
							"missiles_DAGR",
							"CUP_Vacannon_M197_veh",
							"CUP_Vmlauncher_AGM114K_veh",
							"LMG_Minigun_Transport",
							"LMG_Minigun_Transport2",
							"CUP_Vmlauncher_TOW_veh",
							"CUP_Vmlauncher_AT2_veh",
							"FakeHorn",
							"CUP_Vacannon_GI2_veh",
							"CUP_Vmlauncher_AT6_veh",
							"CUP_Vmlauncher_AT16_veh",
							"CUP_Vacannon_2A42_Ka50",
							"CUP_M32_heli",
							"CUP_M240_uh1h_right_veh_W",
							"CUP_M240_uh1h_left_veh_W",
							"gatling_30mm",
							"missiles_SCALPEL",
							"rockets_Skyfire",
							"CUP_Vlmg_M134_veh",
							"CUP_Vlmg_M134_veh2",
							"CUP_Vhmg_GAU21_MH60_Left",
							"CUP_Vhmg_GAU21_MH60_Right",
							"CUP_M240_veh_W",
							"CUP_M240_veh2_W",
							"CMFlareLauncher",
							"CUP_Vmlauncher_S5_veh",
							"CUP_Vmlauncher_S8_CCIP_veh",
							"M134_minigun",
							"missiles_DAR",
							"CUP_Vmlauncher_FFAR_veh",
							"CUP_DL_CMFlareLauncher",
							"CUP_Vlmg_M134_A_veh",
							"CUP_Vacannon_M621_AW159_veh",
							"CUP_Vmlauncher_CRV7_veh",
							"rhs_weap_CMDispenser_ASO2",
							"rhs_weap_MASTERSAFE",
							"rhs_weap_yakB",
							"rhs_weap_2K8_launcher",
							"rhs_weap_s5ko",
							"rhs_weap_s5k1",
							"rhs_weap_gi2",
							"Laserdesignator_pilotCamera",
							"rhs_weap_zt3_Launcher",
							"rhs_weap_DIRCM_Lipa",
							"rhs_weap_s8df",
							"rhs_weap_s8",
							"rhs_weap_fcs_mi24",
							"rhs_weap_9K114_launcher",
							"rhs_weap_CMFlareLauncher",
							"rhs_weap_s5m1",
							"rhs_weap_DummyLauncher",
							"rhs_weap_fcs_nolrf_ammo",
							"rhs_weap_FFARLauncher",
							"rhs_weap_fcs_ah64",
							"rhs_weap_M230",
							"rhs_weap_laserDesignator_AI",
							"rhs_weap_AGM114L_Launcher",
							"rhs_weap_AGM114K_Launcher",
							"rhsusf_weap_ANALQ144",
							"rhsusf_weap_CMDispenser_M130",
							"rhs_weap_m134_minigun_1",
							"rhsusf_weap_ANALQ212",
							"rhsusf_weap_DummyLauncher",
							"rhsusf_weap_LWIRCM",
							"RHS_weap_m134_pylon",
							"rhs_weap_M197",
							"rhs_weap_AIM9M",
							"rhsusf_weap_CMDispenser_ANALE39",
							"rhsusf_weap_ANAAQ24",
							"rhs_weap_fab250",
							"rhs_weap_9M120_launcher",
							"rhs_weap_gsh30",
							"rhs_weap_MASTERSAFE_Holdster15",
							"rhs_weap_2a42",
							"rhs_weap_9k121_Launcher",
							"rhs_weap_DIRCM_Vitebsk",
							"rhs_weap_CMDispenser_UV26"];

private _noWeapon 	  = [
							"FakeHorn",
							"Laserdesignator_mounted",
							"CUP_weapon_mastersafe",
							"CUP_Laserdesignator_mounted",
							"CMFlareLauncher",
							"CUP_DL_CMFlareLauncher",
							"Laserdesignator_pilotCamera",
							"rhs_weap_MASTERSAFE",
							"rhs_weap_CMFlareLauncher",
							"rhsusf_weap_DummyLauncher",
							"rhs_weap_CMDispenser_ASO2",
							"rhs_weap_CMDispenser_UV26",
							"rhs_weap_MASTERSAFE_Holdster15",
							"rhsusf_weap_CMDispenser_M130",
							"rhs_weap_DummyLauncher",
							"rhs_weap_laserDesignator_AI",
							"rhs_weap_fcs_nolrf_ammo",
							"rhsusf_weap_ANALQ144",
							"rhsusf_weap_ANALQ212",
							"rhsusf_weap_ANAAQ24",
							"rhs_weap_fcs_mi24",
							"rhsusf_weap_CMDispenser_ANALE39",
							"rhs_weap_DIRCM_Lipa",
							"rhs_weap_DIRCM_Vitebsk",
							"rhs_weap_fcs_ah64",
							"rhsusf_weap_LWIRCM"
							
							
							
						];

private _Guns = 	[
							"LMG_Minigun_Transport",
							"LMG_Minigun_Transport2",
							"CUP_Vlmg_M134_veh",
							"CUP_Vlmg_M134_veh2",
							"CUP_Vhmg_GAU21_MH60_Left",
							"CUP_Vhmg_GAU21_MH60_Right",
							"CUP_M240_veh_W",
							"CUP_M240_veh2_W",
							"CUP_M240_uh1h_right_veh_W",
							"CUP_M240_uh1h_left_veh_W",
							"gatling_30mm",
							"CUP_M32_heli",
							"CUP_M134",
							"CUP_M134_2",
							"CUP_Vlmg_L7A2_veh",
							"gatling_20mm",
							"CUP_Vhmg_PKT_veh_Noeject",
							"CUP_Vhmg_PKT_veh2",
							"CUP_Vhmg_PKT_veh3",
							"M134_minigun",
							"CUP_Vlmg_M134_A_veh",
							"rhs_weap_m134_minigun_1",
							"RHS_weap_m134_pylon"
					];
private _cannons = 	[
							"CUP_Vacannon_Yakb_veh",
							"CUP_Vmlauncher_AT9_veh",
							"CUP_Vacannon_M230_veh",
							"CUP_Vacannon_2A42_Ka50",
							"CUP_Vacannon_GI2_veh",
							"CUP_Vacannon_M197_veh",
							"CUP_Vacannon_M621_AW159_veh",
							"rhs_weap_M230",
							"rhs_weap_M197",
							"rhs_weap_gi2",
							"rhs_weap_yakB",
							"rhs_weap_2a42",
							"rhs_weap_gsh30"
					];

private _Rockets	 =	[
							"rockets_Skyfire",
							"CUP_Vmlauncher_S5_veh",
							"CUP_Vmlauncher_S8_CCIP_veh",
							"CUP_Vmlauncher_FFAR_veh",
							"CUP_Vmlauncher_CRV7_veh",
							"rhs_weap_FFARLauncher",
							"rhs_weap_s8df",
							"rhs_weap_s8",
							"rhs_weap_s5ko",
							"rhs_weap_s5k1",
							"rhs_weap_s5m1"
						];

private _ATmisiles = [
							"CUP_Vmlauncher_AGM114L_veh",
							"missiles_DAGR",
							"CUP_Vmlauncher_AGM114K_veh",
							"CUP_Vmlauncher_TOW_veh",
							"CUP_Vmlauncher_AT2_veh",
							"CUP_Vmlauncher_AT6_veh",
							"CUP_Vmlauncher_AT16_veh",
							"missiles_SCALPEL",
							"missiles_DAR",
							"rhs_weap_AGM114L_Launcher",
							"rhs_weap_AGM114K_Launcher",
							"rhs_weap_zt3_Launcher",
							"rhs_weap_9M120_launcher",
							"rhs_weap_9K114_launcher",
							"rhs_weap_9k121_Launcher",
							"rhs_weap_2K8_launcher"
					];

private _Bombs	=	[
							"rhs_weap_fab250"
					];

private _AAmisiles = [
							"CUP_Vmlauncher_AIM9L_veh_1Rnd",
							"missiles_ASRAAM",
							"rhs_weap_AIM9M"
						
					];

{
	if!(_X in _AllCfgWeapons)then{_Unidentified_W pushBack _X};
	
	if(_X in _Guns)		then{_LightWeapons 	= (_LightWeapons + 1)};
	if(_X in _cannons)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _Rockets)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _ATmisiles)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _Bombs)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _AAmisiles)	then{_AAcapability 	= (_AAcapability + 1)};


}ForEach _ChopperWeapons;

if(Count _Unidentified_W > 0)then	{
										["We could not identify the following chopper weapons: ", _Unidentified_W] call Tally_fnc_debugMessage; 
										["they have been copied to clipBoard"] call Tally_fnc_debugMessage; 
										if(FSMD3Bugger)then{copyToClipboard str _Unidentified_W};
										diag_Log _Unidentified_W;
									};

if(_LightWeapons > 0)then{_ChopperType 	= "Light Chopper"};
if(_HeavyWeapons > 0)then{_ChopperType = "Heavy Chopper"};


_ChopperType