// SPDX-License-Identifier: BSD-3-Clause
import Foundation

import Cxx

internal struct FirestoreDataConverter {
  static func value(workaround: swift_firebase.swift_cxx_shims.firebase.firestore.MapFieldValue_Workaround) -> [String: Any] {
    guard workaround.keys.size() == workaround.values.size() else { fatalError("Internal error: keys and values should be the same size.") }

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

  /// Maps a Swift version of a Firestore document into a `MapFieldValue` as expected by the
  /// Firestore set and update functions.
  ///
  /// - Parameter document: The dictionary that describes the document of data you'd like to create.
  /// - Returns: a `MapFieldValue` with converted types that Firestore will understand.
  internal static func firestoreValue(document: [String: Any]) -> firebase.firestore.MapFieldValue {
    var map = firebase.firestore.MapFieldValue()
    for item in document {
      guard let value = firestoreValue(field: item.value) else { continue }
      map[std.string(item.key)] = value
    }
    return map
  }

  /// Converts Swift values to their corresponding Firestore `FieldValue`s.
  /// - Parameter field: A Swift value you'd like to convert into a `FieldValue`
  /// - Returns: The `FieldValue` or `nil` that is the Firestore analog of the passed in value.
  internal static func firestoreValue(field: Any) -> firebase.firestore.FieldValue? {
    switch field.self {
    case is NSNull:
      return firebase.firestore.FieldValue.Null()
    case is Bool:
      guard let bool = field as? Bool else { return nil }
      return firebase.firestore.FieldValue.Boolean(bool)
    case is Int:
      guard let int = field as? Int64 else { return nil }
      return firebase.firestore.FieldValue.Integer(int)
    case is Double:
      guard let double = field as? Double else { return nil }
      return firebase.firestore.FieldValue.Double(double)
    case is Date:
      guard let date = field as? Date else { return nil }
      return firebase.firestore.FieldValue.Timestamp(date.firestoreTimestamp())
    case is String:
      guard let string = field as? String else { return nil }
      return firebase.firestore.FieldValue.String(std.string(string))
    case is Data:
      guard let data = field as? Data else { return nil }
      let size = data.count
      return firebase.firestore.FieldValue.Blob([UInt8](data), size)
    case is GeoPoint:
      guard let geopoint = field as? GeoPoint else { return nil }
      return firebase.firestore.FieldValue.GeoPoint(geopoint)
    case is Array<Any>:
      guard let array = field as? Array<Any> else { return nil }
      var vector = swift_firebase.swift_cxx_shims.firebase.firestore.FirestoreFieldValues()

      for element in array {
        guard let value = firestoreValue(field: element) else { continue }
        vector.push_back(value)
      }

      return firebase.firestore.FieldValue.Array(vector)
    case is Dictionary<String, Any>:
      guard let dictionary = field as? [String: Any] else { return nil }

      var map = firebase.firestore.MapFieldValue()
      for item in dictionary {
        guard let value = firestoreValue(field: item.value) else { continue }
        map[std.string(item.key)] = value
      }

      return firebase.firestore.FieldValue.Map(map)
    default:
      return nil
    }
  }
}
