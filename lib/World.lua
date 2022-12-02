--|| KAZI

--// VARIABLES \\--
local World = { _NextId = 1, CreatedEntities = 0, _Changed = require(script.Parent.Event).new() }
local Entities = require(script.Parent.Entities)
local History = require(script.Parent.History)
local ComponentHandler = require(script.Parent.Components)
World._Changed:HardFire("START")

--// WORLD \\--
function World:Spawn(...)
    local Components = {...}
    
    local Output = {}
    for _, Component in next, Components do
        local Name = Component._NAME
        Entities[Name][self._NextId] = Component
        History:AddToHistory(Name, self._NextId, Component)
        for _, v in next, {Component:_ON_GET(self._NextId, "CREATE")} do
            Output[#Output+1] = v
        end

    end

    self.CreatedEntities = self.CreatedEntities + 1 == self._NextId and self.CreatedEntities + 1 or self.CreatedEntities
    Entities._EXISTS[self._NextId] = true
    self._NextId += 1

    self._Changed:HardFire("Spawn", self._NextId, ...)

    return unpack(Output)

end

function World:Despawn(Entity:number)
    for Name, _ in next, ComponentHandler.Components do
        if not Entities[Name][Entity] then continue end
        Entities[Name][Entity] = nil
        History:AddToHistory(Name, Entity, nil)

    end

    Entities._EXISTS[Entity] = nil

    for _, EntityList in next, Entities do
        EntityList[Entity] = nil
    end
    
    self._Changed:HardFire("Despawn", Entity)
    
end

function World:Get(Entity:number, ...)
    local Components = {...}
    local Output = {}
    
    for Idx, Component in next, Components do
        Output[Idx] = Entities[Component._NAME][Entity]:_ON_GET(Entity, "GET")
        if not Output[Idx] then return nil end

    end

    return unpack(Output)

end

function World:GetComponents(Entity:number)
    local Components = {}
    
    for Name, _ in next, ComponentHandler.Components do
        if not Entities[Name][Entity] then continue end
        Components[Name] = Entities[Name][Entity]

    end

    return Components

end

function World:Insert(Entity:number, ...)
    if not Entities._EXISTS[Entity] then self.CreatedEntities += 1; Entities._EXISTS[Entity] = true end

    local Components = {...}
    for _, Component in next, Components do
        Entities[Component._NAME][Entity] = Component
        History:AddToHistory(Component._NAME, Entity, Component)

    end
    
    self._Changed:HardFire("Insert", Entity)
    
end

function World:QuickPatch(Entity:number, ...)
    local Components = {...}
    for _, Component in next, Components do
        Entities[Component._NAME][Entity] = Entities[Component._NAME][Entity]:Patch(Component)
        History:AddToHistory(Component._NAME, Entity, Entities[Component._NAME][Entity])

    end
    
    self._Changed:HardFire("Insert", Entity)

end

function World:Query(...)
    local Id = 0
    local Components = {...}
    local Amount = #Components

    local function Without(self2, ...)
        local BadComponents = {...}

        return function()
            local Output = {}

            while Id < self.CreatedEntities do
                Id += 1
                if not Entities._EXISTS[Id] then continue end

                local IsBad = false
                for _, Component in next, BadComponents do
                    if Entities[Component._NAME][Id] then IsBad = true break end
                end
                if IsBad then continue end

                for Idx, Component in next, Components do
                    local Data = Entities[Component._NAME][Id]
                    if not Data then break end

                    Output[Idx] = Data
                    
                end

                if #Output == Amount then return Id, unpack(Output) end

            end

            return nil
            

        end

    end

    return setmetatable({ Without = Without }, {__call = function()
        local Output = {}

        while Id < self.CreatedEntities do
            Id += 1
            if not Entities._EXISTS[Id] then continue end

            for Idx, Component in next, Components do
                local Data = Entities[Component._NAME][Id]
                if not Data then break end

                Output[Idx] = Data
                
            end

            if #Output == Amount then return Id, unpack(Output) end

        end

        return nil

    end})
    
end

function World:QueryChanged(MainComponent, ...)
    local Id = 0
    local OtherComponents = {...}
    local Amount = #OtherComponents
    local ComponentName = MainComponent._NAME
    History:CreateHistory(ComponentName)

    local function Without(self2, ...)
        local BadComponents = {...}

        return function()
            local Output = {}

            while Id < self.CreatedEntities do
                Id += 1

                local Changes = History:GetHistory(ComponentName, Id)
                if not Changes._Changed then continue end
                
                local IsBad = false
                for _, Component in next, BadComponents do
                    if Entities[Component._NAME][Id] then IsBad = true break end
                end
                if IsBad then continue end

                for Idx, Component in next, OtherComponents do
                    local Data = Entities[Component._NAME][Id]
                    if not Data then break end

                    Output[Idx] = Data
                    
                end

                if #Output == Amount then History:SetChanged(ComponentName, Id, false) return Id, Changes, unpack(Output) end

            end

            return nil

        end

    end

    return setmetatable({ Without = Without }, {__call = function()
        local Output = {}

        while Id < self.CreatedEntities do
            Id += 1

            local Changes = History:GetHistory(MainComponent._NAME, Id)
            if not Changes._Changed then continue end

            for Idx, Component in next, OtherComponents do
                local Data = Entities[Component._NAME][Id]
                if not Data then break end

                Output[Idx] = Data
                
            end

            if #Output == Amount then History:SetChanged(ComponentName, Id, false) return Id, Changes, unpack(Output) end

        end

        return nil

    end})

end


--World:Spawn(...Component)
--World:Despawn(Entity)
--World:Get(Entity, ...Component)
--World:Insert(Entity, ...Component)
--World:Query(...Component)

return World