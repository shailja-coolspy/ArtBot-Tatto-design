import 'dart:async';

import 'package:ai_app/intro_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, navigateToIntroScreen);
  }

  navigateToIntroScreen() {
    Navigator.of(context).pushReplacement(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const IntroScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: AnimatedBuilder(
            animation: _animation,
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                image: AssetImage("assets/images/logo_splash.jpg"),
                fit: BoxFit.fitWidth,
                height: 130,
                width: 130,
              ),
            ),
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
