//
//  DataStore.swift
//
//  Created by Keyvan Yaghoubian on 9/18/24.
//

import Foundation

public protocol DataStore {
    associatedtype Item
    
    func load() throws -> Item
    func save(_ item: Item) throws
    func clear() throws
}
