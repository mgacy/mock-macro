//
//  main.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

import Foundation
import MockMacro

public struct MyModel: Codable {
    let value: Int
}

public enum Mock {
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T {
        try! decoder.decode(type, from: jsonString.data(using: .utf8)!)
    }

    @mock(MyModel.self)
    static let myModelJSON = "{\"value\":5}"
}
