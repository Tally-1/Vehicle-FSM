params["_PosArr", "_Height"];

Private _NewArr = [];
{_NewArr PushBackUnique _x} ForEach _PosArr;

private _deletedEntries 	= 0;
for "_I" from 0 to (count _NewArr - 1) do{
										if(_I > (count _NewArr) - 2)exitWith{};
										private _deleteIndex = (_I - _deletedEntries);
										If ((ceil (getTerrainHeightASL (_NewArr select _I))) < _Height) Then {
																														_NewArr DeleteAt _deleteIndex;
																														_deletedEntries = (_deletedEntries + 1);
																													};
									};
_NewArr