
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_Destroyer01EdenInit'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_Destroyer01EdenInit';
	scriptName _fnc_scriptName;

#line 1 "A3\Functions_F_Destroyer\Functions\Destroyer\fn_Destroyer01EdenInit.sqf [BIS_fnc_Destroyer01EdenInit]"
#line 1 "A3\Functions_F_Destroyer\Functions\Destroyer\fn_Destroyer01EdenInit.sqf"



































if (!isServer) then {};

private _carrierBase = param [0, objNull];
private _carrierDir = getDir _carrierBase;
private _carrierPos = getPosWorld _carrierBase;

private _carrierPitchBank = _carrierBase call bis_fnc_getPitchBank;
_carrierPitchBank params [["_carrierPitch",0],["_carrierBank",0]];

private _cfgVehicles = configFile >> "CfgVehicles";
private _carrierParts = (_cfgVehicles >> typeOf _carrierBase >> "multiStructureParts") call bis_fnc_getCfgData;
private _carrierPartsArray = [];


private ["_dummy","_dummyClassName","_carrierPartPos"];

{
_dummyClassName = _x select 0;
_dummy = createVehicle [_dummyClassName, _carrierPos, [], _carrierDir, "CAN_COLLIDE"];

_dummy setDir _carrierDir;
[_dummy, _carrierPitch, _carrierBank] call bis_fnc_setPitchBank;
_carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));        
_dummy setPosWorld _carrierPartPos;
_carrierPartsArray pushBack [_dummy,_x select 1];
_dummy allowDamage false;
}
foreach _carrierParts;

_carrierBase setVariable ["bis_carrierParts", _carrierPartsArray, true];
