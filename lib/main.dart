import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies/layout/initial_screen.dart';
import 'package:movies/models/hive_opject.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initializes Hive
  Hive.registerAdapter(MovieAdapter());

  await Hive.openBox<Movie>('favoritesBox'); // Open your box
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
    );
  }
}

// 4c16feb230d8ae3e1a6227c1ec47af40
