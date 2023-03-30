#line 0 "/temp/bin/A3/Functions_F/GUI/fn_showNotification.sqf"

















if (time < 1) exitwith {};

private ["_template","_args","_cfgDefault","_cfgTemplate","_cfgTitle","_cfgIconPicture","_cfgIconText","_cfgDescription","_cfgColor","_cfgDuration","_cfgPriority","_cfgDifficulty","_cfgSound","_cfgSoundClose","_cfgSoundRadio","_title","_iconPicture","_iconText","_description","_color","_duration","_priority","_difficulty","_sound","_soundClose","_soundRadio","_iconSize","_data","_difficultyEnabled"];
_template = _this param [0,"Default",[""]];
_args = _this param [1,[],[[]]];


_cfgDefault = configfile >> "CfgNotifications" >> "Default";
_cfgTemplate = [["CfgNotifications",_template],_cfgDefault] call bis_fnc_loadClass;

if (_cfgTemplate == _cfgDefault) then {["Template '%1' not found in CfgNotifications.",_template] call bis_fnc_error;};

_cfgTitle =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "title"));
_cfgIconPicture =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "iconPicture"));
_cfgIconText =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "iconText"));
_cfgDescription =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "description"));
_cfgColor =		[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "color"));
_cfgColorIconPicture =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "colorIconPicture"));
_cfgColorIconText =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "colorIconText"));
_cfgDuration =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "duration"));
_cfgPriority =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "priority"));
_cfgDifficulty =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "difficulty"));
_cfgSound =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "sound"));
_cfgSoundClose =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "soundClose"));
_cfgSoundRadio =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "soundRadio"));
_cfgIconSize =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "iconSize"));

_title =		gettext (_cfgTitle >> "title");
_iconPicture =		gettext (_cfgIconPicture >> "iconPicture");
_iconText =		gettext (_cfgIconText >> "iconText");
_description =		gettext (_cfgDescription >> "description");
_color =		(_cfgColor >> "color") call bis_fnc_colorCOnfigToRGBA;
_colorIconText =	(_cfgColorIconText >> "colorIconText") call bis_fnc_colorConfigToRGBA;
_colorIconPicture =	(_cfgColorIconPicture >> "colorIconPicture") call bis_fnc_colorConfigToRGBA;
_duration =		getnumber (_cfgDuration >> "duration");
_priority =		getnumber (_cfgPriority >> "priority");
_difficulty =		getarray (_cfgDifficulty >> "difficulty");
_sound =		gettext (_cfgSound >> "sound");
_soundClose =		gettext (_cfgSoundClose >> "soundClose");
_soundRadio =		gettext (_cfgSoundRadio >> "soundRadio");
_iconSize =		getnumber (_cfgIconSize >> "iconSize");

if !(isarray (_cfgTemplate >> "colorIconText")) then {_colorIconText = _color;};
if !(isarray (_cfgTemplate >> "colorIconPicture")) then {_colorIconPicture = _color;};

_data = [_title,_iconPicture,_iconText,_description,_color,_colorIconPicture,_colorIconText,_duration,_priority,_args,_sound,_soundClose,_soundRadio,_iconSize];


_difficultyEnabled = true;
{
	_difficultyEnabled = _difficultyEnabled && (difficultyOption _x > 0);
} foreach _difficulty;

if (_difficultyEnabled) then {
	private ["_queue","_queuePriority","_process","_processDone"];

	
	_queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
	_queue resize (_priority max (count _queue));
	if (isnil {_queue select _priority}) then {_queue set [_priority,[]];};
	_queuePriority = _queue select _priority;
	_queuePriority set [count _queuePriority,_data];
	missionnamespace setvariable ["BIS_fnc_showNotification_queue",_queue];

	
	["BIS_fnc_showNotification_counter",+1] call bis_fnc_counter;

	
	_process = missionnamespace getvariable ["BIS_fnc_showNotification_process",true];
	_processDone = if (typename _process == typename true) then {true} else {scriptdone _process};
	if (_processDone) then {
		_process = [] spawn {
			scriptname "BIS_fnc_showNotification: queue";
			_queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
			_layers = [
				("RscNotification_1" call bis_fnc_rscLayer),
				("RscNotification_2" call bis_fnc_rscLayer)
			];
			_layerID = 0;
			while {count _queue > 0} do {
				_queueID = count _queue - 1;
				_queuePriority = _queue select _queueID;
				if !(isnil {_queuePriority}) then {
					if (count _queuePriority > 0) then {
						_dataID = count _queuePriority - 1;
						_data = +(_queuePriority select _dataID);
						if (count _data > 0 && (alive player || ismultiplayer)) then {
							_duration = _data select 7;

							
							missionnamespace setvariable ["RscNotification_data",_data];
							(_layers select _layerID) cutrsc ["RscNotification","plain"];
							_layerID = (_layerID + 1) % 2;
							["BIS_fnc_showNotification_counter",-1] call bis_fnc_counter;

							sleep _duration;
							_queuePriority set [_dataID,[]];
						} else {
							_queuePriority resize _dataID;
						};
					};
					if (count _queuePriority == 0) then {
						_queue resize _queueID;
					};
				} else {
					if (_queueID == count _queue - 1) then {_queue resize _queueID;};
				};
			};
		};
		missionnamespace setvariable ["BIS_fnc_showNotification_process",_process];

		
	};
};
true
