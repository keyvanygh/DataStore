//
//  XCTestCase + extension.swift
//
//
//  Created by Keyvan Yaghoubian on 9/27/24.
//

import XCTest

extension XCTestCase {
    func XCTAssertThrowsErrorAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            // An error was expected, but the async function did not throw one
            let customMessage = message()
            if customMessage.isEmpty {
                XCTFail("Expected error to be thrown, but no error was thrown.", file: file, line: line)
            } else {
                XCTFail(customMessage, file: file, line: line)
            }
        } catch {
            // An error was thrown, pass it to the errorHandler for further checks
            errorHandler(error)
        }
    }

    func XCTAssertNoThrowAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
            // No error was thrown, which is expected
        } catch {
            // An unexpected error was thrown
            let customMessage = message()
            if customMessage.isEmpty {
                XCTFail("Asynchronous call threw an unexpected error: \(error).", file: file, line: line)
            } else {
                XCTFail(customMessage, file: file, line: line)
            }
        }
    }

}
