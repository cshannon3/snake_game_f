import 'package:flutter/material.dart';
import 'package:snake_game_f/Components/animatedapplepiece.dart';
import 'package:snake_game_f/Components/snakepiece.dart';
import 'package:snake_game_f/Controllers/gamecontroller.dart';

class Game extends StatelessWidget {
  final GameController gameController;
  const Game({this.gameController});

  @override
  Widget build(BuildContext context) {
    final double _piecesize = gameController.piecesize;
    List<SnakePiece> snakePieces = [];
    gameController.snakes.forEach((_snake) {
      if (_snake.isAlive) {
        _snake.snakelocations.forEach((_point) {
          snakePieces.add(SnakePiece(
            position: _point,
            piecesize: _piecesize,
            snakeColor: _snake.snakeColor,
          ));
        });
      }
    });
    return Container(
      color: Colors.white,
      child: Stack(
          children: <Widget>[
        AnimatedApple(
          apple: gameController.apple,
          //  position: gameController.applePosition,
          piecesize: gameController.piecesize,
          secondsBeforeDissapears: gameController.secondsBeforeAppleDissapears,
          // appleColor: gameController.appleColor,
        )
      ]..addAll(snakePieces)),
    );
  }
}
