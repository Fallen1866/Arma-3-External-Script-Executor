#line 0 "/temp/bin/A3/Functions_F/Inventory/fn_invRemove.sqf"




















textLogFormat ["INV_REM BIS_FNC_invRemove %1", _this];

private["_return","_unit","_item","_slotsItem","_slotsEmpty","_slotsItem","_success","_howMuch"];
_unit = _this select 0;
_item = _this select 1;
if (count _this > 2) then {_howMuch = _this select 2;} else {_howMuch = 1;};

if ((typeName _unit) != "OBJECT") exitWith {textLogFormat ["INV_ Error: BIS_FNC_invRemove - 1st parameter must be unit! %1", _this];0};
if (((typeName _item) != "CONFIG") && ((typeName _item) != "STRING")) exitWith {textLogFormat ["INV_ Error: BIS_FNC_invRemove - 2nd parameter must be config|string! %1", _this];0};
if (isNil {_item})  exitWith {textLogFormat ["INV_ Error: BIS_FNC_invRemove - 2nd parameter - _item is undefined! %1", _this];0};
if ((typeName _howMuch) != "SCALAR")  exitWith {textLogFormat ["INV_ Error: BIS_FNC_invRemove - 3rd parameter must be scalar! %1", _this];0};

private["_cntRemoved"];
_cntRemoved = 0;

private ["_removeItem"];
_removeItem = 
{
  private ["_unit","_item","_howMuch","_scriptingFunction"];
  _unit = _this select 0;
  _item = _this select 1;
  _howMuch = _this select 2;     
  _scriptingFunction = _this select 3;  
    
  for [{_i=0},{_i<(_cntActual min _howMuch)},{_i=_i+1}] do
  {    
    call compile format ["_unit %1 _item", _scriptingFunction]; 
  };
  
  (_cntActual min _howMuch)
};

if ((typeName _item) == (typename (configfile))) then 
{
  _cntActual = {_x == _item} count ([_unit] call BIS_fnc_inv); 
  if (_item == (configfile >> "cfgweapons" >> (configName _item))) then {_cntRemoved = [_unit,  configName _item, _howMuch, "removeWeapon"] call _removeItem;};  
  if (_item == (configfile >> "cfgmagazines" >> (configName _item))) then {_cntRemoved = [_unit,  configName _item, _howMuch, "removeMagazine"] call _removeItem;};
};
  
if ((typeName _item) == (typeName "")) then 
{  
  if (isClass (configfile >> "cfgweapons" >> (_item))) then 
  {
    _cntActual = {_x == (configfile >> "cfgweapons" >> (_item))} count ([_unit] call BIS_fnc_inv); 
    _cntRemoved = [_unit, _item, _howMuch, "removeWeapon"] call _removeItem;
  }
  else
  {
    if (isClass (configfile >> "cfgmagazines" >> (_item))) then 
    {
      _cntActual = {_x == (configfile >> "cfgmagazines" >> (_item))} count ([_unit] call BIS_fnc_inv); 
      _cntRemoved = [_unit, _item, _howMuch, "removeMagazine"] call _removeItem;
    };
  };  
};  

textLogFormat ["INV_REM BIS_FNC_invRemove _unit _item _howMuch %1 returning: %2", [_unit, _item, _howMuch],_cntRemoved];
_cntRemoved
