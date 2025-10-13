import 'package:tech_proof/core/services/local_storage_service.dart';

class MovieEntity implements JsonConvertible {
  final int id;
  final String posterPath;
  final String title;
  final String releaseDate;
  final String synopsis;
  final double rating;
  final List<String> genres;

  const MovieEntity({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.synopsis,
    required this.rating,
    required this.genres,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posterPath': posterPath,
      'title': title,
      'releaseDate': releaseDate,
      'synopsis': synopsis,
      'rating': rating,
      'genres': genres,
    };
  }

  factory MovieEntity.fromJson(Map<String, dynamic> json) {
    return MovieEntity(
      id: json['id'] as int,
      posterPath: json['posterPath'] as String,
      title: json['title'] as String,
      releaseDate: json['releaseDate'] as String,
      synopsis: json['synopsis'] as String,
      rating: json['rating'] as double,
      genres: List<String>.from(json['genres'] as List),
    );
  }
}
