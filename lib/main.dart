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
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  LatLng _center;
  // LatLng _center = LatLng(32.602798, -85.488960);
  final Map<String, Marker> _markers = {};

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
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
      appBar: AppBar(title: Text('HackGT7 Sanitizer'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          },
        ),
      ]),
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

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  String restaurantName;
  String address;
  String latitude;
  String longitude;
  bool hasHandSanitizer;

  List<Widget> inputs = [
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Restaurant',
      ),
    ),
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Address',
      ),
    ),
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Latitude',
      ),
    ),
    TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Longitude',
      ),
    ),
    Radio()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HackGT7 Sanitizer')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: inputs,
      ),
    );
  }
}
