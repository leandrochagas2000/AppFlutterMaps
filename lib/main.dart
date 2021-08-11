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

  @override
  void dispose() {
    _layerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SfMaps(
                  layers: [
                    MapShapeLayer(
                      controller: _layerController,
            source: MapShapeSource.asset('assets/usa.json',
                      shapeDataField: 'name'),

                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: 46.412886,
                          longitude: -105.619861,
                        );
                      },
                    ),
                  ],
                ),
                FlatButton(
                  child: Text('Add marker'),
                  onPressed: () {
                    _layerController.insertMarker(0);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );

  }




}


// https://www.syncfusion.com/blogs/post/how-to-add-location-tracking-to-your-app-using-syncfusion-flutter-maps.aspx