import 'package:tech_proof/data/repositories/movies_repository_imp.dart';
import 'package:tech_proof/presentation/widgets/tt_app_bar.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';
import 'package:tech_proof/presentation/widgets/tt_movie_grid.dart';
import 'package:tech_proof/src/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
         movieRepository: context.read<MovieRepositoryImpl>(),
      )..add(HomeInit()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return HomePageView(
            
          );
        },
      ),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
  
}

class _HomePageViewState extends State<HomePageView> {
    final ScrollController _scrollController = ScrollController();

   @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
        context.read<HomeBloc>().add(HomeShowLoading());
        context.read<HomeBloc>().add(HomeLoadMore());
    }
  }

  @override
  void dispose() {
    
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<HomeBloc>().state;

    if (currentState is HomeLoading || currentState is HomeInitial) {
      return Column(
        children: [
          Expanded(child: TtLoadingLogo()),
        ],
      );
    }
    if (currentState is HomeReady) {
    return Scaffold(
      appBar: TtAppBar(
        title: 'Popular Movies',
      ),
      body: SingleChildScrollView(
        key: ValueKey('home_scroll_view'),
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
          
              TtMovieGrid(movieList: currentState.movies),
              if (currentState.isLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TtLoadingLogo(),
                ),
            ],
          ),
        ),
      ),
    );
  }
  if (currentState is HomeError) {
    return Scaffold(
      appBar: TtAppBar(),
      body: Center(
        child: Text('An error occurred. Please try again later.'),
      ),
    );
  }
  return SizedBox.shrink();
  }
}


