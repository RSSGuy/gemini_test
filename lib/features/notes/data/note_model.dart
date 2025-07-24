
import 'package:cloud_firestore/cloud_firestore.dart';


class Note {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;

  // ✅ Add constants for field names to prevent typos
  static const String fieldId = 'id';
  static const String fieldTitle = 'title';
  static const String fieldContent = 'content';
  static const String fieldCreatedAt = 'createdAt';

  Note({required this.id, required this.title, required this.content, required this.createdAt});

  // ✅ Add copyWith for easy, immutable updates
  Note copyWith({
    String? id,
    String? title,
    String? content,
    Timestamp? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      // ✅ Use the constants for safer access
      title: data[fieldTitle] ?? '',
      content: data[fieldContent] ?? '',
      createdAt: data[fieldCreatedAt] ?? Timestamp.now(),
    );
  }

  // ✅ Add toJson method to convert a Note object into a Map for Firestore
  // This is used for creating and updating documents.
  Map<String, dynamic> toJsonForCreation() {
    return {
      fieldTitle: title,
      fieldContent: content,
      // Use FieldValue.serverTimestamp() for reliable, server-side timestamps
      fieldCreatedAt: FieldValue.serverTimestamp(),
    };
  }

  // A separate map for updates if you don't want to update the timestamp every time
  Map<String, dynamic> toJsonForUpdate() {
    return {
      fieldTitle: title,
      fieldContent: content,
      // Note: We are NOT including createdAt here, so it won't be overwritten on update.
    };
  }
}