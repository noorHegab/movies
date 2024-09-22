import 'package:hive/hive.dart';

part 'hive_opject.g.dart'; // Ensure the filename matches exactly

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });
}
