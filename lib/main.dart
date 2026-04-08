import 'package:flutter/material.dart';
import 'package:welcome_project_fe/view/screens/dashboard.dart';
import 'package:welcome_project_fe/view/screens/login.dart';
import 'router.dart';


void main() {
  initializeGoRouter(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, 
      title: 'UBTS',
      
    );
  }
}