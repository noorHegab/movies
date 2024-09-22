import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/models/hive_opject.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

Widget buildUpcoming() => Consumer<MainProvider>(
      builder: (context, provider, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        var data = provider.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: screenHeight * 0.25,
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
                      "New Releases",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: data.isEmpty
                        ? const Center(child: Text('No upcoming releases'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final upcoming = data[index];
                              final isFavorite =
                                  provider.isFavorite(upcoming.id ?? 0);

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(
                                      context,
                                      MovieDetailsScreen(
                                          movieId: upcoming.id ?? 0),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.grey[800],
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/original${upcoming.posterPath ?? ''}",
                                          height: screenHeight * 0.28,
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
                                              color: isFavorite
                                                  ? Colors.yellow
                                                  : Colors.grey[600],
                                              child: const Icon(
                                                Icons.add,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              provider.toggleFavorite(Movie(
                                                id: upcoming.id ?? 0,
                                                title:
                                                    upcoming.title ?? 'Unknown',
                                                posterPath:
                                                    upcoming.posterPath ?? '',
                                                overview:
                                                    upcoming.overview ?? '',
                                              ));
                                            },
                                          ),
                                        ),
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
