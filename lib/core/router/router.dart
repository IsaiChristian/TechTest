import 'package:tech_proof/src/favorites/presentation/pages/pages.dart';
import 'package:tech_proof/src/home/presentation/pages/pages.dart';
import 'package:tech_proof/src/movie_detail/presentation/pages/pages.dart';
import 'package:tech_proof/src/search/presentation/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _calculateIndex(state.uri.toString()),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/search');
                  break;
                case 2:
                  context.go('/favorites');
                  break;
              }
            },
            selectedItemColor: Color.fromRGBO(0, 57, 147, 1),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Popular'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          name: 'search',
          path: '/search',
          builder: (context, state) => SearchPage(),
        ),
        GoRoute(
          name: 'favorites',
          path: '/favorites',
          builder: (context, state) => FavoritesPage(),
        ),
      ],
    ),
    GoRoute(
      name: 'movieDetail',
      path: '/movieDetail/:id',
      builder: (context, state) =>
          MovieDetailPage(id: int.parse(state.pathParameters['id']!)),
    ),
  ],
);

int _calculateIndex(String location) {
  if (location.startsWith('/home')) return 0;
  if (location.startsWith('/search')) return 1;
  if (location.startsWith('/favorites')) return 2;
  return 0;
}
