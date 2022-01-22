local _, SpellQueueTest = ...

local locale = GetLocale()
--local locale = "enUS" -- test
local L = {}

L["Dummy"] = "dummy"
L["Autorun"] = "Pop-up"
L["dif"] = "Interval"
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
L["AllSpell Desc"] = [[If unchecked, you can only test with Smite.
When checked, you can test with any skill, but please note that if a skill with a different GCD is involved during the test, the average value will be different and you will not be able to get a proper result.
Advanced) The event of an instant spell uses SPELL_CAST_SUCCESS, and the event of a cast spell uses SPELL_CAST_START.]]
L["AllSpell"] = "All Spell"
L["wating"] = "Click the Enable to start\n A minimum of 20 tests is recommended."
L["watingspell"] = "When you cast a spell, the test begins."
L["Timebase"] = "Time-based generated"
L["result"] = "Total %s Cast %d times\n Have an average GCD of %s"..L["second"]
L["ESCRGT"] = "ESC Key"
L["ESCRGT Desc"] = "To close with the ESC key"
L["Combat"] = "Combat Lock"
L["Combat Desc"] = "Locked so that it cannot be modified during combat"

if locale == "koKR" then
	L["Dummy"] = "허수아비"
	L["Autorun"] = "자동 팝업"
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
	L["AllSpell Desc"] = [==[체크 하지 않을시 오직 성스러운 일격으로만 테스트할 수 있습니다.
체크 할 시에는 모든 스킬로 테스트할 수 있지만 테스트 중 글쿨이 다른 스킬이 개입될 시 평균값이 달라져 제대로 된 결과값을 얻을 수 없음에 주의하시기 바랍니다.
고급) 즉시시전 주문의 이벤트는 SPELL_CAST_SUCCESS를 사용하고 캐스팅형 주문의 이벤트는 SPELL_CAST_START를 사용합니다.]==]
	L["AllSpell"] = "모든 스킬"
	L["wating"] = "시작하려면 활성화 버튼을 누르세요\n 테스트는 최소 20회 이상을 권장합니다."
	L["watingspell"] = "주문을 시전하면 테스트가 시작됩니다."
	L["Timebase"] = "시간 기준 생성됨"
	L["result"] = "%s 동안 %d회 시전하였고\n 평균 %s"..L["second"].."의 글로벌 쿨타임을 가짐"
	L["ESCRGT"] = "ESC키"
	L["ESCRGT Desc"] = "ESC키로 닫을 수 있게 하기"
	L["Combat"] = "전투중 잠금"
	L["Combat Desc"] = "전투중 수정 불가능하게 잠금"
end

SpellQueueTest.L = L