params ["_veh"];
for "_I" from 1 to 10 do 	{
								private _status = (vehicleMoveInfo _veh select 1);
								if(_status == "LEFT"
								or _status == "RIGHT")then{
															_veh sendSimpleCommand "STOPTURNING";
															sleep 0.02;
														};
								
							};