import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/movie_detials_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

Widget buildSimilar() =>
    Consumer<MovieDetailsProvider>(builder: (context, provider, child) {
      final provider =
          Provider.of<MovieDetailsProvider>(context, listen: false);
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      var similarMovies = provider.results;
      if (similarMovies.isEmpty) {
        return const Center(
            child: Text(
          "No similar movies",
          style: TextStyle(color: Colors.white),
        ));
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: screenHeight * 0.37,
          width: double.infinity,
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Similar Movies",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: similarMovies.length,
                      itemBuilder: (context, index) {
                        if (similarMovies.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final similarMovie = similarMovies[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            height: screenHeight * 0.23,
                            width: screenWidth * 0.27,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // provider.results = [];
                                    // provider.data = [];
                                    // provider.topRated = [];
                                    navigateTo(
                                      context,
                                      MovieDetailsScreen(
                                          movieId: similarMovie.id ?? 0),
                                    );
                                  },
                                  child: Stack(children: [
                                    Container(
                                      height: screenHeight * 0.20,
                                      width: screenWidth * 0.27,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[800],
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/original${similarMovie.backdropPath ?? ''}",
                                        height: screenHeight * 0.17,
                                        width: screenWidth * 0.27,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/monitor-1350918_640.webp',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      right: screenWidth * 0.23,
                                      child: ClipPath(
                                        clipper: NotchClipper(),
                                        child: Container(
                                          height: screenHeight * 0.03,
                                          width: screenWidth * 0.04,
                                          color: Colors.grey[600],
                                          child: const Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                // SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/Group 16.png",
                                      height: 5.0,
                                      width: 5.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      similarMovie.voteAverage
                                              ?.toStringAsFixed(1) ??
                                          "N/A",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 4.0),
                                Text(
                                  similarMovie.title ?? "No Title",
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  similarMovie.releaseDate ?? "No Date",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
