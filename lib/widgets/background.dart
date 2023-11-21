import 'package:code_frame/constants/sources.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Sources.backgroundImage),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: child,
    );
  }
}
