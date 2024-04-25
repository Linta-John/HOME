import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationPickerScreen(),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng location) {
          setState(() {
            selectedLocation = location;
          });
          mapController.animateCamera(CameraUpdate.newLatLng(location));
        },
        markers: Set.from([
          if (selectedLocation != null)
            Marker(
              markerId: MarkerId('selected-location'),
              position: selectedLocation!,
            ),
        ]),
        initialCameraPosition: CameraPosition(
          target: LatLng(40.7128, -74.0060), // New York City coordinates
          zoom: 10,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            // Upload the selectedLocation to your database or use it as needed
            print('Selected Location: $selectedLocation');
            Navigator.pop(context,
                selectedLocation); // Return the selected location to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a location'),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
