local _, SpellQueueTest = ...

local const = SpellQueueTest.const
local cfg = SpellQueueTest.cfg
local L = SpellQueueTest.L
local SetCVar, GetCVar = C_CVar.SetCVar, C_CVar.GetCVar
local UnitName, GetSpellInfo = UnitName, GetSpellInfo
local UIParent = UIParent
local PGUID = UnitGUID("player")
local INSTANT = 0

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
	SpellQueueTest.ResultStr:SetText(L["watingspell"])
end)

SpellQueueTest.SlideBar:SetScript("OnValueChanged", function(_, newvalue)
	local dval = math.floor(newvalue)

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
	SpellQueueTest.ResultStr:SetText(L["watingspell"])
end)

SpellQueueTest.HideButton:SetScript("OnClick", function()
	SpellQueueTest:InitFrame()
	SpellQueueTest.StopButton:Disable()
	SpellQueueTest.DragButton:Hide()
end)

SpellQueueTest.EditBox:SetScript("OnEnterPressed", function(self)
	local dval = tonumber(SpellQueueTest.EditBox:GetText())

	if dval then
		dval = SpellQueueTest:tointeger(dval)
		if dval > const.queuemax then dval = const.queuemax end
		if dval < const.queuemin then dval = const.queuemin	end
		if not SetCVar("SpellQueueWindow", dval) then
			SpellQueueTest:SQTprint(L["SetFail"], dval)
			return
		end
		SpellQueueTest.SlideBar:SetValue(dval)
		self:ClearFocus()
	else
		SpellQueueTest:SQTprint(L["EnterInt"])
	end
	SpellQueueTest.EditBox:SetText(SpellQueueTest.SlideBar:GetValue())
end)

SpellQueueTest.EditBox:SetScript("OnEscapePressed", function(self)
	SpellQueueTest.EditBox:SetText(SpellQueueTest.SlideBar:GetValue())
	self:ClearFocus()
end)

SpellQueueTest.InitEvent:SetScript("OnEvent", function(_, event, arg)
	if event == "ADDON_LOADED" and arg == "SpellQueueTest" then
		cfg = SpellQueueTest:ValCompare(SpellQueueTest.Settings, _G["SpellQueueTestSettings"])
		SpellQueueTest.AutoCheck:SetChecked(cfg.Autorun)
		SpellQueueTest.AllSpell:SetChecked(cfg.AllSpell)
		SpellQueueTest:BarEnable(false)
		if cfg.Autorun then
			SpellQueueTest.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		else
			SpellQueueTest.EventFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		end
		--SpellQueueTest.CombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		--SpellQueueTest.CombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	elseif event == "PLAYER_LOGIN" then
		SpellQueueTest.SlideBar:SetValue(GetCVar("SpellQueueWindow"))
		SpellQueueTest.EditBox:SetText(GetCVar("SpellQueueWindow"))
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
		local _, combatEvent, _, srcGUID, _, _, _, destGUID, _, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()
		if not destGUID then return end

		if srcGUID == PGUID and (combatEvent == "SPELL_CAST_START" or combatEvent == "SPELL_CAST_SUCCESS") then
			if not cfg.AllSpell then
				if spellID ~= 585 then return end
			end

			if select(4, GetSpellInfo(spellID)) == INSTANT then
				if combatEvent == "SPELL_CAST_SUCCESS" then
					SpellQueueTest:CLEU(spellID, spellName)
				end
			else
				if combatEvent == "SPELL_CAST_START" then
					SpellQueueTest:CLEU(spellID, spellName)
				end
			end
		end
	end
end)

SpellQueueTest.CombatFrame:SetScript("OnEvent", function(_, event)
	if SpellQueueTest:IsRunning() then
		if event == "PLAYER_REGEN_DISABLED" then
			SpellQueueTest:CheckEnable(false)
			SpellQueueTest:BarEnable(false)
		elseif event == "PLAYER_REGEN_ENABLED" then
			SpellQueueTest:CheckEnable(true)
			SpellQueueTest:BarEnable(true)
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

SpellQueueTest.AllSpell:SetScript("OnClick", function(self)
	if self:GetChecked() then
		cfg.AllSpell = true
	else
		cfg.AllSpell = false
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