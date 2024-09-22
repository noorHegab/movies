import 'package:flutter/material.dart';
import 'package:movies/widgets/build_movie_details.dart';
import 'package:provider/provider.dart';

import '../provider/movie_detials_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsProvider()
        ..getMovieDetails(movieId)
        ..getSimilarMovies(movieId),
      child: buildMovieDetails(),
    );
  }
}
