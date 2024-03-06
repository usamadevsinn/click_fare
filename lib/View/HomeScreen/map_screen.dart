import 'package:click_fare/Utils/resources/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_plugin;
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  location_plugin.Location location = location_plugin.Location();
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLocation();
  }

  Future<void> _requestPermissionAndLocation() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location services are still disabled, show button to enable
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == location_plugin.PermissionStatus.denied) {
      // Location permission is denied, show button to request permission
      _showPermissionDialog();
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      var currentLocation = await location.getLocation();
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentLocation.latitude ?? 0.0,
                currentLocation.longitude ?? 0.0,
              ),
              zoom: 15.0,
            ),
          ),
        );

        // Add a marker for the current location
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              currentLocation.latitude ?? 0.0,
              currentLocation.longitude ?? 0.0,
            ),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        setState(() {}); // Update the widget to show the marker
      } else {
        print('Location data is not available.');
      }
    } catch (e) {
      // Handle location access error
      print('Error getting location: $e');
    }
  }

 void _searchLocation(String query, String markerId) async {
  try {
    var locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      var location = locations.first;
      mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
      );

      // Add a marker for the searched location
      markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: query),
        ),
      );

      setState(() {});

      // Draw polyline if both pickup and destination are set
      if (pickupController.text.isNotEmpty && destinationController.text.isNotEmpty) {
        _searchLocation(pickupController.text, 'pickup');
        _searchLocation(destinationController.text, 'destination');
        _drawPolyline(
          LatLng(markers.elementAt(0).position.latitude, markers.elementAt(0).position.longitude),
          LatLng(markers.elementAt(1).position.latitude, markers.elementAt(1).position.longitude),
        );
      }
    } else {
      print('Location not found.');
    }
  } catch (e) {
    print('Error searching location: $e');
  }
}
  Future<void> _showPermissionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Permission"),
          content: const Text("Please enable location services to use this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await location.requestPermission();
                Navigator.of(context).pop();
                _requestPermissionAndLocation();
              },
              child: const Text("Enable"),
            ),
          ],
        );
      },
    );
  }

 void _drawPolyline(LatLng pickupLatLng, LatLng destinationLatLng) {
  // Clear existing polylines
  polylines.clear();

  // Define polyline properties
  PolylineId id = const PolylineId('poly');
  List<LatLng> points = [pickupLatLng, destinationLatLng];
  Color color = Colors.blue;
  int width = 5;

  // Create the polyline
  Polyline polyline = Polyline(
    polylineId: id,
    color: color,
    points: points,
    width: width,
  );

  // Add the polyline to the set of polylines
  polylines.add(polyline);
}
@override
void dispose() {
  mapController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            _getCurrentLocation();
          },
          backgroundColor: AppTheme.appColor,
          child:  Icon(Icons.location_searching, color: AppTheme.whiteColor,),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
            polylines: polylines,
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.appColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          if (pickupController.text == "" || pickupController.text.isEmpty) {
                            showSnackBar(context, "Please enter pickup location.");
                          } else {
                            _searchLocation(pickupController.text, 'pickup');
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        controller: pickupController,
                        cursorColor: AppTheme.whiteColor,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Pickup",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (pickupController.text.isNotEmpty) {
                          _searchLocation(pickupController.text, 'pickup');
                          FocusScope.of(context).requestFocus(FocusNode());
                        } else {
                          showSnackBar(context, "Please enter pickup location.");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.appColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          if (destinationController.text == "" || destinationController.text.isEmpty) {
                            showSnackBar(context, "Please enter destination location.");
                          } else {
                            _searchLocation(destinationController.text, 'destination');
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        controller: destinationController,
                        cursorColor: AppTheme.whiteColor,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Destination",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (destinationController.text.isNotEmpty) {
                          _searchLocation(destinationController.text, 'destination');
                          FocusScope.of(context).requestFocus(FocusNode());
                        } else {
                          showSnackBar(context, "Please enter destination location.");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
