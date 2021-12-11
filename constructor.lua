local _, SpellQueueTest = ...

local CreateFrame, UIParent = CreateFrame, UIParent
local const = SpellQueueTest.const
local L = SpellQueueTest.L

SpellQueueTest.DragButton = CreateFrame("Frame", "SpellQueueTestMainFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
SpellQueueTest.DragButton:SetPoint("CENTER", UIParent, "CENTER", const.frame_x, const.frame_y)
SpellQueueTest.DragButton:SetSize((const.width * 4) + const.margin, (const.height * 4) + const.margin)
SpellQueueTest.DragButton:SetMovable(true)
SpellQueueTest.DragButton:EnableMouse(true)
SpellQueueTest.DragButton:Hide()
SpellQueueTest.DragButton:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
SpellQueueTest.DragButton:SetBackdropColor(0, 0, 0, 0.5)
SpellQueueTest.DragButton:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving then
		self:StartMoving()
		self.isMoving = true
	end
end)
SpellQueueTest.DragButton:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)
table.insert(UISpecialFrames, SpellQueueTest.DragButton:GetName()) -- ESC key register

SpellQueueTest.StopButton = CreateFrame("Button", nil, SpellQueueTest.DragButton, "UIPanelButtonTemplate")
SpellQueueTest.StopButton:SetPoint("CENTER", SpellQueueTest.DragButton, "CENTER", 0, -const.height - 10)
SpellQueueTest.StopButton:SetSize(const.width, const.height)
SpellQueueTest.StopButton:SetText(L["Disable"])
SpellQueueTest.StopButton:Disable()

SpellQueueTest.StartButton = CreateFrame("Button", nil, SpellQueueTest.StopButton, "UIPanelButtonTemplate")
SpellQueueTest.StartButton:SetPoint("RIGHT", SpellQueueTest.StopButton, "LEFT", 0, 0)
SpellQueueTest.StartButton:SetSize(const.width, const.height)
SpellQueueTest.StartButton:SetText(L["Enable"])

SpellQueueTest.TestButton = CreateFrame("Button", nil, SpellQueueTest.StopButton, "UIPanelButtonTemplate")
SpellQueueTest.TestButton:SetPoint("RIGHT", SpellQueueTest.StopButton, "LEFT", 0, 0)
SpellQueueTest.TestButton:SetSize(const.width, const.height)
SpellQueueTest.TestButton:SetText(L["ReTest"])
SpellQueueTest.TestButton:Hide()

SpellQueueTest.HideButton = CreateFrame("Button", nil, SpellQueueTest.StopButton, "UIPanelButtonTemplate")
SpellQueueTest.HideButton:SetPoint("LEFT", SpellQueueTest.StopButton, "RIGHT", 0, 0)
SpellQueueTest.HideButton:SetSize(const.width, const.height)
SpellQueueTest.HideButton:SetText(L["Close"])

SpellQueueTest.SlideBar = CreateFrame("Slider", "SpellQueueTestSlideBar", SpellQueueTest.StopButton, "OptionsSliderTemplate")
SpellQueueTest.SlideBar:SetPoint("BOTTOM", SpellQueueTest.StopButton, "TOP", 0, 15)
SpellQueueTest.SlideBar:SetSize(const.queuemax - (const.margin / 2), const.height)
SpellQueueTest.SlideBar:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
SpellQueueTest.SlideBar:SetMinMaxValues(const.queuemin, const.queuemax)
SpellQueueTest.SlideBar:SetValueStep(1)
SpellQueueTest.SlideBar:SetOrientation("HORIZONTAL")
SpellQueueTest.SlideBar.tooltipText = L["CVarSQW"]
_G[SpellQueueTest.SlideBar:GetName().."Low"]:SetText(const.queuemin.."ms")
_G[SpellQueueTest.SlideBar:GetName().."High"]:SetText(const.queuemax.."ms")
_G[SpellQueueTest.SlideBar:GetName().."Text"]:SetPoint("TOP", SpellQueueTest.SlideBar, "BOTTOM", 0, -36)

SpellQueueTest.EditBox = CreateFrame("EditBox", "SpellQueueTestEditBox", SpellQueueTest.SlideBar, BackdropTemplateMixin and "BackdropTemplate" or nil)
SpellQueueTest.EditBox:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = true,
	edgeSize = 1,
	tileSize = 5,})
SpellQueueTest.EditBox:SetBackdropColor(0, 0, 0, 0.5)
SpellQueueTest.EditBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
SpellQueueTest.EditBox:SetPoint("BOTTOM", SpellQueueTest.SlideBar, "TOP", 0, -2)
SpellQueueTest.EditBox:SetAutoFocus(false)
SpellQueueTest.EditBox:SetNumeric()
SpellQueueTest.EditBox:EnableMouse(true)
--SpellQueueTest.EditBox:SetMaxLetters(3)
SpellQueueTest.EditBox:SetSize(70, 14)
SpellQueueTest.EditBox:SetFontObject(GameFontHighlightSmall)
SpellQueueTest.EditBox:SetJustifyH("Center")
SpellQueueTest:BarEnable(false)

SpellQueueTest.ResultStr = SpellQueueTest.StopButton:CreateFontString(SpellQueueTest.StopButton, "OVERLAY")--, "GameTooltipText")
SpellQueueTest.ResultStr:SetPoint("BOTTOM", SpellQueueTest.StopButton, "TOP", 0, 65)
SpellQueueTest.ResultStr:SetFont("Fonts\\2002.TTF", 12)
SpellQueueTest.ResultStr:SetText(L["wating"])

SpellQueueTest.title = SpellQueueTest.DragButton:CreateFontString(SpellQueueTest.DragButton, "OVERLAY", "GameTooltipText")
SpellQueueTest.title:SetPoint("TOP", SpellQueueTest.DragButton, "TOP", 0, -6)
SpellQueueTest.title:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
SpellQueueTest.title:SetText("SpellQueueTest")

SpellQueueTest.command = SpellQueueTest.DragButton:CreateFontString(SpellQueueTest.DragButton, "OVERLAY", "GameTooltipText")
SpellQueueTest.command:SetPoint("TOPLEFT", SpellQueueTest.DragButton, "TOPLEFT", 6, -6)
SpellQueueTest.command:SetFont("Fonts\\FRIZQT__.TTF", 11)
SpellQueueTest.command:SetText("|c00008000/SpellQueueTest\n/SQT|r")

SpellQueueTest.logFrame = CreateFrame("ScrollFrame", nil, SpellQueueTest.DragButton, "InputScrollFrameTemplate")
SpellQueueTest.logFrame:SetPoint("TOP", SpellQueueTest.DragButton, "BOTTOM", 0, -5)
SpellQueueTest.logFrame:SetSize(SpellQueueTest.DragButton:GetWidth() - 12, 200)
SpellQueueTest.logFrame.CharCount:Hide()
--SpellQueueTest.logFrame.EditBox:SetFont("Fonts\\ARIALN.ttf", 13)
SpellQueueTest.logFrame.EditBox:SetFont("Interface\\AddOns\\SpellQueueTest\\D2Coding-Ver1.3.2-20180524.ttf", 11)
SpellQueueTest.logFrame.EditBox:SetWidth(SpellQueueTest.logFrame:GetWidth()) -- multiline editboxes need a width declared!!
SpellQueueTest.logFrame.EditBox:SetAllPoints()
SpellQueueTest.logFrame:Hide()

SpellQueueTest.ArrowButton = CreateFrame("Button", nil, SpellQueueTest.DragButton, "UIPanelButtonTemplate")
SpellQueueTest.ArrowButton:SetSize(40, 25)
SpellQueueTest.ArrowButton:SetPoint("BOTTOMLEFT", SpellQueueTest.DragButton, "BOTTOMLEFT", 4, 4)
SpellQueueTest.ArrowButton:SetText(const.open)

SpellQueueTest.ClearButton = CreateFrame("Button", nil, SpellQueueTest.DragButton, "UIPanelButtonTemplate")
SpellQueueTest.ClearButton:SetSize(50, 25)
SpellQueueTest.ClearButton:SetPoint("BOTTOMRIGHT", SpellQueueTest.DragButton, "BOTTOMRIGHT", -4, 4)
SpellQueueTest.ClearButton:SetText("Clear")

SpellQueueTest.AutoCheck = CreateFrame("CheckButton", "SpellQueueTestAutoCheck", SpellQueueTest.DragButton, "ChatConfigCheckButtonTemplate")
SpellQueueTest.AutoCheck:SetSize(25, 25)
SpellQueueTest.AutoCheck:SetPoint("TOPRIGHT", SpellQueueTest.DragButton, "TOPRIGHT", -60, -4)
_G[SpellQueueTest.AutoCheck:GetName().."Text"]:SetPoint("LEFT", SpellQueueTest.AutoCheck, "RIGHT", 0, 0)
_G[SpellQueueTest.AutoCheck:GetName().."Text"]:SetText(L["Autorun"])
SpellQueueTest.AutoCheck.tooltip = L["Autorun Desc"]

SpellQueueTest.AllSpell = CreateFrame("CheckButton", "SpellQueueTestAllSpell", SpellQueueTest.DragButton, "ChatConfigCheckButtonTemplate")
SpellQueueTest.AllSpell:SetSize(25, 25)
SpellQueueTest.AllSpell:SetPoint("TOP", SpellQueueTest.AutoCheck, "BOTTOM", 0, 5)
_G[SpellQueueTest.AllSpell:GetName().."Text"]:SetPoint("LEFT", SpellQueueTest.AllSpell, "RIGHT", 0, 0)
_G[SpellQueueTest.AllSpell:GetName().."Text"]:SetText(L["AllSpell"])
SpellQueueTest.AllSpell.tooltip = L["AllSpell Desc"]

SpellQueueTest.InitEvent = CreateFrame("Frame")
SpellQueueTest.InitEvent:RegisterEvent("ADDON_LOADED")

SpellQueueTest.EventFrame = CreateFrame("Frame")
SpellQueueTest.CombatFrame = CreateFrame("Frame")
