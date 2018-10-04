import 'dart:math' as math;


import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';

class SnakePiece extends StatelessWidget {

  final Point position;
  final double piecesize;
  final bool isSnake;

  const SnakePiece({Key key, this.position, this.piecesize, this.isSnake = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: position.y*piecesize,
        left: position.x*piecesize,
        child: Container(
          height: piecesize,
          width: piecesize,
          decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle
          ),
        )
    );
  }
}

