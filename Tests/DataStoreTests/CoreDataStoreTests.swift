import XCTest
import DataStore

final class CoreDataStoreTests: XCTestCase, DataStoreSpecs {
    
    func test_load_returnsFoundItemOnNonEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let savedItem = try await TestManageObject1.item(in: sut)
        let notSavedItem = try await TestManageObject1.item(in: sut)
        try await sut.save(savedItem)
        
        let loadedItem = try await sut.load()
        
        XCTAssertNotEqual(notSavedItem, loadedItem)
        XCTAssertEqual(savedItem, loadedItem)
    }
    
    func test_load_hasNoSideEffectsOnNonEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        await XCTAssertThrowsErrorAsync(try await sut.load())
        await XCTAssertThrowsErrorAsync(try await sut.load())
    }
    
    func test_save_doseNotThrowsOnEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try await TestManageObject1.item(in: sut)
        
        await XCTAssertNoThrowAsync(try await sut.save(itemToSave))
    }
    
    func test_save_doseNotThrowsOnNonEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let savedItem = try await TestManageObject1.item(in: sut)
        let itemToSave = try await TestManageObject1.item(in: sut)
        try await sut.save(savedItem)
        try await sut.save(itemToSave)
        
        await XCTAssertNoThrowAsync(try await sut.save(itemToSave))
    }
    
    func test_save_overridesPreviouslyInsertedCacheValues() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let previouslySavedItem = try await TestManageObject1.item(in: sut)
        let latestSaveItem = try await TestManageObject1.item(in: sut)
        try await sut.save(previouslySavedItem)
        try await sut.save(latestSaveItem)
        
        let loadedItem = try await sut.load()
        
        XCTAssertNotEqual(previouslySavedItem, loadedItem)
        XCTAssertEqual(latestSaveItem, loadedItem)

    }
    
    func test_clear_doseNotThrowsOnEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        
        await XCTAssertNoThrowAsync(try await sut.clear())
    }
    
    func test_clear_hasNoSideEffectsOnEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        
        await XCTAssertNoThrowAsync(try await sut.clear())
        await XCTAssertThrowsErrorAsync(try await sut.load())
    }
    
    func test_clear_doseNotThrowsOnNonEmptyCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try await TestManageObject1.item(in: sut)
        try await sut.save(itemToSave)
        
        await XCTAssertNoThrowAsync(try await sut.clear())
    }
    
    func test_clear_clearsPreviouslyInsertedCache() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try await TestManageObject1.item(in: sut)
        try await sut.save(itemToSave)
        
        try await sut.clear()
        
        await XCTAssertThrowsErrorAsync( try await sut.load())
    }
    
    func test_storeSideEffects_runSerially() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try await TestManageObject1.item(in: sut)
        
        try await sut.save(itemToSave)
        try await sut.clear()
        
        await XCTAssertThrowsErrorAsync(try await sut.load())
    }
    
    func test_instance_throwsOnInvalidItem() async throws {
        let notTestModel = TestManageObject2.make()
        let sut: CoreDataStore<TestManageObject1> = makeSUT(container: .testContainer(with: notTestModel))
        await XCTAssertThrowsErrorAsync(try await sut.item())
    }
    
    func test_load_throwsOnEmptyStore() async throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        await XCTAssertThrowsErrorAsync(try await sut.load())
    }
    
    func test_save_canSaveTwoDiffrentObjectInOnContainer() async throws {
        let container = NSPersistentContainer.testContainer()
        let sut: CoreDataStore<TestManageObject1> = makeSUT(container: container)
        let sut2: CoreDataStore<TestManageObject2> = makeSUT(container: container)
        let savedItem = try await TestManageObject1.item(in: sut)
        let savedItem2 = try await TestManageObject2.item(in: sut2)
        try await sut.save(savedItem)
        try await sut2.save(savedItem2)
        
        let loadedItem = try await sut.load()
        let loadedItem2 = try await  sut2.load()
        
        XCTAssertEqual(savedItem, loadedItem)
        XCTAssertEqual(savedItem2, loadedItem2)
    }
    
    private func makeSUT<Item>(container: NSPersistentContainer = .testContainer()) -> CoreDataStore<Item> {
        return CoreDataStore<Item>(container: container)
    }
}
