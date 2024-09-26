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
      child: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final provider = Provider.of<MovieProvider>(context, listen: false);

          double screenWidth = MediaQuery.of(context).size.width;
          var results = provider.results;

          if (results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Check if the user has scrolled to the bottom
                if (!provider.isLoadingMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  provider.loadMoreMovies(id);
                }
                return false; // Return false to allow other listeners to act
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: results.length +
                    (provider.isLoadingMore
                        ? 1
                        : 0), // Show loading indicator if loading more
                itemBuilder: (context, index) {
                  // Show a loading indicator at the end of the list when fetching more data
                  if (index == results.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var result = results[index];
                  return InkWell(
                    onTap: () {
                      navigateTo(
                          context, MovieDetailsScreen(movieId: result.id ?? 0));
                    },
                    child: Card(
                      shadowColor: Colors.white,
                      elevation: 10, // Increased elevation for depth effect
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.tmdb.org/t/p/original${result.backdropPath}",
                                height: screenWidth *
                                    0.4, // Adjust height to width ratio
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/monitor-1350918_640.webp',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              result.title ?? "No Title",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // Increased font size
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              result.overview ?? "No Description",
                              style: TextStyle(
                                  color: Colors
                                      .white70), // Slightly lighter color for description
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  result.releaseDate?.substring(0, 10) ?? "",
                                  style: TextStyle(color: Colors.white54),
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
            ),
          );
        },
      ),
    );
  }
}
