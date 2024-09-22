import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/provider/search_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.white,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.getSearch(query);

    if (query.isEmpty) {
      return const Center(child: Text("Enter a search term to get results."));
    }

    return Consumer<SearchProvider>(builder: (context, provider, index) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      var results = provider.results;

      if (results.isEmpty) {
        return const Center(child: Text("No suggestions found."));
      }

      return ListView.builder(
        itemCount: results.length ?? 0, // Fixed itemCount
        itemBuilder: (context, index) {
          var result = results[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${result.backdropPath}",
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.3,
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
                  const SizedBox(width: 5.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.title ?? "No Title",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5.0),
                        Text(result.overview ?? "No Source",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5.0),
                        Text(result.releaseDate?.substring(0, 10) ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.getSearch(query);

    if (query.isEmpty) {
      return const Center(child: Text("Enter a search term to get results."));
    }

    return Consumer<SearchProvider>(builder: (context, provider, index) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      var results = provider.results;

      if (results.isEmpty) {
        return const Center(child: Text("No suggestions found."));
      }

      return ListView.builder(
        itemCount: results.length ?? 0, // Fixed itemCount
        itemBuilder: (context, index) {
          var result = results[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${result.backdropPath}",
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.3,
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
                  const SizedBox(width: 5.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.title ?? "No Title",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5.0),
                        Text(result.overview ?? "No Source",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5.0),
                        Text(result.releaseDate?.substring(0, 10) ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildAppBarActions(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: MovieSearchDelegate(),
        );
      },
    );
  }
}
