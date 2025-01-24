// lib/presentation/widgets/shape_editor.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';

class ShapeEditor extends StatefulWidget {
  const ShapeEditor({Key? key}) : super(key: key);

  @override
  State<ShapeEditor> createState() => _ShapeEditorState();
}

class _ShapeEditorState extends State<ShapeEditor> {
  late PolyEditor _polyEditor;
  List<LatLng> _editablePoints = [];

  @override
void initState() {
    super.initState();
    _polyEditor = PolyEditor(
      points: _editablePoints,
      pointIcon: const Icon(Icons.location_on, color: Colors.green),
      intermediateIcon: const Icon(Icons.lens, color: Colors.blue),
      intermediateIconSize: const Size(20, 20),
      pointIconSize: const Size(30, 30),
      // callbackRefresh: (point) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, provider, _) {
        print("------------------");
        print(provider.selectedShape);
        if (!provider.isEditing || provider.selectedShape == null) {
          return   Container();
        }

        // Update editable points when selected shape changes
        if (_editablePoints != provider.selectedShape!.points) {
          _editablePoints = List.from(provider.selectedShape!.points);
          _polyEditor = PolyEditor(

            points: _editablePoints,
            pointIcon: const Icon(Icons.my_location_outlined, color: Colors.green, size: 15,),
            intermediateIcon: const Icon(Icons.my_location_outlined, color: Colors.blue, size: 15),
            intermediateIconSize: const Size(20, 20),
            pointIconSize: const Size(20, 20),
            callbackRefresh: (latlon) {
              setState(() {}); // Ensure the UI is refreshed when changes occur.
              // If you need to update something specific, include logic here.
              provider.updateShapePoints(_editablePoints); // Example of updating points.
            },
            //   setState(() {});
            //   provider.updateShapePoints(_editablePoints);
            // },
          );
        }

        return Stack(
          children: [
            // Show the current shape being edited
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _editablePoints,
                  strokeWidth: 3.0,
                  color: Colors.green,
                ),
              ],
            ),
            // Add the drag markers
            // MarkerLayer(
            //   markers: _polyEditor.edit().map((dragMarker) => 
            //     Marker( 
            //       child: Icon(Icons.ac_unit),
            //       point: dragMarker.point,
            //       width: dragMarker.size.width,
            //       height: dragMarker.size.height,
            //       // builder: (ctx) => dragMarker.builder(ctx, dragMarker.point, dragMarker),
            //     ),
            //   ).toList(),
            // ),
            // Control buttons

            DragMarkers(markers: _polyEditor.edit(),),
            Positioned(
               left: 0,
                  top: 10,
                  right: 0,
              child: Center(
                child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
                  child: Row(
                    spacing: 2,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        splashColor: Colors.black,
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          provider.updateShapePoints(_editablePoints);
                          provider.cancelEdit();
                        }, 
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.close),
                                               onPressed: () => provider.cancelEdit(),

                      ),
                      // FloatingActionButton(
                      //   heroTag: 'cancel_edit',
                      //   onPressed: () => provider.cancelEdit(),
                      //   // onPressed: () => {},
                      //   backgroundColor: Colors.red,
                      //   child: const Icon(Icons.close),
                      // ),
                      const SizedBox(height: 8),
                            const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_outlined),
                        onPressed: () => provider.deleteSelectedShape(),

                      ),
                      // FloatingActionButton(
                      //   heroTag: 'delete_shape',
                      //   onPressed: () => provider.deleteSelectedShape(),
                      //   backgroundColor: Colors.red[700],
                      //   child: const Icon(Icons.delete),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}