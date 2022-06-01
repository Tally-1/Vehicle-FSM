
params ["_Center", 
		"_targetPos", 
		"_Grid", 
		"_Size"];

private _NewGrid  		= [];
private _Centro	 		= [_Center select 0, 	_Center select 1, 	(_Center select 2)	+ 1.5];
private _EndPos	 		= [];
private _targetAssigned 	= false;
private _PosSize	 		= _Size / 20;
private _Counter 		= 1;

if(count _targetPos > 1)
then{
		_EndPos = [_targetPos select 0, _targetPos select 1, (_targetPos select 2)	+ 1.5];
		_targetAssigned = true;
	};


{
	
	if(!(_Center isEqualTo _x))then{
		private _PosHash = createHashMap;
		_PosHash set ["position", _X];
		private _Pos	 	= [_X select 0, _X select 1, (_X select 2) + 1.5];
		private _Vegetation 	= nearestTerrainObjects [_X, ["Tree", "Bush", "SMALL TREE"], _PosSize, false, true];
		private _Buildings 	= _x nearObjects 			["Building", _PosSize * 1.25];
		private _Roads 		= _X nearRoads _PosSize;
		private _altitude		= (AGLToASL _X) select 2;
		
		if(_targetAssigned)
		then{_PosHash set ["terrainIntersects targetPos", 	(!([_Pos, _targetPos, 20] call Tally_Fnc_LOS_Light)) /*terrainIntersect [_Centro, _Pos]*/];
			 _PosHash set ["TargetPosition", 				_targetPos]};
			 _PosHash set ["terrainIntersects Center", 		(!([_Pos, _Centro, 20] call Tally_Fnc_LOS_Light)) /*terrainIntersect [_targetPos, _Pos]*/];
			 _PosHash set ["Altitude", 						_altitude];
			 _PosHash set ["Vegetation", 					count _Vegetation];
			 _PosHash set ["Buildings", 					count _Buildings];
			 _PosHash set ["RoadSegments", 					count _Roads];
			 _PosHash set ["gridName", 						(["grid ", _Counter] joinString "")];
		
		_NewGrid pushBack _PosHash;
		_Counter = _Counter +1;
	
}}forEach _Grid;



_NewGrid