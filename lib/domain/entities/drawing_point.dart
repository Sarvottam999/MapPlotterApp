 

import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';

class DrawingPoint {
  final LatLng point;
  final ShapeType shapeType;

  DrawingPoint({
    required this.point,
    required this.shapeType,
  });
}
