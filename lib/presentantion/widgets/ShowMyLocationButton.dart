// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationButton extends StatefulWidget {
//   final MapController mapController;
//   final double zoom;

//   const LocationButton({
//     Key? key,
//     required this.mapController,
//     this.zoom = 15.0,
//   }) : super(key: key);

//   @override
//   State<LocationButton> createState() => _LocationButtonState();
// }

// class _LocationButtonState extends State<LocationButton> {
//   bool _isLoading = false;

//   Future<Position?> _getCurrentLocation() async {
//     setState(() => _isLoading = true);
    
//     try {
//       // Check if location service is enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location services are disabled')),
//         );
//         return null;
//       }

//       // Check location permission
//       PermissionStatus permission = await Permission.location.status;
//       if (permission == PermissionStatus.denied) {
//         permission = await Permission.location.request();
//         if (permission == PermissionStatus.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permission denied')),
//           );
//           return null;
//         }
//       }

//       if (permission == PermissionStatus.permanentlyDenied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Location permission permanently denied, please enable it in settings'),
//             action: SnackBarAction(
//               label: 'Settings',
//               onPressed: () => openAppSettings(),
//             ),
//           ),
//         );
//         return null;
//       }

//       // Get current position
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//       return null;
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _moveToCurrentLocation() async {
//     Position? position = await _getCurrentLocation();
//     if (position != null) {
//       widget.mapController.move(
//         LatLng(position.latitude, position.longitude),
//         widget.zoom,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: _isLoading ? null : _moveToCurrentLocation,
//           borderRadius: BorderRadius.circular(8),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _isLoading
//                 ? const SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: CircularProgressIndicator(
//                       color: Colors.black,
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : const Icon(
//                     Icons.my_location,
//                     size: 24,
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Usage example:
// class MapScreen extends StatefulWidget {
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final MapController _mapController = MapController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               center: const LatLng(51.5, -0.09),
//               zoom: 13.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               ),
//               // Add location button
//               LocationButton(
//                 mapController: _mapController,
//                 zoom: 15.0,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }