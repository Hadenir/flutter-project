import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class FilmDetailsScreen extends StatefulWidget {
  final int id;
  final ValueChanged<DbEntryDto> onEntryChanged;

  const FilmDetailsScreen({required this.id, required this.onEntryChanged})
      : super(key: const ValueKey('FilmDetailsScreen'));

  @override
  State<FilmDetailsScreen> createState() => _FilmDetailsScreenState();
}

class _FilmDetailsScreenState extends State<FilmDetailsScreen> {
  final _dataSource = StarWarsDbDataSource('films', (json) => Film.fromJson(json));
  Film? _film;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((film) => setState(() {
          if (film == null) return;
          _film = film;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _film != null ? Text(_film!.displayName) : null,
      ),
      body: _film == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.movie, size: 256),
                  Text(_film!.title, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  // TODO: Opening Crawl
                  DetailsEntry(name: 'Director', value: _film!.director),
                  DetailsEntry(name: 'Producer', value: _film!.producer),
                  DetailsEntry(name: 'Release date', value: DateFormat('dd.MM.yyyy').format(_film!.releaseDate)),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    _film!.characterIds,
                    header: 'Characters',
                    icon: Icons.person,
                    dataSource: StarWarsDbDataSource('people', (json) => Person.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _film!.planetIds,
                    header: 'Planets',
                    icon: Icons.public,
                    dataSource: StarWarsDbDataSource('planets', (json) => Planet.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _film!.starshipIds,
                    header: 'Starships',
                    icon: Icons.directions_boat,
                    dataSource: StarWarsDbDataSource('starships', (json) => Starship.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _film!.vehicleIds,
                    header: 'Vehicles',
                    icon: Icons.two_wheeler,
                    dataSource: StarWarsDbDataSource('vehicles', (json) => Vehicle.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _film!.speciesIds,
                    header: 'Species',
                    icon: Icons.balcony,
                    dataSource: StarWarsDbDataSource('species', (json) => Species.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                ],
              ),
            ),
    );
  }
}
