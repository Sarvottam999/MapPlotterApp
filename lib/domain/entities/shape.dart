import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';

abstract class Shape {
  List<LatLng> points;
  ShapeType type;

  Shape({
    required this.points,
    required this.type,
  });

  double calculateDistance();
  Map<String, dynamic> getDetails();
}
