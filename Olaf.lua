--
local version = 0.01

class "Olaf"

function Olaf:__init()
if myHero.charName ~= "Olaf" then return end
PrintChat("Olaf v.0.01 loaded")
self:LoadSpells()
self:LoadMenu()
Callback.Add("Tick", function() self:Tick() end)
Callback.Add("Draw", function() self:Draw() end)
end

--Icon URL's
local Icons = {
["OlafIcon"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olaf.jpeg",
["Q"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafQ.png",
["W"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafW.png",
["E"] = "https://raw.githubusercontent.com/hirano-git/GoS/master/olafE.png",
["R"] = "https://github.com/hirano-git/GoS/blob/master/olafR.png"
}

function Olaf.LoadSpells()
--Spell Info
Q = {Delay = 0.250, Radius = 250, Range = 1000, Speed = 1550, Collision = false}
W = {Delay = 0.250}
E = {Delay = 0.250, Range = 325}
R = {Delay = 0.250}
end

function Olaf:LoadMenu()
--Main Menu
self.Menu = MenuElement({type = MENU, id = "Olaf", name = "Olaf", leftIcon = Icons["OlafIcon"]})
--Combo Settings Menu
self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
self.Menu.Combo:MenuElement({type = SPACE, name = "Q", leftIcon = Icons["Q"]})
self.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
self.Menu.Combo:MenuElement({type = SPACE, name = "W", leftIcon = Icons["W"]})
self.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
self.Menu.Combo:MenuElement({id = "HealthW", name = "%Health for W", value = 25, min = 1, max = 100, step = 1})
self.Menu.Combo:MenuElement({type = SPACE, name = "E", leftIcon = Icons["E"]})
self.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
self.Menu.Combo:MenuElement({type = MENU, id = "RSettings", name = "Ultimate Settings"})
self.Menu.Combo.RSettings:MenuElement({type = SPACE, name = "Auto R", leftIcon = Icons["R"]})
self.Menu.Combo.RSettings:MenuElement({id = "AutoREnemies", name = "Auto R in Teamfight", value = true})
self.Menu.Combo.RSettings:MenuElement({id = "REnemies", name = "Enemy Amount", value = 2, min = 1, max = 5, step = 1})
self.Menu.Combo.RSettings:MenuElement({id = "AutoRBreakCC", name = "Auto R to Break CC", value = true})
self.Menu.Combo.RSettings:MenuElement({id = "RBreakCCHealth", name = "Min Health to Break CC", value = 50, min = 1, max = 100, step = 1})
--Harass Settings Menu
self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
self.Menu.Harass:MenuElement({type = SPACE, name = "Q", leftIcon = Icons["Q"]})
self.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true})
--Laneclear Settings Menu
self.Menu:MenuElement({type = MENU, id = "Laneclear", name = "Laneclear Settings"})
self.Menu.Laneclear:MenuElement({type = SPACE, name = "Q", leftIcon = Icons["Q"]})
self.Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true})
--Lasthit Settings Menu
self.Menu:MenuElement({type = MENU, id = "Lasthit", name = "Last Hit Settings"})
self.Menu.Lasthit:MenuElement({type = SPACE, name = "E", leftIcon = Icons["E"]})
self.Menu.Lasthit:MenuElement({id = "UseE", name = "Use E", value = true})
--Drawings Settings Menu
self.Menu:MenuElement({type = MENU, id = "Drawings", name = "Drawing Settings"})
self.Menu.Drawings:MenuElement({id = "drawQ", name = "Draw Q Range", value = true})
self.Menu.Drawings:MenuElement({id = "drawE", name = "Draw E Range", value = true})
end

function Olaf:Tick()
if myHero.dead then return end
local target = _G.SDK.TargetSelector:GetTarget(2000)
if target and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
self:Combo(target)
elseif target and _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
self:Harass(target)
end
end

function Olaf:Draw()
if myHero.dead then return end
if(self.Menu.Drawings.drawQ:Value())then
Draw.Circle(myHero, Q.Range, 3, Draw.Color(225, 225, 0, 10))
end
if(self.Menu.Drawings.drawE:Value())then
Draw.Circle(myHero, E.Range, 3, Draw.Color(225, 225, 0, 10))
end
end

function Olaf:Combo(target)
--q not optimal, look for similar code, need some sort of prediction
--local qtarg = self:GetTarget(Q.range)
--if target and self.Menu.Combo.UseQ:Value() and self:CanCast(_Q)then
--local castPosition = qtarg
--self:CastQ(castPosition)
--end
local wrange = self:GetTarget(300)
if wrange and self.Menu.Combo.UseW:Value() and self:CanCast(_W)then
Control.CastSpell(HK_W)
end

local etarg = self:GetTarget(E.range)
if etarg and self.Menu.Combo.UseE:Value() and self:CanCast(_W)then
local castPosition = etarg
self:CastE(castPosition)
end
end

function Olaf:Harass(target)
local etarg = self:GetTarget(E.range)
if etarg and self.Menu.Combo.UseE:Value() and self:CanCast(_W)then
local castPosition = etarg
self:CastE(castPosition)
end
end

function Olaf:CastW(position)
if position then
Control.SetCursorPos(position)
Control.CastSpell(HK_W, position)
end
end

function Olaf:CastE(position)
if position then
Control.SetCursorPos(position)
Control.CastSpell(HK_E, position)
end
end

function Olaf:GetTarget(range)
local targ
for i = 1,Game.HeroCount() do
local hero = Game.Hero(i)
if hero.isTargetable and not hero.dead and hero.team ~= myHero.team then
targ = hero
break
end
end
return targ
end

function Olaf:GetPercentHP(unit)
return 100 * unit.health / unit.maxHealth
end

function Olaf:IsReady(spellSlot)
return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Olaf:CheckMana(spellSlot)
return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Olaf:CanCast(spellSlot)
return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end

function OnLoad()
Olaf()
end