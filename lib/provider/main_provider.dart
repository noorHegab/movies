import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movies/models/hive_opject.dart';
import 'package:movies/models/movie_watch_model.dart';
import 'package:movies/models/top_rated_model.dart';
import 'package:movies/models/upcoming_model.dart';
import 'package:movies/screens/browse_screen.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/search_screen.dart';
import 'package:movies/screens/watch_list_screen.dart';
import 'package:movies/servies/api_manager.dart';
import 'package:movies/servies/search_servies.dart';

import '../models/movie_model.dart';
import '../models/popular_model.dart';
import '../models/search_model.dart';

class MainProvider extends ChangeNotifier {
  int selectedIndex = 0;
  PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();
  final scrollController1 = ScrollController();
  Map<int, bool> watchedMovies = {};
  final DataService dataService = DataService();
  late Box<Movie> favoritesBox;
  SearchModel? searchResult;
  TextEditingController controller = TextEditingController();
  final SearchApiManager searchApiManager = SearchApiManager();

  List<Movie> favorites = [];
  bool isConnected = true; // Internet connection status
  bool isLoading = false;

  List<ResultPopular> results = [];
  List<ResultsMovie> movieDetails = [];
  List<MovieWatched> movieWatched = [];
  List<Data> data = [];
  List<Toprated> topRated = [];
  int pageTopRated = 1;
  int pageUpcoming = 1;

  MainProvider() {
    _initialize();
    checkInternet();
  }

  Future<void> checkInternet() async {
    isLoading = true;
    notifyListeners();

    isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      print('Device is connected to the internet');
    } else {
      print('Device is not connected to the internet');
    }

    isLoading = false;
    notifyListeners();
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

  void updateSearch() {
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    if (favoritesBox.containsKey(movie.id)) {
      favoritesBox.delete(movie.id);
      favorites.remove(movie);
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
    SearchTab(),
    const BrowseScreen(),
    const FavoritesScreen(), // Ensure this is imported correctly
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
      List<Data> newData = await dataService.getUpcoming(pageUpcoming);
      data.addAll(newData);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getTopRated() async {
    try {
      List<Toprated> newTopRated = await dataService.getTopRated(pageTopRated);
      topRated.addAll(newTopRated);
      notifyListeners();
    } catch (error) {
      print("Error fetching top-rated movies: $error");
    }
  }

  Future<void> getMovieDetails(int movieId) async {
    await checkInternet();
    if (!isConnected) return;
    try {
      movieDetails = await dataService.getMovieDetails(movieId);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> scrollListenerTopRated() async {
    if (isLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      pageTopRated += 1;
      await getTopRated();
      print("page num: $pageTopRated");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> scrollListenerUpcoming() async {
    // Check if already loading to prevent multiple calls
    if (isLoading) return;

    // Check if scrolled to the bottom
    if (scrollController1.position.pixels >=
        scrollController1.position.maxScrollExtent - 100) {
      // Add a buffer for triggering earlier
      isLoading = true;
      notifyListeners();

      // Small delay to simulate network call
      await Future.delayed(const Duration(seconds: 2));

      // Increment the page number and fetch new data
      pageUpcoming += 1;
      await getUpcoming();

      print("Fetching page number: $pageUpcoming");

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> performSearch(String query) async {
    isLoading = true;
    notifyListeners();

    try {
      searchResult = await searchApiManager.getSearchData(query);
    } catch (e) {
      searchResult = null;
      print("Error occurred during search: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print("Disposing MainProvider");
    pageController.dispose();
    scrollController.dispose();
    scrollController1.dispose();
    results.clear(); // Clear lists on dispose
    movieDetails.clear();
    data.clear();
    topRated.clear();
    super.dispose();
  }
}
