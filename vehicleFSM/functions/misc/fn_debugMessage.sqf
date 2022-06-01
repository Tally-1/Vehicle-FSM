params ["_Text", "_Data"];
private _signature = format ["VehFSM. %1 --- ", DCO_Version];


if (FSMD3Bugger)then{
						If(IsNil "_Data")then{
												[format ["%1", _Text]] remoteExec ["systemChat", 0];
												
											 }
										else {
												[format ["%1 %2", _Text, _Data]] remoteExec ["systemChat", 0];
											 };
					
_Text = [_signature, _Text] joinString "";
If(IsNil "_Data")then{
												
												diag_log format ["%1", _Text];
												
											 }
										else {
												diag_log format ["%1 %2", _Text, _Data];
											 };

						};