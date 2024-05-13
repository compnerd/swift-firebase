// SPDX-License-Identifier: BSD-3-Clause

@_exported
import firebase

enum VariantConversionError: Error {
  case unsupportedType
}

@_spi(FirebaseInternal)
public func toVariant(_ object: Any?) throws -> firebase.Variant {
  if object == nil {
    return .init()
  } else if let string = object as? String {
    return .init(std.string(string))
  } else if let dict = object as? Dictionary<String, Any> {
    var result = firebase.Variant()
    result.set_map(.init())
    try dict.forEach { element in
      let value = try toVariant(element.value)
      swift_firebase.swift_cxx_shims.firebase.variant_map_insert(
        &result, firebase.Variant(std.string(element.key)), value
      )
    }
    return result
  } else {
    // TODO(bcny/PRENG-63977): Handle other data types.
    throw VariantConversionError.unsupportedType
  }
}

@_spi(FirebaseInternal)
public func fromVariant(_ variant: firebase.Variant) throws -> Any? {
  if variant.is_bool() {
    return swift_firebase.swift_cxx_shims.firebase.variant_bool_value(variant)
  } else if variant.is_null() {
    return nil
  } else {
    // TODO(bcny/PRENG-63977): Handle other data types.
    throw VariantConversionError.unsupportedType
  }
}
