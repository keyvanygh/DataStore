//
//  DataStoreSpecs.swift
//
//
//  Created by Keyvan Yaghoubian on 9/26/24.
//

import Foundation

protocol DataStoreSpecs {
    func test_load_returnsFoundItemOnNonEmptyCache() async throws
    func test_load_hasNoSideEffectsOnNonEmptyCache() async throws
    
    func test_save_doseNotThrowsOnEmptyCache() async throws
    func test_save_doseNotThrowsOnNonEmptyCache() async throws
    func test_save_overridesPreviouslyInsertedCacheValues() async throws
    
    func test_clear_doseNotThrowsOnEmptyCache() async throws
    func test_clear_hasNoSideEffectsOnEmptyCache() async throws
    func test_clear_doseNotThrowsOnNonEmptyCache() async throws
    func test_clear_clearsPreviouslyInsertedCache() async throws
    
    func test_storeSideEffects_runSerially() async throws
}

protocol FailableLoadDataStoreSpecs: DataStoreSpecs {
    func test_load_throwsOnOnEmptyStore() async throws
    func test_load_throwsOnLoadError() async throws
    func test_load_hasNoSideEffectsOnFailure() async throws
}

protocol FailableSaveDataStoreSpecs: DataStoreSpecs {
    func test_save_throwsOnSaveError() async throws
    func test_save_hasNoSideEffectsOnSaveError() async throws
}

protocol FailableClearDataStoreSpecs: DataStoreSpecs {
    func test_clear_throwsOnClearError() async throws
    func test_clear_hasNoSideEffectsOnDeletionError() async throws
}

typealias FailableStoreSpecs = FailableLoadDataStoreSpecs & FailableSaveDataStoreSpecs & FailableClearDataStoreSpecs

