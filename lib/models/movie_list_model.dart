class MovieListModel {
  final List<Genres>? genres;

  MovieListModel({this.genres});

  factory MovieListModel.fromJson(Map<String, dynamic> json) {
    return MovieListModel(
      genres: json['genres'] != null
          ? List<Genres>.from(json['genres'].map((v) => Genres.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genres': genres?.map((v) => v.toJson()).toList(),
    };
  }
}

class Genres {
  final int? id;
  final String? name;

  Genres({this.id, this.name});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
