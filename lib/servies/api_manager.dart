import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/models/movie_watch_model.dart';

import '../models/movie_model.dart';
import '../models/popular_model.dart';
import '../models/top_rated_model.dart';
import '../models/upcoming_model.dart';

class DataService {
  List<Toprated> topRated = [];
  static const String apiKey = "4c16feb230d8ae3e1a6227c1ec47af40";

  // جلب الأفلام الشائعة
  Future<List<Results>> getPopular() async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        PopularModel popularModel = PopularModel.fromJson(json);
        return popularModel.results ?? [];
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (error) {
      throw Exception('Error fetching popular movies: $error');
    }
  }

  // جلب الأفلام القادمة
  Future<List<Data>> getUpcoming() async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        UpcomingModel upcomingModel = UpcomingModel.fromJson(json);
        return upcomingModel.data ?? [];
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (error) {
      throw Exception('Error fetching upcoming movies: $error');
    }
  }

  // جلب الأفلام الأعلى تقييمًا
  Future<List<Toprated>> getTopRated(int page) async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&page=$page");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        TopRatedModel topRatedModel = TopRatedModel.fromJson(json);

        // دمج البيانات الجديدة مع القديمة مع التحقق من null
        if (topRatedModel.toprated != null) {
          topRated = topRated + topRatedModel.toprated!;
        }
        return topRated; // إرجاع القائمة المدمجة
      } else {
        throw Exception('Failed to load top-rated movies');
      }
    } catch (error) {
      throw Exception('Error fetching top-rated movies: $error');
    }
  }

  // جلب تفاصيل فيلم معين
  Future<List<ResultsMovie>> getMovieDetails(int movieId) async {
    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey");
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        MovieModel movieModel = MovieModel.fromJson(json);
        return movieModel.results ?? [];
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      throw Exception('Error fetching movie details: $error');
    }
  }

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
