import 'package:flutter/material.dart';
import 'package:welcome_project_fe/api_service.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';
import 'package:go_router/go_router.dart';
import 'package:welcome_project_fe/util/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            'Sign Up',
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

                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
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
                    
                          const SizedBox(height: 20.0),
                    
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                String username = usernameController.text.trim();
                                String email = emailController.text.trim();
                                String password = passwordController.text.trim();

                                if (username.isEmpty || email.isEmpty || password.isEmpty) {
                                  showRightSnackbar(context, 'Please fill in all fields');
                                  return;
                                }
                                if (!isValidEmail(email)) {
                                  showRightSnackbar(context, 'Please enter a valid email');
                                  return;
                                }

                                try{
                                  await ApiService.register(username, email, password);
                                  showRightSnackbar(context, 'Registration successful! Please log in.');
                                  context.go('/login');
                                }catch(e){
                                  showRightSnackbar(context, 'Registration failed: ${e.toString()}');
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
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    
                          const SizedBox(height: 12),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            
                            children: [
                              const Text('Already have an account?'),
                              TextButton(
                                onPressed: () {
                                  context.go('/login');
                                },
                                child: const Text('Sign In'),
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