params ["_Vehicle", "_Group", "_HalfWayPos", "_TargetPos"];

private _Script = [_Group] spawn Tally_Fnc_ResetGroup;
waituntil{scriptDone _Script};
private _NewGroup = (Group _Vehicle);
[_Vehicle] 	call Tally_Fnc_RemoveAutoCombat;
_NewGroup setBehaviour 			"Aware";
_NewGroup setBehaviourStrong	"Aware";
_NewGroup setCombatBehaviour	"Aware";
_NewGroup setCombatMode 		"YELLOW";