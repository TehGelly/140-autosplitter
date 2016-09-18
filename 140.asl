state("140")
{
	int keyCount : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0x54, 0xc;

	float horizontalHub : "140.exe", 0x959164, 0x76C, 0x41C, 0x5C, 0xD0;
	float vOne : "140.exe", 0x95915C, 0xA4, 0x2F8, 0x620, 0x38, 0xD4;
	float vTwo : "140.exe", 0x95915C, 0x13C, 0x98, 0x2CC, 0x41C, 0xD4;
	float vThree : "140.exe", 0x95915C, 0x230, 0x744, 0x504, 0x1C8, 0xD4;

	int bossOne : "140.exe", 0x95915C, 0x13C, 0x214, 0x5C8, 0xC0, 0x24;
	bool bossChord : "140.exe", 0x95915C, 0x7BC, 0x54C, 0x5E8, 0x518, 0xE4;
}

startup
{
	// not in state because we don't need to read this often
	vars.currentKeyPtr = new DeepPointer(0x95A788, 0x30, 0x98, 0x8, 0x14, 0x54, 0x8, 0x10);
}

init
{
	vars.currentKeyUsed = null;
	vars.loadEnable = false;
	vars.num = 0;
}

update
{
	if (current.keyCount == 1 && (old.keyCount == 0 || vars.currentKeyUsed == null))
	{
		var keyAddr = (IntPtr)vars.currentKeyPtr.Deref<uint>(game);
		var keyUsedAddr = IntPtr.Add(keyAddr, 0xC5); // Key:colorSphereHasBeenOpened
		vars.currentKeyUsed = new MemoryWatcher<bool>(keyUsedAddr);
	}

	if (vars.currentKeyUsed != null)
		vars.currentKeyUsed.Update(game);
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
	if(vars.num == 6)
	{
		if(current.bossOne == 8)
		{
			vars.num++;
			return true;
		}
	}
	else if(vars.num == 12)
	{
		if(old.vTwo == 18 && current.vTwo < 18)
		{
			vars.num++;
			return true;
		}
	}
	else if(vars.num == 18)
	{
		if(current.bossChord)
		{
			return true;
		}
	}
	else if (vars.currentKeyUsed != null && vars.currentKeyUsed.Current && current.keyCount == 0)
	{
		vars.currentKeyUsed = null;
		vars.num++;	
		print(vars.num.ToString());
		vars.loadEnable = (vars.num == 1) || (vars.num==8) || (vars.num==14);
		return true;
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