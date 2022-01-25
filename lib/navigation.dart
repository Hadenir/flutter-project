import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/home_screen.dart';

enum DbEntryType {
  people,
  films,
  starships,
  vehicles,
  species,
  planets,
}

class StarWarsDbPath {}

class DatabaseEntryPath extends StarWarsDbPath {
  final DbEntryType? entryType;
  final int? id;

  DatabaseEntryPath.home()
      : entryType = null,
        id = null;

  DatabaseEntryPath.list(this.entryType) : id = null;

  DatabaseEntryPath.details(this.entryType, this.id);
}

class LoginPath extends StarWarsDbPath {}

class ProfilePath extends StarWarsDbPath {
  final int id;

  ProfilePath(this.id);
}

class StarWarsDbRouterDelegate extends RouterDelegate<StarWarsDbPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StarWarsDbPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  DbEntryType? entryType;
  int? entryId;
  int? profileId;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomeScreenPage'),
          child: HomeScreen(),
        ),
        if (entryType != null) MaterialPage(child: Container()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        return true;
      },
    );
  }

  @override
  SynchronousFuture<void> setNewRoutePath(StarWarsDbPath configuration) {
    if (configuration is DatabaseEntryPath) {
      entryType = configuration.entryType;
      entryId = configuration.id;
      profileId = null;
    } else if (configuration is ProfilePath) {
      entryType = null;
      entryId = null;
      profileId = configuration.id;
    } else if (configuration is LoginPath) {
      // TODO
    }

    return SynchronousFuture(null);
  }

  @override
  StarWarsDbPath get currentConfiguration {
    if (profileId != null) return ProfilePath(profileId!);

    return DatabaseEntryPath.details(entryType, entryId);
  }
}

class StarWarsDbRouteInformationParser extends RouteInformationParser<StarWarsDbPath> {
  @override
  Future<StarWarsDbPath> parseRouteInformation(RouteInformation routeInformation) async {
    // TODO: Add error page and show it instead of homepage

    if (routeInformation.location == null) return DatabaseEntryPath.home();

    var uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.isEmpty) return DatabaseEntryPath.home();

    if (uri.pathSegments.length == 1) {
      switch (uri.pathSegments[0]) {
        case 'people':
          return DatabaseEntryPath.list(DbEntryType.people);
        case 'films':
          return DatabaseEntryPath.list(DbEntryType.people);
        case 'starships':
          return DatabaseEntryPath.list(DbEntryType.people);
        case 'vehicles':
          return DatabaseEntryPath.list(DbEntryType.people);
        case 'species':
          return DatabaseEntryPath.list(DbEntryType.people);
        case 'planets':
          return DatabaseEntryPath.list(DbEntryType.people);
        default:
          return DatabaseEntryPath.home();
      }
    }

    if (uri.pathSegments.length == 2) {
      var id = int.tryParse(uri.pathSegments[1]);
      switch (uri.pathSegments[0]) {
        case 'people':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'films':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'starships':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'vehicles':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'species':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'planets':
          return DatabaseEntryPath.details(DbEntryType.people, id);
        case 'profile':
          return id != null ? ProfilePath(id) : DatabaseEntryPath.home();
        default:
          return DatabaseEntryPath.home();
      }
    }

    return DatabaseEntryPath.home();
  }
}
