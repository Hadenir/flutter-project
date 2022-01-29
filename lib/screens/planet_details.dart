import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class PlanetDetailsScreen extends StatefulWidget {
  final int id;

  const PlanetDetailsScreen({required this.id}) : super(key: const ValueKey('PlanetDetailsScreen'));

  @override
  State<PlanetDetailsScreen> createState() => _PlanetDetailsScreenState();
}

class _PlanetDetailsScreenState extends State<PlanetDetailsScreen> {
  final _dataSource = DbEntryType.planet.getDataSource<Planet>();
  Planet? _planet;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((planet) => setState(() {
          if (planet == null) return;
          _planet = planet;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _planet != null ? Text(_planet!.displayName) : null,
      ),
      body: _planet == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.public, size: 256),
                  Text(_planet!.name, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(
                      name: 'Rotation Period',
                      value:
                          _planet!.rotationPeriod != null ? _planet!.rotationPeriod!.toString() + ' days' : 'unknown'),
                  DetailsEntry(
                      name: 'Orbital Period',
                      value: _planet!.orbitalPeriod != null ? _planet!.orbitalPeriod!.toString() + ' days' : 'unknown'),
                  DetailsEntry(name: 'Climate', value: _planet!.climate),
                  DetailsEntry(name: 'Gravity', value: _planet!.gravity),
                  DetailsEntry(name: 'Terrain', value: _planet!.terrain),
                  DetailsEntry(
                      name: 'Population',
                      value: _planet!.population != null ? _planet!.population!.toString() : 'unknown'),
                  DetailsEntry(
                      name: 'Diameter',
                      value: _planet!.diameter != null ? _planet!.diameter!.toString() + ' km' : 'unknown'),
                  RelatedEntriesList(
                    _planet!.residentIds,
                    header: 'Residents',
                    entryType: DbEntryType.person,
                  ),
                  RelatedEntriesList(
                    _planet!.filmIds,
                    header: 'Films',
                    entryType: DbEntryType.film,
                  ),
                ],
              ),
            ),
    );
  }
}
