import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/profile/data/user_profile_model.dart'; // This import is crucial

class DatabaseService {
  final FirebaseFirestore _db;

  DatabaseService(this._db);

  Future<UserProfile?> getUserProfile(String uid) async {
    final docSnap = await _db.collection('users').doc(uid).get();
    if (docSnap.exists && docSnap.data() != null) {
      // Ensure UserProfile.fromMap exists and is called correctly
      return UserProfile.fromMap(docSnap.data()!, uid);
    }
    return null;
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated to update profile.");
    }
    // userProfile.uid should be the authenticated user's UID
    await _db.collection('users').doc(userProfile.uid).set(userProfile.toMap(), SetOptions(merge: true));
  }
}
