import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:virtual_city_app/src/components/applicationModelPois.dart';
import 'package:virtual_city_app/src/components/poi.dart';
import 'package:virtual_city_app/src/components/sample.dart';
import 'package:virtual_city_app/src/models/SiteResponse.dart';

class ArViewState extends State<ArViewWidget> with WidgetsBindingObserver {
  ArchitectWidget architectWidget;
  Sample sample;
  List<SiteResponse> sites = [];

  String loadPath = "";


  ArViewState(Sample sample, List<SiteResponse> sites) {
    this.sample = sample;
    this.sites = sites;
    if (sample.path.contains("http://") || sample.path.contains("https://")) {
      loadPath = sample.path;
    } else {
      loadPath = "samples/" + sample.path;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    architectWidget = new ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey:
          '',
      startupConfiguration: sample.startupConfiguration,
      features: ["image_tracking", "geo"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sample.name)),
      body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: architectWidget),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (this.architectWidget != null) {
          this.architectWidget.pause();
        }
        break;
      case AppLifecycleState.resumed:
        if (this.architectWidget != null) {
          this.architectWidget.resume();
        }
        break;

      default:
    }
  }

  @override
  void dispose() {
    if (this.architectWidget != null) {
      this.architectWidget.pause();
      this.architectWidget.destroy();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onArchitectWidgetCreated() async {
    this.architectWidget.load(loadPath, onLoadSuccess, onLoadFailed);
    this.architectWidget.resume();
    if (sample.requiredExtensions != null &&
        sample.requiredExtensions.contains("application_model_pois")) {
      ApplicationModelPois applicationModelPois = new ApplicationModelPois();
      List<Poi> pois =
          await applicationModelPois.prepareApplicationDataModel(sites);
      this.architectWidget.callJavascript(
          "World.loadPoisFromJsonData(" + jsonEncode(pois) + ");");
      this.architectWidget.setJSONObjectReceivedCallback(onJSONObjectReceived);
    }
  }

  Future<void> onJSONObjectReceived(Map<String, dynamic> jsonObject) async {
//    Poi.fromJson(jsonObject['argumentations']);
    print('received from js');
    print(jsonObject['pointSelectedId']);
    SiteResponse site = this.sites.firstWhere(
        // ignore: unrelated_type_equality_checks
        (element) => element.siteId == jsonObject['pointSelectedId']);
    Navigator.pushNamed(this.context, 'detail',arguments: site);
    print(site.siteId);
  }

  void onLoadFailed(String error) {
    print(error);
  }

  void onLoadSuccess() {}
}

class ArViewWidget extends StatefulWidget {
  final Sample sample;
  final List<SiteResponse> sites;

  ArViewWidget({
    Key key,
    @required this.sample,
    @required this.sites,
  });

  @override
  ArViewState createState() => new ArViewState(sample, sites);
}
