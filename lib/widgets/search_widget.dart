import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/main_provider.dart';
import 'movie_card_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: TextFormField(
              controller: provider.controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true, // Make the background color different
                fillColor: Colors.grey[800], // Dark background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.white, width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 3), // Change border color on focus
                ),
                hintText: "Search for Movies",
                hintStyle: const TextStyle(
                    color: Colors.white70), // Slightly lighter hint color
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  onPressed: () {
                    provider.controller.clear();
                    provider.searchResult = null;
                    provider.updateSearch();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              onChanged: (query) {
                if (query.isEmpty) {
                  provider.searchResult = null;
                  provider.updateSearch();
                }
              },
              onFieldSubmitted: (query) {
                if (query.isNotEmpty) {
                  provider.performSearch(query);
                }
              },
            ),
          ),
          Consumer<MainProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.searchResult != null &&
                  provider.searchResult!.results != null &&
                  provider.searchResult!.results!.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.searchResult!.results!.length,
                    itemBuilder: (context, index) {
                      final movie = provider.searchResult!.results![index];
                      return MovieCard(movie: movie);
                    },
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No results found.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18), // Improved text style
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
