import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation/navigation_stack.dart';
import 'package:flutter_project/navigation/page_config.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class EntriesListScreenPage<E extends StarWarsDbEntry> extends Page {
  final String title;
  final IconData icon;
  final StarWarsDbDataSource<E> dataSource;

  EntriesListScreenPage({required this.title, required this.icon, required this.dataSource})
      : super(key: ValueKey(title + 'ListScreenPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => EntriesListScreen<E>(
        title: title,
        icon: icon,
        dataSource: dataSource,
      ),
    );
  }
}

class EntriesListScreen<E extends StarWarsDbEntry> extends StatefulWidget {
  final String title;
  final IconData icon;
  final StarWarsDbDataSource<E> dataSource;

  EntriesListScreen({required this.title, required this.icon, required this.dataSource})
      : super(key: ValueKey(title + 'ListScreen'));

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
        title: Text('Star Wars Db - ' + widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesSearchPageConfig(entryType: widget.dataSource.entryType)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemBuilder: (context, i) => EntryListTile<E>(
                        _entries[i],
                        icon: widget.icon,
                        onTap: () => BlocProvider.of<NavigationCubit>(context)
                            .push(DatabaseEntryPathConfig.fromEntry(_entries[i])),
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
            ),
    );
  }

  Future<void> _scrollListener() async {
    if (_isLoadingMore) return;

    if (_scrollController.position.extentAfter < 150) {
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
