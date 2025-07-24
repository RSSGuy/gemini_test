import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/registration_screen.dart';
import '../providers/core_providers.dart'; // Assuming authStateChangesProvider is here

enum PageTransitionType { fade, slide, scale,slideAndFade }
CustomTransitionPage buildPageWithTransition({required BuildContext context, required GoRouterState state, required Widget child, required PageTransitionType type,Offset slideBeginOffset = const Offset(1.0, 0.0),}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case PageTransitionType.fade: return FadeTransition(opacity: animation, child: child);
        case PageTransitionType.slide:
          const begin = Offset(1.0, 0.0); const end = Offset.zero; const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        case PageTransitionType.scale: return ScaleTransition(scale: animation, child: child);
      // --- NEW CASE for Slide and Fade ---
        case PageTransitionType.slideAndFade:
        // Fade Transition
          final fadeAnimation = CurvedAnimation(
            parent: animation, // Use the primary animation
            curve: Curves.easeInOut, // Or any curve you prefer for fade
          );
          // Slide Transition
          // Use the slideBeginOffset passed to the function
          final slideTween = Tween<Offset>(begin: slideBeginOffset, end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeIn)); // Or any curve you prefer for slide
          final slideAnimation = animation.drive(slideTween);

          return FadeTransition(opacity: fadeAnimation, child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
      // --- END NEW CASE ---
        //case PageTransitionType.values: return ScaleTransition(scale: scale);
      }
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authState.asData?.value != null;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
          type: PageTransitionType.fade, // Or your preferred transition
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const RegistrationScreen(),
          type: PageTransitionType.fade, // Or your preferred transition
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(path: '/', pageBuilder: (context, state) => buildPageWithTransition(context: context, state: state, child: const HomeScreen(), type: PageTransitionType.slideAndFade,),),
          GoRoute(path: '/notes', pageBuilder: (context, state) => buildPageWithTransition(context: context, state: state, child: const NotesScreen(), type: PageTransitionType.slideAndFade,),),
          GoRoute(path: '/map', pageBuilder: (context, state) => buildPageWithTransition(context: context, state: state, child: const MapScreen(), type: PageTransitionType.slideAndFade,),),
          GoRoute(path: '/settings', pageBuilder: (context, state) => buildPageWithTransition(context: context, state: state, child: const SettingsScreen(), type: PageTransitionType.slideAndFade,),),
          GoRoute(path: '/profile', pageBuilder: (context, state) => buildPageWithTransition(context: context, state: state, child: const ProfileScreen(), type: PageTransitionType.slideAndFade,),),
        ],
      ),
    ],
  );
});
