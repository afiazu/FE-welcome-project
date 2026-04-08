import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/IconConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:welcome_project_fe/view/screens/login.dart';
import './view/screens/dashboard.dart';

late final GoRouter router;


void initializeGoRouter() {
  router = GoRouter(
    initialLocation: '/login', 
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
        ),
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
    ]
  );
}
