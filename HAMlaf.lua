class "Olaf"

function Olaf:__init()
if myHero.charName ~= "Olaf" then return end
PrintChat("Olaf loaded")
self:LoadSpells()
self:LoadMenu()
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Draw", function() self:Draw() end)
end

local Icons = {
["OlafIcon"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olaf.jpeg",
["Q"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafQ.png",
["W"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafW.png",
["E"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafE.png"
}

function Olaf.LoadSpells()
--Spell Info
--Q real speed = 1550, changed because q would frequently fall short
Q = {delay = 0.250, radius = 250, range = 1000, speed = 1450, Collision = false}
W = {delay = 0.250}
E = {delay = 0.250, range = 325}
R = {delay = 0.250}
end

function Olaf:LoadMenu()
--Main Menu
self.Menu = MenuElement({type = MENU, id = "Olaf", name = "Olaf", leftIcon = Icons["OlafIcon"]})
--Combo Settings Menu
self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
self.Menu.Combo:MenuElement({type = SPACE, name = "Undertow", leftIcon = Icons["Q"]})
self.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
self.Menu.Combo:MenuElement({type = SPACE, name = "Vicious Strikes", leftIcon = Icons["W"]})
self.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
self.Menu.Combo:MenuElement({type = SPACE, name = "Reckless Swing", leftIcon = Icons["E"]})
self.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
--Harass Settings Menu
self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
self.Menu.Harass:MenuElement({type = SPACE, name = "Q", leftIcon = Icons["Q"]})
self.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true})
--[[
--Laneclear Settings Menu
self.Menu:MenuElement({type = MENU, id = "Laneclear", name = "Laneclear Settings"})
self.Menu.Laneclear:MenuElement({type = SPACE, name = "Q", leftIcon = Icons["Q"]})
self.Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true})
--Lasthit Settings Menu
self.Menu:MenuElement({type = MENU, id = "Lasthit", name = "Last Hit Settings"})
self.Menu.Lasthit:MenuElement({type = SPACE, name = "E", leftIcon = Icons["E"]})
self.Menu.Lasthit:MenuElement({id = "UseE", name = "Use E", value = true})
--]]
--Drawings Settings Menu
self.Menu:MenuElement({type = MENU, id = "Drawings", name = "Drawing Settings"})
self.Menu.Drawings:MenuElement({id = "drawQ", name = "Draw Q Range", value = true})
self.Menu.Drawings:MenuElement({id = "drawE", name = "Draw E Range", value = true})
end

function Olaf:Tick()
if myHero.dead then return end
if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
self:Combo()
elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
self:Harass()
end
end

function Olaf:Draw()
if myHero.dead then return end
if(self.Menu.Drawings.drawQ:Value())then
Draw.Circle(myHero, Q.range, 3, Draw.Color(225, 225, 0, 10))
end
if(self.Menu.Drawings.drawE:Value())then
Draw.Circle(myHero, E.range, 3, Draw.Color(225, 225, 0, 10))
end
end

function Olaf:Combo()
local qtarg = _G.SDK.TargetSelector:GetTarget(1000)
if qtarg and self.Menu.Combo.UseQ:Value() and self:CanCast(_Q)then
self:CastQ(qtarg)
end

local wtarg = _G.SDK.TargetSelector:GetTarget(300)
if wtarg and self.Menu.Combo.UseW:Value() and self:CanCast(_W)then
Control.CastSpell(HK_W)
end

local etarg = _G.SDK.TargetSelector:GetTarget(E.range)
if etarg and self.Menu.Combo.UseE:Value() and self:CanCast(_E)then
local castPosition = etarg
self:CastE(castPosition)
end
end

function Olaf:Harass()
local qtarg = _G.SDK.TargetSelector:GetTarget(1000)
if qtarg and self.Menu.Combo.UseQ:Value() and self:CanCast(_Q)then
self:CastQ(qtarg)
end
end


function Olaf:CastQ(target)
if target then
if not target.dead and not target.isImmune then
if target.distance<=Q.range then
local pred=target:GetPrediction(Q.speed,Q.delay)
Control.CastSpell(HK_Q,pred)
end
end
end
return false
end

function Olaf:CastE(position)
if position then
Control.SetCursorPos(position)
Control.CastSpell(HK_E, position)
end
end

function Olaf:CheckMana(spellSlot)
return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Olaf:IsReady(spellSlot)
return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Olaf:CanCast(spellSlot)
return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end

function OnLoad()
Olaf()
end