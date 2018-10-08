import 'dart:math' as math;


import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';

class SnakePiece extends StatelessWidget {

  final Point position;
  final double piecesize;
  final Color snakeColor;


  const SnakePiece({Key key, this.position, this.piecesize, this.snakeColor})
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
              color: snakeColor,
              shape: BoxShape.circle
          ),
        )
    );
  }
}

