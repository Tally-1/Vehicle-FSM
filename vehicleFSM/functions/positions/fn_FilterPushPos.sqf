params ["_Original", "_AssessedPositions"];

private _FinalPositions 	 = [];
Private _PerfectPositions	 = [];
private _LOS_NoCover		 = [];
private _LOS_NoCoverNoHeight = [];
private _BadLOS				 = [];
private _TerribleLOS		 = [];
private _Selector 			 = 0;
private _MinimumPosAmount	 = 32;

if (isnil "_Original") exitWith {diag_log "DCO** Cannot filter push-positions because original array is undefined"};
if (_Original IsEqualTo []) exitWith {diag_log "DCO** No positions found, check timing of push pos loading"; nil};

if (_AssessedPositions IsEqualTo []) exitWith {diag_log "DCO** Positions have not been assessed"; nil};

	{
		private _LOSrank 			= _X select 2;
		private _HeightAdvantage 	= _X select 1;
		private _NearbyObjects 		= _X select 0;
		private _ObjectsPresent		= (count _NearbyObjects) > 0;
		
		if (_HeightAdvantage
		&& {_LOSrank < 1
		&& {_ObjectsPresent}}) then {
										_PerfectPositions pushBackUnique (_Original select _Selector);
									 }
								else {
										if (_HeightAdvantage
										&& {_LOSrank < 1}) then {
																	_LOS_NoCover pushBackUnique (_Original select _Selector);
																 }
															else {
																	if (_LOSrank < 1) then {
																								_LOS_NoCoverNoHeight pushBackUnique (_Original select _Selector);
																							}
																					  else	{
																								if (_LOSrank < 2) then {
																														_BadLOS pushBackUnique (_Original select _Selector);
																														}
																												   else {
																															if (_LOSrank < 3 ) then {
																																						_TerribleLOS pushBackUnique (_Original select _Selector);
																																					};
																														};
																							};
																 };
									 };
		
		
		_Selector = (_Selector + 1);
	} ForEach 
	_AssessedPositions;

_FinalPositions = _PerfectPositions;

private _BestCount 			= (count _PerfectPositions);
private _SecondBestCount 	= (count _LOS_NoCover);
private _ThirdBestCount 	= (count _LOS_NoCoverNoHeight);
private _LevelOfPositioning = 0;

/*
The following segment makes sure that the AI has at least 32 positions to select from (the original Array contains 99 positions in the enemy zone).
The returnValue (_FinalPositions) is organized in such a way that the best positions comes first.
*/

if(_BestCount < _MinimumPosAmount)then{
_LevelOfPositioning = 1;
										private _Counter 	= 0;
										private _PosCount 	= (count _FinalPositions);
										{
											_FinalPositions pushBackUnique _X;
											_PosCount 	= (count _FinalPositions);
											if (_PosCount >= _MinimumPosAmount) exitWith {};
										
										}ForEach _LOS_NoCover;
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 2;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _LOS_NoCoverNoHeight;
																				};
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 3;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _BadLOS;
																				};
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 4;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _TerribleLOS;
																				};
									  };

If (FSMD3Bugger) then 	{systemChat format ["Selected %1 push positions. Position ranking = %2", (Count _FinalPositions), _LevelOfPositioning]};

_FinalPositions