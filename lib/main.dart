import 'package:flutter/material.dart';
import 'package:virtual_city_app/src/pages/home.dart';
import 'package:virtual_city_app/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ibarra Virtual',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: '/',
        routes: getRoutes(),
        onGenerateRoute: (RouteSettings settings) {
          print('Ruta no definida: ${settings.name}');
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage());
        }
    );
  }
}
