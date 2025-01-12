import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Map Drawing'),
      //   actions: [],
      // ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onTap: (_, point) {
                final provider = context.read<DrawingProvider>();
                if (provider.currentShape != ShapeType.none) {
                  provider.addPoint(point);
                }
              },
              onPointerHover: (event, point) {
                final provider = context.read<DrawingProvider>();
                if (provider.currentShape != ShapeType.none) {
                  provider.updateCursor(point);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              Consumer<DrawingProvider>(
                builder: (context, provider, _) {
                  return PolylineLayer(
                    polylines: [
                      ...provider.shapes.map((shape) {
                        List<LatLng> points;
                        if (shape is SquareShape) {
                          points = shape.getSquarePoints();
                        } else if (shape is CircleShape) {
                          points = shape.getCirclePoints();
                        } else {
                          points = shape.points;
                        }
                        return Polyline(
                          points: points,
                          strokeWidth: 2.0,
                          color: Colors.blue,
                        );
                      }),
                      if (provider.currentPoints.isNotEmpty)
                        Polyline(
                          points: provider.currentPoints,
                          strokeWidth: 2.0,
                          color: Colors.red,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          // const Positioned(
          //   bottom: 16,
          //   left: 16,
          //   child: Column(
          //     children: [
          //       DrawingButton(
          //         icon: Icons.line_axis,
          //         label: 'Line',
          //         shapeType: ShapeType.line,
          //       ),
          //         SizedBox(height: 8),
          //       DrawingButton(
          //         icon: Icons.square_outlined,
          //         label: 'Square',
          //         shapeType: ShapeType.square,
          //       ),
          //     ],
          //   ),
          // ),
          // Consumer<DrawingProvider>(
          //   builder: (context, provider, _) {
          //     final details = provider.getCurrentShapeDetails();
          //     if (details == null) return const SizedBox();

          //     return Container(
          //       color: Colors.black,
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: details.entries
          //             .map(
          //               (e) => Text(
          //                 '${e.key}: ${e.value}',
          //                 style: const TextStyle(color: Colors.white),
          //               ),
          //             )
          //             .toList(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
