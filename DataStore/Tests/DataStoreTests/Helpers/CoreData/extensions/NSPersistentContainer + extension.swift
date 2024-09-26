//
//  NSPersistentContainer + extension.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import CoreData

extension NSPersistentContainer {
    static func testContainer(
        with model: NSManagedObjectModel = TestManageObject1.make()
    ) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _,_  in }
        
        return container
    }
}
