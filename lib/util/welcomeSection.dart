import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String userName;
  const WelcomeSection({super.key, this.userName = 'try_User'});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $userName',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
