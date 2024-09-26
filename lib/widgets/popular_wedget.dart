import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:movies/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

import '../models/hive_opject.dart';

Widget buildPopular() =>
    Consumer<MainProvider>(builder: (context, provider, child) {
      final provider = Provider.of<MainProvider>(context, listen: false);
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      var results = provider.results;

      return SizedBox(
        height: screenHeight * 0.38, // زيادة الارتفاع قليلاً لتحسين التصميم
        child: CarouselSlider.builder(
          itemCount: results.length,
          itemBuilder: (context, index, realIndex) {
            if (results.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final result = results[index];
            final isFavorite = provider.isFavorite(result.id ?? 0);

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
                  // خلفية الفيلم بتدرج لوني
                  CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/original${result.backdropPath}",
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/monitor-1350918_640.webp',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    // إضافة تدرج لوني
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  // صورة البوستر مع ظل
                  Positioned(
                    top: screenHeight * 0.11,
                    left: screenWidth * 0.05,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/w500${result.posterPath}",
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
                  // أيقونة الإضافة
                  Positioned(
                    top: screenHeight * 0.11,
                    left: screenWidth * 0.05,
                    child: InkWell(
                      onTap: () {},
                      child: ClipPath(
                        clipper: NotchClipper(),
                        child: InkWell(
                          child: Container(
                            height: screenHeight * 0.038,
                            width: screenWidth * 0.047,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color:
                                  isFavorite ? Colors.yellow : Colors.grey[600],
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            provider.toggleFavorite(Movie(
                              id: result.id ?? 0,
                              title: result.title ?? 'Unknown',
                              posterPath: result.posterPath ?? '',
                              overview: result.overview ?? '',
                            ));
                          },
                        ),
                      ),
                    ),
                  ),
                  // عنوان الفيلم وتاريخ الإصدار مع تحسينات على الخطوط
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
                            fontSize: 16.0, // زيادة حجم الخط
                            fontWeight: FontWeight.bold, // زيادة السماكة
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          result.releaseDate ?? '2019  PG-13  2h 7m',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0, // تصغير حجم التاريخ
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
            autoPlay: true, // تفعيل التشغيل التلقائي
            enlargeCenterPage: true,
            viewportFraction: 0.9, // عرض الفيلم في النطاق الكامل تقريباً
          ),
        ),
      );
    });
