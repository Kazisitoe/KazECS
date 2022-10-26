--|| KAZI

--// VARIABLES \\--
local History = { Cache = {} }

--// HISTORY \\--
function History:GetHistory(ComponentName:string, Id:number)
    local Name = ("%s:%s"):format(debug.info(3, "sl"))
    local Section = self.Cache[Id]
    if not Section then
        self.Cache[Id] = {}
        Section = self.Cache[Id]

    end
    local Cache = Section[ComponentName]
    if not Cache then
        Section[ComponentName] = {}
        Cache = Section[ComponentName]
    end
    
    Cache[Name] = Cache[Name] or { Old = nil, New = nil, _Changed = false } --Maybe change to New = Current Value

    return Cache[Name]

end

function History:AddToHistory(ComponentName:string, Id:number, NewValue:any)
    local Section = self.Cache[Id]
    if not Section then
        self.Cache[Id] = {}
        Section = self.Cache[Id]

    end
    local Cache = Section[ComponentName]
    if not Cache then
        Section[ComponentName] = {}
        Cache = Section[ComponentName]
    end

    for Name, Cached in next, Cache do
        Cached.Old = Cache[Name].New
        Cached.New = NewValue
        Cached._Changed = true
        
    end

end

function History:SetChanged(ComponentName:string, Id:number, IsChanged:boolean)
    local Name = ("%s:%s"):format(debug.info(3, "sl"))
    self.Cache[Id][ComponentName][Name]._Changed = IsChanged

end


return History