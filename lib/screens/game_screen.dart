// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:code_frame/constants/colors.dart';
import 'package:code_frame/constants/sources.dart';
import 'package:code_frame/providers/action_provider.dart';
import 'package:code_frame/providers/history_provider.dart';
import 'package:code_frame/widgets/background.dart';
import 'package:code_frame/widgets/edit_action.dart';
import 'package:code_frame/widgets/history_list.dart';
import 'package:code_frame/widgets/space.dart';
import 'package:code_frame/widgets/touchable_opacity.dart';
import 'package:code_frame/widgets/win_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import 'package:soundpool/soundpool.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  TextEditingController addActionController = TextEditingController();
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
    loadSFX();
  }

  void loadSFX() async {
    _spinSoundId =
        await rootBundle.load(Sources.spinMusic).then((ByteData soundData) {
      return pool.load(soundData);
    });
    _winSoundId =
        await rootBundle.load(Sources.winMusic).then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void showAddActionPromptDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Action"),
          content: TextField(
            controller: addActionController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter action",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (addActionController.text.isNotEmpty) {
                  setState(() {
                    Provider.of<ActionsProvider>(context, listen: false)
                        .addAction(addActionController.text);
                  });
                  addActionController.clear();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var actionsProvider = Provider.of<ActionsProvider>(context);
    var historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    return Scaffold(
      body: Background(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: ConstantColors.tileDarkest,
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
                    selected.add(currentWheelIndex);
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
                    for (var i = 0; i < actionsProvider.actions.length; i++)
                      FortuneItem(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return EditAction(
                                onRemove: () {
                                  Navigator.of(context).pop();
                                  if (actionsProvider.actions.length > 2) {
                                    setState(() {
                                      actionsProvider.removeActionAtIndex(i);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Atleast 2 items are required!"),
                                      ),
                                    );
                                  }
                                },
                                actionName: actionsProvider.actions[i],
                              );
                            },
                          );
                        },
                        style: FortuneItemStyle(
                          color: i % 2 == 0
                              ? ConstantColors.tileLight
                              : ConstantColors.tileDark,
                          borderColor: ConstantColors.tileDarkest,
                          borderWidth: 3,
                          textStyle: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        child: Text(actionsProvider.actions[i]),
                      ),
                  ],
                ),
              ),
            ),
            const Space(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      currentWheelIndex =
                          Random().nextInt(actionsProvider.actions.length);
                      selected.add(currentWheelIndex);
                      await Future.delayed(const Duration(seconds: 5));
                      await showDialog(
                        context: context,
                        useSafeArea: false,
                        builder: (ctx) {
                          return WinDialog(
                            endAnimColor: Colors.amber,
                            message:
                                "${actionsProvider.actions[currentWheelIndex]}!",
                          );
                        },
                      );
                      historyProvider.addAction(
                          actionsProvider.actions[currentWheelIndex]);
                    },
                    child: const Text("Spin"),
                  ),
                ),
                Space.horizontal,
                ElevatedButton(
                  onPressed: showAddActionPromptDialog,
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ],
            ),
            const Space(20),
            const HistoryList(),
            const Space(50),
            const MadeWithLove(),
            const Space(20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    selected.close();
    pool.dispose();
    super.dispose();
  }
}

class MadeWithLove extends StatelessWidget {
  const MadeWithLove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'Made with ❤ By ',
          style: TextStyle(
            color: ConstantColors.lighterGrayText,
            fontWeight: FontWeight.w500,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'SiD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
