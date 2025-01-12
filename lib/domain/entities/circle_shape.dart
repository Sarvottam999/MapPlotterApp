import 'dart:math';

import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:latlong2/latlong.dart';

class CircleShape extends Shape {
  CircleShape({required List<LatLng> points})
      : super(points: points, type: ShapeType.circle);

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    return const Distance().as(
      LengthUnit.Kilometer,
      points[0], // center
      points[1], // radius point
    );
  }

  List<LatLng> getCirclePoints() {
    if (points.length != 2) return [];

    final radius = calculateDistance();
    final center = points[0];
    List<LatLng> circlePoints = [];

    // Generate 32 points to create a circle
    for (int i = 0; i <= 32; i++) {
      final angle = (i * 2 * pi) / 32;
      final lat = center.latitude + (radius / 111.32) * cos(angle);
      final lng = center.longitude +
          (radius / (111.32 * cos(center.latitude * pi / 180))) * sin(angle);
      circlePoints.add(LatLng(lat, lng));
    }

    return circlePoints;
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': 'Circle'};

    var details = {
      'type': 'Circle',
      'center':
          '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };

    if (points.length > 1) {
      final radius = calculateDistance();
      details['radius'] = '${radius.toStringAsFixed(2)} km';
      details['area'] = '${(pi * radius * radius).toStringAsFixed(2)} km²';
    } else if (points.length == 1) {
      final currentRadius = const Distance().as(
        LengthUnit.Kilometer,
        points[0],
        points.last,
      );
      details['current_radius'] = '${currentRadius.toStringAsFixed(2)} km';
      details['current_area'] =
          '${(pi * currentRadius * currentRadius).toStringAsFixed(2)} km²';
    }

    return details;
  }
}
