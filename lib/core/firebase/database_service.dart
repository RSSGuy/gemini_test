// IMPORTS for lib/core/firebase/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../errors/exceptions.dart';
import '../providers/core_providers.dart';
import '../../features/notes/data/note_model.dart';

class DatabaseService {
  final FirebaseFirestore firestore;
  final String? uid;
  DatabaseService({required this.firestore, required this.uid});

  Future<List<Note>> getNotes() async {
    if (uid == null) return [];
    try {
      final snapshot = await firestore.collection('users').doc(uid).collection('notes')
          .orderBy('createdAt', descending: true).get();
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to get notes');
      throw DatabaseException('Could not load notes.');
    }
  }



  /*Future<void> createNote({required String title, required String content}) async {
    if (uid == null) throw DatabaseException('User not signed in.');
    try {
      final noteId = uuidProvider.v4();

      await firestore.collection('users').doc(uid).collection('notes').doc(noteId).set({'title': title, 'content': content, 'createdAt': FieldValue.serverTimestamp(),});
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to create note');
      throw DatabaseException('Could not save note.');
    }
  }*/
  Future<void> createNote({required String title, required String content}) async {
    if (uid == null) throw DatabaseException('User not signed in.');
    try {
      final noteId = uuidProvider.v4();

      await firestore.collection('users').doc(uid).collection('notes').doc(noteId).set({'title': title, 'content': content, 'createdAt': FieldValue.serverTimestamp(),});
      //await FirebaseFirestore.instance.collection('users').add({'title': title, 'content': content, 'createdAt': FieldValue.serverTimestamp(),});
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to create note');
      throw DatabaseException('Could not save note.');
    }
  }

  Future<void> updateNote({required String noteId, required String title, required String content}) async {
    if (uid == null) throw DatabaseException('User not signed in.');
    try {
      await firestore.collection('users').doc(uid).collection('notes').doc(noteId).update({'title': title, 'content': content,});
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to update note');
      throw DatabaseException('Could not update note.');
    }
  }

  Future<void> deleteNote({required String noteId}) async {
    if (uid == null) throw DatabaseException('User not signed in.');
    try {
      await firestore.collection('users').doc(uid).collection('notes').doc(noteId).delete();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to delete note');
      throw DatabaseException('Could not delete note.');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (uid == null) return null;
    try {
      final docSnapshot = await firestore.collection('users').doc(uid).get();
      return docSnapshot.data();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to get user profile');
      throw DatabaseException('Could not load profile.');
    }
  }

  Future<void> updateUserProfile(String name, String email) async {
    if (uid == null) throw DatabaseException('User not signed in.');
    try {
      await firestore.collection('users').doc(uid).set({'name': name, 'email': email, 'lastUpdated': FieldValue.serverTimestamp(),}, SetOptions(merge: true));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Failed to update user profile');
      throw DatabaseException('Could not save profile.');
    }
  }
}