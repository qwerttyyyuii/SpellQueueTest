local _, SpellQueueTest = ...

local locale = GetLocale()
local L = {}

local function DefalultLocale()
	L["Dummy"] = "dummy"
	L["Autorun"] = "Pop-up"
	L["interval"] = "Interval"
	L["avg"] = "Average"
	L["second"] = "s"
	L["Autorun Desc"] = "Auto Pop-up when clicking the Dummy"
	L["Close"] = "Close"
	L["Enable"] = "Enable"
	L["Disable"] = "Disable"
	L["ReTest"] = "Re-test"
	L["ValInit"] = "Ready for the Re-test"
	L["RstPos"] = "Reset position"
	L["User"] = "Home"
	L["Server"] = "World"
	L["SetFail"] = "Set Fail"
	L["EnterInt"] = "Enter the correct Natural Number"
	L["CVarSQW"] = "CVar SpellQueueWindow"
	L["StartButton"] = "Enabled"
end

if locale == "koKR" then
	L["Dummy"] = "허수아비"
	L["Autorun"] = "자동팝업"
	L["dif"] = "간격"
	L["avg"] = "평균"
	L["second"] = "초"
	L["Autorun Desc"] = "허수아비 클릭시 자동 팝업"
	L["Close"] = "닫기"
	L["Enable"] = "활성화"
	L["Disable"] = "비활성화"
	L["ReTest"] = "재검사"
	L["ValInit"] = "재검사 준비됨"
	L["RstPos"] = "위치 초기화"
	L["User"] = "사용자"
	L["Server"] = "서버"
	L["SetFail"] = "설정 실패"
	L["EnterInt"] = "올바른 자연수 값을 입력하세요"
	L["CVarSQW"] = "CVar SpellQueueWindow"
	L["StartButton"] = "활성화됨"
elseif locale == "enUS" then
	DefalultLocale()
else
	DefalultLocale()
end

SpellQueueTest.L = L