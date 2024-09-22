import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

Widget buildPopular() =>
    Consumer<MainProvider>(builder: (context, provider, child) {
      final provider = Provider.of<MainProvider>(context, listen: false);
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      var results = provider.results;

      return Container(
        height: screenHeight * 0.31,
        child: CarouselSlider.builder(
          itemCount: results.length,
          itemBuilder: (context, index, realIndex) {
            if (results.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final result = results[index];

            return InkWell(
              onTap: () {
                navigateTo(
                  context,
                  MovieDetailsScreen(
                    movieId: result.id ?? 0,
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // صورة الخلفية (Backdrop)
                  CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/original${result.backdropPath}",
                    height: screenHeight *
                        0.25, // زيادة الارتفاع لضمان ظهور الصورة بالكامل
                    width: double.infinity,
                    fit: BoxFit.cover, // استخدم BoxFit.cover مع ارتفاع أكبر
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/monitor-1350918_640.webp',
                      fit: BoxFit.cover, // ضمان ظهور الصورة الافتراضية بالكامل
                      width: double.infinity,
                    ),
                  ),

                  // صورة البوستر (Poster)
                  Positioned(
                    top: screenHeight * 0.11,
                    left: screenWidth * 0.05,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original${result.posterPath}",
                        height: screenHeight * 0.19,
                        width: screenWidth * 0.27,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/monitor-1350918_640.webp',
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.27,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // أيقونة الإضافة (Add Icon)
                  Positioned(
                    top: screenHeight * 0.11,
                    left: screenWidth * 0.05,
                    child: InkWell(
                      onTap: () {},
                      child: ClipPath(
                        clipper: NotchClipper(),
                        child: Container(
                          height: screenHeight * 0.038,
                          width: screenWidth * 0.047,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.black54,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // عنوان الفيلم وتاريخ الإصدار
                  Positioned(
                    top: screenHeight * 0.25,
                    left: screenWidth * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title ?? "Dora and the lost city of gold",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          result.releaseDate ?? '2019  PG-13  2h 7m',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ),
        ),
      );
    });
