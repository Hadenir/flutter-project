import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/navigation/navigation_stack.dart';
import 'package:flutter_project/navigation/page_config.dart';

class NavigationRouterDelegate extends RouterDelegate<StarWarsDbPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<StarWarsDbPageConfig> {
  NavigationRouterDelegate();

  final _cubit = NavigationCubit([HomePageConfig()]);

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  StarWarsDbPageConfig? get currentConfiguration => _cubit.state.last;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocConsumer<NavigationCubit, NavigationStack>(
        builder: (context, stack) => Navigator(
          pages: stack.pages,
          key: navigatorKey,
          onPopPage: _onPopPage,
        ),
        listener: (context, state) => notifyListeners(),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(StarWarsDbPageConfig configuration) async {
    _cubit.push(configuration);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;

    if (!_cubit.canPop()) return false;

    _cubit.pop();
    return true;
  }
}

class NavigationRouteInformationParser extends RouteInformationParser<StarWarsDbPageConfig> {
  @override
  Future<StarWarsDbPageConfig> parseRouteInformation(RouteInformation routeInformation) async {
    var location = routeInformation.location;
    if (location == null) return HomePageConfig();

    if (location.endsWith('/')) location = location.substring(0, location.length - 1);

    var uri = Uri.parse(location);
    if (uri.pathSegments.isEmpty) return HomePageConfig();

    if (uri.pathSegments.length == 1) {
      var entryType = DbEntryTypeParser.tryParse(uri.pathSegments[0]);
      if (entryType == null) return HomePageConfig();

      return DatabaseEntriesListPageConfig(entryType: entryType);
    }

    if (uri.pathSegments.length == 2) {
      var entryType = DbEntryTypeParser.tryParse(uri.pathSegments[0]);
      if (entryType == null) return HomePageConfig();
      var id = int.tryParse(uri.pathSegments[1]);
      if (id == null) return HomePageConfig();

      return DatabaseEntryPathConfig(entryType: entryType, entryId: id);
    }

    return HomePageConfig();
  }

  @override
  RouteInformation? restoreRouteInformation(StarWarsDbPageConfig configuration) {
    String location;
    if (configuration is HomePageConfig) {
      location = '';
    } else if (configuration is DatabaseEntriesListPageConfig) {
      location = configuration.entryType.getDataSource().entryName;
    } else if (configuration is DatabaseEntryPathConfig) {
      location = configuration.entryType.getDataSource().entryName + '/' + configuration.entryId.toString();
    } else {
      return null;
    }

    return RouteInformation(location: '/' + location);
  }
}
