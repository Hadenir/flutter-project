import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';

class PersonDetailsScreenPage extends Page {
  final int id;

  const PersonDetailsScreenPage({required this.id});

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => PersonDetailsScreen(id: id),
    );
  }
}

class PersonDetailsScreen extends StatefulWidget {
  final int id;

  const PersonDetailsScreen({required this.id}) : super(key: const ValueKey('PersonDetailsScreen'));

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  final _dataSource = StarWarsDbDataSource<Person>('people', (json) => Person.fromJson(json));
  Person? _person;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((person) => setState(() {
          _person = person;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _person == null ? const Center(child: CircularProgressIndicator()) : Center(child: Text(_person!.name)),
    );
  }
}
