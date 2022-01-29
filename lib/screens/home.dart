import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation/navigation_stack.dart';
import 'package:flutter_project/navigation/page_config.dart';

class HomeScreenPage extends Page {
  const HomeScreenPage() : super(key: const ValueKey('HomeScreenPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen() : super(key: const ValueKey('HomeScreen'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Wars Database'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          GridTile(
            title: 'People',
            icon: const Icon(Icons.person),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.person)),
          ),
          GridTile(
            title: 'Films',
            icon: const Icon(Icons.movie),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.film)),
          ),
          GridTile(
            title: 'Starships',
            icon: const Icon(Icons.directions_boat_filled),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.starship)),
          ),
          GridTile(
            title: 'Vehicles',
            icon: const Icon(Icons.two_wheeler),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.vehicle)),
          ),
          GridTile(
            title: 'Species',
            icon: const Icon(Icons.balcony),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.species)),
          ),
          GridTile(
            title: 'Planets',
            icon: const Icon(Icons.public),
            onTap: () => BlocProvider.of<NavigationCubit>(context)
                .push(DatabaseEntriesListPageConfig(entryType: DbEntryType.planet)),
          ),
        ],
      ),
    );
  }
}

class GridTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const GridTile({required this.icon, required this.title, this.onTap, Key? key}) : super(key: key);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FittedBox(child: icon),
                )),
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
