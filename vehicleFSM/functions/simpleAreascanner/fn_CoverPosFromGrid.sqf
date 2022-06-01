params ["_AreaHash", "_Vehicle"];
private _NewGrid 	= createHashmap;
private _Grid 		= _AreaHash get "grid";

private _nearGridArr		= [_Grid, _Vehicle] call Tally_Fnc_GetNearestGridPositions;
private _noTLOSgridArr 	= [_Grid] call Tally_Fnc_GridArrTargetLOS;
Private _highVegArr		= [_Grid] call Tally_Fnc_GridArrVegetation;
private _AltitudeGridArr	= [_Grid, false] call Tally_Fnc_AltitudeGridArr;

private _finalSelection	= [_Grid, 
						   _nearGridArr, 
						   _noTLOSgridArr, 
						   _highVegArr, 
						   _AltitudeGridArr] call Tally_Fnc_SynthCoverGrid;
private _coverPos = selectRandom _finalSelection;

_coverPos