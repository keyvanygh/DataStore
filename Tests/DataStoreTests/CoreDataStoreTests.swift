import XCTest
import DataStore

final class CoreDataStoreTests: XCTestCase, DataStoreSpecs {
    
    func test_load_returnsFoundItemOnNonEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let savedItem = try TestManageObject1.item(in: sut)
        let notSavedItem = try TestManageObject1.item(in: sut)
        try sut.save(savedItem)
        
        let loadedItem = try sut.load()
        
        XCTAssertNotEqual(notSavedItem, loadedItem)
        XCTAssertEqual(savedItem, loadedItem)
    }
    
    func test_load_hasNoSideEffectsOnNonEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        XCTAssertThrowsError(try sut.load())
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_save_doseNotThrowsOnEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try TestManageObject1.item(in: sut)
        XCTAssertNoThrow(try sut.save(itemToSave))
    }
    
    func test_save_doseNotThrowsOnNonEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let savedItem = try TestManageObject1.item(in: sut)
        let itemToSave = try TestManageObject1.item(in: sut)
        try sut.save(savedItem)
        try sut.save(itemToSave)
        
        XCTAssertNoThrow(try sut.save(itemToSave))
    }
    
    func test_save_overridesPreviouslyInsertedCacheValues() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let previouslySavedItem = try TestManageObject1.item(in: sut)
        let latestSaveItem = try TestManageObject1.item(in: sut)
        try sut.save(previouslySavedItem)
        try sut.save(latestSaveItem)
        
        let loadedItem = try sut.load()
        
        XCTAssertNotEqual(previouslySavedItem, loadedItem)
        XCTAssertEqual(latestSaveItem, loadedItem)

    }
    
    func test_clear_doseNotThrowsOnEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        
        XCTAssertNoThrow(try sut.clear())
    }
    
    func test_clear_hasNoSideEffectsOnEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        
        XCTAssertNoThrow(try sut.clear())
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_clear_doseNotThrowsOnNonEmptyCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try TestManageObject1.item(in: sut)
        try sut.save(itemToSave)
        
        XCTAssertNoThrow(try sut.clear())
    }
    
    func test_clear_clearsPreviouslyInsertedCache() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        let itemToSave = try TestManageObject1.item(in: sut)
        try sut.save(itemToSave)
        
        try sut.clear()
        
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_storeSideEffects_runSerially() throws {
        
    }
    
    func test_instance_throwsOnInvalidItem() throws {
        let notTestModel = TestManageObject2.make()
        let sut: CoreDataStore<TestManageObject1> = makeSUT(container: .testContainer(with: notTestModel))
        XCTAssertThrowsError(try sut.item())
    }
    
    func test_load_throwsOnEmptyStore() throws {
        let sut: CoreDataStore<TestManageObject1> = makeSUT()
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_save_canSaveTwoDiffrentObjectInOnContainer() throws {
        let container = NSPersistentContainer.testContainer()
        let sut: CoreDataStore<TestManageObject1> = makeSUT(container: container)
        let sut2: CoreDataStore<TestManageObject2> = makeSUT(container: container)
        let savedItem = try TestManageObject1.item(in: sut)
        let savedItem2 = try TestManageObject2.item(in: sut2)
        try sut.save(savedItem)
        try sut2.save(savedItem2)
        
        let loadedItem = try sut.load()
        let loadedItem2 = try sut2.load()
        
        XCTAssertEqual(savedItem, loadedItem)
        XCTAssertEqual(savedItem2, loadedItem2)
    }
    
    private func makeSUT<Item>(container: NSPersistentContainer = .testContainer()) -> CoreDataStore<Item> {
        return CoreDataStore<Item>(container: container)
    }
}
