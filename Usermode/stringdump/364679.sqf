#line 0 "/temp/bin/A3/Functions_F/Respawn/fn_respawnNone.sqf"













private ["_soundvolume","_musicvolume"];



disableserialization;
_player = _this select 0;
_killer = _this select 1;
if (isnull _killer) then {_killer = _player};

_musicvolume = musicvolume;
_soundvolume = soundvolume; 

_start = isnil "bis_fnc_respawnNone_start";
if (_start) then {
	bis_fnc_respawnNone_start = [daytime,time / 3600];

	

	sleep 2;
	if (alive player) exitwith {};
	cutText ["","BLACK OUT",1];
	sleep 1.5;
        BIS_fnc_feedback_allowPP = false; 
	

	if (ismultiplayer) then {(finddisplay 46) createdisplay "RscDisplayMissionEnd";} else {enableenddialog};
};
if (alive player) exitwith {cuttext ["","plain"];}; 

waituntil {!isnull (finddisplay 58)};
_display = finddisplay 58;


_n = 1060;
(_display displayctrl _n) ctrlsetfade 1;
if (_start) then {

	
	setacctime 1;
	0 fademusic 0;
	4 fademusic 0.8;
	playmusic format ['RadioAmbient%1',ceil random 1];
	_musicEH = addMusicEventHandler ["MusicStop",{[] spawn {playmusic format ['RadioAmbient%1',ceil random 1];};}];
	uinamespace setvariable ["bis_fnc_respawnNone_musicEH",_musicEH];
	_display displayaddeventhandler ["unload","removeMusicEventHandler ['MusicStop',uinamespace getvariable ['bis_fnc_respawnNone_musicEH',-1]];"];

	(_display displayctrl _n) ctrlcommit 4;
} else {
	(_display displayctrl _n) ctrlcommit 0;
};
cuttext ["","plain"];


_n = 5800;
(_display displayctrl _n) ctrlsettext gettext (configfile >> "cfgingameui" >> "cursor" >> "select");
(_display displayctrl _n) ctrlsetposition [-10,-10,safezoneH * 0.07 * 3/4,safezoneH * 0.07];
(_display displayctrl _n) ctrlsettextcolor [1,1,1,1];
(_display displayctrl _n) ctrlcommit 0;


_sitrep = "SITREP||";
if (name _player != "Error: No unit") then {
	_sitrep = _sitrep + "KIA: %4. %5|";
};
_sitrep = _sitrep + "TOD: %2 [%3]|LOC: %6 \ %7";

private _vehicleKiller = vehicle _killer;
private _weaponKiller = currentweapon _killer;

if (_killer != _player) then {
	_sitrep = _sitrep + "||ENY: %8";
	if(_vehicleKiller != _killer)then
	{
		{
			if((_vehicleKiller turretUnit _x) isEqualTo _killer)exitWith{_weaponKiller = _vehicleKiller currentWeaponTurret _x};
		}foreach ([[-1]] + allTurrets _vehicleKiller);
	};
	if (_weaponKiller != "") then {
		_sitrep = _sitrep + "|ENW: %9</t>"
	};
};
_sitrep = format [
	_sitrep,
	1 * safezoneH,
	[bis_fnc_respawnNone_start select 0,"HH:MM:SS"] call bis_fnc_timetostring,
	[bis_fnc_respawnNone_start select 1,"HH:MM:SS"] call bis_fnc_timetostring,
	toupper localize format ["STR_SHORT_%1",rank _player],
	toupper name _player,
	mapGridPosition _player,
	toupper gettext (configfile >> "CfgWorlds" >> worldname >> "description"),
	toupper ((configfile >> "cfgvehicles" >> typeof _vehicleKiller) call bis_fnc_displayname),
	toupper ((configfile >> "cfgweapons" >> _weaponKiller) call bis_fnc_displayname)

];

_n = 11000;
_bcgPos = ctrlposition (_display displayctrl _n);
_n = 5858;

(_display displayctrl _n) ctrlsetposition [(((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX),
			 ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY),
			 safezoneW - 2 * (_bcgPos select 2),
			 safezoneH / 2];
(_display displayctrl _n) ctrlcommit 0;
[(_display displayctrl _n),_sitrep] spawn {
	scriptname "bis_fnc_respawnNone: SITREP";
	disableserialization;
	_control = _this select 0;
	_sitrepArray = toarray (_this select 1);
	{_sitrepArray set [_foreachindex,tostring [_x]]} foreach _sitrepArray;
	_sitrep = "";
	
	_sitrepFormat = "<t align='left' font='EtelkaMonospacePro' shadow='1'>%1</t>";

	sleep 1;
	for "_i" from 0 to (count _sitrepArray - 1) do {
		_letter = _sitrepArray select _i;
		_delay = if (_letter == "|") then {_letter = "<br />"; 1} else {0.01};
		_sitrep = _sitrep + _letter;
		_control ctrlsetstructuredtext parsetext format [_sitrepFormat,_sitrep + "_"];
		
		sleep _delay;
		if (isnull _control) exitwith {};
	};
	_control ctrlsetstructuredtext parsetext format [_sitrepFormat,_sitrep];
};



_camera = "camera" camcreate position player;
_camera cameraeffect ["internal","back"];
_camera campreparefov 0.4;
_camera campreparetarget _killer;
showcinemaborder false;


_saturation = 0.0 + random 0.3;
_ppColor = ppEffectCreate ["ColorCorrections", 1999];
_ppColor ppEffectEnable true;
_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1 - _saturation, 1 - _saturation, 1 - _saturation, _saturation], [1, 0.25, 0, 1.0]];
_ppColor ppEffectCommit 0;

_ppGrain = ppEffectCreate ["filmGrain", 2012];
_ppGrain ppEffectEnable true;
_ppGrain ppEffectAdjust [random 0.2, 1, 1, 0, 1];
_ppGrain ppEffectCommit 0;


bis_fnc_respawnNone_player = _player;
bis_fnc_respawnNone_killer = _killer;
bis_fnc_respawnNone_camera = _camera;


bis_fnc_respawnNone_vision = -1;
if (sunormoon < 1) then {bis_fnc_respawnNone_vision = 0;};
[-1,-1] call bis_fnc_respawnNone_keydown;

_display displayaddeventhandler ["mousemoving","_this call bis_fnc_respawnNone_loop"];
_display displayaddeventhandler ["mouseholding","_this call bis_fnc_respawnNone_loop"];
_display displayaddeventhandler ["keydown","_this call bis_fnc_respawnNone_keydown"];



waituntil {isnull _display};
_displayTeamSwitch = finddisplay 632;


waituntil {isnull _displayTeamSwitch};

_camera cameraeffect ["terminate","back"];
camdestroy _camera;

bis_fnc_respawnNone_player = nil;
bis_fnc_respawnNone_killer = nil;
bis_fnc_respawnNone_camera = nil;

ppeffectdestroy _ppColor;
ppeffectdestroy _ppGrain;

if (!alive player) exitwith {_this call bis_fnc_respawnNone;};



BIS_fnc_feedback_allowPP = true;
0 fadesound _soundvolume;
0 fademusic _musicvolume;
playmusic "";
bis_fnc_respawnNone_start = nil;
