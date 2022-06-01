private _completeStop = false;
params ["_vehicle", "_brakeTime", "_completeStop"];
private _speed 			= speed _vehicle;
private _fps				= 30;
private _iterations 		= _brakeTime * _fps;
private _speedReduction 	= _speed / _iterations;
private _sleep			= _brakeTime / _iterations;

for "_I" from 
1 to _iterations do
				{
					if(!alive _vehicle)exitWith{/*[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions*/};
					
					private _xx =  VelocityModelSpace _vehicle select 0;
					private _yy =  VelocityModelSpace _vehicle select 1;
					private _zz =  VelocityModelSpace _vehicle select 2;
					
					if(_yy > 1)then	{
										_vehicle setVelocityModelSpace [_xx, (_yy - _speedReduction), _zz];
										sleep _sleep;
									};
					if(_yy < -2)then{
										_vehicle setVelocityModelSpace [_xx, (_yy + _speedReduction), _zz];
										sleep _sleep;
									};
				};
				
if(_completeStop
&&{alive _vehicle})
then{
		_vehicle setVelocityModelSpace [0, 0, 0];
	};