params ["_scanPos", 
		"_targetPos", 
		"_enemyFound", 
		"_overWriteNearScan", 
		"_ScanToOverwrite",
		"_side"];

private _ScanResult = createHashMap;

if(_enemyFound)then{
						_ScanResult = [_side, _scanPos, _targetPos] call Tally_Fnc_AreaPreScan;
					}
				else{
						_ScanResult = [_side, _scanPos] call Tally_Fnc_AreaPreScan;
					};

if(_overWriteNearScan)	then{
								DCO_areaScans deleteAt (DCO_areaScans findIf {_x isEqualTo _ScanToOverwrite});
							};
							
DCO_areaScans pushBack _ScanResult;

while{count DCO_areaScans > 99}do{DCO_areaScans deleteAt 0};

_ScanResult