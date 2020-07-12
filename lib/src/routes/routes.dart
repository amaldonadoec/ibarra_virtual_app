import 'package:flutter/material.dart';
import 'package:virtual_city_app/src/pages/detail.dart';
import 'package:virtual_city_app/src/pages/home.dart';
import 'package:virtual_city_app/src/pages/map.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'map': (BuildContext context) => MapPage(),
    'detail': (BuildContext context) => DetailPage(),
  };
}
