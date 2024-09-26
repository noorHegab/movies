import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie_list_model.dart';
import '../models/movie_model.dart';

class MovieService {
  static const String apiKey = "4c16feb230d8ae3e1a6227c1ec47af40";

  // جلب قائمة التصنيفات (genres)
  Future<List<Genres>> getGenres() async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieListModel movieListModel = MovieListModel.fromJson(json);
        return movieListModel.genres ?? [];
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (error) {
      print("Error fetching genres: $error");
      throw error;
    }
  }

  // جلب الأفلام حسب التصنيف
  Future<List<ResultsMovie>> getMoviesWithCategory(int genreId,
      {int page = 1}) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId&page=$page");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieModel movieModel = MovieModel.fromJson(json);
        return movieModel.results ?? [];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print("Error fetching movies: $error");
      throw error;
    }
  }
}
