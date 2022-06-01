params ["_Center", "_Size"];
private _iterationDistance	=  _Size / 10;
private _grid = [];

private _startPos 	= 	[
						(_Center select 0) - (_Size / 2),
						(_Center select 1) - (_Size / 2),
						(_Center select 2)
					];

private _pos = _startPos;
private _Counter = 1;

for "_I" from 1 to 100 do{

if(_Counter == 11)then{
						_Counter = 1;
						_Pos = 	[
									_startPos select 0,
									(_pos select 1) + _iterationDistance,
									(_pos select 2)
								];
					 };
if(!surfaceIsWater _pos)
then{
		_grid pushBack _pos;
	};



_pos = 	[
			(_pos select 0) + _iterationDistance,
			(_pos select 1),
			1.5
		];
_Counter = (_Counter + 1);
};

_grid