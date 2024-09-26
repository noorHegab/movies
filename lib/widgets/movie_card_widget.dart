import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        'https://image.tmdb.org/t/p/w500/${movie.posterPath}';
    final String title = movie.title ?? 'Unknown ya man';
    final String releaseDate = movie.releaseDate ?? '';

    return InkWell(
      onTap: () {
        navigateTo(context, MovieDetailsScreen(movieId: movie.id ?? 0));
      },
      child: Card(
        color: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 150,
                width: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child:
                      CircularProgressIndicator(), // Placeholder while loading
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error, // Error icon if image fails to load
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Release Date: $releaseDate',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
