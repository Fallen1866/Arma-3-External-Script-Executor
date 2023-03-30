#line 0 "/temp/bin/A3/Functions_F/Effects/fn_effectFiredHeliRocket.sqf"
params["","","","","","","_Sh"];
private _p = getpos _sh;


drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,2,32], "", "Billboard", 1,(0.1 + random 0.1),
[0, -1.3,0],
[0, -2, 0], 0, 10, 7.9, 0.075, [1,3],
[[1, 1, 1, -2], [1, 1, 1, -2],
[1, 1, 1, -1], [1, 0.5, 1, -0]],
[5], 1, 0, "", "", _sh];

private _col	= [[0.7,0.7,0.7,0.5],[0.7,0.7,0.7,0.4],[0.7,0.7,0.7,0.35],[0.8,0.8,0.8,0.18],[0.9,0.9,0.9,0.08], [1,1,1,0.02]];
private _i		= 1;
private _no		= 8+random 1;

while {_i<_no}do
{
	drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48], "", "Billboard", 1, 1, [0, - 2.3, 0],
	[-0.2+random 0.6,-0.8*_i,random 1], 1, 1, 0.80, 0.08, [1.3,6.5,9 + random 1],_col,[2,0.7,0.5],0.1,1.5,"","",_sh];
	_i=_i+1;
};




if ((abs(_p select 2) < 2) and !(surfaceiswater _p)) then
{
	private _vec = vectordir _sh;
	private _no= 20 + random 7;
	_i=0;
	while {_i<_no} do
	{
		drop [["\A3\data_f\ParticleEffects\Universal\Universal.p3d", 16, 12, 13, 0], "", "Billboard", 1, 7,
		[_p select 0, _p select 1, 0], [-((_vec select 0) -0.5 +(random 1))*4,
		-((_vec select 1) -0.5 +(random 1))*4, 0.3 + random 0.3],
		0, 0.104, 0.08, 0.04, [2,4], [[0.6, 0.5, 0.4, 0],[0.6, 0.5, 0.4, 0.4], [0.6, 0.5, 0.4, 0.2],
		[0.6, 0.5, 0.4, 0]], [1000], 1, 0, "", "", ""];
		_i=_i + 1;
	};
};


