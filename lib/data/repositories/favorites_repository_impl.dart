import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/core/network/safe_call.dart';
import 'package:tech_proof/core/services/local_storage_service.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final LocalStorageService _localStorage;
  static const String _keyFavoriteMovies = 'favorite_movies_list';
  List<MovieEntity>? _cachedFavorites;

  FavoriteRepositoryImpl(this._localStorage);

  @override
  Future<Either<Failure, void>> addMovieToFavorites(MovieEntity movie) async {
    return safeCall(() async {
      final Either<Failure, List<MovieEntity>> result =
          await getFavoriteMovies();
      return result.fold((failure) => throw Exception(failure.message), (
        favorites,
      ) async {
        if (!favorites.any((m) => m.id == movie.id)) {
          favorites.add(movie);
          await _localStorage.setJsonList<MovieEntity>(
            _keyFavoriteMovies,
            favorites,
          );
          _cachedFavorites = favorites;
        }
        return;
      });
    });
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    if (_cachedFavorites != null) {
      return Right(List.of(_cachedFavorites!));
    }
    return safeCall(() async {
      final favorites = await _localStorage.getJsonList<MovieEntity>(
        _keyFavoriteMovies,
        MovieEntity.fromJson,
      );
      _cachedFavorites = favorites;
      return List.of(favorites);
    });
  }

  @override
  Future<Either<Failure, void>> removeMovieFromFavorites(int movieId) async {
    return safeCall(() async {
      final Either<Failure, List<MovieEntity>> result =
          await getFavoriteMovies();
      return result.fold((failure) => throw Exception(failure.message), (
        favorites,
      ) async {
        favorites.removeWhere((movie) => movie.id == movieId);
        await _localStorage.setJsonList<MovieEntity>(
          _keyFavoriteMovies,
          favorites,
        );
        _cachedFavorites = favorites;
        return;
      });
    });
  }

  @override
  Future<Either<Failure, bool>> isFavoriteMovie(int movieId) async {
    return safeCall(() async {
      final Either<Failure, List<MovieEntity>> result =
          await getFavoriteMovies();
      return result.fold(
        (failure) => throw Exception(failure.message),
        (favorites) => favorites.any((movie) => movie.id == movieId),
      );
    });
  }
}
