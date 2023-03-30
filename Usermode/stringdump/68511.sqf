#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagKeyLayout.sqf"






















































































































































































































private ["_mode","_limit","_limitSelector"];
startloadingscreen [""];




_category = _this param [0,"",[""]];
_categoryArray = getarray (configfile >> "UserActionGroups" >> _category >> "group");
_categoryAll = count _categoryArray == 0;


_mode = _this param [1,"",[""]];
switch _mode do {
	case "double": {
		_limit = 256;
		_limitSelector = 0;

	};
	case "LCtrl": {
		_limit = 0;
		_limitSelector = 0x1D;

	};
	case "RCtrl": {
		_limit = 0;
		_limitSelector = 0x9D;

	};
	case "LShift": {
		_limit = 0;
		_limitSelector = 0x2A;

	};
	case "RShift": {
		_limit = 0;
		_limitSelector = 0x36;

	};
	default {
		_limit = 0;
		_limitSelector = 0;
	};
};

_template = [
	0x01,"Escape",[],
	0x3B,"F1",[],
	0x3C,"F2",[],
	0x3D,"F3",[],
	0x3E,"F4",[],
	0x3F,"F5",[],
	0x40,"F6",[],
	0x41,"F7",[],
	0x42,"F8",[],
	0x43,"F9",[],
	0x44,"F10",[],
	0x57,"F11",[],
	0x58,"F12",[],

	0x29,"Tilde",[],
	0x02,"Key1",[],
	0x03,"Key2",[],
	0x04,"Key3",[],
	0x05,"Key4",[],
	0x06,"Key5",[],
	0x07,"Key6",[],
	0x08,"Key7",[],
	0x09,"Key8",[],
	0x0A,"Key9",[],
	0x0B,"Key0",[],
	0x0C,"Minus",[],
	0x0D,"Equals",[],
	0x0E,"Backspace",[],

	0x0F,"Tab",[],
	0x10,"Q",[],
	0x11,"W",[],
	0x12,"E",[],
	0x13,"R",[],
	0x15,"Y",[],
	0x14,"T",[],
	0x16,"U",[],
	0x17,"I",[],
	0x18,"O",[],
	0x19,"P",[],
	0x1A,"LBracket",[],
	0x1B,"RBracket",[],
	0x2B,"Backslash",[],

	0x3A,"CapsLock",[],
	0x1E,"A",[],
	0x1F,"S",[],
	0x20,"D",[],
	0x21,"F",[],
	0x22,"G",[],
	0x23,"H",[],
	0x24,"J",[],
	0x25,"K",[],
	0x26,"L",[],
	0x27,"Semicolon",[],
	0x28,"Apostrophe",[],
	0x1C,"Enter",[],

	0x2A,"LShift",[],
	0x2C,"Z",[],
	0x2D,"X",[],
	0x2E,"C",[],
	0x2F,"V",[],
	0x30,"B",[],
	0x31,"N",[],
	0x32,"M",[],
	0x33,"Comma",[],
	0x34,"FullStop",[],
	0x35,"Slash",[],
	0x36,"RShift",[],

	0x1D,"LCtrl",[],
	0xDB,"LWin",[],
	0x38,"LAlt",[],
	0x39,"Space",[],
	0xB8,"RAlt",[],
	0xDC,"RWin",[],
	0xDD,"Menu",[],
	0x9D,"RCtrl",[],

	0xB7,"PrintScreen",[],
	0x46,"ScrollLock",[],
	0xC5,"Pause",[],
	0xD2,"Insert",[],
	0xD3,"Delete",[],
	0xC7,"Home",[],
	0xCF,"End",[],
	0xC9,"PageUp",[],
	0xD1,"PageDown",[],

	0xC8,"Up",[],
	0xCB,"Left",[],
	0xD0,"Down",[],
	0xCD,"Right",[],

	0x45,"NumLock",[],
	0xB5,"NumSlash",[],
	0x37,"NumAsterisk",[],
	0x4A,"NumMinus",[],
	0x4E,"NumPlus",[],
	0x53,"NumSeparator",[],
	0x9C,"NumEnter",[],
	0x4F,"Num1",[],
	0x50,"Num2",[],
	0x51,"Num3",[],
	0x4B,"Num4",[],
	0x4C,"Num5",[],
	0x4D,"Num6",[],
	0x47,"Num7",[],
	0x48,"Num8",[],
	0x49,"Num9",[],
	0x52,"Num0",[]
];

_cfg = configfile >> "CfgDefaultKeysMapping";
for "_i" from 0 to (count _cfg - 1) do {
	_action = _cfg select _i;
	_actionName = configname _action;
	if ({_actionName == _x} count _categoryArray > 0 || _categoryAll) then {
		_keys = getarray _action;
		{
			_key = _x;
			if (typename _key == typename "") then {
				_key = call compile _key;
			};
			_selector = 0;
			_selectorName = "";
			if (typename _key == typename []) then {
				_selector = _key select 0;
				_key = _key select 1;		
			};
			if (_key >= _limit && _key < 1000 && _selector == _limitSelector) then {
				if (_limit > 0) then {_key = _key % _limit};
				_id = _template find _key;
				if (_id >= 0) then {
					_templateName = _template select (_id + 1);
					_templateArray = _template select (_id + 2);
					_templateArray set [count _templateArray,_selectorName + _actionName];
				};
			};
		} foreach _keys;
	};
};
_result = "{{Keyboard
";
for "_i" from 0 to (count _template - 3) step 3 do {
	_templateName = _template select (_i + 1);
	_templateArray = _template select (_i + 2);
	_templateText = "";
	{
		_templateText = _templateText + _x + "<br />";
	} foreach _templateArray;
	_result = _result + "|" + _templateName + " = " + _templateText + "
";
};
_result = _result + "}}";
copytoclipboard _result;

endloadingscreen;
