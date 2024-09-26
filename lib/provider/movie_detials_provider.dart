import 'package:flutter/material.dart';
import 'package:movies/models/movie_details_model.dart';
import 'package:movies/models/movie_watch_model.dart';
import 'package:movies/servies/movie_details_servies.dart';

import '../models/similar_movies_model.dart';

class MovieDetailsProvider extends ChangeNotifier {
  final MovieDetailsServies movieDetailsServies =
      MovieDetailsServies(); // استخدام MovieService
  MovieWatched? movieWatched;
  // ResultsMovie? movieDetails;
  List<Results> results = [];

  MovieDetailsModel? _movieDetails;
  bool _isLoading = false;
  String _errorMessage = '';

  MovieDetailsModel? get movieDetails => _movieDetails;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchMovieDetails(int movieId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _movieDetails = await movieDetailsServies.getMoviesDetails(movieId);
    } catch (error) {
      _errorMessage = "Error fetching movie details: $error";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSimilarMovies(int movieId) async {
    if (results.isNotEmpty) {
      // إذا كانت الأفلام المشابهة موجودة بالفعل، لا تقم بجلب البيانات مرة أخرى
      return;
    }

    try {
      results = await movieDetailsServies.getSimilarMovies(movieId);
      notifyListeners();
    } catch (error) {
      print("Error fetching similar movies: $error");
    }
  }

  Future<void> getMovieWatch(int movieId) async {
    try {
      movieWatched = await movieDetailsServies.getMovieToWatch(movieId);
      notifyListeners();
    } catch (error) {
      print("Error in getMovieWatch: $error");
    }
  }

  @override
  void dispose() {
    movieWatched = null;
    // movieDetails = null;
    results = [];
    super.dispose();
  }
}
