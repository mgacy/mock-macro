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

public struct Mock: MockDecoding {
    @mock(MyModel.self)
    static let myModelJSON = "{\"value\":5}"
}
