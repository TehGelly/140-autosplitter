state("140")
{
	bool isDying : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;
	int timer : "140.exe", 0x9D53CC, 0x658, 0x180, 0x3A0, 0x1B4, 0x344;
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;

	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;

	int timerOne : "140.exe", 0x92C624, 0x360, 0x670, 0x4BC, 0x16C, 0x2C;
	
	int orb : "140.exe", 0x92C624, 0x9C, 0x14, 0x10, 0x188, 0x10;
	bool orb2 : "140.exe", 0x95915C, 0x778, 0x4DC, 0x214, 0x84, 0x6C;

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
		if (vars.splitEnable && current.timer == 3)
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
		if (vars.splitEnable && current.timer == 8)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num == 6)
	{
		vars.splitEnable |= current.orb == 0 && old.orb != 0;
		if(vars.splitEnable && current.timer == 8)
		{
			vars.num++;
			vars.splitEnable = false;
			vars.loadEnable = true;
			return true;
		}
	}
	else if (vars.num < 11)
	{
		vars.splitEnable |= old.orb2 && !current.orb2 && !current.isDying;
		if (vars.splitEnable && current.timer == 8)
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
		else if(current.timer > 1 && vars.num == 7)
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
