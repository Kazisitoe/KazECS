--|| KAZI

--// VARIABLES \\--
local Systems = { Events = {}, Systems = {} }
local Changed = require(script.Parent.World)._Changed

--// SYSTEMS \\--
function Systems:RegisterEvent(Name:string, Event:RBXScriptSignal)
    if self.Systems[Name] then self.Systems[Name]:Disconnect() end

    self.Events[Name] = Event
    Event:Connect(function(...)
        for _, System in next, self.Systems[Name] do task.spawn(System, ...) end
    end)
    self.Systems[Name] = {}

    Changed:HardFire("New system loaded")

end
Systems:RegisterEvent("DEFAULT", game:GetService("RunService").Heartbeat)
Systems:RegisterEvent("WORLD_CHANGED", Changed::RBXScriptSignal)

function Systems:AddSystem(Event:string?, System:(...any)->any?, Priority:number?)
    if typeof(Event) == "function" then
        System = Event::(...any)->any
        Event = "DEFAULT"
    end

    if not self.Events[Event] then error("Attempted to bind system to a nonexistent event") end

    table.insert(self.Systems[Event], Priority or #self.Systems[Event]+1, System)
    Changed:HardFire("New system loaded")

end


return Systems