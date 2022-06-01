private _maxTime	= 5;
params ["_vehicle", "_revDistance", "_maxTime"];
private _startPos	 	= getPos _vehicle;
private _distance 	= 0;
private _timer	 	= time + _maxTime;
private _counter	 	= 0;
private _dir			= getDir _vehicle;

If(speed _vehicle >  5)
then{
		private _script 		= [_Vehicle, 0.5, true] spawn Tally_Fnc_landBrake;
		waituntil{sleep 0.1; scriptDone _script};
	};

/*speed up*/
while { _distance < _revDistance } do
				{
					if(!alive _vehicle)exitWith{/*[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions*/};
					if(_timer < time)exitWith{};
					if(_distance > _revDistance)exitWith{};
					if(speed _vehicle < -40)exitWith	{
														_vehicle setVelocityModelSpace [0, 0, 0];
														_vehicle setPos 	[
																			getPos _vehicle select 0,
																			getPos _vehicle select 1,
																			0
																		];
													};
					
					_distance = _startPos distance2d (getPos _vehicle);
					
					private _xx =  VelocityModelSpace _vehicle select 0;
					private _yy =  VelocityModelSpace _vehicle select 1;
					private _zz =  VelocityModelSpace _vehicle select 2;
					
					if(_yy > -10)then	{
											_vehicle setDir _dir;
											_vehicle setVelocityModelSpace [0, (_yy - 0.4), -0.5];
											//_vehicle setDir _dir;
										};
					
					sleep 0.02;
				};