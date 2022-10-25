--|| KAZI

--// VARIABLES \\--
local Components = { Components = {} }
local ComponentClass = {}
local Entities = require(script.Parent.Entities)

--// COMPONENTS \\--
function Components.new(Name)
    Components.Components[Name] = setmetatable({_NAME = Name}, {__call = function(_, Data:table?)
        Data = Data or {}
        Data._NAME = Name
        
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