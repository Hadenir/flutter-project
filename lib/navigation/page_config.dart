import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/data/starwars_entries.dart';
import 'package:flutter_project/screens/home.dart';

abstract class StarWarsDbPageConfig extends Equatable {
  Page get page;
}

class HomePageConfig extends StarWarsDbPageConfig {
  @override
  Page get page => const HomeScreenPage();

  @override
  List<Object?> get props => [];
}

class DatabaseEntriesListPageConfig extends StarWarsDbPageConfig {
  final DbEntryType entryType;

  @override
  Page get page => entryType.mapToListPage();

  DatabaseEntriesListPageConfig({required this.entryType});

  @override
  List<Object?> get props => [entryType];
}

class DatabaseEntryPathConfig extends StarWarsDbPageConfig {
  final DbEntryType entryType;
  final int id;

  @override
  Page get page => entryType.mapToDetailsPage(id);

  DatabaseEntryPathConfig({required this.entryType, required this.id});

  DatabaseEntryPathConfig.fromEntry(StarWarsDbEntry entry)
      : entryType = entry.entryType,
        id = entry.id;

  @override
  List<Object?> get props => [entryType, id];
}
