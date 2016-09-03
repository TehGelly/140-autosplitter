state("140")
{
	// global variables
	bool isDying : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;

	// velocities
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;
	float verticalOne : "140.exe", 0x9590A0, 0x0, 0x614, 0x30, 0x11C, 0xD4;
	float verticalTwo : "140.exe", 0x959164, 0x560, 0x4FC, 0x688, 0x3C8, 0x2E0;

	// timers
	int hubtimer : "140.exe", 0x959160, 0x120, 0x29C, 0x308, 0x468, 0xF8;
	int timerTwo : "140.exe", 0x960A1C, 0x494, 0x5B0, 0x130, 0x4F8, 0xC;
	int timerOne : "140.exe", 0x92C624, 0x360, 0x670, 0x4BC, 0x16C, 0x2C;
	
	// orbs
	bool orb : "140.exe", 0x959104, 0x54, 0x30, 0x70, 0x14, 0x6C;
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
		vars.splitEnable |= !current.orb && old.orb;
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
		vars.splitEnable |= !current.orb && old.orb && !current.isDying;
		if (vars.splitEnable && current.timerOne%8 == 3)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num == 6)
	{
		vars.splitEnable |= !current.orb && old.orb && !current.isDying;
		if (vars.splitEnable && current.timerTwo%8 == 3)
		{
			vars.num++;
			vars.splitEnable = false;
			return true;
		}
	}
	else if (vars.num < 11)
	{
		vars.splitEnable |= old.orb2 && !current.orb2 && !current.isDying;
		if (vars.splitEnable && current.timerTwo == 8)
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
		if (vars.num == 1 && current.timerOne == 1)
		{
			vars.loadEnable = false;
			return false;
		}
		else if(vars.num == 7 && current.verticalTwo > -2 && old.verticalTwo < -4)
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
