local KazECS = require(script.Parent)
local Components = KazECS.Components
local World = KazECS.World
local Systems = KazECS.Systems
local History = require(script.Parent.History)

return function()
    describe("Systems", function()
        it("SHOULD properly query all entities with specified components", function()
            Components.new("Humanoid")
            Components.new("Far")
            Components.new("Einstein")
            World:Spawn(Components.Far(), Components.Humanoid{ Alive = true })
            World:Spawn(Components.Far(), Components.Humanoid{ Alive = true })
            World:Spawn(Components.Einstein(), Components.Humanoid{ Alive = true })
            World:Spawn(Components.Einstein(), Components.Humanoid{ Alive = true })
            World:Spawn(Components.Far(), Components.Humanoid{ Alive = true }, Components.Einstein())
            World:Spawn(Components.Far(), Components.Humanoid{ Alive = true }, Components.Einstein())

            local function RoleCalls()
                for Id in World:Query(Components.Far):Without(Components.Einstein) do
                    print(Id, "Is an idiot!")
                end
                for Id in World:Query(Components.Einstein):Without(Components.Far) do
                    print(Id, "Is a genius!")
                end
                for Id in World:Query(Components.Einstein, Components.Far) do
                    print(Id, "Is an oxymoron!")
                end

            end

            expect(RoleCalls).never.to.throw()

            local function MassGenocide()
                task.spawn(function()
                    for _ = 1, 4 do
                        for Id, HumanoidChanges in World:QueryChanged(Components.Humanoid) do
                            print(HumanoidChanges.New.Alive and tostring(Id).." is now alive!" or tostring(Id).." has been killed!")
                        end
                        
                        task.wait(1)

                    end

                end)

                for Id in World:Query(Components.Far, Components.Humanoid) do
                    print("Murdered", Id)

                    World:Insert(Id, Components.Humanoid{ Alive = false })
                    
                end
                
            end

            expect(MassGenocide).never.to.throw()

        end)

    end)

end