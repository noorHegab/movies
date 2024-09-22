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
            final provider = Provider.of<MovieProvider>(context, listen: false);
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            // Ensure genres are loaded before displaying tabs
            if (provider.genres.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65.0),
                  child: Text(
                    "Browse Category",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
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
                      // crossAxisSpacing: 8.0,
                      // mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      final category = provider.genres[index];
                      return InkWell(
                        onTap: () {
                          navigateTo(context,
                              MoviesWithCategory(id: category.id ?? 0));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
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
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  category.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Scaffold(
// backgroundColor: Colors.black,
// body: ChangeNotifierProvider(
// create: (context) => MovieProvider()
// ..getMoviesList(),
// child: Consumer<MovieProvider>(builder: (context, provider, child) {
// if (provider.genres.isEmpty) {
// return const Center(child: CircularProgressIndicator());
// }
// return Column(
// children: [
// const SizedBox(height: 30.0),
// DefaultTabController(
// length: provider.genres.length,
// child: Column(
// children: [
// TabBar(
// onTap: (value) {
// provider.changeTab(value);
// },
// indicatorColor: Colors.transparent,
// isScrollable: true,
// tabs: provider.genres.map((e) {
// return Tab(
// child: Container(
// padding: const EdgeInsets.all(5),
// decoration: BoxDecoration(
// color: provider.selectedIndex ==
// provider.genres.indexOf(e)
// ? Colors.grey
//     : Colors.white,
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color: Colors.grey),
// ),
// child: Text(
// e.name ?? '',
// style: TextStyle(
// color: provider.selectedIndex ==
// provider.genres.indexOf(e)
// ? Colors.white
//     : Colors.black,
// ),
// ),
// ),
// );
// }).toList(),
// ),
// const SizedBox(height: 10),
// ],
// ),
// ),
// if (provider.selectedGenreName.isEmpty)
// const Center(
// child: CircularProgressIndicator(),
// ),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(15.0),

// ],
// );
// }),
// ),
// );
