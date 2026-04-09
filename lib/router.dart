import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welcome_project_fe/view/screens/inventory.dart';
import 'package:welcome_project_fe/view/screens/login.dart';
import 'package:welcome_project_fe/view/screens/profile.dart';
import 'package:welcome_project_fe/view/screens/register.dart';
import './view/screens/dashboard.dart';

late final GoRouter router;
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();


void initializeGoRouter() {
  router = GoRouter(
    initialLocation: '/login',
    navigatorKey: rootNavigatorKey,

    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token'); 
      
      final bool isLoggingIn = state.matchedLocation == '/login';
      final bool isRegistering = state.matchedLocation == '/register';

      if (token == null && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      return null; 
    }, 
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => InventoryScreen()
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen()
      )
    ]
  );
}
