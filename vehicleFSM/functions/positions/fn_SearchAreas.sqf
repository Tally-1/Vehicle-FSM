Params ["_area1pos", "_area1Size", "_Vehicle", "_Dir"];
private _SideColor = "ColorBlack";
private _Side		= (Side (Driver _Vehicle));
private _Areas		= [];

if (_Side == west) 	then {_SideColor = "ColorWEST"}
							else {
									if (_Side == east) 	then {_SideColor = "ColorEAST"}
														else{
																if (_Side == independent) 	then {_SideColor = "ColorEAST"}
															};
								 };


If (FSMD3Bugger) then 	{
							[_Vehicle, "ELLIPSE", _area1pos, _Dir, _area1Size, "ColorRed", "Border"] call Tally_Fnc_VehMarkers; 
						};
Private _SearchAreaSize		= 	(_area1Size * 0.5);
Private _Distance			=	(_area1Size * 1.6);

Private _SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), _Dir, _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];
								
								/*If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, _SideColor, "SolidBorder"] call Tally_Fnc_VehMarkers}; */
								_Distance = (_area1Size * 0.8);

		_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir + 67.5), _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];

								/*If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, _SideColor, "SolidBorder"] call Tally_Fnc_VehMarkers}; */


		_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir - 67.5), _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];

								/*If (FSMD3Bugger) then {[_Vehicle, "RECTANGLE", _SearchAreaPos, 0, _SearchAreaSize, _SideColor, "SolidBorder"] call Tally_Fnc_VehMarkers};*/

/*_Areas pushBackUnique _Vehicle;*/
	
_Areas