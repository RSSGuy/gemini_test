class UserProfile {
  final String uid;
  final String? name;
  final String? email;

  UserProfile({
    required this.uid,
    this.name,
    this.email,
  });

  UserProfile copyWith({
    String? name,
    String? email,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    // UID is typically the document ID, so not included in the map for Firestore.
    return {
      'name': name,
      'email': email,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid, // uid is passed from the document snapshot ID
      name: map['name'] as String?,
      email: map['email'] as String?,
    );
  }
}