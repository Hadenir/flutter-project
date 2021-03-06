import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class PersonDetailsScreen extends StatefulWidget {
  final int id;

  const PersonDetailsScreen({required this.id}) : super(key: const ValueKey('PersonDetailsScreen'));

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  final _dataSource = DbEntryType.person.getDataSource<Person>();
  Person? _person;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((person) => setState(() {
          if (person == null) return;
          _person = person;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _person != null ? Text(_person!.displayName) : null,
        actions: [
          if (_person != null)
            IconButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: _person!.deeplink)),
              icon: const Icon(Icons.link),
            ),
        ],
      ),
      body: _person == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 256),
                  Text(_person!.name, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(name: 'Birth year', value: _person!.birthYear),
                  DetailsEntry(name: 'Gender', value: _person!.gender),
                  DetailsEntry(
                      name: 'Height', value: _person!.height != null ? _person!.height!.toString() + ' cm' : 'unknown'),
                  DetailsEntry(
                      name: 'Mass', value: _person!.mass != null ? _person!.mass!.toString() + ' kg' : 'unknown'),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    [if (_person != null && _person!.homeworldId != null) _person!.homeworldId!],
                    header: 'Homeworld',
                    entryType: DbEntryType.planet,
                  ),
                  RelatedEntriesList(
                    _person!.speciesIds,
                    header: 'Species',
                    entryType: DbEntryType.species,
                  ),
                  RelatedEntriesList(
                    _person!.starshipIds,
                    header: 'Starships',
                    entryType: DbEntryType.starship,
                  ),
                  RelatedEntriesList(
                    _person!.vehicleIds,
                    header: 'Vehicles',
                    entryType: DbEntryType.vehicle,
                  ),
                  RelatedEntriesList(
                    _person!.filmIds,
                    header: 'Films',
                    entryType: DbEntryType.film,
                  ),
                ],
              ),
            ),
    );
  }
}
