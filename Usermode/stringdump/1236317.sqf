#line 0 "/temp/bin/A3/Functions_F/Misc/fn_interpolateWeather.sqf"




















private["_date1","_weather1","_date2","_weather2","_iDate","_iWeather","_dateS","_weatherS","_dateE","_weatherE","_iOvercast","_iFog","_iMult","_fogS","_fogE"];

_date1 		= _this param [0,[],[[]]];
_weather1 	= _this param [1,[],[[]]];
_date2 		= _this param [2,[],[[]]];
_weather2 	= _this param [3,[],[[]]];
_iDate 		= _this param [4,date,[[]]];




if (count _date1 != 5) exitWith {"Error in param '_date1'!" call BIS_fnc_error; [0,0]};
if (count _date2 != 5) exitWith {"Error in param '_date2'!" call BIS_fnc_error; [0,0]};
if (count _iDate != 5) exitWith {"Error in param '_iDate'!" call BIS_fnc_error; [0,0]};
if (count _weather1 != 2) exitWith {"Error in param '_weather1'!" call BIS_fnc_error; [0,0]};
if (count _weather2 != 2) exitWith {"Error in param '_weather2'!" call BIS_fnc_error; [0,0]};

_date1 = (_date1 select 0) + (dateToNumber _date1);
_date2 = (_date2 select 0) + (dateToNumber _date2);
_iDate = (_iDate select 0) + (dateToNumber _iDate);


if (_date1 < _date2) then
{
	_dateS 		= _date1;
	_weatherS 	= _weather1;
	_dateE 		= _date2;
	_weatherE 	= _weather2;
}
else
{
	_dateS 		= _date2;
	_weatherS 	= _weather2;
	_dateE 		= _date1;
	_weatherE 	= _weather1;
};

if (_iDate < _dateS) then
{
	["[!!!] Date %1 is lower then the bottom boundry date %2. Boundry date used instead!",_this select 4,_this select 0] call BIS_fnc_logFormat;

	_iDate = _dateS;
};

if (_iDate > _dateE) then
{
	["[!!!] Date %1 is higher then the upper boundry date %2. Boundry date used instead!",_this select 4,_this select 2] call BIS_fnc_logFormat;

	_iDate = _dateE;
};

_dateE = _dateE - _dateS;
_iDate = _iDate - _dateS;
_dateS = 0;

_iMult = _iDate / _dateE;

_fogS = _weatherS select 1; if (typeName _fogS == typeName []) then {_fogS = _fogS select 0};
_fogE = _weatherE select 1; if (typeName _fogE == typeName []) then {_fogE = _fogE select 0};

_iOvercast 	= (((_weatherE select 0) - (_weatherS select 0)) * _iMult) + (_weatherS select 0);
_iFog 		= ((_fogE - _fogS) * _iMult) + _fogS;

_iWeather = [_iOvercast,_iFog];



_iWeather

