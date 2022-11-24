--|| KAZI

--// VARIABLES \\--
local Components = { Components = {} }
local ComponentClass = {}
local Entities = require(script.Parent.Entities)

--// TYPES \\--
export type ComponentInfo = { Name:string, OnGet:()->any, }
export type ComponentGetterContext = "GET" | "CREATE"

--// COMPONENTS \\--
function Components.new(Info:string | ComponentInfo)
    local IsOnlyName = typeof(Info) == "string"
    local Name:string = IsOnlyName and Info or Info.Name
    local Getter = IsOnlyName and function(self, Id, Context:ComponentGetterContext)
        return Context == "GET" and self or Id
    end or Info.OnGet

    Components.Components[Name] = setmetatable({_NAME = Name, _ON_GET = Getter}, {__call = function(_, Data:table?)
        Data = Data or {}
        Data._NAME = Name
        Data._ON_GET = Getter
        
        return table.freeze(setmetatable(Data, {__index = ComponentClass}))

    end})

    Entities[Name] = {}

end

function ComponentClass:Patch(Change:table | (Original:table)->table)
    local New = table.clone(self)
    Change = typeof(Change) == "function" and Change(New) or Change
    
    for Index, NewValue in next, Change do
        New[Index] = NewValue
    end

    return Components[self._NAME](New)

end

--Component(Data)
--Component:Patch(Data or DataChanger)

return setmetatable(Components, {__index = Components.Components})