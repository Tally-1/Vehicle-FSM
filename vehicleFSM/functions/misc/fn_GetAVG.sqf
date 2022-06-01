
/*Returns a average number from an array of numbers, also filters away non-numeric data-types*/
_Caller_Function = "Undefined";
_exactCalculation = false;
params ["_Arr", "_Caller_Function", "_exactCalculation"];
/*Diag_Log format ["%1 called GetAVG function", (_Caller_Function)];*/

if(count _Arr == 0)
exitWith{["An empty array was passed to the GetAVG function by: ", _Caller_Function] call Tally_fnc_debugMessage; 0};

Private _NewArr = [];

{
				If (TypeName _X == "SCALAR") then {_NewArr Pushback _X};
}ForEach _Arr;

_Arr = _NewArr;

if(count _Arr == 0)exitWith{["An array with only non-scalar entries was passed to the GetAVG function by: ", _Caller_Function] call Tally_fnc_debugMessage; 0};

private _Length = (Count _Arr);
private _sum = 0;

for "_i" from 0 to (_Length - 1) do {_sum = ((_sum) + ((_Arr) select _i))};

if(_sum == 0)exitWith{["An array totalling a sum of 0 passed to the GetAVG function by: ", _Caller_Function] call Tally_fnc_debugMessage; 0};

Private _Average = (round (_sum / _Length));
if (_exactCalculation) then{_Average = (_sum / _Length)};

_Average