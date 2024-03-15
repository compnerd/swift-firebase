// SPDX-License-Identifier: BSD-3-Clause

#ifndef firebase_include_FirebaseFirestore_hh
#define firebase_include_FirebaseFirestore_hh

#include <string>
#include <utility>

#include <firebase/firestore.h>

#include "FirebaseCore.hh"
#include "TransactionWeakReference.hh"

// Functions defined in this namespace are used to get around the lack of
// virtual function support currently in Swift. As that support changes
// these functions will go away whenever possible.
namespace swift_firebase::swift_cxx_shims::firebase::firestore {

inline ::firebase::firestore::Settings
firestore_settings(::firebase::firestore::Firestore *firestore) {
  return firestore->settings();
}

inline ::firebase::firestore::DocumentReference
firestore_document(::firebase::firestore::Firestore *firestore,
                   const ::std::string &document_path) {
  return firestore->Document(document_path);
}

inline ::firebase::firestore::CollectionReference
firestore_collection(::firebase::firestore::Firestore *firestore,
                     const ::std::string &collection_path) {
  return firestore->Collection(collection_path);
}

typedef ::firebase::firestore::Error (*FirebaseRunTransactionUpdateCallback)(
    TransactionWeakReference *transaction,
    std::string& error_message,
    void *user_data);
inline ::swift_firebase::swift_cxx_shims::firebase::VoidFuture
firestore_run_transaction(
    ::firebase::firestore::Firestore *firestore,
    ::firebase::firestore::TransactionOptions options,
    FirebaseRunTransactionUpdateCallback update_callback,
    void *user_data) {
  return ::swift_firebase::swift_cxx_shims::firebase::VoidFuture::From(
      firestore->RunTransaction(options, [update_callback, user_data](
          ::firebase::firestore::Transaction& transaction,
          std::string& error_message
      ) -> ::firebase::firestore::Error {
        TransactionWeakReference transaction_ref(&transaction);
        ::firebase::firestore::Error error =
            update_callback(&transaction_ref, error_message, user_data);
        transaction_ref.reset();
        return error;
      }));
}

inline ::firebase::firestore::WriteBatch
firestore_batch(::firebase::firestore::Firestore *firestore) {
  return firestore->batch();
}

// MARK: - DocumentReference

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

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::firestore::DocumentSnapshot>
document_get(const ::firebase::firestore::DocumentReference document,
             ::firebase::firestore::Source source =
                 ::firebase::firestore::Source::kDefault) {
  return document.Get(source);
}

inline ::swift_firebase::swift_cxx_shims::firebase::VoidFuture
document_set_data(::firebase::firestore::DocumentReference document,
                  const ::firebase::firestore::MapFieldValue data,
                  const ::firebase::firestore::SetOptions options) {
  return ::swift_firebase::swift_cxx_shims::firebase::VoidFuture::From(
      document.Set(data, options));
}

inline ::firebase::firestore::CollectionReference
document_collection(::firebase::firestore::DocumentReference document,
                    const ::std::string &collection_path) {
  return document.Collection(collection_path);
}

// MARK: - DocumentSnapshot

inline ::firebase::firestore::DocumentReference
document_snapshot_reference(const ::firebase::firestore::DocumentSnapshot snapshot) {
  return snapshot.reference();
}

inline bool
document_snapshot_exists(const ::firebase::firestore::DocumentSnapshot &snapshot) {
  return snapshot.exists();
}

#if SR69711
struct MapFieldValue_Workaround {
  std::vector<std::string> keys;
  std::vector<::firebase::firestore::FieldValue> values;
};

inline MapFieldValue_Workaround map_field_value_to_workaround(
    const ::firebase::firestore::MapFieldValue value) {
  MapFieldValue_Workaround data;
  data.keys.reserve(value.size());
  data.values.reserve(value.size());

  for (const auto &kv : value) {
    data.keys.emplace_back(kv.first);
    data.values.emplace_back(kv.second);
  }

  return std::move(data);
}

inline MapFieldValue_Workaround document_snapshot_get_data_workaround(
    const ::firebase::firestore::DocumentSnapshot snapshot,
    const ::firebase::firestore::DocumentSnapshot::ServerTimestampBehavior
        stb) {
  auto snap = snapshot.GetData(stb);

  return map_field_value_to_workaround(snap);
}

MapFieldValue_Workaround
field_value_workaround(::firebase::firestore::MapFieldValue value) {
  return map_field_value_to_workaround(value);
}
#endif

inline const ::std::string&
document_snapshot_id(::firebase::firestore::DocumentSnapshot snapshot) {
  return snapshot.id();
}

// MARK: CollectionReference

inline ::firebase::firestore::DocumentReference
collection_document(::firebase::firestore::CollectionReference collection,
                    const ::std::string &document_path) {
  return collection.Document(document_path);
}

inline ::std::string
collection_path(const ::firebase::firestore::CollectionReference& collection) {
  return collection.path();
}

inline ::firebase::firestore::Query
collection_as_query(::firebase::firestore::CollectionReference collection) {
  return collection;
}

typedef void (*DocumentSnapshotListenerTypedCallback)(
    const ::firebase::firestore::DocumentSnapshot *snapshot,
    ::firebase::firestore::Error error_code, const char *error_message,
    void *user_data);
inline ::firebase::firestore::ListenerRegistration
document_add_snapshot_listener(
    bool include_metadata_changes,
    ::firebase::firestore::DocumentReference document,
    DocumentSnapshotListenerTypedCallback callback, void *user_data) {
  return document.AddSnapshotListener(
      include_metadata_changes ? ::firebase::firestore::MetadataChanges::kInclude : ::firebase::firestore::MetadataChanges::kExclude,
      [callback, user_data](
          const ::firebase::firestore::DocumentSnapshot &snapshot,
          ::firebase::firestore::Error error_code,
          const std::string &error_message) {
        callback(&snapshot, error_code, error_message.c_str(), user_data);
      });
}

inline void listener_registration_remove(
    ::firebase::firestore::ListenerRegistration registration) {
  registration.Remove();
}

const uint8_t *field_get_blob(const ::firebase::firestore::FieldValue field) {
  return field.blob_value();
}

typedef std::vector<::firebase::firestore::FieldValue> FirestoreFieldValues;

// MARK: - DocumentChange

inline ::firebase::firestore::DocumentChange::Type
document_change_type(const ::firebase::firestore::DocumentChange change) {
  return change.type();
}

inline ::firebase::firestore::DocumentSnapshot
document_change_document(const ::firebase::firestore::DocumentChange change) {
  return change.document();
}

inline ::std::size_t
document_change_old_index(const ::firebase::firestore::DocumentChange change) {
  return change.old_index();
}

inline ::std::size_t
document_change_new_index(const ::firebase::firestore::DocumentChange change) {
  return change.new_index();
}

// MARK: Query

inline ::firebase::firestore::Firestore*
query_firestore(::firebase::firestore::Query query) {
  return query.firestore();
}

inline ::swift_firebase::swift_cxx_shims::firebase::Future<
    ::firebase::firestore::QuerySnapshot>
query_get(const ::firebase::firestore::Query query,
             ::firebase::firestore::Source source =
                 ::firebase::firestore::Source::kDefault) {
  return query.Get(source);
}

typedef void (*QuerySnapshotListenerTypedCallback)(
    const ::firebase::firestore::QuerySnapshot *snapshot,
    ::firebase::firestore::Error error_code, const char *error_message,
    void *user_data);
inline ::firebase::firestore::ListenerRegistration
query_add_snapshot_listener(
    bool include_metadata_changes,
    ::firebase::firestore::Query query,
    QuerySnapshotListenerTypedCallback callback, void *user_data) {
  return query.AddSnapshotListener(
      include_metadata_changes ? ::firebase::firestore::MetadataChanges::kInclude : ::firebase::firestore::MetadataChanges::kExclude,
      [callback, user_data](
          const ::firebase::firestore::QuerySnapshot &snapshot,
          ::firebase::firestore::Error error_code,
          const std::string &error_message) {
        callback(&snapshot, error_code, error_message.c_str(), user_data);
      });
}

inline ::firebase::firestore::Query
query_where_equal_to(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereEqualTo(field, value);
}

inline ::firebase::firestore::Query
query_where_not_equal_to(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereNotEqualTo(field, value);
}

inline ::firebase::firestore::Query
query_where_less_than(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereLessThan(field, value);
}

inline ::firebase::firestore::Query
query_where_less_than_or_equal_to(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereLessThanOrEqualTo(field, value);
}

inline ::firebase::firestore::Query
query_where_greater_than(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereGreaterThan(field, value);
}

inline ::firebase::firestore::Query
query_where_greater_than_or_equal_to(
    const ::firebase::firestore::Query& query,
    const std::string& field,
    const ::firebase::firestore::FieldValue& value) {
  return query.WhereGreaterThanOrEqualTo(field, value);
}

// MARK: QuerySnapshot

inline ::firebase::firestore::Query
query_snapshot_query(const ::firebase::firestore::QuerySnapshot& snapshot) {
  return snapshot.query();
}

inline ::firebase::firestore::SnapshotMetadata
query_snapshot_metadata(const ::firebase::firestore::QuerySnapshot& snapshot) {
  return snapshot.metadata();
}

inline std::vector<::firebase::firestore::DocumentChange>
query_snapshot_document_changes(
    const ::firebase::firestore::QuerySnapshot& snapshot,
    ::firebase::firestore::MetadataChanges metadata_changes =
        ::firebase::firestore::MetadataChanges::kExclude) {
  return snapshot.DocumentChanges(metadata_changes);
}

inline std::vector<::firebase::firestore::DocumentSnapshot>
query_snapshot_documents(const ::firebase::firestore::QuerySnapshot& snapshot) {
  return snapshot.documents();
}

inline std::size_t
query_snapshot_size(const ::firebase::firestore::QuerySnapshot& snapshot) {
  return snapshot.size();
}

// MARK: WriteBatch

inline ::firebase::firestore::WriteBatch&
write_batch_set(
    ::firebase::firestore::WriteBatch write_batch,
    const ::firebase::firestore::DocumentReference& document,
    const ::firebase::firestore::MapFieldValue& data,
    const ::firebase::firestore::SetOptions& options =
        ::firebase::firestore::SetOptions()) {
  return write_batch.Set(document, data, options);
}

inline ::firebase::firestore::WriteBatch&
write_batch_update(
    ::firebase::firestore::WriteBatch write_batch,
    const ::firebase::firestore::DocumentReference& document,
    const ::firebase::firestore::MapFieldValue& data) {
  return write_batch.Update(document, data);
}

inline ::firebase::firestore::WriteBatch&
write_batch_update(
    ::firebase::firestore::WriteBatch write_batch,
    const ::firebase::firestore::DocumentReference& document,
    const ::firebase::firestore::MapFieldPathValue& data) {
  return write_batch.Update(document, data);
}

inline ::firebase::firestore::WriteBatch&
write_batch_delete(
    ::firebase::firestore::WriteBatch write_batch,
    const ::firebase::firestore::DocumentReference& document) {
  return write_batch.Delete(document);
}

inline ::swift_firebase::swift_cxx_shims::firebase::VoidFuture
write_batch_commit(::firebase::firestore::WriteBatch write_batch) {
  return ::swift_firebase::swift_cxx_shims::firebase::VoidFuture::From(
      write_batch.Commit());
}

} // namespace swift_firebase::swift_cxx_shims::firebase::firestore

#endif
