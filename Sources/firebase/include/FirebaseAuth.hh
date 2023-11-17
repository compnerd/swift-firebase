// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseAuth_hh
#define firebase_include_FirebaseAuth_hh

#include <firebase/auth.h>

// https://github.com/apple/swift/issues/69959
#if __has_include(<swift/bridging>)
#include <swift/bridging>
#else
#define SWIFT_UNSAFE_REFERENCE                        \
  __attribute__((__swift_attr__("import_reference"))) \
  __attribute__((__swift_attr__("retain:immortal")))  \
  __attribute__((__swift_attr__("release:immortal")))
#endif

namespace swift_firebase::swift_cxx_shims::firebase::auth {
inline std::string
user_display_name(const ::firebase::auth::User &user) noexcept {
  return user.display_name();
}

inline std::string user_email(const ::firebase::auth::User &user) noexcept {
  return user.email();
}

inline std::string
user_phone_number(const ::firebase::auth::User &user) noexcept {
  return user.phone_number();
}

inline std::string user_photo_url(const ::firebase::auth::User &user) noexcept {
  return user.photo_url();
}

inline std::string
user_provider_id(const ::firebase::auth::User &user) noexcept {
  return user.provider_id();
}

inline std::string user_uid(const ::firebase::auth::User &user) noexcept {
  return user.uid();
}

class SWIFT_UNSAFE_REFERENCE AuthStateListener
    : public ::firebase::auth::AuthStateListener {
  typedef void (*Handler)(::firebase::auth::Auth *auth,
                          ::firebase::auth::User *user, void *user_data);

public:
  AuthStateListener(Handler handler, void *data) noexcept
      : block_(handler), user_data_(data) {}

  AuthStateListener(const AuthStateListener &) = delete;
  AuthStateListener &operator=(const AuthStateListener &) = delete;

  AuthStateListener(AuthStateListener &&) = delete;
  AuthStateListener &operator=(AuthStateListener &&) = delete;

  void OnAuthStateChanged(::firebase::auth::Auth *auth) override {
    ::firebase::auth::User user = auth->current_user();
    block_(auth, &user, user_data_);
  }

  /// @brief Allocate an auth listener on the heap and return it configured with the passed in parameters.
  /// @param handler This is the callback that you would like to run whenever Firebase tells us that auth has changed, typically you will construct this inline with the function call.
  /// @param user_data User specified data that will be passed to the handler.
  /// @return A heap-allocated auth listener.
  static inline ::firebase::auth::AuthStateListener *
  Create(Handler handler, void *user_data) noexcept {
    return new AuthStateListener(handler, user_data);
  }

  static inline void Destroy(void *listener) noexcept {
    delete reinterpret_cast<AuthStateListener *>(listener);
  }

private:
  Handler block_;
  void *user_data_;
};
} // namespace swift_firebase::swift_cxx_shims::firebase::auth

#endif
