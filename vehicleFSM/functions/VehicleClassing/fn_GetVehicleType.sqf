params ["_Vehicle"];
private _unitScannerType = "";

if(!isNil "objScan_fnc_vehicleType")
then{_unitScannerType = [_Vehicle] call Tally_Fnc_unitScannerClassing;};

/*Author: _David#8349 && Tally*/

private _typeOfVehicle 	= "unknown";
private _CfgName		= (TypeOf _Vehicle);
private _parentType		= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 2);
private _Firstparent		= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 1);
private _Cousin			= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 0);


private _TankCfgNames = [
						"B_T_MBT_01_TUSK_F",
						"Leopard1A4_2",
						"Leopard2A4_2",
						"Leopard2A6HEL_2",
						"Leopard1A4",
						"Leopard2A4",
						"Leopard2A6HEL"
						];
						
private _ApcCfgNames = [
						"Leonidas2_2",
						"Leonidas3_BLU",
						"M113_2",
						"Leonidas2",
						"Leonidas3",
						"M113"
						];

private _ArtyParents =	["rhsgref_ins_2s1",
						"rhsgref_cdf_reg_d30_at",
						"rhsgref_cdf_2s1",
						"rhsgref_cdf_reg_M252",
						"rhsgref_ins_d30",
						"I_E_Truck_02_MRL_F",
						"rhsgref_tla_g_2b14",
						"rhsgref_cdf_b_2s1",
						"B_MBT_01_arty_F",
						"B_MBT_01_mlrs_F",
						"B_T_MBT_01_arty_F",
						"rhsgref_ins_d30_at",
						"rhsgref_ins_2b14",
						"O_MBT_02_arty_F",
						"rhs_9k79",
						"rhsgref_cdf_2s1_at",
						"rhsgref_cdf_reg_BM21",
						"rhssaf_army_2s1",
						"B_T_MBT_01_mlrs_F",
						"rhsusf_M142_usarmy_D",
						"RHS_M252_USMC_D",
						"rhsgref_cdf_b_reg_M252",
						"rhsgref_cdf_b_reg_BM21",
						"rhssaf_army_o_d30",
						"rhsgref_ins_BM21",
						"rhssaf_army_o_2s1",
						"I_Truck_02_MRL_F",
						"rhsgref_tla_2b14",
						"rhsusf_m109_usarmy",
						"rhs_2s3_tv",
						"rhs_2s1_tv",
						"rhs_2s1_at_tv",
						"RHS_M119_WD",
						"rhs_9k79_K",
						"RHS_M252_WD",
						"rhs_2s3_at_tv",
						"rhs_9k79_B",
						"rhssaf_army_o_m252",
						"rhsusf_m109d_usarmy",
						"rhsgref_cdf_reg_d30",
						"RHS_M119_D",
						"rhsgref_cdf_b_2s1_at",
						"RHS_M252_D",
						"rhsgref_ins_2s1_at",
						"rhsusf_M142_usarmy_WD",
						"CUP_B_M270_HE_HIL",
						"CUP_B_M270_DPICM_BAF_WOOD",
						"CUP_B_M270_DPICM_BAF_DES",
						"CUP_B_M270_HE_BAF_DES",
						"CUP_B_M270_HE_BAF_WOOD",
						"CUP_B_M1129_MC_MK19_Desert",
						"CUP_B_M270_DPICM_USA",
						"CUP_B_M270_HE_USA",
						"CUP_B_M270_HE_USMC",
						"CUP_O_BM21_RU",
						"CUP_O_BM21_TKA",
						"CUP_I_M270_DPICM_RACS",
						"CUP_I_M270_HE_RACS",
						"CUP_B_M270_DPICM_HIL",
						"CUP_B_RM70_CZ",
						"CUP_B_BM21_CDF",
						"CUP_B_M1129_MC_MK19_Woodland",
						"CUP_B_M270_DPICM_USMC",
						"CUP_O_BM21_CHDKZ",
						"O_T_MBT_02_arty_ghex_F",
						"CUP_O_BM21_SLA",
						"CUP_I_M270_DPICM_AAF",
						"CUP_I_M270_HE_AAF",
						"GR_MBT_mlrs",
						"GR2_MBT_mlrs",
						"UK3CB_M109_Base",
						"UK3CB_M939_MLRS",
						"UK3CB_MTVR_MLRS",
						"UK3CB_Ural_BM21_Base",
						"UK3CB_MAZ_543_SCUD",
						"UK3CB_2S1",
						"rhs_2s1tank_at_base"];


Private _MBTparents = [	  "MBT_03_base_F",
						  "MBT_04_base_F",
						  "O_MBT_02_base_F",
						  "B_MBT_01_base_F",
						  "MBT_02_base_F",
						  "MBT_01_base_F",
						  "CUP_Challenger2_base",
						  "CUP_Leopard2_Base",
						  "CUP_T72_Base",
						  "CUP_M1Abrams_A2_Base",
						  "CUP_M1Abrams_A2_TUSK_Base",
						  "CUP_M1A2Abrams_TUSK_Base",
						  "CUP_M1A2Abrams_Base",
						  "CUP_M1Abrams_TUSK_Base",
						  "CUP_M1Abrams_Base",
						  "CUP_M60A3_Base",
						  "CUP_T90_Base",
						  "CUP_T55_Base",
						  "CUP_T34_Base",
						  "rhs_t80b",
						  "rhs_t80bv",
						  "rhs_t80u",
						  "rhsusf_m1a2tank_base",
						  "rhsusf_m1a1fep_d",
						  "rhs_t80uk",
						  "rhsusf_m1a2sep1tuskid_usarmy",
						  "rhs_t72ba_tv",
						  "rhs_t72bb_tv",
						  "rhsusf_m1a1tank_base",
						  "rhs_a3t72tank_base",
						  "rhs_a3spruttank_base",
						  "rhs_t72bd_tv",
						  "rhs_tank_base",
						  "rhs_t80a",
						  "rhs_t72bc_tv",
						  "UK3CB_M1A1_Base",
						  "UK3CB_M60a3",
						  "UK3CB_T55",
						  "UK3CB_T72A",
						  "UK3CB_T72B",
						  "UK3CB_T72BM",
						  "UK3CB_T72BA",
						  "UK3CB_T72BB",
						  "UK3CB_T72BC",
						  "UK3CB_M60a1"];

Private _APCparents = ["APC_Wheeled_03_base_F",
						"APC_Wheeled_02_base_F",
						"AFV_Wheeled_01_base_F",
						"Wheeled_APC_F",
						"APC_Wheeled_01_base_F",
						"APC_Tracked_01_base_F",
						"B_APC_Tracked_01_base_F",
						"APC_Tracked_02_base_F",
						"APC_Tracked_03_base_F",
						"O_APC_Tracked_02_base_F",
						"CUP_B_MCV80_GB_D_SLAT",
						"CUP_Boxer_Base",
						"CUP_M2Bradley_Base",
						"CUP_FV432_Bulldog_Base",
						"CUP_B_FV432_Bulldog_GB_D",
						"CUP_B_FV510_GB_D_SLAT",
						"CUP_FV510_Base",
						"CUP_B_FV510_GB_W_SLAT",
						"CUP_MCV80_Base",
						"CUP_Boxer_Base_HMG",
						"CUP_BMP1_base",
						"CUP_BMP2_base",
						"CUP_BRDM2_Base",
						"CUP_BTR80_Common_Base",
						"CUP_MTLB_Base",
						"CUP_StrykerBase",
						"CUP_M1126_ICV_BASE",
						"CUP_M113New_Base",
						"CUP_M113New_Med_Base",
						"CUP_M113New_HQ_Base",
						"CUP_LAV25_Base",
						"CUP_AAV_Base",
						"CUP_B_M2Bradley_USA_D",
						"CUP_B_LAV25_USMC",
						"CUP_BMP3_Base",
						"CUP_BTR80_Base",
						"CUP_BTR90_Base",
						"CUP_BTR40_MG_Base",
						"CUP_GAZ_Vodnik_Base",
						"CUP_BTR80A_Base",
						"CUP_M113A3_Med_Base",
						"rhsusf_caiman_base",
						"rhsusf_m113tank_base",
						"rhsusf_M1237_base",
						"rhsusf_m113_usarmy",
						"MRAP_01_base_F",
						"rhsusf_stryker_m1126_m2_base",
						"rhsusf_stryker_m1127_base",
						"rhsusf_m113_usarmy_unarmed",
						"rhsusf_RG33L_base",
						"rhsusf_stryker_m1126_base",
						"rhsusf_stryker_m1132_m2_base",
						"rhsusf_RG33L_GPK_base",
						"rhsusf_M1117_D",
						"rhsusf_M1117_base",
						"rhsusf_M1232_M2_usarmy_d",
						"rhsusf_m113_usarmy_supply",
						"rhs_btr70_vmf",
						"rhsusf_m113_usarmy_MK19",
						"rhs_zsutank_base",
						"rhsgref_BRDM2",
						"rhs_btr80_msv",
						"rhsgref_BRDM2UM",
						"rhs_btr60_vmf",
						"rhs_btr60_base",
						"rhs_btr_base",
						"rhs_btr70_msv",
						"rhs_bmd1_base",
						"rhs_bmd2_base",
						"rhs_bmd2",
						"rhs_bmp1_vdv",
						"rhs_bmp1k_vdv",
						"rhs_bmp1p_vdv",
						"rhs_bmp2e_vdv",
						"rhs_bmp2_vdv",
						"rhs_bmp2d_vdv",
						"rhs_bmp2k_vdv",
						"rhs_a3spruttank_base",
						"rhs_bmd4_vdv",
						"rhs_bmp1tank_base",
						"rhs_bmp_base",
						"rhs_bmd_base",
						"rhs_brm1k_base",
						"rhs_bmp3tank_base",
						"rhs_t15_base",
						"UK3CB_BAF_Warrior_A3_W",
						"UK3CB_BAF_Warrior_A3_W_Cage",
						"UK3CB_BAF_Warrior_A3_W_Camo",
						"UK3CB_BAF_Warrior_A3_W_Cage_Camo",
						"UK3CB_BAF_Warrior_A3_D",
						"UK3CB_BAF_Warrior_A3_D_Cage",
						"UK3CB_BAF_Warrior_A3_D_Camo",
						"UK3CB_BAF_Warrior_A3_D_Cage_Camo",
						"UK3CB_BAF_FV432_Mk3_GPMG_Green",
						"UK3CB_BAF_FV432_Mk3_RWS_Green",
						"UK3CB_BAF_FV432_Mk3_GPMG_Sand",
						"UK3CB_BAF_FV432_Mk3_RWS_Sand",
						"UK3CB_AAV",
						"UK3CB_LAV25",
						"UK3CB_LAV25_HQ",
						"UK3CB_M1117_base",
						"UK3CB_M113tank_M2_90",
						"UK3CB_M113tank_M240",
						"UK3CB_M113tank_medical",
						"UK3CB_M113tank_MK19_90",
						"UK3CB_M113tank_supply",
						"UK3CB_M113tank_unarmed",
						"UK3CB_BMP1Tank_Base",
						"UK3CB_BMP2Tank_Base",
						"UK3CB_BMP2KTank_Base",
						"UK3CB_M113tank_M2",
						"UK3CB_M113tank_MK19",
						"UK3CB_BTR60_Base",
						"UK3CB_BTR70_Base",
						"UK3CB_BTR80_Base",
						"UK3CB_BTR80a_Base",
						"UK3CB_MTLB_PKT",
						"UK3CB_T34",
						"UK3CB_BRM1KTank_Base",
						"UK3CB_BMD1",
						"UK3CB_BMD1K",
						"UK3CB_BMD1P",
						"UK3CB_BMD1PK",
						"UK3CB_BMD1R",
						"UK3CB_BMD2",
						"UK3CB_Warrior_Base",
						"rhs_bmd1",
						"rhs_bmd1k",
						"rhs_bmd1p",
						"rhs_bmd1pk",
						"rhs_bmp1_msv",
						"rhs_bmp1d_msv",
						"rhs_bmp1k_msv",
						"rhs_bmp1p_msv",
						"rhs_bmp2e_msv",
						"rhs_bmp2d_msv",
						"rhs_bmp2_msv",
						"rhs_bmp2k_msv",
						"UK3CB_BRDM2",
						"UK3CB_BRDM2_ATGM",
						"UK3CB_BRDM2_HQ",
						"UK3CB_BRDM2_UM"
						];
						
Private _AAAparents = 	[
						"UK3CB_2S6M_Tunguska",
						"UK3CB_MTLB_Zu23",
						"UK3CB_ZsuTank_Base",
						"UK3CB_M939_Zu23",
						"UK3CB_MTVR_Zu23",
						"UK3CB_Ural_Zu23_Base",
						"UK3CB_V3S_Zu23",
						"UK3CB_Gaz66_ZU23_Base",
						"B_APC_Tracked_01_AA_F",
						"O_APC_Tracked_02_AA_F",
						"LT_01_AA_base_F"
						];
					   
if (_parentType in _AAAparents
or 	 _Firstparent in _AAAparents)then{_typeOfVehicle = "AAA"}
else {
if	(_parentType in _MBTparents
or   _Firstparent in _MBTparents
or 	(_CfgName in _TankCfgNames))then{_typeOfVehicle = "tank"}
else{
if	(_parentType in _APCparents
or   _Firstparent in _APCparents
or 	(_CfgName in _ApcCfgNames))then{_typeOfVehicle = "APC"}
else{
if	(_Cousin in _ArtyParents
or 	 _parentType in _ArtyParents)then{_typeOfVehicle = "Artillery"}
else{
if	(_Vehicle iskindof "car")then{
								  if	((Count (AllTurrets [_Vehicle, false])) > 0) then {_typeOfVehicle 	= "armedCar"}
								  else	{_typeOfVehicle = "unarmedCar"};
								 }
else{
if	(_Vehicle iskindof "man")
then{
		_typeOfVehicle = "man";
	}
else{
if(_Vehicle IsKindof "StaticWeapon")
then{_typeOfVehicle = "turret"}
else{
if(_Vehicle isKindOf "helicopter")
then{
		_typeOfVehicle = [_Vehicle] call Tally_Fnc_GetChopperType;
	};
}}}}}}};





If(_typeOfVehicle == "unknown"
&&{alive _Vehicle
&&{_unitScannerType != ""}})then{
							     ["Could not categorize vehicle", _CfgName] call Tally_fnc_debugMessage;
							     ["Try installing DCO Unitscanner"] call Tally_fnc_debugMessage;
						};

If(_typeOfVehicle == "unknown"
&&{_unitScannerType != ""
&&{_unitScannerType != "unknown"}})
then{_typeOfVehicle = _unitScannerType};

if(_typeOfVehicle == "unknown"
&&{_unitScannerType == "unknown"})
then{
		private _OBJscanType = [_vehicle] call ObjScan_fnc_VehicleType;
		["DCO Unitscanner identified ",_CfgName," as ", _OBJscanType] call Tally_fnc_debugMessage;
		["it was not categorized properly, tell Tally to look into it."] call Tally_fnc_debugMessage;

};

_typeOfVehicle