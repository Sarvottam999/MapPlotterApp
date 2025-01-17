// lib/domain/entities/fishbone_shape.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import './shape.dart';

class FishboneConfiguration {
  final double verticalLineLength;
  final double lineSpacing;
  final double endOffset;
  final Color mainLineColor;
  final Color verticalLineColor;
  final double mainLineWidth;
  final double verticalLineWidth;

  const FishboneConfiguration({
    required this.verticalLineLength,
    required this.lineSpacing,
    required this.endOffset,
    this.mainLineColor = Colors.blue,
    this.verticalLineColor = Colors.red,
    this.mainLineWidth = 4.0,
    this.verticalLineWidth = 3.0,
  });

  static FishboneConfiguration getConfig(FishboneType type) {
    switch (type) {
      case FishboneType.antiPersonal:
        return FishboneConfiguration(
          verticalLineLength: 4.0,  // 2m + 2m
          lineSpacing: 1.0,         // 1m between lines
          endOffset: 3.0,           // 3m from ends
          mainLineColor: Colors.red,
          verticalLineColor: Colors.red,
        );
      case FishboneType.antiTank:
        return FishboneConfiguration(
          verticalLineLength: 8.0,  // 4m + 4m
          lineSpacing: 3.0,         // 3m between lines
          endOffset: 6.0,           // 6m from ends
          mainLineColor: Colors.blue,
          verticalLineColor: Colors.blue,
        );
      case FishboneType.fragmentation:
        return FishboneConfiguration(
          verticalLineLength: 12.0, // 6m + 6m
          lineSpacing: 12.0,        // 12m between lines
          endOffset: 9.0,           // 9m from ends
          mainLineColor: Colors.green,
          verticalLineColor: Colors.green,
        );
      case FishboneType.normal:
      default:
        return FishboneConfiguration(
          verticalLineLength: 10.0,
          lineSpacing: 3.0,
          endOffset: 10.0,
          mainLineColor: Colors.blue,
          verticalLineColor: Colors.red,
        );
    }
  }
}

class FishboneShape extends Shape {
  final FishboneType fishboneType;
  late final FishboneConfiguration config;

  FishboneShape({
    required List<LatLng> points,
    this.fishboneType = FishboneType.normal,
  }) : super(points: points, type: ShapeType.fishbone) {
    config = FishboneConfiguration.getConfig(fishboneType);
  }

  // Utility function to convert meters to degrees longitude
  static double metersToDegreesLongitude(double meters, double latitude) {
    const double earthRadius = 6371000;
    return (meters / (earthRadius * cos(latitude * pi / 180))) * (180 / pi);
  }

  // Utility function to convert meters to degrees latitude
  static double metersToDegreesLatitude(double meters) {
    const double earthRadius = 6371000;
    return (meters / earthRadius) * (180 / pi);
  }

  @override
  double calculateDistance() {
    if (points.length != 2) return 0;
    
    const double earthRadius = 6371000; // Earth's radius in meters
    
    double lat1 = points[0].latitude * pi / 180;
    double lat2 = points[1].latitude * pi / 180;
    double dLat = (points[1].latitude - points[0].latitude) * pi / 180;
    double dLon = (points[1].longitude - points[0].longitude) * pi / 180;

    double a = sin(dLat/2) * sin(dLat/2) +
        cos(lat1) * cos(lat2) *
        sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return earthRadius * c;
  }

  @override
  List<Polyline> getPolylines() {
    if (points.length != 2) return [];

    List<Polyline> polylines = [];
    final startPoint = points[0];
    final endPoint = points[1];

    // Add main horizontal line
    polylines.add(Polyline(
      points: [startPoint, endPoint],
      strokeWidth: config.mainLineWidth,
      color: config.mainLineColor,
    ));

    // Calculate bearing between points
    double startLat = startPoint.latitude * pi / 180;
    double startLon = startPoint.longitude * pi / 180;
    double endLat = endPoint.latitude * pi / 180;
    double endLon = endPoint.longitude * pi / 180;
    
    double bearing = atan2(
      sin(endLon - startLon) * cos(endLat),
      cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(endLon - startLon)
    );

    // Total distance
    double totalDistance = calculateDistance();
    
    // Calculate number of vertical lines
    int numberOfLines = ((totalDistance - (2 * config.endOffset)) / config.lineSpacing).floor();
    
    // Generate vertical lines
    for (int i = 0; i < numberOfLines; i++) {
      // Calculate distance from start point for this vertical line
      double distanceFromStart = config.endOffset + (i * config.lineSpacing);
      
      // Calculate fraction of total distance
      double fraction = distanceFromStart / totalDistance;
      
      // Interpolate position
      double lat = startPoint.latitude + (endPoint.latitude - startPoint.latitude) * fraction;
      double lon = startPoint.longitude + (endPoint.longitude - startPoint.longitude) * fraction;
      
      // Calculate vertical line endpoints
      double verticalLatDelta = metersToDegreesLatitude(config.verticalLineLength / 2);
      double verticalLonDelta = metersToDegreesLongitude(config.verticalLineLength / 2, lat);
      
      // Create vertical line perpendicular to main line
      double perpBearing = bearing + (pi / 2);
      LatLng verticalStart = LatLng(
        lat + verticalLatDelta * cos(perpBearing),
        lon + verticalLonDelta * sin(perpBearing)
      );
      LatLng verticalEnd = LatLng(
        lat - verticalLatDelta * cos(perpBearing),
        lon - verticalLonDelta * sin(perpBearing)
      );

      // Add vertical line
      polylines.add(Polyline(
        points: [verticalStart, verticalEnd],
        strokeWidth: config.verticalLineWidth,
        color: config.verticalLineColor,
      ));
    }

    return polylines;
  }

  @override
  Map<String, dynamic> getDetails() {
    if (points.isEmpty) return {'type': 'Fishbone (${fishboneType.name})'};
    
    var details = {
      'type': 'Fishbone (${fishboneType.name})',
      'start': '${points[0].latitude.toStringAsFixed(6)}, ${points[0].longitude.toStringAsFixed(6)}',
    };

    if (points.length > 1) {
      details['end'] = '${points[1].latitude.toStringAsFixed(6)}, ${points[1].longitude.toStringAsFixed(6)}';
      details['distance'] = '${(calculateDistance() / 1000).toStringAsFixed(2)} km';
      
      // Calculate number of markers
      double totalDistance = calculateDistance();
      int numberOfLines = ((totalDistance - (2 * config.endOffset)) / config.lineSpacing).floor();
      details['markers'] = '$numberOfLines markers';
    }

    return details;
  }
}