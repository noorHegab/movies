import 'package:flutter/material.dart';
import 'package:movies/component/component.dart';
import 'package:movies/provider/Movie_provider.dart';
import 'package:movies/screens/movies_with_category.dart';
import 'package:provider/provider.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider(
        create: (context) => MovieProvider()..getMoviesList(),
        child: Consumer<MovieProvider>(
          builder: (context, provider, child) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            if (!provider.isConnected) {
              return const Center(
                child: Text(
                  "No Connection With Internet",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }
            if (provider.genres.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30.0),
                  Text(
                    "Browse Categories",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: provider.genres.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        final category = provider.genres[index];
                        return InkWell(
                          onTap: () {
                            navigateTo(context,
                                MoviesWithCategory(id: category.id ?? 0));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Adding shadow to the image
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 2),
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    "assets/images/Image.png",
                                    height: screenHeight * 0.14,
                                    width: screenWidth * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  height: screenHeight * 0.14,
                                  width: screenWidth * 0.35,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
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
            );
          },
        ),
      ),
    );
  }
}
