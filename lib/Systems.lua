--|| KAZI

--// VARIABLES \\--
local Systems = { Events = {}, Systems = {} }

--// SYSTEMS \\--
function Systems:RegisterEvent(Name:string, Event:RBXScriptSignal)
    if self.Systems[Name] then self.Systems[Name]:Disconnect() end

    self.Events[Name] = Event
    Event:Connect(function(...)
        for _, System in next, self.Systems[Name] do System(...) end
    end)
    self.Systems[Name] = {}

end
Systems:RegisterEvent("DEFAULT", game:GetService("RunService").Heartbeat)

function Systems:AddSystem(Event:string?, System:(...any)->any?, Priority:number?)
    if typeof(Event) == "function" then
        System = Event::(...any)->any
        Event = "DEFAULT"
    end

    if not self.Events[Event] then error("Attempted to bind system to a nonexistent event") end

    table.insert(self.Systems[Event], Priority or -1, System)

end


return Systems