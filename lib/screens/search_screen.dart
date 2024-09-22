import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          "Search Movies",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(
          //     Icons.search,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     showSearch(
          //       context: context,
          //       delegate: MovieSearchDelegate(),
          //     );
          //   },
          // ),
        ],
      ),
      body: Center(
        child: Text(
          'Search for movies',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
