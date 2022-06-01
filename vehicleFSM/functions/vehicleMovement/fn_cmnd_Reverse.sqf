private _distanceToGo 	= 10;
private _maxTime 		= 5;
params ["_vehicle", "_distanceToGo", "_maxTime"];
private _startPos 	= (getPos _vehicle);
private _Timer = time + _maxTime;

for "_I" from 1 to 100 
do	{
		private _distance = _startPos distance2d (getPos _vehicle);
		_Vehicle sendSimpleCommand "BACK";
		sleep 0.5;
		if(_distance > _distanceToGo
		or time > _timer
		or !alive _vehicle)exitWith{};
	};