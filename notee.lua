local _, SpellQueueTest = ...

local notebool = true
--if notebool then return end

--1. savedvariables지우는 기능
--2. cnt, 총경과시간 표시
--3. 주석추가
local testsrc = {
	first = 1,
	second = {
		third = 2,
		fourth = {
			fifth = 3,

		},
	},
}

local testdst = {
	second = {
		school = 3,
	},
	sixth = {
		seventh = 7,
	},
}
local cfg

function SpellQueueTest:ValCompare1(a, b)
	local cnt = 0
	local function recursive(src, dst)
		if type(src) ~= "table" then return {} end
		--if not dst then print("cnt", cnt) dst = {} end
		if not dst then dst = {} end
		for k, v in pairs(src) do
			if type(v) == "table" then
				cnt = cnt + 1
				dst[k] = recursive(v, dst[k])
			elseif type(v) ~= type(dst[k]) then
				dst[k] = v
				print(k, v, dst[k])
			else
				print("else",k, v, dst[k])
			end
		end
		return dst
	end

	b = recursive(a, b)
	return b
end

--testdst = SpellQueueTest:ValCompare1(testsrc, testdst)
--cfg = SpellQueueTest:ValCompare1(testsrc, testdst)
--print(testdst.sixth.seventh)
--SpellQueueTest:ValCompare1(_G["SpellQueueTestSettings"])
--local flag = true
--for i, j in pairs(src) do
--	if i == k then
--		flag = false
--		break
--	end
--end
--if flag then
--	print("del", k)
--	flag = false
--end
function SpellQueueTest:ValCompare2(a, b) -- 테이블이면 리커시브
	local function copyDefaults(src, dst)
		for k, v in pairs(dst) do
			local flag = true
			if type(v) == "table" then
				dst[k] = copyDefaults(src, dst[k])
			else
				for i, j in pairs(src) do
					if i == k then
						flag = false
						break
					end
				end
			end
			if flag then
				print("del", k)
				flag = false
			end
		end
	end
	b = copyDefaults(a, b)
	return b
end

SpellQueueTest:ValCompare2(testsrc, testdst)
--print(testdst.sixth.seventh)
--startTime
--number - The time when the cooldown started (as returned by GetTime()); zero if no cooldown; current time if (enabled == 0).
--duration
--number - Cooldown duration in seconds, 0 if spell is ready to be cast.
--enabled
--number - 0 if the spell is active (Stealth, Shadowmeld, Presence of Mind, etc) and the cooldown will begin as soon as the spell is used/cancelled; 1 otherwise.
--modRate
--number - The rate at which the cooldown widget's animation should be updated.
--start, duration, enabled, modRate = GetSpellCooldown("spellName" or spellID or slotID, "bookType")
--gettime, gcd
--CooldownMS, gcdMS = GetSpellBaseCooldown(spellid)

print(GetSpellCooldown(61304))