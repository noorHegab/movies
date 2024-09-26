import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/models/movie_details_model.dart';

import '../models/movie_model.dart';
import '../models/movie_watch_model.dart';
import '../models/similar_movies_model.dart';

class MovieDetailsServies {
  static const String apiKey = "4c16feb230d8ae3e1a6227c1ec47af40";

  // جلب تفاصيل الفيلم حسب معرف الفيلم
  Future<ResultsMovie> getMovieDetails(int movieId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return ResultsMovie.fromJson(json);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      print("Error fetching movie details: $error");
      throw error;
    }
  }

  // جلب الأفلام المشابهة
  Future<List<Results>> getSimilarMovies(int movieId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        SimilarMovies similarMovies = SimilarMovies.fromJson(json);
        return similarMovies.results ?? [];
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (error) {
      print("Error fetching similar movies: $error");
      throw error;
    }
  }

  Future<MovieDetailsModel> getMoviesDetails(int movieId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieDetailsModel movieDetailsModel = MovieDetailsModel.fromJson(json);
        return movieDetailsModel; // Return the movie details model directly
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      print("Error fetching movie details: $error");
      throw error;
    }
  }

  // جلب رابط مشاهدة الفيلم
  MovieWatched? movieWatched;

  Future<MovieWatched> getMovieToWatch(int movieId) async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        // تحقق مما إذا كانت هناك نتائج
        if (json['results'] != null && json['results'].isNotEmpty) {
          // احصل على أول نتيجة
          return MovieWatched.fromJson(json['results'][0]); // إرجاع أول عنصر
        } else {
          throw Exception('No video available');
        }
      } else {
        throw Exception('Failed to load movie videos');
      }
    } catch (error) {
      print("Error fetching movie video: $error");
      throw error; // أعد رمي الخطأ ليتسنى التعامل معه في getMovieWatch
    }
  }
}
