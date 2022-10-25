--|| KAZI

--// VARIABLES \\--
local Systems = { Events = { DEFAULT = game:GetService("RunService").Heartbeat }, Systems = {} }

--// SYSTEMS \\--
function Systems:RegisterEvent(Name:string, Event:RBXScriptSignal)
    if self.System[Name] then self.Systems[Name]:Disconnect() end

    self.Events[Name] = Event
    Event:Connect(function(...)
        for _, System in next, self.Systems[Name] do System(...) end
    end)
    self.Systems[Name] = {}

end

function Systems:AddSystem(Event:string?, System:(...any)->any?, Priority:number?)
    if typeof(Event) == "function" then
        System = Event::(...any)->any
        Event = "DEFAULT"
    end

    if not self.Systems[Event] then error("Attempted to bind system to a nonexistent event") end

    table.insert(self.Systems[Event], Priority, Systems)

end


return Systems