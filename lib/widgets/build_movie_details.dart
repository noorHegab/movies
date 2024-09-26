import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/movie_detials_provider.dart';
import 'package:movies/screens/video_player_screen.dart';
import 'package:movies/widgets/build_similar.dart';
import 'package:provider/provider.dart';

Widget buildMovieDetails() => Consumer<MovieDetailsProvider>(
      builder: (context, provider, child) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        var movieDetails = provider.movieDetails;

        if (movieDetails == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.grey[700],
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.grey[700],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Center(
              child: Text(
                movieDetails.title ?? 'Movie Details',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عرض صورة الخلفية مع زر تشغيل الفيديو
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movieDetails.backdropPath != null
                            ? "https://image.tmdb.org/t/p/original${movieDetails.backdropPath}"
                            : 'assets/images/monitor-1350918_640.webp',
                        height: screenHeight * 0.3,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/monitor-1350918_640.webp',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            await provider.getMovieWatch(movieDetails.id ?? 0);
                            if (provider.movieWatched?.key != null) {
                              String youtubeUrl = provider.movieWatched!.key!;
                              navigateTo(
                                  context,
                                  YouTubePlayerScreen(
                                    videoId: youtubeUrl,
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "No video key available for this movie.")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error fetching movie: $e")));
                          }
                        },
                        child: const ImageIcon(
                          AssetImage("assets/icons/play-button-2.png"),
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // عرض العنوان مع تقييم النجوم
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          movieDetails.title ?? 'No title available',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow[700]),
                          const SizedBox(width: 5),
                          Text(
                            movieDetails.voteAverage?.toString() ?? 'N/A',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    movieDetails.releaseDate ?? 'No release date',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                // عرض الصورة الرئيسية وتصنيفات الفيلم مع Chips
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: movieDetails.posterPath != null
                              ? "https://image.tmdb.org/t/p/original${movieDetails.posterPath}"
                              : 'assets/images/monitor-1350918_640.webp',
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.27,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/monitor-1350918_640.webp',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: movieDetails.genres?.map((e) {
                                    return Chip(
                                      label: Text(
                                        e.name ?? "Unknown",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.grey[700],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    );
                                  }).toList() ??
                                  [],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              movieDetails.overview ?? 'No content',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // عرض الأفلام المشابهة
                buildSimilar(),
              ],
            ),
          ),
        );
      },
    );
