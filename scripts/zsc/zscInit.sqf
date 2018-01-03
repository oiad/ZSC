fnc_sanitizeInput = {
	private ["_input","_badChars"];

	_input = _this;
	_input = toArray (_input);
	_badChars = [60,62,38,123,125,91,93,59,58,39,96,126,44,46,47,63,124,92,34];

	{
		_input = _input - [_x];
	} forEach _badChars;
	
	_input = parseNumber (toString (_input));
	_input
};

BankDialogUpdateAmounts = {
	private ["_vehicleType","_displayName","_sizeOfMoney"];

	_vehicleType = typeOf ZSC_CurrentStorage;
	if (isClass(configFile >> "CfgVehicles" >> _vehicleType)) then {
		_vehicleMagazines = getNumber (configFile >> "CfgVehicles" >> _vehicleType >> "transportMaxMagazines");
		if (_vehicleMagazines == 0) then {_vehicleMagazines = ZSC_defaultStorageMultiplier};
		_displayName = getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName");
		_sizeOfMoney = _vehicleMagazines * ZSC_MaxMoneyInStorageMultiplier;
		ctrlSetText [2701, format ["%1",_displayName]];
		ctrlSetText [13001,format ["%1 %2",[player getVariable [Z_MoneyVariable,0]] call BIS_fnc_numberText,CurrencyName]];
		ctrlSetText [13002,format ["%1 / %3 %2",[ZSC_CurrentStorage getVariable [Z_MoneyVariable,0]] call BIS_fnc_numberText,CurrencyName,[_sizeOfMoney] call BIS_fnc_numberText]];
	} else {
		ctrlSetText [13001,localize "STR_ZSC_VEHICLE_CAPACITY"];
		ctrlSetText [13002,localize "STR_ZSC_VEHICLE_CAPACITY"];
	};
};

GivePlayerDialogAmounts = {
	ctrlSetText [14001, format ["%1 %2",[player getVariable [Z_MoneyVariable,0]] call BIS_fnc_numberText,CurrencyName]];
	ctrlSetText [14003,format ["%1",name ZSC_GiveMoneyTarget]];
};

BankDialogWithdrawAmount = {
	private ["_amount","_bank","_wealth","_vehicleType","_displayName"];

	_amount = (_this select 0) call fnc_sanitizeInput;
	_bank = ZSC_CurrentStorage getVariable [Z_MoneyVariable,0];
	_wealth = player getVariable[Z_MoneyVariable,0];
	_vehicleType = typeOf ZSC_CurrentStorage;
	_displayName = getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName");

	if (!isNull ZSC_CurrentStorage) then {
		if ((_amount < 1) or {_amount > _bank}) exitWith {format [localize "STR_ZSC_WITHDRAW_FAIL",CurrencyName,_displayName] call dayz_rollingMessages;};

		player setVariable[Z_MoneyVariable,(_wealth + _amount),true];
		ZSC_CurrentStorage setVariable[Z_MoneyVariable,(_bank - _amount),true];
		call player_forceSave;

		PVDZ_veh_Save = [ZSC_CurrentStorage,"coins"];
		publicVariableServer "PVDZ_veh_Save";

		format [localize "STR_ZSC_WITHDRAW_OK",[_amount] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	} else {
		localize "STR_ZSC_UNABLE" call dayz_rollingMessages;
	};
};

BankDialogDepositAmount = {
	private ["_amount","_bank","_wealth","_maxCap","_vehicleType","_displayName","_vehicleMagazines"];

	_vehicleType = typeOf ZSC_CurrentStorage; 
	_maxCap = 0;
	_displayName = "Storage";
	if (isClass(configFile >> "CfgVehicles" >> _vehicleType)) then {
		_displayName = getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName");
		_vehicleMagazines = getNumber (configFile >> "CfgVehicles" >> _vehicleType >> "transportMaxMagazines");
		_maxCap = _vehicleMagazines * ZSC_MaxMoneyInStorageMultiplier;
	} else {
		_displayName = "Unknown";
	};

	_amount = (_this select 0) call fnc_sanitizeInput;
	_bank = ZSC_CurrentStorage getVariable [Z_MoneyVariable,0];
	_wealth = player getVariable[Z_MoneyVariable,0];

	if ((_amount < 1) or {_amount > _wealth}) exitWith {format [localize "STR_ZSC_DEPOSIT_FAIL",CurrencyName] call dayz_rollingMessages;};

	if ((_bank + _amount) > _maxCap) then {
		format [localize "STR_ZSC_STORE_FAIL",[_maxCap] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	} else {
		player setVariable[Z_MoneyVariable,(_wealth - _amount),true];
		ZSC_CurrentStorage setVariable[Z_MoneyVariable,(_bank + _amount),true];
		format [localize "STR_ZSC_DEPOSIT_OK",[_amount] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	};

	call player_forceSave;
	PVDZ_veh_Save = [ZSC_CurrentStorage,"coins"];
	publicVariableServer "PVDZ_veh_Save";
};

GivePlayerAmount = {
	private ["_amount","_wealth","_twealth","_isBusy"];

	_amount = (_this select 0) call fnc_sanitizeInput;
	_wealth = player getVariable[Z_MoneyVariable,0];
	_twealth = ZSC_GiveMoneyTarget getVariable[Z_MoneyVariable,0];
	_isBusy = ZSC_GiveMoneyTarget getVariable ["isBusy",false];
	_vehicleType = typeOf ZSC_GiveMoneyTarget; 

	if ((_amount < 1) or {_amount > _wealth}) exitWith {format [localize "STR_ZSC_GIVE_FAIL",CurrencyName] call dayz_rollingMessages;};

	if (!(isPlayer ZSC_GiveMoneyTarget)) exitWith {format [localize "STR_ZSC_GIVE_PLAYER",CurrencyName] call dayz_rollingMessages;};

	if (_isBusy) exitWith {format [localize "STR_ZSC_ALREADY_TRADING",name ZSC_GiveMoneyTarget] call dayz_rollingMessages;};

	player setVariable[Z_MoneyVariable,_wealth - _amount,true];
	ZSC_GiveMoneyTarget setVariable[Z_MoneyVariable,_twealth + _amount,true];

	call player_forceSave;

	format [localize "STR_ZSC_GIVE_OK",name ZSC_GiveMoneyTarget,[_amount] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
};
