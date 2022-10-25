local KazECS = require(script.Parent)
local Components = KazECS.Components

return function()
    describe("Creating a new component", function()
        it("SHOULD be callable to create a new instance of the component", function()
            expect(Components.new("EZ")).never.to.be.ok()
            expect(Components.EZ()).to.be.ok()
        end)

        it("SHOULD store data that can be indexed", function()
            expect(Components.EZ{ Value = 5 }.Value).to.equal(5)

        end)

    end)

end