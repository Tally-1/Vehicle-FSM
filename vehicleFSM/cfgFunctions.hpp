class CfgFunctions
{
	class Tally
	{
		class VFSM_Init 	
		{
			class init {file = "\vehicleFSM\functions\init\fn_init.sqf"; postInit = 1};
		};
		class endFSM
		{
			class Check_EvasionVeh_Conditions	
			{file = "\vehicleFSM\functions\endFSM\fn_Check_EvasionVeh_Conditions.sqf"};
			class EngageEnemy		{file = "\vehicleFSM\functions\endFSM\fn_EngageEnemy.sqf"};
			class EndEvasionVeh		{file = "\vehicleFSM\functions\endFSM\fn_EndEvasionVeh.sqf"};
			class ResumeOriginalPath{file = "\vehicleFSM\functions\endFSM\fn_ResumeOriginalPath.sqf"};
			class Available_And_Wp	{file = "\vehicleFSM\functions\endFSM\fn_Available_And_Wp.sqf"};
			class GroupFsmActive	{file = "\vehicleFSM\functions\endFSM\fn_GroupFsmActive.sqf"};
			class crewDead			{file = "\vehicleFSM\functions\endFSM\fn_crewDead.sqf"};
			class PostScriptActions	{file = "\vehicleFSM\functions\endFSM\fn_PostScriptActions.sqf"};
			class RemoveVehicleVars	{file = "\vehicleFSM\functions\endFSM\fn_RemoveVehicleVars.sqf"};
		};
								
		class helicopters
		{
			class GetChopperType	{file = "\vehicleFSM\functions\helicopters\fn_GetChopperType.sqf"};
			class ChopperEvasion	{file = "\vehicleFSM\functions\helicopters\fn_ChopperEvasion.sqf"};
		};
								
		class misc
		{
			
			class TransferGroupKnowledge
			{file = "\vehicleFSM\functions\misc\fn_TransferGroupKnowledge.sqf"};
			class GetVehicle_Width_Length 		
			{file = "\vehicleFSM\functions\misc\fn_GetVehicle_Width_Length.sqf"};
			class Split_From_Abandoned_Group_Vehicle 
			{file = "\vehicleFSM\functions\misc\fn_Split_From_Abandoned_Group_Vehicle.sqf"};
			class SelectedPositionMarkers 		
			{file = "\vehicleFSM\functions\misc\fn_SelectedPositionMarkers.sqf"};

			class CuratorEH 		{file = "\vehicleFSM\functions\misc\fn_CuratorEH.sqf"};
			class Reveal 			{file = "\vehicleFSM\functions\misc\fn_Reveal.sqf"};
			class CrewInVehicle 	{file = "\vehicleFSM\functions\misc\fn_CrewInVehicle.sqf"};
			class GetGroupVehicles 	{file = "\vehicleFSM\functions\misc\fn_GetGroupVehicles.sqf"};
			class VehMarkers 		{file = "\vehicleFSM\functions\misc\fn_VehMarkers.sqf"};
			class Timer_divisor 	{file = "\vehicleFSM\functions\misc\fn_Timer_divisor.sqf"};
			class MinDistMultiplier	{file = "\vehicleFSM\functions\misc\fn_MinDistMultiplier.sqf"};
			class ClusterMembers 	{file = "\vehicleFSM\functions\misc\fn_ClusterMembers.sqf"};
			class GetNearestEnemy 	{file = "\vehicleFSM\functions\misc\fn_GetNearestEnemy.sqf"};
			class PlayerGroup 		{file = "\vehicleFSM\functions\misc\fn_PlayerGroup.sqf"};
			class ExcludeP_group 	{file = "\vehicleFSM\functions\misc\fn_ExcludeP_group.sqf"};
			class VehEligbleFSM 	{file = "\vehicleFSM\functions\misc\fn_VehEligbleFSM.sqf"};
			class GetNearestObject	{file = "\vehicleFSM\functions\misc\fn_GetNearestObject.sqf"};
			class Add_Z 			{file = "\vehicleFSM\functions\misc\fn_Add_Z.sqf"};
			class TerrainIntersects {file = "\vehicleFSM\functions\misc\fn_TerrainIntersects.sqf"};
			class GroupInit 		{file = "\vehicleFSM\functions\misc\fn_GroupInit.sqf"};
			class ResetGroup 		{file = "\vehicleFSM\functions\misc\fn_ResetGroup.sqf"};
			class CheckCrewStatus	{file = "\vehicleFSM\functions\misc\fn_CheckCrewStatus.sqf"};
			class HandleCrewStatus 	{file = "\vehicleFSM\functions\misc\fn_HandleCrewStatus.sqf"};
			class GetAVG	 		{file = "\vehicleFSM\functions\misc\fn_GetAVG.sqf"};
			class GetAVGheight 		{file = "\vehicleFSM\functions\misc\fn_GetAVGheight.sqf"};
			class ForceCalculator 	{file = "\vehicleFSM\functions\misc\fn_ForceCalculator.sqf"};
			class GetAVGgroupCourage{file = "\vehicleFSM\functions\misc\fn_GetAVGgroupCourage.sqf"};
			class Flank_Hide_Push 	{file = "\vehicleFSM\functions\misc\fn_Flank_Hide_Push.sqf"};
			class CalcAT2 			{file = "\vehicleFSM\functions\misc\fn_CalcAT2.sqf"};
			class AddEh 			{file = "\vehicleFSM\functions\misc\fn_AddEh.sqf"};
			class InitHiding  		{file = "\vehicleFSM\functions\misc\fn_InitHiding.sqf"};
			class InitPush 			{file = "\vehicleFSM\functions\misc\fn_InitPush.sqf"};
			class CrewDead 			{file = "\vehicleFSM\functions\misc\fn_CrewDead.sqf"};
			class RemoveAutoCombat 	{file = "\vehicleFSM\functions\misc\fn_RemoveAutoCombat.sqf"};
			class UpdateKnownEnemies{file = "\vehicleFSM\functions\misc\fn_UpdateKnownEnemies.sqf"};
			class KnownEnemiesDead	{file = "\vehicleFSM\functions\misc\fn_KnownEnemiesDead.sqf"};
			class Is_Evading 		{file = "\vehicleFSM\functions\misc\fn_Is_Evading.sqf"};
			class FormationStop		{file = "\vehicleFSM\functions\misc\fn_FormationStop.sqf"};
			class FormationStart	{file = "\vehicleFSM\functions\misc\fn_FormationStart.sqf"};
			class DeploySmoke 		{file = "\vehicleFSM\functions\misc\fn_DeploySmoke.sqf"};
			class GetNearFriends 	{file = "\vehicleFSM\functions\misc\fn_GetNearFriends.sqf"};
			class GetVehicleWeapons	{file = "\vehicleFSM\functions\misc\fn_GetVehicleWeapons.sqf"};
			class SwitchEngagement	{file = "\vehicleFSM\functions\misc\fn_SwitchEngagement.sqf"};
			class debugMessage		{file = "\vehicleFSM\functions\misc\fn_debugMessage.sqf"};
			class invertNumber		{file = "\vehicleFSM\functions\misc\fn_invertNumber.sqf"};
			class ExitEnd			{file = "\vehicleFSM\functions\misc\fn_ExitEnd.sqf"};
			class globalFunctions	{file = "\vehicleFSM\functions\misc\fn_globalFunctions.sqf"};	
		};
								
		class positions
		{
			class Remove_NonTerrain_IntersectPos	
			{file = "\vehicleFSM\functions\positions\fn_Remove_NonTerrain_IntersectPos.sqf"};
			class GetLowerThanTopPositions	
			{file = "\vehicleFSM\functions\positions\fn_GetLowerThanTopPositions.sqf"};
			class RemovePosLowerThan	
			{file = "\vehicleFSM\functions\positions\fn_RemovePosLowerThan.sqf"};
			class GetFriendlyPushPos		 
			{file = "\vehicleFSM\functions\positions\fn_GetFriendlyPushPos.sqf"};
			class getVectorPositions		 
			{file = "\vehicleFSM\functions\positions\fn_getVectorPositions.sqf"};
			
			class FilterPos		 {file = "\vehicleFSM\functions\positions\fn_FilterPos.sqf"};
			class FilterHidePos	 {file = "\vehicleFSM\functions\positions\fn_FilterHidePos.sqf"};
			class GetHidePos	 {file = "\vehicleFSM\functions\positions\fn_GetHidePos.sqf"};
			class SearchAreas	 {file = "\vehicleFSM\functions\positions\fn_SearchAreas.sqf"};
			class Scan_Area		 {file = "\vehicleFSM\functions\positions\fn_Scan_Area.sqf"};
			class Ygrid			 {file = "\vehicleFSM\functions\positions\fn_Ygrid.sqf"};
			class GetTopHeights	 {file = "\vehicleFSM\functions\positions\fn_GetTopHeights.sqf"};
			class GetAVG_Distance{file = "\vehicleFSM\functions\positions\fn_GetAVG_Distance.sqf"};
			class GetClosePosArr {file = "\vehicleFSM\functions\positions\fn_GetClosePosArr.sqf"};
			class AVGclusterPOS	 {file = "\vehicleFSM\functions\positions\fn_AVGclusterPOS.sqf"};
			class PushPositions	 {file = "\vehicleFSM\functions\positions\fn_PushPositions.sqf"};
			class FilterPushPos	 {file = "\vehicleFSM\functions\positions\fn_FilterPushPos.sqf"};
			class AssessPushPos	 {file = "\vehicleFSM\functions\positions\fn_AssessPushPos.sqf"};
			class LOS_Light		 {file = "\vehicleFSM\functions\positions\fn_LOS_Light.sqf"};
		};
								
		class repairs
		{
			class InitRepairs		 {file = "\vehicleFSM\functions\repairs\fn_InitRepairs.sqf"};
			class RepairVehicle		 {file = "\vehicleFSM\functions\repairs\fn_RepairVehicle.sqf"};
			class NeedRepairs		 {file = "\vehicleFSM\functions\repairs\fn_NeedRepairs.sqf"};
		};
								
		class startFSM
		{
			
			class AssignFlankPositions	 	 
			{file = "\vehicleFSM\functions\startFSM\fn_AssignFlankPositions.sqf"};


			class TaskManager		 {file = "\vehicleFSM\functions\startFSM\fn_TaskManager.sqf"};
			class EvadeVEh		 	 {file = "\vehicleFSM\functions\startFSM\fn_EvadeVEh.sqf"};
			class InitGroupVehicles	 {file = "\vehicleFSM\functions\startFSM\fn_InitGroupVehicles.sqf"};
			class PlayerInVeh	 	 {file = "\vehicleFSM\functions\startFSM\fn_PlayerInVeh.sqf"};
			class FlankPositions 	 {file = "\vehicleFSM\functions\startFSM\fn_FlankPositions.sqf"};
			class QuickDecision	 	 {file = "\vehicleFSM\functions\startFSM\fn_QuickDecision.sqf"};
			
			class getVehGunners	 	 {file = "\vehicleFSM\functions\startFSM\fn_getVehGunners.sqf"};
			class setVehStatus	 	 {file = "\vehicleFSM\functions\startFSM\fn_setVehStatus.sqf"};
			class fireAtEnemies	 	 {file = "\vehicleFSM\functions\startFSM\fn_fireAtEnemies.sqf"};
			class prioritizeEnemies	 {file = "\vehicleFSM\functions\startFSM\fn_prioritizeEnemies.sqf"};
			class GetUnitAtCapacity	 {file = "\vehicleFSM\functions\startFSM\fn_GetUnitAtCapacity.sqf"};
			class formatDir	 	 	 {file = "\vehicleFSM\functions\startFSM\fn_formatDir.sqf"};

			
			class HandleDecision 	 {file = "\vehicleFSM\functions\startFSM\fn_HandleDecision.sqf"};
			
		};
		
		class VehicleClassing
		{
			class GetVehicleType	{file = "\vehicleFSM\functions\VehicleClassing\fn_GetVehicleType.sqf"};
			class moddedVehicleType	{file = "\vehicleFSM\functions\VehicleClassing\fn_moddedVehicleType.sqf"};
		};

		class Waypoints
		{
			class reApplyWaypoints	 {file = "\vehicleFSM\functions\Waypoints\fn_reApplyWaypoints.sqf"};
			class ReApplyConditions	 {file = "\vehicleFSM\functions\Waypoints\fn_ReApplyConditions.sqf"};
			class GetWaypointInfo	 {file = "\vehicleFSM\functions\Waypoints\fn_GetWaypointInfo.sqf"};
			class CopyActiveWaypoints{file = "\vehicleFSM\functions\Waypoints\fn_CopyActiveWaypoints.sqf"};
			class RedoWP			 {file = "\vehicleFSM\functions\Waypoints\fn_RedoWP.sqf"};
			class DeleteWP 			 {file = "\vehicleFSM\functions\Waypoints\fn_DeleteWP.sqf"};
		};

		class vehicleMovement
		{
			class DisLodge 			 {file = "\vehicleFSM\functions\vehicleMovement\fn_DisLodge.sqf"};
			class HardMove 			 {file = "\vehicleFSM\functions\vehicleMovement\fn_HardMove.sqf"};
			class ForceMove 		 {file = "\vehicleFSM\functions\vehicleMovement\fn_ForceMove.sqf"};
			class SoftMove 			 {file = "\vehicleFSM\functions\vehicleMovement\fn_SoftMove.sqf"};
			class FacePos_And_Reverse{file = "\vehicleFSM\functions\vehicleMovement\fn_FacePos_And_Reverse.sqf"};
			class reverse	 	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_reverse.sqf"};
			class ForcedReverse	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_ForcedReverse.sqf"};
			class cmnd_Reverse	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_cmnd_Reverse.sqf"};
			class landBrake	 	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_landBrake.sqf"};
			class FacePos	 	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_FacePos.sqf"};
			class cmnd_FacePos	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_cmnd_FacePos.sqf"};
			class isFacingTargetDir	 {file = "\vehicleFSM\functions\vehicleMovement\fn_isFacingTargetDir.sqf"};
			class TurnDir	 	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_TurnDir.sqf"};
			class getOpositeTurndir	 {file = "\vehicleFSM\functions\vehicleMovement\fn_getOpositeTurndir.sqf"};
			class forceTurnStop	 	 {file = "\vehicleFSM\functions\vehicleMovement\fn_forceTurnStop.sqf"};
		};


		class simpleAreascanner
		{
			class GetNearestGridPositions
			{file = "\vehicleFSM\functions\simpleAreascanner\fn_GetNearestGridPositions.sqf"};
			class Scheduled_AreaPrescan 		
			{file = "\vehicleFSM\functions\simpleAreascanner\fn_Scheduled_AreaPrescan.sqf"};
			class scheduledGroupTasks
			{file = "\vehicleFSM\functions\simpleAreascanner\fn_scheduledGroupTasks.sqf"};
			class ClosestLocationName 		
			{file = "\vehicleFSM\functions\simpleAreascanner\fn_ClosestLocationName.sqf"};

			class SynthCoverGrid 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_SynthCoverGrid.sqf"};
			class GridArrVegetation	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_GridArrVegetation.sqf"};
			class GridArrTargetLOS 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_GridArrTargetLOS.sqf"};
			class AltitudeGridArr 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_AltitudeGridArr.sqf"};
			class CoverPosFromGrid 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_CoverPosFromGrid.sqf"};
			class AreaGrid 			 {file = "\vehicleFSM\functions\simpleAreascanner\fn_AreaGrid.sqf"};
			class ObjectifyGrid		 {file = "\vehicleFSM\functions\simpleAreascanner\fn_ObjectifyGrid.sqf"};
			class AvgGridElement 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_AvgGridElement.sqf"};
			class sumGridElement 	 {file = "\vehicleFSM\functions\simpleAreascanner\fn_sumGridElement.sqf"};
			class AreaPreScan 		 {file = "\vehicleFSM\functions\simpleAreascanner\fn_AreaPreScan.sqf"};
			class InitScan 			 {file = "\vehicleFSM\functions\simpleAreascanner\fn_InitScan.sqf"};
		};
	};
};
class Extended_PreInit_EventHandlers {
    class CbaSettingsVehFsm_init {
        init = "call compile preprocessFileLineNumbers '\vehicleFSM\CBA3den.sqf'";
    };
};