
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleFriendlyFire'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleFriendlyFire';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Misc\functions\fn_moduleFriendlyFire.sqf [BIS_fnc_moduleFriendlyFire]"
#line 1 "A3\modules_f\Misc\functions\fn_moduleFriendlyFire.sqf"























































private[ "_Init", "_Destroy" ];







_Init =
{
private["_array", "_logic", "_units", "_activated", "_tmpunits", "_unit" ];
_array = _this param [0,[],[[]]];


_units = _array param [0,[],[[]]];
_activated = _array param [1,true,[true]];






if(isNil "BIS_FriendlyFire") then
{
BIS_FriendlyFireGroup = createGroup sideLogic;


"Logic" createUnit [[0,0,0], BIS_FriendlyFireGroup, "BIS_FriendlyFire = this; this setGroupID [""FriendlyFire"", ""GroupColor0""]"];
PublicVariable "BIS_FriendlyFire";

_tmpunits = [];

{

_tmpunits = _tmpunits + [[_x, -1, 0]];


if( crew _x select 0 != _x ) then
{
{
_tmpunits = _tmpunits + [[_x, -1, 0]];
} forEach (crew _x);
};
}  foreach _units;



BIS_FriendlyFire setVariable [ "units", _tmpunits, TRUE ];
BIS_FriendlyFire setVariable [ "playerkilledfriendly", false, TRUE ];
BIS_FriendlyFire setVariable [ "checkStatusInLoop", true, TRUE ];

[ _tmpunits ] call _AddEventHandlers;
[] spawn _Main;


["[Friendly Fire] Successfully initialized:"] call BIS_fnc_Log;



[] call _ListActiveUnits;

_returnValue = true;
}
else
{

["[Friendly Fire] Already initialized!"] call BIS_fnc_Log;

_returnValue = false;
};
_returnValue
};


_Destroy =
{
deleteVehicle BIS_FriendlyFire;
BIS_FriendlyFire = nil;
deleteGroup BIS_FriendlyFireGroup;


["[Friendly Fire] Deinitialized!"] call BIS_fnc_Log;

true;
};








private["_ListActiveUnit"];
_ListActiveUnits =
{
if (count (BIS_FriendlyFire getVariable "units") > 0) then {

};

};







private["_AddUnits"];
_AddUnits =
{
private ["_array", "_units", "_unitscount", "_unit", "_actualunits", "_tmpunits" ];

_array = _this param [0,[],[[]]];
_units = _array param [0,[],[[]]];

_actualunits = BIS_FriendlyFire getVariable "units";

_tmpunits = [];
{
if( !isNil "_x" ) then
{ _tmpunits = _tmpunits + [[_x, -1, 0]] };
}  foreach _units;

{
_unit = _x select 0;

_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;

if( count _tmpfound == 0 ) then
{
_actualunits = _actualunits + [_x];
};

} forEach _tmpunits;

BIS_FriendlyFire setVariable [ "units", _actualunits, TRUE ];

[_tmpunits] call _AddEventHandlers;

[] call _ListActiveUnits;

true
};








private["_RemoveUnits"];
_RemoveUnits =
{
private ["_array", "_units", "_unitscount", "_unit", "_actualunits", "_tmpunits", "_foundunit", "_foundhandler", "_actualunits2" ];

_array = _this param [0,[],[[]]];
_units = _array param [0,[],[[]]];
_actualunits = BIS_FriendlyFire getVariable "units";

{
if( !isNil "_x" ) then
{
_unit = _x;
_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;

if( count _tmpfound != 0 ) then
{
_foundunit = (_actualunits select (_tmpfound select 0)) select 0;
_foundhandler = (_actualunits select (_tmpfound select 0)) select 1;
_foundunit removeEventHandler [ "killed", _foundhandler ];
_actualunits2 = [_actualunits, (_tmpfound select 0)] call BIS_fnc_removeIndex;
_actualunits = _actualunits2;
};
};
} forEach _units;

BIS_FriendlyFire setVariable [ "units", _actualunits, TRUE ];

[] call _ListActiveUnits;

true
};







private _HandlerKilled = {
_whohit = _this param [1, objNull, [objNull] ];
_whowashit = _this param [0, objNull, [objNull] ];



if( (_whohit == player) || (_whohit == vehicle player) || ((vehicle _whohit) == (getConnectedUAV player)) ) then
{
BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
};
true
};
private _HandlerHit = {
private _whohit = _this param [1, objNull, [objNull] ];
private _whowashit = _this param [0, objNull, [objNull] ];



if( (_whohit == player) || (_whohit == vehicle player) || ((vehicle _whohit) == (getConnectedUAV player)) ) then
{


_actualunits = BIS_FriendlyFire getVariable "units";
_tmpfound = [_actualunits, _whowashit] call BIS_fnc_findNestedElement ;
_priority = (_actualunits select (_tmpfound select 0)) select 2;

if( _priority > 0 ) then
{

BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
}
else
{


if( !canMove _whowashit ) then
{

BIS_FriendlyFire setVariable ["playerkilledfriendly", true, TRUE];
}
else
{


};
};
};
true
};

private["_AddEventHandlers"];
_AddEventHandlers =
{
private[ "_handler", "_units", "_unit", "_locatedunit", "_tmpunits" ];
_units = _this param [0, [], [[]] ];
if (ismultiplayer) then {
{
private _unit = _x select 0;

if ( _unit isKindOf "man" ) then
{
_handler = _unit addMPEventHandler ["MPKilled",_HandlerKilled];
}
else
{
_handler = _unit addMPEventHandler ["MPHit",_HandlerHit];
};
_locatedunit = ([_units, _unit] call BIS_fnc_findNestedElement) select 0;	
[_units, [_locatedunit, 1], _handler] call BIS_fnc_setNestedElement;

} forEach _units;
} else {

{
private _unit = _x select 0;

if ( _unit isKindOf "man" ) then
{
_handler = _unit addEventHandler ["Killed",_HandlerKilled];
}
else
{
_handler = _unit addEventHandler ["Hit",_HandlerHit];
};
_locatedunit = ([_units, _unit] call BIS_fnc_findNestedElement) select 0;	
[_units, [_locatedunit, 1], _handler] call BIS_fnc_setNestedElement;

} forEach _units;
};
true
};








private["_ChangePriority"];
_ChangePriority =
{
private[ "_unit", "_priority" ];
_array = _this param [0,[],[[]]];
_unit = _array param [0, objNull, [objNull]];
_priority = _array param [1, 0, [0]];
_actualunits = BIS_FriendlyFire getVariable "units";

_tmpfound = [_actualunits, _unit] call BIS_fnc_findNestedElement;

if( count _tmpfound != 0 ) then
{
[ _actualunits, [ (_tmpfound select 0),2 ], _priority ] call BIS_fnc_setNestedElement;
["[Friendly Fire] The priority has been changed for %1", _unit ] call BIS_fnc_LogFormat;
}
else
{
["[Friendly Fire] %1 not found - cannot change the priority", _unit ] call BIS_fnc_LogFormat;
};
true
};







private["_FriendlyFire"];
_FriendlyFire =
{
["[Friendly Fire] Friendly Fire happened! Handling the situation"] call BIS_fnc_Log;
["FriendlyFire", FALSE] RemoteExec ["BIS_fnc_endMission", 0, TRUE];
[] call _Destroy;
true
};









private["_CheckStatus"];
_CheckStatus =
{
private["_returnValue","_playerkilledfriendly"];

_returnValue = false;
_playerkilledfriendly = BIS_FriendlyFire getVariable "playerkilledfriendly";
if( side player == sideEnemy || _playerkilledfriendly ) then
{
_returnValue = true
};
_returnValue
};








private["_Main"];
_Main =
{
private["_playerKilledFriendly", "_checkInLoop"];

while{ BIS_FriendlyFire getVariable "checkStatusInLoop" } do
{

_playerKilledFriendly = ["CheckStatus", []] call BIS_fnc_moduleFriendlyFire;
if( _playerKilledFriendly ) then
{
BIS_FriendlyFire setVariable [ "checkStatusInLoop", false, TRUE ];
};
Sleep 1;
};
if( _playerKilledFriendly ) then { ["FriendlyFire", []] call BIS_fnc_moduleFriendlyFire; };
true
};











private[ "_functionCalled", "_returnValue", "_subset" ];

_returnValue = false;
_functionCalled = _this param [0,["", objNull], ["", objNull]];

if( typeName _functionCalled == "OBJECT" ) then
{

_functionCalled = "Init";
_subset = [];
_subset = _subset + [[ _this, 1] call BIS_fnc_subSelect];
}
else
{

_subset = [ _this, 1] call BIS_fnc_subSelect;
};

_functionCalledCode = call compile format [ "_%1", _functionCalled ];








if!(isNil "BIS_FriendlyFire" && _functionCalled != "Init") then
{

if ( isNil {call compile format ["typeName _%1", _functionCalled]} ) then
{
["FriendlyFire::ENTRY POINT] Function %1 doesn't exist!", _functionCalled ] call BIS_fnc_LogFormat;
_returnValue = false;
}
else
{
_returnValue = _subset call _functionCalledCode;

};
}
else
{
["[FriendlyFire::ENTRY POINT]: Initialize the Friendly Fire system first using Init parameter please!"] call BIS_fnc_LogFormat;
_returnValue = false;
};

_returnValue

