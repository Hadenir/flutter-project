import 'package:flutter/material.dart';
import 'package:flutter_project/navigation.dart';

void main() {
  runApp(const StarWarsDbApp());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class StarWarsDbApp extends StatefulWidget {
  const StarWarsDbApp({Key? key}) : super(key: key);

  @override
  State<StarWarsDbApp> createState() => _StarWarsDbAppState();
}

class _StarWarsDbAppState extends State<StarWarsDbApp> {
  final StarWarsDbRouterDelegate _routerDelegate = StarWarsDbRouterDelegate();
  final StarWarsDbRouteInformationParser _routeInformationParser = StarWarsDbRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Star Wars Database',
      theme: ThemeData.dark(),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
