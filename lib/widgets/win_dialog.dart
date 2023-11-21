import 'package:code_frame/constants/colors.dart';
import 'package:code_frame/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WinDialog extends StatefulWidget {
  final Color endAnimColor;
  final String message;
  const WinDialog({
    Key? key,
    required this.message,
    required this.endAnimColor,
  }) : super(key: key);

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> {
  double initialGradientStep = 0;

  bool firstFrameRendered = false;

  // Logo animation alignment
  Alignment beginAlignment = Alignment.topLeft;
  Alignment endAlignment = Alignment.bottomRight;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!firstFrameRendered) {
        renderNextAnimationFrame();
        firstFrameRendered = true;
      }
    });
    super.initState();
  }

  void renderNextAnimationFrame() {
    if (initialGradientStep == .5) {
      initialGradientStep = 0;
    } else {
      initialGradientStep = .5;
    }
    setState(() {});
  }

  void renderLogoAnimation() {
    if (beginAlignment == Alignment.topLeft) {
      beginAlignment = Alignment.topRight;
      endAlignment = Alignment.bottomLeft;
    } else if (beginAlignment == Alignment.topRight) {
      beginAlignment = Alignment.bottomRight;
      endAlignment = Alignment.topLeft;
    } else if (beginAlignment == Alignment.bottomRight) {
      beginAlignment = Alignment.bottomLeft;
      endAlignment = Alignment.topRight;
    } else if (beginAlignment == Alignment.bottomLeft) {
      beginAlignment = Alignment.topLeft;
      endAlignment = Alignment.bottomRight;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                onEnd: renderLogoAnimation,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: beginAlignment,
                    end: endAlignment,
                    stops: const [.5, 1],
                    colors: [
                      (initialGradientStep == 0
                              ? widget.endAnimColor
                              : Colors.teal)
                          .withOpacity(.5),
                      initialGradientStep == 0
                          ? widget.endAnimColor
                          : Colors.teal,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff171a1f),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(2, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Won Action :",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const Space(20),
                        Text(
                          widget.message,
                          style: const TextStyle(
                            fontSize: 18,
                            color: ConstantColors.midGrayText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: ConstantColors.midGrayText,
                highlightColor: Theme.of(context).primaryColor,
                child: const Text(
                  "Tap to Continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: ConstantColors.midGrayText,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 3),
                height: 200,
                onEnd: renderNextAnimationFrame,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [initialGradientStep, 1],
                    colors: [
                      Colors.transparent,
                      initialGradientStep == 0
                          ? widget.endAnimColor
                          : Colors.teal,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
