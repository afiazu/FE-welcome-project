import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/IconConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove default background color, we'll use gradient
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.lightGreen
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            // child: SingleChildScrollView(
            //   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       // UBTS Logo
            //       Image.asset(
            //         ImageConstants.UBTSlogo,
            //         height: 140,
            //       ),

            //       const SizedBox(height: 40),

            //       // Welcome Title
            //       const Text(
            //         'Welcome',
            //         style: TextStyle(
            //           fontSize: 32,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),

            //       const SizedBox(height: 12),

            //       // Subtitle
            //       Text(
            //         'Manage your tasks and workflow efficiently.',
            //         style: TextStyle(
            //           fontSize: 16,
            //           color: Colors.white.withOpacity(0.9),
            //         ),
            //         textAlign: TextAlign.center,
            //       ),

            //       const SizedBox(height: 40),
            //     ],
            //   ),
            // ),

            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(
                    ImageConstants.UBTSlogo,
                    height: 120,
                  ),

                  const SizedBox(height: 25),

                  // Box Container
                  SizedBox(
                    width: 600,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                    
                      child: Column(
                        children: [
                    
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    
                          const SizedBox(height: 20),
                    
                          // username
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                    
                          const SizedBox(height: 16),
                    
                          // password
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                    
                          const SizedBox(height: 5.0),
                    
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                    
                          const SizedBox(height: 10.0),
                    
                          // login
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                    
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.ubtsBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    
                          const SizedBox(height: 12),
                    
                          TextButton(
                            onPressed: () {

                            },
                            child: const Text('Forgot password?'),
                          ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            
                            children: [
                              const Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {

                                },
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}