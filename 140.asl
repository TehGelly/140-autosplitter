state("140")
{
	bool isDying : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;

	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;

	int hubtimer : "140.exe", 0x959160, 0x120, 0x29C, 0x308, 0x468, 0xF8;
	int timerOne : "140.exe", 0x30474, 0x5B4, 0x2AC, 0x2C, 0x10, 0x29C;
	
	int orb : "140.exe", 0x92C624, 0x9C, 0x14, 0x10, 0x188, 0x10;
	int timerTwo : "140.exe", 0x92D420, 0x5AC, 0x18, 0x1F4, 0x4F8, 0xC;
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
		vars.splitEnable |= (current.orb == 0 && old.orb != 0);
		if(vars.splitEnable && current.timerOne % 8 == 3)
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
