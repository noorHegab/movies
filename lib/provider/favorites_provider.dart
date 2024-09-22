// import 'package:flutter/material.dart';
//
// class FavoritesProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   _firestore.settings = Settings(persistenceEnabled: true);
//   List<Movie> _favorites = [];
//
//   List<Movie> get favorites => _favorites;
//
//   Future<void> loadFavorites() async {
//     final favoritesRef = _firestore.collection('favorites');
//     final querySnapshot = await favoritesRef.get();
//
//     _favorites = querySnapshot.docs.map((doc) => Movie.fromJson(doc.data())).toList();
//     notifyListeners();
//   }
//
//   Future<void> addFavorite(Movie movie) async {
//     final favoritesRef = _firestore.collection('favorites');
//     await favoritesRef.doc(movie.id).set(movie.toJson());
//     _favorites.add(movie);
//     notifyListeners();
//   }
//
//   Future<void> removeFavorite(String movieId) async {
//     final favoritesRef = _firestore.collection('favorites');
//     await favoritesRef.doc(movieId).delete();
//     _favorites.removeWhere((movie) => movie.id == movieId);
//     notifyListeners();
//   }
// }
