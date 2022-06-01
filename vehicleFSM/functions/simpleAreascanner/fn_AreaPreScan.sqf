private _targetPos = [];
params ["_side", "_Center", "_targetPos"];
private _areaDetails	= createHashMap;
if(IsNil "DCO_GridSize")then{DCO_GridSize = 1000};
private _name		= [_Center, DCO_GridSize] call Tally_Fnc_ClosestLocationName;
private _AreaName	= [_name, " [", round(_Center select 0), ",", round(_Center select 1), "]"] joinString "";
private _grid 		= [_Center, DCO_GridSize] call Tally_Fnc_AreaGrid;
		_grid 		= [_Center, _targetPos, _grid, DCO_GridSize] call Tally_Fnc_ObjectifyGrid;
private _AvgAltitude = [_grid, "Altitude"] call Tally_Fnc_AvgGridElement;
private _AvgVegetation = [_grid, "Vegetation"] call Tally_Fnc_AvgGridElement;
private _targetAssigned = false;



_areaDetails set ["center",				_Center];
_areaDetails set ["side",				_side];
_areaDetails set ["average altitude", 	_AvgAltitude];
_areaDetails set ["average vegetation", _AvgVegetation];
_areaDetails set ["grid", 				_grid];
_areaDetails set ["scan time", 			time];
_areaDetails set ["name", 				_AreaName];
_areaDetails set ["all roads", 			[_grid, "RoadSegments"] call Tally_Fnc_sumGridElement];
_areaDetails set ["all vegetation", 	[_grid, "Vegetation"] call Tally_Fnc_sumGridElement];
_areaDetails set ["all Buildings", 		[_grid, "Buildings"] call Tally_Fnc_sumGridElement];
if((count _targetPos) > 1)then{
								_areaDetails set ["TargetPosition", _targetPos];
								_targetAssigned = true;
							  };
_areaDetails set ["assigned target",		_targetAssigned];

_areaDetails