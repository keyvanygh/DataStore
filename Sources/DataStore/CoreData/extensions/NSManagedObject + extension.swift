//
//  NSManagedObject + extension.swift
//
//
//  Created by Keyvan Yaghoubian on 9/27/24.
//

import CoreData

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
