import 'package:flutter/material.dart';
import 'package:snake_game_f/shared.dart';

class GameOverScreen extends StatelessWidget {
  final Function(GameState) onChangeGameState;

  const GameOverScreen({Key key, this.onChangeGameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => onChangeGameState(GameState.startscreen),
      child: Container(
        color: Colors.white,
        child: Center(
          child: RichText(
            text: TextSpan(
              text: "Game Over! Tap to play again!",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}