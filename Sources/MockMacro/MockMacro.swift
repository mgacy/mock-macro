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
/// public enum Mock {
///     static var decoder: JSONDecoder = {
///         let decoder = JSONDecoder()
///         decoder.dateDecodingStrategy = .iso8601
///         return decoder
///     }()
///
///     static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T {
///         try! decoder.decode(type, from: jsonString.data(using: .utf8)!)
///     }
///
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
