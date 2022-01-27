import 'package:flutter/material.dart';
import 'package:flutter_project/navigation.dart';

class HomeScreenPage extends Page {
  final ValueChanged<DbEntryType> onEntryTypeChanged;

  const HomeScreenPage({required this.onEntryTypeChanged}) : super(key: const ValueKey('HomeScreenPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => HomeScreen(onEntryTypeChanged: onEntryTypeChanged),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ValueChanged<DbEntryType> onEntryTypeChanged;

  const HomeScreen({required this.onEntryTypeChanged}) : super(key: const ValueKey('HomeScreen'));

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
            onTap: () => onEntryTypeChanged(DbEntryType.people),
          ),
          GridTile(
            title: 'Films',
            icon: const Icon(Icons.movie),
            onTap: () => onEntryTypeChanged(DbEntryType.films),
          ),
          GridTile(
            title: 'Starships',
            icon: const Icon(Icons.directions_boat_filled),
            onTap: () => onEntryTypeChanged(DbEntryType.starships),
          ),
          GridTile(
            title: 'Vehicles',
            icon: const Icon(Icons.two_wheeler),
            onTap: () => onEntryTypeChanged(DbEntryType.vehicles),
          ),
          GridTile(
            title: 'Species',
            icon: const Icon(Icons.balcony),
            onTap: () => onEntryTypeChanged(DbEntryType.species),
          ),
          GridTile(
            title: 'Planets',
            icon: const Icon(Icons.public),
            onTap: () => onEntryTypeChanged(DbEntryType.planets),
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
    );
  }
}
