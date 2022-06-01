Params ["_PosArr"];

For "_I" from 1 to 3 do {
							Private _AverageHeight = [_PosArr] call Tally_Fnc_GetAVGheight;
							_PosArr = [_PosArr, _AverageHeight] call Tally_Fnc_RemovePosLowerThan;
						};


_PosArr