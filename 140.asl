state("140")
{
	// death variables
	bool isDyingOne : "140.exe", 0x959164, 0x3A0, 0x3D8, 0x714, 0xAC, 0x12C;
	bool isDyingTwo : "140.exe", 0x959164, 0x4FC, 0x5B0, 0x574, 0x30, 0xC0;
	bool isDyingThree : "140.exe", 0x959164, 0x7AC, 0x720, 0x304, 0x7D4, 0xC0;

	// velocities
	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;
	float verticalOne : "140.exe", 0x95915C, 0xA4, 0x2F8, 0x620, 0x38, 0xD4;
	float verticalTwo : "140.exe", 0x95915C, 0x13C, 0x98, 0x2CC, 0x41C, 0xD4;
	float verticalThree : "140.exe", 0x95915C, 0x230, 0x744, 0x504, 0x1C8, 0xD4;

	// timers
	int timer : "140.exe", 0x95A74C;
	
	// orbs
	bool orb : "140.exe", 0x959104, 0x54, 0x30, 0x70, 0x14, 0x6C;
	bool orb2 : "140.exe", 0x95915C, 0x770, 0x324, 0x620, 0x54, 0xC;
	bool orb3 : "140.exe", 0x95915C, 0x230, 0x744, 0x620, 0x5C, 0x3C;

	// boss var
	int bossStage : "140.exe", 0x95915C, 0x5F8, 0x4CC, 0x5D4, 0x218, 0x24C; 

}

init
{
	//changing variables
	vars.num = 0;
	vars.loadEnable = false;
	vars.splitEnable = false;
	vars.bossSplitEnable = false;
	vars.goopybutts = 0;
	vars.wait = 0;


	//const
	refreshRate = 120;
	vars.CYCLE = 16;
	vars.PLACE = 15;
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

	if(vars.num<7)
	{
		vars.splitEnable |= old.orb && !current.orb && 
			((vars.num==6||vars.num==0)?true:!(current.isDyingOne||old.isDyingOne));
	}
	else if(vars.num < 12)
	{
		vars.splitEnable |= old.orb2 && !current.orb2 && 
			((vars.num==11)?true:!(current.isDyingTwo||old.isDyingTwo));
	}
	else if(vars.num < 16)
	{
		vars.splitEnable |= old.orb3 && !current.orb3 && 
			!(current.isDyingThree||old.isDyingThree);
	}
	else
	{
		if(old.bossStage == 8 && current.bossStage == 0)
		{
			vars.goopybutts++;
			vars.bossSplitEnable = vars.goopybutts >= 2;
		}

		if(vars.bossSplitEnable && current.bossStage == 8)
		{
			vars.wait++;
			if(vars.wait == 170)
			{
				return true;
			}
		}
	}

	if (vars.splitEnable && current.timer%vars.CYCLE == vars.PLACE)
	{
		vars.num++;
		vars.splitEnable = false;
		vars.loadEnable = (vars.num == 1) || (vars.num==7) || (vars.num==12);
		return true;
	}
}

isLoading
{
	if (vars.loadEnable)
	{
		if (vars.num == 1 && current.verticalOne > -2 && old.verticalOne < -4)
		{
			vars.loadEnable = false;
			return false;
		}
		else if(vars.num == 7 && current.verticalTwo > -2 && old.verticalTwo < -4)
		{
			vars.loadEnable = false;
			return false;
		}
		else if(vars.num == 12 && current.verticalThree > -2 && old.verticalThree < -4)
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
