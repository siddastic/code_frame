import 'package:code_frame/screens/game_screen.dart';
import 'package:code_frame/widgets/background.dart';
import 'package:code_frame/widgets/game_button.dart';
import 'package:code_frame/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AnimationController? labelController;
  AnimationController? buttonController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "R",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.stars,
                  color: Colors.white,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(), // loop
                    )
                    .rotate(duration: 1.seconds),
                const Text(
                  "ulette Game",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            )
                .animate(
                  onInit: (controller) {
                    labelController = controller;
                  },
                )
                .fadeIn(
                  duration: 250.ms,
                )
                .slideY(
                  begin: -5,
                  end: 0,
                  duration: 250.ms,
                ),
            const Space(50),
            FittedBox(
              child: GameButton(
                onPressed: () {
                  labelController?.reverse();
                  buttonController?.reverse();
                  Future.delayed(250.ms, () async {
                    await Navigator.of(context).pushNamed(GameScreen.routeName);
                    await Future.delayed(100.ms);
                    labelController?.forward();
                    buttonController?.forward();
                  });
                },
                label: "Play",
              )
                  .animate(
                    onInit: (controller) {
                      buttonController = controller;
                    },
                  )
                  .fadeIn(
                    duration: 250.ms,
                  )
                  .slideY(
                    begin: 5,
                    end: 0,
                    duration: 250.ms,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
