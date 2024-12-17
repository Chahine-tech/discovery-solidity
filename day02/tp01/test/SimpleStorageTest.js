const SimpleStorage = artifacts.require("SimpleStorage");

contract("Simple storage", (accounts) => {

    it("should store a value", async () => {
        console.log("Start of test");
        console

        const storage = await SimpleStorage.new();

        await storage.store(10);

        const data = await storage.retrieve();

        assert.equal(data.toString(), 10, "The stored value is incorrect");
    });
});
