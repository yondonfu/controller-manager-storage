const Controller = artifacts.require("Controller")
const SimpleManager = artifacts.require("SimpleManager")
const SimpleStorage = artifacts.require("SimpleStorage")

contract("Integration", accounts => {
  let controller

  describe("init", () => {
    it("works", async () => {
      controller = await Controller.new()

      const storage = await SimpleStorage.new()
      const manager = await SimpleManager.new(storage.address, controller.address)
      await storage.transferOwnership(manager.address)

      await controller.setRegistryContract("SimpleManager", manager.address)
    })
  })

  describe("updates storage", () => {
    let manager
    let storage

    before(async () => {
      manager = SimpleManager.at(await controller.getRegistryContract("SimpleManager"))
      storage = SimpleStorage.at(await manager.simpleStorage.call())
    })

    it("sets uint256", async () => {
      await manager.add(1)
      assert.equal(await storage.a.call(), 1)
    })

    it("sets bytes32", async () => {
      await manager.hash("hello")
      assert.equal(await storage.b.call(), "0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8")
    })
  })

  describe("upgrades manager", () => {
    let manager
    let storage

    before(async () => {
      manager = SimpleManager.at(await controller.getRegistryContract("SimpleManager"))
      storage = SimpleStorage.at(await manager.simpleStorage.call())
    })

    it("replaces old manager and keeps old storage", async () => {
      await manager.pause()

      const newManager = await SimpleManager.new(storage.address, controller.address)

      await controller.setRegistryContract("SimpleManager", newManager.address)
      await manager.setStorageManager(newManager.address)

      await newManager.add(1)
      assert.equal(await storage.a.call(), 2)
    })
  })

  describe("upgrades controller", () => {
    let manager
    let storage

    before(async () => {
      manager = SimpleManager.at(await controller.getRegistryContract("SimpleManager"))
      storage = SimpleStorage.at(await manager.simpleStorage.call())
    })

    it("replaces old controller and keeps old manager and storage", async () => {
      await controller.pause()
      await manager.pause()

      const newController = await Controller.new()
      await controller.updateController("SimpleManager", newController.address)
      await newController.setRegistryContract("SimpleManager", manager.address)

      await manager.unpause()
    })
  })
})
