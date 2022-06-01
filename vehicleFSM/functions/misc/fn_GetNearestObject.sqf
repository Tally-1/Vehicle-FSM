Params ["_Pos", "_ObjArr"];
Private _Distance1		= 100000;
Private _Distance2		= 100000;
Private _Nearest		= 0;

if(Isnil "_ObjArr"
&&{!Isnil "_Pos"})exitWith{_Pos};
if(Isnil "_Pos"
&&{!Isnil "_ObjArr"})exitWith{_ObjArr select 0};

{
	_Distance2 = (_Pos Distance2d _x);
	If (_Distance2 < _Distance1) then {
	
										_Distance1 	= _Distance2;
										_Nearest	= _x;
										
									}} ForEach _ObjArr;


_Nearest