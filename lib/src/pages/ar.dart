import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_city_app/src/components/ar_view.dart';
import 'package:virtual_city_app/src/components/category.dart';
import 'package:virtual_city_app/src/components/custom_expansion_tile.dart'
    as custom;

import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_sdk_build_information.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:virtual_city_app/src/components/sample.dart';

class ArPage extends StatefulWidget {
  ArPage({Key key}) : super(key: key);

  @override
  _ArPageState createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Realidad aumentadad'),
        ),
        body: Container(
            decoration: BoxDecoration(color: Color(0xffdddddd)),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: CategoryExpansionTile(),
            ))

    );
  }
}

class CategoryExpansionTile extends StatefulWidget {
  CategoryExpansionTile({Key key}) : super(key: key);

  @override
  CategoryExpansionTileState createState() => new CategoryExpansionTileState();
}

class CategoryExpansionTileState extends State<CategoryExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return addOption();
  }

  Widget addOption() {
    Sample sample = new Sample.fromJson({
      "required_extensions": ["application_model_pois", "geo"],
      "name": "From Application Model",
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
                    title: Text("Ver en AR"),
                    onTap: () {
                      snapshot.data.success
                          ? _pushArView(sample)
                          : _showDialog(
                              "Device missing features", snapshot.data.message);
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

  Future<void> _pushArView(Sample sample) async {
    WikitudeResponse permissionsResponse =
        await _requestARPermissions(sample.requiredFeatures);
    if (permissionsResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArViewWidget(sample: sample)),
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
