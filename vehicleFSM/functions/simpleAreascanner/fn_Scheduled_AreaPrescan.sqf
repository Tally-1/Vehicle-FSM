params ["_Group"];

if(!isNil "DCO_ScheduledScan")exitWith{["Double area scan blocked"] call Tally_fnc_debugMessage};
if(isNil "_Group")exitWith{};
if(isNull _Group) exitWith{};
if(!(side _Group in [east, west, independent]))exitWith{};
if(time < 10)exitWith{};


if(IsNil "DCO_GridSize")then{DCO_GridSize = 1000};

DCO_ScheduledScan			= true;
private _leader 				= leader _Group;
private _side 				= side 	 _Group;
private _enemyFound		= false;
private _enemy 				= [DCO_GridSize * 1.5, _leader] call Tally_Fnc_GetNearestEnemy;
private _clusterRadius		= 150;
private _eClusterPos			= [0,0,0];
private _scanCenter			= [_leader, _clusterRadius] call Tally_Fnc_AVGclusterPOS;
private _ScanResult			= createHashMap;
private _nearScanAvailable  	= false;
private _overWriteNearScan 	= false;
private _ScanToOverwrite		= [];
private _CopyScan 			= false;

if(!isNull _enemy)then{
						 _eClusterPos 	= [_enemy, _clusterRadius] call Tally_Fnc_AVGclusterPOS;
						 _enemyFound 	= true;
					   };

{
		private _scanPos = (_x get "center");
		if(((_scanPos distance2d _scanCenter) < (DCO_GridSize / 2))
		&&{(_x get "side") == _Side})then{_nearScanAvailable = true};
		
		if(_nearScanAvailable
		&&{_enemyFound
		&&{time - (_x get "scan time") > 20}})exitWith{
															_overWriteNearScan 	= true;
															_ScanToOverwrite 	= _x;
														};
		if(_nearScanAvailable
		&&{time - (_x get "scan time") < 20})exitWith{
														_CopyScan 	= true;
														_ScanResult 	= _x;
													  };
}ForEach 
DCO_areaScans;

if(!(_nearScanAvailable)
or _overWriteNearScan)exitWith{
								_ScanResult = [_scanCenter, _eClusterPos, _enemyFound, _overWriteNearScan, _ScanToOverwrite, _side] call Tally_Fnc_InitScan;
								_Group setVariable ["DCO_AreaScan", _ScanResult, true];
								DCO_ScheduledScan = nil;
							};

if(_CopyScan)then{_Group setVariable ["DCO_AreaScan", _ScanResult, true]};


DCO_ScheduledScan = nil;