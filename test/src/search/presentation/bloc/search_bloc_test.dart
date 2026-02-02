import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tech_proof/core/error/failure.dart';
import 'package:tech_proof/domain/entities/movie_entity.dart';
import 'package:tech_proof/domain/entities/search_response_entity.dart';
import 'package:tech_proof/src/search/presentation/bloc/search_bloc.dart';

import '../../../../mocks.mocks.mocks.dart';

void main() {
  late MockMovieRepositoryImpl mockMovieRepository;
  late SearchBloc searchBloc;

  final tMovies = [
    MovieEntity(
      id: 1,
      title: 'Test Movie',
      posterPath: 'path',
      releaseDate: '2023',
      synopsis: 'synopsis',
      rating: 5.0,
      genres: [],
    ),
  ];

  final tSearchResponse = SearchResponseEntity(
    page: 1,
    results: tMovies,
    totalPages: 1,
    totalResults: 1,
  );

  final tEmptySearchResponse = SearchResponseEntity(
    page: 1,
    results: [],
    totalPages: 1,
    totalResults: 0,
  );

  setUp(() {
    mockMovieRepository = MockMovieRepositoryImpl();
    searchBloc = SearchBloc(movieRepository: mockMovieRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  test('initial state is SearchInitial', () {
    expect(searchBloc.state, SearchInitial());
  });

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchLoaded] when SearchSubmitted is added and repository returns results',
    build: () {
      when(mockMovieRepository.searchMovies(query: 'query')).thenAnswer(
        (_) async => Right(tSearchResponse),
      );
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchSubmitted('query')),
    expect: () => [
      SearchLoading(),
      SearchLoaded(tMovies),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchInitial] when SearchSubmitted is added and repository returns empty results',
    build: () {
      when(mockMovieRepository.searchMovies(query: 'empty')).thenAnswer(
        (_) async => Right(tEmptySearchResponse),
      );
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchSubmitted('empty')),
    expect: () => [
      SearchLoading(),
      SearchInitial(),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchError] when SearchSubmitted is added and repository returns failure',
    build: () {
      when(mockMovieRepository.searchMovies(query: 'error')).thenAnswer(
        (_) async => Left(ServerFailure('Error')),
      );
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchSubmitted('error')),
    expect: () => [
      SearchLoading(),
      const SearchError('Something went wrong with your query'),
    ],
  );
}
