// SPDX-License-Identifier: BSD-3-Clause
import Foundation

struct FirestoreDataConverter {
  static func value(workaround: swift_firebase.swift_cxx_shims.firebase.firestore.MapFieldValue_Workaround) -> [String: Any]? {
    guard workaround.keys.size() == workaround.values.size() else { return nil }

    return Dictionary(uniqueKeysWithValues: zip(workaround.keys, workaround.values).lazy.compactMap {
      guard let converted = FirestoreDataConverter.value(field: $0.1) else { return nil }
      return (key: String($0.0), value: converted)
    })
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
      return field.timestamp_value()
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
      return field.array_value().lazy.compactMap(FirestoreDataConverter.value(field:))
    case .map:
      let value = swift_firebase.swift_cxx_shims.firebase.firestore.field_value_workaround(field.map_value())
      assert(value.keys.size() == value.values.size())
      return Dictionary(uniqueKeysWithValues: zip(value.keys, value.values).lazy)
    default:
      return nil
    }
  }
}
