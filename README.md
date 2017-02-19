# [EPOCH 1.0.6+] Zupa Single Currency
Zupas Single Currency script updated for Epoch 1.0.6+ by salival.

	(original install url: https://github.com/EpochSC/SingleCurrencyStorage)
	(original discussion url: https://epochmod.com/forum/topic/28493-alpha-release-single-currency-30-storage-default-hive-no-global-banking/)
	
* Tested as working on a blank Epoch 1.0.6+ and OverWatch 0.25 server (THIS IS FOR OVERWATCH!).
* Designed to minimize duping/glitching of bank related saving with nearby players (checkWallet etc).
* Lots of code snippets taken from the original Zupa release thread to stop multiple people checking wallet/depositing into the same safe etc.
* Does not support depositing/withdrawing from vehicles, since I only wanted my players to trade with unlocked lockboxes/safes. You can change this if you like.

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible. 
* This has all the config traders set up for epoch 1.0.6 items and OverWatch guns/items. ***YOU WILL NEED TO EDIT THESE IF YOU DO NOT WANT OVERWATCH.***

**[>> Download <<] (https://github.com/oiad/ZSC/archive/master.zip)**

# Mission folder install:

1. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";</code> Add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf";
	```
	
2. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";</code> Add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";
	```

3. In mission\init.sqf find: <code>call compile preprocessFileLineNumbers "server_traders.sqf";</code> Replace with:

	```sqf
	call compile preprocessFileLineNumbers "scripts\traders\server_traders.sqf";
	```

4. In mission\init.sqf find: <code>waitUntil {scriptDone progress_monitor};</code> Add directly above:

	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscInit.sqf";
	execVM "scripts\zsc\playerHud.sqf";
	```

5. Replace your original description.ext with the one provided or merge the contents if you have modified your own version.

6. If you are running Epoch 1.0.6 and NOT running Epoch 1.0.6.1+ you must uncomment: 

	```sqf
	//player_humanityMorph = compile preprocessFileLineNumbers "dayz_code\compile\player_humanityMorph.sqf";
	```
	in the supplied <code>dayz_code\init\compiles.sqf</code> since it doesn't refresh coins on a skin change. Epoch 1.0.6.1+ fixes this issue so you do not need to uncomment it.

# dayz_server folder install:

1. Replace or merge the contents of <code>server_handleSafeGear.sqf</code> provided with your original copy.

2. Replace or merge the contents of <code>server_updateObject.sqf</code> provided with your original copy.

# Battleye filters install:

1. In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> or <code>5 "createDialog"</code> add this to the end of it:

	```sqf
	!="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```
	
So it will then look like this for example:
	```sqf
	5 "createDialog" <CUT> !="_dialog = createDialog \"BankDialog\";" !="_dialog = createdialog \"GivePlayerDialog\";"
	```