import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int id;
  final ValueChanged<DbEntryDto> onEntryChanged;

  const VehicleDetailsScreen({required this.id, required this.onEntryChanged})
      : super(key: const ValueKey('VehicleDetailsScreen'));

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _dataSource = StarWarsDbDataSource('vehicles', (json) => Vehicle.fromJson(json));
  Vehicle? _vehicle;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((vehicle) => setState(() {
          if (vehicle == null) return;
          _vehicle = vehicle;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _vehicle != null ? Text(_vehicle!.displayName) : null,
      ),
      body: _vehicle == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.two_wheeler, size: 256),
                  Text(_vehicle!.name, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(name: 'Model', value: _vehicle!.model),
                  DetailsEntry(name: 'Manufacturer', value: _vehicle!.manufacturer),
                  DetailsEntry(name: 'Crew', value: _vehicle!.crew != null ? _vehicle!.crew!.toString() : 'unknown'),
                  DetailsEntry(
                      name: 'Passengers',
                      value: _vehicle!.passengers != null ? _vehicle!.passengers!.toString() : 'unknown'),
                  DetailsEntry(name: 'Length', value: _vehicle!.length.toString() + ' m'),
                  DetailsEntry(
                      name: 'Cost',
                      value: _vehicle!.cost != null ? _vehicle!.cost!.toString() + ' credits' : 'unknown'),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    _vehicle!.filmIds,
                    header: 'Films',
                    icon: Icons.movie,
                    dataSource: StarWarsDbDataSource('films', (json) => Film.fromJson(json)),
                    onTap: widget.onEntryChanged,
                  ),
                  RelatedEntriesList(
                    _vehicle!.pilotIds,
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
