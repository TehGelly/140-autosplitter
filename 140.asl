state("140")
{
	bool isDying : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;

	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;

	int hubtimer : "140.exe", 0x959160, 0x120, 0x29C, 0x308, 0x468, 0xF8;
	int timerOne : "140.exe", 0x92C624, 0x360, 0x670, 0x4BC, 0x16C, 0x2C;
	
	int orb : "140.exe", 0x92C624, 0x9C, 0x14, 0x10, 0x188, 0x10;
	int timerTwo : "140.exe", 0x93318C, 0x4C, 0x14, 0x220, 0x2D0, 0x1CC;
}

init
{
	vars.num = 0;
	vars.loadEnable = false;
	vars.splitEnable = false;
	refreshRate = 120;
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
		vars.splitEnable |= (current.horizontalHub<old.horizontalHub);
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
		vars.splitEnable |= current.orb == 0 && old.orb !=0 && !current.isDying;
		if (vars.splitEnable && current.timerOne % 8 == 3)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num == 6)
	{
		if(current.orb == 0 && old.orb != 0)
		{
			vars.num++;
			vars.splitEnable = false;
			vars.loadEnable = true;
			return true;
		}
	}
	else if (vars.num < 11)
	{
		vars.splitEnable |= current.orb == 0 && old.orb !=0 && !current.isDying;
		if (vars.splitEnable && current.timerTwo % 8 == 3)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
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
		if (current.timerOne > 0 && vars.num == 1)
		{
			vars.loadEnable = false;
			return false;
		}
		else if(current.timerTwo > 1 && vars.num == 7)
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
