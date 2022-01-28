import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class StarshipDetailsScreen extends StatefulWidget {
  final int id;
  final ValueChanged<DbEntryDto> onEntryChanged;

  const StarshipDetailsScreen({required this.id, required this.onEntryChanged})
      : super(key: const ValueKey('StarshipDetailsScreen'));

  @override
  State<StarshipDetailsScreen> createState() => _StarshipDetailsScreenState();
}

class _StarshipDetailsScreenState extends State<StarshipDetailsScreen> {
  final _dataSource = StarWarsDbDataSource('starships', (json) => Starship.fromJson(json));
  Starship? _starship;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((starship) => setState(() {
          if (starship == null) return;
          _starship = starship;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _starship != null ? Text(_starship!.displayName) : null,
      ),
      body: _starship == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_boat, size: 256),
                  Text(_starship!.name, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(name: 'Model', value: _starship!.model),
                  DetailsEntry(name: 'Manufacturer', value: _starship!.manufacturer),
                  DetailsEntry(
                      name: 'Hyperdrive Rating',
                      value: _starship!.hyperdriveRating != null ? _starship!.hyperdriveRating!.toString() : 'unknown'),
                  DetailsEntry(name: 'Crew', value: _starship!.crew),
                  DetailsEntry(name: 'Passengers', value: _starship!.passengers),
                  DetailsEntry(name: 'Length', value: _starship!.length.toString() + ' m'),
                  DetailsEntry(
                      name: 'Cost',
                      value: _starship!.cost != null ? _starship!.cost!.toString() + ' credits' : 'unknown'),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    _starship!.filmIds,
                    header: 'Films',
                    icon: Icons.movie,
                    dataSource: StarWarsDbDataSource('films', (json) => Film.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _starship!.pilotIds,
                    header: 'Pilots',
                    icon: Icons.person,
                    dataSource: StarWarsDbDataSource('people', (json) => Person.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                ],
              ),
            ),
    );
  }
}
