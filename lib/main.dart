import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}





class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MapShapeSource _shapeSource;


  final MapShapeLayerController _layerController = MapShapeLayerController();
  final TextEditingController _currentLocationTextController = TextEditingController();
  final TextEditingController _destinationLocationTextController = TextEditingController();

  double? _distanceInMiles;
  Stream<Position>? _positionStream;

  late Position _currentPosition, _destinationPosition;

  @override
  void dispose() {
    _layerController.dispose();
    _currentLocationTextController.dispose();
    _destinationLocationTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF096770),
      body: SafeArea(
        child: Column(
          children: [
            //Title widget
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Location Tracker',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                //Current location text field.
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _currentLocationTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 3, top: 3, bottom: 3),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        hintText: 'Current location',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //Current location clickable icon.
                IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                  tooltip: 'My location',
                  onPressed: () async {
                    _currentPosition = await getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    List addresses = await placemarkFromCoordinates(
                        _currentPosition.latitude, _currentPosition.longitude);
                    _currentLocationTextController.text = addresses[0].name;
                    _layerController.insertMarker(0);
                  },
                )
              ],
            ),
            Row(
              children: [
                //Destination location text field.
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _destinationLocationTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 3, top: 3, bottom: 3),
                        hintText: 'Enter the destination',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                //Destination location clickable icon.
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  tooltip: 'Search',
                  onPressed: () async {
                    List places = await locationFromAddress(
                        _destinationLocationTextController.text);
                    _destinationPosition = Position(
                        longitude: places[0].longitude,
                        latitude: places[0].latitude);
                    _layerController.insertMarker(1);

                    //1 mile = 0.000621371 * meters
                    setState(() {
                      _distanceInMiles = distanceBetween(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                          _destinationPosition.latitude,
                          _destinationPosition.longitude) *
                          0.000621371;
                    });
                  },
                )
              ],
            ),
            //Maps widget container
            Container(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SfMaps(
                    layers: [
                      MapShapeLayer(
                        controller: _layerController,
                        markerBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            //current position
                            return MapMarker(
                                latitude: _currentPosition.latitude,
                                longitude: _currentPosition.longitude,
                                child: Icon(Icons.location_on));
                          } else if (index == 1) {
                            //destination position
                            return MapMarker(
                                latitude: _destinationPosition.latitude,
                                longitude: _destinationPosition.longitude,
                                child: Icon(Icons.location_on));
                          } else if (index == 2) {
                            //flight current position
                            return MapMarker(
                              latitude: _currentPosition.latitude,
                              longitude: _currentPosition.longitude,
                              child: Transform.rotate(
                                  angle: 45,
                                  child: Icon(Icons.flight)),
                            );
                          }
                          return MapMarker(
                            latitude: 38.8951,
                            longitude: -77.0364,
                          );
                        },
                        source: MapShapeSource.asset('assets/usa.json',
                            shapeDataField: 'name'),


                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Widget for starting location and stopping location
            //tracking. It also shows the current distance between the
            //current and destination location in miles.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${_distanceInMiles?.toStringAsFixed(2) ??
                                  '-'} miles.',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black)),
                          TextSpan(
                              text: '${'-'} miles.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        OutlineButton(
                          child: Text('Navigate'),
                          textColor: Colors.black,
                          onPressed: () async {
                            _layerController.insertMarker(2);
                            _positionStream = getPositionStream()
                                .listen((Position position) {
                              _currentPosition = position;
                              //1 mile = 0.000621371 * meters
                              setState(() {
                                _distanceInMiles = distanceBetween(
                                    _currentPosition.latitude,
                                    _currentPosition.longitude,
                                    _destinationPosition.latitude,
                                    _destinationPosition.longitude) *
                                    0.000621371;
                              });
                              _layerController.updateMarkers([2]);
                            }) as Stream<Position>?;
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        OutlineButton(
                          child: Text('Remove tracker'),
                          onPressed: () {
                            _layerController.removeMarkerAt(2);
                           //_positionStream.cancel();
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// https://www.syncfusion.com/blogs/post/how-to-add-location-tracking-to-your-app-using-syncfusion-flutter-maps.aspx