#line 0 "/temp/bin/A3/Functions_F/Numbers/fn_parseNumber.sqf"












private ["_number"];
_number = _this param [0,-1,[0,"",{},configfile]];
switch (typename _number) do {

	case (typename {}): {
		_number = call _number;
		if (isnil {_number}) then {_number = -1;};
		_number
	};

	case (typename ""): {
		_number = call compile _number;
		if (isnil {_number}) then {_number = -1;};
		_number
	};

	case (typename configfile): {

		if (isnumber _number) then {
			getnumber _number
		} else {
			if (istext _number) then {
				(gettext _number) call bis_fnc_parsenumber
			} else {
				-1
			};
		};
	};

	default {_number};
};
