import 'package:code_frame/screens/game_screen.dart';
import 'package:code_frame/widgets/background.dart';
import 'package:code_frame/widgets/space.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Roulette Game",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Space(50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(GameScreen.routeName);
              },
              child: const Text(
                "Play",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
