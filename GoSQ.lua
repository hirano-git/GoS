class "Question"
function Question:__init()
PrintChat("Q Loaded")
self:LoadMenu()
Callback.Add("Draw", function() self:Draw() end)
end
function Question:LoadMenu()
--is leftIcon neccisary?
self.Menu = MenuElement({type = MENU, id = "question", name = "...", leftIcon = nil})
self.Menu:MenuElement({id = "RValue", name = "red", value = 255, min = 0, max = 255, step = 1})
self.Menu:MenuElement({id = "GValue", name = "green", value = 255, min = 0, max = 255, step = 1})
self.Menu:MenuElement({id = "BValue", name = "blue", value = 255, min = 0, max = 255, step = 1})
self.Menu:MenuElement({id = "QValue", name = "...", value = false})
end
function Question:Draw()
if self.Menu.QValue:Value() then
Draw.Text("Will you go to prom with me?", 50, 400, 300, Draw.Color(255, self.Menu.RValue:Value(), self.Menu.GValue:Value(), self.Menu.BValue:Value()))
end
end
function OnLoad()
Question()
end
