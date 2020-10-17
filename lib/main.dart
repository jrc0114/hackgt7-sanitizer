import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'src/locations.dart' as locations;

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
  // final Firestore _database = Firestore.instance;
  final LatLng _center = const LatLng(32.602798, -85.488960);
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // final googleOffices = await locations.getGoogleOffices();

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
      // for (final office in googleOffices.offices) {
      //   final marker = Marker(
      //     markerId: MarkerId(office.name),
      //     position: LatLng(office.lat, office.lng),
      //     infoWindow: InfoWindow(
      //       title: office.name,
      //       snippet: office.address,
      //     ),
      //   );
      //   _markers[office.name] = marker;
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HackGT7 Sanitizer')),
      // body: _buildBody(context),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          // target: const LatLng(0, 0),
          // zoom: 2,
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }

  // Widget _buildBody(BuildContext context) {
  //   // TODO: get actual snapshot from Cloud Firestore
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: Firestore.instance.collection('baby').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) return LinearProgressIndicator();

  //       return _buildList(context, snapshot.data.documents);
  //     },
  //   );
  // }

  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ListView(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  //   );
  // }

  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final record = Record.fromSnapshot(data);

  //   return Padding(
  //     key: ValueKey(record.name),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: ListTile(
  //         title: Text(record.name),
  //         trailing: Text(record.votes.toString()),
  //         onTap: () =>
  //             record.reference.updateData({'votes': FieldValue.increment(1)}),
  //       ),
  //     ),
  //   );
  // }
}

// class Record {
//   final String name;
//   final int votes;
//   final DocumentReference reference;

//   Record.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['name'] != null),
//         assert(map['votes'] != null),
//         name = map['name'],
//         votes = map['votes'];

//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);

//   @override
//   String toString() => "Record<$name:$votes>";
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // GoogleMapController mapController;

//   // final LatLng _center = const LatLng(32.602798, -85.488960);

//   // void _onMapCreated(GoogleMapController controller) {
//   //   mapController = controller;
//   // }

//   final Map<String, Marker> _markers = {};
//   Future<void> _onMapCreated(GoogleMapController controller) async {
//     final googleOffices = await locations.getGoogleOffices();
//     setState(() {
//       _markers.clear();
//       for (final office in googleOffices.offices) {
//         final marker = Marker(
//           markerId: MarkerId(office.name),
//           position: LatLng(office.lat, office.lng),
//           infoWindow: InfoWindow(
//             title: office.name,
//             snippet: office.address,
//           ),
//         );
//         _markers[office.name] = marker;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('HackGT7 Sanitizer'),
//           backgroundColor: Colors.green[700],
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: const LatLng(0, 0),
//             zoom: 2,
//             // target: _center,
//             // zoom: 11.0,
//           ),
//           markers: _markers.values.toSet(),
//         ),
//       ),
//     );
//   }
// }
