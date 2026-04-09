import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/view/screens/inventory.dart';
import 'package:welcome_project_fe/view/screens/login.dart';
import 'package:welcome_project_fe/view/screens/profile.dart';
import 'package:welcome_project_fe/view/screens/register.dart';
import './view/screens/dashboard.dart';

late final GoRouter router;


void initializeGoRouter() {
  router = GoRouter(
    initialLocation: '/login', 
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
        builder: (context, state) {
          final userId = state.extra as int?;

          return DashboardScreen(
            userId: userId,
          );
        }
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
