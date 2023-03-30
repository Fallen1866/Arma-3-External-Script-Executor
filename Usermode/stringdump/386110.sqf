#line 0 "/temp/bin/A3/Functions_F/Combat/fn_stalk.sqf"


































params
[
	["_stalkerGroup",grpNull,[grpNull]],
	["_stalkedGroup",grpNull,[grpNull]],
	["_refresh",10,[999]],
	["_radius",0,[999]],
	["_condition",{false},[{}]],
	["_returnWP",0,[999,"",objNull,[]]]
];


if (isNull _stalkerGroup) exitWith {["STALKING: Non-existing group %1 to stalk used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if (_stalkerGroup getVariable "BIS_Stalk" == 1) exitWith {["STALKING: %1 is already stalking!",_stalkerGroup] call BIS_fnc_logFormat; false};
if (isNull _stalkedGroup) exitWith {["STALKING: Non-existing group %2 to be stalked used!",_stalkedGroup] call BIS_fnc_logFormat; false};
if (_stalkerGroup == _stalkedGroup) exitWith {["STALKING: Group %1 cannot stalk itself!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_refresh isEqualType 999) and {_refresh < 5}) exitWith {["STALKING: %1 Delay cannot be lower than 5 seconds!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_radius isEqualType 999) and {_radius < 0}) exitWith {["STALKING: %1 Radius cannot be lower than 0 meters!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType 999) and {!(_returnWP in [0,1,2])}) exitWith {["STALKING: %1 Incorrect return WP type, only 0, 1 or 2 can be used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType "") and {getMarkerType _returnWP == ""}) exitWith {["STALKING: %1 Non-existent marker for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType objNull) and {isNull _returnWP}) exitWith {["STALKING: %1 Non-existent object for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};
if ((_returnWP isEqualType []) and {count _returnWP != 3}) exitWith {["STALKING: %1 Wrong [X,Y,Z] format for return waypoint used!",_stalkerGroup] call BIS_fnc_logFormat; false};


_stalkerGroup setVariable ["BIS_Stalk",1];


private ["_originalPos"];
_originalPos = (getPos leader _stalkerGroup);


_grpOriginalWP = createGroup Civilian;
"C_man_1" createUnit [(position leader _stalkerGroup),_grpOriginalWP];
_grpOriginalWP copyWaypoints _stalkerGroup;
{deleteVehicle _x} forEach (units _grpOriginalWP);


_wp = _stalkerGroup addWaypoint [(leader _stalkerGroup),0];


While
{
	({alive _x} count (units _stalkerGroup) > 0) and
	({alive _x} count (units _stalkedGroup) > 0)
}
Do
{
	if (simulationEnabled (leader _stalkerGroup)) then {
		while {(count (waypoints _stalkerGroup)) > 0} do {deleteWaypoint ((waypoints _stalkerGroup) select 0)};
		_wp = _stalkerGroup addWaypoint [(leader _stalkedGroup),_radius];
	};
	sleep _refresh;

	if (!(isNil _condition) and (_condition)) exitWith {};
};


if (!(isNil _condition) and (_condition)) then
{
	
	_stalkerGroup setVariable ["BIS_Stalk",0];

	if ({alive _x} count (units _stalkerGroup) > 0) then
	{
		{_x commandTarget objNull} forEach (units _stalkerGroup);
                while {(count (waypoints _stalkerGroup)) > 0} do {deleteWaypoint ((waypoints _stalkerGroup) select 0)};

		if (_returnWP isEqualType 999) then
		{
			if (_returnWP == 0) then
			{
				_stalkerGroup copyWaypoints _grpOriginalWP;
				
			};
			if (_returnWP == 1) then
			{
				_pos01 = [(position leader _stalkerGroup), 50, 0] call BIS_fnc_relPos;
				_pos02 = [(position leader _stalkerGroup), 50, 90] call BIS_fnc_relPos;
				_pos03 = [(position leader _stalkerGroup), 50, 180] call BIS_fnc_relPos;
				_pos04 = [(position leader _stalkerGroup), 50, 270] call BIS_fnc_relPos;
				_wp01 = _stalkerGroup addWaypoint [_pos01,0];
				_wp02 = _stalkerGroup addWaypoint [_pos02,0];
				_wp03 = _stalkerGroup addWaypoint [_pos03,0];
				_wp04 = _stalkerGroup addWaypoint [_pos04,0];
				_wp05 = _stalkerGroup addWaypoint [_pos04,0];
				_wp05 setWaypointType "Cycle";
				
			};
			if (_returnWP == 2) then
			{
				_wp = _stalkerGroup addWaypoint [_originalPos,0];
				
			};
		};
		if (_returnWP isEqualType "") then
		{
			_wp = _stalkerGroup addWaypoint [(getMarkerPos _returnWP),0];
                                    
		};
		if (_returnWP isEqualType objNull) then
		{
			_wp = _stalkerGroup addWaypoint [(getPos _returnWP),0];
                                    
		};
		if (_returnWP isEqualType []) then
		{
			_wp = _stalkerGroup addWaypoint [_returnWP,0];
                                    
		};
	};
};

if ({alive _x} count (units _stalkerGroup) == 0) then { _stalkerGroup setVariable ["BIS_Stalk",nil]};
if ({alive _x} count (units _stalkedGroup) == 0) then {};


deleteGroup _grpOriginalWP;


true

