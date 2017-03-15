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
		ctrlSetText [13001,format ["Can not get vehicle capacity!","test"]];
		ctrlSetText [13002,format ["Can not get vehicle capacity!","test"]];
	};
};

GivePlayerDialogAmounts = {
	ctrlSetText [14001, format ["%1 %2",[player getVariable [Z_MoneyVariable,0]] call BIS_fnc_numberText,CurrencyName]];
	ctrlSetText [14003,format ["%1",(name ZSC_GiveMoneyTarget)]];
};

BankDialogWithdrawAmount = {
	private ["_amount","_bank","_wealth","_vehicleType","_displayName"];

	_amount = parseNumber (_this select 0);	
	_bank = ZSC_CurrentStorage getVariable [Z_MoneyVariable,0];
	_wealth = player getVariable[Z_MoneyVariable,0];
	_vehicleType = typeOf ZSC_CurrentStorage;
	_displayName = getText (configFile >> "CfgVehicles" >> _vehicleType >> "displayName");

	if (!isNull ZSC_CurrentStorage) then {
		if ((_amount < 1) or {_amount > _bank}) exitWith {format ["You can not withdraw more %1 than is in the %2.",CurrencyName,_displayName] call dayz_rollingMessages;};

		player setVariable[Z_MoneyVariable,(_wealth + _amount),true];
		ZSC_CurrentStorage setVariable[Z_MoneyVariable,(_bank - _amount),true];
		call player_forceSave;

		PVDZ_veh_Save = [ZSC_CurrentStorage,"coins"];
		publicVariableServer "PVDZ_veh_Save";

		format ["You have withdrawn %1 %2 out of the %3",[_amount] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	} else {
		"Unable to access Money Storage. Please try again." call dayz_rollingMessages;
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

	_amount = parseNumber (_this select 0);
	_bank = ZSC_CurrentStorage getVariable [Z_MoneyVariable,0];
	_wealth = player getVariable[Z_MoneyVariable,0];
	
	if ((_amount < 1) or {_amount > _wealth}) exitWith {"You can not deposit more than what you have." call dayz_rollingMessages;};

	if ((_bank + _amount) > _maxCap) then {
		format ["You can only store a maximum of %1 %2 into the %3.",[_maxCap] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	} else {
		player setVariable[Z_MoneyVariable,(_wealth - _amount),true];
		ZSC_CurrentStorage setVariable[Z_MoneyVariable,(_bank + _amount),true];
		format ["You have deposited %1 %2 into the %3.",[_amount] call BIS_fnc_numberText,CurrencyName,_displayName] call dayz_rollingMessages;
	};

	call player_forceSave;
	PVDZ_veh_Save = [ZSC_CurrentStorage,"coins"];
	publicVariableServer "PVDZ_veh_Save";
};

GivePlayerAmount = {
	private ["_amount","_wealth","_twealth","_isBusy"];

	_amount = parseNumber (_this select 0);
	_wealth = player getVariable[Z_MoneyVariable,0];
	_twealth = ZSC_GiveMoneyTarget getVariable[Z_MoneyVariable,0];
	_isBusy = ZSC_GiveMoneyTarget getVariable ["isBusy",false];
	_vehicleType = typeOf ZSC_GiveMoneyTarget; 

	if ((_amount < 1) or {_amount > _wealth}) exitWith {"You can not give more than you currently have." call dayz_rollingMessages;};

	if (!(isPlayer ZSC_GiveMoneyTarget)) exitWith {"You can only give money to a player" call dayz_rollingMessages;};

	if (_isBusy) exitWith {format ["%1 is already trading, please try again.",name ZSC_GiveMoneyTarget] call dayz_rollingMessages;};

	player setVariable[Z_MoneyVariable,_wealth - _amount,true];
	ZSC_GiveMoneyTarget setVariable[Z_MoneyVariable,_twealth + _amount,true];

	call player_forceSave;
	ZSC_GiveMoneyTarget call player_forceSave;

	format ["You gave %1 %2 %3.",name ZSC_GiveMoneyTarget,[_amount] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
};
