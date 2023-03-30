
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_addVirtualMagazineCargo'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_addVirtualMagazineCargo';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_bootcamp\Inventory\fn_addVirtualMagazineCargo.sqf [BIS_fnc_addVirtualMagazineCargo]"
#line 1 "A3\functions_f_bootcamp\Inventory\fn_addVirtualMagazineCargo.sqf"

















private ["_object","_classes","_isGlobal","_initAction"];
_object = _this param [0,missionnamespace,[missionnamespace,objnull]];
_classes = _this param [1,[],["",true,[]]];
_isGlobal = _this param [2,false,[false]];
_initAction = _this param [3,true,[true]];
[_object,_classes,_isGlobal,_initAction,1,2] call bis_fnc_addVirtualItemCargo;
