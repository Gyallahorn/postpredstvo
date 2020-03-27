// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class SliderContent extends StatelessWidget {
//   BorderRadiusGeometry radius = BorderRadius.only(
//       topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));
//   List<BoxShadow> boxShad = const <BoxShadow>[
//     BoxShadow(color: Colors.black, blurRadius: 8.0)
//   ];
// final GoogleMapController myMapController;
//   SliderContent({this.myMapController});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SlidingUpPanel(
//       borderRadius: radius,
//       boxShadow: boxShad,
//       minHeight: 20,
//       maxHeight: 350,
//       panel: Material(
//           child: Column(
//         children: <Widget>[
//           Container(
//             width: 50,
//             child: Divider(
//               thickness: 5,
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(
//             height: 17,
//           ),
//           Container(
//             height: 44,
//             width: 350,
//             color: Colors.indigo,
//           ),
//           SizedBox(
//             height: 17,
//           ),
//           Container(
//             height: 44,
//             width: 350,
//             color: Colors.lime,
//           ),
//           SizedBox(
//             height: 17,
//           ),
//           Container(
//             height: 30,
//             child: Text(
//               'Пешком ${distance}',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//             ),
//           )
//         ],
//       )),
//       body: Scaffold(
//         floatingActionButton: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 200,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             SliderContent(controller: myMapController)));
//               },
//               child: CircleAvatar(
//                 child: Icon(Icons.menu),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () =>
//                   {myMapController.animateCamera(CameraUpdate.zoomIn())},
//               child: CircleAvatar(
//                 child: Icon(Icons.add),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             GestureDetector(
//               onTap: () =>
//                   {myMapController.animateCamera(CameraUpdate.zoomOut())},
//               child: CircleAvatar(
//                 child: Icon(Icons.remove),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ), //find me
//             GestureDetector(
//               onTap: () => setState(() {
//                 myMapController.animateCamera(
//                   CameraUpdate.newCameraPosition(
//                     CameraPosition(
//                       target: LatLng(position.latitude, position.longitude),
//                       zoom: 12,
//                     ),
//                   ),
//                 );
//               }),
//               child: CircleAvatar(
//                 child: Icon(Icons.near_me),
//               ),
//             ),
//           ],
//         ),
//         body: GoogleMap(
//           myLocationButtonEnabled: true,
//           zoomGesturesEnabled: true,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(position.latitude, position.longitude),
//             zoom: zoom,
//           ),
//           markers: Set<Marker>.of(allMarkers),
//           mapType: MapType.normal,
//           onMapCreated: onMapCreated,
//         ),
//       ),
//     ));
//   }
// }
