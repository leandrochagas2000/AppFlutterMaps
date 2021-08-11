import 'package:flutter/material.dart';
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

  //Position _currentPosition, _destinationPosition;

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
                  onPressed: () async {},
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
                  onPressed: () async {},
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
                          onPressed: () async {},
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        OutlineButton(
                          child: Text('Remove tracker'),
                          onPressed: () {},
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