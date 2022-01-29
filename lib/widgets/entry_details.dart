import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation/navigation_stack.dart';
import 'package:flutter_project/navigation/page_config.dart';

class EntryListTile<E extends StarWarsDbEntry> extends StatelessWidget {
  final E entry;
  final VoidCallback? onTap;
  final IconData icon;

  EntryListTile(this.entry, {required this.icon, this.onTap}) : super(key: ValueKey(entry));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 7,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              constraints: const BoxConstraints(minHeight: 64),
              child: Row(
                children: [
                  Icon(icon, size: 64),
                  const SizedBox(width: 8),
                  Text(entry.displayName),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsEntry extends StatelessWidget {
  final String name;
  final String value;

  DetailsEntry({required this.name, required this.value}) : super(key: ValueKey(name));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const SizedBox(height: 8),
          Expanded(child: Text(name + ':')),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class RelatedEntriesList<E extends StarWarsDbEntry> extends StatefulWidget {
  final List<int> ids;
  final StarWarsDbDataSource<E> dataSource;
  final String header;
  final IconData icon;

  RelatedEntriesList(this.ids, {required this.header, required DbEntryType entryType})
      : icon = entryType.getIcon(),
        dataSource = entryType.getDataSource(),
        super(key: ValueKey(header + 'RelatedEntriesList'));

  @override
  State<RelatedEntriesList<E>> createState() => _RelatedEntriesListState<E>();
}

class _RelatedEntriesListState<E extends StarWarsDbEntry> extends State<RelatedEntriesList<E>> {
  List<E> _entries = List.empty();
  bool _isLoading = true;

  @override
  void initState() {
    Future.wait(widget.ids.map((id) => widget.dataSource.getSingleEntry(id))).then((entries) {
      if (mounted) {
        setState(() {
          _entries = entries.where((x) => x != null).cast<E>().toList();
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading || _entries.isNotEmpty
        ? ExpansionTile(
            title: Text(widget.header),
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else if (_entries.isNotEmpty)
                ListView.builder(
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: EntryListTile<E>(_entries[i],
                        icon: widget.icon,
                        onTap: () => BlocProvider.of<NavigationCubit>(context)
                            .push(DatabaseEntryPathConfig.fromEntry(_entries[i]))),
                  ),
                  itemCount: _entries.length,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
            ],
          )
        : Container();
  }
}
