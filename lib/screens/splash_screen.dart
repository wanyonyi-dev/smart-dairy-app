import 'package:flutter/material.dart';
import 'package:smart_dairy/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.tealAccent, // Corrected color reference
      child: Center( // Centered the image inside the container
        child: Image.asset('assets/cow_image.png', width: 200, height: 200),
      ),
    );
  }
}
