//
//  DataStore.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol DataStore {
    associatedtype Item: Storable
    
    func load() async throws -> Item
    @discardableResult  func save(_ item: Item) async throws -> Item
    func clear() async throws
}

public protocol Storable {
    associatedtype StoreObject
    static func map(storeObject: StoreObject) throws -> Self
    func storeObject(for store: any DataStore) async throws -> StoreObject
}

