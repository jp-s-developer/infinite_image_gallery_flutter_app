import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_image_gallery_app/model/gallery_base_model.dart';
import 'package:infinite_image_gallery_app/screens/details/details_screen.dart';
import 'package:infinite_image_gallery_app/screens/favourite/favourite_screen.dart';
import 'package:infinite_image_gallery_app/screens/home/home_screen.dart';
import 'package:infinite_image_gallery_app/screens/splash/splash_screen.dart';

import '../../screens/favourite/favourite_vm.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String imageDetails = '/imageDetails';
  static const String favourite = '/favourite';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.imageDetails,
      name: 'imageDetails',
      builder: (context, state) {
        return state.extra is Hits
            ? ImageDetailScreen(hit: state.extra as Hits)
            : SizedBox();
      },
    ),
    GoRoute(
      path: AppRoutes.favourite,
      name: 'favourite',
      builder: (context, state) {
        return FavouriteScreen(
          vm: state.extra is FavouriteViewModel
              ? state.extra as FavouriteViewModel
              : FavouriteViewModel(),
        );
      },
    ),
  ],
);
