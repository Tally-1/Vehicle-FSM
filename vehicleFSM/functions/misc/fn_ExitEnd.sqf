params ["_Vehicle", "_EndMsg"];
_Vehicle SetVariable ["Active",  nil,	true];

if(_EndMsg == "none") exitWith{};
sleep 0.1;
[_Vehicle, _EndMsg] spawn Tally_Fnc_EndEvasionVeh