// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseFunctions_hh
#define firebase_include_FirebaseFunctions_hh

#include <memory>

#include <firebase/functions.h>
#include <firebase/functions/callable_reference.h>
#include <firebase/variant.h>

#include "FirebaseCore.hh"

namespace swift_firebase::swift_cxx_shims::firebase::functions {

typedef std::shared_ptr<::firebase::functions::Functions> FunctionsRef;

inline bool
functions_is_valid(const FunctionsRef& ref) {
  return ref.operator bool();
}

inline FunctionsRef
functions_get_instance(::firebase::App* app) {
  return FunctionsRef(::firebase::functions::Functions::GetInstance(app));
}

inline ::firebase::functions::HttpsCallableReference
functions_get_https_callable(FunctionsRef ref, const char* name) {
  return ref.get()->GetHttpsCallable(name);
}

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::functions::HttpsCallableResult>
https_callable_call(::firebase::functions::HttpsCallableReference ref) {
  return ref.Call();
}

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::functions::HttpsCallableResult>
https_callable_call(::firebase::functions::HttpsCallableReference ref,
                    const ::firebase::Variant& data) {
  return ref.Call(data);
}

inline ::firebase::Variant
https_callable_result_data(
    const ::firebase::functions::HttpsCallableResult& result) {
  return result.data();
}

} // namespace swift_firebase::swift_cxx_shims::firebase::functions

#endif
