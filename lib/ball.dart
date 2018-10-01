import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double x;
  final double y;
  final double piecesize;
  final bool isSnake;

  const Ball({Key key, this.x, this.y, this.piecesize, this.isSnake}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: y,
        left: x,
        child: Container(
          height: piecesize,
          width: piecesize,
          decoration: BoxDecoration(
              color: isSnake ?Colors.blue: Colors.red,
              shape: BoxShape.circle
          ),
        )
    );
  }
}