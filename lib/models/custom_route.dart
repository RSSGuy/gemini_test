
import '../models/route_point.dart';

class CustomRoute {
  String? id;
  String name;
  List<RoutePoint> points;

  CustomRoute({this.id, required this.name, required this.points});

  // Factory constructor to create a CustomRoute from a Firestore document
  factory CustomRoute.fromMap(String id, Map<String, dynamic> map) {
    var pointsList = map['points'] as List;
    List<RoutePoint> points = pointsList.map((p) => RoutePoint.fromMap(p)).toList();

    return CustomRoute(
      id: id,
      name: map['name'],
      points: points,
    );
  }

  // Method to convert a CustomRoute instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'points': points.map((p) => p.toMap()).toList(),
    };
  }
}