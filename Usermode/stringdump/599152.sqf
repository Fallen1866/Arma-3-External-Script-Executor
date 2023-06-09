
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_WLInit'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_WLInit';
	scriptName _fnc_scriptName;

#line 1 "A3\Functions_F_Warlords\Warlords\fn_WLInit.sqf [BIS_fnc_WLInit]"
#line 1 "A3\Functions_F_Warlords\Warlords\fn_WLInit.sqf"








startLoadingScreen [""];
progressLoadingScreen 1;

titleCut ["", "BLACK FADED", 30];
_logic = [_this, 0, objNull, [objNull]] call BIS_fnc_param;



_logicDefaultParams = [
"StartingDaytime", 100,
"TimeAcceleration", 1,
"Progress", 1,
"FTEnabled", 1,
"ScanEnabled", 1,
"AIVoting", 0,
"ArsenalEnabled", 0,
"VotingResetEnabled", 0,
"TeamBalanceEnabled", 0,
"MarkersTransparency", 0.5,
"PlayersTransparency", 0.5,
"FatigueEnabled", 1,
"Music", 1,
"Voice", 1,
"StartCP", 500,
"CPMultiplier", 1,
"MaxCP", -1,
"VotingTimeout", 15,
"VehicleSpan", 3600,
"FactionBLUFOR", "BLU_F",
"FactionOPFOR", "OPF_F",
"FactionIndep", "IND_F",
"AssetList", ["A3DefaultAll"],
"MaxSubordinates", 9,
"ScanCooldown", 0,
"MissionEnd", 0,
"DebriefingWinBLUFOR", "BIS_WLVictoryWEST",
"DebriefingFailBLUFOR", "BIS_WLDefeatWEST",
"DebriefingWinOPFOR", "BIS_WLVictoryEAST",
"DebriefingFailOPFOR", "BIS_WLDefeatEAST"
];

_missionParams = "TRUE" configClasses (missionConfigFile >> "Params");
_useMissionParams = FALSE;
if (isMultiplayer && count _missionParams > 0) then {_useMissionParams = TRUE};

{
if (_forEachIndex % 2 == 0) then {
if (isNil {_logic getVariable _x}) then {
_logic setVariable [_x, _logicDefaultParams # ((_logicDefaultParams find _x) + 1)];
};
if (_useMissionParams) then {
_i = _missionParams find (missionConfigFile >> "Params" >> format ["BIS_WL%1", _x]);
if (_i >= 0) then {
_logic setVariable [_x, paramsArray # _i];
};
};
};
} forEach _logicDefaultParams;

if (isServer) then {
if ((_logic getVariable "StartingDaytime") < 100) then {
skipTime (-dayTime + 12 + (_logic getVariable "StartingDaytime"));
};
{createCenter _x} forEach [EAST, WEST, RESISTANCE, CIVILIAN];
BIS_WL_recentStart = TRUE; publicVariable "BIS_WL_recentStart";
addMissionEventHandler ["HandleDisconnect", {
BIS_WL_trackerTick = TRUE;
params ["_unit", "_id", "_uid", "_name"];
if (count weapons _unit == 0) then {
forceRespawn _unit;
};
removeAllOwnedMines _unit;
if (!isNull (_unit getVariable ["BIS_WL_selectedSector", objNull])) then {
if (side group _unit == WEST) then {
BIS_WL_disconnectedVotes_WEST pushBack (_unit getVariable ["BIS_WL_selectedSector", objNull]);
publicVariable "BIS_WL_disconnectedVotes_WEST";
} else {
BIS_WL_disconnectedVotes_EAST pushBack (_unit getVariable ["BIS_WL_selectedSector", objNull]);
publicVariable "BIS_WL_disconnectedVotes_EAST";
};
};
}];
[] spawn {
sleep 120;
BIS_WL_recentStart = FALSE; publicVariable "BIS_WL_recentStart";
};
setTimeMultiplier (_logic getVariable "TimeAcceleration");
};

WEST setFriend [EAST, 0];
EAST setFriend [WEST, 0];
RESISTANCE setFriend [WEST, 0];
WEST setFriend [RESISTANCE, 0];
RESISTANCE setFriend [EAST, 0];
EAST setFriend [RESISTANCE, 0];

if !(isDedicated) then {
waitUntil {!isNull player && isPlayer player && ((side group player) in [WEST, EAST])};
};

_logic call BIS_fnc_WLVarsInit;



if (isServer) then {
BIS_WL_sectors = call BIS_fnc_WLsectorsSetup;
publicVariable "BIS_WL_sectors";
{
_x setVariable ["BIS_WL_selectedSector", objNull];
if !(isPlayer _x) then {
_x setVariable ["BIS_WL_funds", BIS_WL_startCP, TRUE];
_x setVariable ["BIS_WL_funds_backup", BIS_WL_startCP];
_x addEventHandler ["HandleRating", {
if ((_this # 1) > 100) then {
(_this # 0) setVariable ["BIS_WL_funds", (((_this # 0) getVariable "BIS_WL_funds") + ((_this # 1) / 20)) min BIS_WL_maxCP, TRUE];
["Kill reward: %1 (%2)", name (_this # 0), (_this # 1) / 20] call BIS_fnc_WLdebug;
};
}];
};
_x setVariable ["BIS_WL_AIHandle", _x call BIS_fnc_WLAICore];
(group _x) setVariable ["BIS_WL_groupVehs", [], TRUE];
_x addEventHandler ["Respawn", {(_this # 0) setVariable ["BIS_WL_AIHandle", (_this # 0) call BIS_fnc_WLAICore];}];
_x allowFleeing 0;
if !(isNil {_x getVariable "BIS_WL_requisitionPreset"}) then {
_x call BIS_fnc_WLParseAssetList;
};
_x spawn BIS_WL_spawnProtectionCode;
} forEach BIS_WL_allWarlords;
{_x call BIS_fnc_WLsectorHandleServer} forEach [BIS_WL_base_WEST, BIS_WL_base_EAST];
{_x call BIS_fnc_WLsectorSelectionHandleServer} forEach [EAST, WEST];
{_x call BIS_fnc_WLsectorFundsPayoff} forEach [EAST, WEST];
_null = [] spawn BIS_fnc_WLPlayersTrackingServer;
_null = [] spawn {
scriptName "WLInit (buried deletion)";
while {TRUE} do {
sleep 120;
{if (abs ((getPosATL _x) # 2) > 0.5 && !isPlayer _x) then {["Deleting buried unit %1 (%2)", _x, typeOf _x] call BIS_fnc_WLdebug; deleteVehicle _x}} forEach allDeadMen;
_holders = ((allMissionObjects "WeaponHolderSimulated") + (allMissionObjects "WeaponHolder")) select {count (_x nearObjects ["Man", 10]) == 0};
["Deleting %1 weapon holders", count _holders] call BIS_fnc_WLdebug;
{deleteVehicle _x} forEach _holders;
};
};
addMissionEventHandler ["EntityKilled", {
_limit = 3;
params ["_killed", "_killer", "_instigator"];
if (isNull _instigator) then {_instigator = _killer};
if (isPlayer _killed) then {
if (isPlayer _instigator) then {
if (side group _instigator == side group _killed && _instigator != _killed) then {
diag_log format ["WL kill log: [FF] %1 (%2) killed by %3 (%4) at %5 from %6 (%7m)", name _killed, getPlayerUID _killed, name _instigator, getPlayerUID _instigator, position _killed, position _instigator, _killed distance2D _instigator];
} else {
diag_log format ["WL kill log: %1 (%2) killed by %3 (%4) at %5", name _killed, getPlayerUID _killed, name _instigator, getPlayerUID _instigator, position _killed];
};
} else {
if !(isNull _instigator) then {
diag_log format ["WL kill log: %1 (%2) killed by AI at %3", name _killed, getPlayerUID _killed, position _killed];
} else {
diag_log format ["WL kill log: %1 (%2), killer unknown at %3", name _killed, getPlayerUID _killed, position _killed];
};
};

[] spawn {
sleep 1;
_poolToLog = [];
{
_id = _x;
if (typeName _id == typeName "") then {
_arr = BIS_WL_friendlyFirePunishPool select (_forEachIndex + 1);
if (typeName _arr == typeName []) then {
if (count _arr > 0) then {
_poolToLog append [_id, _arr];
};
};
};
} forEach BIS_WL_friendlyFirePunishPool;

diag_log format ["WL FF pool :: %1", _poolToLog];
};
};
if (_killed != _instigator && isPlayer _instigator && side group _killed == side group _instigator && group _killed != group _instigator && isPlayer leader group _killed) then {
_uid = getPlayerUID _instigator;
if (_uid != "") then {
_varID = format ["BIS_WL_friendlyKills_%1", _uid];
_friendlyKills = missionNamespace getVariable [_varID, 0];
if (isPlayer _killed) then {
_friendlyKills = _friendlyKills + 1;
} else {
_friendlyKills = _friendlyKills + 0.5;
};
missionNamespace setVariable [_varID, _friendlyKills];
if (_friendlyKills >= _limit) then {
missionNamespace setVariable [_varID, 0];
_arrID = BIS_WL_friendlyFirePunishPool find _uid;
if (_arrID >= 0) then {
_punishments = BIS_WL_friendlyFirePunishPool select (_arrID + 1);
if (typeName _punishments == typeName []) then {
if (count _punishments > 0) then {
_lastPunishment = _punishments select ((count _punishments) - 1);
if (_lastPunishment + BIS_WL_punishmentDuration < (call BIS_fnc_WLSyncedTime)) then {
_punishments pushBack (call BIS_fnc_WLSyncedTime);
BIS_WL_friendlyFirePunishPool set [_arrID + 1, _punishments];
};
} else {
_punishments pushBack (call BIS_fnc_WLSyncedTime);
BIS_WL_friendlyFirePunishPool set [_arrID + 1, _punishments];
};
};
} else {
BIS_WL_friendlyFirePunishPool append [_uid, [(call BIS_fnc_WLSyncedTime)]];
};
};
};
};
}];
_null = [] spawn {
scriptName "WLInit (friendly fire loop)";
while {TRUE} do {
{
_uid = getPlayerUID _x;
if ((_x getVariable ["BIS_WL_friendlyFirePunishmentEnd", 0]) == 0) then {
_arrID = BIS_WL_friendlyFirePunishPool find _uid;
if (_arrID >= 0) then {
_punishments = BIS_WL_friendlyFirePunishPool select (_arrID + 1);
if (typeName _punishments == typeName []) then {
if (count _punishments > 0) then {
_lastPunishment = _punishments select ((count _punishments) - 1);
_duration = BIS_WL_punishmentDuration + (30 * (((count _punishments) - 1) min 8));
if ((call BIS_fnc_WLSyncedTime) < (_lastPunishment + _duration)) then {
_x setVariable ["BIS_WL_friendlyFirePunishmentEnd", _lastPunishment + _duration, TRUE];
diag_log format ["WL FF punishment log: %1 (%2) :: %3 sec", name _x, _uid, _duration];
[_duration, _x] spawn {
sleep (_this # 0);
(_this # 1) setVariable ["BIS_WL_friendlyFirePunishmentEnd", 0];
};
} else {
_x setVariable ["BIS_WL_friendlyFirePunishmentEnd", 0, TRUE];
};
{
if (_x < ((call BIS_fnc_WLSyncedTime) - 1800)) then {_punishments = _punishments - [_x]};
} forEach _punishments;
BIS_WL_friendlyFirePunishPool set [_arrID + 1, _punishments];
};
};
};
};
} forEach (BIS_WL_allWarlords select {isPlayer _x});
sleep 1;
};
};
[] spawn {
while {TRUE} do {
sleep 60;
{
_class = _x;
_litter = (allMissionObjects _class) select {!(_x getVariable ["BIS_WL_litterTracked", FALSE])};
{
_x setVariable ["BIS_WL_litterTracked", TRUE];
_x spawn {
waitUntil {sleep 5; (position _this) select 2 < 1};
sleep 5;
deleteVehicle _this;
};
} forEach _litter;

} forEach ["Plane_Canopy_Base_F", "Ejection_Seat_Base_F"];
};
};
[] spawn {
while {TRUE} do {
sleep 30;
{
if (_forEachIndex % 2 == 1) then {
_playerID = BIS_WL_friendlyFirePunishPool select (_forEachIndex - 1);
_punishments = _x;
if (typeName _punishments == typeName []) then {
{
if (_x < ((call BIS_fnc_WLSyncedTime) - 1800)) then {_punishments = _punishments - [_x]};
} forEach _punishments;
BIS_WL_friendlyFirePunishPool set [_forEachIndex, _punishments];
};



};
} forEach BIS_WL_friendlyFirePunishPool;

};
};
if (isMultiplayer && BIS_WLTeamBalanceEnabled == 1) then {
[] spawn {
sleep 0.01;
_maxDifference = 3;
while {TRUE} do {
_warlordsToSwitch = [];
_diff = -1;
_westWarlordsLobby = playersNumber WEST;
_westSlots = playableSlotsNumber WEST;
_freeSlotsWest = _westSlots - _westWarlordsLobby;
_eastWarlordsLobby = playersNumber EAST;
_eastSlots = playableSlotsNumber EAST;
_freeSlotsEast = _eastSlots - _eastWarlordsLobby;
_westWarlords = BIS_WL_allWarlords select {side group _x == WEST};
_warlordsToSwitchHandledWest = _westWarlords select {_x getVariable ["BIS_WL_toSwitchSides", FALSE]};
_warlordsToSwitchHandledWestCnt = count _warlordsToSwitchHandledWest;
_westWarlordsCnt = count _westWarlords;
_eastWarlords = BIS_WL_allWarlords select {side group _x == EAST};
_warlordsToSwitchHandledEast = _eastWarlords select {_x getVariable ["BIS_WL_toSwitchSides", FALSE]};
_warlordsToSwitchHandledEastCnt = count _warlordsToSwitchHandledEast;
_eastWarlordsCnt = count _eastWarlords;
if (_westWarlordsCnt > (_eastWarlordsCnt + _maxDifference) && _freeSlotsEast > 0) then {
_diff = (_westWarlordsCnt - _eastWarlordsCnt - _maxDifference - _warlordsToSwitchHandledWestCnt) min _freeSlotsEast;
if (_diff > 0) then {
_warlordsToSwitch = _westWarlords - _warlordsToSwitchHandledWest;
};
} else {
{
_x setVariable ["BIS_WL_toSwitchSides", FALSE, TRUE];
} forEach _warlordsToSwitchHandledWest;
if (_eastWarlordsCnt > (_westWarlordsCnt + _maxDifference) && _freeSlotsWest > 0) then {
_diff = (_eastWarlordsCnt - _westWarlordsCnt - _maxDifference - _warlordsToSwitchHandledEastCnt) min _freeSlotsWest;
if (_diff > 0) then {
_warlordsToSwitch = _eastWarlords - _warlordsToSwitchHandledEast;
};
} else {
{
_x setVariable ["BIS_WL_toSwitchSides", FALSE, TRUE];
} forEach _warlordsToSwitchHandledEast;
}
};
if (count _warlordsToSwitch > 0) then {
_warlordsToSwitch = _warlordsToSwitch select {(_x getVariable ["BIS_WL_connectedAt", 10e10]) > ((call BIS_fnc_WLSyncedTime) - 20)};
_warlordsToSwitch = _warlordsToSwitch apply {[_x getVariable ["BIS_WL_connectedAt", 10e10], _x]};
_warlordsToSwitch sort FALSE;
if (_diff < count _warlordsToSwitch) then {
_warlordsToSwitch resize _diff;
};
_warlordsToSwitch = _warlordsToSwitch apply {_x select 1};
{
_x setVariable ["BIS_WL_toSwitchSides", TRUE, TRUE];
} forEach _warlordsToSwitch;
};
sleep 1;
};
};
};

[] spawn {
while {TRUE} do {
sleep 300;
_allDead = +(allDead select {!(_x isKindOf "Logic")});
_allDeadMen = +(allDeadMen select {!(_x isKindOf "Logic")});
_allSAMsWest = allMissionObjects "b_sam_system_03_f";
_allSAMsEast = allMissionObjects "o_sam_system_04_f";
_SAMsLogAlive = [];
{
_SAMsLogAlive pushBack [if (toLower typeOf _x == "b_sam_system_03_f") then {WEST} else {EAST}, position _x];
} forEach ((_allSAMsWest + _allSAMsEast) select {alive _x});
_SAMsLogDead = [];
{
_SAMsLogDead pushBack [if (toLower typeOf _x == "b_sam_system_03_f") then {WEST} else {EAST}, position _x];
} forEach ((_allSAMsWest + _allSAMsEast) select {!alive _x});
diag_log format ["WL garbage log: Units: %1", count _allDeadMen];
diag_log format ["WL garbage log: Vehicles: %1", count (_allDead - _allDeadMen)];
diag_log format ["WL SAM log: ALIVE: %1 :: %2", count _SAMsLogAlive, _SAMsLogAlive];
diag_log format ["WL SAM log: DEAD: %1 :: %2", count _SAMsLogDead, _SAMsLogDead];
};
};

[] spawn {
while {TRUE} do {
sleep 30;
_vehiclesBelowGround = vehicles select {_pos = getPosATL _x; _depth = _pos # 2; _depth < -0.7 || (_depth < -0.55 && surfaceIsWater _pos)};
_vehiclesBelowGroundCnt = count _vehiclesBelowGround;
{
_x spawn {
_veh = _this;
sleep 2;
if (!isNull _veh) then {
_pos = getPosATL _veh;
_depth = _pos # 2;
if (_depth < -0.7 || (_depth < -0.55 && surfaceIsWater _pos)) then {
{
if (!isNull _x) then {
_x setPos position _veh;
_grp = group _x;
if (isPlayer _x) then {_x setDamage 1} else {deleteVehicle _x};
if (count units _grp == 0) then {deleteGroup _grp};
}
} forEach crew _x;
deleteVehicle _veh;
}
}
}
} forEach _vehiclesBelowGround;
};
};

[] spawn {
while {TRUE} do {
sleep 2;
{
if (!isNil {_x getVariable "BIS_WL_funds"}) then {_x setVariable ["BIS_WL_funds_backup", _x getVariable "BIS_WL_funds"]};
if (!isNil {_x getVariable "BIS_WL_funds_backup"} && isNil {_x getVariable "BIS_WL_funds"}) then {_x setVariable ["BIS_WL_funds", _x getVariable "BIS_WL_funds_backup", TRUE]};
} forEach BIS_WL_allWarlords;
};
};

[] spawn {
while {TRUE} do {
sleep 2;
{
if (!(_x getVariable ["BIS_WL_damageAllowed", TRUE]) && (call BIS_fnc_WLSyncedTime) > (_x getVariable ["BIS_WL_spawnProtectionEnd", 0])) then {
_x setVariable ["BIS_WL_damageAllowed", TRUE, TRUE];
[_x, TRUE] remoteExec ["allowDamage", _x];
["Damage enabled for %1 (%2)", _x, name _x] call BIS_fnc_WLdebug;
};
} forEach BIS_WL_allWarlords;
};
};
};

waitUntil {!isNil "BIS_WL_sectors" && !isNil "BIS_WL_scenarioServices"};

{_x call BIS_fnc_WLParseAssetList} forEach [WEST, EAST];

call BIS_fnc_WLUpdateAO;

if !(isDedicated) then {
[] spawn BIS_fnc_WLClientInit;
if !(isNil {player getVariable "BIS_WL_requisitionPreset"}) then {
player call BIS_fnc_WLParseAssetList;
} else {
player setVariable ["BIS_WL_purchasable", missionNamespace getVariable format ["BIS_WL_purchasable%1", side group player]];
};
} else {
BIS_WL_sectorsArrayWEST = [WEST] call BIS_fnc_WLSectorListing;
BIS_WL_sectorsArrayEAST = [EAST] call BIS_fnc_WLSectorListing;
endLoadingScreen;
};



if (isServer) then {
{
if (isNil {_x getVariable "BIS_WL_purchasable"}) then {
_x setVariable ["BIS_WL_purchasable", missionNamespace getVariable format ["BIS_WL_purchasable%1", side group _x]];
}
} forEach BIS_WL_allWarlords;
{
_side = _x;
_base = missionNamespace getVariable format ["BIS_WL_base_%1", _side];
for [{_i = 0}, {_i < 1}, {_i = _i + 1}] do {
_postfix = "_%2"; if (_i == 0) then {_postfix = ""};
_mrkrName = format ["respawn_%1" + _postfix, _side, _i];
if ((markerType _mrkrName) == "") then {
_mrkr = createMarker [_mrkrName, (position _base) vectorAdd [-5 + random 10, -5 + random 10, 0]];
_mrkrName setMarkerType "Empty";
} else {
_mrkrName setMarkerPos ((position _base) vectorAdd [-5 + random 10, -5 + random 10, 0]);
};
};
} forEach [EAST, WEST];
};



if ((_logic getVariable "MissionEnd") > 0) then {
_null = _logic spawn {
scriptName "WLInit (ending condition)";
waitUntil {(BIS_WL_base_WEST getVariable "BIS_WL_sectorSide") != WEST || (BIS_WL_base_EAST getVariable "BIS_WL_sectorSide") != EAST};

if (isDedicated) exitWith {endMission "End1"};

_endWinBLUFOR = "BIS_WLVictoryWEST"; if ((_this getVariable "DebriefingWinBLUFOR") != "") then {_endWinBLUFOR = _this getVariable "DebriefingWinBLUFOR"};
_endWinOPFOR = "BIS_WLVictoryEAST"; if ((_this getVariable "DebriefingWinOPFOR") != "") then {_endWinOPFOR = _this getVariable "DebriefingWinOPFOR"};
_endDefeatBLUFOR = "BIS_WLDefeatWEST"; if ((_this getVariable "DebriefingFailBLUFOR") != "") then {_endDefeatBLUFOR = _this getVariable "DebriefingFailBLUFOR"};
_endDefeatOPFOR = "BIS_WLDefeatEAST"; if ((_this getVariable "DebriefingFailOPFOR") != "") then {_endDefeatOPFOR = _this getVariable "DebriefingFailOPFOR"};

if ((BIS_WL_base_WEST getVariable "BIS_WL_sectorSide") != WEST) then {
playMusic "";
0 fadeMusic 1;
if (side group player == EAST) then {
_endWinOPFOR call BIS_fnc_endMission;
"Victory" call BIS_fnc_WLSoundMsg;
[BIS_WL_base_WEST, "seize", "succeed"] call BIS_fnc_WLSectorTaskHandle;
[BIS_WL_base_EAST, "defend", "succeed"] call BIS_fnc_WLSectorTaskHandle;
} else {
[_endDefeatBLUFOR, FALSE] call BIS_fnc_endMission;
"Defeat" call BIS_fnc_WLSoundMsg;
[BIS_WL_base_EAST, "seize", "fail"] call BIS_fnc_WLSectorTaskHandle;
[BIS_WL_base_WEST, "defend", "fail"] call BIS_fnc_WLSectorTaskHandle;
};
} else {
if (side group player == WEST) then {
_endWinBLUFOR call BIS_fnc_endMission;
"Victory" call BIS_fnc_WLSoundMsg;
[BIS_WL_base_EAST, "seize", "succeed"] call BIS_fnc_WLSectorTaskHandle;
[BIS_WL_base_WEST, "defend", "succeed"] call BIS_fnc_WLSectorTaskHandle;
} else {
[_endDefeatOPFOR, FALSE] call BIS_fnc_endMission;
"Defeat" call BIS_fnc_WLSoundMsg;
[BIS_WL_base_WEST, "seize", "fail"] call BIS_fnc_WLSectorTaskHandle;
[BIS_WL_base_EAST, "defend", "fail"] call BIS_fnc_WLSectorTaskHandle;
};
};
};
};
