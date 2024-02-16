#ifndef firebase_include_TransactionWeakReference_hh
#define firebase_include_TransactionWeakReference_hh

#include <memory>

namespace swift_firebase::swift_cxx_shims::firebase::firestore {

// Transaction is non-copyable so we need a wrapper type that is copyable.
// This type will hold a valid Transaction during the scope of a RunTransaction
// callback (see Firestore+Swift.swift for details).
class TransactionWeakReference {
 public:
  ~TransactionWeakReference() = default;

  TransactionWeakReference(const TransactionWeakReference& other)
      : container_(other.container_) {}
  TransactionWeakReference& operator=(const TransactionWeakReference& other) {
    container_ = other.container_;
    return *this;
  }

  TransactionWeakReference(::firebase::firestore::Transaction* transaction = nullptr)
      : container_(std::make_shared<Container>(transaction)) {}
  void reset(::firebase::firestore::Transaction* transaction = nullptr) {
    container_->transaction = transaction;
  }

  bool is_valid() const { return container_->transaction != nullptr; }

  // API wrappers to access the underlying Transaction:

  void Set(const ::firebase::firestore::DocumentReference& document,
           const ::firebase::firestore::MapFieldValue& data,
           const ::firebase::firestore::SetOptions& options =
              ::firebase::firestore::SetOptions()) const {
    container_->transaction->Set(document, data, options);
  }

  void Update(const ::firebase::firestore::DocumentReference& document,
              const ::firebase::firestore::MapFieldValue& data) const {
    container_->transaction->Update(document, data);
  }

  void Update(const ::firebase::firestore::DocumentReference& document,
              const ::firebase::firestore::MapFieldPathValue& data) const {
    container_->transaction->Update(document, data);
  }

  void Delete(const ::firebase::firestore::DocumentReference& document) const {
    container_->transaction->Delete(document);
  }

  ::firebase::firestore::DocumentSnapshot Get(
      const ::firebase::firestore::DocumentReference& document,
      ::firebase::firestore::Error* error_code,
      std::string* error_message) const {
    return container_->transaction->Get(document, error_code, error_message);
  }

 private:
  struct Container {
    Container(::firebase::firestore::Transaction* transaction)
        : transaction(transaction) {}
    ::firebase::firestore::Transaction* transaction;
  };
  std::shared_ptr<Container> container_;
};

} // namespace swift_firebase::swift_cxx_shims::firebase::firestore

#endif
