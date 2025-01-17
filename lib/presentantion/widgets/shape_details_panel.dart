// lib/presentation/widgets/shape_details_panel.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/drawing_provider.dart';
import '../../domain/entities/shape.dart';
import 'dart:math';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/core/enum/shape_type.dart';

class ShapeDetailsPanel extends StatelessWidget {
  final MapController mapController;

  const ShapeDetailsPanel({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  void _focusOnShape(Shape shape) {
    if (shape.points.isEmpty) return;

    // Calculate bounds of the shape
    double minLat = shape.points[0].latitude;
    double maxLat = shape.points[0].latitude;
    double minLng = shape.points[0].longitude;
    double maxLng = shape.points[0].longitude;

    for (var point in shape.points) {
      minLat = min(minLat, point.latitude);
      maxLat = max(maxLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLng = max(maxLng, point.longitude);
    }

    // Add some padding
    double latPadding = (maxLat - minLat) * 0.2;
    double lngPadding = (maxLng - minLng) * 0.2;

    // Create bounds with padding
    LatLngBounds bounds = LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    // Animate map to fit bounds
     mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50.0),
        maxZoom: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: Consumer<DrawingProvider>(
          builder: (context, provider, _) {
            if (provider.shapes.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No shapes drawn yet'),
                ),
              );
            }
      
            return ListView.builder(
              itemCount: provider.shapes.length,
              itemBuilder: (context, index) {
                final shape = provider.shapes[index];
                final details = shape.getDetails();
      
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _focusOnShape(shape),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Shape ${index + 1}: ${details['type']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                _getShapeIcon(shape),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          const Divider(),
                          ...details.entries
                              .where((e) => e.key != 'type')
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Text('${_formatKey(e.key)}: ${e.value}'),
                                  )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData _getShapeIcon(Shape shape) {
    switch (shape.type) {
      case ShapeType.line:
        return Icons.show_chart;
      case ShapeType.square:
        return Icons.square_outlined;
      case ShapeType.circle:
        return Icons.circle_outlined;
      case ShapeType.fishbone:
        return Icons.linear_scale;
      default:
        return Icons.shape_line;
    }
  }

  String _formatKey(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}