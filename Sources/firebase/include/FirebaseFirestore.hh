
#ifndef firebase_include_FirebaseFirestore_hh
#define firebase_include_FirebaseFirestore_hh

#include <firebase/firestore.h>

// Functions defined in this namespace are used to get around the lack of
// virtual function support currently in Swift. As that support changes
// these functions will go away whenever possible.
using namespace ::firebase::firestore;

namespace swift_firebase::swift_cxx_shims::firebase::firestore {

inline Settings
firestore_settings(const Firestore firestore) {
  return firestore.settings();
}

inline DocumentReference
firestore_document(const Firestore firestore, ::std::string document_path) {
  return firestore.Document(
    document_path
  );
}

inline CollectionReference
firestore_collection(const Firestore firestore, ::std::string collection_path) {
  return firestore.Collection(collection_path);
}

/**
 * @brief Get the Firestore instance from a given Document
 *
 * @param[in] document The document from which the Firestore instance should be extracted from.
 *
 * @return A pointer to the Firestore instance the passed in Document is in.
*/
inline Firestore *
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
  return collection.Document(
    document_path
  );
}
}

#endif