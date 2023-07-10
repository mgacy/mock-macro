//
//  MockError.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

import Foundation

enum MockError: Error, CustomStringConvertible {
    case incorrectMember
    case missingIdentifierBinding
    case missingMemberSuffix
    case missingMockedType

    var description: String {
        switch self {
        case .incorrectMember:
            return "@Mock must be declared on a static constant or variable."
        case .missingIdentifierBinding:
            return "No identifier pattern binding."
        case .missingMemberSuffix:
            return "@Mock must be declared on a member with the `\(mockJSONMemberSuffix)` suffix."
        case .missingMockedType:
            return #"@Mock requires the mocked type as an argument, in the form "MockedType.self"."#
        }
    }
}
