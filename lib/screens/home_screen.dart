import 'package:flutter/material.dart';
import 'package:movies/provider/main_provider.dart';
import 'package:movies/widgets/popular_wedget.dart';
import 'package:movies/widgets/top_rated_widget.dart';
import 'package:movies/widgets/upcoming_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider(
          create: (context) => MainProvider()
            ..getPopular()
            ..getUpcoming()
            ..getTopRated(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildPopular(),
                buildUpcoming(),
                buildTopRated(),
              ],
            ),
          )),
    );
  }
}
