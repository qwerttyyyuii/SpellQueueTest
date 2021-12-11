local _, SpellQueueTest = ...

SpellQueueTest.const = {
	str_sqt = "|c00008000SpellQueueTest|r",
	sht_sqt = "|c00008000SQT|r",
	queuemin = 0,
	queuemax = 400,
	width = 90,
	height = 30,
	margin = 70,
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
	pre = 0,
}
SpellQueueTest.run = false
SpellQueueTest.cfg = nil
SpellQueueTest.Settings = {
	Autorun = true,
	AllSpell = true,
	cleanexit = false,
}