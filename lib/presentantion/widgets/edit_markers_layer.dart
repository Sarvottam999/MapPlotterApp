// // lib/presentation/widgets/edit_markers_layer.dart

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:myapp/presentantion/providers/drawing_provider.dart';
// import 'package:provider/provider.dart';
//  import '../../domain/entities/square_shape.dart';
// import 'package:myapp/core/point.dart';  // Add this import

// class EditMarkersLayer extends StatelessWidget {
//   const EditMarkersLayer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DrawingProvider>(
//       builder: (context, provider, _) {
//         if (!provider.isEditMode || provider.selectedShape == null) {
//           return const SizedBox.shrink();
//         }

//         final shape = provider.selectedShape!;
//         if (shape is! SquareShape) return const SizedBox.shrink();

//         // Get corner points
//         final points = shape.getSquarePoints();
        
//         return MarkerLayer(
//           markers: [
//             for (int i = 0; i < points.length - 1; i++) // -1 because last point equals first point
//               Marker(
//                 point: points[i],
//                 width: 20,
//                 height: 20,
//                 child: DragMarker(
//                   point: points[i],
//                   index: i,
//                   onDragEnd: (point) {
//                     provider.updatePointPosition(point);
//                   },
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// class DragMarker extends StatefulWidget {
//   final LatLng point;
//   final int index;
//   final Function(LatLng) onDragEnd;

//   const DragMarker({
//     Key? key,
//     required this.point,
//     required this.index,
//     required this.onDragEnd,
//   }) : super(key: key);

//   @override
//   State<DragMarker> createState() => _DragMarkerState();
// }

// class _DragMarkerState extends State<DragMarker> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         final mapController = MapController.of(context);
//         final point = mapController.camera.pointToLatLng(
//           Point<num>(
//             details.globalPosition.dx ,  // Convert to int
//             details.globalPosition.dy   // Convert to int
//           ),
//         );
//         if (point != null) {
//           widget.onDragEnd(point);
//         }
//       },
//       child: Container(
//         width: 20,
//         height: 20,
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.5),
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.white, width: 2),
//         ),
//       ),
//     );
//   }
// }
