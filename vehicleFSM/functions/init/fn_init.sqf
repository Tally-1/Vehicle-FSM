[] spawn //I chose spawn here as a quick-fix to the initial lag when starting a mission. 
	{
		private _running = missionNameSpace getVariable "DOC_FSM_Running";

		if(!Isnil "_running")
		exitWith{diag_log "DCO_Vehicle FSM seems to have fired twice, exiting script"};

		if(is3DEN)
		exitWith{diag_log "DCO_Vehicle FSM exiting, we are in eden Editor"};
		/*
		if (allDisplays isEqualTo [findDisplay 0]
		&&{hasInterface})
		exitWith {diag_log "______Could not initiate vehicle FSM, because display 0 was not found. Probably in Main menu_______"};
		*/

		missionNameSpace setVariable ["DOC_FSM_Running", true, true];


		/*Reading global functions and storing them as variables*/
		//call compile preprocessFileLineNumbers "\vehicleFSM_Scripted\functions\Allfunctions.sqf";
		[] call Tally_fnc_globalFunctions;

		if (isNil "iterationTimer")
			then{
				sleep 1;

				/*give it some time after init, then if the var is still undefined force the default values */
				if (isNil "iterationTimer")
				then{
					iterationTimer 				= 2;
					
					if (isNil "VehMinimumDistance")			then{VehMinimumDistance 		= 450  };
					if (isNil "FSMD3Bugger")				then{FSMD3Bugger 				= false};
					if (isNil "VehicleAutoRepair")			then{VehicleAutoRepair 			= true };
					
					if (isNil "DCOnoSmoke")					then{DCOnoSmoke 				= false};
					if (isNil "globalAgressionMultiplier")	then{globalAgressionMultiplier   	= 1};
					if (isNil "DCOnoGroupReset")			then{DCOnoGroupReset			= false};
					
					if (isNil "DCOnoHideGlobal")			then{DCOnoHideGlobal			= false};
					if (isNil "DCOnoFlankGlobal")			then{DCOnoFlankGlobal			= false};
					if (isNil "DCOnoPushGlobal")			then{DCOnoPushGlobal			= false};
					
					if (isNil "DCOCourageMultiplier")		then{DCOCourageMultiplier		= true};
					if (isNil "DCOquickReaction")			then{DCOquickReaction			= 1};
					if (isNil "DCOexcludePlayerGroups")		then{DCOexcludePlayerGroups		= false};
					
					

				};
				
			};
		/*PosInitCommands(DO NOT CHANGE!)*/
		DCO_AreaScan 			= false;
		DCO_Version	 			= 1.059;
		DCO_deathGroup 			= createGroup civilian;
		DCO_HintTimer			= 20;
		DCO_TenSecondTaskTimer	= 0;
		DCO_Last_AreaPreScan	= -10;
		DCO_areaScans			= [];
		DCO_GridSize			= 1000;


		DCO_AT_Values			= createHashmap;

		DCO_AT_Values set ["unknown", 			0];
		DCO_AT_Values set ["unarmedCar", 		0.01];
		DCO_AT_Values set ["Infantry", 			0.05];
		DCO_AT_Values set ["Unarmed Chopper",	0.05];
		DCO_AT_Values set ["Artillery", 		1];
		DCO_AT_Values set ["armedCar", 	 		2];
		DCO_AT_Values set ["Light Chopper", 	2];
		DCO_AT_Values set ["AT Infantry",		3]; 
		DCO_AT_Values set ["AAA", 				3.5];
		DCO_AT_Values set ["APC", 				4];
		DCO_AT_Values set ["tank", 				6];
		DCO_AT_Values set ["Heavy Chopper",		6];

		ScriptsRunningDOC	= (diag_activeScripts select 0);
		Private _Debug = FSMD3Bugger;
		{[_X] call Tally_Fnc_AddEh}ForEach Vehicles;
		[] call Tally_Fnc_CuratorEH;
		[] remoteExecCall ["Tally_Fnc_3Dmarkers", 0, true];
		missionNameSpace setVariable ["FSMD3Bugger", _Debug, true];
		if (isNil "VehicleAutoRepair")then{VehicleAutoRepair = false};
		["DCO_Vehicle FSM DCO_Version ", (DCO_Version)] 			call Tally_fnc_debugMessage;


		if(!(VehMinimumDistance == 450))		then{["Minimum distance ", 				(VehMinimumDistance)] 			call Tally_fnc_debugMessage};
		if(!(iterationTimer == 2))				then{["Iteration Timer ",  				(iterationTimer)] 				call Tally_fnc_debugMessage};
		if(!(globalAgressionMultiplier == 1))	then{["Agression Multiplier = ",	(globalAgressionMultiplier)] 	call Tally_fnc_debugMessage};
		if(!(DCOCourageMultiplier))				then{["Courage multiplier disabeled",	(DCOCourageMultiplier)] 		call Tally_fnc_debugMessage};
		if(DCOnoSmoke)							then{["Smoke disabeled ",  					(DCOnoSmoke)] 					call Tally_fnc_debugMessage};
		if(DCOnoHideGlobal)						then{["Hiding disabeled ", 				(DCOnoHideGlobal)] 				call Tally_fnc_debugMessage};
		if(DCOnoFlankGlobal)					then{["Flanking disabeled ", 			(DCOnoFlankGlobal)] 			call Tally_fnc_debugMessage};
		if(DCOnoPushGlobal)						then{["Push disabeled ", 					(DCOnoPushGlobal)] 				call Tally_fnc_debugMessage};
		if(DCOnoGroupReset)						then{["Group Reset disabeled ",				(DCOnoGroupReset)] 				call Tally_fnc_debugMessage};



		onPlayerConnected {
		/*params [_id, _uid, _name, _jip, _owner];*/

				[] remoteExecCall ["Tally_Fnc_3Dmarkers", _owner];
			
		};

		/*actual loop(FSM)*/
		While {true} do {
							private _FirstCount = (count Vehicles);
							
							_Script = [] spawn Tally_Fnc_TaskManager;
							waituntil {sleep 0.05; Scriptdone _Script};
							
							sleep iterationTimer;
							
							private _SecondCount = (count Vehicles);
							if (_FirstCount < _SecondCount)
							then{
									/*Adding eventHandlers for vehicles that have been spawned in since the taskmanager was executed*/
									{[_X] call Tally_Fnc_AddEh}ForEach Vehicles;
								};
						};
}				