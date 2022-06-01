private _maxDeviation = 27.5;
Params ["_currentDir", "_targetDir", "_maxDeviation"];
		
		_currentDIr 		= [_currentDir] 	call Tally_Fnc_formatDir;
		_TargetDir 		= [_TargetDir] 	call Tally_Fnc_formatDir;
private _isFacingTarget	= false;
private _DirLow   		= [(_TargetDir - _maxDeviation)] 	call Tally_Fnc_formatDir;
private _DirHigh  		= [(_TargetDir + _maxDeviation)] 	call Tally_Fnc_formatDir;


if 	((_CurrentDir == _TargetDir) or
	((_CurrentDir > _DirLow) && (_CurrentDir < _DirHigh)))
	then {_isFacingTarget = true};

_isFacingTarget