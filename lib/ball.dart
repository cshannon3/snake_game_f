import 'dart:math';

import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double x;
  final double y;
  final double piecesize;
  final bool isSnake;

  const Ball({Key key, this.x, this.y, this.piecesize, this.isSnake})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: y,
        left: x,
        child: Container(
          height: piecesize,
          width: piecesize,
          decoration: BoxDecoration(
              color: isSnake ? Colors.blue : Colors.red,
              shape: BoxShape.circle
          ),
        )
    );
  }
}


class AnimatedApple extends StatefulWidget {
  final double radius;
  final double x;
  final double y;
  final double piecesize;


  const AnimatedApple({Key key, this.radius, this.x, this.y, this.piecesize}) : super(key: key);
  
  @override
  _AnimatedAppleState createState() => new _AnimatedAppleState();
}

class _AnimatedAppleState extends State<AnimatedApple> with TickerProviderStateMixin {

  AnimationController _animationController;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 10))
      ..addListener((){
        setState(() {

        });
      })
    ..forward();
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedApple oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.x != widget.x || oldWidget.y != widget.y) {
      _animationController.reset();
      _animationController.forward();
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return new  Positioned(
        top: widget.y,
        left: widget.x,
        child: Container(
        height: widget.piecesize,
        width: widget.piecesize,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          child: CustomPaint(
            painter: ActivationPainter(
              radius: widget.radius,
              startAngle: -pi/2,
              endAngle : (3*pi / 2)*(1-_animationController.value),
              color: Colors.red,
            ),
          ),
          builder: (context, child) =>  child,
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
  }): activationPaint = new Paint()
    ..color = color
    ..strokeWidth = radius*2
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
      startAngle,
      endAngle - startAngle, //sweepAngle,
      false, //useCenter,
      activationPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}