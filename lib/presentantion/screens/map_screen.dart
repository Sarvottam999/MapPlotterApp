import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/core/enum/fishbone_type.dart';
import 'package:myapp/core/enum/shape_type.dart';
import 'package:myapp/domain/entities/circle_shape.dart';
import 'package:myapp/domain/entities/fishbone_shape.dart';
import 'package:myapp/domain/entities/shape.dart';
import 'package:myapp/domain/entities/square_shape.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/presentantion/widgets/ShowMyLocationButton.dart';
import 'package:myapp/presentantion/widgets/coordinate_popup.dart';
import 'package:myapp/presentantion/widgets/drawing_button.dart';
import 'package:myapp/presentantion/widgets/map_layers.dart';
import 'package:myapp/presentantion/widgets/search_location.dart';
import 'package:myapp/presentantion/widgets/shape_details_panel.dart';
import 'package:myapp/presentantion/widgets/shape_editor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  bool _isMapReady = false;
  bool _isPanelVisible = false;
  MapLayer currentMapLayer = maplayersData[0] ;

  void _handleShapeSelection(DrawingProvider provider, LatLng clickPoint) {
    Shape? selectedShape;
    double minDistance = 100; // threshold in meters

    // Check each shape
    for (var shape in provider.shapes) {
      // Get all polylines for this shape
      List<Polyline> polylines = shape.getPolylines();

      // Check each polyline in the shape
      for (var polyline in polylines) {
        // Check each segment in the polyline
        for (int i = 0; i < polyline.points.length - 1; i++) {
          LatLng start = polyline.points[i];
          LatLng end = polyline.points[i + 1];

          // Calculate distance from click to line segment
          double distance = _distanceToLineSegment(clickPoint, start, end);

          if (distance < minDistance) {
            minDistance = distance;
            selectedShape = shape;
          }
        }
      }
    }

    // If we found a shape close enough to the click
    if (selectedShape != null) {
      // Toggle selection if clicking the same shape
      provider.selectShape(
          selectedShape == provider.selectedShape ? null : selectedShape);
    } else {
      // Deselect if clicked away from shapes
      provider.selectShape(null);
    }
  }

// Helper method to calculate distance from point to line segment
  double _distanceToLineSegment(LatLng p, LatLng start, LatLng end) {
    const Distance distance = Distance();

    // Convert to meters
    double l2 = distance.as(LengthUnit.Meter, start, end);
    l2 = l2 * l2; // squared length of the line segment

    if (l2 == 0) {
      // Line segment is actually a point
      return distance.as(LengthUnit.Meter, p, start);
    }

    // Consider the line extending the segment, parameterized as start + t (end - start)
    // We find projection of point p onto the line
    double t = ((p.longitude - start.longitude) *
                (end.longitude - start.longitude) +
            (p.latitude - start.latitude) * (end.latitude - start.latitude)) /
        l2;

    if (t < 0) {
      // Beyond the start of the segment
      return distance.as(LengthUnit.Meter, p, start);
    }
    if (t > 1) {
      // Beyond the end of the segment
      return distance.as(LengthUnit.Meter, p, end);
    }

    // Projection falls on the segment
    LatLng projection = LatLng(
        start.latitude + t * (end.latitude - start.latitude),
        start.longitude + t * (end.longitude - start.longitude));

    return distance.as(LengthUnit.Meter, p, projection);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    @override
    void initState() {
      super.initState();
      // _mapController = MapController();
    }

    return Scaffold( 
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              onTap: (_, point) {
                final provider = context.read<DrawingProvider>();
                if (provider.isSelectionMode) {
                  _handleShapeSelection(provider, point);
                } else if (provider.currentShape != ShapeType.none) {
                  provider.addPoint(point);
                } else {
                  print("clicked...");
                  Positioned(
                    bottom: 1,
                    right: 0,
                    left: 0,
                    child: Text("####################3"),

                  
                  );

                }
              },
              // onTap: (_, point) {
              //   final provider = context.read<DrawingProvider>();
              //   if (provider.currentShape != ShapeType.none) {
              //     provider.addPoint(point);
              //   }
              // },
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
                urlTemplate:currentMapLayer.url,
                    // 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: currentMapLayer.subdomains,
              ),
              Consumer<DrawingProvider>(
                builder: (context, provider, _) {
                  return PolylineLayer(
                    polylines: [
                      ...provider.shapes.expand((shape) {
                        var polylines = shape.getPolylines();
                        // Highlight selected shape
                        if (shape == provider.selectedShape) {
                          polylines = polylines
                              .map((polyline) => Polyline(
                                    points: polyline.points,
                                    strokeWidth: polyline.strokeWidth + 2,
                                    color: Colors.yellow,
                                  ))
                              .toList();
                        }
                        return polylines;
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
             
             Align(
                alignment: Alignment.center,
                child: const ShapeEditor(),
              ),
          
            
            ],
          ),

           

           if (_isPanelVisible && _isMapReady) // Add condition here
                Positioned(
                  right: 10,
                  top: screenSize.height * 0.1,

                  bottom: screenSize.height * 0.2,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: ShapeDetailsPanel(
                      mapController: _mapController,
                      onPressed: () {
                        setState(() {
                          _isPanelVisible = !_isPanelVisible;
                        });
                      },
                    ),
                  ),
                ),

      //      Positioned(
      // left: 20,
      // bottom: 130,
      //       child: LocationButton(
      //             mapController: _mapController,
      //             zoom: 15.0,
      //           ),
      //     ),
            

          if (_isMapReady && !_isPanelVisible)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),

                  color: Colors.white, // Set the grey color
                ),
                child: IconButton(
                  icon: 
                  
                    SvgPicture.asset('assets/menu.svg'),

                  onPressed: () {
                    setState(() {
                      _isPanelVisible = !_isPanelVisible;
                    });
                  },
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              right: 10,

              
              child: LayerSelector(
              onLayerChanged: (value){
                setState(() {
                  currentMapLayer = value;
                  
                });


              }
            )),

            Positioned(
      top: MediaQuery.of(context).padding.top, // Account for status bar
      left: 0,
      right: 0,
      child: LocationSearchBar(
        onLocationSelected: (LatLng location) {
          // Handle location selection
          // e.g., move map, add marker, etc.
          _mapController.move(location, 15);
          setState(() {
            // markers = [
            //   Marker(
            //     point: location,
            //     builder: (ctx) => Icon(Icons.location_pin),
            //   ),
            // ];
          });
        },
        showCurrentLocation: true, // Optional, defaults to true
      ),
    ),

            // CoordinatePopup(
            //   address: '',
            //                         coordinate: LatLng(20.0121, 21.12251),
            //                         onCancel: () {
            //                  },
            //         ),

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


