// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:code_frame/widgets/background.dart';
import 'package:code_frame/widgets/space.dart';
import 'package:code_frame/widgets/win_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:soundpool/soundpool.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> items =
      "Short walk, call a friend, 10-minute reading, write a gratitude journal, do 15 push-ups, listen to a favorite song, 5-minute meditation, drink a glass of water, relax and take a deep breath, compliment someone"
          .split(',');
  StreamController<int> selected = StreamController<int>();

  Soundpool pool = Soundpool.fromOptions(
    options: const SoundpoolOptions(
      streamType: StreamType.music,
    ),
  );
  int? _spinSoundId;
  int? _winSoundId;
  int currentWheelIndex = 0;

  @override
  void initState() {
    super.initState();

    (() async {
      _spinSoundId = await rootBundle
          .load("assets/sfx/spin.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      _winSoundId = await rootBundle
          .load("assets/sfx/win.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
    }());
  }

  @override
  void dispose() {
    selected.close();
    pool.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xff0e292e),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 500,
                child: FortuneWheel(
                  physics: CircularPanPhysics(
                    duration: const Duration(seconds: 1),
                    curve: Curves.decelerate,
                  ),
                  duration: Duration(seconds: 5),
                  onFling: () {
                    selected.add(1);
                  },
                  onAnimationStart: () {
                    _spinSoundId != null ? pool.play(_spinSoundId!) : null;
                  },
                  onAnimationEnd: () {
                    _winSoundId != null ? pool.play(_winSoundId!) : null;
                  },
                  animateFirst: false,
                  selected: selected.stream,
                  items: [
                    for (var i = 0; i < items.length; i++)
                      FortuneItem(
                        style: FortuneItemStyle(
                          color: i % 2 == 0
                              ? const Color(0xff066760)
                              : const Color(0xff14433e),
                          borderColor: const Color(0xff0c2e30),
                          borderWidth: 3,
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        child: Text(
                          items[i],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Space(20),
            ElevatedButton(
              onPressed: () async {
                currentWheelIndex = Random().nextInt(items.length);
                selected.add(currentWheelIndex);
                await Future.delayed(const Duration(seconds: 5));
                showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (ctx) {
                    return WinDialog(
                      endAnimColor: Colors.amber,
                      message: "${items[currentWheelIndex]}!",
                    );
                  },
                );
              },
              child: const Text("Spin"),
            ),
          ],
        ),
      ),
    );
  }
}
