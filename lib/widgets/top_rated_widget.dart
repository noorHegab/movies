import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

Widget buildTopRated() => Consumer<MainProvider>(
      builder: (context, provider, child) {
        // Add scroll listener only once
        if (!provider.scrollController.hasListeners) {
          provider.scrollController.addListener(provider.scrollListener);
        }

        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        var topRated = provider.topRated;

        // Show loading indicator if no top-rated movies have been loaded yet
        if (topRated.isEmpty && provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: screenHeight * 0.32,
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
                      "Recommended",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: provider.scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.isLoading
                          ? topRated.length + 1 // Show extra space for loader
                          : topRated.length,
                      itemBuilder: (context, index) {
                        // Show CircularProgressIndicator at the end of the list if still loading
                        if (index == topRated.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final topRate = topRated[index];
                        final isWatched = provider.isWatched(topRate.id ?? 0);

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
                                    navigateTo(
                                      context,
                                      MovieDetailsScreen(
                                          movieId: topRate.id ?? 0),
                                    );
                                  },
                                  child: Stack(
                                    children: [
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
                                              "https://image.tmdb.org/t/p/original${topRate.backdropPath ?? ''}",
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
                                          child: InkWell(
                                            child: Container(
                                              height: screenHeight * 0.03,
                                              width: screenWidth * 0.04,
                                              color: isWatched
                                                  ? Colors.yellow
                                                  : Colors.grey[600],
                                              child: const Icon(
                                                Icons.add,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              provider.toggleWatched(
                                                  topRate.id ?? 0);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/Group 16.png",
                                      height: 5.0,
                                      width: 5.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      topRate.voteAverage?.toStringAsFixed(1) ??
                                          "N/A",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  topRate.title ?? "No Title",
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  topRate.releaseDate ?? "No Date",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
