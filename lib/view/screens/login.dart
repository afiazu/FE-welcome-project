import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:welcome_project_fe/util/ImageConstants.dart';
import 'package:welcome_project_fe/util/IconConstants.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( 
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // UBTS Logo
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset(
                  ImageConstants.UBTSlogo,
                  height: 140,
                ),

                const SizedBox(width: 40),
                
                // User Icon SVG
                SvgPicture.asset(
                  IconConstants.userIcon,
                  height: 140,
                ),
                ],),


                const SizedBox(height: 40),

                // Welcome Title
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.ubtsBlue,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'This is a template.',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.ubtsBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}