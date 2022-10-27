--|| KAZI

--// VARIABLES \\--
local History = { Cache = {} }
local Entities = require(script.Parent.Entities)

--// HISTORY \\--
function History:GetHistory(ComponentName:string, Id:number, Name:string?)
    Name = Name or ("%s:%s"):format(debug.info(3, "sl"))
    local Section = self.Cache[Name]
    if not Section then
        self.Cache[Name] = {}
        Section = self.Cache[Name]

    end
    local Cache = Section[ComponentName]
    if not Cache then
        Section[ComponentName] = {}
        Cache = Section[ComponentName]
    end
    
    Cache[Id] = Cache[Id] or { Old = nil, New = nil, _Changed = false } --Maybe change to New = Current Value

    return Cache[Id]

end

function History:CreateHistory(ComponentName:string)
    local Name = ("%s:%s"):format(debug.info(3, "sl"))
    local Section = self.Cache[Name]
    if not Section then
        self.Cache[Name] = {}
        
        return

    end
    if Section[ComponentName] then return end
    Section[ComponentName] = {}
    local Cache = Section[ComponentName]
    
    for Id, _ in next, Entities._EXISTS do
        Cache[Id] = Cache[Id] or { Old = nil, New = nil, _Changed = true } --Maybe change to New = Current Value
    end

end

function History:AddToHistory(ComponentName:string, Id:number, NewValue:any)
    -- local Section = self.Cache[Name]
    -- if not Section then
    --     self.Cache[Name] = {}
    --     Section = self.Cache[Name]

    -- end
    -- local Cache = Section[ComponentName]
    -- if not Cache then
    --     Section[ComponentName] = {}
    --     Cache = Section[ComponentName]
    -- end

    -- for Name, Cached in next, Cache do
    --     Cached.Old = Cache[Id].New
    --     Cached.New = NewValue
    --     Cached._Changed = true
        
    -- end
    for Name, Section in next, self.Cache do
        local Cache = Section[ComponentName]
        if not Cache then
            Section[ComponentName] = {}
            Cache = Section[ComponentName]
        end
        local Cached = Cache[Id]
        if not Cached then
            Cache[Id] = { Old = nil, New = nil, _Changed = true }
            Cached = Cache[Id]

        end

        Cached.Old = Cached.New
        Cached.New = NewValue
        Cached._Changed = true

    end


end

function History:SetChanged(ComponentName:string, Id:number, IsChanged:boolean)
    local Name = ("%s:%s"):format(debug.info(3, "sl"))
    local Record = self.Cache[Name][ComponentName][Id]
    if not IsChanged and not Record.New then
        self.Cache[Name][ComponentName][Id] = nil

        return

    end
    Record._Changed = IsChanged

end

return History