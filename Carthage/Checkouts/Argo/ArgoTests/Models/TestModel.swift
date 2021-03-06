import Argo
import Curry

struct TestModel {
  let numerics: TestModelNumerics
  let string: String
  let bool: Bool
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let eStringArray: [String]
  let eStringArrayOpt: [String]?
  let userOpt: User?
  let dict: [String: String]
}

extension TestModel: Decodable {
  static func decode(j: JSON) -> Decoded<TestModel> {
    let curriedInit = curry(self.init)
    return curriedInit
      <^> j <| "numerics"
      <*> j <| ["user_opt", "name"]
      <*> j <| "bool"
      <*> j <|| "string_array"
      <*> j <||? "string_array_opt"
      <*> j <|| ["embedded", "string_array"]
      <*> j <||? ["embedded", "string_array_opt"]
      <*> j <|? "user_opt"
      <*> (j <| "dict" >>- { [String: String].decode($0) })
  }
}

struct TestModelNumerics {
  let int: Int
  let int64: Int64
  let int64String: Int64
  let double: Double
  let float: Float
  let intOpt: Int?
  let uint: UInt
  let uint64: UInt64
  let uint64String: UInt64
}

extension TestModelNumerics: Decodable {
  static func decode(j: JSON) -> Decoded<TestModelNumerics> {
    return curry(self.init)
      <^> j <| "int"
      <*> j <| "int64"
      <*> j <| "int64_string"
      <*> j <| "double"
      <*> j <| "float"
      <*> j <|? "int_opt"
      <*> j <| "uint"
      <*> j <| "uint64"
      <*> j <| "uint64_string"
  }
}
