state("140")
{
	// death variables
	bool isDyingOne : "140.exe", 0x959164, 0x24C, 0x3B8, 0x7C8, 0x67C, 0xC0;
	bool isDyingTwo : "140.exe", 0x959164, 0x4FC, 0x5B0, 0x574, 0x30, 0xC0;
	bool isDyingThree : "140.exe", 0x959164, 0x24C, 0x72C, 0x608, 0x498, 0xC0;

	// velocities
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;
	float vOne : "140.exe", 0x95915C, 0xA4, 0x2F8, 0x620, 0x38, 0xD4;
	float vTwo : "140.exe", 0x95915C, 0x13C, 0x98, 0x2CC, 0x41C, 0xD4;
	float vThree : "140.exe", 0x95915C, 0x230, 0x744, 0x504, 0x1C8, 0xD4;

	// orbs
	bool orb : "140.exe", 0x959104, 0x54, 0x30, 0x70, 0x14, 0x6C;
	bool orb2 : "140.exe", 0x95915C, 0x770, 0x324, 0x620, 0x54, 0xC;
	bool orb3 : "140.exe", 0x95915C, 0x230, 0x744, 0x620, 0x5C, 0x3C;

	// boss var
	int bossOne : "140.exe", 0x95915C, 0x13C, 0x214, 0x5C8, 0xC0, 0x24;
	bool bossChord : "140.exe", 0x95915C, 0x7BC, 0x54C, 0x5E8, 0x518, 0xE4;

}

init
{
	// number of splits
	vars.num = 0;

	//enabling load on time
	vars.loadEnable = false;

	//enabling split on time
	vars.splitEnable = false;

	//for waiting frames
	vars.wait = 0;

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

// Boss splits and/or checking if to start the split

	if(vars.num < 6)
	{
		// hub-1 to 1-5
		vars.splitEnable |= old.orb && !current.orb && 
			!(current.isDyingOne||old.isDyingOne);
	}
	else if(vars.num == 6)
	{
	// boss-1
		if(current.bossOne == 8)
		{
			vars.num++;
			return true;
		}
	}
	else if(vars.num == 7)
	{
	// hub-2
		vars.splitEnable |= old.orb && !current.orb;
	}
	else if(vars.num < 12)
	{
	// 2-1 to 2-4
		vars.splitEnable |= old.orb2 && !current.orb2 && 
			!(current.isDyingTwo||old.isDyingTwo);
	}
	else if(vars.num == 12)
	{
	//boss 2
		if(old.vTwo == 18 && current.vTwo < 18)
		{
			vars.num++;
			return true;
		}
	}
	else if(vars.num == 13)
	{
	// hub-3
		vars.splitEnable |= old.orb2 && !current.orb2;
	}
	else if(vars.num < 18)
	{
	//3-1 to 3-4
		vars.splitEnable |= old.orb3 && !current.orb3 && 
			!(current.isDyingThree||old.isDyingThree);
	}
	else
	{
	// boss-3
		if(current.bossChord)
		{
			return true;
		}
	}

// Delaying by 10 frames if needed, allowing load enables and resetting variables

	if (vars.splitEnable && vars.wait==20)
	{
		print(vars.num.ToString());
		vars.num++;
		vars.wait = 0;
		vars.splitEnable = false;
		vars.loadEnable = (vars.num == 1) || (vars.num==8) || (vars.num==14);
		return true;
	}
	else if(vars.splitEnable)
	{
		vars.wait++;
	}
}

isLoading
{
	if (vars.loadEnable)
	{
	//picks the old and current vertical values
		vars.cvert = (vars.num==1)?(current.vOne):((vars.num==8)?(current.vTwo):(current.vThree));
		vars.overt = (vars.num==1)?(old.vOne):((vars.num==8)?(old.vTwo):(old.vThree));

	// if the char comes to a sudden stop
		if (vars.cvert > -2 && vars.overt < -4)
		{
			vars.loadEnable = false;
			return false;
		}
		else
		{
			return true;
		}
	}
}
