import 'package:cloud_firestore/cloud_firestore.dart';

class RoutePoint {
  final double latitude;
  final double longitude;
  String? text;
  String? imageUrl;

  RoutePoint({
    required this.latitude,
    required this.longitude,
    this.text,
    this.imageUrl,
  });

  // Factory constructor to create a RoutePoint from a Firestore document
  factory RoutePoint.fromMap(Map<String, dynamic> map) {
    return RoutePoint(
      latitude: map['latitude'],
      longitude: map['longitude'],
      text: map['text'],
      imageUrl: map['imageUrl'],
    );
  }

  // Method to convert a RoutePoint instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'text': text,
      'imageUrl': imageUrl,
    };
  }
}