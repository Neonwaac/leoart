import 'package:flutter/material.dart';
import 'package:shared/core/design/app_durations.dart';

class AppHero extends StatelessWidget {
  final String tag;
  final Widget child;
  final Duration duration;

  const AppHero({
    super.key,
    required this.tag,
    required this.child,
    this.duration = AppDurations.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder:
          (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection direction,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final Widget child;
            if (direction == HeroFlightDirection.push) {
              child = fromHeroContext.widget;
            } else {
              child = toHeroContext.widget;
            }
            return Material(type: MaterialType.transparency, child: child);
          },
      createRectTween: (begin, end) {
        return MaterialRectArcTween(begin: begin, end: end);
      },
      child: child,
    );
  }
}
