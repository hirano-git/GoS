if GetObjectName(myHero) ~= "Heimerdinger" then return end

require("OpenPredict")

local HeimW = {range = 1500, speed = 1000, width = 50, delay = 0.25}
local HeimE = {range = 925, speed = 1000, width = 120, delay = 0.1}
local Ignite = (GetCastName(GetMyHero(),SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(GetMyHero(),SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))

local HeimMenu = Menu("Heimerdinger", "Heimerdinger")
HeimMenu:SubMenu("Combo", "Combo")
HeimMenu.Combo:Boolean("W", "Use W", true)
HeimMenu.Combo:Boolean("E", "Use E", true)
HeimMenu:SubMenu("UseIgnite", "UseIgnite")
HeimMenu.UseIgnite:Boolean("Ign", "Auto Ignite", true)

OnTick(function()
local target = GetCurrentTarget()
	if IOW:Mode() == "Combo" then
		if HeimMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 1500) then
			local PredictW = GetLinearAOEPrediction(target, HeimW)
			if PredictW.hitChance > 0.25 then
				CastSkillShot(_W, PredictW.castPos)
			end
		end
		if HeimMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 925) then
			local PredictE = GetCircularAOEPrediction(target, HeimE)
			if PredictE.hitChance > 0.25 then
				CastSkillShot(_E, PredictE.castPos)
			end
		end
		if HeimMenu.UseIgnite.Ign:Value() and Ignite then
			if Ready(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(target)+GetDmgShield(target)+GetHPRegen(target)*3 and ValidTarget(target, 600) then
				CastTargetSpell(target, Ignite)
			end
		end
	end
)

print("[Heimerdinger] loaded")
