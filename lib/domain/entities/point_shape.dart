import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/shape.dart';

class PointShape extends Shape {
  final double markerSize;
  final Color markerColor;
  final IconData markerIcon;

  PointShape({
    required List<LatLng> points,
    this.markerSize = 30.0,
    this.markerColor = Colors.red,
    this.markerIcon = Icons.location_on,
  }) : super(points: points, type: ShapeType.line);

  @override
  double calculateDistance() {
    // For a point, distance is not applicable
    return 0.0;
  }

  @override
  List<Polyline> getPolylines() {
    // Points don't have polylines
    return [];
  }

  // New method to get markers for the point
  List<Marker> getMarkers() {
    return points.map((point) => Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child:  Icon(
        markerIcon,
        color: markerColor,
        size: markerSize,
      ),
    )).toList();
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': 'Point'};

    var details = {
      'type': 'Point',
      'coordinates': points.map((point) => 
        '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}'
      ).toList(),
    };

    if (points.isNotEmpty) {
      // Add closest known location name if available
      // You could integrate with your LocationDatabase here
      details['location'] = '${points.first.latitude.toStringAsFixed(6)}, '
                           '${points.first.longitude.toStringAsFixed(6)}';
    }

    return details;
  }

  // Helper method to get the closest point to a given location
  LatLng? getClosestPoint(LatLng location) {
    if (points.isEmpty) return null;

    LatLng closestPoint = points.first;
    double minDistance = const Distance().as(
      LengthUnit.Meter,
      location,
      closestPoint,
    );

    for (var point in points) {
      double distance = const Distance().as(
        LengthUnit.Meter,
        location,
        point,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }

    return closestPoint;
  }

  // Method to check if a point is within a certain radius
  bool isPointWithinRadius(LatLng location, double radiusInMeters) {
    if (points.isEmpty) return false;

    for (var point in points) {
      double distance = const Distance().as(
        LengthUnit.Meter,
        location,
        point,
      );

      if (distance <= radiusInMeters) {
        return true;
      }
    }

    return false;
  }

  // Method to add a new point
  void addPoint(LatLng point) {
    points.add(point);
  }

  // Method to remove a point
  void removePoint(LatLng point) {
    points.removeWhere((p) => 
      p.latitude == point.latitude && 
      p.longitude == point.longitude
    );
  }

  // Method to update point style
  // void updateStyle({
  //   double? size,
  //   Color? color,
  //   IconData? icon,
  // }) {
  //   if (size != null) this.markerSize = size;
  //   if (color != null) this.markerColor = color;
  //   if (icon != null) this.markerIcon = icon;
  // }
}