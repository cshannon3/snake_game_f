import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/apple.dart';
import 'package:snake_game_f/Models/point.dart';

class AnimatedApple extends StatefulWidget {
  //final Point position;
  final double piecesize;
  final int secondsBeforeDissapears;
  //final Color appleColor;
  final Apple apple;

  const AnimatedApple(
      {Key key, this.piecesize, this.secondsBeforeDissapears, this.apple})
      : super(key: key);

  @override
  _AnimatedAppleState createState() => new _AnimatedAppleState();
}

class _AnimatedAppleState extends State<AnimatedApple>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.secondsBeforeDissapears))
      ..addListener(() {
        setState(() {});
      })
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onAppleExpired() {
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void didUpdateWidget(AnimatedApple oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (oldWidget.apple.appleLocation != widget.apple.appleLocation) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: widget.apple.appleLocation.y * widget.piecesize,
      left: widget.apple.appleLocation.x * widget.piecesize,
      child: Container(
        height: widget.piecesize,
        width: widget.piecesize,
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            child: CustomPaint(
              painter: ActivationPainter(
                radius: widget.piecesize / 4,
                startAngle: 0.0,
                endAngle: 2 * math.pi * (1 - _animationController.value),
                color: widget.apple.getAppleColor(),
              ),
            ),
            builder: (context, child) => child,
          ),
        ),
      ),
    );
  }
}

class ActivationPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double startAngle;
  final double endAngle;
  final Paint activationPaint;

  ActivationPainter({
    this.radius,
    this.color,
    this.startAngle,
    this.endAngle,
  }) : activationPaint = new Paint()
          ..color = color
          ..strokeWidth = radius * 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromLTWH(
        -radius,
        -radius,
        radius * 2,
        radius * 2,
      ),
      0.0,
      endAngle, //- startAngle, //sweepAngle,
      false, //useCenter,
      activationPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
