private _DistBetweenEachPos 	= 3;
private _TerrainIntersectOnly	= true;
private _ignoreOBJ			= [];
params ["_StartPos", "_EndPos", "_DistBetweenEachPos", "_TerrainIntersectOnly", "_ignoreOBJ"];
if(isNil "_StartPos"
|| isNil "_StartPos"
|| isNil "_StartPos"
|| isNil "_StartPos"
|| isNil "_StartPos")
exitWith{false};

private _ASLvector = [AGLtoASL(_StartPos), AGLtoASL(_EndPos), _DistBetweenEachPos] call Tally_Fnc_getVectorPositions;
private _LOS = true;
private _TerrainIntersects 	= false;
private _structureIntersects 	= false;

{
	private _aglPos = ASLtoAGL _x;
	if(_aglPos select 2 < 0)
	exitWith{
				_TerrainIntersects = true;
			};
	if!(_TerrainIntersectOnly)
	then{
			
		};
		
}forEach 
_ASLvector;

if(_TerrainIntersects
or _structureIntersects)
then{_LOS = false};

_LOS