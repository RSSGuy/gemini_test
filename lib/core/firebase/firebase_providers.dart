
// IMPORTS for lib/core/firebase/firebase_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);

  if (auth.currentUser == null) {
    auth.signInAnonymously();
  }
  return auth.authStateChanges();
});

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final user = ref.watch(authStateChangesProvider).value;
  print('Creating DatabaseService. Current user UID: ${user?.uid}');
  return DatabaseService(firestore: firestore, uid: user?.uid);

});