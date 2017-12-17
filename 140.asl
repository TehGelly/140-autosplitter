startup
{
	var result = MessageBox.Show(timer.Form,
		"This autosplitter script is obsolete.\n"
		+ "Please disable this script in LiveSplit and use the timer mod instead.\n"
		+ "\nClick OK to open the mod's website.",
		"140 Autosplitter script",
		MessageBoxButtons.OKCancel,
		MessageBoxIcon.Information);

	if (result == DialogResult.OK)
	{
		Process.Start("https://github.com/Dalet/140-speedrun-timer/blob/master/README.md");
	}
}
