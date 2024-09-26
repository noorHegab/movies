import 'package:flutter/material.dart';

import '../widgets/search_widget.dart';

class SearchTab extends StatelessWidget {
  // final ApiManager apiManager = ApiManager();
  SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SearchWidget(),
        ],
      ),
    );
  }
}
