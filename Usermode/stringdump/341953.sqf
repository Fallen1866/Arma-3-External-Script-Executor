
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_EXP_camp_lobby_playMissionVideo'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_EXP_camp_lobby_playMissionVideo';
	scriptName _fnc_scriptName;

#line 1 "a3\missions_f_exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf [BIS_fnc_EXP_camp_lobby_playMissionVideo]"
#line 1 "a3\missions_f_exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf"




















disableSerialization;
#line 1 "A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"














































































































































































































































































































































































































































































































#line 5 "a3\missions_f_exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf"



private _missionImage					= _this select 0;
private _missionOverlayImage			= _this select 1;
private _missionIndex					= _this select 2;


private _display						= findDisplay 								50000;
private _ctrlMissionGroup				= _display displayCtrl 				54300;
private _ctrlVideoGroup					= _display displayCtrl 			54400;


private _overlayGroup					= _display displayCtrl 		54600;
private _overlayTop						= _display displayCtrl (		54600 + 1);
private _overlayBottom					= _display displayCtrl (		54600 + 2);
private _overlayLeft					= _display displayCtrl (		54600 + 3);
private _overlayRight					= _display displayCtrl (		54600 + 4);
private _overlayComplete				= _display displayCtrl (		54600 + 5);


private _selectedMissionOptionCtrls 	= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTION_SELECTED";
private _selectedMissionOptionGroup		= controlNull;
private _selectedMissionOptionLine		= controlNull;
private _selectedMissionOptionText		= controlNull;
private _selectedMissionOptionIcon		= controlNull;
private _selectedMissionOptionButton	= controlNull;

if !(isNil { _selectedMissionOptionCtrls }) then
{
_selectedMissionOptionGroup			= _selectedMissionOptionCtrls select 0;
_selectedMissionOptionLine			= _selectedMissionOptionCtrls select 1;
_selectedMissionOptionText			= _selectedMissionOptionCtrls select 2;
_selectedMissionOptionIcon			= _selectedMissionOptionCtrls select 3;
_selectedMissionOptionButton		= _selectedMissionOptionCtrls select 4;
};


private _ctrlTreeOptionGroup			= _display displayCtrl (	53400);


private _xPos							= 0;
private _yPos							= 0;
private _wPos							= ctrlPosition _ctrlVideoGroup select 2;
private _hPos							= ctrlPosition _ctrlVideoGroup select 3;


private _ctrlVideo						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
private _ctrlOverlay					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
private _currentMissionIndex			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
private _inProgress						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

if !(isNil { _ctrlVideo }) then
{
ctrlDelete _ctrlVideo;
ctrlDelete _ctrlOverlay;
};


_ctrlVideo		=
_display ctrlCreate
[
"RscVideo",
(			54400 + 2),
_ctrlVideoGroup
];


_ctrlVideo ctrlSetPosition
[
0,
0,
_wPos,
_hPos
];


_ctrlVideo ctrlSetText _missionImage;
_ctrlVideo ctrlCommit 0;


ctrlDelete _ctrlVideo;


_ctrlVideo		=
_display ctrlCreate
[
"RscVideo",
(			54400 + 2),
_ctrlVideoGroup
];


_ctrlVideo ctrlSetPosition
[
0,
0,
_wPos,
_hPos
];


_ctrlVideo ctrlSetText _missionImage;
_ctrlVideo ctrlCommit 0;


_ctrlOverlay	=
_display ctrlCreate
[
"RscVideo",
(			54400 + 4),
_ctrlVideoGroup
];


_ctrlOverlay ctrlSetPosition
[
0,
0,
_wPos,
_hPos
];


_ctrlOverlay ctrlCommit 0;


uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO",[_ctrlVideo, _ctrlOverlay, _missionIndex, true]];


_nul = [_ctrlVideo, _ctrlOverlay, _missionIndex, _missionImage, _missionOverlayImage] spawn
{
disableSerialization;

private _tempCtrlVideo				= _this select 0;
private _tempCtrlOverlay			= _this select 1;
private _tempMissionIndex			= _this select 2;
private _tempMissionImage			= _this select 3;
private _tempMissionOverlayImage	= _this select 4;


_tempCtrlOverlay ctrlSetText _tempMissionOverlayImage;
_tempCtrlOverlay ctrlCommit 0;


private _ctrlVideo						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
private _ctrlOverlay					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
private _currentMissionIndex			= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
private _inProgress						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

if (isNil { _ctrlVideo })				exitWith {};
if (isNil { _ctrlOverlay })				exitWith {};
if (isNil { _currentMissionIndex }) 	exitWith {};
if (isNil { _inProgress })				exitWith {};


if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};


uiSleep 0.25;


_ctrlVideo								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
_ctrlOverlay							= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
_currentMissionIndex					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
_inProgress								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

if (isNil { _ctrlVideo })				exitWith {};
if (isNil { _ctrlOverlay })				exitWith {};
if (isNil { _currentMissionIndex }) 	exitWith {};
if (isNil { _inProgress })				exitWith {};


if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};


_tempCtrlOverlay ctrlSetFade 1;
_tempCtrlOverlay ctrlCommit 0.5;


_tempCtrlVideo ctrlAddEventHandler
[
"VideoStopped",
format
["['%1'] execVM ""\A3\Missions_F_Exp\Lobby\functions\fn_EXP_camp_lobby_playMissionVideo.sqf"";", _tempMissionImage]
];


uiSleep 0.5;

_ctrlVideo								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 0;
_ctrlOverlay							= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 1;
_currentMissionIndex					= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 2;
_inProgress								= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_VIDEO" select 3;

if (isNil { _ctrlVideo })				exitWith {};
if (isNil { _ctrlOverlay })				exitWith {};
if (isNil { _currentMissionIndex }) 	exitWith {};
if (isNil { _inProgress })				exitWith {};


if ((_tempMissionIndex != _currentMissionIndex) || (!_inProgress)) exitWith {};


uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO",[_tempCtrlVideo, _tempCtrlOverlay, _tempMissionIndex, false]];
};


