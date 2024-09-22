import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/movie_list_model.dart';
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  List<Genres> genres = [];
  List<ResultsMovie> results = [];
  int selectedIndex = 0;
  String selectedGenreName = '';
  static const String apiKey = "4c16feb230d8ae3e1a6227c1ec47af40";

  // Get the list of genres
  Future<void> getMoviesList() async {
    // Avoid fetching if genres are already available
    if (genres.isNotEmpty) return;

    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey");

      http.Response response = await http.get(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieListModel movieListModel = MovieListModel.fromJson(json);
        genres = movieListModel.genres ?? [];

        // Set the first genre as default
        if (genres.isNotEmpty) {
          selectedGenreName = genres[0].name ?? '';
          // Fetch movies for the default genre
          // getMoviesWithCategory(genres[0].id ?? 0);
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (error) {
      print("Error fetching genres: $error");
    }
  }

  void changeTab(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
      // Fetch movies based on the new selected genre
      getMoviesWithCategory(genres[index].id ?? 0);
    }
  }

  Future<void> getMoviesWithCategory(int genreId) async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId");

      http.Response response = await http.get(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieModel movieModel = MovieModel.fromJson(json);
        results = movieModel.results ?? [];
        notifyListeners();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print("Error fetching movies: $error");
    }
  }

  @override
  void dispose() {
    genres = [];
    results = [];
    selectedGenreName = '';
    selectedIndex = 0;
    super.dispose();
  }
}

// Get the list of movies
// Future<void> getMovies() async {
//   // تجنب الجلب المتكرر إذا كانت الأفلام موجودة بالفعل
//   if (results.isNotEmpty) return;
//
//   try {
//     Uri url = Uri.parse(
//         "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey");
//
//     http.Response response = await http.get(url);
//
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       MovieModel movieModel = MovieModel.fromJson(json);
//       results = movieModel.results ?? [];
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   } catch (error) {
//     print("Error fetching movies: $error");
//   }
// }

// Change the selected tab and update genre name
