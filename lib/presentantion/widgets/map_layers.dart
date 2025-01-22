import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

   List<MapLayer> maplayersData = [
     MapLayer(
      id: 'map',
      icon: Icons.terrain,
      label: 'Map',
      image: 'assets/images/layer_icons/terrain.jpg',
url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c']



    ),
//  MapLayer(
//       id: 'terrain',
//       icon: Icons.terrain,
//       label: 'Terrain',
//       image: 'assets/images/layer_icons/terrain.jpg',
// url: 'http://mt0.google.com/vt/lyrs=p&hl=en&x={x}&y={y}&z={z}',
//       subdomains: ['a', 'b', 'c']



//     ),
    MapLayer(
      id: 'satellite',
      icon: Icons.satellite_alt,
      label: 'Satellite',
      image: 'assets/images/layer_icons/satelight.jpg',
      url : 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      subdomains: ['mt0','mt1','mt2','mt3']
    ),
   
//     MapLayer(
//       id: 'traffic',
//       icon: Icons.traffic,
//       label: 'Traffic',
//       image: 'assets/images/layer_icons/traffic.jpg',
// url: 'http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
//       subdomains: ['mt0','mt1','mt2','mt3']

//     ),
   
   
  ];
class LayerSelector extends StatefulWidget {
  final Function(MapLayer) onLayerChanged;

  
  const LayerSelector({
    Key? key,
    required this.onLayerChanged,
  }) : super(key: key);

  @override
  State<LayerSelector> createState() => _LayerSelectorState();
}

class _LayerSelectorState extends State<LayerSelector> {
    bool showAllLayers = false;  // Add this flag to control visibility
    List _maplayersData = maplayersData;
  MapLayer selectedLayer = maplayersData[0];

    @override
  void initState() {
    // widget.onLayerChanged(selectedLayer);
    // TODO: implement initState
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          // width: 50,
          child: Row(
            children: [
              if (showAllLayers) 
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                    children: _maplayersData
                        .where((layer) => layer.id != selectedLayer.id) // Exclude selected layer
                        .map((layer) => _buildLayerButton(layer))
                        .toList(),
                  ),
              ),
              _buildMainLayerButton(),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainLayerButton() {
    MapLayer currentLayer = _maplayersData.firstWhere((layer) => layer.id == selectedLayer.id);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            showAllLayers = !showAllLayers;
          });
    
         },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Container(
                padding: EdgeInsets.all(2),
              
        decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all( color:   Colors.black, width: 3),
      boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
          ),
      ],
        ),
        child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.asset(
          currentLayer.image,
          height: 60, 
          width: 60,
          fit: BoxFit.cover,
      ),
        ),
    ),
              // Icon(currentLayer.icon, size: 24),
              const SizedBox(height: 4),
              Text(
                currentLayer.label,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayerButton(MapLayer layer) {
    bool isSelected = selectedLayer.id == layer.id;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedLayer = layer;
          });
          widget.onLayerChanged(layer);
        },
        child: Container(
          
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade200 : Colors.transparent,
           
          ),
          child: Column(
            children: [
              
              Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
            // BoxShadow(
            //     color: Colors.black,
            //     blurRadius: 8,
            //     offset: const Offset(0, 2),
            // ),
        ],
    ),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.asset(
            layer.image,
            height: 60, 
            width: 60,
            fit: BoxFit.cover,
        ),
    ),
),
              // Icon(
              //   layer.icon,
              //   size: 24,
              //   color: isSelected ? Colors.blue : Colors.grey,
              // ),
              const SizedBox(height: 4),
              Text(
                layer.label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapLayer {
  final String id;
  final IconData icon;
  final String label;
  final String image;
  final String url;
  final List<String> subdomains;


  MapLayer({
    required this.id,
    required this.icon,
    required this.label,
    required this.image,
    required this.url,
    required this.subdomains,
  });
}

// Usage example:
// class MapScreen extends StatelessWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             options: MapOptions(
//               center: const LatLng(51.5, -0.09),
//               zoom: 13.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               ),
//               LayerSelector(
//                 onLayerChanged: (layerId) {
//                   // Handle layer change here
//                   print('Selected layer: $layerId');
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }