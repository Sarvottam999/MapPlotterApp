import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class LocationSearchBar extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final bool showCurrentLocation;

  const LocationSearchBar({
    Key? key, 
    required this.onLocationSelected,
    this.showCurrentLocation = true,
  }) : super(key: key);

  @override
  _LocationSearchBarState createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;
  String? lat, lon; // For coordinate dialog

  // Search location using OpenStreetMap Nominatim API
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5',
        ),
        headers: {'Accept-Language': 'en-US,en;q=0.9'},
      );

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          searchResults = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      _showErrorSnackBar('Error searching location: $e');
    }
  }

  // Search by coordinates
  Future<void> searchLocationByCoordinates(String input) async {
    final RegExp coordPattern = RegExp(r'^(-?\d+\.?\d*),\s*(-?\d+\.?\d*)$');
    final match = coordPattern.firstMatch(input.trim());

    if (match != null) {
      try {
        final lat = double.parse(match.group(1)!);
        final lon = double.parse(match.group(2)!);

        if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
          setState(() => isLoading = true);

          // Get address using reverse geocoding
          final response = await http.get(Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json'
          ));

          if (response.statusCode == 200) {
            final locationData = json.decode(response.body);
            setState(() {
              searchController.text = locationData['display_name'];
              searchResults = [];
              isLoading = false;
            });

            widget.onLocationSelected(LatLng(lat, lon));
          } else {
            // If reverse geocoding fails, just use the coordinates
            setState(() {
              searchController.text = '$lat, $lon';
              searchResults = [];
              isLoading = false;
            }); LatLng(lat, lon);
            widget.onLocationSelected(LatLng(lat, lon));
          }
        } else {
          _showErrorSnackBar('Invalid coordinates range');
        }
      } catch (e) {
        _showErrorSnackBar('Invalid coordinates format');
      }
    } else {
      // If not coordinates, perform normal address search
      searchLocation(input);
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar(
          'Location permissions permanently denied. Please enable in settings.'
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}'
        '&lon=${position.longitude}&format=json'
      ));

      if (response.statusCode == 200) {
        final locationData = json.decode(response.body);
        setState(() {
          searchController.text = locationData['display_name'];
          searchResults = [];
        });

        widget.onLocationSelected(LatLng(position.latitude, position.longitude));
      }
    } catch (e) {
      _showErrorSnackBar('Error getting location: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            Geolocator.openLocationSettings();
          },
          textColor: Colors.white,
        ),
      ),
    );
    setState(() => isLoading = false);
  }

  void _showCoordinateInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Coordinates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Latitude (-90 to 90)',
                hintText: 'e.g., 28.6139',
                helperText: 'Enter latitude value between -90 and 90',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onChanged: (value) => lat = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Longitude (-180 to 180)',
                hintText: 'e.g., 77.2090',
                helperText: 'Enter longitude value between -180 and 180',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onChanged: (value) => lon = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              lat = null;
              lon = null;
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (lat != null && lon != null) {
                Navigator.pop(context);
                searchController.text = '$lat, $lon';
                searchLocationByCoordinates('$lat, $lon');
              } else {
                _showErrorSnackBar('Please enter both latitude and longitude');
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void selectLocation(dynamic location) {
    final lat = double.parse(location['lat']);
    final lon = double.parse(location['lon']);
    final newLocation = LatLng(lat, lon);

    setState(() {
      searchController.text = location['display_name'];
      searchResults = [];
    });

    widget.onLocationSelected(newLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
  constraints: const BoxConstraints(
    minWidth: 200,  // Minimum width
    maxWidth: 300,  // Maximum width
  ),
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search location or enter coordinates (lat, lon)...',
              // helperText: 'Enter address or coordinates like "28.6139, 77.2090"',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear',
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchResults = []);
                      },
                    ),
                  if (widget.showCurrentLocation)
                    IconButton(
                      icon: isLoading 
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2)
                          )
                        : const Icon(Icons.my_location),
                      tooltip: 'Current Location',
                      onPressed: isLoading ? null : getCurrentLocation,
                    ),
                  IconButton(
                    icon: const Icon(Icons.format_list_numbered),
                    tooltip: 'Enter Coordinates',
                    onPressed: _showCoordinateInputDialog,
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              if (value.length > 2) {
                searchLocationByCoordinates(value);
              } else {
                setState(() => searchResults = []);
              }
            },
          ),
        ),
        if (isLoading && searchResults.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    result['display_name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => selectLocation(result),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}