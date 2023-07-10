//
//  MockDecoding.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

import Foundation

public protocol MockDecoding {
    static var decoder: JSONDecoder { get }
}

public extension MockDecoding {
    static var decoder: JSONDecoder {
        .init()
    }

    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T {
        try! decoder.decode(type, from: Data(jsonString.utf8))
    }
}
