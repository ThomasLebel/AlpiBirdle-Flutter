import 'package:birdle/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Tile extends StatelessWidget {
  const Tile(
    this.letter,
    this.hitType, {
    super.key,
    this.delay = Duration.zero,
  });

  final String letter;
  final HitType hitType;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );

    if (hitType == HitType.none || hitType == HitType.removed) {
      return container;
    }

    return container.animate().flipH(duration: 600.ms, delay: delay);
  }
}
