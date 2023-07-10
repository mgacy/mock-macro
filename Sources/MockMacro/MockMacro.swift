//
//  MockMacro.swift
//  MockMacro
//
//  Created by Mathew Gacy on 6/18/23.
//

/// A macro that produces a member decoding an instance of a given type from JSON.
///
/// For example, the following code:
///
/// ```swift
/// public struct Mock: MockDecoding {
///     @mock(MyModel.self)
///     static let myModelJSON = "{\"value\":5}"
/// }
/// ```
///
/// will produce the member:
///
/// ```swift
/// public static var myModel: MyModel {
///     decode(MyModel.self, from: myModelJSON)
/// }
/// ```
@attached(peer, names: arbitrary)
public macro mock<T: Decodable>(_ type: T.Type) = #externalMacro(module: "MockMacroPlugin", type: "MockMacro")
