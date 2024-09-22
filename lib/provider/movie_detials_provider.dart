import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie_watch_model.dart';
import 'package:movies/servies/api_manager.dart';

import '../models/movie_model.dart';
import '../models/similar_movies_model.dart';

class MovieDetailsProvider extends ChangeNotifier {
  final DataService dataService = DataService();
  MovieWatched? movieWatched;
  ResultsMovie? movieDetails;
  List<Results> results = [];

  static const String apiKey = "4c16feb230d8ae3e1a6227c1ec47af40";

  // Function to fetch details of a specific movie by its ID
  Future<void> getMovieDetails(int movieId) async {
    if (movieDetails != null && movieDetails!.id == movieId) {
      // إذا كانت التفاصيل موجودة بالفعل لنفس الفيلم، لا تقم بجلب البيانات مرة أخرى
      return;
    }

    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey");

      http.Response response = await http.get(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        movieDetails = ResultsMovie.fromJson(json);
        print("movieId : $movieId");
        notifyListeners();
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      print("Error fetching movie details: $error");
    }
  }

  // Function to fetch similar movies
  Future<void> getSimilarMovies(int movieId) async {
    if (results.isNotEmpty) {
      // إذا كانت الأفلام المشابهة موجودة بالفعل، لا تقم بجلب البيانات مرة أخرى
      return;
    }

    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey");

      http.Response response = await http.get(url);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        SimilarMovies similarMovies = SimilarMovies.fromJson(json);
        results = similarMovies.results ?? [];
        notifyListeners();
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (error) {
      print("Error fetching similar movies: $error");
    }
  }

  // Method to get the YouTube video key
  // String? getYouTubeVideoKey() {
  //   return dataService.movieWatched?.results?.isNotEmpty == true
  //       ? dataService.movieWatched!.results!.first.key
  //       : null;
  // }

  Future<void> getMovieWatch(int movieId) async {
    try {
      // تأكد أن getMovieToWatch ترجع MovieWatched
      movieWatched = await dataService.getMovieToWatch(movieId);

      if (movieWatched?.key == null) {
        print("key is null");
      }
      notifyListeners();
    } catch (error) {
      print("Error in getMovieWatch: $error");
    }
  }

  @override
  void dispose() {
    movieWatched = null;
    movieDetails = null;
    results = [];
    super.dispose(); // تأكد من استدعاء super.dispose()
  }
}
