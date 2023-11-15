// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseAuth_hh
#define firebase_include_FirebaseAuth_hh

#include <firebase/auth.h>

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

typedef void (*AuthStateListenerCallback)(::firebase::auth::Auth *auth,
                                          ::firebase::auth::User *user,
                                          void *user_data);

class ApplicationAuthStateListener
    : public ::firebase::auth::AuthStateListener {
public:
  ApplicationAuthStateListener(AuthStateListenerCallback initial_callback,
                               void *initial_data)
      : callback(initial_callback), user_data(initial_data) {}

  void OnAuthStateChanged(::firebase::auth::Auth *auth) override {
    ::firebase::auth::User user = auth->current_user();
    callback(auth, &user, user_data);
  }

private:
  AuthStateListenerCallback callback;
  void *user_data;
};

/// @brief Allocate an auth listener on the heap and return it configured with the passed in parameters.
/// @param callback This is the callback that you would like to run whenever Firebase tells us that auth has changed, typically you will construct this inline with the function call.
/// @param user_data This can be used to serialize a Swift closure into so that you can pull it back out when `callback` is run.
/// @return A heap-allocated auth listener.
inline ::firebase::auth::AuthStateListener *
create_auth_state_listener(AuthStateListenerCallback callback,
                           void *user_data) {
  return new ApplicationAuthStateListener(callback, user_data);
}
} // namespace swift_firebase::swift_cxx_shims::firebase::auth

#endif
