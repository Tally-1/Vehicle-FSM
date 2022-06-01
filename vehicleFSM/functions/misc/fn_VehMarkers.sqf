Params ["_Vehicle", "_Shape", "_Pos", "_Dir", "_Size", "_Color", "_Brush"];

private _MarkerList		= (_Vehicle GetVariable "Markers");

if (IsNil "_MarkerList") then	{
									_Vehicle setVariable ["Markers", 	[], true];
								};

Private _MarkerName 	= Format ["Marker_%1", (round(random 10000000))];
Private _marker 		= createMarker [_MarkerName, _Pos];
private _markerIndex	= count (_Vehicle GetVariable "Markers");
(_Vehicle GetVariable "Markers") PushBackUnique _Marker;
		
		_marker setMarkerShape _Shape;
		_marker setMarkerDir _Dir;
		_marker setMarkerSize [_Size, _Size];
		_marker setMarkerBrush _Brush;
		_Marker setMarkerColor _Color;

_markerIndex