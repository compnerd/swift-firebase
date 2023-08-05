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

inline std::string
user_uid(const ::firebase::auth::User &user) noexcept {
  return user.uid();
}
}

#endif

