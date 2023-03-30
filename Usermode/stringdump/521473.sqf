
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_prepareAO'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_prepareAO';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_EPA\Spawning\fn_prepareAO.sqf [BIS_fnc_prepareAO]"
#line 1 "A3\functions_f_EPA\Spawning\fn_prepareAO.sqf"






















BIS_PAO_patrolIndex = _this;


BIS_PAO_civilCars = [
"C_Hatchback_01_F",
"C_Hatchback_01_sport_F",
"C_Offroad_01_F",
"C_Offroad_01_RP_F",
"C_Quadbike_01_F",
"C_SUV_01_F",
"C_Tractor_01_F",
"C_Van_01_box_F",
"C_Van_01_transport_F"
];

BIS_PAO_MRAPs = [
[
"B_MRAP_01_hmg_F",
"B_MRAP_01_gmg_F"
],
[
"O_MRAP_02_hmg_F",
"O_MRAP_02_gmg_F"
],
[
"I_MRAP_03_hmg_F",
"I_MRAP_03_gmg_F"
]
];

BIS_PAO_APCs = [
[
"B_APC_Tracked_01_rcws_F",
"B_APC_Wheeled_01_cannon_F"
],
[
"O_APC_Wheeled_02_rcws_F",
"O_APC_Tracked_02_cannon_F"
],
[
"I_APC_Wheeled_03_cannon_F"
]
];

BIS_PAO_tanks = [
[
"B_MBT_01_cannon_F",
"B_APC_Tracked_01_AA_F"
],
[
"O_MBT_02_cannon_F",
"O_APC_Tracked_02_AA_F"
],
[
"I_APC_Wheeled_03_cannon_F"	
]
];

BIS_PAO_footPatrols = [
[
configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam",
configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSentry"
],
[
configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam",
configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry"
],
[
configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam",
configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry"
]
];

BIS_PAO_specialPatrols = [
[
configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AA",
configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AT",
configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_SniperTeam"
],
[
configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA",
configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT",
configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_SniperTeam"
],
[
configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam_AA",
configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam_AT",
configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_SniperTeam"
]
];

BIS_PAO_ammoBoxes = [
[
["Box_NATO_Ammo_F", 90, 0.5],
["Box_NATO_Wps_F", 0, 1.25],
["Box_NATO_Grenades_F", 90, 0.5],
["Box_NATO_WpsLaunch_F", 0, 1.3],
["Box_NATO_AmmoOrd_F", 90, 0.5],
["Box_NATO_WpsSpecial_F", 0, 1.3]
],
[
["Box_East_Ammo_F", 90, 0.5],
["Box_East_Wps_F", 0, 1.25],
["Box_East_Grenades_F", 90, 0.5],
["Box_East_WpsLaunch_F", 0, 1.3],
["Box_East_AmmoOrd_F", 90, 0.5],
["Box_East_WpsSpecial_F", 0, 1.3]
],
[
["Box_IND_Ammo_F", 90, 0.5],
["Box_IND_Wps_F", 0, 1.25],
["Box_IND_Grenades_F", 90, 0.5],
["Box_IND_WpsLaunch_F", 0, 1.3],
["Box_IND_AmmoOrd_F", 90, 0.5],
["Box_IND_WpsSpecial_F", 0, 1.3]
]
];

BIS_PAO_spawnAmmo = BIS_fnc_PAO_spawnAmmo;
BIS_PAO_corpseRemoval = BIS_fnc_PAO_corpseRemoval;

{

if (triggerText _x == "GEN_infantry") then {
_x spawn {
waitUntil {!isNil "BIS_fps_simulSteps"};
_basePos = position _this;
_rad = (triggerArea _this) select 0;
_sideIndex = ["WEST", "EAST", "GUER"] find ((triggerActivation _this) select 0);
_correctSide = [WEST, EAST, RESISTANCE] select _sideIndex;
deleteVehicle _this;
_oldFPSStep = BIS_fps_simulSteps;
while {TRUE} do {	
waitUntil {BIS_fps_simulSteps > _oldFPSStep};
if ({(_x distance _basePos) < (2000 + _rad) && ((_x distance _basePos) >= (1000 + _rad) || time < 5) && !(vehicle _x isKindOf "Air")} count units group player > 0) exitWith {};
_oldFPSStep = BIS_fps_simulSteps;
};
for [{_x = 1}, {_x <= (_rad / (125 / BIS_PAO_patrolIndex))}, {_x = _x + 1}] do {
_pos = [_basePos, random _rad, random 360] call BIS_fnc_relPos;
_newGrp = grpNull;
if (random 1 > 0.75) then {	
_newGrp = [_pos, _correctSide, (BIS_PAO_specialPatrols select _sideIndex) select floor random count BIS_PAO_specialPatrols] call BIS_fnc_spawnGroup;
} else {
_newGrp = [_pos, _correctSide, (BIS_PAO_footPatrols select _sideIndex) select floor random count BIS_PAO_footPatrols] call BIS_fnc_spawnGroup;
};
{_x call BIS_fnc_PAO_corpseRemoval} forEach units _newGrp;
[_newGrp, _rad] spawn {
_oldFPSStep = BIS_fps_simulSteps;
while {TRUE} do {	
waitUntil {BIS_fps_simulSteps > _oldFPSStep};
if ({(_x distance leader (_this select 0)) < (4000 + (_this select 1))} count units group player == 0) exitWith {};
_oldFPSStep = BIS_fps_simulSteps;
};
{deleteVehicle _x} forEach units (_this select 0);
deleteGroup (_this select 0);
BIS_fps_rescanNewObjects = TRUE;
};
if ((random 1) > 0.75) then {	
_wp = _newGrp addWaypoint [position leader _newGrp, 0];
_wp setWaypointType "GUARD";
} else {
{
_wp = _newGrp addWaypoint [_basePos, _rad];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointBehaviour "SAFE";
} forEach [1, 2, 3, 4, 5];
_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
_wp setWaypointType "CYCLE";
};
};
BIS_fps_rescanNewObjects = TRUE;
};
};


if (triggerText _x == "GEN_patrolVeh") then {
_x spawn {
waitUntil {!isNil "BIS_fps_simulSteps"};
_basePos = position _this;
_dir = (triggerArea _this) select 2;
if (_dir < 0) then {_dir = 360 + _dir};
_dir = _dir - 90;
_sideIndex = ["WEST", "EAST", "GUER"] find ((triggerActivation _this) select 0);
_correctSide = [WEST, EAST, RESISTANCE] select _sideIndex;
_vehType = (triggerStatements _this) select 1;
_wpPath = group ((synchronizedObjects _this) select 0);	
deleteVehicle ((synchronizedObjects _this) select 0);
deleteVehicle _this;
_oldFPSStep = BIS_fps_simulSteps;
while {TRUE} do {
waitUntil {BIS_fps_simulSteps > _oldFPSStep};
if ({(_x distance _basePos) < 2000} count units group player > 0) exitWith {};
_oldFPSStep = BIS_fps_simulSteps;
};
_vehClass = switch (_vehType) do {
case "car": {(BIS_PAO_MRAPs select _sideIndex) select floor random count (BIS_PAO_MRAPs select _sideIndex)};
case "apc": {(BIS_PAO_APCs select _sideIndex) select floor random count (BIS_PAO_APCs select _sideIndex)};
case "tank": {(BIS_PAO_tanks select _sideIndex) select floor random count (BIS_PAO_tanks select _sideIndex)};
default {(BIS_PAO_MRAPs select _sideIndex) select floor random count (BIS_PAO_MRAPs select _sideIndex)};
};
_veh = ([_basePos, _dir, _vehClass, _correctSide] call BIS_fnc_spawnVehicle);
{_x call BIS_fnc_PAO_corpseRemoval} forEach (_veh select 1);
(_veh select 2) copyWaypoints _wpPath;
BIS_fps_rescanNewObjects = TRUE;
};
};


if (triggerText _x == "GEN_civilCar") then {
_x spawn {
waitUntil {!isNil "BIS_fps_simulSteps"};
_basePos = position _this;
_dir = (triggerArea _this) select 2;
if (_dir < 0) then {_dir = 360 + _dir};
_dir = _dir - 90;
deleteVehicle _this;
if (random 1 >= 0.25) then {	
_oldFPSStep = BIS_fps_simulSteps;
while {TRUE} do {
waitUntil {BIS_fps_simulSteps > _oldFPSStep};
if ({(_x distance _basePos) < 2000} count units group player > 0) exitWith {};
_oldFPSStep = BIS_fps_simulSteps;
};
_veh = (BIS_PAO_civilCars select floor random count BIS_PAO_civilCars) createVehicle _basePos;
_veh setFuel random 1;
_veh setDir _dir;
_veh setVelocity [0, 0, -1];
BIS_fps_rescanNewObjects = TRUE;
};
};
};


if (triggerText _x == "GEN_ammo") then {
_x spawn {
waitUntil {!isNil "BIS_fps_simulSteps"};
_basePos = position _this;
_dir = (triggerArea _this) select 2;
if (_dir < 0) then {_dir = 360 + _dir};
_sideIndex = ["WEST", "EAST", "GUER"] find ((triggerActivation _this) select 0);
_boxPoolMin = (triggerTimeout _this) select 0; if (_boxPoolMin == 0) then {_boxPoolMin = 3};	
_boxPoolMax = (triggerTimeout _this) select 2; if (_boxPoolMax == 0) then {_boxPoolMax = 3};
_boxPool = _boxPoolMin + round random (_boxPoolMax - _boxPoolMin);
deleteVehicle _this;
_oldFPSStep = BIS_fps_simulSteps;
while {TRUE} do {
waitUntil {BIS_fps_simulSteps > _oldFPSStep};
if ({(_x distance _basePos) < 2000} count units group player > 0) exitWith {};
_oldFPSStep = BIS_fps_simulSteps;
};
_boxes = +(BIS_PAO_ammoBoxes select _sideIndex);
_boxes resize _boxPool;
[_boxes, _basePos, _dir] call BIS_fnc_PAO_spawnAmmo;
BIS_fps_rescanNewObjects = TRUE;
};
};
} forEach (allMissionObjects "EmptyDetector");


if (isNil "BIS_fps_simulSteps") then {
createCenter SideLogic;
_newGrp = createGroup SideLogic;
_simul = "ModuleSimulationManager_F" createUnit [position player, _newGrp];
};
