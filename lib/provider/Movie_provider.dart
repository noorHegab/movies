import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movies/servies/movie_servies.dart';

import '../models/movie_list_model.dart';
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  List<Genres> genres = [];
  List<ResultsMovie> results = [];
  int selectedIndex = 0;
  String selectedGenreName = '';
  final MovieService _movieService = MovieService();
  bool isConnected = true;
  bool _isDisposed = false;

  MovieProvider() {
    checkInternet();
    getMoviesList(); // Automatically fetch genres when the provider is created
  }

  Future<void> checkInternet() async {
    if (_isDisposed) return; // Check for disposal state
    isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      print('Device is connected to the internet');
    } else {
      print('Device is not connected to the internet');
    }
    if (!_isDisposed) notifyListeners(); // Notify listeners if not disposed
  }

  Future<void> getMoviesList() async {
    if (genres.isNotEmpty || _isDisposed) return;

    try {
      genres = await _movieService.getGenres();
      if (genres.isNotEmpty) {
        selectedGenreName = genres[0].name ?? '';
      }
      notifyListeners();
    } catch (error) {
      print("Error fetching genres: $error");
    }
  }

  void changeTab(int index) {
    if (index != selectedIndex) {
      selectedIndex = index;
      notifyListeners();
      getMoviesWithCategory(
          genres[index].id ?? 0); // Fetch movies for the selected genre
    }
  }

  int _currentPage = 1;

  Future<void> getMoviesWithCategory(int genreId, {int page = 1}) async {
    if (_isDisposed) return; // Check for disposal state

    try {
      // Get movies based on genre and page number
      List<ResultsMovie> newMovies =
          await _movieService.getMoviesWithCategory(genreId, page: page);
      if (newMovies.isNotEmpty) {
        results.addAll(newMovies); // Append new movies to the existing list
        _currentPage = page; // Update current page
      }
    } catch (error) {
      print("Error fetching movies: $error");
    }
  }

  bool isLoadingMore = false;

  Future<void> loadMoreMovies(int genreId) async {
    if (isLoadingMore) return; // Prevent multiple calls
    isLoadingMore = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    await getMoviesWithCategory(genreId,
        page: _currentPage + 1); // Load next page
    isLoadingMore = false; // Set to false after loading
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    genres.clear(); // Clear the genres list
    results.clear(); // Clear the results list
    selectedGenreName = '';
    selectedIndex = 0;
    super.dispose();
  }
}
