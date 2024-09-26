//
//  CoreDataStore.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/25/24.
//

import CoreData

public final class CoreDataStore<Item: NSManagedObject>: DataStore {
    
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

    public func save(_ item: Item) throws {
        try context.performAndWait {
            context.insert(item)
            try context.save()
        }
    }
    
    public func load() throws -> Item {
        try context.performAndWait {
            let entityName = try Item.entityName()

            guard let item: Item = try find(entityName: entityName, in: context) else {
                throw StoreError.itemNotFound
            }
            
            return item
        }
    }
    
    public func clear() throws {
        let entityName = try Item.entityName()

        try context.performAndWait {
            try find(entityName: entityName, in: context).map(context.delete).map(context.save)
        }
    }
    
    public func item() throws -> Item {
        let entityName = try Item.entityName()
        
        try clear()
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: entityName,
            in: context
        ) else { throw StoreError.unableToCreateItem }
        
        return Item(entity: entity, insertInto: nil)
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    private func find<T: NSManagedObject>(
        entityName: String,
        in context: NSManagedObjectContext
    ) throws -> T? {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

// Mark: - Helpers
extension NSPersistentContainer {
    static func load(
        name: String,
        model: NSManagedObjectModel,
        url: URL
    ) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}

extension NSManagedObjectModel {
    static func with(
        name: String,
        in bundle: Bundle
    ) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

extension NSManagedObject {
    
    enum Error: Swift.Error {
        case entityNameIsNil
    }
    
    static func entityName() throws -> String {
        guard let entityName = entity().name else {
            throw NSManagedObject.Error.entityNameIsNil
        }
        return entityName
    }
}
