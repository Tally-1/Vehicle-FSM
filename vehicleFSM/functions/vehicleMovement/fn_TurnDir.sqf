params ["_veh", "_pos"];
private _turnDir = "BACK";
Private _relDir	= [(_veh getRelDir _pos)] call Tally_Fnc_formatDir;

if(_relDir < 360
&&{_relDir > 180})
then{_turnDir = "LEFT"}
else{_turnDir = "RIGHT"};

_turnDir