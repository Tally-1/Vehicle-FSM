params ["_Vehicle"];
private _Crew = (_Vehicle getVariable "crew");
If !(typeName _Crew == "ARRAY") ExitwITH{
																	If(FSMD3Bugger)   then	{
																								systemChat format ["Cannot remove AutoCombat: %1", (_Crew)];
																							};
																};

{
_X disableAI "AUTOCOMBAT";
}ForEach _Crew;
