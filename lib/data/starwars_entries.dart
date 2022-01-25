import 'package:flutter_project/data/starwars_data_source.dart';

int extractIdFromUrl(String url) {
  var uri = Uri.parse(url);
  return int.parse(uri.pathSegments[2]);
}

abstract class StarWarsDbEntry {}

class Person extends StarWarsDbEntry {
  final int id;
  final String name;
  final String birthYear;
  final String gender;
  final int height;
  final int mass;

  final int homeworldId;
  final List<int> speciesIds;
  final List<int> starshipIds;
  final List<int> vehicleIds;
  final List<int> filmIds;

  Person._({
    required this.id,
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
  });

  factory Person.fromJson(Json json) {
    return Person._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      birthYear: json['birth_year'],
      gender: json['gender'],
      height: int.parse(json['height']),
      mass: int.parse(json['mass']),
      homeworldId: extractIdFromUrl(json['homeworld']),
      speciesIds: json['species'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      starshipIds: json['starships'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      vehicleIds: json['vehicles'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Film extends StarWarsDbEntry {
  final int id;
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

  Film._({
    required this.id,
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
  });

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
  final int id;
  final String name;
  final String model;
  final String manufacturer;
  final double hyperdriveRating;
  final int crew;
  final int passengers;
  final double length;
  final int cost;

  final List<int> filmIds;
  final List<int> pilotIds;

  Starship._({
    required this.id,
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
  });

  factory Starship.fromJson(Json json) {
    return Starship._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      hyperdriveRating: double.parse(json['hyperdrive_dating']),
      crew: int.parse(json['crew']),
      passengers: int.parse(json['passengers']),
      length: double.parse(json['length']),
      cost: int.parse(json['cost']),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      pilotIds: json['pilots'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Vehicle extends StarWarsDbEntry {
  final int id;
  final String name;
  final String model;
  final String manufacturer;
  final double hyperdriveRating;
  final int crew;
  final int passengers;
  final double length;
  final int cost;

  final List<int> filmIds;
  final List<int> pilotIds;

  Vehicle._({
    required this.id,
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
  });

  factory Vehicle.fromJson(Json json) {
    return Vehicle._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      hyperdriveRating: double.parse(json['hyperdrive_dating']),
      crew: int.parse(json['crew']),
      passengers: int.parse(json['passengers']),
      length: double.parse(json['length']),
      cost: int.parse(json['cost']),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      pilotIds: json['pilots'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Species extends StarWarsDbEntry {
  final int id;
  final String name;
  final String classification;
  final List<String> skinColors;
  final List<String> hairColors;
  final List<String> eyeColors;
  final int lifespan;
  final String language;

  final int homeworldId;
  final List<int> peopleIds;
  final List<int> filmIds;

  Species._({
    required this.id,
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
  });

  factory Species.fromJson(Json json) {
    return Species._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      classification: json['classification'],
      skinColors: json['skin_colors'].split(', '),
      hairColors: json['hair_colors'].split(', '),
      eyeColors: json['eye_colors'].split(', '),
      lifespan: int.parse(json['average_lifespan']),
      language: json['language'],
      homeworldId: extractIdFromUrl(json['homeworld']),
      peopleIds: json['people'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}

class Planet extends StarWarsDbEntry {
  final int id;
  final String name;
  final int rotationPeriod;
  final int orbitalPeriod;
  final String climate;
  final String gravity;
  final String terrain;
  final int population;
  final int diameter;

  final List<int> residentIds;
  final List<int> filmIds;

  Planet._({
    required this.id,
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
  });

  factory Planet.fromJson(Json json) {
    return Planet._(
      id: extractIdFromUrl(json['url']),
      name: json['name'],
      rotationPeriod: int.parse(json['rotation_period']),
      orbitalPeriod: int.parse(json['orbital_period']),
      climate: json['climate'],
      gravity: json['gravity'],
      terrain: json['terrain'],
      population: int.parse(json['population']),
      diameter: int.parse(json['diameter']),
      residentIds: json['residents'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
      filmIds: json['films'].map((x) => extractIdFromUrl(x)).cast<int>().toList(),
    );
  }
}
