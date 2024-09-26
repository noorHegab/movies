import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/search_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Results> results = [];
  String lastQuery = '';

  Future<void> getSearch(String query) async {
    if (query.isEmpty || query == lastQuery) return;

    results = [];
    lastQuery = query;

    try {
      Uri url = Uri.parse(
          "https://api.themoviedb.org/3/search/movie?api_key=4c16feb230d8ae3e1a6227c1ec47af40&query=$query");

      final http.Response response = await http.get(url);

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['results'] != null && json['results'].isNotEmpty) {
          final SearchModel searchModel = SearchModel.fromJson(json);
          results = searchModel.results ?? [];
        } else {
          results = [];
          print("No results found for query: $query");
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error occurred: $error");
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    results = [];
    lastQuery = '';
    super.dispose();
  }
}
