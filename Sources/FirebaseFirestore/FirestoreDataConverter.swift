// SPDX-License-Identifier: BSD-3-Clause
import Foundation

struct FirestoreDataConverter {
  static func value(workaround: swift_firebase.swift_cxx_shims.firebase.firestore.MapFieldValue_Workaround) -> [String: Any]? {
    guard workaround.keys.size() == workaround.values.size() else { return nil }

    var dictionary = [String: Any]()
    for i in 0..<workaround.keys.size() {
      let key = workaround.keys[i]
      let value = workaround.values[i]
      guard let converted = FirestoreDataConverter.value(field: value) else { continue }
      dictionary[String(key)] = converted
    }
    return dictionary
  }

  static func value(field: firebase.firestore.FieldValue) -> Any? {
    switch field.type() {
      case .null:
      return NSNull()
      case .boolean:
      return field.boolean_value()
      case .integer:
      return field.integer_value()
      case .double:
      return field.double_value()
      case .timestamp:
      return nil
      case .string:
      return String(field.string_value())
      case .blob:
      guard let value = swift_firebase.swift_cxx_shims.firebase.firestore.field_get_blob(field) else { return nil }
      return Data(bytes: value, count: field.blob_size())
      case .reference:
      return field.reference_value()
      case .geoPoint:
      return field.geo_point_value()
      case .array:
      let values = [firebase.firestore.FieldValue](field.array_value())
      var array = [Any]()

      for value in values {
        guard let item = FirestoreDataConverter.value(field: value) else { continue }
        array.append(item)
      }

      return array
      case .map:
      let value = swift_firebase.swift_cxx_shims.firebase.firestore.field_value_workaround(field.map_value())
      var dictionary = [String: Any]()

      assert(value.keys.size() == value.values.size())

      for i in 0..<value.keys.size() {
        let key = value.keys[i]
        let mapValue = value.values[i]
        guard let converted = FirestoreDataConverter.value(field: mapValue) else { continue }
        dictionary[String(key)] = converted
      }

      return dictionary
      default:
      return nil
    }
  }
}