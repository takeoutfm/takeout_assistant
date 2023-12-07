import 'package:flutter/material.dart';

final clockFrameKey = new GlobalKey<_ClockFrameState>();

class ClockFrame extends StatefulWidget {
  final Function(AnimationController controller)? child;
  final AnimationController? animationController;

  const ClockFrame({super.key, this.child, this.animationController});

  @override
  State<StatefulWidget> createState() => _ClockFrameState();
}

class _ClockFrameState extends State<ClockFrame> with TickerProviderStateMixin {
  late AnimationController _animation;

  // TweenSequence<Color?> tweenColors = TweenSequence<Color?>(colors
  //     .asMap()
  //     .map(d
  //       (index, color) => MapEntry(
  //         index,
  //         TweenSequenceItem<Color?>(
  //           weight: 1.0,
  //           tween: ColorTween(
  //             begin: color,
  //             end: colors[index + 1 < colors.length ? index + 1 : 0],
  //           ),
  //         ),
  //       ),
  //     )
  //     .values
  //     .toList());

  AnimationController get animationController => _animation;

  @override
  void initState() {
    _animation = widget.animationController ??
        AnimationController(duration: Duration(minutes: 5), vsync: this);
    _animation.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          // final color =
          //     tweenColors.evaluate(AlwaysStoppedAnimation(_animation.value));
          return Scaffold(
              backgroundColor: Colors.black87,
              body: Center(
                  child: Container(
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                      child: Center(
                          child: AspectRatio(
                              aspectRatio: size.aspectRatio,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final borderRadius =
                                      constraints.biggest.width * 0.09;
                                  final borderWidth =
                                      constraints.biggest.width * 0.01;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                      border: Border.all(
                                          width: borderWidth,
                                          color: Colors.black87,
                                          style: BorderStyle.solid),
                                    ),
                                    child: ClipRRect(
                                      child: widget.child!(_animation),
                                      borderRadius: BorderRadius.circular(
                                          borderRadius - borderWidth),
                                    ),
                                  );
                                },
                              ))))));
        });
  }
}
