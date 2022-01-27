import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';

class EntriesListScreenPage<E extends StarWarsDbEntry> extends Page {
  final String entryName;
  final IconData icon;
  final ValueChanged<int> onEntryIdChanged;
  final StarWarsDbDataSource<E> dataSource;

  EntriesListScreenPage(
      {required this.entryName, required this.icon, required this.dataSource, required this.onEntryIdChanged})
      : super(key: ValueKey(entryName + 'ListScreenPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => EntriesListScreen<E>(
        entryName: entryName,
        icon: icon,
        dataSource: dataSource,
        onEntryIdChanged: onEntryIdChanged,
      ),
    );
  }
}

class EntriesListScreen<E extends StarWarsDbEntry> extends StatefulWidget {
  final String entryName;
  final IconData icon;
  final ValueChanged<int> onEntryIdChanged;
  final StarWarsDbDataSource<E> dataSource;

  EntriesListScreen(
      {required this.entryName, required this.icon, required this.dataSource, required this.onEntryIdChanged})
      : super(key: ValueKey(entryName + 'ListScreen'));

  @override
  State<EntriesListScreen> createState() => _EntriesListScreenState<E>();
}

class _EntriesListScreenState<E extends StarWarsDbEntry> extends State<EntriesListScreen<E>> {
  final _entries = List<E>.empty(growable: true);
  final _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    widget.dataSource.getEntries().then((entries) => setState(() {
          _isLoading = false;
          if (entries != null) _entries.addAll(entries);
        }));

    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Star Wars Db - ' + widget.entryName),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      child: ListView.separated(
                        itemBuilder: (context, i) => ListTile<E>(
                          _entries[i],
                          icon: widget.icon,
                          onTap: () => widget.onEntryIdChanged(_entries[i].id),
                        ),
                        separatorBuilder: (context, i) => const SizedBox(height: 8),
                        itemCount: _entries.length,
                        padding: const EdgeInsets.all(8),
                        controller: _scrollController,
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Container(
                        color: Theme.of(context).dialogBackgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        )),
                    crossFadeState: _isLoadingMore ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  )
                ],
              ));
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels + 128 > _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      var entries = await widget.dataSource.getEntriesNextPage();
      setState(() {
        _isLoadingMore = false;
        if (entries != null) {
          _entries.addAll(entries);
        }
      });
    }
  }
}

class ListTile<E extends StarWarsDbEntry> extends StatelessWidget {
  final E entry;
  final VoidCallback? onTap;
  final IconData icon;

  ListTile(this.entry, {required this.icon, this.onTap}) : super(key: ValueKey(entry));

  @override
  Widget build(BuildContext context) {
    return Ink(
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
    );
  }
}
