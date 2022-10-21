params ["_Vehicle"];

Private _VehicleType = "unknown";
private _VehCFG		= typeOf _Vehicle;
	
if((!isNil "modUnarmedCarCfgs")
&&{_VehCFG in modUnarmedCarCfgs})exitWith{"unarmedCar"};

if((!isNil "modArmedCarCfgs")
&&{_VehCFG in modArmedCarCfgs})exitWith{"armedCar"};

if((!isNil "modLightArmorCfgs")
&&{_VehCFG in modLightArmorCfgs})exitWith{"APC"};

if((!isNil "modHeavyArmorCfgs")
&&{_VehCFG in modHeavyArmorCfgs})exitWith{"tank"};

if((!isNil "modUnarmedChopperCfgs")
&&{_VehCFG in modUnarmedChopperCfgs})exitWith{"Unarmed Chopper"};

if((!isNil "modLightChopperCfgs")
&&{_VehCFG in modLightChopperCfgs})exitWith{"Light Chopper"};

if((!isNil "modHeavyChopperCfgs")
&&{_VehCFG in modHeavyChopperCfgs})exitWith{"Heavy Chopper"};

_VehicleType