params ["_Vehicle", "_FirstScan"];
private _Minimum_Distance 	= ((_Vehicle GetVariable "MinDistEnemy") * 1.25);
private _EnemyCenter		= (_Vehicle GetVariable "centro");
private _List 				= nearestObjects [_EnemyCenter, ["land"], _Minimum_Distance];
private _Side 				= (side _Vehicle);
private _ReturnArr			= [_Vehicle];

		{
			if (side _X == 	_Side
			&& {alive _x}) 	then {
									private _AllyStatus 	= _X GetVariable "currentAction";
									private _AllyIsVeh		= !(_x iskindof "man");
									private _AllyAttacks	= ["push", "flank", "Assesing situation"];
									
									if (_FirstScan) 
									then{
											_ReturnArr pushBackUnique _X;
										}
									else{
											if(_AllyIsVeh)
											then{
													if (!IsNil "_AllyStatus")
													then {
														if (_AllyStatus in _AllyAttacks)
														then {
																_ReturnArr pushBackUnique _X;
															 };
														 };
												}
											else{
													if !(fleeing _X)
													then {
															_ReturnArr pushBackUnique _X;
														 };
												};
										};
								 };
			
		}ForEach _List;


_ReturnArr