part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  const HomeError();
}

class HomeReady extends HomeState {
  final List<MovieEntity> movies;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  const HomeReady({
    required this.movies,
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });
  @override
  List<Object> get props => [movies, page, totalPages, isLoadingMore];
}
