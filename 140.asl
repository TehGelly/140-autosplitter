state("140")
{
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;
	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;
	bool isDying : "140.exe", 0x9587C4, 0xA8, 0x84, 0x1A4, 0x3B8, 0x124;
	bool OrbLvlOne : "140.exe", 0x92C624, 0x7FC, 0x1C4, 0x768, 0x80, 0x15C;
	int hubtimer : "140.exe", 0x959160, 0x120, 0x29C, 0x308, 0x468, 0xF8;
	int timerOne : "140.exe", 0x92C624, 0x318, 0x42C, 0x19C, 0x730, 0x64;
}

init
{
	vars.num = 0;
	vars.loadEnable = false;
	vars.splitEnable = false;
}

start
{
	if (current.horizontalHub != 0)
	{
		return true;
	}
}

split
{
	if (vars.num == 0)
	{
		vars.splitEnable |= (current.horizontalHub < old.horizontalHub);
		if (current.hubtimer == 3 && vars.splitEnable)
		{
			vars.num++;
			vars.loadEnable = true;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num < 7)
	{
		vars.splitEnable |= !current.OrbLvlOne && old.OrbLvlOne && !current.isDying;
		if (current.timerOne % 16 == 3 && vars.splitEnable)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num == 7)
	{
		// TODO: Implement + return value
	}
	else
	{
		return true;
	}
	// TODO: Return value
}

isLoading
{
	if (vars.loadEnable)
	{
		if ((current.verticalOne - old.verticalOne) < 0.4)
		{
			return true;
		}
		else
		{
			vars.loadEnable = false;
			return false;
		}
	}
}
