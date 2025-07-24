
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added
import '../services/auth_service.dart';
import '../services/database_service.dart'; // Added

final sideMenuCollapsedProvider = StateProvider<bool>((ref) => false);
const uuidProvider = Uuid();
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

// Firebase Auth Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Firestore & Database Service Providers
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance); // Added

final databaseServiceProvider = Provider<DatabaseService>((ref) { // Added
  return DatabaseService(ref.watch(firebaseFirestoreProvider));
});
