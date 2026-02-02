import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/src/movie_detail/presentation/bloc/movie_detail_bloc.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieRepositoryImpl mockMovieRepository;
  late MovieDetailBloc movieDetailBloc;
  const tMovieId = 1;

  final tMovie = MovieEntity(
    id: tMovieId,
    title: 'Test Movie',
    posterPath: 'path',
    releaseDate: '2023',
    synopsis: 'synopsis',
    rating: 5.0,
    genres: [],
  );

  setUp(() {
    mockMovieRepository = MockMovieRepositoryImpl();
    movieDetailBloc = MovieDetailBloc(
      movieRepository: mockMovieRepository,
      movieId: tMovieId,
    );
  });

  tearDown(() {
    movieDetailBloc.close();
  });

  test('initial state is MovieDetailInitial', () {
    expect(movieDetailBloc.state, MovieDetailInitial());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits [MovieDetailLoading, MovieDetailLoaded] when MovieDetailInit is added and repository returns success',
    build: () {
      when(
        mockMovieRepository.getMovie(id: tMovieId),
      ).thenAnswer((_) async => Right(tMovie));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const MovieDetailInit()),
    expect: () => [MovieDetailLoading(), MovieDetailLoaded(tMovie)],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits [MovieDetailLoading, MovieDetailError] when MovieDetailInit is added and repository returns failure',
    build: () {
      when(
        mockMovieRepository.getMovie(id: tMovieId),
      ).thenAnswer((_) async => Left(ServerFailure('Error')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const MovieDetailInit()),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError(message: 'Failed to fetch movie details'),
    ],
  );
}
