
#ifndef firebase_include_FirebaseFirestore_hh
#define firebase_include_FirebaseFirestore_hh

#include <firebase/firestore.h>

// Functions defined in this namespace are used to get around the lack of
// virtual function support currently in Swift. As that support changes
// these functions will go away whenever possible.
namespace swift_firebase::swift_cxx_shims::firebase::firestore {

inline ::firebase::firestore::DocumentReference
firestore_document(const ::firebase::firestore::Firestore firestore, ::std::string document_path) {
  return firestore.Document(
    document_path
  );
}

/**
 * @brief Get the Firestore instance from a given Document
 *
 * @param[in] document The document from which the Firestore instance should be extracted from.
 *
 * @return A pointer to the Firestore instance the passed in Document is in.
*/
inline ::firebase::firestore::Firestore *
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
}

#endif