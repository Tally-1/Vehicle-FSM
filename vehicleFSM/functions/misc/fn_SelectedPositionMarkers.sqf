params ["_Vehicle"];
if !(FSMD3Bugger) exitWith{};

private _selectedPosMarked  = (_Vehicle GetVariable "SelPosMarked");
private _EvasionPos			= (_Vehicle GetVariable "EvadePos");
private _MarkerSize			= 5;
private _Colors				= [	"ColorKhaki", 
								"ColorBlack", 
								"ColorWhite", 
								"ColorBlue"]; 

if (isnil "_EvasionPos")		exitWith{["sheeet, no destination marker...."] call Tally_fnc_debugMessage};
if (isnil "_selectedPosMarked")	exitWith{["sheeet, no destination marker...."] call Tally_fnc_debugMessage};

If(_selectedPosMarked)then	{
								{
									if (_X < (count (_Vehicle GetVariable "Markers"))) then {
																								private _Marker = ((_Vehicle GetVariable "Markers") select _X);
																								if (!IsNil "_Marker") then {deleteMarker _Marker;};
																								(_Vehicle GetVariable "Markers") deleteAt _X;
																							};
									
									
								} ForEach 
								(_Vehicle GetVariable "NextPosMarkers");
								
								_Vehicle SetVariable ["NextPosMarkers",	[], true];
							};
							
for "_I" from 1 to 4 do {
							private _Color = _Colors select (_I -1);
							private _MarkerIndex = [_Vehicle, "ELLIPSE", _EvasionPos, 0, _MarkerSize,  _Color, "Border"] 	call Tally_Fnc_VehMarkers;
							(_Vehicle GetVariable "NextPosMarkers") PushBackUnique _MarkerIndex;
							_MarkerSize = (_MarkerSize +5);
						};
						

_Vehicle SetVariable ["SelPosMarked", true, true];