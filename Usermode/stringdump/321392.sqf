#line 0 "/temp/bin/A3/Functions_F/Combat/fn_fireSupportCluster.sqf"








































params
[
	["_position",objNull,[objNull,[],""]],
	["_ammo","G_40mm_HEDP",[""]],
	["_radius",100,[999]],
	["_quantity",[1,20],[[]]],
	["_delay",10,[999,[]]],
	["_condition",{false},[{}]],
	["_safeZone",0,[999]],
	["_altitude",100,[999]],
	["_velocity",100,[999]],
	["_shellSounds",[""],[[]]]
];


if ((_position isEqualType "") and {getMarkerType _position == ""}) exitWith {["VIRTUAL CLUSTER: Non-existent marker %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType objNull) and {isNull _position}) exitWith {["VIRTUAL CLUSTER: Non-existent object %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType []) and {count _position != 3}) exitWith {["VIRTUAL CLUSTER: Wrong coordinates %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if (_ammo == "") then {_ammo = "G_40mm_HEDP"};
if (!(isClass (configFile >> "CfgAmmo" >> _ammo))) exitWith {["VIRTUAL CLUSTER: Non-existing ammo classname %1 for virtual fire support!",_ammo] call BIS_fnc_logFormat; false};
if (_radius < 0) exitWith {"VIRTUAL CLUSTER: radius cannot be lower than 0 meters!" call BIS_fnc_log; false};
if (_quantity select 0 < 1) exitWith {"VIRTUAL CLUSTER: At least one round must be fired!" call BIS_fnc_log; false};
if (_quantity select 1 < 2) exitWith {"VIRTUAL CLUSTER: Cluster must contain at least two pieces of submunition!" call BIS_fnc_log; false};
if ((_delay isEqualType 999) and {_delay < 0}) exitWith {"VIRTUAL CLUSTER: Delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {count _delay != 2}) exitWith {"VIRTUAL CLUSTER: Wrong format of random delay, use [#x,#y]." call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 0 < 0}) exitWith {"VIRTUAL CLUSTER: Min delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < 0}) exitWith {"VIRTUAL CLUSTER: Max delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < _delay select 0}) exitWith {"VIRTUAL CLUSTER: Max delay cannot be lower than min delay!" call BIS_fnc_log; false};
if (_safeZone < 0) exitWith {"VIRTUAL CLUSTER: Safezone cannot be lower than 0!" call BIS_fnc_log; false};
if (_safeZone > _radius) exitWith {"VIRTUAL CLUSTER: Safezone cannot be bigger than radius!" call BIS_fnc_logFormat; false};
if (_altitude < 0) exitWith {"VIRTUAL CLUSTER: Altitude cannot be lower than 0m!" call BIS_fnc_logFormat; false};


private ["_limit","_submunition","_roundsFired","_targetPos","_finalPos","_marker","_shell","_minDelay","_maxDelay","_finalDelay"];
_roundsFired = 0;
      _limit = _quantity select 0;
      _submunition = _quantity select 1;


if (_delay isEqualType 999) then {_minDelay = _delay; _maxDelay = _delay};
if (_delay isEqualType []) then {_minDelay = _delay select 0; _maxDelay = _delay select 1};





While
{
	(_roundsFired < _limit)
}
Do
{
	
	if (!(isNil _condition) and (_condition)) exitWith {};

	
	if (_position isEqualType "") then {_targetPos = getMarkerPos _position};
	if (_position isEqualType objNull) then {_targetPos = getPos _position};
	if (_position isEqualType []) then {_targetPos = _position};

	
	for "_i" from 1 to _submunition do
	{
		_finalPos = [_targetPos,(random (_radius - _safeZone)) + _safeZone, random 360] call BIS_fnc_relPos;
		_shell = _ammo createVehicle [_finalPos select 0, _finalPos select 1, _altitude];
		_shell setVectorUp [0,0,-1];
		_shell setVelocity [0,0,-(abs _velocity)];
		if !(_shellSounds isEqualTo [""]) then {[_shell,(selectRandom _shellSounds)] remoteExec ["say3D"]};

		sleep 0.1;
	};

	_roundsFired = _roundsFired + 1;

	_finalDelay = _minDelay + (random (_maxDelay - _minDelay));
	sleep _finalDelay;

};




true

