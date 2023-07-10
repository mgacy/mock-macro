//
//  Macro.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

let mockJSONMemberSuffix = "JSON"

public struct MockMacro: PeerMacro {
    public static func expansion<Context, Declaration>(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] where Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol {
        // Get new member type
        guard
            case .argumentList(let arguments) = node.argument,
            arguments.count == 1,
            let memberAccessExpr = arguments.first?.expression.as(MemberAccessExprSyntax.self),
            let mockedType = memberAccessExpr.base?.as(IdentifierExprSyntax.self)
        else {
            throw MockError.missingMockedType
        }

        // Only allow on static variables
        guard
            let variableDecl = declaration.as(VariableDeclSyntax.self),
            variableDecl.modifiers?
                .first(where: { $0.name.tokenKind == TokenKind.keyword(.static) })?
                .as(DeclModifierSyntax.self) != nil
        else {
            throw MockError.incorrectMember
        }

        // Get JSON member
        guard
            let binding = variableDecl.bindings.first,
            let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self)
        else {
            throw MockError.missingIdentifierBinding
        }

        let member = makeMock(
            try makeMemberName(identifierPattern.identifier),
            of: mockedType.trimmed,
            decoding: IdentifierExprSyntax(identifier: identifierPattern.identifier))

        return [
            DeclSyntax(member)
        ]
    }
}

extension MockMacro {
    static func makeMemberName(_ identifier: TokenSyntax) throws -> IdentifierPatternSyntax {
        guard
            case .identifier(let memberName) = identifier.tokenKind,
            memberName.hasSuffix(mockJSONMemberSuffix)
        else {
            throw MockError.missingMemberSuffix
        }

        let mockMemberName = String(memberName.dropLast(mockJSONMemberSuffix.count))
        return IdentifierPatternSyntax(identifier: .identifier(mockMemberName))
    }

    static func makeMock(
        _ variableName: IdentifierPatternSyntax,
        of modelType: IdentifierExprSyntax,
        decoding json: IdentifierExprSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: ModifierListSyntax {
                DeclModifierSyntax(name: "public")
                DeclModifierSyntax(name: "static")
            },
            bindingKeyword: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: variableName,
                    typeAnnotation: TypeAnnotationSyntax(
                        type: SimpleTypeIdentifierSyntax(name: modelType.identifier)
                    ),
                    accessor: .getter(
                        CodeBlockSyntax {
                            FunctionCallExprSyntax(
                                callee: IdentifierExprSyntax(identifier: "decode"),
                                argumentList: {
                                    TupleExprElementSyntax(
                                        expression: MemberAccessExprSyntax(
                                            base: modelType,
                                            dot: .periodToken(),
                                            name: .identifier("self")
                                        )
                                    )
                                    TupleExprElementSyntax(
                                        label: "from",
                                        expression: json.trimmed
                                    )
                                }
                            )
                        }
                    )
                )
            }
        )
    }
}
