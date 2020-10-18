import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackGT7 Sanitizer',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  LatLng _center;
  // LatLng _center = LatLng(32.602798, -85.488960);
  final Map<String, Marker> _markers = {};

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      Firestore.instance.collection('restaurant').getDocuments().then((docs) {
        docs.documents.forEach((doc) {
          print(doc.documentID);
          final marker = Marker(
              markerId: MarkerId(doc['name']),
              position: LatLng(doc['lat'], doc['lng']),
              infoWindow: InfoWindow(
                title: doc['name'],
                snippet: doc['address'],
              ));
          setState(() {
            _markers[doc.documentID] = marker;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HackGT7 Sanitizer')),
      // body: _buildBody(context),
      body: _center == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                // target: const LatLng(0, 0),
                // zoom: 2,
                target: _center,
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              markers: _markers.values.toSet(),
            ),
    );
  }
}
