#line 0 "/temp/bin/A3/Functions_F/Scenes/fn_sceneRotate.sqf"









private["_center", "_angle", "_coord"];

_center 		= _this select 0;				
_centerAngle		= _this select 1;				
_angle 			= _this select 2;				
_coord	 		= _this select 3;				

private["_centerX", "_centerZ", "_centerY", "_angleOffset", "_coordX", "_coordZ", "_coordY", "_eye", "_newCoord", "_coordAndAngle"];

_centerX = (_center select 0);
_centerZ = (_center select 1);
_centerY = (_center select 2);

_angleOffset = 360 - _centerAngle;

_coordX 		= (_coord select 0)/100;						
_coordZ 		= ((_coord select 1)/100)*(-1);						
_coordY 		= ((_coord select 2)/100);
_eye			= (180 - _angle) - _angleOffset;					
		
_newCoord = [0, 0, 0];		
_newCoord set [0, _centerX + (_coordX * cos(_angleOffset) - _coordZ * sin(_angleOffset))];	
_newCoord set [1, _centerZ + (_coordX * sin(_angleOffset) + _coordZ * cos(_angleOffset))];	
_newCoord set [2, _coordY];									

_coordAndAngle = [[],0];

_coordAndAngle set [0, _newCoord];
_coordAndAngle set [1, _eye];

_coordAndAngle

