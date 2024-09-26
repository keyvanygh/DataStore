//
//  DataStoreSpecs.swift
//
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import Foundation

protocol DataStoreSpecs {
    func test_load_returnsFoundItemOnNonEmptyCache() throws
    func test_load_hasNoSideEffectsOnNonEmptyCache() throws
    
    func test_save_doseNotThrowsOnEmptyCache() throws
    func test_save_doseNotThrowsOnNonEmptyCache() throws
    func test_save_overridesPreviouslyInsertedCacheValues() throws
    
    func test_clear_doseNotThrowsOnEmptyCache() throws
    func test_clear_hasNoSideEffectsOnEmptyCache() throws
    func test_clear_doseNotThrowsOnNonEmptyCache() throws
    func test_clear_clearsPreviouslyInsertedCache() throws
    
    func test_storeSideEffects_runSerially() throws
}

protocol FailableLoadDataStoreSpecs: DataStoreSpecs {
    func test_load_throwsOnOnEmptyStore() throws
    func test_load_throwsOnLoadError() throws
    func test_load_hasNoSideEffectsOnFailure() throws
}

protocol FailableSaveDataStoreSpecs: DataStoreSpecs {
    func test_save_throwsOnSaveError() throws
    func test_save_hasNoSideEffectsOnSaveError() throws
}

protocol FailableClearDataStoreSpecs: DataStoreSpecs {
    func test_clear_throwsOnClearError() throws
    func test_clear_hasNoSideEffectsOnDeletionError() throws
}

typealias FailableStoreSpecs = FailableLoadDataStoreSpecs & FailableSaveDataStoreSpecs & FailableClearDataStoreSpecs

