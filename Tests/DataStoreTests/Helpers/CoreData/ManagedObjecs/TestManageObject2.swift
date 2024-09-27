//
//  TestManageObject2.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import CoreData
import DataStore

@objc(TestManageObject2)
class TestManageObject2: NSManagedObject {
    @NSManaged var stringTestAttribute: String
}

extension TestManageObject2 {
    static func make() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = "TestManageObject2"
        entity.managedObjectClassName = NSStringFromClass(TestManageObject2.self)
        
        
        let attribute = NSAttributeDescription()
        attribute.name = "stringTestAttribute"
        attribute.attributeType = .stringAttributeType
        attribute.isOptional = false
        entity.properties = [attribute]
        
        model.entities = [entity]
        
        return model
    }
    
    static func item(in store: CoreDataStore<TestManageObject2>) async throws -> TestManageObject2 {
        let item = try await store.item()
        item.stringTestAttribute = "a-test-string-attribute"
        return item
    }
}
