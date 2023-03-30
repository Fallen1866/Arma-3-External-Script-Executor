
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_lookAtArray'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_lookAtArray';
	scriptName _fnc_scriptName;

#line 1 "\A3\Functions_F_Tacops\Systems\fn_lookAtArray.sqf [BIS_fnc_lookAtArray]"
#line 1 "A3\Functions_F_Tacops\Systems\fn_lookAtArray.sqf"
scriptname "BIS_fnc_lookAtArray";







































params 
[
["_initialize",		true,		[true]		],
["_userArray",		[],			[[]]		]
];



if(_initialize) then 
{
if (_userArray isEqualTypeArray [objNull, 0, true, {}]) exitWith {};

private _handler = missionNamespace getVariable ["BIS_lookAtFrameHandler", nil];


if(isNil{_handler}) then
{

missionNamespace setVariable ["BIS_lookAtArray", _userArray];


_handler = addMissionEventHandler ["EachFrame", "[] spawn BIS_fnc_lookAtArrayEH"];


missionNamespace setVariable ["BIS_lookAtFrameHandler", _handler];
}
else
{



_existingArray = missionNamespace getVariable ["BIS_lookAtArray", nil];

if(!isNil{_existingArray}) then
{

missionNamespace setVariable ["BIS_lookAtArray", _existingArray + _userArray];
};	
};	
}
else 
{
_handler = missionNamespace getVariable ["BIS_lookAtFrameHandler", nil];


if( !isNil {_handler;} ) then
{
removeMissionEventHandler ["EachFrame", _handler];
};


missionNamespace setVariable ["BIS_lookAtFrameHandler", nil];
};
