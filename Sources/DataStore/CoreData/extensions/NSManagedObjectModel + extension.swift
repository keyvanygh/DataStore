//
//  NSManagedObjectModel + extension.swift
//  
//
//  Created by Keyvan Yaghoubian on 9/27/24.
//

import CoreData

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
