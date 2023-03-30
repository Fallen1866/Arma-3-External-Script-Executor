
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_WLVotingBarHandle'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_WLVotingBarHandle';
	scriptName _fnc_scriptName;

#line 1 "A3\Functions_F_Warlords\Warlords\fn_WLVotingBarHandle.sqf [BIS_fnc_WLVotingBarHandle]"
#line 1 "A3\Functions_F_Warlords\Warlords\fn_WLVotingBarHandle.sqf"








if (_this == "hide") exitWith {BIS_WL_votingBar_progress = []};

private ["_selectionTimeVarID", "_leadingSectorVarID", "_tmout", "_tmoutCur", "_barColor", "_sectorColor"];

_selectionTimeVarID = format ["BIS_WL_selectionTime_%1", side group player];
_leadingSectorVarID = format ["BIS_WL_leadingSector_%1", side group player];

_barColor = +(switch (side group player) do {
case WEST: {BIS_WL_sectorColors # 1};
case EAST: {BIS_WL_sectorColors # 0};
});
_sectorColor = [0.25, 0.25, 0.25, 1];

_tmout = BIS_WL_selectionTimeout;
_tmoutCur = (missionNamespace getVariable _selectionTimeVarID) - (call BIS_fnc_WLSyncedTime);

_barColor set [3, 1];
_sectorColor set [3, 1];

BIS_WL_votingBar_progress = [_tmoutCur, _tmout, _barColor, _sectorColor, format ["%1%3: %2", localize "STR_A3_WL_voting_hud_most_voted", (missionNamespace getVariable _leadingSectorVarID) getVariable "Name", if (toLower language == "french") then {" "} else {""}]];
