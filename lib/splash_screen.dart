import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:movies/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(duration: 3000,
            splash: Image.network('https://png.pngtree.com/template/20190629/ourmid/pngtree-home-movie-logo-simple-line-logo-template-vector-illustration-image_223617.jpg', height: 300, width: 300,),
            nextScreen: HomePage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.blue));

  }
}