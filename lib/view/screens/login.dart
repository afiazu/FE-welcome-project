import 'package:flutter/material.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welcome_project_fe/util/snackbar.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  bool rememberMe = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              Colors.white,
              Colors.grey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
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
                
                          TextField(
                            controller: usernameController,
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
                            controller: passwordController,
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
                              onPressed: () async {
                                try {
                                  final response = await ApiService.login(
                                    usernameController.text, 
                                    passwordController.text
                                  );

                                final token = response['token'];
                                final userId = response['user_id'];

                                final preferences = await SharedPreferences.getInstance();
                                await preferences.setInt('user_id', userId);
                                await preferences.setString('token', token);
                                await preferences.setString('username', usernameController.text);

                                context.go('/dashboard', extra: userId);
                                
                                } catch (e) {
                                  // error
                                  showRightSnackbar(context, 'Login Failed', isError: true);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return ColorConstants.ubtsBlue;
                                  }
                                  return ColorConstants.ubtsYellow;
                                }),

                                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return ColorConstants.textWhite;
                                  }
                                  return ColorConstants.textBlack;
                                }),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
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
                                  context.go('/register');
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