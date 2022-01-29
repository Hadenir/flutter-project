import 'package:flutter_project/widgets/star_wars_crawl.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class FilmDetailsScreen extends StatefulWidget {
  final int id;

  const FilmDetailsScreen({required this.id}) : super(key: const ValueKey('FilmDetailsScreen'));

  @override
  State<FilmDetailsScreen> createState() => _FilmDetailsScreenState();
}

class _FilmDetailsScreenState extends State<FilmDetailsScreen> {
  final _dataSource = DbEntryType.film.getDataSource<Film>();
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
                  SizedBox(
                    height: 400,
                    child: StarWarsCrawl(
                      'Episode ${_film!.episode}\n${_film!.title.toUpperCase()}\n',
                      _film!.openingCrawl,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_film!.title, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(name: 'Director', value: _film!.director),
                  DetailsEntry(name: 'Producer', value: _film!.producer),
                  DetailsEntry(name: 'Release date', value: DateFormat('dd.MM.yyyy').format(_film!.releaseDate)),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    _film!.characterIds,
                    header: 'Characters',
                    entryType: DbEntryType.person,
                  ),
                  RelatedEntriesList(
                    _film!.planetIds,
                    header: 'Planets',
                    entryType: DbEntryType.planet,
                  ),
                  RelatedEntriesList(
                    _film!.starshipIds,
                    header: 'Starships',
                    entryType: DbEntryType.starship,
                  ),
                  RelatedEntriesList(
                    _film!.vehicleIds,
                    header: 'Vehicles',
                    entryType: DbEntryType.vehicle,
                  ),
                  RelatedEntriesList(
                    _film!.speciesIds,
                    header: 'Species',
                    entryType: DbEntryType.species,
                  ),
                ],
              ),
            ),
    );
  }
}
