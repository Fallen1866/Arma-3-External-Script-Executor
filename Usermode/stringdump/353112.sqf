#line 0 "/temp/bin/A3/Functions_F/Misc/fn_healthEffects_handleDamage_code.sqf"
_unit = _this select 0;
_damageReal = _this select 2;
_damageUnit = damage _unit;
_damage = _damageReal - _damageUnit; 

if (_unit == player && alive player && (_damage > 0 || _damageReal < 0)) then {
	_hitpart = _this select 1;
	if (_hitpart == "") then {
		private ["_dir","_dirToFront","_dirToEnd","_dirTotal"];
		_shooter = _this select 3;

		
		_delayFade = 2 + (_damageUnit * 4);
		_colorRGB = [0.3,0.0,0.0];
		_coefFront = 0.2;
		_coefSide = 0.25;
		_coefBack = 0.25;
		_coefIncapacitated = 0.3;
		_permanentEffectThreshold = 0.35;

		
		if (lifestate _unit == "INCAPACITATED") then {
			_shooter = _unit;
			_incapacitatedCoef = ((_damageUnit max 0.85) - 0.85) / 0.15;
			_coefFront = _coefIncapacitated + (0.05 * sin (time * (50 + 100 * _incapacitatedCoef)));

			_adjust = [
				1,
				1,
				0,
				_colorRGB + [0.4 * _incapacitatedCoef],
				[1,1,1,(1 - _incapacitatedCoef) max 0],
				[0.7,0.7,0.7,0]
			];

			BIS_fnc_healthEffects_colorCorrection_incapacitated ppeffectadjust _adjust;
			BIS_fnc_healthEffects_colorCorrection_incapacitated ppeffectcommit 0;
			BIS_fnc_healthEffects_colorCorrection_incapacitated ppeffectenable true;

			
			_adjust set [3,_colorRGB + [0]];
			_adjust set [4,[1,1,1,1]];
			BIS_fnc_healthEffects_colorCorrection_incapacitated ppeffectadjust _adjust;
			BIS_fnc_healthEffects_colorCorrection_incapacitated ppeffectcommit _delayFade;
		};

		
		if (_damage > 0.07) then {

			
			if (
				
				_unit == _shooter
				||
				
				vehicle _unit != _unit
				||
				
				isnull _shooter
			) then {
				_dir = 0;
				_dirToFront = 1;
				_dirToEnd = 0;
				_dirTotal = 0;
			} else {
				_dir = [_unit,_shooter] call bis_fnc_relativedirto;
				_dirToFront = (180 - _dir) / 180;
				_dirToEnd = (abs _dirToFront / _dirToFront) - _dirToFront;
				_dirTotal = abs _dirToFront * _dirToEnd * 4;
			};

			
			_sizeCoef = 0.85 - (_coefFront * abs _dirToFront);
			_offsetX = -_dirTotal * _coefSide;
			_offsetY = - abs (_dirToEnd^2) * _coefBack;
			_sizeX = _sizeCoef;
			_sizeY = _sizeCoef;

			
			_colorAlpha = 0.4 + 0.3 * (_damage min 1);

			_adjust = [
				1,
				1,
				0,
				_colorRGB + [_colorAlpha],	
				[1,1,1,1],
				[0.3,0.3,0.3,0],
				[
					_sizeX,		
					_sizeY,		
					0,		
					_offsetX,	
					_offsetY,	
					0.5,		
					1		
				]
			];

			
			BIS_fnc_healthEffects_colorCorrection ppeffectadjust _adjust;
			BIS_fnc_healthEffects_colorCorrection ppeffectcommit 0;

			
			_adjust set [3,_colorRGB + [0]];
			BIS_fnc_healthEffects_colorCorrection ppeffectadjust _adjust;
			BIS_fnc_healthEffects_colorCorrection ppeffectcommit _delayFade;
		};

		
		_damageUnitReduced = if (_damageUnit > _permanentEffectThreshold) then {_damageUnit} else {0};
		_adjust = [
			1,
			1,
			(_damageUnitReduced / 4),
			[0.2,0,0,0.2],		
			[1,1,1,1 - _damageUnitReduced],
			[0.3,0.3,0.3,0],
			[
				1 - _damageUnitReduced / 3,	
				1.2,				
				0,				
				0,				
				0,				
				0.1,				
				1				
			]
		];
		BIS_fnc_healthEffects_colorCorrection_radial ppeffectadjust _adjust;
		BIS_fnc_healthEffects_colorCorrection_radial ppeffectcommit 0;

		
		_adjust = [
			0.007 * _damageUnitReduced,	
			0,				
			0.25,				
			0.25				
		];
		BIS_fnc_healthEffects_radialBlur ppeffectadjust _adjust;
		BIS_fnc_healthEffects_radialBlur ppeffectcommit 0;
	};
};
_damageReal

