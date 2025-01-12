// import 'package:helloworld/core/enums/shape_type.dart';
// import 'package:helloworld/domain/entities/shape.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';

class SquareShape extends Shape {
  SquareShape({required List<LatLng> points})
      : super(points: points, type: ShapeType.square);

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Kilometer,
      points[0],
      points[1],
    );
  }

  List<LatLng> getSquarePoints() {
    if (points.length != 2) return [];

    final dx = points[1].longitude - points[0].longitude;
    final dy = points[1].latitude - points[0].latitude;

    return [
      points[0],
      LatLng(points[0].latitude, points[1].longitude),
      points[1],
      LatLng(points[1].latitude, points[0].longitude),
      points[0],
    ];
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': 'Square'};

    var details = {
      'type': 'Square',
      'start':
          '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };

    if (points.length > 1) {
      details['end'] =
          '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
      details['side_length'] = '${calculateDistance().toStringAsFixed(2)} km';
      details['area'] =
          '${(calculateDistance() * calculateDistance()).toStringAsFixed(2)} km²';
    } else if (points.length == 1) {
      var currentDistance = const Distance().as(
        LengthUnit.Kilometer,
        points[0],
        points.last,
      );
      details['current_side'] = '${currentDistance.toStringAsFixed(2)} km';
      details['current_area'] =
          '${(currentDistance * currentDistance).toStringAsFixed(2)} km²';
    }

    return details;
  }
}
