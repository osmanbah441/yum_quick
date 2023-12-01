import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreQueryOffset on Query {
  Query offset(int offset) {
    if (offset < 0) {
      throw ArgumentError('Offset cannot be negative.');
    }
    final startAt = orderBy(FieldPath.documentId).startAfter([offset]);
    return startAt;
  }
}
