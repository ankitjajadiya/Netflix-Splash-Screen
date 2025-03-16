import 'package:flutter/material.dart';
import 'package:netflix_splash_screen/splash_screen/welcome_screen.dart';
import 'package:video_player/video_player.dart';

class NetflixSplashScreen extends StatefulWidget {
  const NetflixSplashScreen({super.key});

  @override
  State<NetflixSplashScreen> createState() => _NetflixSplashScreenState();
}

class _NetflixSplashScreenState extends State<NetflixSplashScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/video/splash.mp4')
      ..initialize().then((_) {
        setState(() {
          controller.play();
        });
      });

    controller.addListener(() {
      if (controller.value.position == controller.value.duration) {
        // Video finished, navigate to the next screen
        Navigator.of(context).push(fadeRoute(WelcomeScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }

  // Custom Fade Transition Route
  PageRouteBuilder fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation, // Apply fade effect
          child: child,
        );
      },
    );
  }
}
