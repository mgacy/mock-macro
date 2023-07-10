//
//  MockMacroTests.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

import MockMacroPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class MockMacroTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "mock": MockMacro.self,
    ]

    func testMacro() {
        assertMacroExpansion(
            """
            @mock(TestType.self)
            static let testTypeJSON: String = "{\"value\":5}"
            """,
            expandedSource: """
            public static var testType: TestType {
                decode(TestType.self, from: testTypeJSON)
            }
            """,
            macros: testMacros
        )
    }
}
