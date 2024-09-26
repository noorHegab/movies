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
    return ChangeNotifierProvider(
      create: (context) => MainProvider()
        ..getPopular()
        ..getUpcoming()
        ..getTopRated(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<MainProvider>(builder: (context, provider, child) {
          if (!provider.isConnected) {
            return const Center(
              child: Text(
                "No Connection With Internet",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                buildPopular(),
                buildUpcoming(),
                buildTopRated(),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
