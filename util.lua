local _, SpellQueueTest = ...

local const = SpellQueueTest.const
local GetCVar = C_CVar.GetCVar

function SpellQueueTest:resetvalue()
	self.avg.cnt = 0
	self.avg.sum = 0
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
	frame.EditBox:Insert(const.str_sqt.." "..str.."\n")
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

function SpellQueueTest:InitFrame()
	self.EventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:resetvalue()
	self.TestButton:Hide()
	self.StartButton:Show()
	self:BarEnable(false)
	self.EditBox:SetText(self:tointeger(self.SlideBar:GetValue()))
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
-- 없어진 변수 지우기