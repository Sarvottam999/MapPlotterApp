// import 'package:helloworld/core/enums/shape_type.dart';
// import 'package:helloworld/domain/entities/shape.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:flutter_map/flutter_map.dart';

class LineShape extends Shape {
  LineShape({required List<LatLng> points})
      : super(points: points, type: ShapeType.line);

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Kilometer,
      points[0],
      points[1],
    );
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': 'Line'};

    var details = {
      'type': 'Line',
      'start':
          '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };

    if (points.length > 1) {
      details['end'] =
          '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
      details['distance'] = '${calculateDistance().toStringAsFixed(2)} km';
    } else if (points.length == 1) {
      details['current_length'] = '${const Distance().as(
            LengthUnit.Kilometer,
            points[0],
            points.last,
          ).toStringAsFixed(2)} km';
    }

    return details;
  }

  @override
List<Polyline> getPolylines() {
  return [
    Polyline(
      points: points, // or points for line, getSquarePoints() for square, etc.
      strokeWidth: 2.0,
      // color: Colors.blue,
    ),
  ];
}
}
