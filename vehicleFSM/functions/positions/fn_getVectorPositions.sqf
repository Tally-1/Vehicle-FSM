private _DistBetweenEachPos 	= 3;
params ["_StartPos", "_EndPos", "_DistBetweenEachPos"];

private _Dir					= _StartPos getDir _EndPos;
Private _Distance 			= (_StartPos distance2d _EndPos);
private _PosInBetween 		= [_StartPos];
private _PosAmount 			= floor (_Distance / _DistBetweenEachPos);

if(_PosAmount > 0)
then{
		private _OrigX				= _StartPos select 0;
		private _OrigY				= _StartPos select 1;
		private _OrigZ				= _StartPos select 2;
		private _endZ				= _EndPos select 2;
		private _elevationDiff		= [_OrigZ - _endZ]  call Tally_Fnc_invertNumber;
		private _elevationBetween	= _elevationDiff / _PosAmount;
		private _NextPosDistance 	= _DistBetweenEachPos;
		private _NextPosElevation 	= _OrigZ + _elevationBetween;

		/*systemChat format ["Diff = %1, elevation between = %2", _elevationDiff, _elevationBetween];*/


		for "_I" from 1 to _PosAmount 
		do	{
				private _xx	= ((sin _Dir) * _NextPosDistance) + _OrigX;
				private _yy	= ((cos _Dir) * _NextPosDistance) + _OrigY;
				private _zz	= _NextPosElevation;
				
				
				Private _Position	= [_xx, _yy, _zz];
				_NextPosDistance	= (_NextPosDistance + _DistBetweenEachPos);
				_NextPosElevation 	= _NextPosElevation + _elevationBetween;
				_PosInBetween pushBack _Position;
				
			};
	};


_PosInBetween pushBack _EndPos;

_PosInBetween