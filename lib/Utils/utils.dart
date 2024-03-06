
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

showSnackBar(context, text) {
  var snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

push(context, screen) {
  Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
}

pushReplacement(context, screen) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (_) => screen));
}

pushUntil(context, screen) {
  Navigator.pushAndRemoveUntil(
      context, CupertinoPageRoute(builder: (_) => screen), (route) => false);
}

const kGoogleApiKey = 'AIzaSyCemo98vIgqSxuuU8M5rcEscpvjTWkGgJs';

fetchLocation() async {
  Location location = Location();
  // ignore: unused_local_variable
  LocationData _locationData;

  if (await Permission.location.request().isGranted) {
    return await location.getLocation();
  } else {
    await Permission.location.request();
  }
}
