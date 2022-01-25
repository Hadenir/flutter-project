import 'package:dio/dio.dart';
import 'package:flutter_project/data/starwars_entries.dart';

typedef Json = Map<String, dynamic>;

class StarWarsDbDataSource<T extends StarWarsDbEntry> {
  final _baseUrl = 'https://swapi.dev/api';
  var _nextPageUrl = '';

  final String entryName;
  T Function(Json) fromJson;

  StarWarsDbDataSource(this.entryName, this.fromJson);

  Future<List<T>?> getEntries() async {
    Response<Json> response = await Dio().get(_baseUrl + '/' + entryName);

    if (response.statusCode == 200) {
      _nextPageUrl = response.data!['next'];
      return response.data!['results'].map((x) => fromJson(x)).cast<T>().toList();
    } else {
      return null;
    }
  }

  Future<List<T>?> getEntriesNextPage() async {
    Response<Json> response = await Dio().get(_nextPageUrl);

    if (response.statusCode == 200) {
      _nextPageUrl = response.data!['next'];
      return response.data!['results'].map((x) => fromJson(x)).cast<T>().toList();
    } else {
      return null;
    }
  }

  Future<T?> getSingleEntry(int id) async {
    Response<Json> response = await Dio().get(_baseUrl + '/' + entryName + '/' + id.toString());

    if (response.statusCode == 200) {
      return fromJson(response.data!);
    } else {
      return null;
    }
  }
}
