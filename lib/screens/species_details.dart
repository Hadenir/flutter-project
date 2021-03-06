import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class SpeciesDetailsScreen extends StatefulWidget {
  final int id;

  const SpeciesDetailsScreen({required this.id}) : super(key: const ValueKey('SpeciesDetailsScreen'));

  @override
  State<SpeciesDetailsScreen> createState() => _SpeciesDetailsScreenState();
}

class _SpeciesDetailsScreenState extends State<SpeciesDetailsScreen> {
  final _dataSource = DbEntryType.species.getDataSource<Species>();
  Species? _species;

  @override
  void initState() {
    _dataSource.getSingleEntry(widget.id).then((species) => setState(() {
          if (species == null) return;
          _species = species;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _species != null ? Text(_species!.displayName) : null,
        actions: [
          if (_species != null)
            IconButton(
              onPressed: () => Clipboard.setData(ClipboardData(text: _species!.deeplink)),
              icon: const Icon(Icons.link),
            ),
        ],
      ),
      body: _species == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.balcony, size: 256),
                  Text(_species!.name, style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 8),
                  DetailsEntry(name: 'Classification', value: _species!.classification),
                  DetailsEntry(name: 'Skin Colors', value: _species!.skinColors.join(', ')),
                  DetailsEntry(name: 'Hair Colors', value: _species!.hairColors.join(', ')),
                  DetailsEntry(name: 'Eye Colors', value: _species!.eyeColors.join(', ')),
                  DetailsEntry(name: 'Lifespan', value: _species!.lifespan + ' years'),
                  DetailsEntry(name: 'Language', value: _species!.language),
                  const SizedBox(height: 16),
                  RelatedEntriesList(
                    [if (_species != null && _species!.homeworldId != null) _species!.homeworldId!],
                    header: 'Homeworld',
                    entryType: DbEntryType.planet,
                  ),
                  RelatedEntriesList(
                    _species!.filmIds,
                    header: 'Films',
                    entryType: DbEntryType.film,
                  ),
                ],
              ),
            ),
    );
  }
}
