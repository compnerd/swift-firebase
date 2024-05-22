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
typedef std::shared_ptr<::firebase::functions::HttpsCallableReference> HttpsCallableRef;

inline bool
functions_is_valid(const FunctionsRef& ref) {
  return ref.operator bool();
}

inline FunctionsRef
functions_get_instance(::firebase::App* app) {
  return FunctionsRef(::firebase::functions::Functions::GetInstance(app));
}

inline HttpsCallableRef
functions_get_https_callable(FunctionsRef ref, const char* name) {
  // Unfortunately `HttpsCallableReference` does not use internal reference
  // counting, and as a result, we need to avoid the copy-constructor for
  // `HttpsCallableReference`. Otherwise, if Swift creates a copy of the object
  // and deletes that copy, it will result in any pending `Call` being
  // interrupted or triggering memory corruption in the case that `Call` has
  // not completed. To avoid this and to prevent Swift from seeing the copy
  // constructor, wrap with a `std::shared_ptr`.
  return HttpsCallableRef(new ::firebase::functions::HttpsCallableReference(
      std::move(ref.get()->GetHttpsCallable(name))));
}

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::functions::HttpsCallableResult>
https_callable_call(HttpsCallableRef ref) {
  return ref.get()->Call();
}

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::functions::HttpsCallableResult>
https_callable_call(HttpsCallableRef ref,
                    const ::firebase::Variant& data) {
  return ref.get()->Call(data);
}

inline ::firebase::Variant
https_callable_result_data(
    const ::firebase::functions::HttpsCallableResult& result) {
  return result.data();
}

} // namespace swift_firebase::swift_cxx_shims::firebase::functions

#endif
