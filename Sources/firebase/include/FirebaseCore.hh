#ifndef firebase_include_FirebaseCore_hh
#define firebase_include_FirebaseCore_hh

#include <firebase/util.h>

namespace swift_firebase::swift_cxx_shims::firebase {

/*
template <class ResultType>
class FutureWithResultOrError {
 public:
  typedef void (*Callback)(
      const ResultType* result, int error, void* user_data);
};

template <class ResultType> inline void
future_with_result_or_error(
    const ::firebase::Future<ResultType>& future,
    FutureWithResultOrError<ResultType>::Callback callback,
    void* user_data) {
  // XXX
}
*/

/*
template <class ResultType> inline bool
future_wait(const ::firebase::Future<ResultType>& future, int timeout_milliseconds) {
  return future.Wait(timeout_milliseconds);
}
*/

typedef void (*CompletionType)(void*);

// This class exists to provide protocol conformance to FutureProtocol.
template <class R> class ConformingFuture: public ::firebase::Future<R> {
 public:
  typedef R ResultType;
  //typedef ::firebase::Future<R> FutureType;
  //typedef ::firebase::Future<R>::TypedCompletionCallback TypedCompletionCallback;

  ConformingFuture(const ::firebase::Future<R>& rhs)
      : ::firebase::Future<R>(rhs) {}

  //FutureType AsFuture() {
  //  return *this;
  //}
  //
  
  //typedef int CompletionType;
  //void CallOnCompletion(CompletionType c) {}

  void Foo() const {}

  void CallOnCompletion(void* completion) const {
    // 
  }
} __attribute__((swift_attr("conforms_to:FirebaseCore.FutureProtocol")));


} // namespace swift_firebase::swift_cxx_shims::firebase

#endif
