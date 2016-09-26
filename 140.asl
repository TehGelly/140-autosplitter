state("140")
{
	int keyCount : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0x54, 0xc;
	uint keyPtr : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0x54, 0x8, 0x10;

	float movementDirectionX : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0xD0;
	float movementDirectionY : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0xD4;

	int bossOne : 0x95915C, 0x13C, 0x214, 0x5C8, 0xC0, 0x24;
	bool bossChord : 0x95915C, 0x7BC, 0x54C, 0x5E8, 0x518, 0xE4;

	bool controlPaused : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0xbd;
	bool logicPaused : 0x95A788, 0x30, 0x98, 0x8, 0x14, 0xbf;
	int levelIndex : 0x92C620;
}

startup
{
	vars.timerModel = new TimerModel { CurrentState = timer };
}

init
{
	vars.init = true;
}

exit
{
	if (timer.CurrentPhase == TimerPhase.Running
		|| timer.CurrentPhase == TimerPhase.Paused)
		vars.timerModel.Reset();
}

update
{
	if (vars.init || (current.levelIndex == 0 && current.levelIndex != old.levelIndex))
	{
		vars.init = false;
		vars.currentKeyUsed = null;
		vars.num = 0;
		vars.loadEnable = false;
		vars.split = false;
	}

	if (current.keyCount > 0 && current.keyPtr != 0
		&& (current.keyPtr != old.keyPtr || vars.currentKeyUsed == null))
	{
		var keyUsedAddr = IntPtr.Add((IntPtr)current.keyPtr, 0xC5); // Key:colorSphereHasBeenOpened
		vars.currentKeyUsed = new MemoryWatcher<bool>(keyUsedAddr);
		print("Updated key address to " + current.keyPtr.ToString("X"));
	}

	if (vars.currentKeyUsed != null)
		vars.currentKeyUsed.Update(game);

	if (vars.num == 6)
	{
		if (current.bossOne == 8)
		{
			vars.num++;
			vars.split = true;
		}
	}
	else if(vars.num == 12)
	{
		if (old.movementDirectionY == 18 && current.movementDirectionY < 18)
		{
			vars.num++;
			vars.split = true;
		}
	}
	else if(vars.num == 18)
	{
		if (current.bossChord)
			vars.split = true;
	}
	else if (vars.currentKeyUsed != null && vars.currentKeyUsed.Current && current.keyCount == 0)
	{
		vars.currentKeyUsed = null;
		vars.num++;
		vars.loadEnable = (vars.num == 1 || vars.num == 8 || vars.num == 14);
		vars.split = true;
	}
}

start
{
	return current.levelIndex == 0 && !current.logicPaused && old.logicPaused != current.logicPaused;
}

reset
{
	if (current.levelIndex == 0 && current.controlPaused && old.controlPaused != current.controlPaused)
	{
		vars.init = true;
		return true;
	}
}

split
{
	if (vars.split)
	{
		vars.split = false;
		return true;
	}
}

isLoading
{
	if (vars.loadEnable)
	{
		// if the char comes to a sudden stop
		if (current.movementDirectionY == 0 && old.movementDirectionY < 0)
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
