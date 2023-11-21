// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:code_frame/constants/colors.dart';
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
  List<String> history = [];
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  duration: const Duration(seconds: 5),
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
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xff14433e),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text(
                                        "Edit Action :",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        items[i],
                                        style: const TextStyle(
                                          color: ConstantColors.midGrayText,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 0,
                                      color: Color(0xff0c2e30),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        if (items.length > 2) {
                                          setState(() {
                                            items.removeAt(i);
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Atleast 2 items are required!"),
                                            ),
                                          );
                                        }
                                      },
                                      leading: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      title: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
                history.add(items[currentWheelIndex]);
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
                setState(() {});
              },
              child: const Text("Spin"),
            ),
            const Space(20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff14433e),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xff0c2e30),
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        history.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Color(0xff0c2e30),
                  ),
                  for (var i = 0; i < history.length; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xff0c2e30),
                        borderRadius: i == history.length - 1
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28))
                            : null,
                      ),
                      child: ListTile(
                        title: Text(
                          history[i],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Space(50),
          ],
        ),
      ),
    );
  }
}
