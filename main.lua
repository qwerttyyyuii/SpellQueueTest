local _, SpellQueueTest = ...

local SetCVar, GetCVar, GetNetStats = C_CVar.SetCVar, C_CVar.GetCVar, GetNetStats
local UIParent = UIParent
local const = SpellQueueTest.const
local L = SpellQueueTest.L

local cfg
local pre = 0
local first = true
local PGUID = UnitGUID("player")
local sqtset = "SpellQueueTestSettings"

SpellQueueTest.DragButton:SetScript("OnHide", function(self)
	SpellQueueTest:InitFrame()
	SpellQueueTest.StopButton:Disable()
	SpellQueueTest:CloseEditor()

	if self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)

SpellQueueTest.StopButton:SetScript("OnClick", function()
	SpellQueueTest:InitFrame()
	SpellQueueTest.StopButton:Disable()
end)

SpellQueueTest.StartButton:SetScript("OnClick", function()
	SpellQueueTest.EventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	SpellQueueTest.StartButton:Hide()
	SpellQueueTest.TestButton:Show()
	SpellQueueTest.StopButton:Enable()
	SpellQueueTest:BarEnable(true)
	SpellQueueTest:LogInsert(L["StartButton"])
end)

SpellQueueTest.SlideBar:SetScript("OnValueChanged", function(_, newvalue)
	local dval = math.floor(newvalue)

	if first then
		first = false
		_G[SpellQueueTest.SlideBar:GetName().."Text"]:SetText(dval.."ms")
		SpellQueueTest.EditBox:SetText(dval)
		return
	end
	if not SetCVar("SpellQueueWindow", dval) then
		SpellQueueTest:SQTprint(L["SetFail"], dval)
		return
	end
	_G[SpellQueueTest.SlideBar:GetName().."Text"]:SetText(dval.."ms")
	SpellQueueTest.EditBox:SetText(dval)
end)

SpellQueueTest.TestButton:SetScript("OnClick", function()
	SpellQueueTest.StopButton:Enable()
	SpellQueueTest:resetvalue()
	SpellQueueTest:BarEnable(true)
	SpellQueueTest:LogInsert(L["ValInit"])
end)

SpellQueueTest.HideButton:SetScript("OnClick", function()
	SpellQueueTest:InitFrame()
	SpellQueueTest.StopButton:Disable()
	SpellQueueTest.DragButton:Hide()
end)

SpellQueueTest.EditBox:SetScript("OnEnterPressed", function(self)
	local dval = tonumber(SpellQueueTest.EditBox:GetText())
	if not dval then
		SpellQueueTest:SQTprint(L["EnterInt"])
		SpellQueueTest.EditBox:SetText(SpellQueueTest.SlideBar:GetValue())
		return
	end
	dval = SpellQueueTest:tointeger(dval)
	if dval > const.queuemax then dval = const.queuemax end
	if dval < const.queuemin then dval = const.queuemin	end
	if not SetCVar("SpellQueueWindow", dval) then
		SpellQueueTest:SQTprint(L["SetFail"], dval)
		return
	end
	SpellQueueTest.SlideBar:SetValue(dval)
	SpellQueueTest.EditBox:SetText(SpellQueueTest.SlideBar:GetValue())
	self:ClearFocus()
end)

SpellQueueTest.EditBox:SetScript("OnEscapePressed", function(self)
	SpellQueueTest.EditBox:SetText(SpellQueueTest.SlideBar:GetValue())
	self:ClearFocus()
end)

SpellQueueTest.InitEvent:SetScript("OnEvent", function(_, event, arg)
	if event == "ADDON_LOADED" and arg == "SpellQueueTest" then
		if not _G[sqtset] then _G[sqtset] = {} end
		cfg = SpellQueueTest:ValCompare(SpellQueueTest.Settings, _G[sqtset])
		SpellQueueTest.AutoCheck:SetChecked(cfg.Autorun)
		if SpellQueueTest.AutoCheck:GetChecked() then
			SpellQueueTest.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		else
			SpellQueueTest.EventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		end
		SpellQueueTest.SlideBar:SetValue(GetCVar("SpellQueueWindow"))
	elseif event == "PLAYER_LOGOUT" then
		if _G[sqtset] then _G[sqtset] = cfg end
	end
end)

SpellQueueTest.EventFrame:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		local var = UnitName("target")

		if var then
			var = string.lower(var)
			if string.find(var, L["Dummy"]) then
				SpellQueueTest.DragButton:Show()
			end
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, combatEvent, _, srcGUID, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		if not destGUID then return end

		if srcGUID == PGUID and combatEvent == "SPELL_CAST_SUCCESS" then
			if spellID == 585 then
				local cur = debugprofilestop() / 1000
				local avg = SpellQueueTest.avg

				if avg.cnt == 0 then
					SpellQueueTest:LogInsert(string.format(L["CVarSQW"].." %dms", GetCVar("SpellQueueWindow")))
					SpellQueueTest:LogInsert(string.format("Ping ["..L["User"].."]%dms ["..L["Server"].."]%dms", select(3, GetNetStats())))
				else
					local dif = cur - pre
					avg.sum = avg.sum + dif
					SpellQueueTest:LogInsert(string.format("%03d ["..L["dif"].."]%s"..L["second"].." ["..L["avg"].."]%s"..L["second"],
															avg.cnt,
															SpellQueueTest:LogColor(dif),
															SpellQueueTest:LogColor(avg.sum / avg.cnt)))
				end
				pre = cur
				avg.cnt = avg.cnt + 1
			end
		end
	end
end)

SpellQueueTest.ArrowButton:SetScript("OnClick", function()
	if SpellQueueTest.logFrame:IsShown() then
		SpellQueueTest.ArrowButton:SetText(const.open)
		SpellQueueTest.logFrame:Hide()
	else
		SpellQueueTest.ArrowButton:SetText(const.close)
		SpellQueueTest.logFrame:Show()
	end
end)

SpellQueueTest.ClearButton:SetScript("OnClick", function()
	SpellQueueTest.logFrame.EditBox:SetText("")
	SpellQueueTest.logFrame.EditBox:ClearFocus()
end)

SpellQueueTest.logFrame.EditBox:SetScript("OnEscapePressed", function(_)
	SpellQueueTest:CloseEditor()
end)

SpellQueueTest.AutoCheck:SetScript("OnClick", function(self)
	if self:GetChecked() then
		cfg.Autorun = true
		SpellQueueTest.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	else
		cfg.Autorun = false
		SpellQueueTest.EventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
	end
end)

SLASH_SpellQueueTest1 = "/sqt"
SLASH_SpellQueueTest2 = "/spellqueuetest"
function SlashCmdList.SpellQueueTest(msg)
	msg = string.lower(msg)

	if msg == "hide" then
		SpellQueueTest.DragButton:Hide()
	elseif msg == "pos" then
		SpellQueueTest.DragButton:ClearAllPoints()
		SpellQueueTest.DragButton:SetPoint("CENTER", UIParent, "CENTER", const.frame_x, const.frame_y)
		SpellQueueTest:SQTprint(L["RstPos"])
	else
		SpellQueueTest.DragButton:Show()
		SpellQueueTest:SQTprint("/sqt hide")
		SpellQueueTest:SQTprint("/sqt pos ("..L["RstPos"]..")")
	end
end