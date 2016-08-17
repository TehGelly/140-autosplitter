state("140")
{
	bool isDying : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;

	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;

	int hubtimer : "140.exe", 0x959160, 0x120, 0x29C, 0x308, 0x468, 0xF8;
	int timerOne : "140.exe", 0x92C624, 0x318, 0x42C, 0x19C, 0x730, 0x64;

	bool OrbLvlOne : "140.exe", 0x92C624, 0x7FC, 0x1C4, 0x768, 0x80, 0x15C;
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
		if (vars.splitEnable && current.hubtimer == 3)
		{
			vars.num++;
			vars.loadEnable = true;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num < 6)
	{
		vars.splitEnable |= !current.OrbLvlOne && old.OrbLvlOne && !current.isDying;
		if (vars.splitEnable && current.timerOne % 4 == 3)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num == 6)
	{
		// TODO: Implement + return value
	}
	else if (vars.num < 11)
	{

	}
	else if (vars.num == 11)
	{

	}
	else if (vars.num < 16)
	{

	}
	else
	{
		// TODO : Boss split
	}
}

isLoading
{
	if (vars.loadEnable)
	{
		if (current.timerOne > 0)
		{
			vars.loadEnable = false;
			return false;
		}
		else
		{
			return true;
		}
	}

	// TODO: Loadless for more levels
}
