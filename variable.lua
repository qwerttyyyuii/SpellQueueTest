local _, SpellQueueTest = ...

SpellQueueTest.const = {
	str_sqt = "|c00008000SpellQueueTest|r",
	queuemin = 0,
	queuemax = 400,
	width = 90,
	height = 30,
	margin = 40,
	frame_x = 0,
	frame_y = 250,
	open = "▼",
	close = "▲",
	--open = ">>>",
	--close = "<<<",
}
SpellQueueTest.avg = {
	sum = 0,
	cnt = 0,
}
SpellQueueTest.spellinfo = {
	smite = {
		spellID = 585,
		castTime = 1500,
	},
}
SpellQueueTest.Settings = {
	Autorun = true,
}