private _MinPosAmount = 5;
params ["_GridHash", 
		"_nearGridArr", 
		"_noTLOSgridArr", 
		"_highVegArr", 
		"_AltitudeGridArr"];
private _1stSelection 		= [];
private _2ndSelection 	= [];
private _3rdSelection 	= [];
private _finalSelection 	= [];

	{
		if(	_X in _nearGridArr
		&&{	_X in _noTLOSgridArr
		&&{	_X in _highVegArr
		&&{	_X in _AltitudeGridArr
		}}})then{
					_1stSelection pushback _x;
				}
			else{
			if(	_X in _nearGridArr
			&&{	_X in _noTLOSgridArr
			&&{	_X in _highVegArr
			}})then{
					_2ndSelection pushback _x;
				   }
			   else{
			   if(_X in _highVegArr
			   or _X in _noTLOSgridArr)
			   then{
					_3rdSelection pushback _x;
				}}};
		
	}forEach 
	_GridHash;
/*
hint ( parsetext format [
							"1stSelection == %1<br/>2ndSelection == %2<br/>3rdSelection == %3<br/>"
							, (count _1stSelection), (count _2ndSelection), (count _3rdSelection)]);
*/

if(count _1stSelection >= _MinPosAmount)exitWith{_1stSelection};

{_finalSelection pushbackUnique _x}forEach _1stSelection;
{_finalSelection pushbackUnique _x}forEach _2ndSelection;

if(count _finalSelection >= _MinPosAmount)exitWith{_finalSelection};

{
	_finalSelection pushbackUnique _x;
	if(count _finalSelection >= _MinPosAmount)exitWith{};
}forEach _3rdSelection;


_finalSelection