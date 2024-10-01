import CoreData

public protocol CoreDataStoreable: Storable where StoreObject == NSManagedObject {
    static func entityName() throws -> String
}

public final class CoreDataStore<Item: CoreDataStoreable>: DataStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public enum StoreError: Error {
        case managedObjectModelNotFound
        case failedToLoadPersistentContainer(Error)
        case itemNotFound
        case unableToCreateItem
    }
    
    public init(container: NSPersistentContainer) {
        self.container = container
        self.context = container.newBackgroundContext()
    }
    
    convenience public init(
        storeURL: URL,
        modelName: String,
        in bundle: Bundle = Bundle.main
    ) throws {
        
        guard let model = NSManagedObjectModel.with(
            name: modelName,
            in: bundle
        ) else {
            throw StoreError.managedObjectModelNotFound
        }
        
        do {
            let container = try NSPersistentContainer.load(
                name: modelName,
                model: model,
                url: storeURL
            )
            
            self.init(container: container)
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    public func save(_ item: Item) async throws {
        let item = try await item.storeObject(for: self)
        
        try await context.perform { [context] in
            context.insert(item)
            try context.save()
        }
    }
    
    public func load() async throws -> Item {
        let entityName = try Item.entityName()

        guard let item: Item.StoreObject = try await find(entityName: entityName, in: context) else {
            throw StoreError.itemNotFound
        }
        
        return try Item.map(storeObject: item)
    }
    
    public func clear() async throws {
        let entityName = try Item.entityName()
        let context = context
        
        guard let item = try await find(entityName: entityName, in: context) else {
            return
        }
        
        try await context.perform {
            context.delete(item)
            try context.save()
        }
    }
    
    public func item() async throws -> Item.StoreObject {
        let entityName = try Item.entityName()
        
        try await clear()
        
        return try await context.perform { [context] in
            guard let entity = NSEntityDescription.entity(
                forEntityName: entityName,
                in: context
            ) else { throw StoreError.unableToCreateItem }
            
            return Item.StoreObject(entity: entity, insertInto: nil)
        }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.perform { [container] in
            let coordinator = container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    private func find<T: NSManagedObject>(
        entityName: String,
        in context: NSManagedObjectContext
    ) async throws -> T? {
        return try await context.perform {

            let request = NSFetchRequest<T>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            return try context.fetch(request).first
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
