import 'dart:async';

import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:virtual_city_app/src/components/ar_view.dart';
import 'package:virtual_city_app/src/components/sample.dart';
import 'package:virtual_city_app/src/models/SiteResponse.dart';
import 'package:virtual_city_app/src/pages/ar.dart';
import 'package:virtual_city_app/src/providers/backend_provider.dart';
import 'package:virtual_city_app/src/routes/navigatorArgument.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> allMarkers = {};
  List<SiteResponse> _sites = [];
  int countSites = 0;

  @override
  void initState() {
    super.initState();
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    final NavigatorArgument args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              //
            }),
        title: Text(args.categoryName + ' ($countSites)'),
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _labelAR(),
          _cardTiles(args.categoryId),
        ],
      ),
    );
  }

  void getRequestSites(categoryId) async {
    final response = await getSites(categoryId);
    setState(() {
      _sites = response;
      countSites = _sites.length;
      allMarkers.clear();
      for (final office in response) {
        print('oficcc: ' + office.name);
        final marker = Marker(
          markerId: MarkerId(office.siteId.toString()),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
          ),
        );
        allMarkers[office.siteId.toString()] = marker;
      }
    });
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(0.3516377, -78.12012727), zoom: 15.0),
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          final NavigatorArgument args =
              ModalRoute.of(context).settings.arguments;

          getRequestSites(args.categoryId);
        },
        zoomControlsEnabled: false,
        markers: allMarkers.values.toSet(),
      ),
    );
  }

  Widget _labelAR() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 50.0,
        child: addOption(),
      ),
    );
  }

  Widget _cardTiles(categoryId) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Container(
              height: 110.0,
              child: ListView.builder(
                  itemCount: _sites.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final site = _sites[index];
                    return Container(
                      width: 320,
                      child: InkWell(
                        child: GFListTile(
                          avatar: GFImageOverlay(
                            height: 150,
                            width: 90,
                            image: NetworkImage(site.images[0].url),
                            boxFit: BoxFit.cover,
                            color: Colors.white,
                            colorFilter: ColorFilter.mode(
                                Colors.white, BlendMode.colorBurn),
                          ),
                          titleText: site.name,
                          color: Colors.white,
                          subTitle: Expanded(
                            child: Text(
                              site.description ?? '',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          icon: Icon(Icons.location_on),
                          margin: EdgeInsets.only(left: 7, right: 7),
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 0, right: 8),
                        ),
                        onTap: () {
                          _gotoLocation(site.lat, site.lng);
                        },
                      ),
                    );
                  }),
            )));
  }

  Widget myDetailsContainer1(String restaurantName, double lat, double long) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _gotoLocation(lat, long);
              },
              color: Colors.red,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5.0),
            RaisedButton(
              onPressed: () {},
              color: Colors.blue,
              child: Text('Ver mas detalles',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 18,
      bearing: 45.0,
    )));
  }

  Widget addOption() {
    Sample sample = new Sample.fromJson({
      "required_extensions": ["application_model_pois", "geo"],
      "name": "Realidad aumentada UTN",
      "path": "09_ObtainPoiData_1_FromApplicationModel/index.html",
      "requiredFeatures": ["geo"],
      "startupConfiguration": {
        "camera_position": "back",
        "camera_resolution": "auto"
      }
    });

    return FutureBuilder(
        future: _isDeviceSupporting(["application_model_pois", "geo"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                decoration: BoxDecoration(
                    color: snapshot.data.success ? Colors.white : Colors.grey),
                child: ListTile(
                    title: Text(
                      "Visualizar con realidad aumentada >",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      snapshot.data.success
                          ? _pushArView(sample, _sites)
                          : _showDialog("Funciones faltantes del dispositivo",
                              snapshot.data.message);
                    }));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<WikitudeResponse> _isDeviceSupporting(List<String> features) async {
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  Future<WikitudeResponse> _requestARPermissions(List<String> features) async {
    return await WikitudePlugin.requestARPermissions(features);
  }

  Future<void> _pushArView(Sample sample, List<SiteResponse> sites) async {
    WikitudeResponse permissionsResponse =
        await _requestARPermissions(sample.requiredFeatures);
    if (permissionsResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArViewWidget(
                  sample: sample,
                  sites: sites,
                )),
      );
    } else {
      _showPermissionError(permissionsResponse.message);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showPermissionError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permissions required"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Open settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  WikitudePlugin.openAppSettings();
                },
              )
            ],
          );
        });
  }
}

Marker item1 = Marker(
  markerId: MarkerId('1'),
  position: LatLng(0.3516377, -78.12012727),
  infoWindow: InfoWindow(title: 'Iglesia La Merced'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker item2 = Marker(
  markerId: MarkerId('2'),
  position: LatLng(0.35107529, -78.11750468),
  infoWindow: InfoWindow(title: 'Catedral de Pedro Moncayo'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
