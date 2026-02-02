import 'movie_entity.dart';

class PopularMoviesResponseEntity {
  final int page;
  final List<MovieEntity> results;
  final int totalPages;
  final int totalResults;

  const PopularMoviesResponseEntity({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
}
