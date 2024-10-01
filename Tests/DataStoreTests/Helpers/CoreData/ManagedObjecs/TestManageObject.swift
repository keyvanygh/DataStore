//
//  File.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import CoreData
import DataStore

@objc(TestManageObject1)
final class TestManageObject1: NSManagedObject {
    @NSManaged var stringTestAttribute: String
}

extension TestManageObject1 {
    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = "TestManageObject1"
        entity.managedObjectClassName = NSStringFromClass(TestManageObject1.self)
        
        let entity2 = NSEntityDescription()
        entity2.name = "TestManageObject2"
        entity2.managedObjectClassName = NSStringFromClass(TestManageObject2.self)
        
        let attribute = NSAttributeDescription()
        attribute.name = "stringTestAttribute"
        attribute.attributeType = .stringAttributeType
        attribute.isOptional = false
        entity.properties = [attribute]
        entity2.properties = [attribute]
        
        model.entities = [entity, entity2]
        
        return model
    }
}

struct LocalTestModel: Equatable {
    let stringTestAttribute: String
    
}

extension LocalTestModel: CoreDataStoreable {
    
    enum Error: Swift.Error {
        case entityNameIsNil
        case unableToMap
        case invalidStore
        case unableToCreateStoreObject
    }
    
    static func entityName() throws -> String {
        
        guard let entityName = TestManageObject1().entity.name else {
            throw Error.entityNameIsNil
        }
        
        return entityName
    }
    
    static func map(storeObject: NSManagedObject) throws -> LocalTestModel {
        guard let storeObject = storeObject as? TestManageObject1 else {
            throw Error.unableToMap
        }
        
        return LocalTestModel(stringTestAttribute: storeObject.stringTestAttribute)
    }
    
    func storeObject(for store: any DataStore) async throws -> NSManagedObject {
        guard let store = store as? CoreDataStore<LocalTestModel> else {
            throw Error.invalidStore
        }
        
        guard let item = try await store.item() as? TestManageObject1 else {
            throw Error.unableToCreateStoreObject
        }
        
        item.stringTestAttribute = stringTestAttribute
        return item
    }
}
