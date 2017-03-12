if (isServer) then {
	diag_log "Loading custom server compiles";	
};

if (!isDedicated) then {
	diag_log "Loading custom client compiles";
	
	fnc_usec_selfactions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";
	player_humanityMorph = compile preprocessFileLineNumbers "dayz_code\compile\player_humanityMorph.sqf"; // This line can be removed when Epoch 1.0.6.2 comes out.
};
