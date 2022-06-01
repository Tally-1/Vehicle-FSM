
private _AddedAltitude = 0;
private _IsInterSecting = false;
private _DistBetweenEachPos = 5;
params ["_StartPos", "_EndPos", "_AddedAltitude", "_DistBetweenEachPos"];



private _NextPosDistance 	= _DistBetweenEachPos;
private _Dir 				= _StartPos getDir _EndPos;
Private _Distance 			= (_StartPos distance2d _EndPos);
private _PosAmount 			= floor (_Distance / _DistBetweenEachPos);
private _InterSectionHeight = selectMax [(getTerrainHeightASL _StartPos) + _AddedAltitude, 
										 (getTerrainHeightASL _EndPos) 	 + _AddedAltitude];


for "_I" from 1 to _PosAmount 
do	{
		Private _Position 	= [_StartPos select 0, _StartPos select 1, _Dir, _NextPosDistance] call Tally_Fnc_CalcAreaLoc;
		private _Height		= (getTerrainHeightASL _Position);
		
		_NextPosDistance = (_NextPosDistance + _DistBetweenEachPos);
		if(_Height > _InterSectionHeight)
		exitWith{
					_IsInterSecting = true;
				};
		
	};


_IsInterSecting