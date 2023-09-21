// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseFirestore_hh
#define firebase_include_FirebaseFirestore_hh

#include <firebase/firestore.h>

using namespace ::firebase::firestore;

// Functions defined in this namespace are used to get around the lack of
// virtual function support currently in Swift. As that support changes
// these functions will go away whenever possible.
namespace swift_firebase::swift_cxx_shims::firebase::firestore {
inline Settings
firestore_settings(Firestore* firestore) {
  return firestore->settings();
}

inline DocumentReference
firestore_document(Firestore* firestore, const ::std::string document_path) {
  return firestore->Document(document_path);
}

inline CollectionReference
firestore_collection(Firestore* firestore, const ::std::string collection_path) {
  return firestore->Collection(collection_path);
}

inline Firestore*
document_firestore(DocumentReference document) {
  return document.firestore();
}

inline std::string
document_id(const DocumentReference document) {
  return document.id();
}

inline std::string
document_path(const DocumentReference document) {
  return document.path();
}

inline ::firebase::Future<DocumentSnapshot>
document_get(const DocumentReference document, Source source = Source::kDefault) {
  return document.Get(source);
}

inline DocumentReference
collection_document(CollectionReference collection, std::string document_path) {
  return collection.Document(document_path);
}
} // swift_firebase::swift_cxx_shims::firebase::firestore

#endif
