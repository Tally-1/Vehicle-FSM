/*
Declaring essential functions to missionNamespace-global in order to allow the
FSM to be run as a server-mod without forcing client-dependency
*/

missionNamespace setVariable[
"Tally_Fnc_3Dmarkers", {

if(!isnil "3DmarkersDOC")exitWith{};
3DmarkersDOC 			= true;
DCO_SelectedUnit			= "";
DCO_SelectedGroup		= "";


addMissionEventHandler ["Draw3D", {

If (FSMD3Bugger) then 	{
								private _engagedVehicles = 0;
							
								{
									
									If (_x getVariable "Evading")
									then{
											Private _Side 		= (Side _x);
											Private _SideColor 	= [1,1,1,0.5];
											private _ActionText = (_x getVariable "currentAction");
											private _FinalPos 	= (_x getVariable "EvadePos");
											private _Text	 	= "";
											private _Damage 	= (Getdammage _x);
											private _Health 	= 1 - _Damage;
											private _PathIcon	= "\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa";
											private _FPS		= diag_fps;
											if (!IsNil "_ActionText") then {_Text = _ActionText;};
											if(_Side == west)		  then{_SideColor 	= [0.2, 0.2, 1, 0.8]};
											if(_Side == east)		  then{_SideColor 	= [1, 0.2, 0.2, 0.8]};
											if(_Side == independent)  then{_SideColor 	= [0.2, 1, 0.2, 0.8]};
											_engagedVehicles = (_engagedVehicles +1);
											
											_Color = [_Damage,_Health,0,1];
											_S1ze = 1;
											_alpha = 0.4;
											_angle = 0; 
											
											drawIcon3D 	["\A3\ui_f\data\map\markers\military\warning_CA.paa", 
											_Color, 
											[((ASLToAGL getPosASL _x) select 0), ((ASLToAGL getPosASL _x) select 1), (((ASLToAGL getPosASL _x)select 2) + 1.5)], 
											_S1ze, _S1ze, _angle, (_Text), 0, 0.02, "TahomaB"];
											
											
											private _PathPosArr = (_x getVariable "pathPos");
											if (!IsNil "_PathPosArr"
											&&{(!IsNil "_FinalPos")
											&&{_FPS > 20}})
											then{
													
													_S1ze = 0.5;
													_PathPosArr = [_x] call Tally_Fnc_GetPathPositions;
													private _Poscount		= ((count _PathPosArr)-1);
													for "_I" from 0 to _Poscount
													do 	{
															private _PathPos = (_PathPosArr select _I);
															if(_I == _Poscount)
															then{
																	_PathIcon 	= "\A3\ui_f\data\map\markers\handdrawn\destroy_CA.paa"; 
																	_S1ze 		= 2;
																};
															
																	drawIcon3D 	[_PathIcon, 
																				_SideColor, 
																				_PathPos, 
																				_S1ze, 
																				_S1ze, 
																				45, 
																				"", 
																				0, 
																				0.02,
																				"TahomaB"];
																
															
															
														};
												};
											
										};
								
										
									
									If (_x getVariable "Spotted")then{
																		drawIcon3D 	["", 
																		[0,0.5,0.5,0.8], 
																		[((ASLToAGL getPosASL _x) select 0), 
																		((ASLToAGL getPosASL _x) select 1), 
																		(((ASLToAGL getPosASL _x)select 2) + 10)], 
																		0.5, 
																		0.5, 
																		45, 
																		("Detected"), 
																		0, 
																		0.02, 
																		"TahomaB"];
																	};
								
								
								
								
								
								} forEach Vehicles;
								///////////////////////////////////////////////////
								{
									private _LastArea = _X getVariable "DCO_AreaScan";
									if (!IsNil "_LastArea")
									then{
											private _grid 			= _LastArea get "grid";
											private _center 			= _LastArea get "center";
											private _targetPos 		= _LastArea get "TargetPosition";
											private _AvgAltitude		= (_LastArea get "average altitude");
											private _AvgVeg			= (_LastArea get "average vegetation");
											private _targetAssigned	= (_LastArea get "assigned target");
											private _gridCount 		= count _grid;
											private _FPS			= diag_fps;
											
											if(_AvgVeg == 0)then{_AvgVeg = 0.1};
											
											for "_I" from 0 to _gridCount -1 do
												{
													private _gridPos 		= _grid select _I;
													private _position 		= _gridPos get "position";
													private _vegetation 		= (_gridPos get "Vegetation");
													private _altitude 		= (_gridPos get "Altitude");
													private _size			= 0.75;
													private _txtSize			= 0.02;
													private _lineSpace		= -6;
													private _icon			= "\A3\ui_f\data\map\groupicons\selector_selectedFriendly_ca.paa";
													private _greenMultiplier 	=  _vegetation / _AvgVeg; 
													private _blueMultiplier 	=  _altitude / _AvgAltitude;
													private _green			= 0.5 * _greenMultiplier;
													private _blue			= 0.5 * _blueMultiplier;
													private _Color			= [	0, _green, _blue, 1];
													private _centerPos		= false;
													private _nameText		= format ["%1", (_gridPos get "gridName")];
													private _vegText			= format ["Vegetation = %1", (_vegetation)];
													private _altText			= format ["Altitude = %1", 	 (_altitude)];
													private _roadText		= format ["RoadSegments = %1", 	 (_gridPos get "RoadSegments")];
													private _buildText		= format ["Buildings = %1", 	 (_gridPos get "Buildings")];
													
													if(_targetAssigned
													&&{(_gridPos get "terrainIntersects targetPos")})
													then{
															_Color	= [	1, 0, 0, 1];
														};
													
													if(_position distance2d _Center < 5)
													then	{
																_size 		= 1;
																_txtSize		= 0.04;
																_icon 		= "\A3\ui_f\data\map\markers\military\circle_CA.paa";
																_nameText	= format ["%1", 							(_LastArea get "name")];
																_roadText	= format ["%1 roadSegments in area", 		(_LastArea get "all roads")];
																_vegText		= format ["%1 trees and bushes in area", 	(_LastArea get "all vegetation")];
																_buildText	= format ["%1 Buildings in area", 			(_LastArea get "all Buildings")];
																_altText		= format ["Average altitude = %1 m.o.s", 	(_AvgAltitude)];
																_lineSpace	= -11;
																_centerPos	= true;
																
															};
													
													drawIcon3D 	[_icon, _Color, _position, _size, _size, 45, _nameText];
													
													_Color = [0,0,0,1];
													if(_centerPos)then{_Color = [0,0.25,0.8,1]};
													
													_Position = [_Position, _lineSpace] call Tally_Fnc_Add_Z;
													drawIcon3D 	["", _Color, _position, _size, _size, 45, _buildText, 0, _txtSize];
													
													_Position = [_Position, _lineSpace] call Tally_Fnc_Add_Z;
													drawIcon3D 	["", _Color, _position, _size, _size, 45, _altText, 0, _txtSize];
													
													_Position = [_Position, _lineSpace] call Tally_Fnc_Add_Z;
													drawIcon3D 	["", _Color, _position, _size, _size, 45, _vegText, 0, _txtSize];
													
													_Position = [_Position, _lineSpace] call Tally_Fnc_Add_Z;
													drawIcon3D 	["", _Color, _position, _size, _size, 45, _roadText, 0, _txtSize];
													
												};
												if(_targetAssigned)
												then{
														private _Color 		= [0.8,0.2,0.2,1];
														private _icon 		= "\a3\UI_F_Enoch\Data\CfgMarkers\pencilCircle2_ca.paa";
														private _size		= 2;
														private _nameText 	= "Closest enemy position";
														
														drawIcon3D 	[_icon, _Color, _targetPos, _size, _size, 45, _nameText];
													};
												
											
											
										};
										
								} forEach 
								(curatorSelected select 1);
							
							
							
							}; 
					}];
}, true];


missionNamespace setVariable[
"Tally_Fnc_CalcAreaLoc", {
params ["_OrigX", "_OrigY", "_Dir", "_Distance"];


Private _NewX = ((sin _Dir) * _Distance) + _OrigX;
Private _Newy = ((cos _Dir) * _Distance) + _OrigY;

Private _SearchAreaPos = [_NewX,_NewY, 0];


_SearchAreaPos}
, true];


missionNamespace setVariable[
"Tally_Fnc_GetPathPositions", {
params["_Vehicle"];

private _DistBetweenEachPos = 15;
private _NextPosDistance 	= _DistBetweenEachPos;
private _TargetPos 			= (_Vehicle getVariable "EvadePos");
		If!([_TargetPos] 
		call 
		Tally_Fnc_IsPos)
		then{
				_TargetPos = (_TargetPos select 0);
			};
private _VehiclePos 			= (GetPos _Vehicle);
private _Dir 				= _VehiclePos getDir _TargetPos;
Private _Distance 			= (_VehiclePos distance2d _TargetPos);
private _PosAmount 			= floor (_Distance / _DistBetweenEachPos);
private _PosInBetween 		= [_VehiclePos];

if(_PosAmount > 0)
then{
		for "_I" from 1 to _PosAmount 
		do	{
				Private _Position 	= [_VehiclePos select 0, _VehiclePos select 1, _Dir, _NextPosDistance] call Tally_Fnc_CalcAreaLoc;
				_NextPosDistance = (_NextPosDistance + _DistBetweenEachPos);
				_PosInBetween pushBack _Position;
				
			};
	};
	
	_PosInBetween pushBack _TargetPos;
	
	

_PosInBetween}
, true];



// [] spawn Tally_Fnc_PathDrawer;


missionNamespace setVariable[
"Tally_Fnc_IsPos", {
Params["_Arr"];
Private _Pos = true;
if!(typeName _Arr == "ARRAY")exitWith{false};
if!(Count _Arr == 3)exitWith{false};

{
if!(typeName _X == "SCALAR")
then{_Pos = false;};
}ForEach _Arr;

_Pos}
, true];