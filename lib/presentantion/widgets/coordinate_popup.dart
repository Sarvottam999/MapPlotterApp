import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CoordinatePopup extends StatefulWidget {
  final LatLng coordinate;
  final VoidCallback onCancel;
  final String? address; // Optional address if you want to show it

  const CoordinatePopup({
    Key? key,
    required this.coordinate,
    required this.onCancel,
    this.address,
  }) : super(key: key);

  @override
  State<CoordinatePopup> createState() => _CoordinatePopupState();
}

class _CoordinatePopupState extends State<CoordinatePopup> {
  @override
  Widget build(BuildContext context) {
   return Card(
  color: Colors.white,
  elevation: 1,
  child: Row(
    children: [
      Image.asset(
        'assets/location_popup.png',
        height: 100,
        width: 100,
      ),
      Expanded(  // Add this
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Variyadi Bajar',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                'Panjgur, Balochistan, Pakistan',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(
                color: Color.fromARGB(224, 227, 227, 227),
                endIndent: 20,
                // thickness: 1,  // Add thickness for visibility
                height: 20,    // Add height for spacing
              ),
              Text('${widget.coordinate.latitude}, ${widget.coordinate.longitude}', style: TextStyle(
                color: const Color.fromARGB(255, 20, 56, 255)
              ),)
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
}


// CoordinatePopup(
//             address: '',
//             coordinate: LatLng(20.0121, 21.12251),
//             onCancel: () {},
//           ),