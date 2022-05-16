// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:night_watch3/model/user.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocation/geolocation.dart';
// import 'package:geolocator/geolocator.dart';
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }d
// }

class Maps3 extends StatefulWidget {
  @override
  _Maps3State createState() => _Maps3State();
}

class _Maps3State extends State<Maps3> {
  // ignore: unused_element
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  void _setStyleDark(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_Dark.json');
    controller.setMapStyle(value);
  }

  // ignore: unused_element
  void _setStyleNight(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_Night.json');
    controller.setMapStyle(value);
  }

  // ignore: unused_element
  void _setStyleStandard(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_Standard.json');
    controller.setMapStyle(value);
  }

  late GoogleMapController _controller;
  var currentLocation = LocationData;
  var location = Location();
  late LatLng userPosition;

  List<Marker> allMarkers = [];

  late PageController _pageController;

  late int prevPage;

  // ignore: unused_field
  late LatLng _center;

  late double lon;
  late double lat;

  Future _getLocation() async {
    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        print('Latitude:${currentLocation.latitude}');
        print('Longitude:${currentLocation.longitude}');
        lon = currentLocation.latitude!;
        lat = currentLocation.longitude!;

        // return LatLng(lat, lon) ;
        
        // return LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } catch (e) {
      print('ERROR:$e');
      currentLocation = (null)!;
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getLocation();

    evStations.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.shopName),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.shopName, snippet: element.address),
          position: element.locationCoords));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? child) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black),
                        child: Row(children: [
                          Container(
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(image: ExactAssetImage(
                                      // evStations[index].thumbNail
                                      ''), fit: BoxFit.cover))),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  evStations[index].shopName,
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  evStations[index].address,
                                  style: TextStyle(
                                      color: Colors.lightGreen,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 170.0,
                                  child: Text(
                                    evStations[index].description,
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('',
              style: TextStyle(
                color: Colors.lightGreen,
              )),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0, -74.0060), zoom: 9.0),
                  markers: Set.from(allMarkers),
                  onMapCreated: mapCreated,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  trafficEnabled: true,
                  tiltGesturesEnabled: true,
                  buildingsEnabled: true,
                  indoorViewEnabled: true),
            ),
            Positioned(
              bottom: 20.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: evStations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coffeeShopList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
      _setStyleDark(controller);
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: evStations[_pageController.page!.toInt()].locationCoords,
        zoom: 20.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
  // int _radioValue = 0;
  // GoogleMapController _controller;

  // var pos;
  // // Geoflutterfire geo = Geoflutterfire();

  // Firestore _firestore = Firestore.instance;

  // List<Marker> allMarkers = [];

  // PageController _pageController;

  // int prevPage;
  // double lat;
  // double lng;

  // Position position;

  // //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  // @override
  // void initState() {
  //
  //   getLocation();
  //   _getCurrentLocation();

  //   super.initState();

  //   _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
  //     ..addListener(_onScroll);
  // }

  // void _onScroll() {
  //   if (_pageController.page.toInt() != prevPage) {
  //     prevPage = _pageController.page.toInt();
  //     moveCamera();
  //   }
  // }

  // Future<void> getLocation() async {

  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.location);

  //   if (permission == PermissionStatus.denied) {
  //     await PermissionHandler()
  //         .requestPermissions([PermissionGroup.locationAlways]);
  //   }
  // }

  // void _getCurrentLocation() async {
  //      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemark = await Geolocator()
  //       .placemarkFromCoordinates(position.latitude, position.longitude);
  //   var res = await Geolocator().getCurrentPosition();
  //   setState(() {
  //     pos = res;
  //   });
  //   // GeoFirePoint mylocation =
  //   //     geo.point(latitude: pos.latitude, longitude: pos.longitude);
  //   lat = res.latitude;
  //   lng = res.longitude;
  // }

  // _coffeeShopList(index) {
  //   return AnimatedBuilder(
  //     animation: _pageController,
  //     builder: (BuildContext context, Widget widget) {
  //       double value = 1;
  //       if (_pageController.position.haveDimensions) {
  //         value = _pageController.page - index;
  //         value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
  //       }
  //       return Center(
  //         child: SizedBox(
  //           height: Curves.easeInOut.transform(value) * 125.0,
  //           width: Curves.easeInOut.transform(value) * 350.0,
  //           child: widget,
  //         ),
  //       );
  //     },
  //     child: InkWell(
  //         onTap: () {
  //           moveCamera();
  //         },
  //         child: Stack(children: [
  //           Center(
  //               child: Container(
  //                   margin: EdgeInsets.symmetric(
  //                     horizontal: 10.0,
  //                     vertical: 20.0,
  //                   ),
  //                   height: 125.0,
  //                   width: 275.0,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black54,
  //                           offset: Offset(0.0, 4.0),
  //                           blurRadius: 10.0,
  //                         ),
  //                       ]),
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                           color: Colors.white),
  //                       child: Row(children: [
  //                         Container(
  //                             height: 90.0,
  //                             width: 90.0,
  //                             decoration: BoxDecoration(
  //                               // border: Color.fromARGB(a, r, g, b),
  //                               borderRadius: BorderRadius.only(
  //                                   bottomLeft: Radius.circular(10.0),
  //                                   topLeft: Radius.circular(10.0)),
  //                               // image: DecorationImage(
  //                               //     image: NetworkImage(
  //                               //         coffeeShops[index].thumbNail),
  //                               //     fit: BoxFit.cover)
  //                             )),
  //                         SizedBox(width: 5.0),

  //                         Column(
  //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 evStations[index].shopName,
  //                                 style: TextStyle(
  //                                     fontSize: 12.5,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                               Text(
  //                                 evStations[index].address,
  //                                 style: TextStyle(
  //                                     fontSize: 12.0,
  //                                     fontWeight: FontWeight.w600),
  //                               ),
  //                               Container(
  //                                 width: 170.0,
  //                                 child: Text(
  //                                   evStations[index].description,
  //                                   style: TextStyle(
  //                                       fontSize: 11.0,
  //                                       fontWeight: FontWeight.w300),
  //                                 ),
  //                               )
  //                             ])
  //                       ]))))
  //         ])),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.black,
  //         title: Text('Maps'),

  //         centerTitle: true,
  //       ),
  //       body: Stack(
  //         children: <Widget>[
  //           Container(
  //             height: MediaQuery.of(context).size.height - 50.0,
  //             width: MediaQuery.of(context).size.width,
  //             child: GoogleMap(
  //               onMapCreated: mapCreated,
  //               initialCameraPosition: CameraPosition(
  //                 target: LatLng(40.7128, -74.0060), zoom: 12.0),
  //               // markers: Set.from(allMarkers),
  //                   // target: LatLng(position.latitude,position.longitude), zoom: 12.0),

  //               // onMapCreated: (GoogleMapController controller) {

  //               //   // allMarkers.add(Marker(
  //               //   //     markerId: null,
  //               //   //     position: LatLng(lat,lng)));
  //               //   // _controller = controller;

  //               //   _setStyleDark(controller);
  //               // },
  //             ),
  //           ),
  //           Positioned(
  //             bottom: 20.0,
  //             child: Container(
  //               height: 200.0,
  //               width: MediaQuery.of(context).size.width,
  //               child: PageView.builder(
  //                 controller: _pageController,
  //                 itemCount: evStations.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return _coffeeShopList(index);
  //                 },
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }

  // void mapCreated(controller) {
  //   setState(() {
  //     _controller = controller;
  //     _setStyleDark(controller);
  //     evStations.forEach((element) {
  //     allMarkers.add(Marker(
  //       markerId: MarkerId(element.shopName),
  //       visible: true,
  //       draggable: false,
  //     ));
  //   });

  //   });
  // }

  // moveCamera() {
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: evStations[_pageController.page.toInt()].locationCoords,
  //       // target: LatLng(pos.latitude, pos.longitude),
  //       zoom: 10.0,
  //       bearing: 45.0,
  //       tilt: 50.0

  //       )));

  // }
}
