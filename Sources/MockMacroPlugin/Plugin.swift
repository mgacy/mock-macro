//
//  Plugin.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MockPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MockMacro.self
    ]
}
#endif
