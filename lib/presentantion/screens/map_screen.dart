import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
  final MapController _mapController = MapController();
  bool _isMapReady = false;
  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();
    // _mapController = MapController();
  }


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Map Drawing'),
      //   actions: [],
      // ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (_, point) {
                final provider = context.read<DrawingProvider>();
                if (provider.currentShape != ShapeType.none) {
                  provider.addPoint(point);
                }
              },
              onPointerHover: (event, point) {
                print("event==========>${event}");

                final provider = context.read<DrawingProvider>();
                if (provider.currentShape != ShapeType.none) {
                  provider.updateCursor(point);
                }

                print("point==========>${point}");
              },
               onMapReady: () {
                print("=============     called   =========");
                      setState(() {
                        _isMapReady = true;
                      });
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
                      ...provider.shapes
                          .expand((shape) => shape.getPolylines()),
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
           if (   _isPanelVisible) // Add condition here
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: ShapeDetailsPanel(mapController: _mapController),
            ),
            ],
          ),

          Positioned(
            top: 0,
            right: 0,
            
            child:  IconButton(
              icon: Icon(_isPanelVisible ? Icons.chevron_right : Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _isPanelVisible = !_isPanelVisible;
                });
              },
              tooltip: _isPanelVisible ? 'Hide Panel' : 'Show Panel',
            ),)
         
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

