import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label;
  final Widget? child;
  const GameButton({
    required this.onPressed,
    this.label,
    this.child,
    super.key,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 50.milliseconds);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.label != null || widget.child != null,
      'You must provide either a label or a child widget',
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) async {
        _controller.reverse();
        await Future.delayed(50.milliseconds);
        widget.onPressed();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: 0.7,
        ).animate(_controller),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: widget.child ??
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
