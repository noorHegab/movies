import 'package:flutter/material.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: Selector<MainProvider, int>(
          selector: (p0, p1) => p1.selectedIndex,
          builder: (context, selectedIndex, child) {
            var provider = Provider.of<MainProvider>(context, listen: false);
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.grey[800],
                selectedItemColor: Colors.yellow,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  provider.selectedIndex = index;
                  provider.pageController.animateToPage(index,
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 800));
                },
                currentIndex: selectedIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('assets/icons/Home icon.png'),
                    ),
                    label: 'HOME', // Localized label
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/icons/search-2.png')),
                    label: 'SEARCH', // Localized label
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                        AssetImage('assets/icons/Icon material-movie.png')),
                    label: 'BROWSE', // Localized label
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                        AssetImage('assets/icons/Icon ionic-md-bookmarks.png')),
                    label: 'WATCHLIST', // Localized label
                  ),
                ],
              ),
              body: PageView(
                controller: provider.pageController,
                onPageChanged: provider.setIndex,
                children: provider.screens,
              ),
            );
          }),
    );
  }
}
