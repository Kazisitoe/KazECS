local KazECS = require(script.Parent)
local Components = KazECS.Components
local World = KazECS.World

return function()
    describe("Entites in the world", function()
        Components.new("Test")
        local Entity = World:Spawn(Components.Test{ Health = 100 })

        it("SHOULD chose the correct Id", function()
            expect(Entity).to.be.a("number")
        end)
        it("SHOULD be referenced and read with Get", function()
            expect(World:Get(Entity, Components.Test)).to.be.ok()
            expect(World:Get(Entity, Components.Test).Health).to.equal(100)
        end)
        it("SHOULD be patchable with Component:Patch", function()
            World:Insert(Entity, World:Get(Entity, Components.Test):Patch{ Health = 75 })
            expect(World:Get(Entity, Components.Test).Health).to.equal(75)

        end)
        it("SHOULD be patchable with QuickPatch", function()
            World:QuickPatch(Entity, Components.Test{ Health = 50 })
            expect(World:Get(Entity, Components.Test).Health).to.equal(50)

        end)

    end)

end