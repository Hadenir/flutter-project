import 'package:flutter_project/data/starwars_data_source.dart';

int? extractIdFromUrl(String? url) {
  if (url != null) {
    var uri = Uri.parse(url);
    return int.tryParse(uri.pathSegments[2]);
  }
}

abstract class StarWarsDbEntry {
  final int id;

  StarWarsDbEntry(this.id);

  String get displayName;
}

class Person extends StarWarsDbEntry {
  final String name;
  final String birthYear;
  final String gender;
  final int? height;
  final int? mass;

  final int? homeworldId;
  final List<int> speciesIds;
  final List<int> starshipIds;
  final List<int> vehicleIds;
  final List<int> filmIds;

  @override
  String get displayName => name;

  Person._({
    required id,
    required this.name,
    required this.birthYear,
    required this.gender,
    required this.height,
    required this.mass,
    required this.homeworldId,
    required this.speciesIds,
    required this.starshipIds,
    required this.vehicleIds,
    required this.filmIds,
  }) : super(id);

  factory Person.fromJson(Json json) {
    return Person._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      birthYear: json['birth_year'],
      gender: json['gender'],
      height: int.tryParse(json['height']),
      mass: int.tryParse(json['mass']),
      homeworldId: extractIdFromUrl(json['homeworld']),
      speciesIds: json['species'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      starshipIds: json['starships'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      vehicleIds: json['vehicles'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Film extends StarWarsDbEntry {
  final int episode;
  final String title;
  final String openingCrawl;
  final String director;
  final String producer;
  final DateTime releaseDate;

  final List<int> characterIds;
  final List<int> planetIds;
  final List<int> starshipIds;
  final List<int> vehicleIds;
  final List<int> speciesIds;

  @override
  String get displayName => title;

  Film._({
    required id,
    required this.episode,
    required this.title,
    required this.openingCrawl,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.characterIds,
    required this.planetIds,
    required this.starshipIds,
    required this.vehicleIds,
    required this.speciesIds,
  }) : super(id);

  factory Film.fromJson(Json json) {
    return Film._(
      id: extractIdFromUrl(json['url']),
      episode: json['episode_id'],
      title: json['title'],
      openingCrawl: json['opening_crawl'],
      director: json['director'],
      producer: json['producer'],
      releaseDate: DateTime.parse(json['release_date']),
      characterIds: json['characters'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      planetIds: json['planets'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      speciesIds: json['species'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      starshipIds: json['starships'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      vehicleIds: json['vehicles'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Starship extends StarWarsDbEntry {
  final String name;
  final String model;
  final String manufacturer;
  final double? hyperdriveRating;
  final String crew;
  final String passengers;
  final double length;
  final int? cost;

  final List<int> filmIds;
  final List<int> pilotIds;

  @override
  String get displayName => name;

  Starship._({
    required id,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.hyperdriveRating,
    required this.crew,
    required this.passengers,
    required this.length,
    required this.cost,
    required this.filmIds,
    required this.pilotIds,
  }) : super(id);

  factory Starship.fromJson(Json json) {
    return Starship._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      hyperdriveRating: double.tryParse(json['hyperdrive_rating']),
      crew: json['crew'],
      passengers: json['passengers'],
      length: double.parse(json['length'].replaceAll(',', '')),
      cost: int.tryParse(json['cost_in_credits']),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      pilotIds: json['pilots'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Vehicle extends StarWarsDbEntry {
  final String name;
  final String model;
  final String manufacturer;
  final int? crew;
  final int? passengers;
  final double? length;
  final int? cost;

  final List<int> filmIds;
  final List<int> pilotIds;

  @override
  String get displayName => name;

  Vehicle._({
    required id,
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.crew,
    required this.passengers,
    required this.length,
    required this.cost,
    required this.filmIds,
    required this.pilotIds,
  }) : super(id);

  factory Vehicle.fromJson(Json json) {
    return Vehicle._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      crew: int.tryParse(json['crew']),
      passengers: int.tryParse(json['passengers']),
      length: double.tryParse(json['length']),
      cost: int.tryParse(json['cost_in_credits']),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      pilotIds: json['pilots'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Species extends StarWarsDbEntry {
  final String name;
  final String classification;
  final List<String> skinColors;
  final List<String> hairColors;
  final List<String> eyeColors;
  final String lifespan;
  final String language;

  final int? homeworldId;
  final List<int> peopleIds;
  final List<int> filmIds;

  @override
  String get displayName => name;

  Species._({
    required id,
    required this.name,
    required this.classification,
    required this.skinColors,
    required this.hairColors,
    required this.eyeColors,
    required this.lifespan,
    required this.language,
    required this.homeworldId,
    required this.peopleIds,
    required this.filmIds,
  }) : super(id);

  factory Species.fromJson(Json json) {
    return Species._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      classification: json['classification'],
      skinColors: json['skin_colors'].split(', '),
      hairColors: json['hair_colors'].split(', '),
      eyeColors: json['eye_colors'].split(', '),
      lifespan: json['average_lifespan'],
      language: json['language'],
      homeworldId: extractIdFromUrl(json['homeworld']),
      peopleIds: json['people'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Planet extends StarWarsDbEntry {
  final String name;
  final int? rotationPeriod;
  final int? orbitalPeriod;
  final String climate;
  final String gravity;
  final String terrain;
  final int? population;
  final int? diameter;

  final List<int> residentIds;
  final List<int> filmIds;

  @override
  String get displayName => name;

  Planet._({
    required id,
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.population,
    required this.diameter,
    required this.residentIds,
    required this.filmIds,
  }) : super(id);

  factory Planet.fromJson(Json json) {
    return Planet._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      rotationPeriod: int.tryParse(json['rotation_period']),
      orbitalPeriod: int.tryParse(json['orbital_period']),
      climate: json['climate'],
      gravity: json['gravity'],
      terrain: json['terrain'],
      population: int.tryParse(json['population']),
      diameter: int.tryParse(json['diameter']),
      residentIds: json['residents'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}
