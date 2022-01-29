import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation/navigation_stack.dart';
import 'package:flutter_project/navigation/page_config.dart';
import 'package:flutter_project/widgets/entry_details.dart';

class EntriesSearchScreenPage<E extends StarWarsDbEntry> extends Page {
  final String title;
  final IconData icon;
  final StarWarsDbDataSource<E> dataSource;

  EntriesSearchScreenPage({required this.title, required this.icon, required this.dataSource})
      : super(key: ValueKey(title + 'EntriesSearchPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => EntriesSearchScreen<E>(
        title: title,
        icon: icon,
        dataSource: dataSource,
      ),
    );
  }
}

class EntriesSearchScreen<E extends StarWarsDbEntry> extends StatefulWidget {
  final String title;
  final IconData icon;
  final StarWarsDbDataSource<E> dataSource;

  const EntriesSearchScreen({required this.title, required this.icon, required this.dataSource})
      : super(key: const ValueKey('EntriesSearchScreen'));

  @override
  _EntriesSearchScreenState<E> createState() => _EntriesSearchScreenState();
}

class _EntriesSearchScreenState<E extends StarWarsDbEntry> extends State<EntriesSearchScreen<E>> {
  final _entries = List<E>.empty(growable: true);
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textEditingController.clear(),
                ),
                hintText: 'Search...',
              ),
              onSubmitted: (query) async {
                setState(() {
                  _entries.clear();
                  _isLoading = true;
                });

                var entries = await widget.dataSource.search(query);
                if (entries != null) {
                  _entries.addAll(entries);
                }

                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
        ),
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
