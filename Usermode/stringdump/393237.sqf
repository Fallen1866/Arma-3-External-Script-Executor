#line 0 "/temp/bin/A3/Functions_F/Respawn/fn_showRespawnMenuPosition.sqf"
private ["_list","_respawnPositions","_addPositions","_deletePositions","_respawnPositionsNew","_fnc_refreshLoop"];

_respawnTemplates = getMissionConfigValue "respawnTemplates";
_sideTemplates = getMissionConfigValue ("respawnTemplates" + str (side group player));	
if ((!isNil "_sideTemplates") && {(count _sideTemplates) > 0}) then {_respawnTemplates = _sideTemplates};
if ((isNil "_respawnTemplates") || {(typeName []) != (typeName _respawnTemplates)}) then {_respawnTemplates = []}; 

disableSerialization;
if ("MenuPosition" in _respawnTemplates) then {	
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocList} else {BIS_RscRespawnControlsMap_ctrlLocList};
	lbClear _list;		
	BIS_RscRespawnControls_posMetadata = [];
	
	
	_respawnPositions = (player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers);
	if ((leader group player) == player) then {
		_respawnPositions = _respawnPositions - [player,group player];	
	} else {
		_respawnPositions = _respawnPositions - [player];	
	};
	[true,_list,_respawnPositions] call BIS_fnc_showRespawnMenuPositionList;
	_lastSel = (BIS_RscRespawnControls_selected select 0);
	_list lbSetCurSel (if (_lastSel >= 0) then {_lastSel} else {0});	
	
	[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;	
	
	
	_fnc_refreshLoop = {
		
		_respawnPositionsNew = (player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers);
		if !(_respawnPositions isEqualTo _respawnPositionsNew) then {	
			_addPositions = _respawnPositionsNew - _respawnPositions;
			_deletePositions = _respawnPositions - _respawnPositionsNew;
			
			if ((count _addPositions) > 0) then {[true,_list,_addPositions] call BIS_fnc_showRespawnMenuPositionList};
			if ((count _deletePositions) > 0) then {[false,_list,_deletePositions] call BIS_fnc_showRespawnMenuPositionList};
			_respawnPositions = _respawnPositionsNew;
		};
		
		
		[_list] call BIS_fnc_showRespawnMenuPositionRefresh;
	};
	
	
	if (missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]) then {		
		while {missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 1;
		};
	} else {										
		while {missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 1;
		};
	};
} else {
	
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocList} else {BIS_RscRespawnControlsMap_ctrlLocList};
	_locDisabled = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocDisabled} else {BIS_RscRespawnControlsMap_ctrlLocDisabled};
	
	lbClear _list;		
	
	_locDisabled ctrlEnable true;
	_locDisabled ctrlSetFade 0;
	_locDisabled ctrlCommit 0;
};
