import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';

import 'data/starwars_entries.dart';

class HomeScreen extends StatelessWidget {
  final StarWarsDbDataSource _dataSource = StarWarsDbDataSource('planets', (x) => Planet.fromJson(x));

  HomeScreen() : super(key: const ValueKey('HomeScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Wars Database'),
      ),
      body: InkWell(
        onTap: () {
          _dataSource.getSingleEntry(1).then((value) {
            print(value);
          });
        },
      ),
      // body: const Center(child: Text('Home screen')),
    );
  }
}
