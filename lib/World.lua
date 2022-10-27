--|| KAZI

--// VARIABLES \\--
local World = { _NextId = 1, TotalEntities = 0, AllEntities = {} }
local Entities = require(script.Parent.Entities)
local History = require(script.Parent.History)
local ComponentHandler = require(script.Parent.Components)

--// WORLD \\--
function World:Spawn(...)
    local Components = {...}
    
    for _, Component in next, Components do
        local Name = Component._NAME
        Entities[Name][self._NextId] = Component
        History:AddToHistory(Name, self._NextId, Component)

    end

    self._NextId += 1
    self.TotalEntities += 1
    self.AllEntities[self._NextId-1] = true

    return self._NextId - 1

end

function World:Despawn(Entity:number)
    for Name, _ in next, ComponentHandler.Components do
        Entities[Name][Entity] = nil
        History:AddToHistory(Name, self._NextId, nil)

    end

    self.AllEntities[Entity] = nil
    self.TotalEntities -= 1

    for _, EntityList in next, Entities do
        EntityList[Entity] = nil
    end

    self._NextId = Entity
    
end

function World:Get(Entity:number, ...)
    local Components = {...}
    local Output = {}
    
    for Idx, Component in next, Components do
        Output[Idx] = Entities[Component._NAME][Entity]
        if not Output[Idx] then return nil end

    end

    return unpack(Output)

end

function World:Insert(Entity:number, ...)
    if not self.AllEntities[Entity] then self.TotalEntities += 1; self.AllEntities[Entity] = true end

    local Components = {...}
    for _, Component in next, Components do
        Entities[Component._NAME][Entity] = Component
        History:AddToHistory(Component._NAME, Entity, Component)

    end
    
end

function World:QuickPatch(Entity:number, ...)
    local Components = {...}
    for _, Component in next, Components do
        Entities[Component._NAME][Entity] = Entities[Component._NAME][Entity]:Patch(Component)
        History:AddToHistory(Component._NAME, Entity, Entities[Component._NAME][Entity])

    end

end

function World:Query(...)
    local Id = 0
    local Components = {...}
    local Amount = #Components

    local function Without(self2, ...)
        local BadComponents = {...}

        return function()
            local Output = {}

            while Id < self.TotalEntities do
                Id += 1
                if not self.AllEntities[Id] then continue end

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

        while Id < self.TotalEntities do
            Id += 1
            if not self.AllEntities[Id] then continue end

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

    local function Without(self2, ...)
        local BadComponents = {...}

        return function()
            local Output = {}

            while Id < self.TotalEntities do
                Id += 1
                if not self.AllEntities[Id] then continue end

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

        while Id < self.TotalEntities do
            Id += 1
            if not self.AllEntities[Id] then continue end

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