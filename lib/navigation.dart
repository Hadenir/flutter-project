import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_data_source.dart';
import 'package:flutter_project/screens/entries_list.dart';
import 'package:flutter_project/screens/entry_details_page.dart';
import 'package:flutter_project/screens/film_details.dart';
import 'package:flutter_project/screens/home.dart';
import 'package:flutter_project/screens/person_details.dart';
import 'package:flutter_project/screens/planet_details.dart';
import 'package:flutter_project/screens/species_details.dart';
import 'package:flutter_project/screens/starship_details.dart';
import 'package:flutter_project/screens/vehicle_details.dart';

import 'data/starwars_entries.dart';

enum DbEntryType {
  people,
  films,
  starships,
  vehicles,
  species,
  planets,
}

class DbEntryDto {
  final DbEntryType entryType;
  final int entryId;

  DbEntryDto(this.entryType, this.entryId);
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
        HomeScreenPage(
          onEntryTypeChanged: (entryType) {
            this.entryType = entryType;
            notifyListeners();
          },
        ),
        if (entryType == DbEntryType.people) ...[
          EntriesListScreenPage(
            entryName: 'People',
            icon: Icons.person,
            dataSource: StarWarsDbDataSource('people', (json) => Person.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: PersonDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ],
        if (entryType == DbEntryType.films) ...[
          EntriesListScreenPage(
            entryName: 'Films',
            icon: Icons.movie,
            dataSource: StarWarsDbDataSource('films', (json) => Film.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: FilmDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ],
        if (entryType == DbEntryType.starships) ...[
          EntriesListScreenPage(
            entryName: 'Starships',
            icon: Icons.directions_boat,
            dataSource: StarWarsDbDataSource('starships', (json) => Starship.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: StarshipDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ],
        if (entryType == DbEntryType.vehicles) ...[
          EntriesListScreenPage(
            entryName: 'Vehicles',
            icon: Icons.two_wheeler,
            dataSource: StarWarsDbDataSource('vehicles', (json) => Vehicle.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: VehicleDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ],
        if (entryType == DbEntryType.species) ...[
          EntriesListScreenPage(
            entryName: 'Species',
            icon: Icons.balcony,
            dataSource: StarWarsDbDataSource('species', (json) => Species.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: SpeciesDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ],
        if (entryType == DbEntryType.planets) ...[
          EntriesListScreenPage(
            entryName: 'Planets',
            icon: Icons.public,
            dataSource: StarWarsDbDataSource('planets', (json) => Planet.fromJson(json)),
            onEntryIdChanged: (entryId) {
              this.entryId = entryId;
              notifyListeners();
            },
          ),
          if (entryId != null)
            EntryDetailsScreenPage(
              screen: PlanetDetailsScreen(
                id: entryId!,
                onEntryChanged: (entryDto) {
                  entryType = entryDto.entryType;
                  entryId = entryDto.entryId;
                  notifyListeners();
                },
              ),
            )
        ]
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        if (profileId != null) {
          profileId = null;
          return true;
        } else if (entryType != null) {
          if (entryId != null) {
            entryId = null;
          } else {
            entryType = null;
          }
          return true;
        }

        return false;
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
