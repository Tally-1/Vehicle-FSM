Tally_Fnc_Reveal = {
Params ["_Reciever", "_TargetArr"];
Private _Side = (Side _Reciever);
{_Reciever reveal [_x, (_Side knowsAbout _x)]} ForEach _TargetArr;
};



Tally_Fnc_EndEvasionVeh = {
params ["_Vehicle"];

diag_log "Ending EVASION";
private _Driver = (Driver _Vehicle);

If 	((!IsNil "_Driver") 	&&
	(alive _Driver)) 	then {
								Private _Script = [(group _Driver)] spawn Tally_Fnc_ResetGroup;
								waituntil {ScriptDone _Script};
								{[_X, (_Vehicle GetVariable "Cluster")] spawn Tally_Fnc_Reveal} ForEach (Units (Group (Driver _Vehicle)));

							};
(Gunner _Vehicle) doWatch objNull;

{deleteMarker _X} ForEach (_Vehicle GetVariable "Markers");

			
			_Vehicle SetVariable ["Cluster", 		nil, true];
			_Vehicle SetVariable ["Centro", 		nil, true];
			_Vehicle SetVariable ["Spacing", 		nil, true];
			_Vehicle SetVariable ["Positions", 		nil, true];
			_Vehicle SetVariable ["Areas", 			nil, true];
			_Vehicle SetVariable ["Markers", 		nil, true];
			_Vehicle SetVariable ["Evading", 		nil, true];
			_Vehicle SetVariable ["EvadePos",		nil, true];
			_Vehicle SetVariable ["timer",			nil, true];
			_Vehicle SetVariable ["MinDistEnemy", 	nil, true];
};

Tally_Fnc_VehMarkers = {
Params ["_Vehicle", "_Shape", "_Pos", "_Dir", "_Size", "_Color", "_Brush"];

Private _MarkerName = Format ["Marker_%1", (round(random 10000000))];
Private _marker 	= createMarker [_MarkerName, _Pos];
		(_Vehicle GetVariable "Markers") PushBackUnique _Marker;
		
		_marker setMarkerShape _Shape;
		_marker setMarkerDir _Dir;
		_marker setMarkerSize [_Size, _Size];
		_marker setMarkerBrush _Brush;
		_Marker setMarkerColor _Color;

};

Tally_Fnc_CalcAreaLoc = {
params ["_OrigX", "_OrigY", "_Dir", "_Distance"];


Private _NewX = ((sin _Dir) * _Distance) + _OrigX;
Private _Newy = ((cos _Dir) * _Distance) + _OrigY;

Private _SearchAreaPos = [_NewX,_NewY, 0];


_SearchAreaPos};



Tally_Fnc_SearchAreas = {
Params ["_area1pos", "_area1Size", "_Vehicle", "_Dir"];

If (FSMD3Bugger) then {
						[_Vehicle, "ELLIPSE", _area1pos, _Dir, _area1Size, "ColorRed", "SolidBorder"] call Tally_Fnc_VehMarkers; 
						};
Private _SearchAreaSize		= 	(_area1Size * 0.5);
Private _Distance			=	(_area1Size * 1.6);

Private _SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), _Dir, _Distance] call Tally_Fnc_CalcAreaLoc);
								(_Vehicle GetVariable "Areas") PushBackUnique [_SearchAreaPos, _SearchAreaSize];
								
						If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, "ColorBlack", "SolidBorder"] call Tally_Fnc_VehMarkers}; 
						

_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir + 45), _Distance] call Tally_Fnc_CalcAreaLoc);
						(_Vehicle GetVariable "Areas") PushBackUnique [_SearchAreaPos, _SearchAreaSize];

						If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, "ColorBlue", "SolidBorder"] call Tally_Fnc_VehMarkers}; 


_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir - 45), _Distance] call Tally_Fnc_CalcAreaLoc);
						(_Vehicle GetVariable "Areas") PushBackUnique [_SearchAreaPos, _SearchAreaSize];

						If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, "ColorGreen", "SolidBorder"] call Tally_Fnc_VehMarkers};
		
};



Tally_Fnc_Scan_Area = {
Params ["_Pos", "_Size", "_Vehicle"];

Private _PosAmount 	= 10;
Private _Spacing 	= (_Size / _PosAmount);

Private _StartPos = ([(_Pos select 0), (_Pos select 1), 225, (_Size * 1.272727)] Call Tally_Fnc_CalcAreaLoc);
_StartPos = [	_StartPos select 	0, 
				_StartPos select 	1, 
									0];

For "_I" from 1 to _PosAmount do {
									[_StartPos, _Spacing, _PosAmount, _Vehicle] call Tally_Fnc_Ygrid;
									 _StartPos = [((_StartPos select 0) + (_Spacing * 2)), 
													_StartPos select 1, 
																	 0];
								  };
_Vehicle SetVariable ["Spacing", 		_Spacing, true];
};

Tally_Fnc_Ygrid = {
params ["_Pos", "_Spacing", "_Final_Height", "_Vehicle"];
Private _Center = (_Vehicle GetVariable "Centro");

	for "_i" from 1 to _Final_Height do {
											
											If !(surfaceIsWater [(_Pos select 0), (_Pos select 1)]) then {
											if !(terrainIntersect [_pos, _Center]) Then 	{
											
																											(_Vehicle GetVariable "Positions") PushbackUnique  _Pos;
																											If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _Pos, 0, _Spacing, "ColorOrange", "SolidBorder"] call Tally_Fnc_VehMarkers};
																										  }};
											
											_Pos = [_Pos select 0, (_Pos select 1) + (_Spacing * 2), 1];
								
										};

};

Tally_Fnc_FilterPos = {
Params ["_Vehicle", "_Center"];

Diag_Log format ["%1 positions pre-selected", (count (_Vehicle GetVariable "Positions"))];

If (FSMD3Bugger) then {[_Vehicle, "ELLIPSE", _Center, 0, 150, "Colorblue", "SOLID"] call Tally_Fnc_VehMarkers};

_FinalPositions = [(_Vehicle GetVariable "Positions")] Call Tally_Fnc_GetTopHeights;
_Vehicle SetVariable ["Positions", _FinalPositions, true];

_FinalPositions = [(_Vehicle GetVariable "Positions"), _Center] Call Tally_Fnc_GetClosePosArr;
{(_Vehicle GetVariable "Positions") PushBackUnique _X} forEach _FinalPositions;


If (FSMD3Bugger) then {
								{
								[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorRed", "SOLID"] call Tally_Fnc_VehMarkers;
								} ForEach (_Vehicle GetVariable "Positions");
						};
						
Diag_Log format ["%1 positions left", (count (_Vehicle GetVariable "Positions"))];
};





Tally_Fnc_GetTopHeights = {
Params ["_PosArr"];
Private _NewArr = [];
{_NewArr PushBackUnique _x} ForEach _PosArr;
Private _PosCount = 0;

For "_I" from 1 to 2 do {
							Private _Counter = 0;
							Private _AverageHeight = [_NewArr] call Tally_Fnc_GetAVGheight;
							
							{
								If ((ceil (getTerrainHeightASL _x)) < _AverageHeight) Then {
																								_NewArr DeleteAt _Counter;
																								_PosCount = (_PosCount + 1);
																							};
								 
								_Counter = (_Counter + 1);
							} ForEach _NewArr;
						 };
Diag_Log format ["%1 positions deleted due to height", (_PosCount)];



_NewArr};

Tally_Fnc_GetClosePosArr = {
Params ["_PosArr", "_Center"];
Private _NewArr = [];
Private _PosCount = 0;
{_NewArr PushBackUnique _x} ForEach _PosArr;


							Private _Counter = 0;
							Private _AverageDistance = (Round ([_NewArr, _Center] call Tally_Fnc_GetAVG_Distance));
							Diag_Log format ["Average Distance %1", _AverageDistance];
							
							{
								Private _Distance = (Round(_Center Distance2D _x));
								
								If (_Distance > _AverageDistance) Then {
																								_NewArr DeleteAt _Counter;
																						
																								_PosCount = (_PosCount + 1);
																					};
								 
								_Counter = (_Counter + 1);
							} ForEach _NewArr;
						 
						  
						  
Diag_Log format ["%1 positions deleted due to Distance", (_PosCount)];



_NewArr};


Tally_Fnc_GetAVG_Distance = {
Params ["_PosArr", "_Center"];

Private _Distances = [];
private _AverageDistance = 0;

if (Count _PosArr > 1) then {
								{
											private _Dist = (_Center Distance2D _x);
											If (TypeName _Dist == "SCALAR") then {_Distances Pushback _Dist};
								
								}forEach _PosArr;


								If (Count _Distances > 0) then {_AverageDistance = ([_Distances, "Tally_Fnc_GetAVG_Distance"] call Tally_Fnc_GetAVG)};
							};

If (IsNil "_AverageDistance") then {_AverageDistance = 0};

_AverageDistance};







Tally_Fnc_GetAVGheight = {
Params ["_PosArr"];
Private _Heights = [];
private _AverageHeight = 0;


if (Count _PosArr > 1) then {
								{
										private _elevation = (round getTerrainHeightASL _x);
										If (TypeName _elevation == "SCALAR") then {_Heights Pushback _elevation};
										 
								}forEach _PosArr;

								If (Count _Heights > 0) then {_AverageHeight = (round ([_Heights, "Tally_Fnc_GetAVGheight"] call Tally_Fnc_GetAVG))};
							};

If (IsNil "_AverageHeight") then {_AverageHeight = 0;};

_AverageHeight};




Tally_Fnc_GetAVG = {
_Caller_Function = "Undefined";
params ["_Arr", "_Caller_Function"];
Diag_Log format ["%1 called GetAVG function", (_Caller_Function)];

Private _NewArr = [];

{
				If (TypeName _X == "SCALAR") then {_NewArr Pushback _X};
}ForEach _Arr;

_Arr = _NewArr;

private _Length = (Count _Arr);
private _sum = 0;

for "_i" from 0 to (_Length - 1) do 
									{_sum = ((_sum) + ((_Arr) select _i))};

Private _Average = (floor (_sum / _Length));

_Average};











Tally_Fnc_EvadeVEh = {
Private _Minimum_Distance 	= 400; 
Private _DeBug = false;
Params ["_Vehicle", "_Minimum_Distance", "_DeBug"];

Private _Driver 				= (driver _Vehicle);
Private _Evading = (_Vehicle getVariable "Evading");
Private _Group				= (Group _Driver);
private _Side				= (Side _Driver);
Private _Timer				= (Time + 3);
Private _Enemy    			= [_Minimum_Distance, _Driver] call Tally_Fnc_GetNearestEnemy;

FSMD3Bugger = _DeBug;



If (Isnil "_Enemy")                                 		ExitWith {};
If (Isnull _Enemy)                                 		ExitWith {};
diag_log format ["side Vehicle %1 Has %2 TargetKnowledge", _Vehicle, (_Side knowsAbout _Enemy)];
If ((!((_Side knowsAbout _Enemy) > 0)) 
&& (!((_Group knowsAbout _Enemy) > 0)))               	ExitWith {diag_log format ["Side for Vehicle %1 does not know about near enemy", _Vehicle];};
private _EnemyDist	= (_Vehicle Distance2D _Enemy);
If (!Alive _Enemy)                                 		ExitWith {diag_log format ["Vehicle %1 Has DEAD enemies", _Vehicle];};



Private _EnAvgPos			= ([_Enemy, (Round(_Minimum_Distance * 0.5))] call Tally_Fnc_AVGclusterPOS);
Private _EnemyCluster		= ([_Enemy, (Round(_Minimum_Distance * 0.5))] call Tally_Fnc_ClusterMembers);




Private _EnemyDir 	= ((_Vehicle getRelDir _Enemy) + (Getdir _Vehicle));
Private _evasionDir = ((_EnemyDir - 180) + 0);
Private _GoDistance = ((_Minimum_Distance - (_Vehicle Distance2D _Enemy)) + (_Minimum_Distance / 5)); 

_Vehicle SetVariable ["Evading", true, true];




If (_EnemyDist < 50) then {_evasionDir = (getDir _Vehicle)};



Private _dummy = "B_Static_Designator_01_F" createVehicleLocal [0,0,0];
_dummy allowdammage false;
hideObject _dummy;


for "_I" from 0 to 3 do {
							_dummy SetPos (GetPos _Vehicle);
							sleep 0.02;
						};

_dummy SetDir _evasionDir;
Waituntil {Sleep 0.02; (((Getdir _Dummy) == (_evasionDir)) or (Time > _Timer))};


Private _EvasionPos = (_Dummy modelToWorld [0,_GoDistance ,0]);
sleep 0.1;
Deletevehicle _Dummy;


[_Group] spawn Tally_Fnc_DeleteWP;





_Vehicle SetVariable ["Cluster",		_EnemyCluster,									true];
_Vehicle SetVariable ["Centro",			_EnAvgPos,										true];
_Vehicle SetVariable ["Positions",		[], 											true];
_Vehicle SetVariable ["Areas", 			[], 											true];
_Vehicle SetVariable ["Markers", 		[], 											true];
_Vehicle SetVariable ["timer", 			(round((time) + (_Minimum_Distance / 5))), 		true];
_Vehicle SetVariable ["MinDistEnemy", 	_Minimum_Distance, 								true];

Private _Script = [(getpos _Enemy), _Minimum_Distance, _Vehicle, _evasionDir] spawn Tally_Fnc_SearchAreas;
Waituntil {ScriptDone _Script};
{
Private _arr = _x;
_arr PushbackUnique _Vehicle;
_Script =  _arr spawn Tally_Fnc_Scan_Area;
Waituntil {ScriptDone _Script};
} ForEach (_Vehicle GetVariable "Areas");
_Script = [_Vehicle, _EnAvgPos] Spawn Tally_Fnc_FilterPos;
Waituntil {ScriptDone _Script};

Private _EvasionPos2 = (SelectRandom (_Vehicle GetVariable "Positions"));
If !(IsNil "_EvasionPos2") then {_EvasionPos = _EvasionPos2};
_Vehicle SetVariable ["EvadePos", 		_EvasionPos, true];

_Group setBehaviourStrong "AWARE";

_Driver DoMove _EvasionPos;

{[_X, (_Vehicle GetVariable "Cluster")] spawn Tally_Fnc_Reveal} ForEach (Units (Group (Driver _Vehicle)));

If (FSMD3Bugger) then {
							[_Vehicle, "ELLIPSE", _EvasionPos, 0, 20, "ColorKhaki", "Border"] call Tally_Fnc_VehMarkers;
							[_Vehicle, "ELLIPSE", _EvasionPos, 0, 15, "ColorBlack", "Border"] call Tally_Fnc_VehMarkers;
							[_Vehicle, "ELLIPSE", _EvasionPos, 0, 10, "ColorWhite", "Border"] call Tally_Fnc_VehMarkers;
							[_Vehicle, "ELLIPSE", _EvasionPos, 0, 5,  "ColorBlue", "Border"] call Tally_Fnc_VehMarkers;
						};
};



Tally_Fnc_Check_EvasionVeh_Conditions = {
params ["_Vehicle"];

if 	((IsNil "_Vehicle") 
or 	(IsNull _Vehicle)) exitWith {};

Private _Evading 	= (_Vehicle getVariable "Evading");

if 	(IsNil "_Evading")  exitWith {}; 

Private _TargetPos 			= (_Vehicle getVariable "EvadePos");
Private _Minimum_Distance	= (_Vehicle getVariable "MinDistEnemy");
Private _Timer 				= (_Vehicle getVariable "timer");
private _Distance			= (_Vehicle Distance2D _TargetPos);
private _Driver				= (Driver _Vehicle);
Private _Enemy    			= ([(_Minimum_Distance * 1.5), _Driver] call Tally_Fnc_GetNearestEnemy);
Private _EnemyDist			= (_Driver Distance2D _Enemy);
Private _Radius				= (_Minimum_Distance / 10); 


If	(IsNil "_Driver") 			exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(IsNull _Driver) 			exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(!Alive _Driver) 			exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(!CanMove _Vehicle)			exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(crew _Vehicle IsEqualTo []) 	exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(_Distance < _Radius) 		exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(time > _Timer) 			exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};
IF	(fuel _Vehicle == 0) 		exitWith {[_Vehicle] spawn Tally_Fnc_EndEvasionVeh};



If ((_Distance > _Radius) 
&& {((velocityModelSpace _Vehicle) select 1) < 5}) then {
															_Driver moveTo _TargetPos;
															_Driver setBehaviourStrong "AWARE";
															(Group _Driver) setSpeedMode "FULL";
															sleep 3;
															If ((((velocityModelSpace _Vehicle) select 1) < 1) && (!IsNil "_Evading"))
															then {_Driver DoMove _TargetPos};
														};

If (Alive (Gunner _Vehicle)) then 	{
										Private _Taken = (_Vehicle GetVariable "DaDa");
										
										If (!Isnil "_Taken") exitWith {};
										
										_Vehicle SetVariable ["DaDa", true, true];
										
										Private _Target = (SelectRandom (_Vehicle GetVariable "Cluster"));
										(Gunner _Vehicle) reveal [_Target, 4];
										
										sleep 1;
										(Gunner _Vehicle) dofire _Target;
										
										
										
										_Vehicle SetVariable ["DaDa", nil, true];
									};

												
														



};

Tally_Fnc_ClusterMembers = {
Params ["_Unit", "_Radius"];
private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _NewList = [];

	{				
	if 	((Side _x) == (_Side))
	then 	{
			
				_NewList PushBackUnique _X;
			};
			
	}ForEach _list;
diag_log format ["%1 enemy units in area", (Count _NewList)];
_NewList};





Tally_Fnc_AVGclusterPOS = {
params ["_unit", "_Radius"];
private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _Yarr 	= [];
Private _Xarr 	= [];



{
	if 	((Side _x) == (_Side))
	then 	{
			
				Private _Xpos   = (round ((Getpos _x) select 0));
				Private _Ypos   = (round ((Getpos _x) select 1));
				_Yarr PushBackUnique _Ypos;
				_Xarr PushBackUnique _Xpos;
			};
}ForEach _list;



Private _Returnpos = [(round ([_Xarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), (round ([_Yarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), 0];
If (Isnil "_Returnpos") then {
								_Returnpos = _Pos;
							};

_Returnpos};



Tally_Fnc_GetNearestEnemy = {
Private _Enemy = objnull; 
Params ["_Radius", "_Unit"];
Private _pos 	= (GetPos _Unit);
private _list 	= _pos nearObjects _Radius;
Private _Side 	= (Side _Unit);
private _Enemies = [];

	{
	if (_x iskindof "Land") then {
									
									
									If ((side _x) in [west, east, Independent])
									then{
									
									If (!((Side _x) == (_Side)))
									then {
									
									Private _Otherside = (Side _X);
									if !([_Side, _Otherside] call BIS_fnc_sideIsFriendly) 
									then {
									
									_Enemies PushbackUnique _x;
									
									}}}}}
									ForEach _list;

If ((count _Enemies) > 0) then {
									_Enemy = [_Pos, _Enemies] call Tally_Fnc_GetNearestObject;
								};



_Enemy};




Tally_Fnc_VehEligbleFSM = {


params ["_Vehicle"];
Private _eligble = false;
Private _Evading = (_Vehicle getVariable "Evading");


if 	(!IsNil "_Vehicle" 
&& 	{!IsNull _Vehicle 
&& 	{Alive _Vehicle
&& 	{_Vehicle Iskindof "Land"
&& 	{!(_Vehicle Iskindof "man")
&& 	{!(crew _Vehicle IsEqualTo [])
&& 	{Alive (driver _Vehicle)
&& 	{CanMove _Vehicle
&& 	{IsNil "_Evading"
&&	{((Count (AllTurrets [_Vehicle, false])) > 0)
&&	{!(fuel _Vehicle == 0)
	}}}}}}}}}}) 
				then {_eligble = true};

_eligble};





Tally_Fnc_GetNearestObject = {
Params ["_Pos", "_ObjArr"];
Private _Distance1		= 100000;
Private _Distance2		= 100000;
Private _Nearest		= 0;

{
	_Distance2 = (_Pos Distance2d _x);
	If (_Distance2 < _Distance1) then {
	
										_Distance1 	= _Distance2;
										_Nearest	= _x;
										
									Sleep 0.1}} ForEach _ObjArr;


_Nearest};




Tally_Fnc_DeleteWP = {
Params ["_Group"];
If ((count waypoints _group) > 0) then {
										for "_i" from count waypoints _group - 1 to 0 step -1 do
													
													{deleteWaypoint [_group, _i]};
													{deleteWaypoint _x}ForEach (waypoints _Group);
										};
};



Tally_Fnc_ResetGroup = {
Params ["_Group"];

Private _NewGroup = createGroup (side _Group);
 

{ [_x] joinSilent _NewGroup } forEach (units _Group);
{ [_x] joinSilent _NewGroup } forEach (units _Group);
DeleteGroup _Group;
_NewGroup deleteGroupWhenEmpty true;

_NewGroup};