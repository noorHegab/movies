import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/Movie_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

class MoviesWithCategory extends StatelessWidget {
  final int id;
  MoviesWithCategory({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MovieProvider()..getMoviesWithCategory(id),
        child: Consumer<MovieProvider>(builder: (context, provider, child) {
          final provider = Provider.of<MovieProvider>(context, listen: false);

          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          var results = provider.results;

          if (results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                var result = results[index];
                return InkWell(
                  onTap: () {
                    navigateTo(
                        context, MovieDetailsScreen(movieId: result.id ?? 0));
                  },
                  child: Card(
                    shadowColor: Colors.white,
                    elevation: 5,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/original${result.backdropPath}",
                              height: screenHeight * 0.3,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/monitor-1350918_640.webp',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(result.title ?? "No Title",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 5.0),
                          Text(
                            result.overview ?? "No Description",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                result.releaseDate?.substring(0, 10) ?? "",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }));
  }
}
