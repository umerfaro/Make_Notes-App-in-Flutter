import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../view_models/splash_services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  splashScreens splashScreen= splashScreens();
  late final AnimationController _animationController =
  AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void initState() {
    super.initState();
    splashScreen.IsSplashLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set the background color that matches the image
        //color: Color(0xFF567ED2), // Replace with your desired background color

        // Add the gradient overlay
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[200]!, // Start color (same as background)
              Colors.grey[600]!, // End color (a slightly darker shade)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1500),
                builder: (BuildContext context, double value, Widget? child) {
                  final angle = value * math.pi; // The angle of rotation

                  // Use the `Transform` widget to handle the flip animation
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective effect to make it look like a 3D flip
                      ..rotateY(angle), // Rotate around the Y-axis
                    child: child,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(
                    child: Image(image: AssetImage('images/notes.png')),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Make Notes",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700], // Use white color for better visibility
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
