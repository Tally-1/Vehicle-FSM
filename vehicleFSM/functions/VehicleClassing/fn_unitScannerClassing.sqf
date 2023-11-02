params ["_Vehicle"];
private _VehicleData = [_Vehicle] call ObjScan_fnc_VehicleData;
private _description = [_VehicleData] call ObjScan_fnc_vehicleDescription;
private _weapons     = _vehicleData get "weaponTypes";
private _chassisID = (_vehicleData get "chassis") get "chassisID";
private _type = "unknown";

if("APC" in _description)exitWith{"APC"};
if("IFV" in _description)exitWith{"APC"};
if("Tank" in _description)exitWith{"tank"};
if("Armored Anti-Air" == _description)exitWith{"AAA"};
if("MRAP (" in _description)exitWith{"armedCar"};
if("car (" in _description)exitWith{"armedCar"};
if("MRAP" == _description)exitWith{"unarmedCar"};
if("car" == _description)exitWith{"unarmedCar"};
if("microVehicle" == _description)exitWith{"unarmedCar"};
if("Armed small chopper" == _description)exitWith{"Light Chopper"};
if("CAS chopper"  == _description)exitWith{"Heavy Chopper"};
if(_chassisID >= 4 && {_chassisID <= 4.3})exitWith{"Unarmed Chopper"};

if(6.1 in _weapons)exitWith{"Artillery"};

private _chassis   = (_vehicleData get "chassis") get "chassisDescription";







_type;