// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseFirestore_hh
#define firebase_include_FirebaseFirestore_hh

#include <firebase/firestore.h>

// Functions defined in this namespace are used to get around the lack of
// virtual function support currently in Swift. As that support changes
// these functions will go away whenever possible.
namespace swift_firebase::swift_cxx_shims::firebase::firestore {
inline ::firebase::firestore::Settings
firestore_settings(::firebase::firestore::Firestore* firestore) {
  return firestore->settings();
}

inline ::firebase::firestore::DocumentReference
firestore_document(::firebase::firestore::Firestore* firestore, const ::std::string document_path) {
  return firestore->Document(document_path);
}

inline ::firebase::firestore::CollectionReference
firestore_collection(::firebase::firestore::Firestore* firestore, const ::std::string collection_path) {
  return firestore->Collection(collection_path);
}

inline ::firebase::firestore::Firestore*
document_firestore(::firebase::firestore::DocumentReference document) {
  return document.firestore();
}

inline std::string
document_id(const ::firebase::firestore::DocumentReference document) {
  return document.id();
}

inline std::string
document_path(const ::firebase::firestore::DocumentReference document) {
  return document.path();
}

inline ::firebase::Future<::firebase::firestore::DocumentSnapshot>
document_get(const ::firebase::firestore::DocumentReference document, ::firebase::firestore::Source source = ::firebase::firestore::Source::kDefault) {
  return document.Get(source);
}

inline ::firebase::firestore::DocumentReference
collection_document(::firebase::firestore::CollectionReference collection, std::string document_path) {
  return collection.Document(document_path);
}

typedef void (*SnapshotListenerTypedCallback_SwiftWorkaround) (const ::firebase::firestore::DocumentSnapshot *snapshot,
                                                               ::firebase::firestore::Error *error_code,
                                                               const char *error_message,
                                                               void *user_data
                                                               );
inline ::firebase::firestore::ListenerRegistration
document_add_snapshot_listener(
  ::firebase::firestore::DocumentReference document,
  SnapshotListenerTypedCallback_SwiftWorkaround callback,
  void *user_data
  ) {
    return document.AddSnapshotListener([callback, user_data](const ::firebase::firestore::DocumentSnapshot &snapshot, ::firebase::firestore::Error error_code, const std::string &error_message) {
      callback(
        &snapshot,
        &error_code,
        error_message.c_str(),
        user_data
      );
    });
}

inline void
listener_registration_remove(::firebase::firestore::ListenerRegistration registration) {
  registration.Remove();
}
} // swift_firebase::swift_cxx_shims::firebase::firestore

#endif
