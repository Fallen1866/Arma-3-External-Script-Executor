#line 0 "/temp/bin/A3/Functions_F/Tasks/fn_setTask.sqf"





































#line 1 "//temp/bin/A3/Functions_F/Tasks/defines.inc"
#line 0 "//temp/bin/A3/Functions_F/Tasks/defines.inc"


























#line 38 "/temp/bin/A3/Functions_F/Tasks/fn_setTask.sqf"







private["_ids","_id","_taskVar","_parent","_children","_prevData","_index"];


_ids	 = _this param [0,"",["",[]]]; if (typeName _ids == typeName "") then {_ids = [_ids]};
_id	 = _ids param [0,"",[""]]; if (_id == "") exitWith {["[x] Task ID cannot be an empty string!"] call bis_fnc_error;""};
_taskVar = _id call bis_fnc_taskVar;


_prevData = [];
for "_index" from 0 to 11 do {_prevData pushBack ((if ((missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index])}));};


_parent   = _ids param [1,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,1],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 1]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,1],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 1])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,1],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 1])}),[""]];
_children = _ids param [2,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2])}),[[]]];

(missionNamespace setVariable [format["%1.%2",_taskVar,0],_id]);
(missionNamespace setVariable [format["%1.%2",_taskVar,1],_parent]);
(missionNamespace setVariable [format["%1.%2",_taskVar,2],_children]);







private["_fnc_addOwner","_newOwner","_owners","_thisVar"];

_fnc_addOwner =
{
	switch (typename _this) do
	{
		case (typename true):
		{
			if (_this) then {_owners pushBackUnique _this;};
		};
		case (typename grpnull);
		case (typename "");
		case (typename sideunknown):
		{
			_owners pushBackUnique _this;
		};
		case (typename objnull):
		{
			_thisVar = _this call bis_fnc_objectVar;
			_owners pushBackUnique _thisVar;
		};
		case (typename []):
		{
			{_x call _fnc_addOwner;} foreach _this;
		};
	};
};

_owners = (if ((missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3])});
_newOwner = _this param [1,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,3],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 3])}),[true,sideunknown,grpnull,objnull,[],""]];
_newOwner call _fnc_addOwner;

(missionNamespace setVariable [format["%1.%2",_taskVar,3],_owners]);






private _dest 		= _this param [3,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,4],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 4]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,4],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 4])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,4],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 4])}),[objnull,[]]];
private _destTarget 	= _dest param [0,objnull,[objnull,0]];

if (typename _destTarget == typename objnull) then
{
	_dest =
	[
		_destTarget,
		_dest param [1,false,[false]]
	]
}
else
{
	if (typeName _destTarget == typeName objNull) then
	{
		_dest =
		[
			_destTarget,
			_dest param [1,false,[false]]
		]
	}
	else
	{
		_dest =
		[
			_destTarget,
			_dest param [1,0,[0]],
			_dest param [2,0,[0]]
		]
	};
};

(missionNamespace setVariable [format["%1.%2",_taskVar,4],_dest]);







private _priority = _this param [5,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,5],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 5]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,5],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 5])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,5],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 5])}),[0]];

(missionNamespace setVariable [format["%1.%2",_taskVar,5],_priority]);







private _global = _this param [7,true,[true]]; if !(isMultiplayer) then {_global = false;};







private _taskType = _this param [8,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,10],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 10]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,10],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 10])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,10],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 10])}),[""]];

(missionNamespace setVariable [format["%1.%2",_taskVar,10],_taskType]);






private _txt = _this param [2,[(if ((missionNamespace getVariable [format["%1.%2",_taskVar,6],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 6]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,6],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 6])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,6],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 6])}),(if ((missionNamespace getVariable [format["%1.%2",_taskVar,7],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 7]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,7],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 7])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,7],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 7])}),(if ((missionNamespace getVariable [format["%1.%2",_taskVar,8],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 8]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,8],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 8])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,8],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 8])})],[[],""]];

if (typename _txt == typename "") then
{
	
	private _cfgTaskDescription = if (_txt == "") then
	{
		[["CfgTaskDescriptions",_id],configfile >> ""] call bis_fnc_loadClass;
	}
	else
	{
		[["CfgTaskDescriptions",_txt],configfile >> ""] call bis_fnc_loadClass;
	};

	_txt =
	[
		if (isArray (_cfgTaskDescription >> "description")) then {
			format getarray (_cfgTaskDescription >> "description")
		} else {
			gettext (_cfgTaskDescription >> "description")
		},
		gettext (_cfgTaskDescription >> "title"),
		gettext (_cfgTaskDescription >> "marker")
	];
}
else
{
	_txt = +_txt;
};

private ["_text"];

{
	_text = _txt param [_forEachIndex,"",["",[]]];
	if (typename _text != typename []) then {_text = [_text]};

	(missionNamespace setVariable [format["%1.%2",_taskVar,_x],_text]);
}
forEach [6,7,8];







private _state = _this param [4,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9])}),["",true]];

if (typename _state == typename true) then {_state = toupper([(if ((missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,9],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 9])}),"ASSIGNED"] select _state)};

(missionNamespace setVariable [format["%1.%2",_taskVar,9],_state]);







private _core = _this param [9,(if ((missionNamespace getVariable [format["%1.%2",_taskVar,11],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 11]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,11],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 11])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,11],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 11])}),[true]];

(missionNamespace setVariable [format["%1.%2",_taskVar,11],_core]);








if (_state != "CREATED" && {_state != "ASSIGNED"}) then
{
	private ["_xTaskVar","_xId","_xState"];

	{
		_xTaskVar = _x call bis_fnc_taskVar;

		_xId 	  = (missionNamespace getVariable (format["%1.%2",_xTaskVar,0]));
		_xState   = (missionNamespace getVariable (format["%1.%2",_xTaskVar,9]));

		if !(isNil "_xId") then				
		{
			if (isNil "_xState") then
			{
				_xState = "CREATED";
			};

			if (_xState == "CREATED" || {_xState == "ASSIGNED" || {_xState == "AUTOASSIGNED"}}) then
			{
				

				[_x,nil,nil,nil,_state,nil,false] call bis_fnc_setTask;
			};
		};
	}
	foreach _children;
};







if (_parent != "") then
{
	private ["_parentVar","_parentId","_parentChildren","_added"];

	_parentVar  = _parent call bis_fnc_taskVar;
	_parentId = (missionNamespace getVariable (format["%1.%2",_parentVar,0]));
	_parentChildren = (if ((missionNamespace getVariable [format["%1.%2",_parentVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_parentVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2])} else {(missionNamespace getVariable [format["%1.%2",_parentVar,2],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select 2])});
	_added = false;

	if ({_x == _id} count _parentChildren == 0) then
	{
		_parentChildren pushBack _id;
		_added = true;
	};

	
	if (isNil "_parentId") exitWith
	{
		[[_parent,"",_parentChildren],_owners] call bis_fnc_setTask;
	};

	
	if (_added) then
	{
		(missionNamespace setVariable [format["%1.%2",_parentVar,2],_parentChildren]);

		
		if (_global) then
		{
			publicvariable format["%1.%2",_parentVar,2];
		};
	};
};







private["_current","_prev","_var"];


if (_global) then
{
	for "_index" from 0 to 11 do
	{
		_current = (if ((missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index]) isEqualType []) then {+(missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index])} else {(missionNamespace getVariable [format["%1.%2",_taskVar,_index],["","",[],[],[objNull,false],-1,"","","","CREATED","Default",false] select _index])});
		_prev 	 = _prevData select _index;

		

		if !(_current isEqualTo _prev) then
		{
			

			
			publicVariable format["%1.%2",_taskVar,_index];
		};
	};
};

private _notification = _this param [6,true,[true]];


if (_global) then
{
	[_id, _notification] remoteExecCall ["BIS_fnc_setTaskLocal", 0, toLower _id];
}
else
{
	[_id,_notification] call BIS_fnc_setTaskLocal;
};

_id
