//
//  File.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import CoreData
import DataStore

@objc(TestManageObject1)
class TestManageObject1: NSManagedObject {
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
    
    static func item(in store: CoreDataStore<TestManageObject1>) async throws -> TestManageObject1 {
        let item = try await store.item()
        item.stringTestAttribute = "a-test-string-attribute"
        return item
    }
}
