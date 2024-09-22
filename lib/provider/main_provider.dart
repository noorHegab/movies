import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movies/models/hive_opject.dart';
import 'package:movies/models/movie_watch_model.dart';
import 'package:movies/screens/browse_screen.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/search_screen.dart';
import 'package:movies/screens/watch_list_screen.dart';
import 'package:movies/servies/api_manager.dart';

import '../models/movie_model.dart';
import '../models/popular_model.dart';
import '../models/top_rated_model.dart';
import '../models/upcoming_model.dart';

class MainProvider extends ChangeNotifier {
  int selectedIndex = 0;
  PageController pageController = PageController();
  final scrollController = ScrollController();
  Map<int, bool> watchedMovies = {};
  final DataService dataService = DataService();
  late Box<Movie> favoritesBox;

  List<Movie> favorites = [];

  MainProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    favoritesBox = await Hive.openBox<Movie>('favoritesBox');
    loadFavorites();
  }

  void toggleWatched(int movieId) {
    watchedMovies[movieId] = !(watchedMovies[movieId] ?? false);
    notifyListeners();
  }

  bool isWatched(int movieId) {
    return watchedMovies[movieId] ?? false;
  }

  void loadFavorites() {
    favorites = favoritesBox.values.toList();
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    if (favoritesBox.containsKey(movie.id)) {
      favoritesBox.delete(movie.id);
      favorites.remove(movie); // تحسين الأداء
    } else {
      favoritesBox.put(movie.id, movie);
      favorites.add(movie);
    }
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return favorites.any((movie) => movie.id == movieId);
  }

  List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const BrowseScreen(),
    FavoritesScreen(), // تأكد من استيراد هذا بشكل صحيح
  ];

  List<String> title = [
    "HOME",
    "SEARCH",
    "BROWSE",
    "WATCHLIST",
  ];

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<Results> results = [];
  List<ResultsMovie> movieDetails = [];
  List<MovieWatched> movieWatched = [];
  List<Data> data = [];
  List<Toprated> topRated = [];
  int page = 1;
  bool isLoading = false;

  Future<void> getPopular() async {
    if (results.isNotEmpty) return;
    try {
      results = await dataService.getPopular();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getUpcoming() async {
    if (data.isNotEmpty) return;
    try {
      data = await dataService.getUpcoming();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getTopRated() async {
    try {
      List<Toprated> newTopRated = await dataService.getTopRated(page);
      topRated.addAll(newTopRated);
      notifyListeners();
    } catch (error) {
      print("Error fetching top-rated movies: $error");
    }
  }

  Future<void> getMovieDetails(int movieId) async {
    try {
      movieDetails = await dataService.getMovieDetails(movieId);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> scrollListener() async {
    if (isLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      page += 1;
      await getTopRated();
      print("page num: $page");
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    results.clear(); // مسح القوائم عند التخلص
    movieDetails.clear();
    data.clear();
    topRated.clear();
    super.dispose();
  }
}
