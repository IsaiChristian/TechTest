import 'package:tech_proof/data/models/movie_detail_model.dart';
import 'package:tech_proof/data/models/movie_model.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';

extension MovieMapper on MovieModel {
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      posterPath: posterPath,
      title: title,
      releaseDate: releaseDate,
      synopsis: overview,
      rating: voteAverage,
      genres: [],
    );
  }
}

extension MovieListMapper on List<MovieModel> {
  List<MovieEntity> toEntityList() {
    return map((movie) => movie.toEntity()).toList();
  }
}

extension MovieDetailMapper on MovieDetail {
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      posterPath: posterPath!,
      title: title,
      releaseDate: releaseDate,
      synopsis: overview,
      rating: voteAverage,
      genres: genres.map((genre) => genre.name).toList(),
    );
  }
}

extension MovieDetailListMapper on List<MovieDetail> {
  List<MovieEntity> toEntityList() {
    return map((movie) => movie.toEntity()).toList();
  }
}
