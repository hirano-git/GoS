--[[credits: >ilovesona for toggled ability function, took example from simple karthus castE
	      >Zwei for Ignite code and OpenPredict examples
--]]

if GetObjectName(GetMyHero()) ~= "Swain" then return end

require("OpenPredict")
--require("DLib")

local SwainMenu = Menu("Swain","Swain")
SwainMenu:SubMenu("Combo", "Combo")
SwainMenu.Combo:Boolean("Q", "Use Q", true)
SwainMenu.Combo:Boolean("W", "Use W", true)
SwainMenu.Combo:Boolean("E", "Use E", true)
--[[
SwainMenu:SubMenu("RConfig", "Set R")
SwainMenu.RConfig:Boolean("R", "Use R", true)
SwainMenu.RConfig:Slider("rHP", "Use R if %HP <", 85, 1, 100, 1)
SwainMenu.RConfig:Slider("rMana", "Use R if %Mana >", 25, 1, 100, 1)
--]]
SwainMenu:SubMenu("UseIgnite", "UseIgnite")
SwainMenu.UseIgnite:Boolean("Ign", "Auto Ignite", true)

local SwainW = {delay = .9, range = 900, width = 125, speed = math.huge}
local SwainQ = {delay = .2, range = 700, width = 325, speed = math.huge}
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))
--[[
local isCastingR = false
local rRange = GetCastRange(myHero,_R)
local function castR(target)
	local isInDistance = IsInDistance(target, rRange)
	if isInDistance and IsReady(_R) and not isCastingR then
		CastSpell(_R)
	end
	if not isInDistance and isCastingR then
		CastSpell(_R)
	end
end
--]]

OnTick(function(MyHero)
local target = GetCurrentTarget()
if IOW:Mode() == "Combo" then
		if SwainMenu.Combo.E:Value() and IsReady(_E) and ValidTarget(target, 625) then
			CastTargetSpell(target,_E)
		end
		if SwainMenu.Combo.Q:Value() and IsReady(_Q) and ValidTarget(target, 700) then
			local PredictQ = GetCircularAOEPrediction(target,SwainQ)
			if PredictQ.hitChance > 0.2 then
				CastSkillShot(_Q,PredictQ.castPos)
			end
		end
		if SwainMenu.Combo.W:Value() and IsReady(_W) and ValidTarget(target, 900)then
			local PredictW = GetCircularAOEPrediction(target, SwainW)
			if PredictW.hitChance > 0.3 then
				CastSkillShot(_W,PredictW.castPos)
			end
		end

		if Ignite and SwainMenu.UseIgnite.Ign:Value() then
			if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(target)+GetDmgShield(target)+GetHPRegen(target)*3 and ValidTarget(target, 600) then
				CastTargetSpell(target, Ignite)
			end
		end
	--[[
		if ValidTarget(target) and SwainMenu.RConfig.R:Value() then
			castR(target)
		end
	--]]
end
end)

--[[
local rBuffName = "SwainMetamorphasis"
OnUpdateBuff(function(object,buffProc)

	if object == myHero and buffProc.Name == rBuffName then
		isCastingR = true
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == rBuffName then
		isCastingR = false
	end
end)
--]]

print("[Swain: Become a Master Tactician] loaded")
