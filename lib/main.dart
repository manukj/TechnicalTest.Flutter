import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/routes/app_routes.dart';
import 'package:flutter_tech_task/core/routes/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tech Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.listing,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
