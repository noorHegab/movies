import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/provider/movie_detials_provider.dart';
import 'package:movies/widgets/build_similar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildMovieDetails() => Consumer<MovieDetailsProvider>(
      builder: (context, provider, child) {
        final provider =
            Provider.of<MovieDetailsProvider>(context, listen: false);
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
                          await provider.getMovieWatch(movieDetails.id ?? 0);
                          if (provider.movieWatched?.key != null) {
                            late String youtubeUrl =
                                'https://www.youtube.com/watch?v=${provider.movieWatched!.key}';
                            print("The Key is : ${provider.movieWatched?.key}");
                            final Uri url = Uri.parse(youtubeUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Could not launch URL')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('key is empty')),
                            );
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    movieDetails.title ?? 'No title available',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                        child: SizedBox(
                          height: screenHeight * 0.2,
                          width: screenWidth * 0.2,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: movieDetails.genreIds?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 50.0,
                              crossAxisSpacing: 30.0,
                            ),
                            itemBuilder: (context, index) {
                              final genre = movieDetails.genreIds?[index];
                              return Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(
                                  child: Text(
                                    genre != null ? genre.toString() : "Action",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                buildSimilar(),
              ],
            ),
          ),
        );
      },
    );

// Column(
// children: [
// Row(
// children: [
// Container(
// height: screenHeight * 0.03,
// width: screenWidth * 0.09,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color: Colors.grey),
// ),
// child: const Center(
// child: Text(
// "Action",
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// SizedBox(width: screenWidth * 0.04),
// Container(
// height: screenHeight * 0.03,
// width: screenWidth * 0.09,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color: Colors.grey),
// ),
// child: const Center(
// child: Text(
// "Action",
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// SizedBox(width: screenWidth * 0.04),
// Container(
// height: screenHeight * 0.03,
// width: screenWidth * 0.09,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color: Colors.grey),
// ),
// child: const Center(
// child: Text(
// "Action",
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 10.0,
// ),
// Row(
// children: [
// Container(
// height: screenHeight * 0.03,
// width: screenWidth * 0.09,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color: Colors.grey),
// ),
// child: const Center(
// child: Text(
// "Action",
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// ],
// ),
// const SizedBox(
// height: 10.0,
// ),
// Text(
// movieDetails.overview ??
// 'No overview available',
// style: const TextStyle(
// fontSize: 16, color: Colors.white),
// textAlign: TextAlign.left,
// maxLines: 3,
// overflow: TextOverflow.ellipsis,
// ),
// ],
// ),
