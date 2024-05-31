# Vehicle-FSM

Built by Tally On behalf of Dragon Company.

Show support by hopping into the DCO discord server and say hello!
https://discord.gg/bRTqWJzeza



Inspired by the "Smarter Tanks" mod. This FSM has been commissioned to fill a gap in AI modifications available, and represents the first in a series of modifications to greatly improve the Arma 3 AI.

Credits go to Yipman and Your Pal Deebs for overall design direction and planning, and to Tally for his incredible programming and terrifying incantations that is making our dreams come true.

This mod was developed and tested to work as best it can alongside LAMBS Danger.FSM, and the two mods compliment each other's capabilities; Danger.FSM allows vehicles to turn and face opponents while standing still, suppress buildings, and use their HE shells more effectively- It is highly recommended to combine them!


*Contact info at the bottom of this page.



PRIMARY FEATURES


This modification primarily grants vehicles the ability to assess threats when they encounter enemies: the strength of surrounding friendly units is compared to all known enemies, and the vehicle will take on one of three states!


Red status:
If the enemy strength is superior (Meaning the enemy can destroy the vehicle easily) :
Pop smoke (If FPS is decent)
The vehicle will attempt avoid or if detected - hide from the enemy.
After hiding for a while, the vehicle will re-engage based on current knowledge.

Yellow status:
If the enemy is equal in strength to the vehicle and its nearest allies.
The vehicle will work to improve its positions laterally.
Vehicle will maintain user defined minimum safe distance from the enemy.
High ground positions at 45 deg angle with minimum exposure are preferred.

Green status:
If the enemy strength is significantly weaker than the vehicle and its nearest allies.
The vehicle will aggressively push towards the last known enemy position.
Unarmed vehicles will never push (Which may help troop transports avoid suicide).

Courage:
The squad leader's courage skill matters- Vehicles with brave leaders are more willing to push against an enemy, while a cowardly one will be more likely to flank or hide when encountering enemies.
If the squad leader dies, the sum of the vehicle crew's courage will be used instead.
This works by modifying the threat assessment's end result according to the courage skill.
100% Courage doubles the percieved strength of allies, while 25% will halve it.
Courage levels below 25% significantly reduce confidence, 10% would be 1/10th.
This feature can be disabled, and a global aggressiveness setting is also available.




OTHER FEATURES:


A lightly damaged vehicle will dismount its driver in order to fix the vehicle to a working state. The gunner will remain in the vehicle during repairs.
We have also suppressed the vanilla setting that makes crews abandon immobilized vehicles- Since they can fix their damaged tracks on their own, they will stay in the fight!

If the gunner gets killed, the driver will either attempt to flee, or will jump the gun and engage targets. In the same way, if the driver is killed, the gunner or commander will enter the driving seat.

If the vehicle is grouped with another and one of the vehicles are dismounted, the dismounted units will form it's own squad in order for crewmen to run after it's lead tank.

If a vehicle gets ambushed by enemy forces close the vehicle will attempt to push through.

If the enemy is discovered in front of the vehicle, it will attempt to turn and exit while suppressing.



Enable / disable / tweak features
Go to settings in eden editor and select addon options. Then select DCO Vehicle FSM. There you may change the most important global values.
To change the individual Vehicles behaviour you can place the following lines inside the vehicles init-field:

Keep the vehicle from pushing even if it is significantly stronger than the enemy.
this setVariable ['noPush',    true, true]; 
Keep the vehicle from flanking leaving it with only the options of hiding or pushing.
this setVariable ['noFlank',   true, true]; 
Keep the vehicle from hiding making it either push or flank (unless those also have been disabeled).
this setVariable ['noHide',     true, true]; 

use all three in order to have the FSM completely disregard said vehicle.


Known issues:
Armed Light Vehicles will be unresponsive for sometime when ambushed due to vanilla pathfinding issues.
Dismounted crew sometimes doesn't create their individual groups.
A pushing vehicle will move towards the area of known enemy's exact position (not last known position).
The FSM can be slow to respond if too many vehicles simultaneously go into first contact (normally 16++).
Helicopters are seen as a risk for ground vic's, but helo's does not avoid know threats as for now.
Armor does not retreat with front armour towards the enemy.
Zeus-remote control might fail for client-zeus.


Compatibility
Vehicle FSM touches on a lot of areas in ArmA 3, so it will naturally not be compatible with every single mod out there.

Vehicles:
Modded vehicles are likely to cause errors / failures, unless we go in and actively re-write the FSM to fit said vehicles.
Vehicle.FSM has internal lists defining vehicles, because BI does not intuitively label them. If you see any notifications about a vehicle not being recognized while debug mode is on, send us the class name, and we can add it!


Compatible Vehicle mods:
CUP vehicles (added every single one we could find)
RHS vehicles (added every single one we could find)

Vehicle mods that will outright crash the FSM:
Turret Enhanced
Script Enhanced Foxhole / Fighting hole(WIP)

Any vehicle mod that we have not added will not be recognized by the FSM and as such might cause unwanted behaviour.
We have not added the creator DLC's.

Add your own modded vehicles:
You may add any modded vehicle you have by inserting them into one of the following variables (declared as arrays).

Example:
modUnarmedCarCfgs = ["MyModdedUnarmedCar_CfgName", "myUAZ__CfgName"]; 
modArmedCarCfgs = ["MyModdedArmedCar_CfgName"];
modLightArmorCfgs = ["MyModdedAPC_CfgName"];
modHeavyArmorCfgs = ["MyModdedTank_CfgName"];
modUnarmedChopperCfgs = ["MyModdedUnarmedChopper_CfgName"];
modLightChopperCfgs = ["MyModdedArmed_TransportHeli_CfgName"];
modHeavyChopperCfgs = ["MyModdedAttackChopper1_CfgName", "MyModdedAttackChopper2_CfgName"];

Contact us on Discord [discord.gg] for more info.

AI mods:

When employing another AI-mod at the same time as Vehicle FSM it will at times give conflicting orders to the AI that might lead to inaction.

Vehicle FSM has been tested with Danger.FSM and works ok...(most of the time).

If you experience a lot of issues with another AI mod one solution may be to deactivate the group-reset function (found in addon-settings in editor).

Debugging:
If you have issues with the FSM and also are using a large amount of mods at the same time, try deactivating the primary suspects.
Debug mode is available as an option in addon-settings (see tutorial video above).