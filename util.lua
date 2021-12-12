local _, SpellQueueTest = ...

local const = SpellQueueTest.const
local L = SpellQueueTest.L
local GetCVar, GetNetStats = C_CVar.GetCVar, GetNetStats

function SpellQueueTest:resetvalue()
	self.avg.cnt = 0
	self.avg.sum = 0
	self.avg.pre = 0
end

function SpellQueueTest:tointeger(x)
	return x < 0 and math.ceil(x) or math.floor(x)
end

function SpellQueueTest:SQTprint(...)
	print(const.str_sqt, ...)
end

function SpellQueueTest:LogInsert(str)
	local frame = self.logFrame
	if not frame:IsShown() then
		self.ArrowButton:SetText(const.close)
		frame:Show()
	end
	frame.EditBox:Insert(const.sht_sqt.." "..str.."\n")
end

function SpellQueueTest:CloseEditor()
	self.ArrowButton:SetText(const.open)
	self.logFrame.EditBox:ClearFocus()
	self.logFrame:Hide()
end

function SpellQueueTest:BarEnable(isEnable)
	local val = 0.5
	self.SlideBar:Disable()
	self.EditBox:Disable()

	if isEnable then
		val = 1
		self.SlideBar:Enable()
		self.EditBox:Enable()
	end
	_G[self.SlideBar:GetName().."Low"]:SetVertexColor(1, 1, 1, val)
	_G[self.SlideBar:GetName().."High"]:SetVertexColor(1, 1, 1, val)
	_G[self.SlideBar:GetName().."Text"]:SetVertexColor(1, 1, 1, val)
	self.SlideBar.Center:SetVertexColor(1, 1, 1, val)
	_G[self.EditBox:GetName()]:SetTextColor(1, 1, 1, val)
end

function SpellQueueTest:CheckEnable(isEnable)
	local val = 0.5
	self.AllSpell:Disable()

	if isEnable then
		val = 1
		self.AllSpell:Enable()
	end
	_G[self.AllSpell:GetName().."Text"]:SetVertexColor(1, 1, 1, val)
end

function SpellQueueTest:InitFrame()
	self.run = false
	self.EventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:resetvalue()
	self.TestButton:Hide()
	self.StartButton:Show()
	self:BarEnable(false)
	self.EditBox:SetText(self:tointeger(self.SlideBar:GetValue()))
	self.ResultStr:SetText(L["wating"])
end

function SpellQueueTest:LogColor(val)
	local refmargin = 0.020
	local ref = 1.500 + refmargin
	local str
	local valstr = string.format("%.3f", val)
	val = tonumber(valstr)
	if val < ref then
		str = "|cFF00FF00"..valstr.."|r" -- Green
	elseif val == ref then
		str = "|cFFFFFFFF"..valstr.."|r" -- White
	elseif val > ref then
		str = "|cFFFF0000"..valstr.."|r" -- Red
	else
		str = "ERROR "..valstr
	end
	return str
end

function SpellQueueTest:CLEU(spellID, spellName)
	local cur = debugprofilestop() / 1000
	local avg = self.avg

	if avg.cnt == 0 then
		self:LogInsert(string.format(L["CVarSQW"].." %dms", GetCVar("SpellQueueWindow")))
		self:LogInsert(string.format("Ping ["..L["User"].."]%dms ["..L["Server"].."]%dms", select(3, GetNetStats())))
		self.ResultStr:SetText(L["Timebase"])
	else
		local dif = cur - avg.pre
		avg.sum = avg.sum + dif
		local Arithmean = self:LogColor(avg.sum / avg.cnt)
		self:LogInsert(string.format("% 3d ["..L["dif"].."]%s"..L["second"].." ["..L["avg"].."]%s"..L["second"].." % 6d %s",
									avg.cnt, self:LogColor(dif), Arithmean, spellID, spellName))
		self.ResultStr:SetText(string.format(L["result"], SpellQueueTest:TimeSeparate(avg.sum), avg.cnt, Arithmean))
	end
	avg.pre = cur
	avg.cnt = avg.cnt + 1
end

function SpellQueueTest:TimeSeparate(time)
	local sec, min = 60, 60 * 60
	local str

	if sec > time and time >= 0 then
		str = string.format("%.1f"..L["second"], time)
	elseif min > time and time >= sec then
		str = string.format("%02d:%02d", time / sec, time % sec)
	elseif time >= min then
		local hr = time % min
		str = string.format("%d:%02d:%02d", time / min, hr / sec, (hr % sec) % sec)
	end
	return str
end

function SpellQueueTest:isRunning()
	return self.run
end

function SpellQueueTest:ValCompare(a, b)
	local function copyDefaults(src, dst)
		-- If no source (defaults) is specified, return an empty table:
		if type(src) ~= "table" then return {} end -- almost always table
		-- If no target (saved variable) is specified, create a new table:
		--if not type(dst) then dst = {} end -- never works
		if not dst then dst = {} end --if type(dst) ~= "table" then dst = {} end
		-- Loop through the source (defaults):
		for k, v in pairs(src) do
			-- If the value is a sub-table:
			if type(v) == "table" then
				-- Recursively call the function:
				dst[k] = copyDefaults(v, dst[k])
				-- Or if the default value type doesn't match the existing value type:
			elseif type(v) ~= type(dst[k]) then
				-- Overwrite the existing value with the default one:
				dst[k] = v
			end
		end
		-- Return the destination table:
		return dst
	end
	b = copyDefaults(a, b)
	return b
end