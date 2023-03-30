#line 0 "/temp/bin/A3/Functions_F/Systems/fn_showTime.sqf"












private ["_rscLayer","_dateStartArray","_dateEndArray","_subCoef","_monthList","_yearStart","_yearEnd","_dateStart","_dateEnd","_diff","_diffDays","_speedCoef","_date","_dateBorder","_startYear","_startMonth","_startMonthString","_startDay","_startHour","_startMinute","_ctrlText","_coef","_start","_currentDate","_currentYear","_dateArray","_currentMonth","_currentMonthString","_currentDay","_currentHour","_currentMinute","_debug","_text","_delay"];
disableserialization;




_rscLayer = [] call bis_fnc_rscLayer;

_rscLayer cutRSC ["RscTime","plain"];

waituntil {!isnil {uinamespace getvariable "BIS_InfoTime"}};
_BIS_InfoTime = uinamespace getvariable "BIS_InfoTime";

_dateStartArray = if (count _this > 0) then {_this select 0} else {date};
_dateEndArray = if (count _this > 1) then {_this select 1} else {[date select 0,date select 1,(date select 2)+1,date select 3,date select 4]};
_subCoef = if (count _this > 2) then {_this select 2} else {1};

_monthList = [
	"error",
	"str_january",
	"str_february",
	"str_march",
	"str_april",
	"str_may",
	"str_june",
	"str_july",
	"str_august",
	"str_september",
	"str_october",
	"str_november",
	"str_december"
];

_yearStart = _dateStartArray select 0;
_yearEnd = _dateEndArray select 0;

_dateStart = (datetonumber _dateStartArray);
_dateEnd = (datetonumber _dateEndArray);

_diff = _dateEnd - _dateStart;
_diffDays = _diff / (1/365);
_speedCoef = 1 + (0.00023 * _subCoef) * _diffDays;

_date = _dateStart;
_dateBorder = _dateEnd - _diff / 2 / _speedCoef;

_startYear = _dateStartArray select 0;
_startMonth = _dateStartArray select 1;
_startMonthString = _monthList select _startMonth;
_startDay = _dateStartArray select 2;
_startHour = _dateStartArray select 3;
_startMinute = _dateStartArray select 4;

_ctrlText = _BIS_InfoTime displayCtrl 112301;
_coef = 1;

_start = true;


while {_date <= _dateEnd} do {

	_date = _date + (1/365/24/60)*_coef;




	_currentDate = _date;
	_currentYear = _startYear;
	_dateArray = numbertodate [_currentYear,_currentDate];

	
	_currentMonth = _dateArray select 1;
	_currentMonthString = _monthList select _currentMonth;
	_currentDay = _dateArray select 2;
	_currentHour = _dateArray select 3;
	_currentMinute = _dateArray select 4;

	_debug = [_date];

	_text = format ["<t size='1.8'>%1</t><br /><t size='1.8'>%2 %3</t><br /><t size='1.8'>%4:%5</t><br />",
		_currentYear,
		localize _currentMonthString,
		if (_currentDay < 10) then {"0" + str _currentDay} else {_currentDay},
		if (_currentHour < 10) then {"0" + str _currentHour} else {_currentHour},
		if (_currentMinute < 10) then {"0" + str _currentMinute} else {_currentMinute},
		_debug
	];

	_ctrlText ctrlsetstructuredtext parsetext _text;
	

	_coef = _coef * (1 + _subCoef * (_dateBorder - _date));
	
	if (_coef < 1) then {_coef = 1};

	_delay = 0.1 / _coef;
	if (_delay < 0.01) then {_delay = 0.01};
	if (_delay > 0.10) then {_delay = 0.10};
	if (_start) then {sleep 2} else {sleep _delay};
	_start = false;
};

_rscLayer
